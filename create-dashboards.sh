#!/bin/bash

# url of the github repo, files will be loaded from here
BASE_URL="https://raw.githubusercontent.com/bodnaristvan/dashboard-loader/master/"
TEMP_DIR=/tmp
OUTPUT_DIR=~/Desktop
TEMPLATE_FILE=$TEMP_DIR/d.html
HOST=`hostname -s`
# this gets the number of displays connected on osx, will not work on linux
SCREEN_NUM=`system_profiler SPDisplaysDataType | grep "Resolution:" | wc -l`

# get absolute path for relative dirs
function abspath() {
	pushd . > /dev/null;
	if [ -d "$1" ]; then
		cd "$1"
		dirs -l +0
	else
		cd "`dirname \"$1\"`"
		cur_dir=`dirs -l +0`
		if [ "$cur_dir" == "/" ]; then
			echo "$cur_dir`basename \"$1\"`"
		else
			echo "$cur_dir/`basename \"$1\"`"
		fi
	fi
	popd > /dev/null
}


# download dashboard frame
echo "Getting dashboard frame template:"
curl -# -o $TEMPLATE_FILE "$BASE_URL/dashboard-frame.html"

echo
# get dashboard config name
echo -n "Name of the dashboard config to use [$HOST]: "
read USER_CONFIG_NAME
if [ -n "$USER_CONFIG_NAME" ]; then
	CONFIG=$USER_CONFIG_NAME
else
	CONFIG=$HOST
fi

# get the output dir from user input
echo -n "Directory to generate the files to [$OUTPUT_DIR]: "
read USER_OUTPUT_DIR
if [ -d "$USER_OUTPUT_DIR" ]; then
	OUTPUT_DIR=abspath $USER_OUTPUT_DIR
fi
echo

# run the generator with the given config and screen number	
echo "Generating dashboard files to $OUTPUT_DIR: "
for i in `seq 1 $(( $SCREEN_NUM ))`;
do
	OUTFILE=$OUTPUT_DIR/dashboard-screen$i.html
	echo "Creating file $OUTFILE for $CONFIG:$i"
	sed -e s/\<%hostname%\>/$CONFIG/g -e s/\<%screenIndex%\>/$i/g $TEMPLATE_FILE > $TEMPLATE_FILE.sed && mv $TEMPLATE_FILE.sed $OUTFILE
done
echo

# clean up generator and template
echo -n "Removing temp files: "
rm $TEMPLATE_FILE
echo "done."
echo

echo "Finished generating dashboard files."