file=$1
dir=$2
log="${3:-log.txt}"

if [ -e $dir ];then rm -rf $dir ; fi  
mkdir $dir

cp run.sh $dir/
python3 p1.py --out_file "$dir/input.json" --seed 42 --matrix_shapes '{"in": [32,32,3], "weights": [3,3,3,2], "bias": [2]}'

cd $dir
./run.sh $file $log