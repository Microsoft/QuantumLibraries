// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.
namespace Microsoft.Quantum.Tests {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;

    function ResultAsIntTest () : Unit {
        
        EqualityFactI(ResultAsInt([Zero, Zero]), 0, $"Expected [Zero, Zero] to be represented by 0.");
        EqualityFactI(ResultAsInt([One, Zero]), 1, $"Expected [One, Zero] to be represented by 1.");
        EqualityFactI(ResultAsInt([Zero, One]), 2, $"Expected [Zero, One] to be represented by 2.");
        EqualityFactI(ResultAsInt([One, One]), 3, $"Expected [One, One] to be represented by 3.");
    }
    
    
    function BoolArrFromPositiveIntTest () : Unit {
        
        for (number in 0 .. 100) {
            let bits = IntAsBoolArray(number, 9);
            let inte = PositiveIntFromBoolArr(bits);
            EqualityFactI(inte, number, $"Integer converted to bit string and back should be identical");
        }
        
        let bits70 = [false, true, true, false, false, false, true, false];
        let number70 = PositiveIntFromBoolArr(bits70);
        EqualityFactI(70, number70, $"Integer from 01000110 in little Endian should be 70");
    }
    
}


