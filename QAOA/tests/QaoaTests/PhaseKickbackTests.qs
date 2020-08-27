﻿// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Tests {
    open Microsoft.Quantum.Logical;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Qaoa;

    @Test("QuantumSimulator")
    operation RunPhaseKickbackTest() : Unit {

        let controlQubitsIndices = [0];
        let phaseExponent = 0.5;

		using ((register, aux) = (Qubit(), Qubit())) {
            RunPhaseKickback(controlQubitsIndices, phaseExponent, [register], aux);
            AssertQubit(Zero, register);
            ResetAll([register]);
            ResetAll([aux]);
        }
    }

     @Test("QuantumSimulator")
    operation RunPhaseKickbackOneControlQubitTest() : Unit {

        let controlQubitsIndices = [0];
        let phaseExponent = 0.5;
        
        let complexZero = Complex(0.685125,-0.174941);
        let complexOne = Complex(0.685125,0.174941);

        using ((register, aux) = (Qubit(), Qubit())) {
            H(register);
            RunPhaseKickback(controlQubitsIndices, phaseExponent, [register], aux);
            AssertQubitIsInStateWithinTolerance((complexZero, complexOne), register, 1E-05);
            ResetAll([register]);
            ResetAll([aux]);
        }
    }
}
