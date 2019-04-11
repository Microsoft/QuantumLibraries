﻿using System;
using System.Collections.Generic;
using System.Linq;

using Microsoft.Jupyter.Core;
using Microsoft.Quantum.Chemistry.Broombridge;
using Microsoft.Quantum.Chemistry.Fermion;
using Microsoft.Quantum.Chemistry.Generic;
using Microsoft.Quantum.Chemistry.LadderOperators;
using Microsoft.Quantum.Chemistry.OrbitalIntegrals;

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace Microsoft.Quantum.Chemistry.Magic
{
    /// <summary>
    /// Loads Broombridge electronic structure problem and returns fermion Hamiltonian.
    /// </summary>
    public class FermionHamiltonianLoadMagic : MagicSymbol
    {
        /// <summary>
        /// Loads a fermion Hamiltonian from a Broombridge electronic structure problem.
        /// </summary>
        public FermionHamiltonianLoadMagic()
        {
            this.Name = $"%chemistry.fh.load";
            this.Documentation = new Documentation() { Summary = "Loads the fermion Hamiltonian for an electronic structure problem. The problem is loaded from a file or passed as an argument." };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;
        }

        /// <summary>
        /// List of arguments
        /// </summary>
        public class Arguments
        {
            /// <summary>
            /// The name of a .yaml file with a broombridge schema.
            /// </summary>
            public string fileName { get; set; }

            /// <summary>
            /// A Broombridge ProblemDescription to load the FermionHamiltonian from.
            /// </summary>
            public CurrentVersion.ProblemDescription problemDescription { get; set; }

            /// <summary>
            /// The IndexConvention to use to generate the Hamiltonian from the ProblemDescription.
            /// </summary>
            public SpinOrbital.IndexConvention indexConvention { get; set; } = SpinOrbital.IndexConvention.UpDown;
        }

        /// <summary>
        /// Loads a FermionHamiltonian from either a .yaml file with a Broombridge definition,
        /// or from a ProblemDescription.
        /// If the fileName is specified, that will be used and the problemDescription will be ignored.
        /// </summary>
        public ExecutionResult Run(string input, IChannel channel)
        {
            if (string.IsNullOrWhiteSpace(input))
            {
                channel.Stderr("Please provide the name of a Broombridge file or a problem description to load the fermion Hamiltonian from.");
                return ExecuteStatus.Error.ToExecutionResult();
            }

            // Identify the ProblemDescription with the hamiltonian from the arguments.
            var args = JsonConvert.DeserializeObject<Arguments>(input);
            var problemData = SelectProblemDescription(args);

            // Electronic structure Hamiltonians are usually represented compactly by orbital integrals. Let us construct
            // such a Hamiltonian from broombridge.
            OrbitalIntegralHamiltonian orbitalIntegralHamiltonian = problemData.ToOrbitalIntegralHamiltonian();

            // We can obtain the full fermion Hamiltonian from the more compact orbital integral representation.
            // This transformation requires us to pick a convention for converting a spin-orbital index to a single integer.
            // Let us pick one according to the formula `integer = 2 * orbitalIndex + spinIndex`.
            FermionHamiltonian fermionHamiltonian = orbitalIntegralHamiltonian.ToFermionHamiltonian(SpinOrbital.IndexConvention.UpDown);

            return fermionHamiltonian.ToExecutionResult();
        }

        /// <summary>
        /// Selects the ProblemDescription from the given arguments.
        /// If the fileName is specified, it will try to load the Broombridge data from the file
        /// and will use the first ProblemDescription, otherwise, the problemDescription in the arguments is used.
        /// </summary>
        protected virtual CurrentVersion.ProblemDescription SelectProblemDescription(Arguments args)
        {
            if (string.IsNullOrWhiteSpace(args.fileName))
            {
                return args.problemDescription;
            }

            // A single file can contain multiple problem descriptions. Let us pick the first one.
            CurrentVersion.Data broombridge = Deserializers.DeserializeBroombridge(args.fileName);
            return broombridge.ProblemDescriptions.First();
        }
    }

    /// <summary>
    /// Adds terms to a fermion Hamiltonian.
    /// </summary>
    public class FermionHamiltonianAddTermsMagic : MagicSymbol
    {
        /// <summary>
        /// Adds terms to a fermion Hamiltonian.
        /// </summary>
        public FermionHamiltonianAddTermsMagic()
        {
            this.Name = $"%chemistry.fh.add_terms";
            this.Documentation = new Documentation() { Summary = "Adds terms to a fermion Hamiltonian." };
            this.Kind = SymbolKind.Magic;
            this.Execute = this.Run;
        }

        /// <summary>
        /// The list of arguments
        /// </summary>
        public class Arguments
        {
            /// <summary>
            /// The fermion hamiltonian to add terms to.
            /// </summary>
            public FermionHamiltonian hamiltonian { get; set; }

            /// <summary>
            /// The list of terms and their coefficient to add.
            /// </summary>
            public List<(int[], double)> fermionTerms { get; set; }
        }

        /// <summary>
        /// Simply calls AddRange on the hamiltonian to add each term from the list of fermionTerms
        /// </summary>
        public ExecutionResult Run(string input, IChannel channel)
        {
            if (string.IsNullOrWhiteSpace(input))
            {
                channel.Stderr("Please provide the hamiltonian and fermion terms as input.");
                return ExecuteStatus.Error.ToExecutionResult();
            }

            var args = JsonConvert.DeserializeObject<Arguments>(input);

            if (args.hamiltonian == null) throw new ArgumentNullException(nameof(args.hamiltonian));
            if (args.fermionTerms == null) throw new ArgumentNullException(nameof(args.fermionTerms));

            args.hamiltonian.AddRange(args.fermionTerms.Select(t => (new HermitianFermionTerm(t.Item1.ToLadderSequence()), t.Item2.ToDoubleCoeff())));
            
            return JObject.FromObject(args.hamiltonian).ToExecutionResult();
        }
    }
}