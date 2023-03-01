# assumed file structure
# root
#   circomlib-ml
#   my_dense
#       |- input.json
#       |- run.sh


file=$1
log="${2:-log.txt}"
cppdir="${file}_cpp"
> $log  # clear the log file


echo "Step-1: compiling the Circuit" >> $log
start=$(date +%s%N)
circom ../circomlib-ml/circuits/"$file.circom" --r1cs --sym --c -o ./
end=$(date +%s%N)
echo "Elapsed Time for Step-1: $((($end - $start)/1000000)) ms"  >> $log

cd $cppdir

echo "Step-2: Make" >> ../$log
start=$(date +%s%N)
make
end=$(date +%s%N)
echo "Elapsed Time for Step-2: $((($end - $start)/1000000)) ms"  >> $log

cd ..

echo "Step-3: Execute binary which takes input.json and witness" >> $log
start=$(date +%s%N)
$cppdir/$file input.json witness.wtns
end=$(date +%s%N)
echo "Elapsed Time for Step-3: $((($end - $start)/1000000)) ms"  >> $log

echo "Step-3.1: powers of tau (Not timed as it requires input)" >> $log
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v

echo "Step-3.2: phase 2 (Not timed as it requires input)" >> $log
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup $file.r1cs pot12_final.ptau Dense_0000.zkey
snarkjs zkey contribute "${file}_0000".zkey "${file}_0001".zkey --name="1st Contributor Name" -v
snarkjs zkey export verificationkey "${file}_0001".zkey verification_key.json

echo "Step-4: Generating a proof" >> $log
start=$(date +%s%N)
snarkjs groth16 prove "${file}_0001".zkey witness.wtns proof.json public.json
end=$(date +%s%N)
echo "Elapsed Time for Step-4: $((($end - $start)/1000000)) ms"  >> $log

echo "Step-5: Verify the proof" >> $log
start=$(date +%s%N)
snarkjs groth16 verify verification_key.json public.json proof.json
end=$(date +%s%N)
echo "Elapsed Time for Step-5: $((($end - $start)/1000000)) ms"  >> $log