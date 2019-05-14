// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

namespace Microsoft.Quantum.Arithmetic {
    /// # Summary
    /// FixedPoint type. Consists of an integer that is equal to the number of
    /// qubits to the left of the binary point, i.e., qubits of weight greater
    /// than or equal to 1, and a quantum register.
    newtype FixedPoint = (Int, Qubit[]);
}