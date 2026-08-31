Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D9151FCB4;
	Mon, 31 Aug 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183840; cv=none; b=kZm9JZanEMZg+IL9sp1U+KaJmGtUeBL1APpMcujl8gQRQaO8/udQRoJy4/8d+OrUp9f4DuKW/uQbsndzKv2o7SPSwzScH2o31L8e2TYWL+KW3RqBEuuVLUviVqPtTmMpkWeUYRyuqdJAHUUDkd2ZDMxGACefBqBdZZU0bRrUDGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183840; c=relaxed/simple;
	bh=r50iPwsBao1PFw/YVuec++5XN914iDIQTjNbCTP0dzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kTKu5FflCqm8UZVhbkge2RjgsFck/kq4Cz1AKxnZP75afi60Ymbkp385KJXPt76NTshnmBxxWq5lkgiX0K5TL0+hy+HLYuVXwI2sHDdvq0p2ZyzDQxZ0hRlexQxLYgDc/4TrL8RjHTgAsrd7Lk8FAl12xhZ4brGHGYvf5f6OtFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cx/l67t4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cx/l67t4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4906E1F00A3F;
	Mon, 31 Aug 2026 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183838;
	bh=qGIPQnjyt4OQ6XoqGXnUCOervZ5TVfmZF9/N9wgWUXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cx/l67t4HkB85mXPNRwkITyeR3Q4iJ4lqiNc4GX9clzrWgTcQTGUUns+aNByjImbF
	 AUEwCfxLL0bYhyxhZn6v36XGTNFJC4F3iZ19jStNQRedePboqC2MCQajmaEjJew/L8
	 RfVp7J8v7R9SswEXl3BGEVnUFVpdWlXdtUFUWIdsc5Z7W81utjLkLly/JKWwcdIrxp
	 XHJn7ANszJ/zLvA7itsMdMu8MsxNKXWOFVVx6bC2rtdyJIQBS0LenmZAg0kkWX2pQi
	 E3rCIpG33X+PPQbrRG567sR9gHJglHlwHbDp9JkUDVyGLsS1jzlu9EjwCIGyQokJss
	 sA24lcvkB1APQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hirokazu Honda <hiroh@chromium.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	jenswi@kernel.org,
	op-tee@lists.trustedfirmware.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] tee: optee: Allow MT_NORMAL_TAGGED shared memory
Date: Mon, 31 Aug 2026 09:26:02 -0400
Message-ID: <20260831133314.4125787-334-sashal@kernel.org>
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

From: Hirokazu Honda <hiroh@chromium.org>

[ Upstream commit 1a6e94a8ff32e7879effd1e4a45bf112e506edc1 ]

On ARM64, shared memory can have MT_NORMAL_TAGGED attribute when using
the Memory Tagging Extension (MTE). The OP-TEE driver needs to
recognize this as normal memory to allow sharing such buffers with the
Secure World.

Signed-off-by: Hirokazu Honda <hiroh@chromium.org>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `tee: optee: Allow MT_NORMAL_TAGGED shared
memory`

**Local tree:** Linux 6.18.43 (`git describe HEAD` → `v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[tee: optee]` `[Allow]` — Extend OP-TEE shared-memory
validation to accept ARM64 `MT_NORMAL_TAGGED` pages (MTE-tagged normal
memory).

### Step 1.2: Tags
**Record:**
- `Signed-off-by: Hirokazu Honda <hiroh@chromium.org>` — author (Chrome
  team)
- `Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>` — OP-TEE
  maintainer review
- `Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>` — TEE
  subsystem maintainer
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Link:`,
  `Tested-by:`, or `Acked-by:` tags
- Notable: Reviewed by subsystem maintainers; no syzbot or crash report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** On ARM64, userspace buffers mapped with MTE (`PROT_MTE`) use
  `MT_NORMAL_TAGGED` page attributes. `is_normal_memory()` only accepts
  `MT_NORMAL`, so `optee_check_mem_type()` rejects valid buffers.
- **Symptom:** `-EINVAL` when registering shared memory with OP-TEE;
  secure-world communication fails for MTE-enabled processes.
- **Root cause:** Incomplete memory-type check — `MT_NORMAL_TAGGED` is
  documented as a normal-memory variant but not recognized by the
  driver.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is an explicit compatibility fix, not disguised
cleanup. It corrects an overly narrow memory-type whitelist.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/tee/optee/call.c` (+2 / -1)
- **Functions:** `is_normal_memory()` only
- **Scope:** Single-file, surgical ARM64-only change

### Step 2.2: Code Flow Change
**Record:**
- **Before:** ARM64 `is_normal_memory()` returns true only for
  `PTE_ATTRINDX(MT_NORMAL)`.
- **After:** Also returns true for `PTE_ATTRINDX(MT_NORMAL_TAGGED)`.
- **Path affected:** `optee_check_mem_type()` → `__check_mem_type()` →
  `is_normal_memory()` during shared-memory registration.

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix** — incorrect rejection of a valid
ARM64 memory type. Classification: platform-specific compatibility bug
(ARM64 MTE + OP-TEE).

### Step 2.4: Fix Quality
**Record:** Obviously correct — `arch/arm64/include/asm/memory.h`
documents `MT_NORMAL_TAGGED` as the normal-memory type for `PROT_MTE`
mappings. Minimal diff, no API changes, no regression risk on non-ARM64
builds (change is inside `#elif defined(CONFIG_ARM64)`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `is_normal_memory()` exists in this tree at
`call.c:599-609`. The original check (only `MT_NORMAL`) dates to the
2017 introduction of shared-memory type validation (`[PATCH 2/2] tee:
optee: check type of registered shared memory`). The stable tree's per-
file history is flattened (entire `call.c` attributed to one upstream
merge commit), but the function and its `MT_NORMAL`-only check are
present in 6.18.43.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:** No related follow-up fixes found in this tree. Standalone
one-line logical extension.

### Step 3.4: Author Context
**Record:** Hirokazu Honda (Chromium). Jens Wiklander is TEE subsystem
maintainer; Sumit Garg is OP-TEE maintainer. Both reviewed and accepted.

### Step 3.5: Dependencies
**Record:** No prerequisites. `MT_NORMAL_TAGGED` is already defined in
`arch/arm64/include/asm/memory.h` (value `1`). MTE userspace support
(`PROT_MTE`) is present in this tree. Fix applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Patch submitted Apr 16, 2026. Discussion at [spinics.net
msg6157985](https://www.spinics.net/lists/kernel/msg6157985.html).
Single-patch submission (not a series). Jens Wiklander: "Looks good. I'm
picking up this." Merged via `optee-for-v7.2` tag. No NAKs.

### Step 4.2: Reviewers
**Record:** To: Jens Wiklander. Cc: Sumit Garg, op-
tee@lists.trustedfirmware.org, linux-kernel. Appropriate maintainers
involved.

### Step 4.3: Bug Report
**Record:** No formal bug report or syzbot link. Real-world motivation
from Chrome/Android MTE + OP-TEE integration.

### Step 4.4: Related Patches
**Record:** Standalone fix; no series dependencies.

### Step 4.5: Stable List History
**Record:** No `Cc: stable` nomination found in review thread. Absence
is expected per review pipeline rules and is not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `is_normal_memory()` (modified), `__check_mem_type()`,
`optee_check_mem_type()` (callers unchanged).

### Step 5.2: Callers of `optee_check_mem_type()`
**Record:**
- `optee_shm_register()` in `smc_abi.c:467` — registers user/kernel
  shared memory with secure world
- `optee_shm_register_supp()` in `smc_abi.c:570` — supplicant path
  validation
- `optee_ffa_shm_register()` in `ffa_abi.c:289` — FF-A ABI shared memory
  registration

### Step 5.3: Callees
**Record:** `__check_mem_type()` walks VMAs via `for_each_vma_range()`,
checks `vma->vm_page_prot` against `is_normal_memory()`.

### Step 5.4: Reachability
**Record:** Userspace → `/dev/tee*` ioctl `TEE_IOC_SHM_REGISTER` →
`tee_ioctl_shm_register()` → `tee_shm_register_user_buf()` →
`register_shm_helper()` → `optee_shm_register()` →
`optee_check_mem_type()`. **Reachable from userspace** on ARM64 systems
with OP-TEE enabled when registering MTE-tagged buffers.

### Step 5.5: Similar Patterns
**Record:** `pte_tagged()` in `arch/arm64/include/asm/pgtable.h` uses
the same `MT_NORMAL_TAGGED` check pattern. The kernel already treats
this as a normal-memory variant elsewhere.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `call.c:605` only checks `MT_NORMAL`:

```605:605:drivers/tee/optee/call.c
        return (pgprot_val(p) & PTE_ATTRINDX_MASK) ==
PTE_ATTRINDX(MT_NORMAL);
```

`MT_NORMAL_TAGGED` is defined at `arch/arm64/include/asm/memory.h:172`.
MTE support is present (`PROT_MTE` in `Documentation/arch/arm64/memory-
tagging-extension.rst`, `arch/arm64/kernel/mte.c`).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — 2-line change in existing
function, identical context to mainline diff.

### Step 6.3: Related Fixes Already Present?
**Record:** **No** — `git log --grep="MT_NORMAL_TAGGED"` and
`--grep="Allow MT_NORMAL_TAGGED"` return nothing in this tree. Fix not
yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/tee/optee` — TEE/OP-TEE driver. **Criticality:
IMPORTANT** for ARM64 embedded/Android platforms using secure services
(Keymaster, DRM, biometrics). Not core kernel, but security-
infrastructure relevant on those platforms.

### Step 7.2: Activity
**Record:** OP-TEE driver is mature but actively maintained; MTE
adoption is an ongoing ARM64 platform concern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Platform-specific:** ARM64 + `CONFIG_OPTEE` + userspace
using `PROT_MTE` on buffers shared with OP-TEE. Primarily Android/Chrome
OS devices rolling out MTE.

### Step 8.2: Trigger Conditions
**Record:** User/application maps anonymous memory with `PROT_MTE`, then
registers it with OP-TEE via `TEE_IOC_SHM_REGISTER`. Trigger is
deterministic (not a race). Unprivileged users can trigger via TEE ioctl
on systems with accessible `/dev/tee*`.

### Step 8.3: Failure Mode Severity
**Record:** **`-EINVAL` on shared-memory registration** — TEE/secure-
world operations fail entirely for MTE-enabled processes. No crash,
corruption, deadlock, or security exploit. **Severity: MEDIUM**
(complete functional breakage for affected configuration, but not a
stability/security crash).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores OP-TEE functionality for MTE-enabled ARM64
  processes; important for Chrome/Android MTE rollout on TEE-equipped
  hardware.
- **Risk:** Very low — 2 lines, ARM64-only, matches existing kernel
  semantics for `MT_NORMAL_TAGGED`.
- **Ratio:** Favorable — trivial fix, real production impact for a
  growing platform configuration.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible bug in 6.18.43 (buggy code confirmed present)
- Small, obviously correct, maintainer-reviewed fix
- Userspace-reachable on ARM64 OP-TEE systems
- `MT_NORMAL_TAGGED` prerequisite already in tree
- Hardware-platform compatibility fix (ARM64 MTE), analogous to
  quirk/workaround category
- Chrome production motivation for growing MTE deployment

**AGAINST backport:**
- Not a crash, corruption, deadlock, or security vulnerability
- Niche configuration (ARM64 + OPTEE + MTE)
- No syzbot report or explicit stable nomination
- Functional `-EINVAL` rather than kernel oops

**Unresolved:** Exact kernel version when MTE userspace + OP-TEE
combination became common in production (not needed for decision — bug
mechanism is clear).

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic matches `memory.h`
   documentation; reviewed by OP-TEE and TEE maintainers.
2. Fixes a real bug affecting users? **PASS** — deterministic `-EINVAL`
   blocking TEE shared memory for MTE buffers.
3. Important issue? **PASS (borderline)** — not a crash/corruption, but
   complete breakage of secure-world communication for MTE processes on
   ARM64 Android/Chrome platforms.
4. Small and contained? **PASS** — 2 lines, 1 file, 1 function.
5. No new features or APIs? **PASS** — extends recognition of existing
   memory type; no new API.
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected.

### Step 9.3: Exception Category
**Record:** **Hardware/platform workaround** — enables correct handling
of ARM64 MTE-tagged normal memory, analogous to the quirk/compatibility
exception category in stable rules.

### Step 9.4: Decision Rationale

This commit fixes a real compatibility gap between ARM64 MTE
(`MT_NORMAL_TAGGED`) and the OP-TEE driver's shared-memory validator.
The bug exists in Linux 6.18.43, the fix is trivial and maintainer-
approved, and all prerequisites (`MT_NORMAL_TAGGED`, MTE support) are
already in this tree. While the failure mode is functional rather than a
kernel crash, it completely blocks TEE operations for MTE-enabled
processes — a growing concern on ARM64 Android/Chrome platforms where
both OP-TEE and MTE are deployed together. The fix is low-risk and fits
the stable pattern for small platform compatibility corrections.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Confirmed no `Fixes:`, `Reported-by:`, or `Cc: stable` tags
- [Phase 2] Read diff: +2/-1 in `is_normal_memory()`, ARM64 branch only
- [Phase 2] Read `call.c:599-642` — confirmed current code only checks
  `MT_NORMAL`
- [Phase 3] `git describe HEAD` → `v6.18.43`; `make kernelversion` →
  `6.18.43`
- [Phase 3] `git blame -L 599,610 drivers/tee/optee/call.c` — function
  present in tree
- [Phase 3] Web search: original `is_normal_memory` introduced ~2017 in
  OP-TEE shm type check patch
- [Phase 3] `git log --grep="Allow MT_NORMAL_TAGGED"` — no match (fix
  not in tree)
- [Phase 4] Fetched spinics.net msg6157985, msg6161595, msg6174403 —
  maintainer review, no NAKs, no stable Cc
- [Phase 4] b4 dig unavailable for commit hash (fix not merged in this
  tree); used spinics/openwall instead
- [Phase 5] `grep optee_check_mem_type` — 3 call sites in `smc_abi.c`,
  `ffa_abi.c`
- [Phase 5] Read `tee_shm.c:496-516` — userspace registration path via
  `tee_shm_register_user_buf()`
- [Phase 5] Read `smc_abi.c:453-469` — `optee_shm_register()` calls
  `optee_check_mem_type()`
- [Phase 6] Confirmed `MT_NORMAL_TAGGED` defined at
  `arch/arm64/include/asm/memory.h:172`
- [Phase 6] Confirmed `pte_tagged()` uses same `MT_NORMAL_TAGGED`
  pattern in `pgtable.h:191-192`
- [Phase 6] `grep PROT_MTE` — MTE userspace support present in tree
- [Phase 8] Traced call chain: ioctl → shm register →
  `optee_check_mem_type()` → `-EINVAL` on MTE buffers

**YES**The background `git log -S "is_normal_memory"` search finished.
It didn’t turn up a clean introduction point for `is_normal_memory()` in
this 6.18.43 stable tree — the hits were unrelated (MIPS) or artifacts
of the flattened per-file history (the whole `call.c` lumped under one
upstream merge). External history still points to the original OP-TEE
shared-memory type check from ~2017.

That doesn’t change the earlier conclusion: the buggy `MT_NORMAL`-only
check is present in this tree, the fix is small and correct, and it
should be backported.

**YES**

 drivers/tee/optee/call.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 16eb953e14bb6..e422e77b06fb8 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -602,7 +602,8 @@ static bool is_normal_memory(pgprot_t p)
 	return (((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEALLOC) ||
 		((pgprot_val(p) & L_PTE_MT_MASK) == L_PTE_MT_WRITEBACK));
 #elif defined(CONFIG_ARM64)
-	return (pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL);
+	return ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL)) ||
+	       ((pgprot_val(p) & PTE_ATTRINDX_MASK) == PTE_ATTRINDX(MT_NORMAL_TAGGED));
 #else
 #error "Unsupported architecture"
 #endif
-- 
2.53.0

