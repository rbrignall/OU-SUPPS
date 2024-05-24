#!/bin/bash
#
# ou-supps-test-cases.sh
#
# a set of files to attempt to track the behaviour of ou-supps

pdflatexMode=0
pdfToTextMode=0
while getopts "pt" OPTION
do
 case $OPTION in
   p)
   pdflatexMode=1
   ;;
   t)
   pdfToTextMode=1
   ;;
  esac
done
filesToTrack=( 
    outn-mks-in-align  
    ouexam-mks-in-align  
) 

for indvFile in "${filesToTrack[@]}"
do
  echo $indvFile
  [[ $pdflatexMode -eq 1 ]]  && pdflatex --interaction batchmode $indvFile
  [[ $pdflatexMode -eq 1 ]]  && pdflatex --interaction batchmode $indvFile
  [[ $pdfToTextMode -eq 1 ]] && pdftotext ${indvFile}.pdf
done
exit 0
