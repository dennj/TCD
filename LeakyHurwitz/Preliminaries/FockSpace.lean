/-
Section 2.3 — Fock space formalism.

Objects represented, mostly opaquely until the underlying formal algebra is
implemented:
  * the central extension `â_∞` of the infinite general linear Lie algebra,
  * the generating operators `E_{ij}`, the central element `c`,
  * the operators `ℰ_n(u)` and the two-parameter `ℰ(u, z)`,
  * the Heisenberg algebra `J_n = ℰ_n(0)`,
  * the bosonic Fock space `Λ = ℂ[p_1, p_2, …]` and the Heisenberg action,
  * the cut-and-join operators `ℱ_r^k` (Definition `LeakyCompletedOperator`).
-/

import LeakyHurwitz.Preliminaries.Partitions

namespace LeakyHurwitz

/-! ### The Lie algebra `â_∞` -/

/-- The (centrally extended) Lie algebra `â_∞`.

    Opaque; will eventually be implemented as a quotient of a free
    Lie algebra on `{E_{ij}} ∪ {c}` modulo the commutation relations of
    paper eq. (2.13).  We require infinite matrices `a_{ij}` to have only
    finitely many non-zero diagonals above the main diagonal. -/
opaque AInfty : Type

namespace AInfty
axiom instAddCommGroup : AddCommGroup AInfty
attribute [instance] instAddCommGroup
axiom instModule : Module ℂ AInfty
attribute [instance] instModule
/-- The Lie bracket on `â_∞`. -/
axiom bracket : AInfty → AInfty → AInfty
end AInfty

/-- The matrix unit `E_{ij}` (indexed by half-integers `i, j ∈ ℤ'`). -/
noncomputable opaque E (_i _j : ℤ') : AInfty

/-- The central element `c ∈ â_∞`. -/
noncomputable opaque c : AInfty

/-- `ℰ_n(u)`: the generating operator from paper eq. (2.14). -/
noncomputable opaque ℰ (_n : ℤ) (_u : ℂ) : AInfty

/-- Specialisation `J_n = ℰ_n(0)` for `n ≠ 0` (Heisenberg generators). -/
noncomputable opaque J (_n : ℤ) : AInfty

/-- Commutator identity for `ℰ`-operators (paper eq. 2.15). -/
axiom ℰ_commutator (m n : ℤ) (u v : ℂ) :
    AInfty.bracket (ℰ m u) (ℰ n v) =
      varsigma ((m : ℂ) * v - (n : ℂ) * u) • ℰ (m + n) (u + v)

/-- Heisenberg commutator (paper, after eq. 2.15):
    `[J_m, J_n] = m · δ_{m+n,0} · c`. -/
axiom J_commutator (m n : ℤ) :
    AInfty.bracket (J m) (J n) = if m + n = 0 then (m : ℂ) • c else 0

/-! ### Bosonic Fock space -/

/-- Bosonic Fock space `Λ` (charge zero): polynomial ring in
    countably many variables `p_1, p_2, …` over `ℂ`.
    We model it as an opaque commutative `ℂ`-algebra for now. -/
opaque BosonicFock : Type

namespace BosonicFock
axiom instCommRing : CommRing BosonicFock
attribute [instance] instCommRing
axiom instAlgebra : Algebra ℂ BosonicFock
attribute [instance] instAlgebra

/-- The vacuum `|0⟩ = 1 ∈ Λ`. -/
noncomputable opaque vacuum : BosonicFock

/-- The covacuum `⟨0| : Λ → ℂ`, evaluation at `p_k = 0`. -/
noncomputable opaque covacuum : BosonicFock →ₗ[ℂ] ℂ

/-- Vacuum expectation `⟨ 𝒫 ⟩ = ⟨0 | 𝒫 | 0⟩` of an operator on Λ. -/
noncomputable opaque vev (_𝒫 : BosonicFock →ₗ[ℂ] BosonicFock) : ℂ
end BosonicFock

/-! ### Cut-and-join operators -/

/--
The `k`-leaky `r`-completed cycles operator `ℱ_r^k`, defined via the
expansion (paper eq. `LeakyCompletedOperator`)
  ℰ_{-k}(u) = Σ_{r ≥ 0} ℱ_r^k · u^r / r!.
-/
noncomputable opaque cutJoinLeaky (_k : ℤ) (_r : ℕ) : BosonicFock →ₗ[ℂ] BosonicFock

@[inherit_doc] scoped notation "ℱ[" r "," k "]" => LeakyHurwitz.cutJoinLeaky k r

/-- Non-leaky completed cycles operator `ℱ_r = ℱ_r^0`. -/
noncomputable def cutJoin (r : ℕ) : BosonicFock →ₗ[ℂ] BosonicFock :=
  cutJoinLeaky 0 r

/-- The operator `M_k = ℱ_2^k − (k² / 24) · J_{−k}` (paper, after CMRFockSpace). -/
noncomputable opaque M_op (_k : ℤ) : BosonicFock →ₗ[ℂ] BosonicFock

/-!
### `τ`-functions

Following Sato--Segal--Wilson, the orbit of the vacuum under the formal
exponentiation of `â_∞` is the space of KP `τ`-functions.  The paper recalls
Okounkov's theorem identifying the disconnected double-simple Hurwitz
generating series with a Fock-space matrix element and hence with a
2D-Toda/KP `τ`-function.  The exact theorem statement is deferred until the
formal exponential, vacuum expectation, and KP hierarchy are represented.
-/

end LeakyHurwitz
