namespace QuantumHello {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Oracles;
    open Microsoft.Quantum.Characterization;
  
    @EntryPoint()
    // Exploring Grovers Search Algorithm
    operation SolveGraphColoringProblem() : Unit {
        // The number of vertices is an integer
        let nVertices = 5;

        // Hard code the edges as tuples with start and end vertices
        let edges = [(0,1), (0,2), (0,3), (1,2), (1,3), (2,3), (3,4)];

        // Hardcoded Graph Coloring
        let coloring = [false, false, true, false, false, true, true, true, true, false];
        let colors = ["red", "green", "blue", "yellow"];

        // Interpret the coloring : Split the bit string into two bit fragments and convert them to colors
        let colorBits = Chunks(2, coloring);
        for (i in 0..nVertices-1) {
            let colorIndex = BoolArrayAsInt(colorBits[i]);
            Message ($"Vertex {i} - color #{colorIndex} ({colors[colorIndex]})");
        }


    }

    // Random Qubit
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


    operation GenerateRandomNumber() : Int {
        using (qubits = Qubit[3]) {
            ApplyToEach(H, qubits);
            Message ("The qubit register in a uniform superposition: ");
            Message (" ");
            DumpMachine();
            let result = ForEach(MResetZ, qubits);
            //ForEach(Reset, qubits);
            Message ("Measuring collapses qubits to a basis state");
            Message (" ");
            DumpMachine();
            return BoolArrayAsInt(ResultArrayAsBoolArray(result));
        }
    }

    
    operation GenerateRandomNumberMulQubit() : Int{
        using (qubits = Qubit[3]) {
            ApplyToEach (H,qubits);
            Message ("The qubit register in uniform superposition: ");
            DumpMachine();
            Message (" ");
            mutable results = new Result[0];
            for (q in qubits) {
                Message (" ");
                set results += [M(q)];
                DumpMachine();
            }
            Message (" ");
            return BoolArrayAsInt(ResultArrayAsBoolArray(results));
        }
    }

// Exploring Interference
    
    operation TestInterference1() : Result {
        using (q = Qubit()) {
            Message ("At the beginning the qubit is in the state |0>");
            Message (" ");
            DumpMachine();
            H(q);
            Message ("After applying H the qubit is in uniform supoerposition");
            Message (" ");
            DumpMachine();
            H(q);
            Message ("If we reapply H the qubit returns to the state |0>");
            Message (" ");
            DumpMachine();
            Message ("If we measure we always obtain |0>");
            Message (" ");
            return MResetZ(q);
        }
    }

    
    operation TestInterference2() : Unit{
        using (q = Qubit()) {
            X(q);
            H(q);
            DumpMachine();
            Reset(q);
        }
    }

    
    operation TestInterference3() : Unit {
        using (q = Qubit()) {
            Y(q);
            H(q);
            DumpMachine();
            Reset(q);
        }
    }

    // Exploring Entanglement

    operation TestingEntanglement1() : Result[] {
        using (qubits = Qubit[2]) {
            H(qubits[0]);
            CNOT (qubits[0],qubits[1]);
            Message ("Entangled state before measurement");
            DumpMachine();
            Message (" ");
            let result = MultiM(qubits);
            Message ("State after measurement");
            DumpMachine();
            return result;
        }

    }

    
    operation TestingEntanglement2() : Result[] {
        using (qubits = Qubit[2]) {
            H(qubits[0]);
            Controlled X ([qubits[0]],qubits[1]);
            Message ("Entangled state before measurement");
            DumpMachine();
            Message (" ");
            let results = MultiM(qubits);
            Message ("State after measurement");
            DumpMachine();
            return results;
        }
    }

}
