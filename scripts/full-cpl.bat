@ECHO OFF
SETLOCAL EnableDelayedExpansion

IF "%1"=="chap" (
	SET CHAPNAME=error
	:: intro
	IF "%2"=="intro" (SET CHAPNAME=intro)
	IF "%2"=="1" (SET CHAPNAME=intro)
	:: back ml
	IF "%2"=="backml" (SET CHAPNAME=back_ml)
	IF "%2"=="2" (SET CHAPNAME=back_ml)
	:: back dp
	IF "%2"=="back_dp" (SET CHAPNAME=back_dp)
	IF "%2"=="3" (SET CHAPNAME=back_dp)
	:: comparison
	IF "%2"=="comp" (SET CHAPNAME=comp)
	IF "%2"=="4" (SET CHAPNAME=comp)
	:: mtask
	IF "%2"=="mtask" (SET CHAPNAME=mtask)
	IF "%2"=="5" (SET CHAPNAME=mtask)
	:: self distil
	IF "%2"=="sdist" (SET CHAPNAME=sdist)
	IF "%2"=="6" (SET CHAPNAME=sdist)
	:: biaflows
	IF "%2"=="biaflows" (SET CHAPNAME=biaflows)
	IF "%2"=="7" (SET CHAPNAME=biaflows)
	:: appendix
	IF "%2"=="appendix" (SET CHAPNAME=appendix)
	IF "%2"=="8" (SET CHAPNAME=appendix)
	IF "!CHAPNAME!"=="error" (
		echo -- Invalid chapter name --
		echo -- Abort...
		exit
	)
	echo -- Compile only chapter 'chap!CHAPNAME!'
	docker run --volume="%cd%":"/data" -t thtex latexmk -cd -f -interaction=batchmode -pdf root.tex 
) ELSE (
	echo -- Compile full thesis
	docker run --volume="%cd%":"/data" -t thtex latexmk -cd -f -interaction=batchmode -pdf root.tex 
)

SET ERRORLEVEL_COMPIL=!ERRORLEVEL!

IF !ERRORLEVEL_COMPIL!==0 (
  echo -- Compilation went OK. 
  echo -- Cleaning...
  docker run --volume="%cd%":"/data" -t thtex latexmk -c
)
