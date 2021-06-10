include "../../node_modules/circomlib/circuits/mimc.circom"

template ReceiverFunction(){
    //value transferred
    signal private input receiverBalanceBefore;
    signal private input value;
    //output hash(balance, value, balance after transferred)
    signal output hashStartingBalance;
    signal output hashValue;
    signal output hashBalanceAfter;

    //Hash MiMC, ../../circomlib/circuits/mimc.circom
    // take as parameters the number of entries and the number of cryptographic "rounds"
    // 3 components because 3 hashes
    component mimc1 = MultiMiMC7(1,91){
        mimc1.in[0] <== receiverBalanceBefore;
        mimc1.k <== 2;
    }
    component mimc2 = MultiMiMC7(1,91){
        mimc2.in[0] <== value;
        mimc2.k <== 2;
    }
    component mimc3 = MultiMiMC7(1,91){
        mimc3.in[0] <== (receiverBalanceBefore + value);
        mimc3.k <== 2;
    }

    //Hash of output
    mimc1.out ==> hashStartingBalance;
    mimc2.out ==> hashValue;
    mimc3.out ==> hashBalanceAfter;
}

component main = ReceiverFunction();