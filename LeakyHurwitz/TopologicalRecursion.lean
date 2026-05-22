/-
Section 2.5 — Topological recursion (Eynard–Orantin and ABDKS generalisations).
Section 7 — Topological recursion for fixed leakiness.

This module collects:
  * the definition of a *spectral curve* `(Σ, x, y, B)`,
  * the unstable cases `ω_{0,1}` and `ω_{0,2}`,
  * the recursive definition of `ω_{g,n}` for `2g − 2 + n + 1 > 0`,
  * the loop-equation reformulation,
  * the (degenerate, generalised) topological recursion of ABDKS25,
  * the main theorem of Section 7: topological recursion holds for
    leaky Hurwitz numbers with fixed positive leakiness.
-/

import Mathlib.Analysis.Complex.Basic
import LeakyHurwitz.Preliminaries.FockSpace

namespace LeakyHurwitz

/-- Opaque type of meromorphic functions on a Riemann surface with carrier
`Σ`. -/
opaque MeromorphicFunction (_Sigma : Type) : Type

/-- Opaque type of symmetric bidifferentials on `Σ × Σ`. -/
opaque SymmetricBidifferential (_Sigma : Type) : Type

/-- Opaque type of multidifferentials on `Σⁿ`. -/
opaque Multidifferential (_Sigma : Type) (_n : ℕ) : Type

/-- A spectral curve `(Σ, x, y, B)` in the original Eynard–Orantin formulation.

    * `Σ` is a Riemann surface (opaque here).
    * `x`, `y` are meromorphic functions on `Σ` such that all ramification
      points of `x` are simple and disjoint from those of `y`.
    * `B` is a symmetric bidifferential on `Σ` with a double pole on the
      diagonal, biresidue `1`, and no other singularities. -/
structure SpectralCurve where
  /-- The underlying Riemann surface `Σ`. -/
  surface : Type
  /-- A point on `Σ`, witnessing non-emptiness. -/
  point : surface
  /-- The meromorphic function `x : Σ → ℂ`. -/
  x : MeromorphicFunction surface
  /-- The meromorphic function `y : Σ → ℂ`. -/
  y : MeromorphicFunction surface
  /-- The symmetric bidifferential `B`. -/
  B : SymmetricBidifferential surface

namespace SpectralCurve

variable (S : SpectralCurve)

instance : Nonempty S.surface := ⟨S.point⟩

/-- Ramification locus of `x`. -/
noncomputable opaque ramificationLocus : Set S.surface

/-- Local deck transformation `σ_a` near a ramification point `a`. -/
noncomputable opaque deckTransform (_a : S.surface) : S.surface → S.surface

/-- Multidifferentials `ω_{g,n}` produced by topological recursion. -/
axiom multidifferential (_g _n : ℕ) : Multidifferential S.surface _n

/- The unstable cases `ω_{0,1} = y dx` and `ω_{0,2} = B` will be stated
once meromorphic differentials are represented rather than plain functions. -/

end SpectralCurve

/-
The Eynard–Orantin recursion relation (paper eq. defining ω_{g,n+1}):

  ω_{g,n+1}(z₀, z_{⟦n⟧})
   = Σ_{a ∈ R} Res_{z=a} K^a(z₀, z) ·
      [ ω_{g-1,n+2}(z, σ_a(z), z_{⟦n⟧})
        + Σ'_{g₁+g₂=g, I⊔J=⟦n⟧} ω_{g₁,|I|+1}(z, z_I) · ω_{g₂,|J|+1}(σ_a(z), z_J) ].

The exact Lean theorem is deferred until residues, recursion kernels, and
the stable/unstable indexing conventions are represented. -/

/-! ### Loop equations (paper, Proposition `LoopEquations`) -/

/- Linear loop equations, quadratic loop equations, and the projection
property are not stated here yet; the exact analytic predicates still need to
be formalized. -/

/-! ### Degenerate topological recursion (ABDKS25) -/

/-- Special points of a degenerate spectral curve (paper, `DefSpecialPoints`). -/
opaque specialPoints (S : SpectralCurve) : Set S.surface

/- The theorem that degenerate-TR differentials are symmetric and have poles
only at special points is deferred until those predicates are available. -/

/-!
### Main theorem of Section 7

For fixed positive leakiness `k > 0`, the multidifferentials computed from
the leaky completed cycles Hurwitz numbers `h^{k,r}_{g;μ,ν}` (Section 2.2)
satisfy topological recursion on an explicit spectral curve.
-/

/-- Spectral curve associated to a fixed-leakiness cut-and-join operator
    (paper, Section 6). -/
axiom spectralCurveOfFixedLeakiness (_k : ℕ+) : SpectralCurve

/- The Section 7 theorem will be stated after the fixed-leakiness
multidifferentials are connected to the spectral curve above. -/

end LeakyHurwitz
