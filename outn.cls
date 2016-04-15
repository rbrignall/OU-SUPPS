\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{outn}[2016/04/14 v0.1 (Robert Brignall, all rights reserved)]
% Experimental!
\newif\if@markcheck
\@markcheckfalse
\DeclareOption{markcheck}{%
  \@markchecktrue
}
\newif\if@oneassignment
\@oneassignmentfalse
\DeclareOption{oneassignment}{%
  \@oneassignmenttrue
}
\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,11pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=2cm,marginparsep=-4ex,nohead,asymmetric]{geometry}%
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{changepage}
\RequirePackage{array}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amsthm}
\RequirePackage{amssymb}
\RequirePackage{lastpage}
\RequirePackage{ifthen}
\RequirePackage[inline,shortlabels]{enumitem}
\RequirePackage{marginnote}
\RequirePackage[xcolor]{mdframed}
\RequirePackage{l3regex}
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
\newcommand\tntitle[1]{\renewcommand\@tntitle{#1}}
\newcommand\@tntitle{\@latex@error{No \noexpand\tntitle specified}\@ehc}
%
\def\@tninstructions{\relax}
\newcommand\tninstructions[1]{\DeclareRobustCommand\@tninstructions{#1}}
%
\def\@suppno{DRAFT} % default
\newcommand\suppno[1]{\DeclareRobustCommand\@suppno{#1}}
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footers for title page (copyright, etc)
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{2pt}%
    \fancyfoot[L]{\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}\hfill \textbf{\@suppno}\\
\textbf{\@versionno} }%
}
\renewcommand{\maketitle}{
  \thispagestyle{frontpage}
  %\vspace{2cm}
\begin{adjustwidth}{0cm}{-4cm}
  \begin{tabular}{@{}p{4.5cm}@{}p{12.5cm}@{}}
  \vspace{0.2cm}
  \includegraphics[width=3.5cm]{ou_greyscale_masterlogo_29mm}%{ou_compact_grey_24mm}
&
\vspace{0.2cm}\relax
\parbox{8cm}{
	\textbf{\@faculty\newline
	\@modulecode\ \@moduletitle}
}
\hfill{\fboxsep=5mm\fboxrule=1.5mm\fbox{\large\sf Tutor Notes}}\par
	\medskip
	\textbf{\Large \@tntitle\ \@tnyear}
\\
%\rule{12.5cm}{1pt}

&\raggedright
  \@tninstructions
\end{tabular}
\rule{17cm}{2pt}
  
%\if@oneassignment
%\medskip
%\else
%\medskip\textbf{Contents\hfill Cut-off date}\par\medskip
%\fi
%%inserts list of TMA/CMA entries
%\@starttoc{tma}


%\nointerlineskip\vspace{12pt}
%\end{tabular}
%  \rule{17cm}{2pt}
%\par\medskip
%\begin{tabular}{@{}p{4.5cm}@{}p{12.5cm}@{}}
% &\raggedright
%  \@tninstructions
% \end{tabular}
\end{adjustwidth}
%
%  \newpage
}

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfootoffset[RE,RO]{4cm} % lines up number with marks column
    \fancyfoot[C]{page~\thepage~of~\pageref{LastPage}} % internal right hand pages only
}
\pagestyle{internalpages}


\setcounter{secnumdepth}{3}

%\newcommand{\marginnote}[1]{{\renewcommand{\baselinestretch}{1.0}\marginpar{\footnotesize \raggedright #1}}}
\raggedright
\raggedbottom                
\setlength{\mathindent}{40pt}\relax
\parindent 0pt
\parskip 4pt

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TMA/CMA initiators
% Usage syntax: \assignment{name}[cut off]{number}[subtitle]
\newif\iffirstassignment
\firstassignmenttrue
\def\assignment#1{%
	\def\@assignmentname{#1} %store name of assignment (tma/cma, etc)
	  \setcounter{question}{0}
	% Draw a rule under end of previous assignment (if not first assignment)
  	\iffirstassignment\firstassignmentfalse\else\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\newpage\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}

\def\@assignmentwithcutoff[#1]#2{%
	\def\@cutoff{Cut-off date #1}
	{\large \textbf{\@assignmentname\ #2} \hfill\textbf{Cut-off date}\ \ #1}\par
	\@ifnextchar[{\@assignmentsubtitle}{\relax}
}

\def\@assignmentnocutoff#1{%
	\def\@cutoff{\relax}
	{\large \textbf{\@assignmentname\ #1}}\par
	\@ifnextchar[{\@assignmentsubtitle}{\relax}
}

% This does nothing, but means syntax can be identical to AB if desired.
\def\@assignmentsubtitle[#1]{%
	\relax
}

% Set up the two most common types of assignment
% usage e.g. \tma[cut off]{number}[subtitle]
\def\tma{\assignment{TMA}}
\def\cma{\assignment{CMA}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question headers
\newcounter{question}

\def\question{\@ifstar\@question\@@question}
% \@question is the version with star: it displays no marks
\newcommand{\@question}[1][]{%
	\stepcounter{question}
	\par\bigskip{\textbf{Question~\thequestion}\ #1}\nopagebreak\par}
% \@@question is the version with no star: 2nd (compulsory) argument takes number of marks to display. 
\newcommand{\@@question}[2][]{%
	\if@markcheck%experimental system to check marks
		\ifthenelse{\value{marktarget}=\value{marksum}}{\typeout{Q\thequestion, P\thepage, marks ok}}{\ClassError{outn}{Q\thequestion, P\thepage, mark mismatch}{Press enter to continue compilation}}
		\setcounter{marktarget}{#2}		
		\setcounter{marksum}{0}
	\fi
	\stepcounter{question}
	\par\bigskip{\textbf{Question~\thequestion}\ #1} -- #2 marks\nopagebreak\par}

%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=8mm,labelsep*=0pt}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%%%%%
%% Marks
\renewcommand{\marks}[1]{%
	\marginnote{\hfill[\textsl{#1}]}
	\if@markcheck\addtocounter{marksum}{#1}\fi % experimental	
}
\let\mk\marks
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
  \par\medskip\@optiontext
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
%% Experimental mark counter
\if@markcheck
	\newcounter{marksum} % rolling sum of submarks
	\newcounter{marktarget} % stated total of marks
\fi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Make marks always appear on RHS:
%% Needed for marginnote package
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solutions
\newmdenv[linewidth=0pt,topline=false,bottomline=false,rightline=false,innerrightmargin=5.5cm,innerleftmargin=10pt,linecolor=black,frametitle=Solution to \thequestion]{solutionbox}
%
\newenvironment{solution}
 {\def\marks{\solnmarks}\begin{adjustwidth}{-13pt}{-5.5cm}\begin{solutionbox}\small}
 {\end{solutionbox}\end{adjustwidth}\def\marks{\bracketedmarks}}
%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Line at end of AB
\let\@oldenddochook\@enddocumenthook
\def\@enddocumenthook{%
\par\bigskip \makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}
\@oldenddochook}

%%
%% EOF
