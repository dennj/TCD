/-
Formalization of:
  "Failing to keep the balance: explicit formulae and topological recursion
   for leaky Hurwitz numbers"
  by Marvin Anas Hahn and Reinier Kramer (arXiv:2603.06094v1)

Section 2.1 — Notation.

This file fixes the global notation used throughout the formalization:
  * the iota set `⟦n⟧ = {1, …, n}`,
  * the auxiliary trigonometric functions `ς` and `S`,
  * the set `ℤ'` of half-integers.
-/

import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Set.Basic
import Mathlib.Data.Finset.Basic
import Mathlib.Data.Real.Basic

namespace LeakyHurwitz

/-- `⟦n⟧ = {1, …, n}`, the index set used throughout the paper. -/
def iota (n : ℕ) : Finset ℕ := Finset.Ioc 0 n

@[inherit_doc] notation "⟦" n "⟧" => LeakyHurwitz.iota n

/-- The function `ς(z) = 2 sinh(z/2)`. -/
noncomputable def varsigma (z : ℂ) : ℂ := 2 * Complex.sinh (z / 2)

@[inherit_doc] scoped notation "ς" => LeakyHurwitz.varsigma

/-- The function `S(z) = ς(z) / z = (2 sinh(z/2)) / z`. -/
noncomputable def calS (z : ℂ) : ℂ := varsigma z / z

@[inherit_doc] scoped notation "𝓢" => LeakyHurwitz.calS

/-- The set of half-integers `ℤ' = ℤ + 1 / 2`, modelled as a subset of `ℝ`. -/
def halfIntegers : Set ℝ := { x : ℝ | ∃ n : ℤ, x = (n : ℝ) + (1 / 2 : ℝ) }

/-- The subtype of half-integers, used for the indices of `â_∞`. -/
abbrev HalfInt : Type := { x : ℝ // x ∈ halfIntegers }

@[inherit_doc] scoped notation "ℤ'" => LeakyHurwitz.HalfInt

end LeakyHurwitz
