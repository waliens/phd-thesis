import re
import os
from bisect import bisect
from argparse import ArgumentParser

BEGIN_PATTERN = re.compile(r"(?:\\begin[ ]?(?:\[[^\[\]]*])?[ ]?{([^{}]+)}(?:{[^\[\]]*})*|\$\$|\\\[)", re.IGNORECASE)
END_PATTERN = re.compile(r"(?:\\end[ ]?{([^{}]+)}|\\])", re.IGNORECASE)


def command_length(s):
	if re.match(r"^\\[}{]", s) is not None:
		return 2  # escape
	# scan name
	length = 0
	name_match = re.match(r"\\[^\s{\\]+", s)
	if name_match is None:
		raise ValueError("Invalid command")
	cmd_name = name_match.group(0)
	length += len(cmd_name)

	bparam_match = re.match(r"^\s*{", s[length:])
	if bparam_match is None:
		return length
	length += bparam_match.regs[0][1]

	cnt, curr = 1, 0

	while cnt > 0 and curr + length < len(s):
		if s[curr + length] == "{":
			cnt += 1
		elif s[curr + length] == "}":
			cnt -= 1
			if curr + length + 1 < len(s) and s[curr + length + 1] == "{":
				cnt += 1
				curr += 1
		curr += 1

	length += curr
	return length


def scan_commands_and_inline_math(line):
	curr = 0
	items = list()
	while curr < len(line):
		char = line[curr]
		if char == "\\":
			if curr + 1 < len(line) and line[curr + 1] == "\\":
				curr += 2
			else:
				le = command_length(line[curr:])
				items.append((curr, curr + le))
				curr += le
		elif char == "$":
			if curr + 1 < len(line) and line[curr + 1] == "$":
				curr += 2
			else:
				j = curr + 1
				while j < len(line) and line[j] != "$":
					j += 1
				items.append((curr, j + 1))
				curr = j + 1
		else:
			curr += 1
	return items


def scan_envs(line: str, env_stack: list):
	ms_start_env = [m for m in re.finditer(BEGIN_PATTERN, line)]
	ms_end_env = [m for m in re.finditer(END_PATTERN, line)]
	b, e = 0, 0
	start_seq, end_seq = list(), list()

	if len(env_stack) == 0:
		start_seq.append(0)

	while b < len(ms_start_env) or e < len(ms_end_env):
		if b >= len(ms_start_env):
			pop, match = True, ms_end_env[e]
			e += 1
		elif e >= len(ms_end_env):
			pop, match = False, ms_start_env[b]
			b += 1
		else:
			mb, me = ms_start_env[b], ms_end_env[e]
			if mb.regs[0][0] <= me.regs[0][0]:
				pop, match = False, mb
				b += 1
			else:
				pop, match = True, me
				e += 1

		if match.group(0) == "$$" and len(env_stack) > 0 and env_stack[-1] == "$$":
			value = "$$"
			pop = True
		elif len(match.groups()) == 1 and match.groups()[0] is None:
			value = match.group(0)
			if value == "\\]":
				value = "\\["
		else:
			value = match.group(1)

		curr_first_index, curr_last_index = match.regs[0]
		if pop:
			if len(env_stack) == 0 or env_stack[-1] != value:
				raise ValueError("Invalid stack state: {} pop? {}".format(env_stack, ms_end_env[e]))
			env_stack.pop()
			if len(env_stack) == 0:
				start_seq.append(curr_last_index)
		else:
			if len(env_stack) == 0:
				end_seq.append(curr_first_index)
			env_stack.append(value)

	if len(env_stack) == 0:
		end_seq.append(len(line))

	return list([(s, e) for s, e in zip(start_seq, end_seq) if e - s > 0])


def merge_lines(lines):
	out_lines = list()
	start_group, i = 0, 0
	env_stack = list()
	while i < len(lines):
		line = lines[i].rstrip()
		sequences = scan_envs(line, env_stack)
		scanned = scan_commands_and_inline_math(line.strip())

		if len(line) == 0:
			if start_group != i:
				out_lines.append(re.sub(r"\s+", " ", " ".join([s.strip() for s in lines[start_group:i]])))
			out_lines.append("")
			start_group = i + 1
		elif re.match(r"^\s+%", line) is not None or len(sequences) == 0 or (len(scanned) == 1 and (scanned[0][1] - scanned[0][0]) == len(line.rstrip())):
			if start_group != i:
				out_lines.append(re.sub(r"\s+", " ", " ".join([s.strip() for s in lines[start_group:i]])))
				start_group = i

			out_lines.append(line)
			start_group += 1

		i += 1

	if start_group != len(lines):
		out_lines.append(re.sub(r"\s+", " ", " ".join([s.strip() for s in lines[start_group:]])))

	return out_lines


def find_best_split(s, index):
	# check for command in the line first
	scanned = scan_commands_and_inline_math(s)
	command_at_split = [(start, end) for (start, end) in scanned if start <= index < end]
	left_right = [index - 1, index + 1]
	invalid_split_characters_pattern = re.compile(r"[^\s]")
	if len(command_at_split) > 0:
		assert len(command_at_split) == 1
		start, end = command_at_split[0]
		left_right[0] = start - 1
		left_right[1] = end
	else:
		if invalid_split_characters_pattern.match(s[index]) is None:
			return index  # ...:index] / [index:...

	while left_right[1] < len(s) or left_right[0] > 0:
		if (left_right[0] > 0 and abs(left_right[1] - index) >= abs(left_right[0] - index)) or left_right[1] >= len(s):
			# left
			which = 0
		else:
			# right
			which = 1
		match = invalid_split_characters_pattern.match(s[left_right[which]])
		if match is None:
			return left_right[which]
		left_right[which] += -1 if which == 0 else 1

	return len(s)


def split_line(line, width=80):
	if len(line) == 0:
		return [""]

	out_lines = list()
	remaining = line.strip()
	while len(remaining.strip()) > width:
		remaining = remaining.strip()
		split_point = find_best_split(remaining, width)
		if split_point != len(remaining):
			out_lines.append(remaining[:split_point])
			remaining = remaining[split_point:]
		else:
			out_lines.append(remaining)
			remaining = ""

	if len(remaining) > 0:
		out_lines.append(remaining)

	return [o.strip() for o in out_lines]


def split_lines(lines, width=80):
	out_lines = list()
	env_stack = list()
	for i, line in enumerate(lines):
		print("\rsplit: {:3.2f}% (l: {})".format(100 * (i + 1) / len(lines), i + 1), end="", flush=True)

		sequences = scan_envs(line, env_stack)
		if not line.strip().startswith("%") and len(sequences) == 1 and (sequences[0][1] - sequences[0][0]) == len(line):
			out_lines.extend(split_line(line, width=width))
		else:
			out_lines.append(line)
	print()
	return out_lines


def warp_text_file(filepath, width=80, out_filepath="test.txt"):
	if not os.path.exists(filepath) or not os.path.isfile(filepath):
		raise FileNotFoundError("file '{}' does not exist".format(filepath))

	env_stack = list()

	with open(filepath, "r") as file:
		lines = file.readlines()
		out_merged = merge_lines(lines)
		out_split = split_lines(out_merged, width=width)

	with open(out_filepath, "w+", encoding="utf8") as file:
		file.writelines([o + "\n" for o in out_split])


if __name__ == "__main__":
	import sys
	parser = ArgumentParser()
	parser.add_argument("-i", "--input", dest="input", required=True)
	parser.add_argument("-o", "--output", dest="output", required=True)
	args, _ = parser.parse_known_args(sys.argv[1:])
	print("in  file: {}".format(args.input))
	print("out file: {}".format(args.output))
	warp_text_file(args.input, out_filepath=args.output)