/-
Section 2.1–2.2 — Partitions, central characters, shifted symmetric power sums.

We re-use `Nat.Partition` from Mathlib and layer on the paper-specific
data: character `χ_λ(μ)`, central character `f_μ(λ)`, shifted power sums
`p_k(λ)`, and the ring `Λ*` of shifted symmetric functions.
-/

import Mathlib.Combinatorics.Enumerative.Partition.Basic
import Mathlib.Data.Complex.Basic
import Mathlib.Data.PNat.Basic
import Mathlib.NumberTheory.LSeries.RiemannZeta
import LeakyHurwitz.Preliminaries.Notation

namespace Nat.Partition

/-- The length `ℓ(μ)` of a partition: number of (nonzero) parts. -/
def length {n : ℕ} (μ : Nat.Partition n) : ℕ := μ.parts.card

/-- The size `|μ|` of a partition is `n` when `μ : Nat.Partition n`. -/
def size {n : ℕ} (_μ : Nat.Partition n) : ℕ := n

/-- The parts of a partition, in the conventional non-increasing order. -/
def partsList {n : ℕ} (μ : Nat.Partition n) : List ℕ :=
  μ.parts.sort (fun a b => b ≤ a)

/-- The `i`-th part `μᵢ`, with paper indexing `i = 1, 2, ...`.
It is `0` after the length of the partition. -/
def part {n : ℕ} (μ : Nat.Partition n) (i : ℕ) : ℕ :=
  μ.partsList.getD (i - 1) 0

/-- The product `∏ μᵢ` of all parts of a partition. -/
def partsProd {n : ℕ} (μ : Nat.Partition n) : ℕ := μ.parts.prod

/-- The usual factor `|Aut μ| = ∏_j m_j(μ)!`, where `m_j(μ)` is the
multiplicity of the part `j`. -/
def autOrder {n : ℕ} (μ : Nat.Partition n) : ℕ :=
  μ.toFinsuppAntidiag.prod fun _ multiplicity => Nat.factorial multiplicity

end Nat.Partition

namespace LeakyHurwitz

/--
The character of the irreducible `S_d`-representation labelled by `lam`,
evaluated on a partition `mu` of the same size.

This is an opaque constant until the relevant representation theory of
symmetric groups is available at this index level.
-/
noncomputable opaque character {d : ℕ} (_lam _mu : Nat.Partition d) : ℂ

@[inherit_doc] scoped notation "χ_" lam "(" mu ")" => LeakyHurwitz.character lam mu

/-- Size of the conjugacy class `C_μ ⊂ S_d`. -/
noncomputable opaque conjClassSize {d : ℕ} (_mu : Nat.Partition d) : ℕ+

/-- Dimension of the irreducible `S_d`-representation `λ`. -/
noncomputable opaque dimRepr {d : ℕ} (_lam : Nat.Partition d) : ℕ+

/--
Central character (paper eq. 2.2):
  f_μ(λ) = |C_μ| / dim(λ) · χ_λ(μ),
for `μ, λ ⊢ d`.
-/
noncomputable def centralCharSameSize {d : ℕ} (mu lam : Nat.Partition d) : ℂ :=
  (conjClassSize mu : ℂ) / (dimRepr lam : ℂ) * character lam mu

/-- The character value `χ_λ(μ)` used in the paper's extended central
character. If `|μ| < |λ|`, this uses the natural inclusion
`S_|μ| ⊂ S_|λ|`; if `|μ| = |λ|`, it is the ordinary character value. -/
noncomputable opaque extendedCharacter {a b : ℕ}
    (_lam : Nat.Partition b) (_mu : Nat.Partition a) : ℂ

/--
Extended central character for partitions `μ` of possibly *different* size
than `λ` (paper eq. 2.3):
  f_μ(λ) = binom(|λ|, |μ|) · |C_μ| / dim(λ) · χ_λ(μ).
If `|μ| > |λ|` the binomial vanishes.
-/
noncomputable def centralChar {a b : ℕ} (mu : Nat.Partition a) (lam : Nat.Partition b) : ℂ :=
  (Nat.choose b a : ℂ) * (conjClassSize mu : ℂ) / (dimRepr lam : ℂ) *
    extendedCharacter lam mu

/-- The finite part of the shifted power sum formula. Since `λᵢ = 0` for
`i > ℓ(λ)`, the infinite sum in the paper has only finitely many non-zero
terms. -/
noncomputable def shiftedPowerSumFinitePart (k : ℕ) {n : ℕ}
    (lam : Nat.Partition n) : ℂ :=
  ((List.range lam.length).map fun j =>
    ((lam.part (j + 1) : ℂ) - (j + 1 : ℂ) + (1 / 2 : ℂ)) ^ k -
      (-(j + 1 : ℂ) + (1 / 2 : ℂ)) ^ k).sum

/--
Shifted symmetric power sum `p_k(λ)` (paper eq. 2.4):

  p_k(λ) = Σ_{i ≥ 1} ((λ_i − i + ½)^k − (−i + ½)^k) + (1 − 2^{−k}) · ζ(−k).
-/
noncomputable def shiftedPowerSum (k : ℕ) {n : ℕ} (lam : Nat.Partition n) : ℂ :=
  shiftedPowerSumFinitePart k lam +
    (1 - ((2 : ℂ) ^ k)⁻¹) * riemannZeta (-(k : ℂ))

@[inherit_doc] scoped notation "p_[" k "]" lam => LeakyHurwitz.shiftedPowerSum k lam

/--
For a partition `μ`, define `p_μ = ∏_i p_{μ_i}` (paper eq. 2.5).
-/
noncomputable def shiftedPowerSumProd {n m : ℕ}
    (mu : Nat.Partition m) (lam : Nat.Partition n) : ℂ :=
  (mu.parts.map fun i => shiftedPowerSum i lam).prod

/-!
### The ring `Λ*` of shifted symmetric functions

Following the paper (eq. 2.7), `Λ*` is the projective limit of the rings of
shifted-symmetric polynomials `ℚ[λ₁, …, λ_n]^{(S_n)}` along the maps that
set the last variable to zero.

Formalising this rigorously requires either a direct construction or a
re-implementation of Mathlib's `MvPolynomial` machinery with the shifted
action. We declare an opaque type for now.
-/

/-- Opaque stand-in for the ring `Λ*` of shifted symmetric functions
    over `ℚ` in countably many variables. -/
opaque ShiftedSymRing : Type

namespace ShiftedSymRing
/-- Commutative ring instance: opaque for now. -/
axiom instCommRing : CommRing ShiftedSymRing
attribute [instance] instCommRing
end ShiftedSymRing

/-- A partition of arbitrary size. -/
abbrev AnyPartition : Type := Σ n : ℕ, Nat.Partition n

/-- The central character `f_μ` as an element of `Λ*`
(Kerov–Olshanski). -/
noncomputable opaque centralCharFun (_mu : AnyPartition) : ShiftedSymRing

/-- The shifted power sum `p_k` is an element of `Λ*`. -/
noncomputable opaque powerSumElt (_k : ℕ) : ShiftedSymRing

/- The paper recalls the Kerov--Olshanski theorem that the `f_μ` form a
basis of `Λ*`, and that `Λ*` is freely generated by the `p_k`.
The exact linear-algebraic statement is deferred until `ShiftedSymRing` is
implemented as the projective limit in the preceding paragraph. -/

end LeakyHurwitz
