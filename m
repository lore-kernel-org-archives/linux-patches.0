Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055324F4721;
	Mon, 31 Aug 2026 13:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183665; cv=none; b=LoIoOXC510ZDZR32pSUcYZkBV+OOJ0I6GDiUKbTj4CdbDpB3lxotErr2jDdUEZ15BwHC7qjEBm0eAd6s/Rb7Sbyc/9ojgj2wAAQDiHF6xFyL4R4MhjqLc981bR062fhZmQyO43G2znkEjn/E7NDz0x1q9M3RISwg3dZrdiQfTx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183665; c=relaxed/simple;
	bh=BW4xLsWHKB5l0atcZ9qxOX/DFKtJ8J3aw15FQLe0Jqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PBiaqADioWn6rG8MXaxLb8QIdWLJ/bhCd4VUKoNvzkLBNKn3oNnQpM/glb9etEiZFr9gz+pyDItflmabe6KonTyMwQiv4M27extAlniP2g61EBwRKjoOXAHkUOTttOK8+wOBj8VT+NW4QeLnj9NEDrsFgAZC3wbrv5pc8pdQMbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kI1jpGyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kI1jpGyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF9F1F00A3F;
	Mon, 31 Aug 2026 13:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183662;
	bh=bJRaqYwtJATJVndD9WvdSR6tW7hyJbdXhIGYO3A3wTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kI1jpGyWo9pKc81QktOP2Q7t5X7w5IiA4XctTc5U46Uras6gmn6snyorxh08mrxGw
	 NybhHcyKdAzPvvcxja6h5zXQShTBZO/Mc5jLmn/skjv/umTau6G4Q8scM3Kmlb4LS1
	 NDKChOYKgcOIn4YxQcyDrz1bAwg79w4jmGt691uF2Nb33XZBUsOpDJJ5XgSKhGEaby
	 CIxQiC8NcMiVmixZb9zp/fOLul6G/onoxGYc2BApnP5T+uHE/qSTqm2VCrq9bu6A4w
	 mVLljT4pb5EWUhpyOW4ykNddIdQbBBBUZrfYQ0QIXjmEt7/UPH2o6eloz6veHWlhZM
	 1/beSLYvpNTdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>,
	tglx@kernel.org,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] x86/microcode/AMD: Move the no-revision fixup to get_patch_level()
Date: Mon, 31 Aug 2026 09:24:17 -0400
Message-ID: <20260831133314.4125787-229-sashal@kernel.org>
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

From: "Borislav Petkov (AMD)" <bp@alien8.de>

[ Upstream commit 098bcea71b8d257d80b0037b97b66070806600a5 ]

On machines which don't have microcode applied yet, the revision is 0.
However, this doesn't work with the Zen family/model/stepping patch
arithmetic. So move the fixup to the patch level getter function and
this way make sure the patch level is always proper and thus the
arithmetic always works.

And now that it can be called on any family, make this Zen-only.

Assisted-by: claude/claude-opus-4-6
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20260530024213.86137-1-bp@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `x86/microcode/AMD: Move the no-revision
fixup to get_patch_level()`

**Local tree:** `v6.18.44` on branch `stable/linux-6.18.y` (detached
HEAD)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[x86/microcode/AMD]` `[move]` — Relocate the zero-revision
workaround from `need_sha_check()` into `get_patch_level()` so Zen
patch-ID arithmetic always sees a valid revision.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent on this commit (original reporter is on
  prerequisite `fcf8239ad6a5d`: Vítek Vávra)
- **Tested-by:** — absent
- **Reviewed-by / Acked-by:** — absent
- **Link:**
  `https://lore.kernel.org/r/20260530024213.86137-1-bp@kernel.org`
- **Cc: stable:** — absent
- **Signed-off-by:** Borislav Petkov (AMD) `<bp@alien8.de>`
- **Assisted-by:** claude/claude-opus-4-6
- Notable: upstream commit `098bcea71b8d2`; no syzbot, no multi-reporter
  tags on this specific commit

### Step 1.3: Body analysis
**Record:**
- **Bug:** On machines with no BIOS microcode loaded,
  `MSR_AMD64_PATCH_LEVEL` reads as 0. Zen encodes family/model/stepping
  inside the patch revision word; revision 0 breaks that arithmetic.
- **Symptom:** Patch matching, cache lookup, and Entrysign cutoff
  selection fail or behave incorrectly when revision stays 0.
- **Root cause:** Prior fix (`fcf8239`) synthesized a lowest revision
  only inside `need_sha_check()`, but many callers use
  `get_patch_level()` directly and still see 0.
- **Fix approach:** Centralize the synthesis in `get_patch_level()`,
  limit it to Zen (family ≥ 0x17).

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “move” wording, this completes an incomplete
bug fix. The prior commit addressed only the SHA-check path; this fixes
all `get_patch_level()` consumers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `arch/x86/kernel/cpu/microcode/amd.c` only
- **Scope:** ~4 insertions, ~5 deletions (net −1 line); single-file
  surgical fix
- **Functions modified:** `need_sha_check()`, `get_patch_level()`

### Step 2.2: Code flow per hunk

**Hunk 1 — `need_sha_check()`:**
- **Before:** If `cur_rev == 0`, synthesize lowest Zen revision via
  `cpuid_to_ucode_rev()`.
- **After:** Passes `cur_rev` through unchanged to
  `get_cutoff_revision()`.
- **Path affected:** SHA256 digest verification during microcode
  application.

**Hunk 2 — `get_patch_level()`:**
- **Before:** Returns raw MSR value (0 when no BIOS microcode).
- **After:** If MSR is 0 and CPU is Zen+ (family ≥ 0x17), synthesize
  lowest revision from CPUID; pre-Zen still returns 0.
- **Path affected:** All microcode revision queries — early BSP load,
  patch verification, cache lookup, CPU info collection, reload.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** in Zen patch-ID arithmetic.

When `get_patch_level()` returns 0 on Zen:
1. **`verify_patch()`** (added by `d75aa97c90da2`, present in this
   tree): `get_cutoff_revision(0)` returns 0 → `if (!cutoff) goto ok`
   accepts every patch, breaking Entrysign pre/post-cutoff selection.
2. **`cache_find_patch()` / `patch_cpus_equivalent()`**:
   `ucode_rev_to_cpuid(0)` does not match the CPU-encoded patch ID →
   cache miss → `find_patch()` returns NULL → runtime microcode update
   fails (`UCODE_NFOUND`).
3. **`patch_newer()`**: revision comparisons against 0 produce wrong
   ordering.

The fix ensures all callers of `get_patch_level()` see a valid Zen-
encoded revision.

### Step 2.4: Fix quality
**Record:** Obviously correct — centralizes existing logic at the single
source of truth. Minimal diff. Low regression risk: pre-Zen explicitly
excluded (`family < 0x17` returns 0 unchanged). Removing the duplicate
fixup from `need_sha_check()` is safe because callers now get a
synthesized revision from `get_patch_level()` first.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Zero-revision fixup in `need_sha_check()` introduced by
  **`fcf8239ad6a5d`** (Aug 2025): “Handle the case of no BIOS microcode”
- `get_patch_level()` introduced by **`037e81fb9d2df`**; present since
  before Zen encoding changes
- Zen patch-ID encoding introduced by **`94838d230a6c`** (Jul 2024) — in
  this tree
- Patch selection using `get_patch_level()` + cutoff:
  **`d75aa97c90da2`** (Sep 2025, backported Jan 2026) — in this tree

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag on this commit. Related fix:
`fcf8239ad6a5d` with `Fixes: 94838d230a6c`, `Cc:
stable@vger.kernel.org`, `Reported-by: Vítek Vávra`.

### Step 3.3: File history
**Record:** Recent related commits in this tree:
- `fcf8239ad6a5d` — incomplete zero-rev fix (SHA path only)
- `d75aa97c90da2` — patch selection via `verify_patch()` +
  `get_cutoff_revision()`
- `54e9bd5025a07` — Entrysign Zen5 fixes
- This commit (`098bcea71b8d2`) is on `origin/master` but **not yet** in
  `stable/linux-6.18.y`

Standalone single-patch fix; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Borislav Petkov is the x86/AMD microcode maintainer.
Multiple recent commits in `amd.c` in this tree.

### Step 3.5: Dependencies
**Record:**
- Requires `cpuid_to_ucode_rev()`, `get_cutoff_revision()`, Zen patch-ID
  logic — all present in v6.18.44
- Requires `fcf8239ad6a5d` (already in tree) for `cpuid_to_ucode_rev()`
  and the original partial fix
- **`git apply --check` on `098bcea71b8d2` passes cleanly** on current
  tree
- No other commits required

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 dig -c 098bcea71b8d2:**
  `https://patch.msgid.link/20260530024213.86137-1-bp@kernel.org`
- **b4 dig -a:** v1 only (May 29, 2026); mbox also contains v2 (Jun 3,
  2026) with same diff
- **Reviewer feedback:** No replies, NAKs, stable nominations, or
  Tested-by in thread (single-patch post, no discussion)

### Step 4.2: Reviewers
**Record:** **b4 dig -w:** To/Cc: Borislav Petkov, X86 ML, LKML. No
external reviewers listed.

### Step 4.3: Bug report
**Record:** No direct bug report on this commit. Original user report on
`fcf8239ad6a5d` (Vítek Vávra) — machines shipped without BIOS microcode.
This commit completes that fix.

### Step 4.4: Related patches
**Record:** Follow-up to `fcf8239ad6a5d`. Interacts with `d75aa97c90da2`
patch-selection logic. No other series patches needed.

### Step 4.5: Stable list
**Record:** No stable-list discussion found for this specific commit.
Prior commit `fcf8239` had `Cc: stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `get_patch_level()`, `need_sha_check()`, and downstream:
`verify_patch()`, `cache_find_patch()`, `find_patch()`,
`load_ucode_amd_bsp()`, `collect_cpu_info_amd()`, `reload_ucode_amd()`,
`__apply_microcode_amd()`.

### Step 5.2: Callers of `get_patch_level()`
**Record:** (verified via grep in `amd.c`)
- `verify_patch()` — patch container scanning / Entrysign selection
- `load_ucode_amd_bsp()` — early BSP microcode load
- `__apply_microcode_amd()` — post-apply verification
- `find_patch()` → `cache_find_patch()` — runtime patch lookup
- `reload_ucode_amd()`, `collect_cpu_info_amd()` — reload and sysfs/CPU
  info

All are boot-time or microcode-update paths on AMD x86 systems.

### Step 5.3: Callees
**Record:** `native_rdmsr(MSR_AMD64_PATCH_LEVEL)`,
`cpuid_to_ucode_rev()`, `x86_family()`, `pr_info_once()`.

### Step 5.4: Reachability
**Record:** Triggered on every AMD Zen+ system boot where BIOS has not
applied microcode (MSR reads 0). Common during early boot microcode
loading and later reload paths. Not userspace-syscall reachable, but
affects all such hardware at boot.

### Step 5.5: Similar patterns
**Record:** `cpuid_to_ucode_rev()` fixup was duplicated in
`need_sha_check()` and `get_patch_level()`'s `CONFIG_MICROCODE_DBG`
path. This commit consolidates into one place.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.y)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree at
`arch/x86/kernel/cpu/microcode/amd.c:236-238` still has fixup only in
`need_sha_check()`. `get_patch_level()` at lines 340-342 returns raw MSR
without zero-rev handling. All prerequisite commits (`94838d`,
`fcf8239`, `d75aa97`) are ancestors of HEAD.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` on upstream commit
succeeds with no conflicts. No rework needed for 6.18.y (the
`hypervisor_present` change in master is a separate commit, not part of
this patch).

### Step 6.3: Related fixes already present?
**Record:** `fcf8239ad6a5d` (partial fix) is in tree. This commit is
**not** yet applied. No alternate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `arch/x86` — AMD microcode loader. **Criticality:
IMPORTANT** (CPU security mitigations, boot-time correctness; not
universal like mm/VFS, but affects all AMD Zen+ users without BIOS
ucode).

### Step 7.2: Activity
**Record:** Actively maintained — multiple microcode commits in
2025–2026 in this tree (Entrysign, Zen5, patch selection).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** AMD Zen and newer (family ≥ 0x17) systems where BIOS has not
applied microcode (MSR revision = 0). Config: `CONFIG_MICROCODE` + AMD
CPU.

### Step 8.2: Trigger conditions
**Record:** Boot or microcode reload on hardware with no prior microcode
applied. Documented real-world scenario (machines shipped without BIOS
microcode). Not timing-dependent.

### Step 8.3: Failure mode severity
**Record:**
- Microcode fails to load/update (`find_patch()` → NULL)
- Wrong patch may be selected when dual-patch containers are used
  (`verify_patch()` bypasses cutoff logic)
- Missing CPU security/errata mitigations
- **Severity: HIGH** (functional failure + potential security impact
  from wrong/missing microcode; not a kernel oops, but materially
  affects CPU security state)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit: HIGH** — fixes broken microcode loading on real hardware;
  completes a stable-nominated partial fix
- **Risk: VERY LOW** — 9-line move, maintainer-authored, applies
  cleanly, Zen-only guard
- **Ratio:** Strong benefit, minimal risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Fixes real bug on Zen+ systems without BIOS microcode (user-reported
  scenario)
- Completes incomplete fix from `fcf8239` (which had `Cc: stable`)
- Breaks `verify_patch()` cutoff selection and `cache_find_patch()` when
  rev=0
- Small, surgical, maintainer fix; applies cleanly to 6.18.44
- All prerequisites present in this tree
- Upstream in mainline (`098bcea71b8d2`)

**AGAINST backport:**
- No independent Tested-by or review discussion
- No crash/oops — functional/security impact rather than kernel panic
- Narrow hardware/config scope (AMD Zen+ without BIOS ucode)

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; `git apply
   --check` passes; author is maintainer (no formal Tested-by)
2. Fixes real bug affecting users? **PASS** — microcode load/selection
   broken when MSR=0 on Zen
3. Important issue? **PASS** — HIGH: missing/wrong microcode, security
   mitigations at stake
4. Small and contained? **PASS** — single file, ~9 lines changed
5. No new features/APIs? **PASS** — relocates existing fixup logic
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
on merit as a bug fix.

### Step 9.4: Problem summary for stable users

Commit `fcf8239` added a workaround for machines with no BIOS microcode,
but only inside `need_sha_check()`. Meanwhile `get_patch_level()` — used
by patch verification (`d75aa97`), cache lookup, early load, and CPU
info — still returned 0. On Zen CPUs, revision 0 is not a valid encoded
patch level, so patch matching arithmetic fails and Entrysign cutoff
selection is bypassed. This commit moves the synthesis to
`get_patch_level()` with a Zen-only guard, fixing all consumers at once.

---

## Verification

- [Phase 1] Parsed subject, body, tags; Link to lore confirmed
- [Phase 2] Read diff and current `amd.c` at lines 232-248, 321-343,
  504-575, 822-876, 916-930
- [Phase 3] `git blame` on changed lines; `fcf8239ad6a5d`,
  `d75aa97c90da2`, `94838d230a6c` identified; ancestry confirmed in tree
- [Phase 3] `git apply --check` on `098bcea71b8d2` — passes
- [Phase 4] `b4 dig -c 098bcea71b8d2` — lore URL found; `-a` shows v1;
  `-w` shows recipients; mbox saved, no review replies
- [Phase 5] `grep get_patch_level` — 6 call sites in `amd.c`; traced
  `verify_patch`, `cache_find_patch`, `find_patch` logic
- [Phase 6] `git describe HEAD` → v6.18.44; buggy code confirmed
  present; fix not yet in tree
- [Phase 6] `git merge-base --is-ancestor` — `fcf8239`, `d75aa97`,
  `94838d` all in tree
- [Phase 8] Failure modes derived from code paths at
  `verify_patch():554-556` and `cache_find_patch():851-855`

**YES**

 arch/x86/kernel/cpu/microcode/amd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 46673530bc6f0..4a33d10685587 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -233,11 +233,6 @@ static bool need_sha_check(u32 cur_rev)
 {
 	u32 cutoff;
 
-	if (!cur_rev) {
-		cur_rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
-		pr_info_once("No current revision, generating the lowest one: 0x%x\n", cur_rev);
-	}
-
 	cutoff = get_cutoff_revision(cur_rev);
 	if (cutoff)
 		return cur_rev <= cutoff;
@@ -338,6 +333,13 @@ static u32 get_patch_level(void)
 	}
 
 	native_rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
+	if (!rev) {
+		if (x86_family(bsp_cpuid_1_eax) < 0x17)
+			return rev;
+
+		rev = cpuid_to_ucode_rev(bsp_cpuid_1_eax);
+		pr_info_once("No current revision, generating the lowest one: 0x%x\n", rev);
+	}
 
 	return rev;
 }
-- 
2.53.0

