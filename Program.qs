namespace QuantumHello {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;


    operation GenerateRandomBit() : Result {
        using (q = Qubit()){
            // Put the qubit to superposition
            H(q);
            // The qubit now has an equal chance of being measured 0 or 1
            // Measure the qubit
            return MResetZ(q);
        }
    }

    operation SampleRandomNumberInRange(min : Int,max : Int) : Int {
        mutable output = 0;
        repeat{
            mutable bits = new Result [0];
            for (idxBit in 1..BitSizeI(max)){
                set bits += [GenerateRandomBit()];
            }
            set output = ResultArrayAsInt(bits);
        } until (output >= min and output <= max);
        return output;
    }

    operation SampleRandomNumber() : Int {
        // Minimum Value
        let min = 30;
        // Maximum Value
        let max = 40;
        Message ($"Sampling a Random Number between {min} and {max} : ");
        return SampleRandomNumberInRange(min,max);
    }

   
    operation GenerateRandomBitAgain() : Result {
        using (q = Qubit()) {
            Message ("Initial state of Qubit");
            DumpMachine();
            Message (" ");
            H(q);
            Message ("Applying Hadamard Gate to Qubit");
            DumpMachine();
            Message (" ");
            let randomBit = M(q);
            Message ("Measuring Qubit");
            DumpMachine();
            Message (" ");
            Reset(q);
            Message ("Resetting Qubit");
            DumpMachine();
            Message (" ");
            return randomBit;
        }
    }

    @EntryPoint()
    operation GenerateSpecificState(alpha : Double) : Result {
        using (q = Qubit()) {
            Ry(2.0 * ArcCos(Sqrt(alpha)),q);
            Message ("Qubit is in the desired state");
            Message (" ");
            DumpMachine();
            Message (" ");
            Message ("Your skewed Random Bit is");
            let skewed = M(q);
            Reset (q);
            return skewed;
        }
    }
}
