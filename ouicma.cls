\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ouicma}[2024/03/11 v2.4 (Robert Brignall, all rights reserved)]
\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,12pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=5cm,marginparsep=0ex,nohead,asymmetric]{geometry}%
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
%\RequirePackage{hyperref}
%\RequirePackage{pageslts}
\RequirePackage{changepage}
\RequirePackage{array}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amssymb}
\RequirePackage[user,lastpage]{zref}
\RequirePackage{ifthen}
\RequirePackage{tikz}
\RequirePackage{enumitem}
\RequirePackage{mdframed}
\RequirePackage{marginnote}
\RequirePackage{iftex}
%%

%\def\contentsname{}
%\renewcommand{\baselinestretch}{1.3}
\topskip0pt
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
\newcommand\icmayear[1]{\renewcommand\@ouyear{#1}}
\newcommand\@ouyear{\@latex@error{No \noexpand\icmayear specified}\@ehc}
% Optional copyrightyear:
\def\@copyrightyear{\@ouyear}
\newcommand\copyrightyear[1]{\def\@copyrightyear{#1}}
%
\newcommand\icmatitle[1]{\renewcommand\@outitle{#1}}
\newcommand\@outitle{\@latex@error{No \noexpand\icmatitle specified}\@ehc}
%
\def\@ousubtitle{\relax}
\newcommand\icmasubtitle[1]{\DeclareRobustCommand\@ousubtitle{#1}}
%
\def\@instructions{No special instructions specified.}
\newcommand\instructions[1]{\DeclareRobustCommand\@instructions{#1}}
%
\def\@cutoffdate{\relax}
\newcommand\cutoffdate[1]{\DeclareRobustCommand\@cutoffdate{#1}}
%
\def\@coversmaterialin{\relax}
\newcommand\coversmaterialin[1]{\DeclareRobustCommand\@coversmaterialin{#1}}
%
\def\@suppno{DRAFT}
\newcommand\suppno[1]{\DeclareRobustCommand\@suppno{#1}}
%
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}
%
\def\@oudeclaration{%
	\textbf{Read and complete the following --- otherwise your work will 
not be marked}\\\bigskip
The University has to ensure as far as possible that the work submitted by 
students is their own and that credit is not given for unreferenced material 
from other sources. The University statement `What constitutes 
plagiarism or cheating' appears in the Plagiarism Policy Document and in 
your Assessment Handbook and you are expected to have familiarised 
yourself with it. Please be aware that the University may subject your 
work to checks (including computerised checks) for plagiarism and in some 
instances may need to seek further information from you. Any cases where 
a basis for concern about the originality of the work is identified will be 
considered under the University's policy on academic conduct. 

I confirm that I have read the statement `What constitutes plagiarism or 
cheating' and that my answers will be my own work. \bigskip

Signature:\\[20pt]

\rule{\textwidth}{2pt}\\[20pt]

Name (in block capitals):\\[20pt]

\rule{\textwidth}{2pt}\\[20pt]

Personal identifier (PI): \\[20pt]

\rule{\textwidth}{2pt}\\[20pt]

}
\newcommand\declaration[1]{\DeclareRobustCommand\@oudeclaration{#1}}
%
\def\@oulogofilebase{OU_Master_LOGO_BLACK_17-5mmForA4width}
\newcommand\oulogofilebase[1]{\renewcommand\@oulogofilebase{#1}}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meta data can be set using \metadataset command, based on pgfkeys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pgfkeys{
 /meta data/.is family, /meta data,
   faculty/.store in=\@faculty,
   module code/.store in =\@modulecode,
   module title/.store in=\@moduletitle,
   presentation/.store in=\@ouyear,
   copyright year/.store in=\@copyrightyear,
   document title/.store in=\@outitle,
   document subtitle/.store in=\@ousubtitle,
   supp no/.store in=\@suppno,
   version no/.store in=\@versionno,
   cut off date/.store in=\@cutoffdate,
   covers material in/.store in=\@coversmaterialin,
   multiple choice option text/.code=\optiontext{#1},
   instructions/.store in=\@instructions,
   declaration/.store in=\@oudeclaration,
   ou logo file base/.store in=\@oulogofilebase,
}
\newcommand{\metadataset}[1]{%
    \pgfkeys{/meta data,#1}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{2pt}%
 \fancyfoot[L]{\large\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}\hfill \textbf{\@suppno}\\
\textbf{\@versionno} }%
}
\renewcommand{\maketitle}{
% Logo preamble:
\ifpdf%
  \def\@oulogofile{\@oulogofilebase.pdf}
\else%
  \def\@oulogofile{\@oulogofilebase.eps}
\fi%
%%
  \thispagestyle{frontpage}
  \vspace{2cm}
\begin{adjustwidth}{0cm}{-4cm}
  \begin{tabular}{@{}p{6.5cm}@{}p{11.5cm}@{}}
  \vspace{1.5cm}
  \IfFileExists{\@oulogofile}{%
    \includegraphics[]{\@oulogofile}%
  }{%
    \fbox{\parbox[t][17.5mm][c]{53.7mm}{\centering OU Logo}}%
  }%
&
\vspace{1.5cm}\textbf{\@faculty\newline
\@modulecode\ \@moduletitle}

\bigskip\bigskip\bigskip
\textbf{\Huge \@modulecode}\newline
\rule{10.5cm}{1pt}

\bigskip\bigskip\textbf{\Huge \@outitle}
\par\bigskip\textbf{\large \@ousubtitle}

\medskip\rule{10.5cm}{1pt}

\medskip\textbf{Covers \@coversmaterialin}

\medskip\textbf{Cut-off date: \@cutoffdate}

\nointerlineskip\vspace{12pt}
\end{tabular}
  \rule{17cm}{2pt}
\end{adjustwidth}

\begin{adjustwidth}{0cm}{-4cm}
  \raggedright
  \@instructions
  \end{adjustwidth}
\newpage
\vspace*{\fill}
\hfill \textbf{This page is intentionally left blank.}\hfill 
\vspace*{\fill} 
\newpage
\begin{adjustwidth}{0cm}{0cm}
  \topskip2cm
  \@oudeclaration
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
  \fancyfootoffset[RE,RO]{4cm} % lines up with full width on front page
  \fancyfoot[C]{page~\thepage~of~\zpageref{LastPage}} % internal right hand pages only
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
\def\boxtext{\protect{\marginnote{\ Answer:\hfill}[10pt]}}


\newcounter{question}
\definecolor{actvcolrule}{cmyk}{.3,.9,1,.3} %Confirmed dark brown, SR 22/01/09
\definecolor{actvcol}{cmyk}{.045,.135,.15,.045}
\newmdenv[linecolor=actvcolrule,backgroundcolor=actvcol,leftline=false,rightline=false,linewidth=1pt]{questionbox}
\newcommand{\question}{%
  \par\bigskip
  \begin{questionbox}
    \stepcounter{question}
    {\textbf{Question~\thequestion}}
    \boxtext
  \end{questionbox}
  \nopagebreak\par
  }



%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=1.0ex}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Marks
\newcommand{\mk}[1]{\marginnote{\hfill[\textsl{#1}]}}
%\def\marks{\ClassWarning{ouicma}{\protect\marks\space is deprecated. Please use \protect\mk\space(same syntax)}\mk}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Boxes for people to write their answers in
\newcommand{\answerbox}[1][1]{\marginnote{\ \tikz[scale=1.2]{\draw (0,0) grid (#1,1);}}[-10pt]}
\newcommand{\wideanswerbox}[1][1]{\marginnote{\ \tikz[xscale=2.4,yscale=1.2]{\draw (0,0) grid (#1,1);}}[-10pt]}


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
%
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
%
% notice at end of document
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\AtEndDocument{%
\par\bigskip\centering \bfseries%
	 [End of questions]
}%
%%
