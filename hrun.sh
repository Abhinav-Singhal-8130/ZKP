file=$1
dir=$2
log="${3:-log.txt}"

if [ -e $dir ];then rm -rf $dir ; fi  
mkdir $dir

cp run.sh $dir/
python3 p1.py --out_file "$dir/input.json" --seed 42 --matrix_shapes '{"in": [100], "weights": [100, 100], "bias": [100]}'

cd $dir
./run.sh $file $log