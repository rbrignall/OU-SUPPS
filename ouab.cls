\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ouab}[2015/05/22 v0.9 (Robert Brignall, all rights reserved)]
% Experimental!
\newif\if@markcheck
\@markcheckfalse
\DeclareOption{markcheck}{%
  \@markchecktrue
}
\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,12pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=2cm,nohead,asymmetric]{geometry}%
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
\newcommand\abyear[1]{\renewcommand\@abyear{#1}}
\newcommand\@abyear{\@latex@error{No \noexpand\abyear specified}\@ehc}
%
\newcommand\abtitle[1]{\renewcommand\@abtitle{#1}}
\newcommand\@abtitle{\@latex@error{No \noexpand\abtitle specified}\@ehc}
%
\def\@absubtitle{\relax}
\newcommand\absubtitle[1]{\DeclareRobustCommand\@absubtitle{#1}}
%
\def\@abinstructions{No special instructions specified.}
\newcommand\abinstructions[1]{\DeclareRobustCommand\@abinstructions{#1}}
%
\def\@suppno{DRAFT} % default
\newcommand\suppno[1]{\DeclareRobustCommand\@suppno{#1}}
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand{\maketitle}{
  \thispagestyle{empty}
  \vspace{2cm}
\begin{adjustwidth}{0cm}{-4cm}
  \begin{tabular}{@{}p{4.5cm}@{}p{12.5cm}@{}}
  \vspace{1.5cm}
  \includegraphics[width=3.5cm]{ou_compact_grey_24mm}
&
\vspace{1.5cm}\textbf{\@faculty\newline
\@modulecode\ \@moduletitle}

\bigskip\bigskip\bigskip
\textbf{\Huge \@modulecode}\newline
\rule{12.5cm}{1pt}

\bigskip\bigskip\textbf{\Huge \@abtitle}
\par\bigskip\textbf{\large \@absubtitle}

\medskip\rule{12.5cm}{1pt}

\medskip\textbf{Contents\hfill Cut-off date}

%inserts list of TMA/CMA entries
\@starttoc{tma}

\nointerlineskip\vspace{12pt}
\end{tabular}
  \rule{17cm}{2pt}
\end{adjustwidth}

\begin{adjustwidth}{2.5cm}{-2cm}
  \raggedright
  \@abinstructions
  \end{adjustwidth}
  \vfill
\begin{adjustwidth}{0cm}{-4cm}
  \rule{17cm}{2pt}
  \textbf{Copyright \copyright\ \@abyear\ The Open University\hfill \@suppno}
  \end{adjustwidth}
  \newpage
}

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
    %\fancyhead[RE, RO]{\textbf\thepage}%
    \fancyfoot[C]{page~\thepage~of~\pageref{LastPage}} % internal right hand pages only
    %\fancyfoot[RE,RO]{\bfseries\thepage}
    %\fancyfoot[LE,LO]{\bfseries\@modulecode\ \@exammonth\ \@examyear}  
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
  	\iffirstassignment\firstassignmentfalse\else\rule{\textwidth}{2pt}\newpage\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}

\def\@assignmentwithcutoff[#1]#2{%
  	\addtocontents{tma}{\protect\makebox[1cm][l]{\thepage}\@assignmentname\ #2 \hfill #1}
	{\large \textbf{\@assignmentname\ \@modulecode\ #2} -- cut off date #1}\par
	\@ifnextchar[{\@assignmentsubtitle}{\addtocontents{tma}{\par\medskip}}
}

\def\@assignmentnocutoff#1{%
  	\addtocontents{tma}{\protect\makebox[1cm][l]{\thepage}\@assignmentname\ #1}
	{\large \textbf{\@assignmentname\ \@modulecode\ #1}}\par
	\@ifnextchar[{\@assignmentsubtitle}{\addtocontents{tma}{\par\medskip}}
}

\def\@assignmentsubtitle[#1]{%
  \addtocontents{tma}{\newline\protect\makebox[1cm][l]{}#1\par\medskip}
}

% Set up the two most common types of assignment
% usage e.g. \tma[cut off]{number}[subtitle]
\def\tma{\assignment{TMA}}
\def\cma{\assignment{CMA}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question headers
\newcounter{question}
\newcommand{\question}[2][]{%
	\if@markcheck%experimental
		\ifthenelse{\value{marktarget}=\value{marksum}}{\typeout{Q\thequestion, P\thepage, marks ok}}{\ClassError{ouab}{Q\thequestion, P\thepage, mark mismatch}{Press enter to continue compilation}}
		\setcounter{marktarget}{#2}		
		\setcounter{marksum}{0}
	\fi
	\stepcounter{question}
	\par\bigskip{\textbf{Question~\thequestion}\ #1} -- #2 marks\nopagebreak\par}

%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=8mm,labelsep*=0pt}
\setlist[enumerate,1]{label=(\roman*), ref=(\roman*)}
\setlist[enumerate,2]{label=(\alph*), ref=(\alph*)}
%%%%%%
%% Marks
\renewcommand{\marks}[1]{%
	\marginnote{\hfill[\textsl{#1}]}
	\if@markcheck\addtocounter{marksum}{#1}\fi % experimental	
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options for CMAs
% Inline ones (chops page into columns by using boxes of appropriate widths)
\def\inlineoptions#1{%
  \par\medskip\emph{Options}\par
  \setcounter{enumi}{0}%
  \dimen0 \linewidth
  \divide\dimen0 by #1\relax
  \def\item{\hfil\egroup\penalty50 \hfill
    \refstepcounter{enumi}%
    \leavevmode\hbox to \dimen0 \bgroup\protect\makebox[0.7cm][l]{\textbf{\Alph{enumi}}}\space}% 
  \def\noitem{\hfil\egroup\penalty50 \hfill
    \leavevmode\hbox to \dimen0 \bgroup}%
  \leavevmode\bgroup\hskip 0pt plus -1fill %
}
\def\endinlineoptions{\hfil\egroup}

% Normal options: this is just using enumitem features with enumerate.
\newenvironment{options}%
	{\par\medskip\emph{Options}\begin{enumerate}[label=\textbf{\Alph*}]}%
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
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Line at end of AB
\let\@oldenddochook\@enddocumenthook
\def\@enddocumenthook{%
\par\bigskip \rule{\textwidth}{2pt}
\@oldenddochook}

%%
%% EOF
