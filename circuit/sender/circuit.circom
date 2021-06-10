include "../../node_modules/circomlib/circuits/mimc.circom"
include "../../node_modules/circomlib/circuits/comparators.circom"


template senderFunction(){
    //value transferred
    signal private input senderBalanceBefore;
    signal private input value;
    //output hash
    signal output hashStartingBalance;
    signal output hashValue;
    signal output hashBalanceAfter;

    //hash MiMC, ../../circomlib/circuits/mimc.circom

    //check Balance >= value transferred
    component valueOK = LessEqThan(32){
        valueOK.in[0] <== value;
        valueOK.in[1] <== senderBalanceBefore;
    }
    valueOK.out === 1;

    component mimc1 = MultiMiMC7(1,91){
        mimc1.in[0] <== senderBalanceBefore;
        //k is cryptography key
        mimc1.k <== 2;
    }

    component mimc2 = MultiMiMC7(1,91){
        mimc2.in[0] <== value;
        mimc2.k <== 2;
    }

    component mimc3 = MultiMiMC7(1,91){
        mimc3.in[0] <== (senderBalanceBefore - value);
        mimc3.k <== 2;
    }

    // output hash
    mimc1.out ==> hashStartingBalance;
    mimc2.out ==> hashValue;
    mimc3.out ==> hashBalanceAfter;
}

component main = senderFunction();