/-
# LeakyHurwitz

Lean 4 / Mathlib formalization of:

  *Failing to keep the balance: explicit formulae and topological recursion
   for leaky Hurwitz numbers*

  by Marvin Anas Hahn and Reinier Kramer (arXiv:2603.06094v1).

This top-level file imports the section-by-section modules.  Unavailable
background theories are represented by opaque constants or axioms; theorem
statements are only installed when their Lean statements are explicit enough
to match the paper.

## Layout

  Section 2.1   `LeakyHurwitz.Preliminaries.Notation`
  Section 2.1–2 `LeakyHurwitz.Preliminaries.Partitions`
  Section 2.2   `LeakyHurwitz.Preliminaries.HurwitzNumbers`
  Section 2.3   `LeakyHurwitz.Preliminaries.FockSpace`
  Section 2.4   `LeakyHurwitz.TropicalCovers`
  Section 2.5   `LeakyHurwitz.TopologicalRecursion`
  Section 3     `LeakyHurwitz.Polynomiality`
  Section 4     `LeakyHurwitz.ClosedFormulae`
  Section 5–6   `LeakyHurwitz.HamiltonianFlow`
-/

import LeakyHurwitz.Preliminaries.Notation
import LeakyHurwitz.Preliminaries.Partitions
import LeakyHurwitz.Preliminaries.HurwitzNumbers
import LeakyHurwitz.Preliminaries.FockSpace
import LeakyHurwitz.TropicalCovers
import LeakyHurwitz.TopologicalRecursion
import LeakyHurwitz.Polynomiality
import LeakyHurwitz.ClosedFormulae
import LeakyHurwitz.HamiltonianFlow
