/-
Section 5 — Cut-and-join as Hamiltonian flow.
Section 6 — Explicit closed algebraic formulas for multidifferentials.

The story:
  * a cut-and-join operator `W ∈ â_∞ ⟦ℏ⟧` is *lower triangular* in the
    Heisenberg basis;
  * decompose `W` as a linear combination of leaky completed cycles
    `ℱ_r^k`; pack the coefficients into a two-variable generating series;
  * the *dequantisation* (leading order in ℏ) of this generating series
    is a *Hamiltonian function* whose flow generates the spectral curve
    `Σ ⊂ ℂ* × ℂ` for the Hurwitz multidifferentials;
  * we realise `ω_{0,1}` as an integral of the standard symplectic form
    on `ℂ* × ℂ`.

This gives a natural symplectic interpretation of topological recursion
and is a partial converse to the ABDKS24KP0 construction.
-/

import LeakyHurwitz.Preliminaries.FockSpace
import LeakyHurwitz.TopologicalRecursion

namespace LeakyHurwitz

/-- Opaque type of formal `ℏ`-series with coefficients in `â_∞`. -/
opaque AInftyHbarSeries : Type

/-- Opaque type of formal two-variable generating series. -/
opaque FormalTwoVariableSeries : Type

/-- Predicate that an element of `â_∞ ⟦ℏ⟧` is lower triangular in the
Heisenberg basis. -/
opaque IsLowerTriangular (_W : AInftyHbarSeries) : Prop

/-- A *lower triangular* operator `W ∈ â_∞ ⟦ℏ⟧`. -/
structure CutJoinOperator where
  /-- The underlying element of `â_∞ ⟦ℏ⟧`. -/
  toSeries : AInftyHbarSeries
  /-- Lower-triangularity in the Heisenberg basis. -/
  lower_triangular : IsLowerTriangular toSeries

/-- The two-variable generating series of the coefficients in the
    decomposition `W = Σ_{r,k} c_{r,k}(ℏ) · ℱ_r^k`. -/
axiom genSeries (_W : CutJoinOperator) : FormalTwoVariableSeries

/-- The *dequantisation* of `W`: leading order in ℏ. -/
axiom dequantisation (_W : CutJoinOperator) : FormalTwoVariableSeries

/- The Hamiltonian-flow spectral-curve theorem, the closed multidifferential
formula, and the fixed-leakiness explicit spectral curve are deferred until
their analytic hypotheses and generating-series objects are formalized. -/

end LeakyHurwitz
