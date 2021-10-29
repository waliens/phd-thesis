
\NeedsTeXFormat{LaTeX2e}[2021-09-20]
\newcommand{\classname}{mormontThesis}
\providecommand{\baseclass}{book}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\newbool{nolistspace}
\newbool{chapteroneline}
\newbool{listtoc}
\newbool{toctoc}
\newbool{parskip}
\newbool{hyperrefsupport}
\booltrue{hyperrefsupport}
\newbool{headsepline}
\booltrue{headsepline}
\newbool{consistentlayout}
\booltrue{consistentlayout}
%\newbool{chaptergraybg}

\DeclareOption{nohyperref}{\boolfalse{hyperrefsupport}}
\DeclareOption{nolistspacing}{\booltrue{nolistspace}}
\DeclareOption{liststotoc}{\booltrue{listtoc}}
\DeclareOption{chapterinoneline}{\booltrue{chapteroneline}}
\DeclareOption{toctotoc}{\booltrue{toctoc}}
\DeclareOption{parskip}{\booltrue{parskip}}
\DeclareOption{headsepline}{\booltrue{headsepline}}
\DeclareOption{consistentlayout}{\booltrue{consistentlayout}}
%\DeclareOption{chaptergraybg}{\booltrue{chaptergraybg}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}}

\ProcessOptions\relax

\LoadClass{\baseclass}







% Addchap provides unnumbered chapters with an entry in the table of contents 
%as well as an updated header
\ProvideDocumentCommand{\addchap}{ s o m }{%
  \chapter*{#3}%
  \markboth{}{}%
  \IfBooleanTF{#1}{%
  }{%
    \IfNoValueTF{#2}{%
      \addchaptertocentry{#3}%
      \markboth{\MakeMarkcase{#3}}{\MakeMarkcase{#3}}%
    }{%
      \addchaptertocentry{#2}%
      \markboth{\MakeMarkcase{#2}}{\MakeMarkcase{#2}}%
    }%
  }%
}%

\ProvideDocumentCommand{\addsec}{ s o m }{%
  \section*{#3}%
  \markright{}%
  \IfBooleanTF{#1}{%
  }{%
    \IfNoValueTF{#2}{%
      \addcontentsline{toc}{section}{#3}%
      \markright{\MakeMarkcase{#3}}%%
    }{%
      \addcontentsline{toc}{section}{#2}%
      \markright{\MakeMarkcase{#2}}%
    }%
  }%
}%

%----------------------------------------------------------------------------------------
% CLASS OPTIONS
%----------------------------------------------------------------------------------------

\ifbool{parskip}{\RequirePackage{parskip}} % If the parskip option is passed to 
%the class, require the parskip package 


\ifbool{listtoc}{% If the liststotoc option has been passed to the class, add 
%the lists to the table of contents
  \patchcmd{\listoftables}{\@starttoc{lot}}{%
    \addchaptertocentry{\listtablename}\@starttoc{lot}%
  }{}{}%
  \patchcmd{\listoffigures}{\@starttoc{lof}}{%
    \addchaptertocentry{\listfigurename}\@starttoc{lof}%
  }{}{}%
}

\ifbool{toctoc}{% If the toctotoc options has been passed to the class, add the 
%table of contents to the table of contents
  \patchcmd{\tableofcontents}{\@starttoc{toc}%
}{%
  \addchaptertocentry{\contentsname}\@starttoc{toc}}{}{}%
}

\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}

% If the option `nolistspacing' is given, the spacing in the different lists is 
%reduced to single spacing. This option is only useful, if the spacing of the 
%document has been changed to onehalfspacing or doublespacing.
\ifbool{nolistspace}{
  \patchcmd{\listoffigures}{%
    \@starttoc{lof}
  }{%
    \begingroup%
    \singlespace\@starttoc{lof}\endgroup%
  }{}{}%
  \patchcmd{\listoftables}{%
    \@starttoc{lot}
  }{%
    \begingroup%
    \singlespace\@starttoc{lot}\endgroup%
  }{}{}%
  \patchcmd{\tableofcontents}{%
    \@starttoc{toc}
  }{%
    \begingroup%
    \singlespace\@starttoc{toc}\endgroup%
  }{}{}%
}{}


%----------------------------------------------------------------------------------------
% REQUIRED PACKAGES
%----------------------------------------------------------------------------------------

\RequirePackage{babel} % Required for automatically changing names of document 
%elements to languages besides english

\RequirePackage{scrbase} % Required for handling language-dependent names of 
%sections/document elements

\RequirePackage{scrhack} % Loads fixes for various packages

\RequirePackage{setspace} % Required for changing line spacing

\RequirePackage{longtable} % Required for tables that span multiple pages (used 
%in the symbols, abbreviations and physical constants pages)
\RequirePackage{colortbl} % for cellcolor
\RequirePackage{siunitx} % Required for \SI commands

\RequirePackage{graphicx} % Required to include images
\graphicspath{{icons/}{figures/}{./}{images/}} % Specifies where to look for included images

\RequirePackage{booktabs} % Required for better table rules

\RequirePackage{amsthm}
\RequirePackage{amssymb}

%\RequirePackage{eufrak}

\usepackage[ruled,vlined,linesnumbered]{algorithm2e}

\RequirePackage{caption} % Required for customising the captions
\captionsetup{justification=centerlast,font=small,labelfont=sc,margin=50pt}
\usepackage[acronym,nomain]{glossaries}
\usepackage{tocloft}
\setcounter{secnumdepth}{3}
\renewcommand{\cftpartleader}{\cftdotfill{\cftdotsep}} % for parts
\renewcommand{\cftpartfont}{\color{secondary}\normalsize\bf}
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % for chapters
\renewcommand{\@cftmaketoctitle}{}

\RequirePackage{xcolor}
\RequirePackage[many]{tcolorbox}
\RequirePackage{placeins}
\RequirePackage{multirow}
\RequirePackage{varwidth}
\RequirePackage[export]{adjustbox}
\RequirePackage{pdflscape}



%\RequirePackage{tikz}
\usetikzlibrary{matrix,chains,positioning,decorations.pathreplacing,arrows}

%----------------------------------------------------------------------------------------
% DEFINE CUSTOM THESIS INFORMATION COMMANDS
%----------------------------------------------------------------------------------------

\NewDocumentCommand{\thesistitle} { o m }{%
 \IfValueTF{#1}{\def\shorttitle{#1}}{\def\shorttitle{#2}}%
 \def\@title{#2}%
 \def\ttitle{#2}%
}
\DeclareDocumentCommand{\author}{m}{\newcommand{\authorname}{#1}\renewcommand{\@author}{#1}}
\NewDocumentCommand{\supervisor}{m}{\newcommand{\supname}{#1}}
\NewDocumentCommand{\examiner}{m}{\newcommand{\examname}{#1}}
\NewDocumentCommand{\degree}{m}{\newcommand{\degreename}{#1}}
\NewDocumentCommand{\addresses}{m}{\newcommand{\addressname}{#1}}
\NewDocumentCommand{\university}{m}{\newcommand{\univname}{#1}}
\NewDocumentCommand{\department}{m}{\newcommand{\deptname}{#1}}
\NewDocumentCommand{\group}{m}{\newcommand{\groupname}{#1}}
\NewDocumentCommand{\faculty}{m}{\newcommand{\facname}{#1}}
\NewDocumentCommand{\subject}{m}{\newcommand{\subjectname}{#1}}
\NewDocumentCommand{\keywords}{m}{\newcommand{\keywordnames}{#1}}

\newcommand{\checktoopen}{% New command to move content to the next page which 
%prints to the next odd page if twosided mode is active  
  \if@openright\cleardoublepage\else\clearpage\fi
  \ifdef{\phantomsection}{\phantomsection}{}% The \phantomsection command is 
  %necessary for hyperref to jump to the correct page
}

\NewDocumentCommand{\bhrule}{}{\typeout{--------------------}}
\NewDocumentCommand{\tttypeout}{m}{\bhrule\typeout{\space #1}\bhrule}

\newcommand{\HRule}{\rule{.9\linewidth}{.6pt}} % New command to make the lines 
%in the title page
\newcommand{\decoRule}{\rule{.8\textwidth}{.4pt}} % New command for a rule to 
%be used under figures

\setcounter{tocdepth}{3} % The depth to which the document sections are printed 
%to the table of contents
\ProvideDocumentCommand{\addchaptertocentry}{ m }{%
  \addcontentsline{toc}{chapter}{#1}%
}


%----------------------------------------------------------------------------------------
% COLORS
%----------------------------------------------------------------------------------------

% color palette
\definecolor{primary}{RGB}{0,91,144}
\colorlet{primary-lgt}{primary!50!white}
\colorlet{primary-drk}{primary!50!black}
\definecolor{secondary}{RGB}{176,43,59} 
\colorlet{secondary-lgt}{secondary!50!white}
\colorlet{secondary-drk}{secondary!50!black}
\definecolor{ternary}{RGB}{131,154,40}
\colorlet{ternary-lgt}{ternary!50!white}
\colorlet{ternary-drk}{ternary!50!black}

\definecolor{Dandelion}{HTML}{FDBB43}
\definecolor{LimeGreen}{HTML}{8BC63E}

\definecolor{dodgerblue}{rgb}{0.12, 0.56, 1.0}
\definecolor{forestgreen}{rgb}{0.13, 0.55, 0.13}
\definecolor{light-gray}{gray}{0.95}
\definecolor{lightgray}{gray}{0.95}
\definecolor{lightlightgray}{gray}{0.99}
\definecolor{less-light-gray}{gray}{0.9}
\definecolor{deepgreen}{HTML}{0AF191}
\definecolor{purplish}{HTML}{E21173}



%----------------------------------------------------------------------------------------
% PART STYLE
%----------------------------------------------------------------------------------------
\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{\thepart\hspace{1em}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{}{}%
  {
    \thispagestyle{\part@p@gestyle}
    \centering
    \interlinepenalty \@M
    \normalfont
    \ifnum \c@secnumdepth >-2\relax
      {\color{secondary}
      \huge\sffamily\mdseries \partname\nobreakspace\thepart}
      \par
    \fi
    \par \vspace{20pt}
    \begin{center} \color{black} \Huge \rmfamily\bfseries #2 \normalfont \end{center}
  }%
\@endpart}

%----------------------------------------------------------------------------------------
% CHAPTER STYLE
%----------------------------------------------------------------------------------------


%\colorlet{chap-bg}{white}
%\colorlet{chap-bg}{black!10} % light gray


% Simple interface for the user  to customize the chapter titles 
\ProvideDocumentCommand{\abovechapterskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\chapterbelowskip}{}{\vspace*{50pt}}
\ProvideDocumentCommand{\chapterinbetweenskip}{}{\vspace*{5pt}}
\ProvideDocumentCommand{\autodot}{}{}
\ProvideDocumentCommand{\mdtChapapp}{}{}
\ProvideDocumentCommand{\chapteralign}{}{\raggedright}
\ProvideDocumentCommand{\chapterfont}{}{\Huge\rmfamily\bfseries}
\ProvideDocumentCommand{\chapterprefixfont}{}{\large\sffamily\mdseries}
\DeclareDocumentCommand{\@makechapterhead}{ m }{
  \abovechapterskip
  {\parindent \z@ \chapteralign \normalfont
    \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
\begin{minipage}{.15\textwidth}
    {\color{secondary}\scalebox{6}{\thechapter}}
\end{minipage}% This must go next to `\end{minipage}`
\begin{minipage}{.85\textwidth}
    \centering
    \chapterprefixfont  \@chapapp \space \par\nobreak %\vspace{-2em}
    \rule[2em]{\linewidth}{.5pt}
    \par\nobreak \vspace{-2em}
  \interlinepenalty\@M
  \chapterfont #1
\end{minipage}
      \fi
    \fi

  \chapterbelowskip
  }
  \thispagestyle{\chapter@p@gestyle}
}
\def\@makeschapterhead#1{
  \abovechapterskip
  {\parindent \z@ \chapteralign
  \begin{minipage}{\linewidth}
  \centering
  \chapterfont #1
  \chapterinbetweenskip
  \interlinepenalty\@M
  \par\nobreak
  \rule[2em]{\linewidth}{.5pt}
  \end{minipage}
  }
}


%----------------------------------------------------------------------------------------
% FOREWORD
%----------------------------------------------------------------------------------------
% https://texdoc.org/serve/tcolorbox.pdf/0
% #1: tcolorbox options
% #2: Box title
\newtcolorbox{overview}[2][]
{
  colframe = primary,
  colback  = primary-lgt!50!white,
  coltitle = white,
  colbacktitle = primary,
  title    = {#2},
  fonttitle = \sffamily,
  enhanced,
 % attach boxed title to top right,
 %frame style={top color=dodgerblue, bottom color=orange, middle color=white},
  leftrule = 0.5mm,
  rightrule = 0.5mm,
  bottomrule = 0.5mm,
  toprule=0mm,
  arc = 1mm,
  after skip=20pt plus 2pt,
  {#1},
}

\newcommand{\iconPublication}{\includegraphics[width=.75cm]{quill}}
\newcommand{\iconAbout}{\includegraphics[width=.75cm]{about}}
\newcommand{\iconOutline}{\includegraphics[width=.75cm]{outline}}
\newcommand{\iconGit}{\includegraphics[width=.75cm]{github}}
\newcommand{\iconNew}{\includegraphics[width=.75cm]{unread}}


%----------------------------------------------------------------------------------------
% NUMBERING
%----------------------------------------------------------------------------------------
%\numberwithin{theorem}{chapter}
%\numberwithin{property}{chapter}
%\numberwithin{example}{chapter}
%\numberwithin{definition}{chapter}
%\numberwithin{algorithm}{chapter}
%\numberwithin{figure}{chapter}
%\numberwithin{table}{chapter}


%----------------------------------------------------------------------------------------
% MARGINS
%----------------------------------------------------------------------------------------

\RequirePackage{geometry}
\geometry{
%  showframe,
  headheight=4ex,
  bottom=1.5cm,
  inner=3.2cm,
  outer=2.5cm
%  includehead,
%  includefoot
}

\raggedbottom

%----------------------------------------------------------------------------------------
% PENALTIES
%----------------------------------------------------------------------------------------

\doublehyphendemerits=10000 % No consecutive line hyphens
\brokenpenalty=10000 % No broken words across columns/pages
\widowpenalty=9999 % Almost no widows at bottom of page
\clubpenalty=9999 % Almost no orphans at top of page
\interfootnotelinepenalty=9999 % Almost never break footnotes

%----------------------------------------------------------------------------------------
% HEADERS AND FOOTERS
%----------------------------------------------------------------------------------------

\RequirePackage[markcase=noupper]{scrlayer-scrpage}

\ifoot{}% Inner footer
\ofoot{}% Outer footer


\ifbool{headsepline}{\KOMAoption{headsepline}{true}}{}
\PreventPackageFromLoading[\ClassError{\classname}{Package `fancyhdr' is
incompatible\MessageBreak with this class}{The pagesyles are defined 
  using package `scrlayer-scrpage', please consult the\MessageBreak 
KOMA-script documentation for details.}]{fancyhdr}


\newcommand{\blank@p@gestyle}{empty}
\newcommand{\chapter@p@gestyle}{empty}
\newcommand{\part@p@gestyle}{empty}

\NewDocumentCommand{\blankpagestyle}{ m }{%
  \ClassWarning{\classname}{\string\blankpagestyle\space is
  obsolete,\MessageBreak use \string\setblankpagestyle \space  
  instead}\renewcommand{\blank@p@gestyle}{}{#1}
}
\NewDocumentCommand{\setblankpagestyle}{ m 
}{\renewcommand{\blank@p@gestyle}{#1}}
\NewDocumentCommand{\setchapterpagestyle}{ m 
}{\renewcommand{\chapter@p@gestyle}{#1}}

\DeclareDocumentCommand\cleardoublepage{}{\clearpage\if@twoside 
\ifodd\c@page\else
  \hbox{}
  \thispagestyle{\blank@p@gestyle}
  \newpage
  \if@twocolumn\hbox{}\newpage\fi\fi\fi%
}


%----------------------------------------------------------------------------------------
% ABSTRACT PAGE DESIGN
%----------------------------------------------------------------------------------------

\DeclareDocumentCommand{\abstractauthorfont}{}{}
\DeclareDocumentCommand{\abstracttitlefont}{}{}
\newcommand{\byname}{by}
\newcommand{\abstractname}{Abstract}
\providecaptionname{german,ngerman,austrian,naustrian}{\byname}{von}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\byname}{by}
\ifbool{consistentlayout}{
  \DeclareDocumentEnvironment{abstract}{ O{} }{%
    \addchap*{\abstractname}%
    {\chapteralign\normalsize\abstractauthorfont \authorname \par}% Author 
    %name
    \vspace{\baselineskip}
    {\chapteralign\parbox{.7\linewidth}{\chapteralign\normalsize\itshape\abstracttitlefont\@title}\par}%
    % Thesis title
    \bigskip\noindent\ignorespaces
  }%
  {}%end alt-abstract
}{%
  \DeclareDocumentEnvironment{abstract}{ O{\null\vfill} }{
    \checktoopen
    \tttypeout{\abstractname}
    #1%added to be able to have abstract more than one page long
    \thispagestyle{plain}
    \begin{center}
      {\normalsize \MakeUppercase{\univname} \par}% University name in 
      %capitals
      \bigskip
      {\huge\textit{\abstractname} \par}
      \bigskip
      {\normalsize \facname \par}% Faculty name
      {\normalsize \deptname \par}% Department name
      \bigskip
      {\normalsize \degreename\par}% Degree name
      \bigskip
      {\normalsize\bfseries \@title \par}% Thesis title
      \medskip
      {\normalsize \byname{} \authorname \par}% Author name
      \bigskip
    \end{center}
  }
  {
    \vfill\null
  }
}

\DeclareDocumentEnvironment{extraAbstract}{ O{\null\vfill} }{
  \checktoopen
  \tttypeout{\abstractname}
  #1%added to be able to have abstract more than one page long
  \thispagestyle{empty}
  \begin{center}
    {\normalsize \MakeUppercase{\univname} \par}% University name in 
    %capitals
    \bigskip
    {\huge\textit{\abstractname} \par}
    \bigskip
    {\normalsize \facname \par}% Faculty name
    {\normalsize \deptname \par}% Department name
    \bigskip
    {\normalsize \degreename\par}% Degree name
    \bigskip
    {\normalsize\bfseries \@title \par}% Thesis title
    \medskip
    {\normalsize \byname{} \authorname \par}% Author name
    \bigskip
  \end{center}
}
{
  \vfill\null
}

%----------------------------------------------------------------------------------------
% ACKNOWLEDGEMENTS PAGE DESIGN
%----------------------------------------------------------------------------------------

\usepackage{xcolor}
\colorlet{mdtRed}{red!50!black}

\newcommand{\acknowledgementname}{Acknowledgements}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}
 {\acknowledgementname}{Acknowledgements} % Acknowledgement text for English 
%countries
\providecaptionname{german,ngerman,austrian,naustrian}{\acknowledgementname}{Danksagung}
 % Acknowledgement text for Germanic countries

\ifbool{consistentlayout}{
  \DeclareDocumentEnvironment{acknowledgements}{}{%
    \tttypeout{\acknowledgementname}
    \addchap*{\acknowledgementname}
  }
}
{
  \DeclareDocumentEnvironment{acknowledgements}{}{%
    \checktoopen
    \tttypeout{\acknowledgementname}
    \thispagestyle{plain}
    \begin{center}{\huge\textit{\acknowledgementname}\par}\end{center}
  }
  {
    \vfil\vfil\null
  }
}

%----------------------------------------------------------------------------------------
% DECLARATION PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\authorshipname}{Declaration of Authorship}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\authorshipname}{Declaration
 of Authorship} % Declaration of Authorship text for English countries
\providecaptionname{german,ngerman,austrian,naustrian}{\authorshipname}{Eidesstattliche
 Erkl\"arung} % Declaration of Authorship text for Germanic countries

\ifbool{consistentlayout}{
  \DeclareDocumentEnvironment{declaration}{}{
    \addchap*{\authorshipname}
    }{}%
}{
  \DeclareDocumentEnvironment{declaration}{}{
    \checktoopen
    \tttypeout{\authorshipname}
    \thispagestyle{plain}
    \null\vfil
    {\noindent\huge\bfseries\authorshipname\par\vspace{10pt}}
  }{}
}

%----------------------------------------------------------------------------------------
% DEDICATION PAGE DESIGN
%----------------------------------------------------------------------------------------

\ifbool{consistentlayout}{
  \DeclareDocumentCommand{\dedicatory}{
    m O{\vspace*{.7\textheight} }  }{
      \checktoopen\tttypeout{Dedicatory}
      \markboth{}{}
      #2
      {\hfill\parbox{.4\textwidth}{\flushright#1\par}}
    }
}{
  \newcommand\dedicatory[1]{
    \checktoopen
    \tttypeout{Dedicatory}
    \null\vfil
    \thispagestyle{plain}
    \begin{center}{\Large\slshape #1}\end{center}
    \vfil\null
  }
}


%----------------------------------------------------------------------------------------
% PHYSICAL CONSTANTS PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\constantsname}{Physical Constants}
\providecaptionname{english,british,american}{\constantsname}{Physical 
Constants}
\providecaptionname{ngerman,german,austrian,naustrian}{\constantsname}{Physikalische
 Konstanten}

\NewDocumentEnvironment{constants}{ m }{%
  \ifbool{nolistspace}{\begingroup\singlespacing}{}
  \ifbool{listtoc}{\addchap{\constantsname}}{\addchap*{\constantsname}}
  \begin{longtable}{#1}
  }{%
  \end{longtable}
  \addtocounter{table}{-1}% Don't count this table as one of the document 
  %tables
  \ifbool{nolistspace}{\endgroup}{}
}

%----------------------------------------------------------------------------------------
% SYMBOLS PAGE DESIGN
%----------------------------------------------------------------------------------------

\newcommand{\symbolsname}{List of Symbols}
\providecaptionname{english,british,american}{\symbolsname}{List of Symbols}
\providecaptionname{ngerman,german,austrian,naustrian}{\symbolsname}{Symbolverzeichnis}

\NewDocumentEnvironment{symbols}{ m }{%
  \ifbool{nolistspace}{\begingroup\singlespacing}{}
  \ifbool{listtoc}{\addchap{\symbolsname}}{\addchap*{\symbolsname}}
  \begin{longtable}{#1}
  }{%
  \end{longtable}
  \addtocounter{table}{-1}% Don't count this table as one of the document 
  %tables
  \ifbool{nolistspace}{\endgroup}{}
}


%----------------------------------------------------------------------------------------
% NUMBERING
%----------------------------------------------------------------------------------------
\newtheorem{definition}{Definition}[section]
\newtheorem{proposition}{Proposition}[section]
\newtheorem{theorem}{Theorem}[section]
\newtheorem{corollary}{Corollary}[theorem]
\newtheorem{lemma}[theorem]{Lemma}


%----------------------------------------------------------------------------------------
% ALGORITHMS
%----------------------------------------------------------------------------------------
\newcommand{\algoCommentFormat}[1]{\footnotesize\ttfamily\textcolor{somber1}{#1}}
\SetCommentSty{algoCommentFormat}
\newcommand{\algoLineNumFormat}[1]{\textcolor{somber2}{#1}}
\SetNlSty{algoLineNumFormat}{}{}
\DontPrintSemicolon

\SetKwProg{Fn}{Function}{:}{}

%\definecolor{shadecolor}{gray}{0.95}
%\makeatletter
%\def\@algocf@pre@ruled{\begin{shaded}}%
%\def\@algocf@post@ruled{\end{shaded}\relax}%
%\makeatother

%----------------------------------------------------------------------------------------
% SUBFIGURES
%----------------------------------------------------------------------------------------
\RequirePackage{caption}
\RequirePackage{subfig}
\captionsetup[subfigure]{width=0.9\linewidth}
%\captionsetup[subfigure]{width=0.9\linewidth,justification=raggedright}
% Fix caption spacing https://tex.stackexchange.com/questions/372575/add-space-between-captions-not-between-the-images


%----------------------------------------------------------------------------------------

\ifbool{hyperrefsupport}{% If the nohyperref class option has not been specified
\AtEndPreamble{\RequirePackage{hyperref}
\hypersetup{pdfpagemode={UseOutlines},
bookmarksopen=true,
bookmarksopenlevel=0,
hypertexnames=false,
colorlinks=true,% Set to false to disable coloring links
citecolor=ternary,% The color of citations
linkcolor=primary,% The color of references to document elements (sections, %figures, etc)
urlcolor=primary,% The color of hyperlinks (URLs)
pdfstartview={FitV},
unicode,
breaklinks=true,
linktocpage=true,
}

\pdfstringdefDisableCommands{% If there is an explicit linebreak in a section 
%heading (or anything printed to the pdf-bookmarks), it is replaced by a space
  \let\\\space%
}
  }
}{%nothing
}

%----------------------------------------------------------------------------------------

\usepackage{titlesec}

\endinput
% lazyLizardTracer
