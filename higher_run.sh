file=$1
dir=$2
log="${3:-log.txt}"

if [ -e $dir ];then rm -rf $dir ; fi  
mkdir $dir

cp run.sh $dir/
python3 p1.py "$dir/input.json" '{"in": [10], "weights": [10, 10], "bias": [10]}'
cd $dir
./run.sh $file $log