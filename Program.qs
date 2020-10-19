namespace QuantumHello {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation GenerateRAndomBit() : Result {
        using (q = Qubit()){
            // Put the qubit to superposition
            H(q);
            // The qubit now has an equal chance of being measured 0 or 1
            // Measure the qubit
            return MResetZ (q);
        }
    }
}
