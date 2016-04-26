%% Note that lines beginning with a % sign are ignored by LaTeX

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ouexam}[2015/12/10 v1.0 (Robert Brignall, all rights reserved)]
%% Handles options 
\newif\if@specimen
\@specimenfalse
\DeclareOption{specimen}{%
  \@specimentrue
}
\newif\if@secondspecimen
\@secondspecimenfalse
\DeclareOption{secondspecimen}{%
  \@secondspecimentrue
}
\newif\if@showsolutions
\@showsolutionsfalse
\DeclareOption{showsolutions}{%
 \@showsolutionstrue
}
\ProcessOptions\relax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\LoadClass[fleqn,12pt,onecolumn,twoside,a4paper]{article}
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=5cm,nohead,asymmetric]{geometry}%
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{changepage}
\RequirePackage{array}
\RequirePackage{amssymb}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amsthm}
\RequirePackage{lastpage}
\RequirePackage{ifthen}
\RequirePackage{enumitem}
\RequirePackage{marginnote}
\RequirePackage[xcolor]{mdframed}
\RequirePackage{verbatim}
\RequirePackage{barcodes}
%%


%\renewcommand{\baselinestretch}{1.3}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to set up module codes, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand\modulecode[1]{\renewcommand\@modulecode{#1}}
\newcommand\@modulecode{\@latex@error{No \noexpand\modulecode specified}\@ehc}
\newcommand\moduletitle[1]{\renewcommand\@moduletitle{#1}}
\newcommand\@moduletitle{\@latex@error{No \noexpand\moduletitle specified}\@ehc}

\newcommand\examtime[1]{\renewcommand\@examtime{#1}}
\newcommand\examday[1]{\renewcommand\@examday{#1}}
\newcommand\exammonth[1]{\renewcommand\@exammonth{#1}}
\newcommand\examyear[1]{\renewcommand\@examyear{#1}}
\if@specimen 
	\def\@examtime{\relax}
	\def\@examday{\relax}
	\def\@exammonth{\relax}
	\def\@examyear{\relax}
\else
	\if@secondspecimen
		\def\@examtime{\relax}
		\def\@examday{\relax}
		\def\@exammonth{\relax}
		\def\@examyear{\relax}
		
	\else
		\newcommand\@examtime{\@latex@error{No \noexpand\examtime specified}\@ehc}
		\newcommand\@examday{\@latex@error{No \noexpand\examday specified}\@ehc}
		\newcommand\@exammonth{\@latex@error{No \noexpand\exammonth specified}\@ehc}
		\newcommand\@examyear{\@latex@error{No \noexpand\examyear specified}\@ehc}
	\fi
\fi

\newcommand\timeallowed[1]{\renewcommand\@timeallowed{#1}}
\newcommand\@timeallowed{\@latex@error{No \noexpand\timeallowed specified}\@ehc}

\def\@copyrightyear{\@examyear}
\newcommand\copyrightyear[1]{\def\@copyrightyear{#1}}

\def\@examinstructions{No special instructions specified.}
\newcommand\examinstructions[1]{\renewcommand\@examinstructions{#1}}

\def\@conflation{C}
\if@specimen
	\def\@conflation{Specimen}
\else
	\if@secondspecimen
		\def\@conflation{Second Specimen}
	\fi
\fi


\newcommand\conflation[1]{\renewcommand\@conflation{#1}}
\def\@suppno{\relax} % default
\newcommand\suppno[1]{\DeclareRobustCommand\@suppno{#1}}
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BARCODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\font\barcodefont=wlc39 scaled 1300    % Size OK?
\newlength\barcodewidth
%
\newif\if@barcode
\@barcodefalse
%
\def\@examcode{\relax} % default blank
\newcommand\examcode[1]{%
  \@barcodetrue
  \DeclareRobustCommand\@examcode{#1}
  \def\bar@examcode{\barcodefont @#1@}
  \settowidth{\barcodewidth}{\bar@examcode}
}
%
% Makes parbox of correct width and inserts barcode
 \def\setbarcode
{%
  \if@barcode
  \relax
  \parbox[t]{\barcodewidth}{
    \bar@examcode%
\par
    \textsf{\@examcode}%
  }%
  \fi
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Footers for title page (copyright, etc)
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
    \fancyfoot[L]{\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}\hfill \textbf{\@suppno}\\
\textbf{\@versionno} }%
}
\newlength\titletablewidth
\setlength\titletablewidth{\dimexpr\textwidth-1cm} % width of RH column on front page
\renewcommand{\maketitle}{
  \thispagestyle{frontpage}
  \vspace*{1cm}
\begin{adjustwidth}{0cm}{-3.5cm} % N.B. positive measurements increase margins!
  \begin{tabular}{@{}p{4.5cm}@{}p{\titletablewidth}@{}}
  \vspace{1.5cm}
  \includegraphics[width=3.9cm]{ou_greyscale_masterlogo_29mm}%{ou_compact_grey_24mm}
&
\vspace{1.5cm}{\textbf{{\Huge \@modulecode\//\@conflation}} \hfill\ \setbarcode}\\ 
&
\raggedright\bfseries Module Examination \@examyear \newline

\vspace*{-10pt}
\@moduletitle\newline

\@examday\ \@exammonth\ \@examyear\hfill \@examtime\newline
\rule{\titletablewidth}{1pt}

\nointerlineskip\vspace{12pt}
{\if@showsolutions
{\hfill \textbf{\Large ***SOLUTIONS***}\hfill}
\else
{\hfill Time allowed:\ \@timeallowed\hfill}
\fi}

\nointerlineskip\vspace{12pt}
\rule{\titletablewidth}{1pt}
\end{tabular}
\end{adjustwidth}
\vspace{30pt}

  \begin{adjustwidth}{2cm}{-2cm}
  \raggedright
  \@examinstructions
  \end{adjustwidth}
  \newpage
}

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code for "TURN OVER" text to appear on all odd pages (except the last page)
\def\LastPagenum{\@ifundefined{r@LastPage}{0}{\expandafter
\expandafter\expandafter\@cdr
\csname r@LastPage\endcsname\@nil\null} }
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfootoffset[RE,RO]{\dimexpr\marginparsep+2cm} % lines up number with marks column
    %\fancyhead[RE, RO]{\textbf\thepage}%
    \fancyfoot[CO]{\ifthenelse{\not \value{page}=\LastPagenum}{\bfseries TURN OVER}{}} % internal right hand pages only
    \fancyfoot[LE,RO]{\bfseries\thepage}
    \fancyfoot[RE,LO]{\bfseries\@modulecode\ \if@specimen{Specimen}\else\if@secondspecimen{Second Specimen}\else{\@exammonth\ \@examyear}\fi\fi}  
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
%% Question headers
\newcounter{question}
\def\questiontext{Question}
\newcommand{\@question}[1][]{\refstepcounter{question}\par\bigskip{\bfseries \questiontext~\thequestion}\ #1\nopagebreak\par\nobreak\@afterheading}
\newcommand{\question}[1]{\@question #1}

%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=8mm,labelsep*=0pt}
\setlist[itemize]{align=left,leftmargin=8mm,labelsep*=0pt}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*)}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Options for multi-choice questions (as per CMAs in ouab.cls)

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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Marks
\newcommand{\bracketedmarks}[1]{\marginnote{\hfill[\textsl{#1}]\hspace*{3cm}}}
\newcommand{\solnmarks}[1]{\marginnote{\hfill\small #1\hspace*{3cm}}}
\newcommand{\solnmarksplus}[2]{\marginnote{\hfill\small \makebox[2cm][r]{#1}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright #2}}}}
\def\marks{\bracketedmarks}
\def\mk{\bracketedmarks}
\def\mkplus{\solnmarksplus}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Section headers:
%\renewcommand{\section}[1]{\@startsection
%{section}%                   % the name
%{1}%                         % the level
%{0mm}%                       % the indent
%{-\baselineskip}%            % the before skip
%{0.5\baselineskip}%          % the after skip
%{\large\bfseries\MakeUppercase}
%{SECTION \thesection: #1}} % the style
%\renewcommand{\subsection}{\@startsection
%{subsection}%                   % the name
%{2}%                         % the level
%{0mm}%                       % the indent
%{-0.5\baselineskip}%            % the before skip
%{0.25\baselineskip}%          % the after skip
%{\normalfont\bfseries}} % the style

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Solutions command
%% (Resets question counter, inserts [END OF QUESTION PAPER], etc)
\newif\if@solutions
\@solutionsfalse
\newcommand\solutions{%
\@solutionstrue
\setcounter{question}{0}
\def\questiontext{Solution to Question}
\par\bigskip\centering \textbf{[END OF QUESTION PAPER]}
\newpage
\raggedright
{\Huge\bfseries Solutions}\par
}
%
% NOTICE at end of exam paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\let\@oldenddochook\@enddocumenthook
\def\@enddocumenthook{%
\par\bigskip\centering \bfseries%
\if@solutions
	 [END OF SOLUTIONS]
\else
	[END OF QUESTION PAPER]
\fi
\@oldenddochook}
%%

%%%%%%%%%%%%%%%%%%
% EVERYTHING ABOVE HERE AS IN OUEXAM CLASS
\newmdenv[linewidth=3pt,topline=false,bottomline=false,rightline=false,innerrightmargin=5.5cm,innerleftmargin=10pt,linecolor=black,backgroundcolor=yellow!10,frametitle=Solution]{solutionbox}
\if@showsolutions
  \newenvironment{solution}
  {\def\marks{\solnmarks}\begin{adjustwidth}{-13pt}{-5.5cm}\begin{solutionbox}\small}
  {\end{solutionbox}\end{adjustwidth}\def\marks{\bracketedmarks}}
\else
  \newenvironment{solution}
  {\comment}
  {\endcomment}
\fi





