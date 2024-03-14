\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{outn}[2024/03/11 v2.4 (Robert Brignall, all rights reserved)]

\newif\if@tnandss
\@tnandssfalse
\newif\if@specsolns
\@specsolnsfalse

\DeclareOption{tn-and-ss}{%
    \@tnandsstrue
    \ifx\buildmode\undefined
      \immediate\write18{%
        pdflatex --jobname="\jobname"
        "\gdef\string\buildmode{1}\string\input\space\jobname"
      }%
      \immediate\write18{%
        pdflatex --jobname="\jobname-ss"
        "\gdef\string\buildmode{2}\string\input\space\jobname"
      }%
      \expandafter\stop
    \fi
    \ifnum\buildmode=1\relax\fi
    \ifnum\buildmode=2 \@specsolnstrue\fi
}

\DeclareOption{specsolns}{%
  \if@tnandss
    \relax
  \else
    \@specsolnstrue
  \fi
}

\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,10pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=5cm,marginparsep=0ex,nohead,asymmetric]{geometry}%
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{changepage}
\RequirePackage{array}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage[user,lastpage]{zref}
\RequirePackage{ifthen}
\RequirePackage[inline,shortlabels]{enumitem}
\RequirePackage{marginnote}
\RequirePackage{xcolor}
\RequirePackage{framed}
\RequirePackage{pgfkeys}
\RequirePackage{iftex}
\RequirePackage{environ}
\RequirePackage{verbatim}
\RequirePackage{caption}
  \captionsetup{justification=raggedright,format=plain,labelsep=quad,labelfont={normalsize,bf},singlelinecheck=false,font={normalsize,stretch=1.25}}
\if@specsolns
  \RequirePackage{caption}
  \captionsetup{justification=raggedright,format=plain,labelsep=quad,labelfont={normalsize,bf},singlelinecheck=false,font={normalsize,stretch=1.25,color=\@specsolnscolor}}
\fi


%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to set up module codes, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@faculty{Mathematics, Computing and Technology}
\newcommand\faculty[1]{\DeclareRobustCommand\@faculty{#1}}
%
\newcommand\modulecode[1]{\renewcommand\@modulecode{#1}}
\newcommand\@modulecode{\@latex@error{No \noexpand\modulecode specified}\@ehc}
%
\newcommand\moduletitle[1]{\renewcommand\@moduletitle{#1}}
\newcommand\@moduletitle{\@latex@error{No \noexpand\moduletitle specified}\@ehc}
%
\newcommand\tnyear[1]{\renewcommand\@tnyear{#1}}
\newcommand\@tnyear{\@latex@error{No \noexpand\tnyear specified}\@ehc}
%
% Optional copyrightyear:
\def\@copyrightyear{\@tnyear}
\newcommand\copyrightyear[1]{\def\@copyrightyear{#1}}
%
% Title of document:
% Can be handled by \tntitle[A]{B}
% Or \tntitle{B}\sstitle{A}
% \sstitle overrules optional \tntitle parameter
\newif\if@sstitle
\@sstitlefalse
\newcommand{\sstitle}[1]{%
  \@sstitletrue
  \if@specsolns%
    \renewcommand\@tntitle{#1}
  \else%
    \relax
  \fi%
}%
%
\newcommand\@tntitle{\@latex@error{No \noexpand\tntitle specified}\@ehc}
\newcommand{\tntitle}{\@dblarg\@settntitle}
\def\@settntitle[#1]#2{
  \if@specsolns%
    \if@sstitle\relax%
    \else\renewcommand\@tntitle{#1}\fi
  \else%
    \renewcommand\@tntitle{#2}
  \fi%
}
%
% title for tutor only environment
\newcommand\tutoronlytitle[1]{\renewcommand\@tutoronlytitle{#1}}
\newcommand\@tutoronlytitle{{\bfseries For tutors only:}\par}
% title for student only environment
\newcommand\studentonlytitle[1]{\renewcommand\@studentonlytitle{#1}}
\newcommand\@studentonlytitle{{\bfseries For students only:}\par}

\definecolor{ougreen}{RGB}{0,128,0}
\def\@specsolnscolor{ougreen}
\newcommand\specsolnscolor[1]{\def\@specsolnscolor{#1}}
\if@specsolns
  \AtBeginDocument{\color{\@specsolnscolor}}
  \captionsetup{justification=raggedright,format=plain,labelsep=quad,labelfont={normalsize,bf},singlelinecheck=false,font={normalsize,stretch=1.25,color=\@specsolnscolor}}
\fi
%
\def\@oulogofilebase{OU_Master_LOGO_BLACK_17-5mmForA4width}
\newcommand\oulogofilebase[1]{\renewcommand\@oulogofilebase{#1}}
%
\newif\if@switchmarks
\@switchmarksfalse
\newcommand\switchmarks{\@switchmarkstrue}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meta data can be set using \metadataset command, based on pgfkeys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pgfkeys{
 /meta data/.is family, /meta data,
   faculty/.store in=\@faculty,
   module code/.store in =\@modulecode,
   module title/.store in=\@moduletitle,
   document title/.store in=\@tntitle,
   presentation/.store in=\@tnyear,
   copyright year/.store in=\@copyrightyear,
   specimen solutions color/.store in=\@specsolnscolor,
   multiple choice option text/.store in=\@optiontext,
   tutor only title/.store in=\@tutoronlytitle,
   student only title/.store in=\@studentonlytitle,
   ou logo file base/.store in=\@oulogofilebase,
   switch marks/.is if=@switchmarks,
}
\newcommand{\metadataset}[1]{%
    \pgfkeys{/meta data,#1}%
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footers for title page (copyright, etc)
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
    \fancyfoot[L]{%
    	\if@specsolns\color{\@specsolnscolor}\fi
    	\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}%
	}%
}
\renewcommand{\maketitle}{
%% First, set up PDF metadata
 \pdfinfo{
   /Author (The Open University)
   /Title  (\@modulecode\ \@tntitle\ \@tnyear)
}%
% Logo preamble:
\ifpdf%
  \def\@oulogofile{\@oulogofilebase.pdf}
\else%
  \def\@oulogofile{\@oulogofilebase.eps}
\fi%
%%
  \thispagestyle{frontpage}
\if@specsolns
%
%
\begin{adjustwidth}{0cm}{-4cm}
  \begin{tabular}{@{}p{17cm}@{}}
\parbox{12cm}{
	\textbf{\@faculty\newline
	\@modulecode\ \@moduletitle}
}
\hfill{\fboxsep=5mm\fboxrule=1.5mm\fbox{\large\sf Specimen Solutions}}\par
	\medskip
	\textbf{\Large \@tntitle\ \@tnyear}
\end{tabular}
\end{adjustwidth}
%
%
\else % not specimen solutions
%
%
  %\vspace{2cm}
\begin{adjustwidth}{0cm}{-4cm}
  \begin{tabular}{@{}p{6.5cm}@{}p{11.5cm}@{}}
  \vspace{0.2cm}
  \IfFileExists{\@oulogofile}{%
    \includegraphics[]{\@oulogofile}%
  }{%
    \fbox{\parbox[t][2cm][c]{3.5cm}{\centering OU Logo}}%
  }%
&
\vspace{0.2cm}\relax
\parbox{8cm}{
	\textbf{\@faculty\newline
	\@modulecode\ \@moduletitle}
}
\hfill{\fboxsep=5mm\fboxrule=1.5mm\fbox{\large\sf Tutor Notes}}\par
	\medskip
	\textbf{{\Large \@tntitle\ \@tnyear}\hfill \large\sf CONFIDENTIAL}\\[0.6cm]
\end{tabular}
\end{adjustwidth}
%
%
\fi
}

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfootoffset[RE,RO]{4cm} % lines up number with marks column
    \fancyfoot[R]{%
    	\if@specsolns\color{\@specsolnscolor}\fi
    	page~\thepage~of~\zpageref{LastPage}%
	} % centre bottom of every page except first
	% Copyright as per front page
	\fancyfoot[L]{%
    	\if@specsolns\color{\@specsolnscolor}\fi
    	\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}%
	}%
}
\pagestyle{internalpages}


\setcounter{secnumdepth}{3}

%\newcommand{\marginnote}[1]{{\renewcommand{\baselinestretch}{1.0}\marginpar{\footnotesize \raggedright #1}}}
\raggedright
\raggedbottom
\parindent 0pt
\parskip 6pt
\setlength{\mathindent}{20pt}\relax
\g@addto@macro{\normalsize}{%
	\setlength\abovedisplayskip{8pt plus 1 pt minus 1pt}%
	\setlength\belowdisplayskip{8pt plus 1pt minus 1pt}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TMA/CMA initiators
% Usage syntax: \assignment{name}[cut off]{number}[subtitle]
%
\newif\iffirstassignment
\firstassignmenttrue

\def\assignment#1{%
	\def\@assignmentname{#1} %store name of assignment (tma/cma, etc)
	  \setcounter{question}{0}
	% Draw a rule under end of previous assignment (if not first assignment)
  	\iffirstassignment\firstassignmentfalse\else\par\addvspace{\smallskipamount}\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\newpage\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}

% Version that doesn't add a new page
\def\samepageassignment#1{%
	\def\@assignmentname{#1} %store name of assignment (tma/cma, etc)
	  \setcounter{question}{0}
	% Draw a rule under end of previous assignment (if not first assignment)
  	\iffirstassignment\firstassignmentfalse\else\par\addvspace{\smallskipamount}\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\par\bigskip\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}

\def\@assignmentwithcutoff[#1]#2{%
\begin{adjustwidth}{0cm}{-5cm}
	\def\@cutoff{\@cutofftext\ #1}
	{\large \textbf{\@assignmentname\ #2} \hfill\textbf{\@cutofftext}#1}
\end{adjustwidth}
	\@ifnextchar[{\@assignmentsubtitle}{
		\par\addvspace{\bigskipamount}
	}
}

\def\@assignmentnocutoff#1{%
	\def\@cutoff{\relax}
	{\large \textbf{\@assignmentname\ #1}}%
	\@ifnextchar[{\@assignmentsubtitle}{\par\addvspace{\bigskipamount}}
}

% This does nothing except add some space,
% but means structure is identical to ouab.cls.
\def\@assignmentsubtitle[#1]{%
	\par\addvspace{\bigskipamount}
}

% Allows cut-off text to be suppressed
\def\@cutofftext{Cut-off date\ \ }
\def\nocutoffdate{\def\@cutofftext{See module website for the cut-off date.}}

% Set up the two most common types of assignment, and starred versions (which add no new page)
% usage e.g. \tma[cut off]{number}[subtitle]
\def\tma{\@ifstar\@tma\@@tma}
\def\@tma{\samepageassignment{TMA}}
\def\@@tma{\assignment{TMA}}
% And for CMAs
\def\cma{\@ifstar\@cma\@@cma}
\def\@cma{\samepageassignment{CMA}}
\def\@@cma{\assignment{CMA}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Horizontal lines after subtotals and totals
\newif\ifdraw@total@line
\newif\ifdraw@subtotal@line
\newif\ifdraw@ourule@line

% reference: http://tex.stackexchange.com/questions/34312/how-to-create-a-command-with-key-values
\pgfkeys{
 /totalhline/.is family, /totalhline,
 default/.style =
  {moveleft=.1\textwidth,
   movedown=0pt,
   width=1.5\textwidth,
   height=2pt,
   color=black},
   moveleft/.estore in=\@outn@total@hline@move@left,
   movedown/.estore in=\@outn@total@hline@move@down,
   width/.estore in=\@outn@total@hline@width,
   height/.estore in=\@outn@total@hline@height,
   color/.estore in=\@outn@total@hline@color,
   draw line/.is if=draw@total@line,
 /subtotalhline/.is family, /subtotalhline,
 default/.style =
  {moveleft=.1\textwidth,
   movedown=0pt,
   width=1.5\textwidth,
   height=1pt,
   color=black},
   moveleft/.estore in=\@outn@subtotal@hline@move@left,
   movedown/.estore in=\@outn@subtotal@hline@move@down,
   width/.estore in=\@outn@subtotal@hline@width,
   height/.estore in=\@outn@subtotal@hline@height,
   color/.estore in=\@outn@subtotal@hline@color,
   draw line/.is if=draw@subtotal@line,
 /ourule/.is family, /ourule,
 default/.style = /totalhline/default,
   moveleft/.estore in=\@outn@rule@move@left,
   movedown/.estore in=\@outn@rule@move@down,
   width/.estore in=\@outn@rule@width,
   height/.estore in=\@outn@rule@height,
   color/.estore in=\@outn@rule@color,
   draw line/.is if=draw@ourule@line,
}

% command to customise the line after totals
\newcommand{\setTotalHline}[1][]{%
    \pgfkeys{/totalhline,default,#1}%
}
% by default, turn subtotal lines on
\setTotalHline[draw line]

% command to customise the line after subtotals
\newcommand{\setSubtotalHline}[1][]{%
    \pgfkeys{/subtotalhline,default,#1}%
}
% by default, turn subtotal lines on
\setSubtotalHline[draw line]

% command to customise the ourule
\newcommand{\setOUrule}[1][]{%
    \pgfkeys{/ourule,default,#1}%
}
% this command sets the default values of \@outn@rule@move@left and friends
\setOUrule[/ourule/.default,draw line]

% the following command draws a rule manually (not with subtotal and friends) with optional key=values
\newcommand{\ourule}[1][]{%
    \ifdraw@ourule@line
    \pgfkeys{/ourule,#1}%
    \outn@draw@rule{\@outn@rule@move@left}%
                   {\@outn@rule@width}%
                   {\@outn@rule@color}%
                   {\@outn@rule@height}%
                   {\@outn@rule@move@down}%
  \fi
}

% reference: http://tex.stackexchange.com/questions/29574/shift-horizontal-line-to-the-left
\newcommand{\outn@draw@rule}[5]{%
        % #1: moveleft
        % #2: width
        % #3: color
        % #4: height
        % #5: movedown
  \par\nobreak % don't break a page here
  \vspace{#5}%
  \moveleft#1\vbox{% we want the rule to protrude on the left
    \hsize=#2% correct the length
    \kern\the\prevdepth % don't take into account the depth of the preceding line
    \kern\baselineskip % space before the rule
    \color{#3}\hrule height #4 width\hsize % the rule
    \kern3pt % space after the rule
  }\nointerlineskip % no additional space after the rule
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tutor or Student text
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For user to specify color:
\def\@tutorcolor{black}
\def\@studentcolor{\@specsolnscolor}
\newcommand\tutoronlycolor[1]{\def\@tutorcolor{#1}}
\newcommand\studentonlycolor[1]{\def\@studentcolor{#1}}
%
\AtBeginDocument{
  \if@specsolns
    \newcommand{\tnonly}[1]{\relax}
    \newcommand{\remark}[1]{\relax}
    \newenvironment{tutor}{\comment}{\endcomment}
    \newenvironment{longremark}{\comment}{\endcomment}
    %
    \newcommand{\ssonly}[1]{{\color{\@studentcolor}#1}}
    \newenvironment{student}{\color{\@studentcolor}\@studentonlytitle}{}
    %
    \newcommand{\tnorss}[2]{{\color{\@studentcolor}#2}}
  \else
    \newcommand{\tnonly}[1]{{\color{\@tutorcolor}#1}}
    \newenvironment{tutor}{\color{\@tutorcolor}\@tutoronlytitle}{}
    \newcommand{\remark}[1]{{\color{\@tutorcolor}\emph{Remark:} #1}}
    \newenvironment{longremark}{\vspace{0.25\baselineskip}\par\color{\@tutorcolor}\emph{Remarks}\\[3pt]}{\par}
    %
    \newcommand{\ssonly}[1]{\relax}
    \newenvironment{student}{\comment}{\endcomment}
    %
    \newcommand{\tnorss}[2]{{\color{\@tutorcolor}#1}}
  \fi
  %
  \newcommand*{\tutoronly}{\tnonly}
  \newcommand*{\studentonly}{\ssonly}
  \newcommand*{\tutororstudent}{\tnorss}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Newpage commands
\newcommand{\sspagebreak}{\if@specsolns\pagebreak\fi}
\newcommand{\tnpagebreak}{\if@specsolns\else\pagebreak\fi}
\newcommand{\ssnewpage}{\if@specsolns\newpage\fi}
\newcommand{\tnnewpage}{\if@specsolns\else\newpage\fi}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question headers
\newcounter{question}

\def\question{\@ifstar\@question\@@question}
% \@question is the version with star: it displays no marks
\newcommand{\@question}[1][\unskip]{%
	\refstepcounter{question}
	\par\bigskip{\textbf{Solution to Question~\thequestion} #1}\nopagebreak\par}
% \@@question is the version with no star: 2nd (compulsory) argument takes number of marks to display.
\newcommand{\@@question}[2][\unskip]{%
	\refstepcounter{question}
	\par\bigskip{\textbf{Solution to Question~\thequestion} #1} -- #2 marks\nopagebreak\par}

%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=1.0ex}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%
%% "Inline" lists, using inline option of enumitem:
\renewlist{enumerate*}{enumerate*}{3}
\setlist*[enumerate*]{before=\vspace{6pt}\newline,itemjoin=\hspace{50pt}}
\setlist*[enumerate*,1]{label=(\roman*), ref=(\roman*)}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Marks
%
\if@specsolns%
  	% suppress everything in specimen solutions
  	\newcommand*{\bracketedmarks}{\@ifstar\@relaxcmdA\@relaxcmdA}
  	\newcommand*{\solnmarks}{\@ifstar\@relaxcmdA\@relaxcmdA}
  	\newcommand*{\solnmarksplus}{\@ifstar\@relaxcmdB\@relaxcmdB}
    % Two flavours of \@relaxcmd depending on parameters
    % \@relaxopt handles final optional spacing parameter if supplied 
    \newcommand{\@relaxcmdA}[2][]{\@relaxopt}
    \newcommand{\@relaxcmdB}[2]{\@relaxopt}
    \newcommand{\@relaxopt}[1][]{\relax}
\else%
	% Not specimen solutions
	% Bracketed marks - not really used in outn
	\newcommand{\bracketedmarks}[2][\unskip]{%
		\marginnote{\hfill %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\small\raggedright #1}}\makebox[1cm][r]{[\textsl{#2}]}%
			\else%
				\makebox[1cm][r]{[\textsl{#2}]}\makebox[4cm][r]{\parbox[t]{3.75cm}{\small\raggedright #1}}%
			\fi%		
		}%
	}
	% Solnmarks -- the main system for rendering marks in outn
	\def\solnmarks{\@ifstar\@solnmarks\@@solnmarks}
	% \solnmarks*[]{}, doesn't affect @update@totals
	\newcommand{\@solnmarks}[2][\unskip]{%
		\@solnmarksbox{#1}{#2}%
	}	
	\newcommand{\@@solnmarks}[2][\unskip]{%
		\@solnmarksbox{#1}{\@update@totals{#2}}%
	}
	\newcommand{\@solnmarksbox}[2]{%
		\marginnote{\hfill\small\sf %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright #1}}\makebox[1cm][r]{#2}%
			\else%
				\makebox[1cm][r]{#2}\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright #1}}%
			\fi%
		}%
	}	
	%	
  	\newcommand{\solnmarksplus}[2]{\solnmarks[#2]{#1}}
\fi
% The standard \mk command is defined in terms of solnmarks.
% \bracketedmarks is available mainly for compatibility with ouab and ouexam.
\def\mk{\solnmarks}
\def\mkplus{\solnmarksplus} % Note: doesn't support * mode.
%
%
% definition of \total and \subtotal
\def\total{\@ifstar\@total\@@total}
\def\subtotal{\@ifstar\@subtotal\@@subtotal}
%
\if@specsolns%
    % specimen solutions mode is active
    \newcommand{\@total}[1][]{\relax}
    \newcommand{\@@total}[2][]{\relax}
    \newcommand{\@subtotal}[1][]{\relax}
    \newcommand{\@@subtotal}[2][]{\relax}
\else%
    \begingroup
    \catcode`P=12
    \catcode`T=12
    \lowercase{%
      \def\x{%
        \def\@render@mk##1.##2PT{%
          \ifnum##2=5
            \ifnum##1=0\else##1\fi% integer part
            \(\frac12\)% if x.5, print 1/2
          \else % Could capture more fractions here
            ##1%
            \ifnum##2=0% if no decimal part do nothing more
            \else.##2% otherwise print the decimal
            \fi
          \fi
        }%
      }%
    }\expandafter\endgroup\x

    \newlength{\tot@l}
    \newlength{\subtot@l}
    \newlength{\@mk}
    \newcommand{\thetotal}{\expandafter\@render@mk\the\tot@l}
    \newcommand{\thesubtotal}{\expandafter\@render@mk\the\subtot@l}
    % Required to set lengths globally from inside enumerate
    % See https://tex.stackexchange.com/a/406025/96966
    \gdef\gsetlength#1#2{%
      \begingroup
        \setlength\skip@{#2}% Local assignment to a scratch register.
        \global#1=\skip@    % Global assignement to #1;
      \endgroup             % \skip@ is restored by end of group.
    }
    \def\@update@totals#1{%
      \begingroup
        \newif\if@nan\@nanfalse%
        \newif\if@fndpt\@fndptfalse%
        \edef\tmp{\testleadneg{\detokenize{#1}}\relax}%
        \expandafter\testreal\tmp\relax%
        % Add to counter if a number
        \if@nan%
          #1% Render content as-is
        \else%
          \global\advance\subtot@l#1\p@%
          \global\advance\tot@l#1\p@%
          \setlength{\@mk}{#1pt}%
          \expandafter\@render@mk\the\@mk% Render using mark filter
        \fi
      \endgroup
     }
     % Tests for numerical content
     \def\testreal#1#2\relax{%
       % First decimal place or not?
       \if.#1\if@fndpt\@nantrue\else\@fndpttrue\fi\else%
       % Check for digits, otherwise not a number
       \if1#1\else\if2#1\else\if3#1\else\if4#1\else%
       \if5#1\else\if6#1\else\if7#1\else\if8#1\else%
       \if9#1\else\if0#1\else\@nantrue%
       \fi\fi\fi\fi\fi\fi\fi\fi\fi\fi\fi%
       \if@nan\else\if\relax#2\else\testreal#2\relax\fi\fi}

       \def\testleadneg#1#2\relax{\if-#1#2\else#1#2\fi%
     }
    % \total*
    \newcommand{\@total}[1][\unskip]{%
    	\strut\marginnote{\sf\bfseries %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Total\ #1}}\makebox[1cm][r]{\thetotal}%
     		\else%
				\makebox[1cm][r]{\thetotal}\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Total\ #1}}%
			\fi%
		}%
		\nopagebreak\gsetlength{\subtot@l}{0pt}\gsetlength{\tot@l}{0pt}\outn@draw@total@rule%
	}%
    % \total[]{}
    \newcommand{\@@total}[2][\unskip]{%
    	\strut\marginnote{\sf\bfseries %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Total\ #1}}\makebox[1cm][r]{#2}%
     		\else%
				\makebox[1cm][r]{#2}\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Total\ #1}}%
			\fi%
		}%
		\nopagebreak\gsetlength{\subtot@l}{0pt}\gsetlength{\tot@l}{0pt}\outn@draw@total@rule%
	}
    % \subtotal*
    \newcommand{\@subtotal}[1][\unskip]{%
    	\strut\marginnote{\small\sf\bfseries %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Subtotal\ #1}}\makebox[1cm][r]{\thesubtotal}%
     		\else%
				\makebox[1cm][r]{\thesubtotal}\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Subtotal\ #1}}%
			\fi%
		}%
		\nopagebreak\gsetlength{\subtot@l}{0pt}\outn@draw@subtotal@rule%
	}
    % \subtotal[]{}
    \newcommand{\@@subtotal}[2][\unskip]{%
    	\strut\marginnote{\small\sf\bfseries %
			\if@switchmarks%
				\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Subtotal\ #1}}\makebox[1cm][r]{#2}%
     		\else%
				\makebox[1cm][r]{#2}\makebox[4cm][r]{\parbox[t]{3.75cm}{\raggedright Subtotal\ #1}}%
			\fi%
		}%
		\nopagebreak\gsetlength{\subtot@l}{0pt}\outn@draw@subtotal@rule%
	}
\fi

% total horizontal rule
\newcommand{\outn@draw@total@rule}{%
\ifdraw@total@line%
        \outn@draw@rule{\@outn@total@hline@move@left}%
                       {\@outn@total@hline@width}%
                       {\@outn@total@hline@color}%
                       {\@outn@total@hline@height}%
                       {\@outn@total@hline@move@down}%
\fi%
}

% subtotal horizontal rule
\newcommand{\outn@draw@subtotal@rule}{%
\ifdraw@subtotal@line%
        \outn@draw@rule{\@outn@subtotal@hline@move@left}%
                       {\@outn@subtotal@hline@width}%
                       {\@outn@subtotal@hline@color}%
                       {\@outn@subtotal@hline@height}%
                       {\@outn@subtotal@hline@move@down}%
\fi%
}


%
\newcommand{\textref}[1]{\hfill\fbox{\emph{\textbf{#1}}}}
\newcommand{\longtextref}[1]{\hfill\fbox{\parbox{\dimexpr\textwidth-2\fboxsep-0.8pt\relax}{\emph{\textbf{#1}}}}}
\newenvironment{references}{\vspace{0.25\baselineskip}\par{\itshape References}\\[3pt]}{\par}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options for CMAs

% Options text
\def\@optiontext{\emph{Options}\par}
\newcommand\optiontext[1]{%
  \def\@optiontext{
    \ifthenelse{\equal{#1}{}}{}{\emph{#1}\par}
  }
}

% Inline ones (chops page into columns by using boxes of appropriate widths)
\newenvironment{inlineoptions}[2][1]{%
% #1 is the optional line spacing stretch. Default is 1
% #2 is the number of columns
  \par\medskip\@optiontext\vspace{\dimexpr\baselineskip-#1\baselineskip}
    \setcounter{enumi}{0}%
  \dimen0 \linewidth%
  \divide\dimen0 by #2\relax%
  \def\item{\hfil\egroup\penalty50 \hfill%
    \refstepcounter{enumi}%
    \def\baselinestretch{#1}%
    \@currsize
    \leavevmode\hbox to \dimen0 \bgroup\protect\makebox[0.7cm][l]{\textbf{\Alph{enumi}}}\space }%
  % Hack to allow "blank" slots at end of final line (or wherever)
  \def\noitem{\hfil\egroup\penalty50 \hfill%
    \leavevmode\hbox to \dimen0 \bgroup}%
  \leavevmode\bgroup\hskip 0pt plus -1fill %
}{\hfil\egroup\par}

% Normal options: this is just using enumitem features with enumerate.
\newenvironment{options}%
	{\par\medskip\@optiontext\begin{enumerate}[label=\textbf{\Alph*}]}%
	{\end{enumerate}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make marks always appear on RHS:
%% Needed for marginnote package
%% \@mn@@@marginnote changed on 2018/04/13
\@ifpackagelater{marginnote}{2018/04/13}
  {%
    % Version of marginnote from 2018/04/13
    \long\def\@mn@@@marginnote[#1]#2[#3]{%
      \begingroup
        \ifmmode\mn@strut\let\@tempa\mn@vadjust\else
          \if@inlabel\leavevmode\fi
          \ifhmode\mn@strut\let\@tempa\mn@vadjust\else\let\@tempa\mn@vlap\fi
        \fi
        \@tempa{%
          \vbox to\z@{%
            \vss
            \@mn@margintest
            \if@reversemargin\if@tempswa
                \@tempswafalse
              \else
                \@tempswatrue
            \fi\fi
            %\if@tempswa
              \rlap{%
                \if@mn@verbose
                  \PackageInfo{marginnote}{xpos seems to be \@mn@currxpos}%
                \fi
                \begingroup
                  \ifx\@mn@currxpos\relax\else\ifx\@mn@currxpos\@empty\else
                      \kern-\dimexpr\@mn@currxpos\relax
                  \fi\fi
                  \ifx\@mn@currpage\relax
                    \let\@mn@currpage\@ne
                  \fi
                  \if@twoside\ifodd\@mn@currpage\relax
                      \kern\oddsidemargin
                    \else
                      \kern\evensidemargin
                    \fi
                  \else
                    \kern\oddsidemargin
                  \fi
                  \kern 1in
                \endgroup
                \kern\marginnotetextwidth\kern\marginparsep
                \vbox to\z@{\kern\marginnotevadjust\kern #3
                  \vbox to\z@{%
                    \hsize\marginparwidth
                    \linewidth\hsize
                    \kern-\parskip
                    \marginfont\raggedrightmarginnote\strut\hspace{\z@}%
                    \ignorespaces#2\endgraf
                    \vss}%
                  \vss}%
              }%
          }%
        }%
      \endgroup
    }
  }
  {% Older versions of marginnote
    \long\def\@mn@@@marginnote[#1]#2[#3]{%
      \begingroup
        \ifmmode\mn@strut\let\@tempa\mn@vadjust\else
          \if@inlabel\leavevmode\fi
          \ifhmode\mn@strut\let\@tempa\mn@vadjust\else\let\@tempa\mn@vlap\fi
        \fi
        \@tempa{%
          \vbox to\z@{%
            \vss
            \@mn@margintest
            \if@reversemargin\if@tempswa
                \@tempswafalse
              \else
                \@tempswatrue
            \fi\fi
            % Removed: \if@tempswa
              \rlap{%
                \ifx\@mn@currxpos\relax
                  \kern\marginnoterightadjust
                  \if@mn@verbose
                    \PackageInfo{marginnote}{%
                      xpos not known,\MessageBreak
                      using \string\marginnoterightadjust}%
                  \fi
                \else\ifx\@mn@currxpos\@empty
                    \kern\marginnoterightadjust
                    \if@mn@verbose
                      \PackageInfo{marginnote}{%
                        xpos not known,\MessageBreak
                        using \string\marginnoterightadjust}%
                    \fi
                  \else
                    \if@mn@verbose
                      \PackageInfo{marginnote}{%
                        xpos seems to be \@mn@currxpos,\MessageBreak
                        \string\marginnoterightadjust
                        \space ignored}%
                    \fi
                    \begingroup
                      \setlength{\@tempdima}{\@mn@currxpos}%
                      \kern-\@tempdima
                      \if@twoside\ifodd\@mn@currpage\relax
                          \kern\oddsidemargin
                        \else
                          \kern\evensidemargin
                        \fi
                      \else
                        \kern\oddsidemargin
                      \fi
                      \kern 1in
                    \endgroup
                  \fi
                \fi
                \kern\marginnotetextwidth\kern\marginparsep
                \vbox to\z@{\kern\marginnotevadjust\kern #3
                  \vbox to\z@{%
                    \hsize\marginparwidth
                    \linewidth\hsize
                    \kern-\parskip
                    \marginfont\raggedrightmarginnote\strut\hspace{\z@}%
                    \ignorespaces#2\endgraf
                    \vss}%
                  \vss}%
              }%
          }%
        }%
      \endgroup
    }
  }%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solutions
% Dummy environment:
\newenvironment{solution}{}{}
%
%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Line at end of AB
\AtEndDocument{%
\par\addvspace{\smallskipamount}\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}%
}%
%%
%% EOF
