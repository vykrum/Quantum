namespace QuantumHello {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;


    operation GenerateRandomBit() : Result {
        using (q = Qubit()){
            // Put the qubit to superposition
            H(q);
            // The qubit now has an equal chance of being measured 0 or 1
            // Measure the qubit
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(max : Int) : Int {
        mutable output = 0;
        repeat{
            mutable bits = new Result [0];
            for (idxBit in 1..BitSizeI(max)){
                set bits += [GenerateRandomBit()];
            }
            set output = ResultArrayAsInt(bits);
        } until (output <= max);
        return output;
    }

    @EntryPoint()
    operation SampleRandomNumber() : Int {
        let max = 50;
        Message ($"Sampling a Random Number between 0 and {max} : ");
        return SampleRandomNumberInRange(max);
    }
}
