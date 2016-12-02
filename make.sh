#!/usr/local/bin/bash
set -u

function USAGE() {
	printf "Usage:\n %s -t TEXFILE [-l LANG] [-n NAME]\n\n" $( basename ${0} )
	echo "Required argument : "
	echo " -t TEXFILE"
	echo "Options :"
	echo " -l LANG (english or french)           [by default : french]"
	echo " -n NAME (CV_NAME.pdf and CL_NAME.pdf) [by default : JohnDoe]"
	echo
	echo "Help :"
	echo " -h print this help"
	echo
	exit ${1:-0}
}

cleanlatex () {
	if [ -z "${1}" ]; then
		echo "File name is missing"
	else
		if [ -e "${1}.aux" ] ; then command rm ${1}.aux ; fi
		if [ -e "${1}.bcf" ] ; then command rm ${1}.bcf ; fi
		if [ -e "${1}.log" ] ; then command rm ${1}.log ; fi
		if [ -e "${1}.out" ] ; then command rm ${1}.out ; fi
		if [ -e "${1}.run.xml" ] ; then command rm ${1}.run.xml ; fi
	fi
}

TEXFILE="NOTDEFINED"
LANG="french"
NAME="JohnDoe"

while getopts ":ht:n:l:" OPTION
do
	case ${OPTION} in
		t)
			TEXFILE=${OPTARG}
			;;
		l)
			LANG=${OPTARG}
			;;
		n)
			NAME=${OPTARG}
			;;
		h)
			USAGE
			;;
		:)
			echo "Error: option -${OPTARG} requires an argument."
			exit 1
			;;
		\?)
			echo "Error : invalid option -${OPTARG}"
			exit 1
			;;
	esac
done

if [[ ${TEXFILE} == "NOTDEFINED" ]] ; then
	USAGE
	exit 1
fi

xelatex -jobname=${LANG} "resume.tex"
xelatex -jobname=${LANG} "resume.tex"

mv "${LANG}.pdf" "CV_${NAME}.pdf"

cleanlatex ${LANG}

open "CV_${NAME}.pdf"