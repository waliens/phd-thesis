
\NeedsTeXFormat{LaTeX2e}[2017-04-15]
\newcommand{\classname}{mormontThesis}
\providecommand{\baseclass}{book}
\RequirePackage{etoolbox}
\RequirePackage{xparse}

\ProcessOptions\relax

\LoadClass{\baseclass}

%----------------------------------------------------------------------------------------
%	REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage{babel} % Required for automatically changing names of document 
%elements to languages besides english

\RequirePackage{scrbase} % Required for handling language-dependent names of 
%sections/document elements

\RequirePackage{scrhack} % Loads fixes for various packages

\RequirePackage{graphicx} % Required to include images
\graphicspath{{icons/}{figures/}{./}{images/}} % Specifies where to look for included images