/-
Section 2.4 — Tropical covers (and leaky tropical covers).

Objects formalised:
  * `TropicalCurve` — abstract metric graph with vertex-genus and a length
    function `ℓ : E → ℝ ∪ {∞}`.
  * `TropicalCover` — surjective harmonic map between geometric realisations.
  * `LeakyTropicalCover` — drops the balancing condition; records the
    leakiness `k_w` at each interior vertex.
  * Wick's theorem (statement only).

Implementation note: we use `Mathlib.Combinatorics.SimpleGraph` extended with
multi-edges via `Quiver` or by carrying the edge type explicitly.  For the
purposes of this skeleton, the graph data is opaque.
-/

import Mathlib.Combinatorics.SimpleGraph.Basic
import Mathlib.Data.ENNReal.Basic
import Mathlib.Data.List.Sort
import LeakyHurwitz.Preliminaries.FockSpace

namespace LeakyHurwitz

attribute [local instance] Classical.propDecidable

open scoped ENNReal in
/-- Length values: a non-negative real, or `+∞` (corresponding to ends). -/
abbrev EdgeLength : Type := ENNReal

/--
An abstract tropical curve `Γ`:
  * vertex set `V`,
  * edge set `E` (possibly with multi-edges; modelled by a multiset of pairs),
  * length function `ℓ : E → ℝ ∪ {∞}`,
  * vertex-genus `g : V⁰ → ℕ` on the interior vertices,
  * leaves `V^∞` = one-valent vertices (no separate field; derivable from
    the incidence relation).

This is an opaque structure-level skeleton: a full Mathlib-style record
will eventually replace it.
-/
structure TropicalCurve where
  V : Type
  E : Type
  fintypeV : Fintype V
  fintypeE : Fintype E
  /-- Incidence: every edge has two endpoints (unordered, with multiplicity). -/
  endpoints : E → V × V
  /-- Length function. -/
  length : E → EdgeLength
  /-- Vertex genus. Defined on all vertices; zero on leaves. -/
  vertexGenus : V → ℕ

namespace TropicalCurve

variable (Γ : TropicalCurve)

attribute [instance] TropicalCurve.fintypeV TropicalCurve.fintypeE

/-- Incidence of a vertex and an edge. -/
def IsIncident (v : Γ.V) (e : Γ.E) : Prop :=
  (Γ.endpoints e).1 = v ∨ (Γ.endpoints e).2 = v

/-- The valency of a vertex. (Counts edge-endpoints, so a loop contributes 2.) -/
opaque valence : Γ.V → ℕ

/-- An interior vertex: valency ≠ 1. -/
def isInterior (v : Γ.V) : Prop := valence Γ v ≠ 1

/-- A leaf: one-valent vertex. -/
def isLeaf (v : Γ.V) : Prop := valence Γ v = 1

/-- First Betti number `b¹(Γ) = |E| − |V| + (#connected components)`. -/
opaque firstBetti : ℕ

/-- Total genus `g(Γ) = b¹(Γ) + Σ_v g(v)` (Section 2.4 Definition). -/
opaque totalGenus : ℕ

end TropicalCurve

/--
A tropical cover `π : Γ₁ → Γ₂` (paper Definition `def:tropcov`):
  * a surjective map on vertices and edges,
  * each edge `e ∈ E(Γ₁)` carries a positive integer weight `ω(e)` such that
    `π|_e : [0, ℓ(e)] → [0, ℓ(π(e))]` is `t ↦ ω(e) · t`,
  * the *balancing / harmonicity* condition: the local degree `d_v` is
    independent of the choice of adjacent edge in the target.
-/
structure TropicalCover (Γ₁ Γ₂ : TropicalCurve) where
  onVertices : Γ₁.V → Γ₂.V
  onEdges    : Γ₁.E → Γ₂.E
  weight     : Γ₁.E → ℕ+
  surj_V     : Function.Surjective onVertices
  surj_E     : Function.Surjective onEdges
  /-- Whether `π⁻¹((e')ᵒ) ∩ e` is nonempty in the paper's local-degree
  formula. This is geometric data until edge realisations are implemented. -/
  interiorPreimageMeets : Γ₁.E → Γ₂.E → Prop
  /-- The local degree at `v`, measured in the target direction `e'`. -/
  localDegreeAlong : Γ₁.V → Γ₂.E → ℕ
  /-- Paper formula for the local degree in a chosen target direction. -/
  localDegreeAlong_eq_sum : ∀ (v : Γ₁.V) (e' : Γ₂.E),
    localDegreeAlong v e' =
      ∑ e : Γ₁.E,
        if Γ₁.IsIncident v e ∧ interiorPreimageMeets e e' then (weight e : ℕ) else 0
  /-- Harmonicity/balancing: the local degree is independent of the adjacent
  target edge `e'` at `π(v)`. -/
  harmonic : ∀ (v : Γ₁.V) (e₁ e₂ : Γ₂.E),
    Γ₂.IsIncident (onVertices v) e₁ →
    Γ₂.IsIncident (onVertices v) e₂ →
    localDegreeAlong v e₁ = localDegreeAlong v e₂

namespace TropicalCover

variable {Γ₁ Γ₂ : TropicalCurve} (π : TropicalCover Γ₁ Γ₂)

/-- Local degree `d_v` at a vertex of the source. It is obtained by choosing
an adjacent target edge; harmonicity proves independence of this choice once
the relevant existence lemmas are available. -/
noncomputable opaque localDegree (_v : Γ₁.V) : ℕ

/-- Global degree, independent of the chosen target vertex (by harmonicity). -/
noncomputable opaque degree : ℕ

/-- Ramification profile of an end of the target. -/
opaque ramificationProfile (_e : Γ₂.E) : List ℕ+

end TropicalCover

/--
The tropical projective line `ℙ¹_trop = ℝ ∪ {±∞}`, possibly subdivided by
finitely many two-valent vertices `p₁ < … < p_r ∈ ℝ`.

We represent it as the data of the inner subdivision points.
-/
structure TropicalP1 where
  innerPoints : List ℝ
  sorted : innerPoints.SortedLT

/-- The inherited map conditions for a leaky cover of `ℙ¹_trop`: conditions
(1) and (2) of the paper's tropical-cover definition, namely surjectivity on
vertices/edges of the subdivided tropical line and integral-affine behaviour
with slope `weight e` on every source edge. -/
opaque SatisfiesP1MapConditions
    (_Γ : TropicalCurve) (_P : TropicalP1)
    (_onVertices : _Γ.V → ℝ) (_weight : _Γ.E → ℕ+) : Prop

/--
A leaky tropical cover of `ℙ¹_trop` (paper definition after `def:tropcov`):

The surjectivity and weighted-affine conditions of `TropicalCover` hold,
but the harmonicity is *replaced* by recording the leakiness
`k_w = d_w^1 − d_w^2` at each interior vertex of `Γ`, where `d_w^j` is the
local degree counted on the side `j ∈ {1, 2}`.
-/
structure LeakyTropicalCover (Γ : TropicalCurve) (P : TropicalP1) where
  onVertices : Γ.V → ℝ -- maps to the geometric realisation
  weight     : Γ.E → ℕ+
  map_conditions : SatisfiesP1MapConditions Γ P onVertices weight
  /-- Local degree toward the negative direction at a vertex. -/
  leftDegree : Γ.V → ℕ
  /-- Local degree toward the positive direction at a vertex. -/
  rightDegree : Γ.V → ℕ
  leakiness  : Γ.V → ℤ
  /-- `k_w = d_w^1 - d_w^2`. -/
  leakiness_eq : ∀ v, leakiness v = (leftDegree v : ℤ) - (rightDegree v : ℤ)
  /-- Leakiness is defined to be zero on leaves. -/
  leakiness_leaf : ∀ v, Γ.isLeaf v → leakiness v = 0

namespace LeakyTropicalCover

variable {Γ : TropicalCurve} {P : TropicalP1} (π : LeakyTropicalCover Γ P)

/-- The multiplicity of a leaky tropical cover (paper eq. 2.X):
    `mult(π) = (1 / |Aut π|) · ∏ |Aut x_i^+| |Aut x_i^-| · ∏_e ω(e)`. -/
opaque multiplicity : ℚ

end LeakyTropicalCover

/-!
The paper next states Wick's theorem and the completed-cycle expansion
`prop-expansion`.  Their exact Lean statements should be added only after the
operator products, normal ordering, and indexing type of covers of a fixed
type have been formalized; we avoid installing weakened `True` placeholders.
-/

end LeakyHurwitz
