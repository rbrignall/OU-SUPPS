\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{outn}[2016/04/18 v0.2 (Robert Brignall, all rights reserved)]

\newif\if@studenttex
\@studenttexfalse
\DeclareOption{studenttex}{%
  \@studenttextrue
}
\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,10pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=5cm,marginparsep=-6ex,nohead,asymmetric]{geometry}%
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
%\RequirePackage[xcolor]{mdframed}
\RequirePackage{xparse,environ}
\if@studenttex
  \RequirePackage{l3regex,l3tl-analysis,l3str}
  \RequirePackage{answers}
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
\newcommand\tntitle[1]{\renewcommand\@tntitle{#1}}
\newcommand\@tntitle{\@latex@error{No \noexpand\tntitle specified}\@ehc}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footers for title page (copyright, etc)
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  %\renewcommand{\footrulewidth}{2pt}%
    \fancyfoot[L]{\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}}%
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
\end{tabular}
\end{adjustwidth}
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
  	\iffirstassignment\firstassignmentfalse\else\makebox[\textwidth][l]{\rule{\dimexpr\textwidth+\marginparwidth+\marginparsep}{2pt}}\bigskip\bigskip\fi
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
	\stepcounter{question}
	\par\bigskip{\textbf{Question~\thequestion}\ #1} -- #2 marks\nopagebreak\par}

%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=8mm,labelsep*=0pt}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%%%%%
%% Marks
\newcommand{\bracketedmarks}[1]{\marginnote{\hfill[\textsl{#1}]\hspace*{3cm}}}
\newcommand{\solnmarks}[1]{\marginnote{\hfill\small #1\hspace*{3cm}}}
\newcommand{\solnmarksplus}[2]{\marginnote{\hfill\small \makebox[2cm][r]{#1}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright #2}}}}
\def\marks{\bracketedmarks}
\def\mk{\marks}
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

%\newmdenv[linewidth=0pt,topline=false,bottomline=false,rightline=false,innerrightmargin=5.5cm,innerleftmargin=10pt,linecolor=black,frametitle=Solution to \thequestion]{solutionbox}
%
%\newenvironment{solution}
% {\def\marks{\solnmarks}\begin{adjustwidth}{-13pt}{-5.5cm}\begin{solutionbox}\small}
% {\end{solutionbox}\end{adjustwidth}\def\marks{\bracketedmarks}}
\if@studenttex
    \ExplSyntaxOn
    \NewEnviron{solution}
     {
      \def\marks{\solnmarks}
      \textbf{Solution}
      \par
      \strip_marks:V \BODY
     }[\def\marks{\bracketedmarks}]
     
    \tl_new:N \l_solution_text_tl
    \iow_new:N \g_solution_stream
  
    \cs_generate_variant:Nn \tl_replace_all:Nnn {NV}
    \cs_generate_variant:Nn \iow_now:Nn { NV }
    \str_const:Nx \c_other_eol_str { \cs_to_str:N \^^M }
    
    \cs_new_protected:Npn \strip_marks:n #1
    {
        \tl_set:Nn \l_solution_text_tl { #1 }
        \l_solution_text_tl % Send token list to normal output unmodified 
        %\tl_show_analysis:n { \l_solution_text_tl } % for debugging
        % Remove all instances of \marks{} commands
        \regex_replace_all:nnN { \c{marks}\cB\{ [^\}]* \cE\} } {  } \l_solution_text_tl
        \regex_replace_all:nnN { \c{marks} \w } {  } \l_solution_text_tl
        \regex_replace_all:nnN { \c{solnmarksplus}\cB\{ [^\}]* \cE\} \cB\{ [^\}]* \cE\} } {  } \l_solution_text_tl
        \regex_replace_all:nnN { \c{solnmarksplus} ^[\}|\{] } {  } \l_solution_text_tl
        \regex_replace_all:nnN { \c{mk}\cB\{ [^\}]* \cE\} } {  } \l_solution_text_tl
        \regex_replace_all:nnN { \c{mk} \w } {  } \l_solution_text_tl
        %\regex_replace_all:nnN { \r } { BLOB } \l_solution_text_tl
        \iow_now:Nx \g_solution_stream {Solution~to~Question~\thequestion}
        \iow_now:NV \g_solution_stream \l_solution_text_tl % Send modified token list to stream.
    }
    \cs_generate_variant:Nn \strip_marks:n { V }
    
    \AtBeginDocument{
      \iow_open:Nn \g_solution_stream { \jobname-student.tex }
      \def\solnpreamble{\documentclass{article}\usepackage{amsmath}\begin{document}}
      \iow_now:Nn \g_solution_stream {\documentclass{article}\usepackage{amsmath}\begin{document}}
    }
    \AtEndDocument{
      \iow_now:Nn \g_solution_stream{\end{document}}
      \iow_close:N \g_solution_stream
    }
    \ExplSyntaxOff
\else %matches \if@studenttex
  \NewEnviron{solution}
  {
    \textbf{Solution}
    \par
    \BODY
  }
\fi

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
