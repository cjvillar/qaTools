#!/usr/bin/env bash

###################################### 
# USED TO AUTOMATE QA FOR ASSEMBLIES #
#         By: Chris V                #
######################################

# Runs with arguments
if [ "$1" == "" ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
 echo "usage: Run with any argument to get working ( i.e. -f )"
 exit 0;

fi

# Insert name of db and create a dir in /hive/users/chrisv/tracks under the name of the dir

echo "Enter directory name"
read dirname

#old push q way > exists=$(hgsql -h mysqlbeta qapushq -Ne "show tables like '$dirname'")


hgsql -h redmine -Ne "select i.id from (select id from issues where tracker_id = 24 and status_id = 10) as i inner join (
select customized_id, value from custom_values where custom_field_id = 2) as ass on i.id = ass.customized_id where ass.value = '$dirname';" redmine


 if [ "$exists" == "" ]; then echo "'$dirname'  doesn't exist."; exit 0; fi

if [ ! -d "../$dirname" ]
then
    echo "'$dirname' doesn't exist. Creating now"
    mkdir ../$dirname
    echo "Directory created"
else
    echo "Directory exists"
    echo "Exiting  Script"
    exit 0; 

fi


# Within this directory do SQL query for the tables listed in the directories name. As of now the tables retrieved from the pushQ.  
##Old way of getting tables: hgsql -Ne "show tables" $dirname > ../$dirname/rawTablelist.txt 
#cat ../$dirname/rawTablelist.txt | if grep "ERROR" ; then echo "mySQL error check $dirname for mispelling"; 
# exit 0; fi 
# New way of getting tables:
prepname="$(tr '[:lower:]' '[:upper:]' <<< ${dirname:0:1})${dirname:1}"

hgsql -h mysqlbeta qapushq -Ne "SELECT tbls FROM $dirname WHERE dbs='$dirname'" > ./$dirname/pushQtablesRaw;
awk -v RS=" " '{print}' ./$dirname/pushQtablesRaw > ./$dirname/pushQtablesClean ; cat ./$dirname/pushQtablesClean | sort > ./$dirname/pushQtablesCleanSorted;
cat ./$dirname/pushQtablesCleanSorted | grep -v -e 'trackDb*' -e 'hgFindSpec*' > ./$dirname/tables${prepname};
sed -i '/^$/d' ./$dirname/tables${prepname} ; cat ./$dirname/tables${prepname} | wc -l > count; mv count ./$dirname/$(head -1 count).pushQtableCount ;
cat ./$dirname/tables${prepname};
echo “Paste this list into your track QA spreadsheet”;

# Remove any hgFindSpec* and trackDb* files from rawTablelist.txt


echo "Do you wish to remove hgFindSpec* and trackDb* files from rawTablelist.txt?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) cat rawTablelist.txt | grep -v 'hgFindSpec*\trackDb*' > ../$dirname/Tablelist.txt ; break;;
        No ) exit;;
    esac
done


# make pause to check pushq tables are in the makeDoc then use this sql query to change push q from N to Y 
# change once pushq is retired. 




#hgsql -h mysqlbeta qapushq "UPDATE $DB SET makeDocYN='Y'" < remember to set $db to $dirname


# Edit raw list to work with qaGbtrack need an if/then statment to check chromeInfo if larger than 300k then split tables into chain/net and other to run qaGbtracks

hgsql -Ne "select count(*) from chromInfo" $dirname > ../$dirname/chromeInfocount 
printf "\n chromInfo count =";
cat ../$dirname/chromeInfocount 
print "CAUTION: If ChromeInfo is larger than 5 digits qaGbtracks may take more than two days to complete"
# Add if then statment to continue with qaGbscripts by either spliting chain/net or not.



# Echo ../$dirname/chromeInfocount
# Make if than statment to either proceed with the qaGb script or split tables into chain/net and other then do qaGb script

cat ../$dirname/Tablelist.txt | grep 'chain*' > ../$dirname/chainnet.txt
cat ../$dirname/Tablelist.txt | grep 'net*' >> ../$dirname/chainnet.txt
cat ../$dirname/Tablelist.txt | grep -v '*chain*\|*net*' > ../$dirname/qatablelist.txt

# Now give option to run qaGbTracks [-h] [-f TABLEFILE] db [table [table ...]] outFile
#checks for underscores in table names,checks for the existence of table descriptions ,checks shortLabel and longLabel length, positionalTblCheck ,checkTblCoords 
#,genePredCheck, pslCheck ,featureBits and (a version of) countPerChrom.
#
#  qaGbTracks -f qatablelist.txt  $dirname ../$dirname/qaGbtrackOut &
#  qaGbTracks -f chainnet.txt  $dirname ../$dirname/qaGbchainnetOut &  

# Organize qaGbtracks output with Ontogeney tools (import and use in this script). Make the output easy to read and dynamic such that it makes a check list.

#ADD NEXT STEP IN QA... 

#Runs robot on DEV hgTableTest.
#prepName="$(tr '[:lower:]' '[:upper:]' <<< ${db:0:1})${db:1}"
#hgTablesTest -db=$dirname hgwdev.ucsc.edu/cgi-bin/hgBlat dev${prepName}TablesTestLog
#check md5sum



