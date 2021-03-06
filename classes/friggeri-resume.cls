\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{friggeri-resume}[2016/12/06 Resume based on friggeri template]

\DeclareOption{print}{\def\@resume@print{}}
\DeclareOption*{%
	\PassOptionsToClass{\CurrentOption}{article}
}
\ProcessOptions\relax
\LoadClass{article}

%%%%%%%%%%%%
% Packages %
%%%%%%%%%%%%

\RequirePackage[french, english]{babel}
\RequirePackage{xcolor}
\RequirePackage{etoolbox}
\RequirePackage{tikz}
\RequirePackage[quiet]{fontspec}
\RequirePackage{fontawesome}
\RequirePackage[math-style=TeX, vargreek-shape=unicode]{unicode-math}
\RequirePackage{ifthen}
\RequirePackage{parskip}
\RequirePackage[absolute, overlay]{textpos}
\RequirePackage[left=6.1cm, top=2cm, right=1.5cm, bottom=1.5cm, nohead, nofoot]{geometry}
\RequirePackage{hyperref}

%%%%%%%%%%%%%%%%
% NEW COMMANDS %
%%%%%%%%%%%%%%%%

% \checkjobname : stop compiling if jobname is not french or english
\newcommand{\checkjobname}{%
	\newcounter{foo}
	\setcounter{foo}{0}
	\ifnum\pdfstrcmp{\jobname}{french}=0
		\selectlanguage{french}
		\stepcounter{foo}
	\fi
	\ifnum\pdfstrcmp{\jobname}{english}=0
		\selectlanguage{english}
		\stepcounter{foo}
	\fi
	\ifnum\the\value{foo}=0
		\message{Error : bad jobname ! Must be : french or english !}
		\stop
	\fi
}

% this is the macro to define phrases in two languages:
\newcommand{\trad}[2]{%
	\expandafter\ifstrequal\expandafter{\jobname}{french}{%
		#1%
	}{%
		#2%
	}%
}%

%%%%%%%%%%
% Colors %
%%%%%%%%%%

\definecolor{white}{RGB}{255,255,255}
\definecolor{darkgray}{HTML}{333333}
\definecolor{gray}{HTML}{4D4D4D}
\definecolor{lightgray}{HTML}{999999}
\definecolor{green}{HTML}{C2E15F}
\definecolor{orange}{HTML}{FDA333}
\definecolor{purple}{HTML}{D3A4F9}
\definecolor{red}{HTML}{FB4485}
\definecolor{blue}{HTML}{6CE0F1}

\ifdefined\@resume@print
	\colorlet{green}{gray}
	\colorlet{orange}{gray}
	\colorlet{purple}{gray}
	\colorlet{red}{gray}
	\colorlet{blue}{gray}
	\colorlet{fillheader}{white}
	\colorlet{header}{gray}
\else
	\colorlet{fillheader}{gray}
	\colorlet{header}{white}
\fi

\colorlet{textcolor}{gray}
\colorlet{headercolor}{gray}

%%%%%%%%%
% Fonts %
%%%%%%%%%

\newfontfamily\bodyfont[]{Helvetica Neue}
\newfontfamily\thinfont[]{Helvetica Neue UltraLight}
\newfontfamily\headingfont[]{Helvetica Neue Condensed Bold}

\defaultfontfeatures{Mapping=tex-text}

\setmainfont[Mapping=tex-text, Color=textcolor]{Helvetica Neue Light}
\setmathfont{XITS Math}

%%%%%%%%%%
% Header %
%%%%%%%%%%

\newcommand{\header}[3]{%
	\begin{tikzpicture}[remember picture, overlay]
		\node [rectangle, fill=fillheader, anchor=north, minimum width=\paperwidth, minimum height=4cm] (box) at (current page.north){};
		\node [anchor=center] (name) at (box) {%
			\fontsize{40pt}{72pt}\color{header} % Header first line size
			{\thinfont #1}{\bodyfont #2}
		};
		\node [anchor=north] at (name.south) {%
			\fontsize{20pt}{24pt}\color{header} % Header first second size
			\thinfont #3
		};
	\end{tikzpicture}
	\vspace{2.5cm}
	\vspace{-2\parskip}
}

%%%%%%%%%%%%%
% Structure %
%%%%%%%%%%%%%

\newcounter{colorCounter}

\def\@sectioncolor#1{%
	{%
		\color{%
		\ifcase\value{colorCounter}
			blue\or
			red\or
			orange\or
			green\or
			purple\else
			headercolor\fi
		} #1
	}
	\stepcounter{colorCounter}
	%reset the counter once we exhaust all colours
	\ifthenelse{\equal{\value{colorCounter}}{6}}{%
		\setcounter{colorCounter}{0}
	}{}
}

\renewcommand{\section}[1]{%
	\par\vspace{\parskip}
	{%
		\LARGE\headingfont\color{headercolor}
		\@sectioncolor #1
	}
	\par\vspace{\parskip}
}

\pagestyle{empty}

%%%%%%%%%%%%%%%%%%%%
% List environment %
%%%%%%%%%%%%%%%%%%%%

\setlength{\tabcolsep}{0pt}
\renewcommand{\bfseries}{%
	\headingfont\color{headercolor}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% New command to insert a new "experience"
\newcommand{\Experience}[6]{%
	\begin{tabular*}{14.5cm}{p{2cm}p{12.5cm}}
		#1 & \textbf{#2}                                   \hfill \textbf{#3}                                   \\
		   & {\addfontfeature{Color=lightgray}\textit{#4}} \hfill {\addfontfeature{Color=lightgray}\textit{#5}} \\
		   & \begin{minipage}{11.5cm}
		   		#6
			 \end{minipage}                                                                                     \\
	\end{tabular*}
}

% New command to insert a new "education"
\newcommand{\Education}[4]{%
	\begin{tabular*}{14.5cm}{p{2cm}p{12.5cm}}
		#1 & \textbf{#2} \hfill {\addfontfeature{Color=lightgray}\textit{#3}} \\
		   & \begin{minipage}{11.5cm}
		   		#4
			 \end{minipage}                                                   \\
	\end{tabular*}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% New command to insert 2 references
\newcommand{\References}[8]{%
	\begin{tabular*}{14.5cm}{p{2cm}p{6.25cm}p{6.25cm}}
		& \textbf{#1}                                   & \textbf{#5}                                   \\
		& #2                                            & #6                                            \\
		& {\addfontfeature{Color=lightgray}\textit{#3}} & {\addfontfeature{Color=lightgray}\textit{#7}} \\
		& #4                                            & #8                                            \\
	\end{tabular*}
}

%%%%%%%%%%%%%%
% Side block %
%%%%%%%%%%%%%%

\setlength{\TPHorizModule}{1cm}
\setlength{\TPVertModule}{1cm}

\newenvironment{aside}{%
	\let\oldsection\section
	\renewcommand{\section}[1]{%
		\par\vspace{\baselineskip}{\Large\headingfont\color{headercolor} ##1}
	}
	\begin{textblock}{4.3}(0.75, 4.33) % {largeur}(horizontal position, vertical position)
	\begin{flushright}
	\obeycr
}{%
	\restorecr
	\end{flushright}
	\end{textblock}
	\let\section\oldsection
}

%%%%%%%%%%%%%%%%
% Other tweaks %
%%%%%%%%%%%%%%%%

\hypersetup{%
	colorlinks=true,
	linkcolor=false,
	citecolor=false,
	filecolor=false,
	urlcolor = false
}

% A fix for \href{}{} colors not working with fontspec
\makeatletter
\def\HyColor@@@@UseColor#1\@nil{%
	\addfontfeatures{Color=#1}
}
\makeatother
