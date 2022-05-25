# phd-thesis


## How to compile ?

Compilation can be done with a docker container.

```
docker pull rmormont/thesis-tex-compile:1.0
```

Run the compile script:

```
cd ../tex
sh ../scripts/cpl.sh
```

In order to compile a chapter independently, you can provide additional argument to the compile line.
The parameters should be either the chapter number or the chapter short name:

- `intro`: introduction
- `backml`: background ML
- `backdp`: background digital pathology
- `comp`: comparison 
- `mtask`: multi-task
- `strain`: self-training
- `biaflows`: software contributions
- `appendix`: appendix
