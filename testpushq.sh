
#####USE TO TEST SQL QUERY TO GET A CLEAN LIST OF ASSEMBLY TABLES######
# Insert name of db and create a dir in /hive/users/chrisv/tracks under the name of the dir

echo "Enter directory name"
read dirname

exists=$(hgsql -h mysqlbeta qapushq -Ne "show tables like '$dirname'")

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

hgsql -h mysqlbeta qapushq -Ne "SELECT tbls FROM $dirname WHERE dbs='$dirname'" > ./$dirname/pushQtablesRaw; 
awk -v RS=" " '{print}' ./$dirname/pushQtablesRaw > ./$dirname/pushQtablesClean ; cat ./$dirname/pushQtablesClean | sort > ./$dirname/pushQtablesCleanSorted; 
cat ./$dirname/pushQtablesCleanSorted | grep -v -e 'trackDb*' -e 'hgFindSpec*' > ./$dirname/tables${prepname}; 
sed -i '/^$/d' ./$dirname/tables${prepname} ; cat ./$dirname/tables${prepname} | wc -l > count; mv count ./$dirname/$(head -1 count).pushQtableCount ; 
cat ./$dirname/tables${prepname}; 
echo “Paste this list into your track QA spreadsheet”;



