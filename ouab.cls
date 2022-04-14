\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ouab}[2021/11/16 v2.3.3 (Robert Brignall, all rights reserved)]
% Experimental!
\newif\if@draft
\@draftfalse
\DeclareOption{draft}{%
  \@drafttrue
}
\newif\if@oneassignment
\@oneassignmentfalse
\DeclareOption{oneassignment}{%
  \@oneassignmenttrue
}
%
% accessibility warnings
%
\newif\if@ousupps@accessibility@warnings
\@ousupps@accessibility@warningsfalse
\DeclareOption{accessibility-warnings}{%
   \@ousupps@accessibility@warningstrue
}
\DeclareOption{a-w}{%
   \@ousupps@accessibility@warningstrue
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
\RequirePackage[user,lastpage]{zref}
\RequirePackage{ifthen}
\RequirePackage[inline,shortlabels]{enumitem}
\RequirePackage{marginnote}
\RequirePackage{pgfkeys}
\RequirePackage{iftex}
\RequirePackage[labelsep=quad]{caption} % Fixes figure captions to OU style
%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to set up module codes, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@faculty{Faculty of Science, Technology, Engineering and Mathematics}
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
% Optional copyrightyear:
\def\@copyrightyear{\@abyear}
\newcommand\copyrightyear[1]{\def\@copyrightyear{#1}}
%
\newcommand\abtitle[1]{\renewcommand\@abtitle{#1}}
\newcommand\@abtitle{\@latex@error{No \noexpand\abtitle specified}\@ehc}
%
\def\@absubtitle{\relax}
\newif\if@subtitle
\@subtitlefalse
\newcommand\absubtitle[1]{\DeclareRobustCommand\@absubtitle{#1}\@subtitletrue}
%
\def\@abinstructions{No special instructions specified.}
\newcommand\abinstructions[1]{\DeclareRobustCommand\@abinstructions{#1}}
%
\def\@suppno{DRAFT} % default
\newcommand\suppno[1]{\DeclareRobustCommand\@suppno{#1}}
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}
%
\def\@oulogofilebase{OU_Master_Logo_Black_CMYK_29mm}
\newcommand\oulogofilebase[1]{\renewcommand\@oulogofilebase{#1}}
%
\def\@uniqueID{}
\newcommand\uniqueID[1]{\DeclareRobustCommand\@uniqueID{#1}}
%
\def\@figuredescription{}
\newcommand\figuredescription[1]{\global\def\@figuredescription{#1}}
\AtBeginEnvironment{figure}{%
   \global\def\@figuredescription{}%
}
\AtBeginEnvironment{figure*}{%
   \global\def\@figuredescription{}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meta data can be set using \metadataset command, based on pgfkeys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pgfkeys{
 /meta data/.is family, /meta data,
   faculty/.store in=\@faculty,
   module code/.store in =\@modulecode,
   module title/.store in=\@moduletitle,
   document title/.store in=\@abtitle,
   document subtitle/.code=\absubtitle{#1},
   presentation/.store in=\@abyear,
   copyright year/.store in=\@copyrightyear,
   multiple choice option text/.code=\optiontext{#1},
   supp no/.store in=\@suppno,
   version no/.store in=\@versionno,
   instructions/.store in=\@abinstructions,
   no cut off date/.code = \nocutoffdate,
   ou logo file base/.store in=\@oulogofilebase,
   unique ID/.code=\uniqueID{#1},
}
\newcommand{\metadataset}[1]{%
    \pgfkeys{/meta data,#1}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footers for title page (copyright, etc)
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{2pt}%
    \fancyfoot[L]{\large\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}\hfill \textbf{\@suppno}\\
\textbf{\@versionno} }%
}
\newlength{\logospace}
\setlength{\logospace}{4.1cm}
\renewcommand{\maketitle}{
%% First, set up PDF metadata
 \pdfinfo{
   /Author (The Open University)
   /Title  (\@modulecode\ \@abtitle\ \@abyear)
}%
% Logo preamble:
\ifpdf%
  \def\@oulogofile{\@oulogofilebase.pdf}
\else%
  \def\@oulogofile{\@oulogofilebase.eps}
\fi%
%%
  \thispagestyle{frontpage}
  %\vspace{2cm}
\begin{adjustwidth}{0cm}{-\logospace}
  \begin{tabular}{@{}p{\logospace}@{}p{\textwidth}@{}}
  \vspace{0.2cm}%
  \IfFileExists{\@oulogofile}{%
    \includegraphics[width=3.3cm]{\@oulogofile}%
  }{%
    \fbox{\parbox[t][2cm][c]{3.3cm}{\centering OU Logo}}%
  }%
&
\vspace{0.2cm}\textbf{\@faculty\newline
\@modulecode\ \@moduletitle}

\bigskip\bigskip\bigskip
\textbf{\Huge \@modulecode}\newline
\rule{\textwidth}{1pt}

\bigskip\bigskip\textbf{\Huge \@abtitle\hfill\@abyear}
\if@subtitle\par\bigskip\textbf{\large \@absubtitle}\fi

\medskip\rule{\textwidth}{1pt}

\if@oneassignment
\medskip
\else
\medskip{\large\textbf{Contents\hfill \@covercutofftext}}\par\medskip
\fi
%inserts list of TMA/CMA entries
\@starttoc{tma}
\nointerlineskip
\end{tabular}
\par\medskip
  \rule{\dimexpr\textwidth+\logospace}{2pt}
\par\medskip
\end{adjustwidth}
%
\begin{adjustwidth}{\logospace}{-\logospace} 
  \@abinstructions
\end{adjustwidth}
%
  \newpage
}

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfootoffset[RE,RO]{4cm} % lines up number with marks column
  \fancyfoot[C]{page~\thepage~of~\zpageref{LastPage}} % internal right hand pages only
  \if@draft%
    \fancyfoot[RE,RO,LE,LO]{DRAFT}
  \fi%
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
\newif\iffirstassignment
\firstassignmenttrue

\def\assignment#1{%
	\if@draft%
		\@check@marks%
		\setcounter{marktarget}{0}%
	\fi	  
	\def\@assignmentname{#1} %store name of assignment (tma/cma, etc)
	\setcounter{question}{0}
	% Draw a rule under end of previous assignment (if not first assignment)
  	\iffirstassignment\firstassignmentfalse\else\par\addvspace{\smallskipamount}\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\newpage\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}
% Version that doesn't add a new page
\def\samepageassignment#1{%
	\if@draft% Do checks on marks from previous assignment (if it exists)
		\@check@marks%
		\setcounter{marktarget}{0}%
	\fi%
	\def\@assignmentname{#1} %store name of assignment (tma/cma, etc)
	\setcounter{question}{0}
	% Draw a rule under end of previous assignment (if not first assignment)
  	\iffirstassignment\firstassignmentfalse\else\par\addvspace{\smallskipamount}\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\par\bigskip\fi
	\@ifnextchar[{\@assignmentwithcutoff}{\@assignmentnocutoff}
}
%
\def\@assignmentwithcutoff[#1]#2{%
	\def\@cutoff{\@cutofftext\ #1}
	{\large \textbf{\@assignmentname\ #2} \hfill\textbf{\@cutofftext}#1}
	\if@oneassignment%
		\relax%
	\else%
	  	\addtocontents{tma}{\protect\makebox[1cm][l]{\thepage}\@assignmentname\ #2 \hfill #1}%
	\fi%
	\@ifnextchar[{\@assignmentsubtitle}{
		\if@oneassignment\addtocontents{tma}{\hfill\textbf{\@cutoff}}
		\else\addtocontents{tma}{\par\medskip}\fi
		\par\addvspace{\bigskipamount}
	}
}
%
\def\@assignmentnocutoff#1{%
	\def\@cutoff{\relax}
	{\large \textbf{\@assignmentname\ #1}}%
	\if@oneassignment
		\relax 
	\else
	  	\addtocontents{tma}{\protect\makebox[1cm][l]{\thepage}\@assignmentname\ #1}
	\fi
	\@ifnextchar[{\@assignmentsubtitle}{\addtocontents{tma}{\par\medskip}\par\addvspace{\bigskipamount}}
}

\def\@assignmentsubtitle[#1]{%
	\if@oneassignment
		\addtocontents{tma}{\textbf{#1\hfill\@cutoff} \par\medskip}
	\else
		\addtocontents{tma}{\newline\protect\makebox[1cm][l]{}#1\par\medskip}
	\fi
	\par\addvspace{\bigskipamount}
}
%
% Allows cut-off text to be suppressed
\def\@cutofftext{Cut-off date\ \ }
\def\@covercutofftext{Cut-off date}
\def\nocutoffdate{\def\@cutofftext{See module website for the cut-off date.}\def\@covercutofftext{\relax}}

% Set up the two most common types of assignment, and starred versions (which add no new page)
% usage e.g. \tma[cut off]{number}[subtitle]
\def\tma{\@ifstar\@tma\@@tma}
\def\@tma{\samepageassignment{TMA}}
\def\@@tma{\assignment{TMA}}
% And for CMAs
\def\cma{\@ifstar\@cma\@@cma}
\def\@cma{\samepageassignment{CMA}}
\def\@@cma{\assignment{CMA}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question headers
\newcounter{question}
%
\def\question{\@ifstar\@question\@@question}
%
%% \@question is the version with star: it displays no marks
\newcommand{\@question}[1][\unskip]{%
	\if@draft%
		\@check@marks%
		\setcounter{marktarget}{0}% 0 suppresses warnings later
	\fi
	\stepcounter{question}%
	\par\addvspace{\bigskipamount}%
	{\textbf{Question~\thequestion} #1}\nopagebreak\par}
%
%% \@@question is the version with no star: 2nd (compulsory) argument takes number of marks to display. 
\newcommand{\@@question}[2][\unskip]{%
	\if@draft%
		\@check@marks%
		\setcounter{marksum}{0}
		\setcounter{marktarget}{#2}
	\fi
	\stepcounter{question}%
	\par\addvspace{\bigskipamount}% 
	\def\@marktext{\ifnum#2=1 mark \else marks\fi}
	{\textbf{Question~\thequestion} #1}\hspace{12pt}--\hspace{12pt}#2 \@marktext\nopagebreak\par}
%
\newcommand\@check@marks{
	\ifnum\c@marktarget=0\relax% Mark of 0 specified: do nothing
	\else
		\ifnum\c@marktarget=\c@marksum% Marks match
			\relax
		\else% Marks don't match
			\fbox{\parbox{0.9\textwidth}{\textbf{Draft mode warning}\newline Marks specified: \themarktarget\newline Sum of marks in Question~\thequestion: \themarksum}}
		\fi
	\fi
}
%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=1.0ex}
\setlist[itemize]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=-0.25ex}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%
%% "Inline" lists, using inline option of enumitem:
\renewlist{enumerate*}{enumerate*}{3}
\setlist*[enumerate*]{before=\vspace{6pt}\newline,itemjoin=\hspace{50pt}}
\setlist*[enumerate*,1]{label=(\roman*), ref=(\roman*)}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Marks
\newcommand{\mk}[1]{%
	\marginnote{\hfill[\textsl{#1}]}%
	\if@draft\@update@marktarget{#1}\fi%
}
% Set up marktarget counter and update mechanism
\newcounter{marktarget} % stated total of marks
\newcounter{marksum} % cumulative sum of specified marks
\def\@update@marktarget#1{%
 	\afterassignment\get@args\count@=0#1\hfuzz#1\hfuzz}
\def\get@args#1\hfuzz#2\hfuzz{%
 	\if\relax\detokenize{#1}\relax
     	\if\relax\detokenize{#2}\relax
     	\else%
        	\addtocounter{marksum}{#2} % Subtract mark from target
     	\fi%
  	\else%
    	\relax
  	\fi%
}
%\def\marks{\ClassWarning{ouab}{\protect\marks\space is deprecated. Please use \protect\mk\space(same syntax)}\mk}
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

%
% accessibility warnings
%
\newcommand{\ouabPrintAW}{}
\newif\if@ousupps@accessibility@warnings@printed
\@ousupps@accessibility@warnings@printedfalse

\if@ousupps@accessibility@warnings%
 \typeout{ouab: accessibility warnings switch active}
 \renewcommand{\ouabPrintAW}{%
  \@ousupps@accessibility@warnings@printedtrue%
  \subsection*{Accessibility warnings summary}\@starttoc{aws}}
 %
 % command to output accessibility warning message
 %
 \newcommand{\ousupps@accessibility@warning@message}[2]{%
  %
  % \ousupps@accessibility@warning@message{<warning NUMBER>}{<warning MESSAGE>}
  %
  \marginnote{\fbox{\fbox{\parbox{5cm}{\small\emph{AW#1: #2}}}}}%
  \addcontentsline{aws}{subsubsection}{AW#1: #2}%
  \typeout{ouab: accessibility warning, AW#1: #2}
 }
 %
 % AW1: list levels need to be <=2 for the VLE
 %
 \AtBeginEnvironment{enumerate}{%
  \ifnum\the\@enumdepth>1%
   \ousupps@accessibility@warning@message{1}{list depth (enumerate) more than 2}%
  \fi
  \ifnum\the\@itemdepth>1%
   \ousupps@accessibility@warning@message{1}{list depth (enumerate) more than 2}%
  \fi
 }
 \AtBeginEnvironment{itemize}{%
  \ifnum\the\@enumdepth>1%
   \ousupps@accessibility@warning@message{1}{list depth (itemize) more than 2}%
  \fi
  \ifnum\the\@itemdepth>1%
   \ousupps@accessibility@warning@message{1}{list depth (itemize) more than 2}%
  \fi
 }
 %
 % AW3, AW4: tabular environment checks
 %
 \BeforeBeginEnvironment{tabular}{%
  %
  % AW3: tabular in math environment
  %
  \ifmmode%
   \ousupps@accessibility@warning@message{3}{tabular in math mode}%
  \else
   %
   % AW4: tabular without table/table* wrapping body
   %
   \def\@tempa{table}%
   \ifx\@tempa\@currenvir\relax
   \else
    \def\@tempa{table*}%
    \ifx\@tempa\@currenvir\relax
    \else
     \ousupps@accessibility@warning@message{4}{tabular not in table nor in table*}%
    \fi
   \fi
  \fi
 }
 %
 % AW 5: figure description empty
 %
 \AfterEndEnvironment{figure}{%
  \ifx\@figuredescription\@empty%
   \ousupps@accessibility@warning@message{5}{no figure description given}%
  \fi
 }
 \AfterEndEnvironment{figure*}{%
  \ifx\@figuredescription\@empty%
   \ousupps@accessibility@warning@message{5}{no figure description given}%
  \fi
 }
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Line at end of AB
\AtEndDocument{%
 \if@draft%
  \@check@marks%
 \fi%
 \par\addvspace{\smallskipamount}%
 \makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}%
 %
 % accessibility warnings
 %
 \if@ousupps@accessibility@warnings%
  %
  % AW2: unique ID not specified
  %
  \ifx\@uniqueID\@empty%
   \ousupps@accessibility@warning@message{2}{unique ID not specified}%
  \fi
  %
  % check if \ouabPrintAW has been called, and if not, then output summary
  %
  \if@ousupps@accessibility@warnings@printed\relax%
  \else
   \ouabPrintAW%
  \fi
 \fi
}%
%%
%% EOF
