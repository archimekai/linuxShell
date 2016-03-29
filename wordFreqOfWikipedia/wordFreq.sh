#Author		Kai WEN 
#Date		20160314
# !bin/bash
filename="webpage.txt";
##### get webpages from wikipedia ; use featured contentes to improve quality
wget -r -e robots=off --wait=0.3 --level=1 -np --quota=20M https://en.wikipedia.org/wiki/Wikipedia:Featured_articles
# make sure their are 100 files
find ./en.wikipedia.org/ -type f -print0|sed -n '1,100p'|xargs -0 cat>$filename
##### word frequency statistics
awk 'BEGIN{p="";space=" "} {p=p""space""$0} END{print(p);}' $filename | awk '{gsub(/<\/script>/,"\n");print}' | awk '{gsub(/<script>.*/,"");print}'| awk '{gsub(/>/,"\n");print;}'| awk '{gsub(/<.*/,"");print}'|awk 'BEGIN{p="";space=" "} {p=p""space""$0} END{print(p);}'|awk '{gsub(/[ \t]{1,}/," ");print}'|egrep -o "\b[[:alpha:]]+\b"|tr '[A-Z]' '[a-z]'|awk '{ count[$0]++;ntotal++ } END{slen=asorti(count,newcount);   for(i=1;i<=slen;i++) { printf("%-14s%d\t%lf\n",newcount[i],count[newcount[i]], 1.0 * count[newcount[i]] / ntotal ) ; } }'|sort -k 2nr|sed -n '1,1000p'|awk 'BEGIN{printf("%s\t%-14s%s\t%s\n","Rank","Word","Count","Freq")} {print (NR)"\t"$0}'  >wordfreq.txt
cat wordfreq.txt

#egrep -o "\b[[:alpha:]]+\b" < wiki | awk '{ count[$0]++ } END{ printf("%-14s%s\n","Word","Count") ;  for(ind in count) { printf("%-14s%d\n",ind,count[ind]); } }' 
