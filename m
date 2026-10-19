Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CE75B22FC;
	Mon, 19 Oct 2026 14:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418430; cv=none; b=m7t86ap7MwKh7GZOdewkcGXESifqsyW706VnCCxOgUsnK8ZbVll7gp6EaArIaG42QKhEIsYV2zEZO4je5D1lzVMnNiJI09CHeJr000BJn5UL2twbU1VYPdYpDN7+wcq0cWfXN93zF6AbIlbJv19fJsvsFocr4g+jKxV8uWVIJ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418430; c=relaxed/simple;
	bh=HZyHm/8NGS5AjoFW9jMzeT2t1j7Hr38G0rq7hobWajo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YyPpxRDW6kUCH7I6YUHyc3m09PBzOGWLOiqdPRGVyv5Ko1KjnnGFy7ClnGnLAitj2H5S7G6fvJWkO60sIpnIjhUhbjKF+ZNbtXcYGfA+w2H4rQ7JnR7YVNOlBSttWhJWDijiMB1/DKpYRhemJd7phgVU74Neb9y8ECBcLE+uIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLidLT4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLidLT4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836BF1F000C6;
	Mon, 19 Oct 2026 14:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418428;
	bh=CDyUvjRFuY6gb/FANiwi4tYUqLnklY0TRx7rrQv5F9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLidLT4/lGMMuz3I+Yx/yaHIzQjxenx0c4/kA21a9Z7c48Nkv6AeV0jjIcyguY3UD
	 mxUUabP7m1WdQu4n4GsiHY2hAoBfwtID7XB+YwBdWFgpGC0WaqdCUyfCyDQU71kCTk
	 uwV1sJ2ZPGWrtWmplpc5JBpdEvQkywTVbiYoolJJxy6eSJbsPLBmUNL+0TpLMsJdrT
	 d0U/VQ0GecWNIUJECjX1xxjow9XWa3cVsxgVY/hZHS3sXU/RM1fRmz03pDpVC66OOa
	 G4c8OUF8bJ3v31W3oMR9gSlN1t47EVuXi7yqN4NgLiFxdmjYjlzwlRQsoxBI/CnF7O
	 7MhfkTnCBtyHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yong-Xuan Wang <yongxuan.wang@sifive.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] RISC-V: errata: Add SiFive MAL-9092 workaround
Date: Mon, 19 Oct 2026 09:48:53 -0400
Message-ID: <20261019135441.1420968-242-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yong-Xuan Wang <yongxuan.wang@sifive.com>

[ Upstream commit 148ab873d8194cb44f29474da3b4428fa2e100d1 ]

SiFive cores with MAL-9092 require fence.rw instructions around
HLV/HLVX/HSV hypervisor instructions to ensure proper memory ordering
when accessing guest memory.

Note that HSTATUS.HU is cleared during KVM initialization, restricting
hypervisor instructions to HS-mode only. If future changes enable
HSTATUS.HU for U-mode access, additional errata considerations will be
needed.

Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
Reviewed-by: Samuel Holland <samuel.holland@sifive.com>
Link: https://patch.msgid.link/20260817-sifive-errata-v1-1-6a80f1a2743d@sifive.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.y** (`v6.18.57`). This SiFive MAL-9092 change
is a hardware-errata workaround for KVM guest-memory accesses, and the
code it patches is already in this series.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: [subsystem: RISC-V errata/SiFive] [action verb: Add] [workaround
for SiFive MAL-9092: `fence.rw` around HLV/HLVX/HSV]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- No `Fixes:` tag (expected for this review queue)
- No `Reported-by:` / `Tested-by:` / `Acked-by:`
- `Reviewed-by: Samuel Holland <samuel.holland@sifive.com>` (SiFive,
  same vendor)
- `Link: https://patch.msgid.link/20260817-sifive-
  errata-v1-1-6a80f1a2743d@sifive.com`
- `Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>` (author,
  SiFive)
- `Signed-off-by: Paul Walmsley <pjw@kernel.org>` (RISC-V arch
  maintainer)
- No `Cc: stable@vger.kernel.org` (expected; not a negative signal)
- Sasha Levin SOB ignored per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- [Bug] SiFive cores with MAL-9092 do not provide the required memory
  ordering around hypervisor load/store (`HLV`/`HLVX`/`HSV`) when
  touching guest memory.
- [Symptom] Wrong/stale guest instruction or data observed by the host
  hypervisor (KVM unprivileged guest-memory access). Not a documented
  oops; it is an architecture-level ordering hole.
- [Version] None stated. Paul queued it for v7.3-rc. Affected `mimpid`
  values look like 2025-10-31, 2025-12-17, and 2026-03-20 silicon.
- [Root cause] Missing `fence.rw` around those hypervisor instructions
  on specific `marchid`/`mimpid` combinations. `HSTATUS.HU` is left
  clear in KVM setup, so the workaround is HS-mode only.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. It is an explicit hardware-errata
workaround, which is a stable exception category (quirks/workarounds).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `arch/riscv/Kconfig.errata`: +14 (`CONFIG_ERRATA_SIFIVE_MAL_9092`,
  `depends on ERRATA_SIFIVE && 64BIT`, `default y`)
- `arch/riscv/errata/sifive/errata.c`: +20 (`errata_mal_9092_check_func`
  + list entry)
- `arch/riscv/include/asm/errata_list_vendors.h`: +2/-1
  (`ERRATA_SIFIVE_MAL_9092 2`, `ERRATA_SIFIVE_NUMBER 3`)
- `arch/riscv/include/asm/insn-def.h`: +13/-3 (ALTERNATIVE nop→`fence
  rw,rw` around `HLVX_HU`/`HLV_W`/`HLV_D`)
- Total: **4 files, +49/-4**. Functions: `errata_mal_9092_check_func`
  (new), `errata_list[]` (extended), HLV macros. Scope: single-arch
  surgical errata, not a refactor.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- Probe: previously only CIP-453/CIP-1200. After,
  `marchid==0x8000000000000109` and `mimpid` in
  `{0x19251031,0x19251217,0x19260320}` also set bit
  `ERRATA_SIFIVE_MAL_9092`.
- HLV macros: previously a single hypervisor load. After, `nop` (or
  patched `fence rw,rw`) both before and after the instruction via the
  existing `ALTERNATIVE` framework.
- Normal KVM path (`kvm_riscv_vcpu_unpriv_read`), not an error path.
  Unaffected CPUs keep `nop`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: [category: hardware workaround / memory-ordering errata]
[mechanism: SiFive MAL-9092 omits ordering around HS-mode guest-memory
hypervisor ops; alternatives patch in `fence.rw` only on matching CPUs]

No HSV macros exist in this tree; wrapping HLV/HLVX is the complete in-
tree coverage.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Matches CIP-453/CIP-1200 style. CPU-ID gated, `default y`,
reviewed by SiFive and queued by the arch maintainer. Regression risk is
low: extra nops on other CPUs; fences only on listed IDs. Residual
risks: `insn-def.h` relies on include order for
`ALTERNATIVE`/`SIFIVE_VENDOR_ID`/`ERRATA_SIFIVE_MAL_9092`;
`warn_miss_errata()` can warn at boot if KVM is not built-in because the
only alternative sites are in KVM.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record: HLV macros come from `26b73f14933e9c` (2022-10-02, “riscv: KVM:
Apply insn-def to hlv encodings”). SiFive errata probe/list from
`800149a77c2cb8` / `bff3ff525460b4` (2021, CIP-453/CIP-1200). The
hypervisor accessors have been in tree for years; the errata is new
silicon, not new kernel code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The defect is in the CPU, not in a prior kernel
commit. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record: Recent `arch/riscv` errata work is MIPS P8700, T-Head
GHOSTWRITE, vendor-header split (`16d18e3eaf29b`). None of those is a
prerequisite for this patch. Standalone v1, not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Yong-Xuan Wang is a SiFive contributor with RISC-V KVM work in
this history (APLIC, Svade/Svadu). Samuel Holland (SiFive) reviewed. Not
the arch maintainer; Paul Walmsley queued it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs RISC-V alternatives, `ERRATA_SIFIVE`,
`errata_list_vendors.h`, and the HLV macros. All are ancestors of
`v6.18.57` (`git merge-base --is-ancestor` succeeded for `16d18e3eaf29b`
and `26b73f14933e9c`). Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c f36eeaaaecc2c` → https://patch.msgid.link/20260817-sifive-
  errata-v1-1-6a80f1a2743d@sifive.com
- `b4 dig -a`: **v1 only** (2026-08-17). No v2/v3.
- Thread: patch + Paul Walmsley “Thanks, queued for v7.3-rc.” No NAKs,
  no stable nomination, no reviewer risk flags.
- lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig
  -m` mbox.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4 dig -w` To/Cc: Paul Walmsley, Palmer Dabbelt, Albert Ou,
Alexandre Ghiti, Samuel Holland, other SiFive engineers, linux-riscv,
linux-kernel. Appropriate RISC-V maintainers were on the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot/bugzilla/user crash thread. This is a vendor errata
from SiFive, not a fuzzer report. Public MAL-9092 documentation beyond
the patch was not found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Single standalone patch (`[PATCH]`, not `[PATCH 1/N]`). No
follow-ups on these files after this commit on HEAD.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Web search of stable/MAL-9092 found no stable-list discussion
and no stated reason to keep it out of stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `errata_mal_9092_check_func` (new); `errata_list[]`; macros
`ALT_SIFIVE_MAL_9092_FENCE`, `HLVX_HU`, `HLV_W`, `HLV_D`. Existing
`sifive_errata_probe` / `sifive_errata_patch_func` pick it up via
`ERRATA_SIFIVE_NUMBER`.

**Step 5.2: TRACE CALLERS**

Record:
- `HLV*` used only in `arch/riscv/kvm/vcpu_exit.c` →
  `kvm_riscv_vcpu_unpriv_read()`
- Callers of that: `kvm_riscv_vcpu_virtual_insn()` in `vcpu_insn.c`
  (guest insn fetch when `stval` is 0 / 16-bit); `vcpu_sbi_v01.c` (SBI
  0.1 SEND_IPI / remote fence hart-mask reads)
- Context: KVM VM-exit handling, not IRQ-entry core. Reachable whenever
  a guest traps.

**Step 5.3: TRACE CALLEES**

Record: Probe only compares `archid`/`impid`. Patching uses
`patch_text_nosync` under `text_mutex`, same as CIP errata. Macros
expand to `ALTERNATIVE("nop", "fence rw, rw", ...)`.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace QEMU/KVM on RISC-V → guest trap →
`kvm_riscv_vcpu_unpriv_read` → HLV/HLVX. Unprivileged guest code can
induce those exits. Only relevant with `CONFIG_KVM` on matching SiFive
cores.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same pattern as CIP-453 and CIP-1200 in this tree. No HSV macros
in `arch/riscv` at `v6.18.57` or HEAD, so nothing else to wrap here.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: Yes. Local tree: `git describe HEAD` =
`v6.18.57-155-gcdf239ca885b2`, `make kernelversion` = **6.18.57**. `git
merge-base --is-ancestor f36eeaaaecc2c v6.18.57` failed (workaround not
in 6.18.57). `v6.18.57` already has HLV macros in `insn-def.h`, KVM
`vcpu_exit.c`, and SiFive errata with `ERRATA_SIFIVE_NUMBER 2`. The
hardware bug is therefore live for matching CPUs running this series.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: `git diff --stat v6.18.57 f36eeaaaecc2c -- <the four files>` is
exactly +49/-4. Clean apply. No conflicting refactor in 6.18.57 vs this
patch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: `git log --grep=MAL-9092` only finds this candidate. No earlier
equivalent workaround.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: [arch/riscv errata + KVM guest-memory access] [IMPORTANT, not
CORE: RISC-V-specific, and only listed SiFive cores with KVM]. Wrong
guest-memory ordering is still a real virt correctness issue for those
systems.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: RISC-V errata and KVM are actively maintained. This is new-
silicon errata on a mature HLV/KVM path, not a rewrite of a brand-new
subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: RISC-V + `CONFIG_ERRATA_SIFIVE` (selected by `ARCH_SIFIVE`) +
`CONFIG_64BIT` + KVM + `marchid 0x8000000000000109` with one of three
`mimpid`s. Driver/platform-specific, not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Trigger is KVM using HLV/HLVX to read guest memory (instruction
emulate, SBI 0.1 hart masks). Common for any VM on those cores. Guest
(typically unprivileged) can cause the VM-exit. Not a rare error-path-
only bug.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: [Failure mode: missing memory fence → stale/wrong guest insn or
data in the hypervisor] [Severity: HIGH — guest corruption or incorrect
emulation; not a documented host panic]. Silent wrongness is worse than
a WARN.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: HIGH for KVM on the listed SiFive cores (correct guest-memory
  access).
- Risk: LOW — ~50 lines, ID-gated alternatives, same mechanism as
  CIP-1200 already in 6.18.57. Unaffected CPUs only gain nops.
- Ratio: benefit outweighs risk for this 6.18.y tree.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Hardware errata/quirk, which stable explicitly accepts
- Real KVM guest-memory ordering bug on shipping/soon-shipping SiFive
  cores
- Small (+49/-4), uses existing alternatives/errata machinery
- HLV/KVM/SiFive errata all present in 6.18.57; applies cleanly
- Reviewed by SiFive, queued by RISC-V arch maintainer, no NAKs
- CPU-ID match so other RISC-V systems are not functionally changed

AGAINST:
- New Kconfig symbol (standard for RISC-V errata, `default y`)
- No field crash/syzbot report (vendor errata, typical)
- Possible `warn_miss_errata` noise if KVM is disabled on an affected
  CPU
- HSV mentioned in text but no HSV macros here (not a functional gap in
  6.18.y)

UNRESOLVED:
- Public MAL-9092 datasheet text was not found (only the kernel patch)
- lore.kernel.org HTTP 403; discussion recovered from b4 mbox instead

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — ID-gated alternative fences;
   SiFive review; maintainer queued for 7.3-rc
2. Fixes a real bug that affects users? **PASS** — KVM guest-memory
   ordering on listed cores
3. Important issue? **PASS** — HIGH: incorrect hypervisor guest
   instruction/data reads (corruption / bad emulation)
4. Small and contained? **PASS** — 4 files, +49/-4
5. No new features or APIs? **PASS** — no userspace ABI; Kconfig is the
   usual errata toggle
6. Can apply to the local tree? **PASS** — clean vs `v6.18.57`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Hardware quirk/workaround (SiFive CPU errata), same class as
USB/PCI quirks and existing CIP-453/CIP-1200.

**Step 9.4: DECISION**

This belongs on **this** 6.18.y tree. The HLV path has been here since
2022; 6.18.57 just lacks the fence workaround. LTS users who run KVM on
these SiFive cores get a contained, ID-gated fix with the same shape as
errata already in the series.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Samuel Holland; Link to msgid
  20260817-sifive-errata-v1-1; SOB Yong-Xuan Wang and Paul Walmsley; no
  Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +49/-4 across Kconfig.errata, errata.c,
  errata_list_vendors.h, insn-def.h; ALTERNATIVE nop→fence around
  HLVX_HU/HLV_W/HLV_D
- [Phase 3] git blame v6.18.57 insn-def.h: HLV macros from
  26b73f14933e9c (2022); errata framework from 2021 CIP commits
- [Phase 3] No Fixes: tag; standalone, not a series
- [Phase 3] git merge-base --is-ancestor 26b73f14933e9c v6.18.57 → yes;
  16d18e3eaf29b v6.18.57 → yes
- [Phase 4] b4 dig -c f36eeaaaecc2c: lore URL found; -a: v1 only; -w:
  RISC-V maintainers on To/Cc; mbox: Paul “queued for v7.3-rc”; no NAK
- [Phase 4] lore WebFetch 403; mbox used instead
- [Phase 5] HLV* only used in kvm/vcpu_exit.c; callers vcpu_insn.c and
  vcpu_sbi_v01.c; git grep HSV_ in arch/riscv: none
- [Phase 6] git describe HEAD: v6.18.57-155-gcdf239ca885b2;
  kernelversion 6.18.57
- [Phase 6] git merge-base --is-ancestor f36eeaaaecc2c v6.18.57 → not in
  6.18.57; git grep MAL-9092 v6.18.57 → none
- [Phase 6] git diff --stat v6.18.57 f36eeaaaecc2c -- the four files →
  exact patch, clean apply
- [Phase 7] ARCH_SIFIVE selects ERRATA_SIFIVE; KVM is
  arch/riscv/kvm/Kconfig
- [Phase 8] Failure mode: missing fence → wrong guest memory in KVM,
  severity HIGH
- UNVERIFIED: full public MAL-9092 silicon manual; compile of
  vcpu_exit.c was inferred from include order, not by building

The workaround is small, ID-gated, and fixes a real KVM memory-ordering
erratum on hardware that 6.18.y can boot. It meets the stable rules and
the hardware-quirk exception.

**YES**

 arch/riscv/Kconfig.errata                    | 14 ++++++++++++++
 arch/riscv/errata/sifive/errata.c            | 20 ++++++++++++++++++++
 arch/riscv/include/asm/errata_list_vendors.h |  3 ++-
 arch/riscv/include/asm/insn-def.h            | 16 +++++++++++++---
 4 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index 6f230aebd4968..65d00fb9db9d7 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -95,6 +95,20 @@ config ERRATA_STARFIVE_JH7100
 	  Say "Y" if you want to support the BeagleV Starlight and/or
 	  StarFive VisionFive V1 boards.
 
+config ERRATA_SIFIVE_MAL_9092
+	bool "Apply SiFive HLV/HLVX/HSV fence errata"
+	depends on ERRATA_SIFIVE && 64BIT
+	default y
+	help
+	  This will apply the SiFive MAL-9092 errata to add fence.rw
+	  instructions around all HLV/HLVX/HSV instructions.
+
+	  Note: HSTATUS.HU is cleared during KVM initialization. If future
+	  changes enable HSTATUS.HU to allow hypervisor instructions in
+	  U-mode, additional errata handling may be required.
+
+	  If you don't know what to do here, say "Y".
+
 config ERRATA_THEAD
 	bool "T-HEAD errata"
 	depends on RISCV_ALTERNATIVE
diff --git a/arch/riscv/errata/sifive/errata.c b/arch/riscv/errata/sifive/errata.c
index 38aac2c47845a..3025b9d6966f8 100644
--- a/arch/riscv/errata/sifive/errata.c
+++ b/arch/riscv/errata/sifive/errata.c
@@ -51,6 +51,22 @@ static bool errata_cip_1200_check_func(unsigned long  arch_id, unsigned long imp
 	return true;
 }
 
+static bool errata_mal_9092_check_func(unsigned long  arch_id, unsigned long impid)
+{
+	/*
+	 * Affected cores:
+	 * Architecture ID: 0x8000000000000109
+	 * Implementation ID: 0x19251031, 0x19251217, 0x19260320
+	 */
+
+	if (arch_id != 0x8000000000000109)
+		return false;
+	if (impid != 0x19251031 && impid != 0x19251217 && impid != 0x19260320)
+		return false;
+
+	return true;
+}
+
 static struct errata_info_t errata_list[ERRATA_SIFIVE_NUMBER] = {
 	{
 		.name = "cip-453",
@@ -60,6 +76,10 @@ static struct errata_info_t errata_list[ERRATA_SIFIVE_NUMBER] = {
 		.name = "cip-1200",
 		.check_func = errata_cip_1200_check_func
 	},
+	{
+		.name = "mal-9092",
+		.check_func = errata_mal_9092_check_func
+	},
 };
 
 static u32 __init_or_module sifive_errata_probe(unsigned long archid,
diff --git a/arch/riscv/include/asm/errata_list_vendors.h b/arch/riscv/include/asm/errata_list_vendors.h
index ec7eba3734371..c62a82f60468a 100644
--- a/arch/riscv/include/asm/errata_list_vendors.h
+++ b/arch/riscv/include/asm/errata_list_vendors.h
@@ -11,7 +11,8 @@
 #ifdef CONFIG_ERRATA_SIFIVE
 #define	ERRATA_SIFIVE_CIP_453 0
 #define	ERRATA_SIFIVE_CIP_1200 1
-#define	ERRATA_SIFIVE_NUMBER 2
+#define	ERRATA_SIFIVE_MAL_9092 2
+#define	ERRATA_SIFIVE_NUMBER 3
 #endif
 
 #ifdef CONFIG_ERRATA_THEAD
diff --git a/arch/riscv/include/asm/insn-def.h b/arch/riscv/include/asm/insn-def.h
index d29da6ccd3dd8..b1b97eab91007 100644
--- a/arch/riscv/include/asm/insn-def.h
+++ b/arch/riscv/include/asm/insn-def.h
@@ -191,18 +191,28 @@
 	INSN_R(OPCODE_SYSTEM, FUNC3(0), FUNC7(49),		\
 	       __RD(0), RS1(gaddr), RS2(vmid))
 
+#define ALT_SIFIVE_MAL_9092_FENCE					\
+ALTERNATIVE("nop", "fence rw, rw", SIFIVE_VENDOR_ID,			\
+	    ERRATA_SIFIVE_MAL_9092, CONFIG_ERRATA_SIFIVE_MAL_9092)
+
 #define HLVX_HU(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(50),		\
-	       RD(dest), RS1(addr), __RS2(3))
+	       RD(dest), RS1(addr), __RS2(3)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 
 #define HLV_W(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(52),		\
-	       RD(dest), RS1(addr), __RS2(0))
+	       RD(dest), RS1(addr), __RS2(0)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 
 #ifdef CONFIG_64BIT
 #define HLV_D(dest, addr)					\
+	ALT_SIFIVE_MAL_9092_FENCE "\n"				\
 	INSN_R(OPCODE_SYSTEM, FUNC3(4), FUNC7(54),		\
-	       RD(dest), RS1(addr), __RS2(0))
+	       RD(dest), RS1(addr), __RS2(0)) "\n"		\
+	ALT_SIFIVE_MAL_9092_FENCE
 #else
 #define HLV_D(dest, addr)					\
 	__ASM_STR(.error "hlv.d requires 64-bit support")
-- 
2.53.0

