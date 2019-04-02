namespace Microsoft.Quantum.Canon {
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Arrays;

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.Reversed" instead.
    function Reverse<'T>(array : 'T[]) : 'T[] {
        Renamed("Microsoft.Quantum.Canon.Reverse", "Microsoft.Quantum.Arrays.Reversed");
        return Reversed(array);
    }

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.Filtered" instead.
    function Filter<'T> (predicate : ('T -> Bool), array : 'T[]) : 'T[] {
        Renamed("Microsoft.Quantum.Canon.Filter", "Microsoft.Quantum.Arrays.Filtered");
        return Filtered(predicate, array);
    }

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.All" instead.
    function ForAll<'T> (predicate : ('T -> Bool), array : 'T[]) : Bool {
        Renamed("Microsoft.Quantum.Canon.ForAll", "Microsoft.Quantum.Arrays.All");
        return All(predicate, array);
    }

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.Any" instead.
    function ForAny<'T> (predicate : ('T -> Bool), array : 'T[]) : Bool {
        Renamed("Microsoft.Quantum.Canon.ForAny", "Microsoft.Quantum.Arrays.Any");
        return Any(predicate, array);
    }

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.Mapped" instead.
    function Map<'T, 'U> (mapper : ('T -> 'U), array : 'T[]) : 'U[] {
        Renamed("Microsoft.Quantum.Canon.Map", "Microsoft.Quantum.Arrays.Mapped");
        return Mapped(mapper, array);
    }

    /// # Deprecated
    /// Please use @"Microsoft.Quantum.Arrays.MappedByIndex" instead.
    function MapIndex<'T, 'U> (mapper : ((Int, 'T) -> 'U), array : 'T[]) : 'U[] {
        Renamed("Microsoft.Quantum.Canon.MapIndex", "Microsoft.Quantum.Arrays.MappedByIndex");
        return MappedByIndex(mapper, array);
    }

}
