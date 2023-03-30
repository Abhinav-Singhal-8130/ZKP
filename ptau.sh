power=$1
randstr1="aasdfasdf"

snarkjs powersoftau new bn128 $power "pot${power}_0000.ptau" -v
snarkjs powersoftau contribute "pot${power}_0000.ptau" "pot${power}_0001.ptau" --name="First contribution" -v  -e=$randstr1
snarkjs powersoftau prepare phase2 "pot${power}_0001.ptau" "pot${power}_final.ptau" -v
