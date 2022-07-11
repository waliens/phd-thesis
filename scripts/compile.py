import re
import os
import random
import shutil
import string
import subprocess
from argparse import ArgumentParser
from tempfile import NamedTemporaryFile


CHAPTERS = ["intro", "backml", "backdp", "comp", "mtask", "strain", "biaflows", "appendix_comp", "appendix_mtask", "appendix_strain"]


def is_int(v):
    return re.match("[0-9]+", v) is not None


def random_string(n):
    return "".join([random.choice(string.ascii_letters) for _ in range(n)])


def make_target(include, draft=False):
    with open("root.tex", "r", encoding="utf8") as root_file:
        tex = root_file.read()
        replace_str = "\\begin{document}\\input{" + include + "}\\end{document}"
        if draft:
            replace_str = "\PassOptionsToPackage{draft}{graphicx}" + os.linesep + replace_str
        tex = tex.replace("\\begin{document}\\end{document}", replace_str)
        tmp_target_filename = "{}_target.tex".format(os.path.basename(include).rsplit(".", 1)[0])
        with open(tmp_target_filename, "w+", encoding="utf8") as tmp_target:
            tmp_target.write(tex)
        return tmp_target_filename


def latexmk_cline(name, target, gg=False):
    cmd = ["latexmk", "-cd", "-f", "-interaction=batchmode", "-jobname={}".format(name), "-pdf", target, "-norc", "-r", "./.latexmkrc", "-outdir=."]
    if gg:
        cmd.insert(3, "-gg")
    return cmd

def latexmk_clean():
    return ["latexmk", "-c"]


def grep(filename, regex):
    with open(filename, "r", encoding="utf8") as file:
        line = "a"
        matching_lines = list()
        while len(line) > 0:
            try:
                line = file.readline()
                if re.match(regex, line) is not None:                
                    matching_lines.append(line.strip())
            except UnicodeError:
                pass
        return matching_lines


def compile(argv):
    parser = ArgumentParser()
    parser.add_argument("chap", nargs="?", default=None)
    parser.add_argument("-c", "--clean", action="store_true", dest="clean")
    parser.add_argument("-d", "--draft", action="store_true", dest="draft")
    parser.add_argument("-gg", action="store_true", dest="gg")

    parser.set_defaults(clean=False, gg=False, draft=False)
    args, others = parser.parse_known_args(argv)

    if args.chap is None:
        print("-- Compile full thesis")
        target_file = "full.tex"
        jobname = "thesis_full"
    else:
        if not (is_int(args.chap) or args.chap in set(CHAPTERS)):
            raise ValueError("-- Invalid chapter reference '{}'".format(args.chap))
        chapt_folder = os.path.join(os.getcwd(), "chapters")
        matches = [fname for fname in os.listdir(chapt_folder) if str(args.chap) in fname and fname.endswith(".tex")]
        if len(matches) > 1:
            print("-- Several matches for chapter query '{}' -> {}".format(args.chap, matches), file=sys.stderr)
            sorted_idx = sorted(range(len(matches)), key=(lambda i: 1 - (len(args.chap) / len(matches[i]))))
            matches = [matches[sorted_idx[0]]]
            print("--  pick best match: {}".format(matches[0]), file=sys.stderr)
        elif len(matches) == 0:
            raise ValueError("no match for chapter query '{}'".format(args.chap))

        target_file = os.path.join("chapters", matches[0])
        chap_name = os.path.basename(target_file).rsplit(".", 1)[0]
        print("-- Compile chapter {}".format(chap_name))
        jobname = "thesis_{}".format(chap_name)

    target_fname = make_target(target_file, draft=args.draft) 

    try:
        proc = subprocess.run(latexmk_cline(name=jobname, target=target_fname, gg=args.gg))

        if proc.returncode != 0:
            print("==== ERROR SUMMARY ====")
            for error in grep("{}.log".format(jobname), re.compile(r"^! ")):
                print(error)
            print("=======================")

        if proc.returncode == 0 and args.clean:
            print("-- Clean up... ", end="")
            clean_proc = subprocess.run(latexmk_clean())
            if clean_proc.returncode == 0:
                print("success")
            else:
                print()
        return proc.returncode
    finally:
        os.remove(target_fname)


if __name__ == "__main__":
    import sys
    exit(compile(sys.argv[1:]))

