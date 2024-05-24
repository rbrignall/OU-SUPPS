\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ouexam}[2024/04/17 v3.0.1 (Robert Brignall, all rights reserved)]

%% Handles options

\newif\if@showsolutions
\@showsolutionsfalse
\DeclareOption{qp-and-ss}{%
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
    \ifnum\buildmode=1\relax\fi %Question paper
    \ifnum\buildmode=2\@showsolutionstrue\fi %Solutions
}
\newif\if@specimen
\@specimenfalse
\DeclareOption{specimen}{%
  \@specimentrue
}
\newif\if@secondspecimen
\@secondspecimenfalse
\DeclareOption{secondspecimen}{%
  \ExecuteOptions{specimen}
  \@secondspecimentrue
}
\newif\if@specimensolutions
\@specimensolutionsfalse
\newif\if@hidequestions
\@hidequestionsfalse
\DeclareOption{solutionsonly}{%
%
 \ifnum\ifx\buildmode\undefined 1\else\ifnum\buildmode=1 0\else1\fi\fi=1
   \@hidequestionstrue
 \fi
 \ExecuteOptions{@showsolutions}
}
\DeclareOption{showsolutions}{%
 % true unless \buildmode not defined or \buildmode=1
 \ExecuteOptions{@showsolutions}
}
\DeclareOption{specimensolutions}{%
 \@specimentrue
 \ExecuteOptions{@showsolutions}
}
\DeclareOption{@showsolutions}{%
  \ifnum\ifx\buildmode\undefined 1\else\ifnum\buildmode=1 0\else1\fi\fi=1
    \@showsolutionstrue
  \fi
}
%
\newif\if@bigfontneeded
\@bigfontneededfalse
\DeclareOption{14pt}{%
 \@bigfontneededtrue
 \def\@txtsize{14pt}
}
\DeclareOption{17pt}{%
 \@bigfontneededtrue
 \def\@txtsize{17pt}
}
\DeclareOption{20pt}{%
 \@bigfontneededtrue
 \def\@txtsize{20pt}
}
\newif\if@smallmargins
\DeclareOption{smallmargins}{%
  \@smallmarginstrue
}
\newif\if@nobarcode
\@nobarcodefalse
\DeclareOption{nobarcode}{%
	\@nobarcodetrue
}
\newif\if@remoteexam
\@remoteexamfalse
\DeclareOption{remote}{%
	\@remoteexamtrue
	\@nobarcodetrue
}
\ProcessOptions\relax
%%
%% Some option postprocessing:
\if@specimen
  \if@showsolutions
    \@specimensolutionstrue
    \@hidequestionstrue
  \fi
\fi
\if@showsolutions
  \def\ssonly#1{#1}
  \def\qponly#1{\relax}
\else
  \def\ssonly#1{\relax}
  \def\qponly#1{#1}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages/class file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@specimensolutions
  \LoadClass[fleqn,11pt,onecolumn,twoside,a4paper]{article}
\else
  \LoadClass[fleqn,12pt,onecolumn,twoside,a4paper]{article}
\fi
\if@bigfontneeded
	\RequirePackage[\@txtsize]{extsizes}
\fi
\RequirePackage[a4paper,left=2cm,right=6cm,top=1cm,bottom=3cm,marginparwidth=5cm,nohead,asymmetric]{geometry}%
\RequirePackage{fancyhdr}
\RequirePackage{graphicx}
\RequirePackage{changepage}
\RequirePackage{array}
\RequirePackage{amssymb}
\RequirePackage[fleqn]{amsmath}
\RequirePackage{amsthm}
\RequirePackage[user,lastpage]{zref}
\RequirePackage{ifthen}
\RequirePackage[inline]{enumitem}
\RequirePackage{marginnote}
\RequirePackage{caption} % Fixes figure captions to OU style
\captionsetup{justification=raggedright,format=plain,labelsep=quad,labelfont={normalsize,bf},singlelinecheck=false,font={normalsize,stretch=1.25}}
\if@showsolutions%
	\if@specimensolutions%
		\RequirePackage{xcolor}
	\else%
	% Suppressed if not displaying solutions
        \RequirePackage[breakable]{tcolorbox}
    \fi%
\else
	\RequirePackage{xcolor}
\fi%
\RequirePackage{verbatim}
\RequirePackage{pgfkeys}
\RequirePackage{iftex}
\if@nobarcode
	\relax
\else
    \RequirePackage[code=Code39,X=.364mm,ratio=2.3,H=0.63cm]{makebarcode}
\fi

%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters to set up module codes, etc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\@faculty{Faculty of Science, Technology, Engineering and Mathematics} % only used in specimensolutions
\newcommand\faculty[1]{\DeclareRobustCommand\@faculty{#1}}
%
\newcommand\modulecode[1]{\renewcommand\@modulecode{#1}}
\newcommand\@modulecode{\@latex@error{No \noexpand\modulecode specified}\@ehc}
%
\newcommand\moduletitle[1]{\renewcommand\@moduletitle{#1}}
\newcommand\@moduletitle{\@latex@error{No \noexpand\moduletitle specified}\@ehc}
%
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
    \newcommand\@examtime{\@latex@error{No \noexpand\examtime specified}\@ehc}
    \newcommand\@examday{\@latex@error{No \noexpand\examday specified}\@ehc}
    \newcommand\@exammonth{\@latex@error{No \noexpand\exammonth specified}\@ehc}
    \newcommand\@examyear{\@latex@error{No \noexpand\examyear specified}\@ehc}
\fi
%
\newcommand\timeallowed[1]{\renewcommand\@timeallowed{#1}}
\newcommand\@timeallowed{\@latex@error{No \noexpand\timeallowed specified}\@ehc}
%
\def\@copyrightyear{\@examyear}
\newcommand\copyrightyear[1]{\def\@copyrightyear{#1}}
%
\def\@examinstructions{No special instructions specified.}
\newcommand\examinstructions[1]{\renewcommand\@examinstructions{#1}}
%
\def\@foottext{%
  \if@specimen
    \if@secondspecimen{Second specimen}%
    \else{Specimen}%
    \fi
  \else{\@exammonth\ \@examyear}%
  \fi
}
\def\@session{\relax}
\if@specimen
	\def\@session{/\@foottext}
\fi
%
\def\@specimensolutionstitle{Solutions to the \@foottext\ Examination Paper}
\newcommand\specimensolutionstitle[1]{\def\@specimensolutionstitle{#1}}
%
\newcommand\conflation[1]{\renewcommand\@session{#1}\ClassWarning{ouexam}{\protect\conflation\space is deprecated. Please use \protect\session\space(same syntax)}} % backwards compatibility
\newcommand\session[1]{\renewcommand\@session{/#1}}
\def\@submitby{\relax}
\newcommand\submitby[1][23:59 BST]{\DeclareRobustCommand\@submitby{Submit by:\ #1}}
\def\@suppno{\relax} % default
\newcommand{\suppno}{\@dblarg\@setsuppno}
\def\@setsuppno[#1]#2{
  \if@specimensolutions
    \DeclareRobustCommand\@suppno{#1}
  \else
    \DeclareRobustCommand\@suppno{#2}
  \fi
}
\def\@versionno{\relax} % default blank
\newcommand\versionno[1]{\DeclareRobustCommand\@versionno{#1}}
%
\if@specimensolutions
  \def\@oulogofilebase{OU_Master_LOGO_BLACK_17-5mmForA4width}
  \def\@logow{4.0cm}
  \def\@logoh{1.24cm}
\else
  \def\@oulogofilebase{OU_Compact_LOGO_BLACK_40mm}
  \def\@logow{2.37cm}
  \def\@logoh{4.0cm}
\fi
\newcommand\oulogofilebase[1]{\renewcommand\@oulogofilebase{#1}}
%
\newif\if@switchmarks
\@switchmarksfalse
\newcommand\switchmarks{\@switchmarkstrue}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BARCODE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\newif\if@barcode
\@barcodefalse
%
\def\@examcode{\relax} % default blank
\if@nobarcode % Set by nobarcode option to class as override
	\if@remoteexam
	  \newcommand\examcode[1]{%
	    \DeclareRobustCommand\@examcode{#1}
	  }
 	\else
	  \newcommand\examcode[1]{\relax}
	\fi
\else
	\newlength\barcodewidth
	\newcommand\examcode[1]{%
	  \@barcodetrue
	  \DeclareRobustCommand\@examcode{#1}
	  \def\bar@examcode{\barcode{#1}}
	  \settowidth{\barcodewidth}{\bar@examcode}
	}
\fi
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
 \def\setqpid
{%
  \if@remoteexam
    \if@specimen\relax%
    \else%
      \footnotesize \hfill QP ID: \@examcode
    \fi
  \else
    \relax
  \fi
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Meta data can be set using \metadataset command, based on pgfkeys
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pgfkeys{
 /meta data/.is family, /meta data,
   module code/.store in =\@modulecode,
   session/.store in =\@session,
   module title/.store in=\@moduletitle,
   specimen solutions title/.store in=\@specimensolutionstitle,
   exam code/.code=\examcode{#1},
   exam time/.store in =\@examtime,
   exam day/.store in=\@examday,
   exam month/.store in=\@exammonth,
   exam year/.store in=\@examyear,
   time allowed/.store in=\@timeallowed,
   copyright year/.store in=\@copyrightyear,
   supp no/.store in=\@suppno,
   version no/.store in=\@versionno,
   faculty/.store in=\@faculty,
   multiple choice option text/.store in=\@optiontext,
   instructions/.store in=\@examinstructions,
   top padding/.code=\setlength\toppadding{#1},
   ou logo file base/.store in=\@oulogofilebase,
   switch marks/.is if=@switchmarks,
}
\newcommand{\metadataset}[1]{%
    \pgfkeys{/meta data,#1}%
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title page
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Footers for title page (copyright, etc)
% First, some lengths that depend on whether were SSEP or an exam
\newlength\@titlefooterleftindent
\newlength\@titlefooterrightindent
\if@specimensolutions%
	\setlength\@titlefooterleftindent{0cm}
	\setlength\@titlefooterrightindent{-2.5cm}
\else%
	\setlength\@titlefooterleftindent{0cm}
	\setlength\@titlefooterrightindent{-1cm}
\fi%
\fancypagestyle{frontpage}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
    \fancyfoot[L]{%
    \begin{adjustwidth}{\@titlefooterleftindent}{\@titlefooterrightindent}%
    	\textbf{Copyright \copyright\ \@copyrightyear\ The Open University}
		\if@specimensolutions\relax \else\\
        	{\footnotesize You have been provided with this question paper for your personal use, either for end-of-module assessment or (if you downloaded this paper from the OUSA website) to help you prepare for a future exam. You are not permitted to pass on this question paper, or any of its contents, to any website, online service, social media platform or any individual or organisation, as this is an infringement of the University's copyright and a disciplinary offence under Section SD 1.2 of the University's Code of Practice for Student Discipline.}\\
	        \setqpid
		\fi
		\textbf{\@versionno}\hfill \textbf{\@suppno}%
	\end{adjustwidth}%
	}%
}
\newlength\titletablewidth
\setlength\titletablewidth{\dimexpr\textwidth-1cm} % width of RH column on front page
\newlength\toppadding
\setlength\toppadding{0cm} % allows users to adjust space at top if desired
%%
%%
% Maketitle command %
\renewcommand{\maketitle}{%
%% First, set up PDF metadata
 \pdfinfo{
   /Author (The Open University)
   /Title  (\@modulecode\ Exam\ \@examyear)
}%
% Logo preamble:
\ifpdf%
  \def\@oulogofile{\@oulogofilebase.pdf}
\else%
  \def\@oulogofile{\@oulogofilebase.eps}
\fi%
%%
  \if@specimensolutions\relax\else
    \newgeometry{left=2cm,right=6cm,top=1cm,bottom=5.5cm,footskip=4.94mm,marginparwidth=5cm,nohead,asymmetric}
  \fi
  \thispagestyle{frontpage}%
  \vspace*{\dimexpr\toppadding-\topskip}% Subtract \topskip which gets inserted
  \begin{adjustwidth}{0pt}{-3.5cm} % N.B. positive measurements increase margins!
     \if@specimensolutions%
  	\@makespecimensolutionstitle
     \else%
  	\@makestandardtitle
     \fi
  \end{adjustwidth}
  \if@specimensolutions\relax\else
    \restoregeometry
  \fi
  \if@smallmargins% Adjust geometry for future pages
    \newgeometry{a4paper,left=1cm,right=4cm,top=1cm,bottom=3cm,marginparwidth=5cm,nohead,asymmetric}%
  \fi%
}
%%
\def\@makestandardtitle{%
     \if@bigfontneeded
    	\fontsize{14.4}{18}\selectfont % Equates to \large in 12pt for most of the title page
     \fi
     \hfill\ \setbarcode\par\bigskip % New location for longer barcodes
     \begin{tabular}{@{}p{4cm}@{}p{\titletablewidth}@{}}%
        \vspace{-0.7cm}%
    	  \IfFileExists{\@oulogofile}{%
              \includegraphics[scale=1.0]{\@oulogofile}%
            }{%
              \fbox{\parbox[t][\@logoh][c]{\@logow}{\centering OU Logo}}%
            }%
     &
    	{\textbf{{\fontsize{24.88}{30}\selectfont \@modulecode\/\@session}}}\newline

    	\raggedright\bfseries Module Examination \@examyear \newline
    	
    	\vspace*{-10pt}
    	\@moduletitle\newline
    	
    	{\if@remoteexam
	  {\@examday\ \@exammonth\ \@examyear\hfill \@submitby\newline}
	\else
	  {\@examday\ \@exammonth\ \@examyear\hfill \@examtime\newline}
	\fi}
    	
    	\nointerlineskip\vspace{12pt}
     	{\if@showsolutions
    	  {\hfill \textbf{\fontsize{17.28}{22}\selectfont ***SOLUTIONS***}\hfill} %Equates to \Large in 12pt, \LARGE in 11pt
    	  \par\nointerlineskip\vspace{12pt}
    	  \rule{\titletablewidth}{1pt}
    	\else
	  {\if@remoteexam
	    {\relax}
	  \else
	    {\hfill Time allowed:\ \@timeallowed\hfill}
    	    \par\nointerlineskip\vspace{12pt}
    	    \rule{\titletablewidth}{1pt}
	  \fi}
    	\fi}
    \end{tabular}
    \vspace{20pt}
	
	\raggedright
	\@examinstructions
    \clearpage}
%%
\def\@makespecimensolutionstitle{%
    \begin{tabular}{@{}p{4.6cm}@{}p{\titletablewidth}@{}}%
        \vspace{-0.3cm}%
    	  \IfFileExists{\@oulogofile}{%
              \includegraphics[width=4.0cm]{\@oulogofile}%
            }{%
              \fbox{\parbox[t][\@logoh][c]{\@logow}{\centering OU Logo}}%
            }%
    &
	\if@bigfontneeded
		\fontsize{14.4}{18}\selectfont\raggedright\textbf{\@faculty}\newline
		\textbf{\@modulecode\ \@moduletitle}\\
		\fontsize{24.88}{30}\selectfont \raggedright \textbf{\@modulecode\ \@specimensolutionstitle}
	\else
	  	\raggedright\textbf{\@faculty}\newline
                \textbf{\@modulecode\ \@moduletitle}\newline

	        \LARGE\raggedright \textbf{\@modulecode\ \@specimensolutionstitle}
	\fi
    \end{tabular}
    \vspace{30pt}	
}
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Code for "TURN OVER" text to appear on all odd pages (except the last page)
%% Set up footer info
\fancypagestyle{internalpages}{%
  \fancyhf{} % clear all header and footer fields
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}%
  \fancyfootoffset[RE,RO]{\dimexpr\marginparsep+2cm} % lines up number with marks column
  \if@specimensolutions %only show page numbers for specimen solutions
	\fancyfoot[C]{page~\thepage~of~\zpageref{LastPage}}
  \else %not specimen solutions
    \if@remoteexam
	  \fancyfoot[R]{\bfseries\thepage~of~\zpageref{LastPage}}
	  \fancyfoot[C]{\ifthenelse{\zref@extractdefault{LastPage}{page}{0}=\value{page}}{\relax}{\bfseries CONTINUED}}
	  \if@bigfontneeded %display only module code on L to avoid text clashes
	    \fancyfoot[L]{\bfseries\@modulecode\if@specimen{\ \@foottext}\fi}
	  \else
	    \fancyfoot[L]{\bfseries\@modulecode\ \@foottext}
	  \fi
    \else % not remote exam
 	  \fancyfoot[LE,RO]{\bfseries\thepage}
	  \fancyfoot[CO]{\ifthenelse{\zref@extractdefault{LastPage}{page}{0}=\value{page}}{\relax}{\bfseries TURN OVER}}% internal right hand pages only
	  \if@bigfontneeded %suppress module code on LO to avoid text clashes
	    \fancyfoot[RE]{\bfseries\@modulecode\ \@foottext}
	  \else
	    \fancyfoot[RE,LO]{\bfseries\@modulecode\ \@foottext}
	  \fi
    \fi
  \fi
}
\pagestyle{internalpages}
%
\setcounter{secnumdepth}{3}

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
%% Question headers
\newcounter{question}
\def\questiontext{Question}
\newcommand{\@question}[1][]{%
    \refstepcounter{question}
    \gsetlength{\subtot@l}{0pt}\gsetlength{\tot@l}{0pt}
    \par\bigskip{\bfseries \questiontext~\thequestion}\ #1\nopagebreak\par\nobreak\@afterheading}
\newcommand{\question}[1]{\@question #1}

%% Question wrapper environment
\if@hidequestions%
    \newenvironment{questionblock}{\comment}{\endcomment}
\else
    \newenvironment{questionblock}{}{}
\fi
%% Subquestion settings -- all controlled by enumerate with enumitem
\setlist{itemsep=2pt,topsep=0pt,partopsep=0pt}
\setlist[enumerate]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=1.0ex}
\setlist[itemize]{align=left,leftmargin=!,labelwidth=4ex,labelsep*=-0.25ex}
\setlist[enumerate,1]{label=(\alph*), ref=(\alph*)}
\setlist[enumerate,2]{label=(\roman*), ref=(\roman*),leftmargin=9mm}
%%
%% "Inline" lists, using inline option of enumitem:
\renewlist{enumerate*}{enumerate*}{3}
\setlist*[enumerate*]{before=\vspace{6pt}\newline,itemjoin=\hspace{50pt}}
\setlist*[enumerate*,1]{label=(\roman*), ref=(\roman*)}
%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Horizontal lines after subtotals and totals
\newif\ifdraw@total@line
\newif\ifdraw@subtotal@line
\newif\ifdraw@ourule@line

% reference: http://tex.stackexchange.com/questions/34312/how-to-create-a-command-with-key-values
\pgfkeys{
 /totalhline/.is family, /totalhline,
 default/.style =
  {moveleft=0pt,
   movedown=0pt,
   width=\dimexpr\textwidth+5cm,
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
  {moveleft=0pt,
   movedown=0pt,
   width=\dimexpr\textwidth+5cm,
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
    % DIFFERENT FROM OUTN: use \rlap{\hrule...} because of solutions environment.
    \color{#3}\rlap{\rule{\hsize}{#4}}% height #4 width\hsize % the rule
    \kern3pt % space after the rule
  }\nointerlineskip % no additional space after the rule
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Marks, totals, subtotals
% @update@totals and auxiliary functions as per outn.cls
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
    % Check if empty, and if not deploy \testreal
    \expandafter\ifx\expandafter\relax\detokenize{#1}\relax\@nantrue%
    \else%
        \edef\tmp{\testleadneg{\detokenize{#1}}\relax}%
        \expandafter\testreal\tmp\relax%
    \fi%
    % Add to counter if a number
    \if@nan%
      #1% Render content as-is
    \else%
      \ifmeasuring@\relax\else
        \global\advance\subtot@l#1\p@%
        \global\advance\tot@l#1\p@%
      \fi
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
% Now define mark commands
\newcommand{\bracketedmarks}[1]{%
	\marginnote{%
		\if@switchmarks\if@showsolutions\makebox[3cm][r]{\relax}\fi\fi%
		\makebox[2cm][r]{[\textsl{#1}]\if@switchmarks\if@showsolutions\hspace{0.5cm}\fi\fi}\hfill%
	}%
}
%
% Solnmarks -- rendering marks within solution environments
\def\solnmarks{\@ifstar\@solnmarks\@@solnmarks}
% \solnmarks*[]{}, doesn't affect @update@totals
\newcommand{\@solnmarks}[2][\unskip]{%
	\@solnmarksbox{#1}{#2}%
}	
\newcommand{\@@solnmarks}[2][\unskip]{%
    \@solnmarksbox{#1}{\@update@totals{#2}}%
}
\newcommand{\@solnmarksbox}[2]{%
	\marginnote{\hfill\footnotesize\sf %
		\if@switchmarks%
			\hfill\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright #1}}\makebox[1cm][r]{#2\hspace{0.5cm}}%
		\else%
			\makebox[2cm][r]{#2}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright #1}}%
		\fi%
	}%
}	
%
\newcommand{\solnmarksplus}[2]{\solnmarks[#2]{#1}\ClassWarning{ouexam}{\protect\solnmarksplus\space is deprecated. Please use \protect\mk\space}}
\newcommand{\mkplus}[2]{\solnmarks[#2]{#1}\ClassWarning{ouexam}{\protect\mkplus\space is deprecated. Please use \protect\mk\space}}
\def\mk{\bracketedmarks}
%
%% Definition of \total and \subtotal
\def\total{\@ifstar\@total\@@total}
\def\subtotal{\@ifstar\@subtotal\@@subtotal}
% \total*
\newcommand{\@total}[1][\unskip]{%
    \strut\marginnote{\sf\bfseries %
		\if@switchmarks%
			\hfill\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Total\ #1}}\makebox[1cm][r]{\thetotal\hspace{0.5cm}}%
     	\else%
			\makebox[2cm][r]{\thetotal}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Total\ #1}}%
		\fi%
	}%
	\nopagebreak\gsetlength{\subtot@l}{0pt}\gsetlength{\tot@l}{0pt}\outn@draw@total@rule%
}%
% \total[]{}
\newcommand{\@@total}[2][\unskip]{%
    \strut\marginnote{\sf\bfseries %
		\if@switchmarks%
			\hfill\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Total\ #1}}\makebox[1cm][r]{#2\hspace{0.5cm}}%
     	\else%
			\makebox[2cm][r]{#2}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Total\ #1}}%
		\fi%
	}%
	\nopagebreak\gsetlength{\subtot@l}{0pt}\gsetlength{\tot@l}{0pt}\outn@draw@total@rule%
}
% \subtotal*
\newcommand{\@subtotal}[1][\unskip]{%
    \strut\marginnote{\small\sf\bfseries %
		\if@switchmarks%
			\hfill\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Subtotal\ #1}}\makebox[1cm][r]{\thesubtotal\hspace{0.5cm}}%
     	\else%
			\makebox[2cm][r]{\thesubtotal}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Subtotal\ #1}}%
		\fi%
	}%
	\nopagebreak\gsetlength{\subtot@l}{0pt}\outn@draw@subtotal@rule%
}
% \subtotal[]{}
\newcommand{\@@subtotal}[2][\unskip]{%
   	\strut\marginnote{\small\sf\bfseries %
		\if@switchmarks%
			\hfill\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Subtotal\ #1}}\makebox[1cm][r]{#2\hspace{0.5cm}}%
    	\else%
			\makebox[2cm][r]{#2}\makebox[3cm][r]{\parbox[t]{2.75cm}{\raggedright Subtotal\ #1}}%
		\fi%
	}%
	\nopagebreak\gsetlength{\subtot@l}{0pt}\outn@draw@subtotal@rule%
}
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
%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Newpage commands
\newcommand{\sspagebreak}{\if@showsolutions\pagebreak\fi}
\newcommand{\solutionbreak}{\sspagebreak}
\newcommand{\qppagebreak}{\if@showsolutions\else\pagebreak\fi}
\newcommand{\questionbreak}{\qppagebreak}
\newcommand{\ssnewpage}{\if@showsolutions\newpage\fi}
\newcommand{\qpnewpage}{\if@showsolutions\else\newpage\fi}
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
\par\bigskip\centering \textbf{\@endtext}
\newpage
\raggedright
{\Huge\bfseries Solutions}\par
}
%
% NOTICE at end of exam paper
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \putendtext command allows hook to be placed
% before AtEndDocument (e.g. to insert blank pages at the end)
\def\@endtext{[END OF QUESTION PAPER]}
\newcommand\putendtext{%
	{\par\bigskip\centering \bfseries%
	\@endtext\par
	}
	\def\@endtext{\relax}
}

\AtEndDocument{%
\par\bigskip\centering \bfseries%
\if@specimensolutions
	\relax
\else
	\if@solutions
		 [END OF SOLUTIONS]
	\else
		\@endtext	
	\fi
\fi
}%
%%

%%%%%%%%%%%%%%%%%%
% Solutions environment: need to pull out solutions for spec papers and present differently.
%
\if@showsolutions%
	\if@specimensolutions%
		% Don't want to use tcolorbox here
		\newenvironment{solution}{%
			\def\mk{\solnmarks}%
  		}{}
	\else
		% Regular solutions: use tcolorbox environment to define box
        \newtcolorbox{solutionbox}{%
            colframe=black,arc=0pt,toprule=-.2pt,rightrule=-.2pt,bottomrule=-.2pt,leftrule=3pt,
            width=\textwidth,left=10pt,grow to left by=13pt,right=5.5cm,add to width=5.5cm,
            fonttitle=\bfseries,title=Solution,coltitle=black,attach title to upper,after title={\par\medskip},
            colback=yellow!10,parbox=false,breakable}
	    % Now define the wrapper
	    \newenvironment{solution}{%
            \def\mk{\solnmarks}%
            \begin{solutionbox}\raggedright\small}%
            {\end{solutionbox}}
    \fi
\else
	% Suppress anything in the solution environment.
    \newenvironment{solution}
        {\comment}
        {\endcomment}
\fi
