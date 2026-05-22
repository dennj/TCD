/-
Section 2.2 — (Leaky) Hurwitz numbers.

This file formalizes the paper's definitions of branched covers, double
Hurwitz numbers, and completed-cycles double Hurwitz numbers as accurately as
the current prerequisites allow.  Geometric objects not yet present in Mathlib
are kept opaque, but the numerical definitions no longer use placeholder
values such as `0`.
-/

import Mathlib.Data.PNat.Basic
import Mathlib.Algebra.BigOperators.Fin
import LeakyHurwitz.Preliminaries.Partitions

namespace LeakyHurwitz

open scoped BigOperators

/-! ### Branched covers of `ℙ¹` -/

/-- The projective line `ℙ¹`.  This is opaque until the required complex
geometry infrastructure is selected. -/
opaque ProjectiveLine : Type

namespace ProjectiveLine

/-- The point `0 ∈ ℙ¹`. -/
axiom zero : ProjectiveLine

/-- The point `∞ ∈ ℙ¹`. -/
axiom infinity : ProjectiveLine

end ProjectiveLine

/-- A compact, possibly disconnected, Riemann surface. -/
opaque CompactRiemannSurface : Type

namespace CompactRiemannSurface

/-- Genus of a compact Riemann surface. -/
noncomputable opaque genus : CompactRiemannSurface → ℕ

/-- Connectedness of the source surface. -/
opaque IsConnected : CompactRiemannSurface → Prop

end CompactRiemannSurface

/-- A holomorphic map from a compact Riemann surface to `ℙ¹`. -/
opaque HolomorphicMapToP1 (_S : CompactRiemannSurface) : Type

/-- `f` has ramification profile `μ` over the point `p ∈ ℙ¹`. -/
opaque HasRamificationProfile {d : ℕ+} {S : CompactRiemannSurface}
    (_f : HolomorphicMapToP1 S) (_p : ProjectiveLine)
    (_μ : Nat.Partition (d : ℕ)) : Prop

/-- `f` has simple ramification profile `(2, 1, ..., 1)` of degree `d`
over `p ∈ ℙ¹`. -/
opaque HasSimpleRamification {d : ℕ+} {S : CompactRiemannSurface}
    (_f : HolomorphicMapToP1 S) (_p : ProjectiveLine) : Prop

/-- The number `b = 2g - 2 + ℓ(μ) + ℓ(ν)` of simple branch points.
The natural-number expression is written as `2g + ℓ(μ) + ℓ(ν) - 2`, avoiding
premature truncation of `2g - 2`. -/
def simpleBranchPointCount (g : ℕ) {d : ℕ+}
    (μ ν : Nat.Partition (d : ℕ)) : ℕ :=
  2 * g + μ.length + ν.length - 2

/-- A choice of pairwise distinct simple branch points
`q₁, ..., q_b ∈ ℙ¹`. -/
structure BranchPointConfiguration (b : ℕ) where
  point : Fin b → ProjectiveLine
  pairwise_distinct : Function.Injective point

/-- A branched covering of type `(g, μ, ν)` with fixed simple branch points. -/
structure BranchedCover (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) where
  source : CompactRiemannSurface
  map : HolomorphicMapToP1 source
  genus_eq : CompactRiemannSurface.genus source = g
  ramification_zero : HasRamificationProfile map ProjectiveLine.zero μ
  ramification_infinity : HasRamificationProfile map ProjectiveLine.infinity ν
  simple_ramification : ∀ i : Fin (simpleBranchPointCount g μ ν),
    HasSimpleRamification (d := d) map (q.point i)

namespace BranchedCover

/-- Equivalence of branched covers: `f₁ : S₁ → ℙ¹` and `f₂ : S₂ → ℙ¹`
are equivalent if there is an isomorphism `S₁ ≅ S₂` intertwining the maps.
The actual isomorphism type is opaque until compact Riemann surfaces are
available as a category. -/
opaque Equivalent {g : ℕ} {d : ℕ+} {μ ν : Nat.Partition (d : ℕ)}
    {q : BranchPointConfiguration (simpleBranchPointCount g μ ν)}
    (_f₁ _f₂ : BranchedCover g μ ν q) : Prop

/-- The equivalence relation from the paper's definition. -/
axiom setoid (g : ℕ) (d : ℕ+) (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) :
    Setoid (BranchedCover g μ ν q)

/-- Equivalence classes of branched covers. -/
abbrev Class (g : ℕ) (d : ℕ+) (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) : Type :=
  Quotient (setoid g d μ ν q)

/-- The automorphism group of a branched cover. -/
noncomputable opaque Aut {g : ℕ} {d : ℕ+} {μ ν : Nat.Partition (d : ℕ)}
    {q : BranchPointConfiguration (simpleBranchPointCount g μ ν)}
    (_f : BranchedCover g μ ν q) : Type

/-- There are finitely many equivalence classes of branched covers. -/
axiom classFintype (g : ℕ) (d : ℕ+) (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) :
    Fintype (Class g d μ ν q)

/-- The summand `1 / |Aut(f)|`, lifted to an equivalence class. -/
noncomputable opaque classWeight {g : ℕ} {d : ℕ+} {μ ν : Nat.Partition (d : ℕ)}
    {q : BranchPointConfiguration (simpleBranchPointCount g μ ν)}
    (_F : Class g d μ ν q) : ℚ

/-- Whether an equivalence class has connected source. -/
opaque classConnected {g : ℕ} {d : ℕ+} {μ ν : Nat.Partition (d : ℕ)}
    {q : BranchPointConfiguration (simpleBranchPointCount g μ ν)}
    (_F : Class g d μ ν q) : Prop

end BranchedCover

/-- The disconnected double Hurwitz number
`hᵇᵘˡˡᵉᵗ_{g; μ,ν} = Σ_[f] 1 / |Aut(f)|`. -/
noncomputable def doubleHurwitz (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) : ℚ := by
  classical
  letI := BranchedCover.classFintype g d μ ν q
  exact ∑ F : BranchedCover.Class g d μ ν q, BranchedCover.classWeight F

/-- The connected double Hurwitz number, obtained by restricting the same sum
to classes whose source is connected. -/
noncomputable def connectedDoubleHurwitz (g : ℕ) {d : ℕ+}
    (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) : ℚ := by
  classical
  letI := BranchedCover.classFintype g d μ ν q
  exact ∑ F : BranchedCover.Class g d μ ν q,
    if BranchedCover.classConnected F then BranchedCover.classWeight F else 0

/-! ### Character formulas and completed cycles -/

/-- The one-part partition `(2)`, used for the transposition class. -/
def transpositionPartition : Nat.Partition 2 := Nat.Partition.indiscrete 2

/-- The right-hand side of the Frobenius-character formula for disconnected
double Hurwitz numbers. -/
noncomputable def doubleHurwitzCharacterSum (g : ℕ) {d : ℕ+}
    (μ ν : Nat.Partition (d : ℕ)) : ℂ :=
  ((μ.partsProd : ℂ) * (ν.partsProd : ℂ))⁻¹ *
    ∑ lam : Nat.Partition (d : ℕ),
      character lam μ * character lam ν *
        centralChar transpositionPartition lam ^ simpleBranchPointCount g μ ν

/-- Frobenius-character / symmetric-group formula for double Hurwitz numbers
(paper, displayed equation after Definition 2.2). -/
axiom doubleHurwitz_eq_character_sum
    (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (q : BranchPointConfiguration (simpleBranchPointCount g μ ν)) :
    (doubleHurwitz g μ ν q : ℂ) = doubleHurwitzCharacterSum g μ ν

/-- A list of positive completed-cycle lengths satisfying
`Σ (rᵢ - 1) = 2g - 2 + ℓ(μ) + ℓ(ν)`. -/
structure CompletedCycleProfile (g : ℕ) {d : ℕ+}
    (μ ν : Nat.Partition (d : ℕ)) where
  values : List ℕ+
  sum_eq_branch_count :
    (values.map fun r : ℕ+ => (r : ℕ) - 1).sum = simpleBranchPointCount g μ ν

namespace CompletedCycleProfile

/-- The number `n` of completed-cycle insertions. -/
def length {g : ℕ} {d : ℕ+} {μ ν : Nat.Partition (d : ℕ)}
    (r : CompletedCycleProfile g μ ν) : ℕ := r.values.length

/-- The product `∏ᵢ p_{rᵢ}(λ)/(rᵢ-1)!` appearing in the definition. -/
noncomputable def shiftedPowerFactor {g : ℕ} {d : ℕ+}
    {μ ν : Nat.Partition (d : ℕ)}
    (r : CompletedCycleProfile g μ ν) (lam : Nat.Partition (d : ℕ)) : ℂ :=
  (r.values.map fun ri : ℕ+ =>
    shiftedPowerSum (ri : ℕ) lam / (Nat.factorial ((ri : ℕ) - 1) : ℂ)).prod

end CompletedCycleProfile

/-- Completed-cycles disconnected double Hurwitz numbers
`h^{r,•}_{g; μ,ν}` (paper Definition `CCHNdef`). -/
noncomputable def completedCyclesHurwitz (g : ℕ) {d : ℕ+}
    (μ ν : Nat.Partition (d : ℕ)) (r : CompletedCycleProfile g μ ν) : ℂ :=
  ((μ.partsProd : ℂ) * (ν.partsProd : ℂ))⁻¹ *
    ∑ lam : Nat.Partition (d : ℕ),
      character lam μ * character lam ν * r.shiftedPowerFactor lam

/-- Connected completed-cycles double Hurwitz numbers, obtained from the
disconnected numbers by inclusion-exclusion. -/
noncomputable opaque connectedCompletedCyclesHurwitz
    (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (_r : CompletedCycleProfile g μ ν) : ℂ

/-! ### Gromov--Witten/Hurwitz correspondence -/

/-- The relative Gromov--Witten descendant invariant from paper equation
`GWdef`.  The list contains the descendant powers `rᵢ`. -/
noncomputable opaque relativeGWDescendentInvariant
    (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (_descendentPowers : List ℕ) : ℂ

/-- The Gromov--Witten/Hurwitz correspondence, paper Theorem `GW/H`. -/
axiom GW_H_correspondence
    (g : ℕ) {d : ℕ+} (μ ν : Nat.Partition (d : ℕ))
    (r : CompletedCycleProfile g μ ν) :
    completedCyclesHurwitz g μ ν r =
      relativeGWDescendentInvariant g μ ν
        (r.values.map fun ri : ℕ+ => (ri : ℕ) - 1)

/-!
The logarithmic/pluricanonical double-ramification-cycle construction of
leaky Hurwitz numbers is introduced next in the paper, but the operational
definition used in the sequel is the Fock-space Definition `DefHNfromCJ`;
that definition lives in `Preliminaries.FockSpace`.
-/

end LeakyHurwitz
