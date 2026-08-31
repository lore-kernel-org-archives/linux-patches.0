Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02437552925;
	Mon, 31 Aug 2026 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184017; cv=none; b=ghYnsb16YYYdQg4FvaQhVgqQ0YZ/eA3o0Wa2WyFYXaDe4h35vqWLNy92tUrlJqrFN+r8LbjOFatSD0qwvGtRTvsdqGzeC8PEIdZdMy1VhDYnvPGTHBxFg7NbLREa5GF7hT+Jl4az/f/ev7GATO4eH4IcfdmlQZzuUj9L6lpCivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184017; c=relaxed/simple;
	bh=MG7I1D4ufAI7jrXsZRNa2o6kbzQihBa3/3eUbODy4/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WPn8sdjNI6m9mGzJE6hcusrbe8NR2bYyZ6aXNVmwd9dg8vLEJlUm6+bFHSbvAHcD+ilDNgdSdnB1bmoe6oOQhtKfvMQxlaGIdnvyw0WGYXTRulOx8Jiub26qj4wS5jn8r8bEF6BcR7vF+IJ3Y4smZQEF6vi9TwnuyNI8okNvKZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRaVN1Et; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRaVN1Et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8277D1F00ACF;
	Mon, 31 Aug 2026 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184013;
	bh=CidNdpnOwPaWgqdN5zzQ/+4Wjai7x6h2A9meyleHZA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRaVN1EtpJuUVSy6nHg2Eu3nBGfPUnDcE9BLyDDKzOzyI12Ul+kkbNJLiO9OKfWdo
	 034GTw1D+5Z1STkeB12u+Nm8bOCczoDlCg09v1TZLDJTnhgPbqJ7wU7knkKGeP2N6p
	 stwuEDWGx5SDewqXhQ9kdhoRiplKMuduV2Yw3x13jX6KpdKe3OKzzYnTbBAWqxFX1C
	 v68XQUlADiBEX1wMnViybsnpweho3J7H3t/0gQnMMsmTP2Wx7CECf/YBf64jYOCder
	 cVgVxdeVFTV9kKa18v3FYzJLC5eVmRBRczL1bhYG86DwUEONSGvZV3/3lu82j7P6zo
	 yHHGlSxO7qS6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Han Gao <gaohan@iscas.ac.cn>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] riscv: also select ARCH_KEEP_MEMBLOCK if kexec is selected
Date: Mon, 31 Aug 2026 09:27:46 -0400
Message-ID: <20260831133314.4125787-438-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Han Gao <gaohan@iscas.ac.cn>

[ Upstream commit bce35135fecc7a73c60aaa9d2ec699ead1e32661 ]

On RISC-V, also select ARCH_KEEP_MEMBLOCK if kexec is selected, not
only if ACPI is selected.  This is because kexec requires the memblock
areas to be kept after boot to initialize the secondary kernel.  This
is needed for both Device Tree and ACPI platforms.

Signed-off-by: Han Gao <gaohan@iscas.ac.cn>
Link: https://patch.msgid.link/20260519165546.123105-1-gaohan@iscas.ac.cn
[pjw@kernel.org: change to add the dependency on kexec, rather than making it unconditional;
 rewrite the patch description accordingly]
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[riscv]` `[also select]` — Extend `ARCH_KEEP_MEMBLOCK`
Kconfig selection on RISC-V to cover kexec, not only ACPI.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Han Gao `<gaohan@iscas.ac.cn>` (author)
- **Link:**
  https://patch.msgid.link/20260519165546.123105-1-gaohan@iscas.ac.cn
- **Signed-off-by:** Paul Walmsley `<pjw@kernel.org>` (maintainer,
  rewrote approach)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: maintainer rework note in commit message — original patch was
  unconditional; final version scopes to `KEXEC`

### Step 1.3: Body analysis
**Record:**
- **Bug:** On RISC-V, `ARCH_KEEP_MEMBLOCK` is selected only when `ACPI`
  is enabled. Device Tree platforms with kexec enabled do not keep
  memblock data after boot.
- **Symptom:** kexec cannot properly initialize the secondary kernel
  because it needs live memblock region information at runtime.
- **Root cause (author):** kexec depends on memblock areas remaining
  available after boot; the ACPI-only guard was incomplete.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although phrased as a Kconfig dependency correction,
this fixes broken/unreliable kexec and kdump on non-ACPI RISC-V
platforms — a functional correctness bug, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `arch/riscv/Kconfig` only (+1/−1 line)
- **Functions:** None (Kconfig only)
- **Scope:** Single-file, surgical Kconfig fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `select ARCH_KEEP_MEMBLOCK if ACPI` — memblock metadata
  discarded after boot on DT-only configs, even with `CONFIG_KEXEC`.
- **After:** `select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC` — memblock
  kept when kexec is enabled, regardless of firmware type.
- **Path affected:** Build-time config selection; runtime kexec memory-
  hole discovery in generic kexec code.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic/correctness — missing Kconfig dependency
- **Mechanism:** Without `ARCH_KEEP_MEMBLOCK`, `memblock_discard()` runs
  during `mem_init()`. Generic kexec then uses the
  `kexec_walk_resources()` iomem fallback instead of
  `kexec_walk_memblock()`. On RISC-V DT systems (the common case), kexec
  memory placement can be wrong or fail (`-EADDRNOTAVAIL`), breaking
  kexec reboot and kdump. arm64 unconditionally selects
  `ARCH_KEEP_MEMBLOCK`; RISC-V was inconsistent.

### Step 2.4: Fix quality
**Record:**
- Obviously correct: ties memblock retention to the feature that needs
  it.
- Minimal: one-line change.
- Low regression risk: only affects kernels built with `CONFIG_KEXEC`;
  adds small retained memblock metadata (same trade-off arm64 already
  makes).
- Maintainer-scoped the fix from unconditional to `KEXEC`-only, reducing
  blast radius.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Current line introduced by `e8065df5b0c460` (Sunil V L, Oct 2023):
  "RISC-V: ACPI: Enhance acpi_os_ioremap with MMIO remapping" — added
  `ARCH_KEEP_MEMBLOCK if ACPI` for ACPI memblock queries.
- RISC-V kexec support dates to 5.13 (`fba8a8674f68a`); kdump since
  5.13. The ACPI-only memblock guard left DT+kexec without the needed
  dependency for years.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag. Bug introduced by incomplete scoping
in `e8065df5b0c460`.

### Step 3.3: Related file history
**Record:**
- Recent `arch/riscv/Kconfig` churn is unrelated (CFI, insn, NUMA).
- Standalone one-patch fix; not part of a series.
- Upstream mainline commit: `bce35135fecc7` (merged Jun 7, 2026). Exists
  in repo as stable-prep commit `c3f1b5f4a3a85` but is **not** in
  current HEAD.

### Step 3.4: Author context
**Record:** Han Gao is an active RISC-V contributor (ACPI, DTS, compat
fixes). Paul Walmsley is the RISC-V maintainer who accepted and refined
the patch.

### Step 3.5: Dependencies
**Record:** No prerequisites. `KEXEC` symbol exists in
`kernel/Kconfig.kexec`; RISC-V has `ARCH_SUPPORTS_KEXEC def_bool y`.
Patch applies cleanly (`git apply --check` passed).

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260519165546.123105-1-gaohan@iscas.ac.cn
- **Series:** v1 only (original subject: "unconditionally select
  ARCH_KEEP_MEMBLOCK")
- **Maintainer feedback:** Paul Walmsley asked to scope to kexec rather
  than make it unconditional; committed version follows that guidance.
- No NAKs found. No explicit stable nomination.

### Step 4.2: Reviewers
**Record:** CC'd: Paul Walmsley, Palmer Dabbelt, Albert Ou, Alexandre
Ghiti, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org.

### Step 4.3: Bug reports
**Record:** No external bug report, syzbot, or user `Reported-by:`. Bug
identified by developer analysis of kexec/memblock interaction.

### Step 4.4: Related patches
**Record:** Standalone. Maintainer suggested tying to
`ARCH_SELECTS_KEXEC`; final patch uses `KEXEC` in the `RISCV` config
select instead.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found in the mbox thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** No C functions modified. Runtime impact is through existing
generic code:
- `kexec_locate_mem_hole()` in `kernel/kexec_file.c`
- `memblock_discard()` in `mm/memblock.c`
- RISC-V `init_resources()` / `reserve_memblock_reserved_regions()` in
  `arch/riscv/kernel/setup.c`

### Step 5.2: Callers
**Record:** `kexec_locate_mem_hole()` is called from
`kexec_add_buffer()`, used throughout RISC-V kexec_file loading
(`machine_kexec_file.c`, `kexec_elf.c`, `kexec_image.c`) — reachable
from the `kexec_file_load` syscall when users load a new kernel or crash
kernel.

### Step 5.3: Callees
**Record:** With fix, kexec uses `kexec_walk_memblock()` →
`for_each_free_mem_range()` with `MEMBLOCK_NONE`, correctly skipping
driver-managed regions. Without fix, falls back to
`kexec_walk_resources()` → `walk_system_ram_res()`.

### Step 5.4: Reachability
**Record:** Reachable from userspace via kexec syscalls on any RISC-V
system with `CONFIG_KEXEC` enabled. DT platforms are the majority of
RISC-V hardware (VisionFive, Milk-V, Sophgo, StarFive, QEMU virt without
ACPI, etc.).

### Step 5.5: Similar patterns
**Record:**
- arm64: `select ARCH_KEEP_MEMBLOCK` (unconditional)
- x86, arm, mips, loongarch, powerpc: unconditional `ARCH_KEEP_MEMBLOCK`
- RISC-V is the outlier with ACPI-only selection

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Local tree is **v6.18.44** (`git describe HEAD`).
Current line:

```59:59:arch/riscv/Kconfig
        select ARCH_KEEP_MEMBLOCK if ACPI
```

Fix commit `bce35135fecc7` / `c3f1b5f4a3a85` is **not** an ancestor of
HEAD. RISC-V kexec support is fully present (`ARCH_SUPPORTS_KEXEC`,
`machine_kexec_file.c`, etc.).

### Step 6.2: Backport complications
**Record:** Clean apply confirmed. No conflicting changes in
`arch/riscv/Kconfig` at this line.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix in HEAD. ACPI-only guard remains.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `arch/riscv` — platform-specific but kexec/kdump affects
production RISC-V deployments. **Criticality: IMPORTANT** (not universal
like mm/, but kdump is operationally critical where enabled).

### Step 7.2: Activity
**Record:** RISC-V kexec actively developed (kexec_file Image support in
6.16, CMA allocation, recent NULL-deref fix in `machine_kexec_prepare`).
This gap is relevant to the current tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** RISC-V users with `CONFIG_KEXEC` (and typically
`CONFIG_KEXEC_FILE`, `CONFIG_CRASH_DUMP`) on **Device Tree** platforms
without ACPI — the dominant RISC-V configuration.

### Step 8.2: Trigger conditions
**Record:** Triggered whenever a user loads or executes a kexec image
(`kexec -e`, kdump after panic). Common for intentional kexec; rare but
critical for kdump.

### Step 8.3: Failure mode severity
**Record:**
- kexec load failure (`-EADDRNOTAVAIL`) or booting secondary kernel into
  wrong memory
- kdump failure after kernel crash — no crash dump captured
- **Severity: HIGH** for kexec/kdump users; **LOW** for users without
  `CONFIG_KEXEC`

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for RISC-V kexec/kdump users — restores intended
  memblock-based memory discovery
- **Risk:** VERY LOW — one-line Kconfig, maintainer-approved, mirrors
  other architectures
- **Ratio:** Strong benefit, negligible risk

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real functional bug: DT RISC-V + kexec lacks `ARCH_KEEP_MEMBLOCK`
- Maintainer accepted and committed upstream
- arm64 and other arches keep memblock for kexec
- Trivial, obviously correct one-line fix
- Applies cleanly to v6.18.44
- Affects kdump — operationally important
- RISC-V kexec fully present in this tree

**AGAINST backport:**
- No user bug report or syzbot report
- iomem fallback may work on simple memory layouts (incomplete
  mitigation)
- Only affects `CONFIG_KEXEC` builds
- Not a general-purpose crash or security vulnerability

**Unresolved:** No reproduction log in mailing list; impact severity on
specific boards not independently verified with a failing test case.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — maintainer-reviewed Kconfig
   dependency; logic is clear.
2. Fixes a real bug affecting users? **PASS** — kexec/kdump broken on DT
   RISC-V without this.
3. Important issue? **PASS** — kexec/kdump failure (HIGH for affected
   users).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — corrects existing config
   dependency only.
6. Can apply to local tree? **PASS** — clean apply verified; buggy code
   present.

### Step 9.3: Exception categories
**Record:** None strictly, but analogous to a build/config fix that
enables correct behavior of an existing feature.

### Step 9.4: Decision rationale
This is a maintainer-approved Kconfig correction that fixes kexec/kdump
on the most common RISC-V platform type (Device Tree without ACPI). The
fix is minimal, applies cleanly to the local v6.18.44 tree, and aligns
RISC-V with arm64's established pattern. The missing dependency has been
present since ACPI memblock support was added in 2023 while kexec has
been supported since 5.13.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show bce35135fecc7`
- **[Phase 2]** Diff analysis: 1-line Kconfig change in
  `arch/riscv/Kconfig`
- **[Phase 3]** `git blame -L 55,65 arch/riscv/Kconfig`: ACPI-only line
  from `e8065df5b0c460` (Oct 2023)
- **[Phase 3]** `git log --oneline --reverse --grep=kexec --
  arch/riscv/`: kexec since `fba8a8674f68a` (5.13)
- **[Phase 3]** `git merge-base --is-ancestor c3f1b5f4a3a85 HEAD`: fix
  **NOT** in tree
- **[Phase 3]** `git apply --check` on upstream patch: **clean apply**
- **[Phase 4]** `b4 dig -c c3f1b5f4a3a85`: found lore thread
- **[Phase 4]** `b4 dig -a`: v1 series only
- **[Phase 4]** `b4 dig -w`: Paul Walmsley, Palmer Dabbelt, Alexandre
  Ghiti CC'd
- **[Phase 4]** `/tmp/kexec_memblock.mbx`: maintainer scoped fix to
  kexec; no stable Cc, no NAK
- **[Phase 5]** Read `kernel/kexec_file.c` lines 586–744: memblock vs
  iomem walk selection
- **[Phase 5]** Read `mm/memblock.c` lines 100–103, 380–409: memblock
  discarded without `ARCH_KEEP_MEMBLOCK`
- **[Phase 5]** Grep `arch/*/Kconfig`:
  arm64/x86/arm/mips/loongarch/powerpc select `ARCH_KEEP_MEMBLOCK`
  unconditionally
- **[Phase 6]** `git describe HEAD`: v6.18.44; `make kernelversion`:
  6.18.44
- **[Phase 6]** Grep `arch/riscv/Kconfig`: buggy `if ACPI` line
  confirmed present
- **[Phase 6]** Verified RISC-V kexec files exist:
  `machine_kexec_file.c`, `ARCH_SUPPORTS_KEXEC`
- **[Phase 8]** Confirmed `CONFIG_KEXEC` symbol exists in
  `kernel/Kconfig.kexec`
- **UNVERIFIED:** No hands-on kexec failure reproduction on a DT RISC-V
  board

**YES**

 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index fadec20b87a8e..02e2289596989 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -56,7 +56,7 @@ config RISCV
 	select ARCH_HAS_UBSAN
 	select ARCH_HAS_VDSO_ARCH_DATA if HAVE_GENERIC_VDSO
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
-	select ARCH_KEEP_MEMBLOCK if ACPI
+	select ARCH_KEEP_MEMBLOCK if ACPI || KEXEC
 	select ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE	if 64BIT && MMU
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_OPTIONAL_KERNEL_RWX_DEFAULT
-- 
2.53.0

