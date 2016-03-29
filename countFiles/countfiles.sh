# Author: 	Kai WEN 1300063704
# Date:		20160314
# !/bin/bash

dir=$1;

names=$(ls -la ${dir});
#echo ${names};
nEXEowner=$(grep "^...x" -c <<<"${names}");
nEXEgroup=$(grep "^.\{6\}x" -c <<<"${names}");
nEXEother=$(grep "^.\{9\}x" -c <<<"${names}");
nDirectory=$(grep "^d" -c <<<"${names}");

echo "===== Counts of different files:=====";
echo -e "Files executable by owner : ${nEXEowner} \n\t\t by group : ${nEXEgroup} \n\t\t by others: ${nEXEother}";
echo "Directories: ${nDirectory} (including . and ..)";


declare -A exnames; 
#names=$(ls -1 ${dir});
names=$( ls -al ${dir}|grep "^-"|awk '{for(i=9;i<=NF;i++){print $i}}');
for line in ${names}
do
  line=`tr '[A-Z]' '[a-z]'<<<"$line"`;
  tp=`grep "\." <<<"${line}"`;
  rtnval1=$?;
  tp=`grep "^\." <<<"${line}"`;
  rtnval2=$?;
  if [ $rtnval1 -eq 0 ] && [ $rtnval2 -ne 0 ]   #determine whether there is . in current line
  then
      ex=${line##*.};   #find extension
      exnames[${ex}]=0;
  fi
done

### count the extensions
for line in ${names}
do
  line=`tr '[A-Z]' '[a-z]'<<<"$line"`;
  tp=`grep "\." <<<"${line}"`;
  rtnval1=$?;
  tp=`grep "^\." <<<"${line}"`;
  rtnval2=$?;
  if [ $rtnval1 -eq 0 ] && [ $rtnval2 -ne 0 ]   #determine whether there is . in current line
  then 
      ex=${line##*.};
      exnames[${ex}]=`expr 1 + ${exnames[${ex}]}`;
  fi
done

function printArrWithDot()
{
  if test ${#exnames[@]} -eq 0
  then
    echo No files with extensions;
  else
    for index in ${!exnames[*]}
    do
      echo -e "EX: .${index}    \tCount: ${exnames[${index}]}";
    done
  fi
}
echo  ;
echo ===== Numbers of different extensions:=====
printArrWithDot;

