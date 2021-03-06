#http://ephrain.pixnet.net/blog/post/62810813-%5Blinux%5D-%E4%BD%BF%E7%94%A8-getopt-%E5%9C%A8-shell-script-%E4%B8%AD%E8%A7%A3%E6%9E%90%E5%91%BD%E4%BB%A4%E5%88%97%E5%8F%83
#http://wiki.bash-hackers.org/howto/getopts_tutorial

#Default arguments
GETOPT_RESULT=$(getopt -o i,c,l:,k: -l name:,color -- "$@" )
eval set -- "${GETOPT_RESULT}"
REGEXP="*.c"
LOC=.
COLOR_FLAG="0"
KEY="empty"
LETTER_CASE="1"
while true
do
	case "$1" in
		-l)
			LOC="$2"
			echo "location=${LOC}"
			shift 2
			;;
		-k)
			KEY="$2"
			echo "key=${KEY}"
			shift 2
			;;
		-c)
			echo "color activated"
			COLOR_FLAG="1"
			shift
			;;
		-i)
			echo "ignore letter case"
			LETTER_CASE="0"
			shift
			;;
		--name)
			REGEXP="$2"
			echo "name=${REGEXP}"
			shift 2
			;;
		*)
			break
			;;
	esac
done

#exit;

GREP_CMD="grep"
if [ "$COLOR_FLAG" == "1" ]; then
	GREP_CMD="${GREP_CMD} --color"
fi
if [ "$LETTER_CASE" == "0" ]; then
	GREP_CMD="${GREP_CMD} -i"
fi
echo "loop"
for file in $(find $LOC -name "${REGEXP}" )
do
	GREP_CMD_CUR="${GREP_CMD} ${KEY} ${file}"
	GREP_RES=`${GREP_CMD_CUR}`
	if [ "$GREP_RES" == "" ]; then
		continue;
	fi
	if [ "$COLOR_FLAG" == "1" ]; then
		printf "\033[32m"
	fi
	#echo "$GREP_CMD_CUR"
	echo "${file}:";	
	if [ "$COLOR_FLAG" == "1" ]; then
		printf "\033[0m"
	fi
	$GREP_CMD_CUR
done

