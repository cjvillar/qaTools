
#####USE TO TEST SQL QUERY TO GET A CLEAN LIST OF ASSEMBLY TABLES######
# Insert name of db and create a dir in /hive/users/chrisv/tracks under the name of the dir

echo "Enter directory name"
read dirname

exists=$(hgsql -Ne "SHOW DATABASES LIKE '$dirname'")
 if [ "$exists" == "" ]; then echo "'$dirname'  doesn't exist."; exit 0; fi

if [ ! -d "$dirname" ]
then
    echo "'$dirname' doesn't exist. Creating now"
    mkdir $dirname
    echo "Directory created"
else
    echo "Directory exists"
    echo "Exiting  Script"
    exit 0;

fi
prepname="$(tr '[:lower:]' '[:upper:]' <<< ${dirname:0:1})${dirname:1}"

hgsql -h mysqlbeta qapushq -Ne 'SELECT tbls FROM "$dirname" WHERE dbs="$dirname"' > pushQtablesRaw; 
awk -v RS=" " '{print}' pushQtablesRaw > pushQtablesClean ; cat pushQtablesClean | sort > pushQtablesCleanSorted; 
cat pushQtablesCleanSorted | grep -v -e 'trackDb*' -e 'hgFindSpec*' > tables${prepname}; 
sed -i '/^$/d' tables${prepname} ; cat tables${prepname} | wc -l > count; mv count $(head -1 count).pushQtableCount ; 
cat tables${prepname}; 
echo “Paste this list into your track QA spreadsheet”;



