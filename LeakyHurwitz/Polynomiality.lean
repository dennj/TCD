/-
Section 3 — Polynomiality and wall-crossing for leaky Hurwitz numbers.

Main results of this section in the paper:

  * **Universal piecewise polynomiality** (Theorem 3.X, generalising AKL25):
    the completed cycles `(k, r)`-leaky Hurwitz number
    `h^{k,r}_{g;μ,ν}` is piecewise polynomial in `(μ, ν, k)`, with the
    "universal" property that the polynomiality extends to the leakiness
    parameters.

  * **Cubic wall-crossing** (Theorem 3.Y): the difference of polynomials
    on adjacent chambers of polynomiality is expressed in terms of
    completed cycles leaky Hurwitz numbers with strictly smaller input
    data. Unlike the disconnected version of AKL25 (quadratic), the
    connected variant has a *cubic* wall-crossing kernel.

The exact theorem statements will be added once the leaky resonance
arrangement, chambers, and smaller-input Hurwitz terms have been formalized.
-/

import LeakyHurwitz.Preliminaries.HurwitzNumbers
import LeakyHurwitz.TropicalCovers

namespace LeakyHurwitz

/-! ### Formal set-up: chambers of polynomiality -/

/-- A *chamber* in the parameter space `(μ, ν, k) ∈ ℤ^{ℓ(μ)+ℓ(ν)} × ℤ` is
    a connected component of the complement of the *resonance arrangement*.
    Opaque for now. -/
opaque Chamber : Type

/-- The wall-crossing kernel between two adjacent chambers. Cubic in the
    paper's connected setting, quadratic in the disconnected setting of
    AKL25. -/
opaque wallCrossingKernel : Chamber → Chamber → ℚ

/- The paper's universal piecewise-polynomiality and wall-crossing theorems
are deliberately not installed as weakened placeholders. -/

end LeakyHurwitz
