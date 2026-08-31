Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC64AD7D0;
	Mon, 31 Aug 2026 13:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184101; cv=none; b=esXz4/i7u072EkIdsFPH5Bvx/1WBA+Ia4qAFh83SSYN+ia3gfav81j408dm+7cKG5CWXAeKtvmuKJYB6JCmrFmulSoXemUmxzb0iPPQ9R7Xa//dGErSXL8ATnpQP6rEEMHYZX4ETjAn3yB751xtLjW1cNd/VCsEc/xeSavVKu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184101; c=relaxed/simple;
	bh=NC3USh1yWDAno1VZRkMDZENxazEkRsJm2JtGIAQdiAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QigvAG/KJewrDfEHcdU2UoK/HGQxl1v7c75+IUyT9gH25psH17eq8Kc8/iNvAEnzdZdnerVwX/SmB3AGPINfIiyqNAz4BvcMF9knBuWG3TonDm20Bi6o4JwFTeRg5aAcm+xoRuYB8/m/WJ61D9vCsOXSkSqITIJbe0P/+PVKcSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGMJhghs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGMJhghs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BF51F00ACF;
	Mon, 31 Aug 2026 13:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184097;
	bh=nxW0z1+3lAtGBNK9zzpc7iWkVAh9cpA3oZ+ROWhMJrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGMJhghsWfASSBWig9eU8tHZdTvB2kyaWwHYyJhxcVQ3TNRRwJUuNqLg0pjtLBGS3
	 pgBKZh68Q+xY/APjHLEhrxXDPYdUz0VfgNrLYQDoBHX+/7c5jLyZ7H2j6XLaLt5rwT
	 gFuuR3NNXRPeSj2FXNWJe6Sje77hFeL5Tn5g42BlKSYxF6JKjjB0v29Tzhbj+Q1asn
	 u+vLOXWPb2Xa6STwnTx36ScLVcvOukZXriGcn0SU/AeZKosjg++Sh7H/nDvsUHxYmE
	 HrSwi9qOS7xx7QJR7/56Ez10Kkq7hZSNA1vYDSsYgMkg53Tk9wElpMACaIUl7pOuq/
	 MrALPtJKTiqnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ce Sun <cesun102@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amdgpu: avoid integer overflow in VA range check
Date: Mon, 31 Aug 2026 09:28:37 -0400
Message-ID: <20260831133314.4125787-489-sashal@kernel.org>
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

From: Ce Sun <cesun102@amd.com>

[ Upstream commit cc768f4dd0bb9083c813683eeec44fc23921f771 ]

The original addition operation in 64-bit unsigned type may encounter
overflow situations. To prevent such issues and safely reject invalid
inputs, the check_add_overflow() function is used.

Signed-off-by: Ce Sun <cesun102@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drm/amdgpu]` `[avoid]` — prevent integer overflow in the
`AMDGPU_GEM_VA` ioctl VA range validation (`amdgpu_gem_va_ioctl`).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Ce Sun `<cesun102@amd.com>` (author)
- **Reviewed-by:** Tao Zhou `<tao.zhou1@amd.com>`
- **Signed-off-by:** Alex Deucher `<alexander.deucher@amd.com>`
  (maintainer)
- No `Fixes:`, `Reported-by:`, `Link:`, `Cc: stable@vger.kernel.org`,
  `Tested-by:`, or `Acked-by:` tags
- Notable: reviewed by AMD developer and merged by amdgpu maintainer; no
  fuzzer or user bug report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `args->va_address + args->map_size` uses unchecked 64-bit
  unsigned addition in the top-reserved VA range check.
- **Symptom/failure mode:** On overflow, the wrapped sum can be `<=
  vm_size`, so invalid oversized VA ranges are not rejected at the ioctl
  boundary.
- **Root cause:** Missing overflow-safe addition before comparing
  against `vm_size`.
- **Version info:** None in the commit message.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Although the subject says “avoid” rather than “fix,”
this is an input-validation bug in a userspace-reachable DRM ioctl. It
is not cosmetic cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c` only (+2/-2, 4
  lines touched)
- **Functions:** `amdgpu_gem_va_ioctl()`
- **Scope:** Single-file, surgical ioctl validation fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `if (args->va_address + args->map_size > vm_size)` —
  overflow wraps, check may pass incorrectly.
- **After:** `if (check_add_overflow(args->va_address, args->map_size,
  &tmp) || tmp > vm_size)` — overflow is detected and rejected with
  `-EINVAL`.
- **Path affected:** Early validation in `amdgpu_gem_va_ioctl()`, before
  GEM lookup, fence handling, and VM locking.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Integer overflow / input validation bug
- **Mechanism:** A malicious or buggy userspace caller can supply
  `va_address` and `map_size` whose true sum exceeds `UINT64_MAX`.
  Unchecked addition wraps to a small value, potentially bypassing the
  reserved-top VA check. The fix uses `check_add_overflow()` to reject
  such inputs.

### Step 2.4: Fix Quality
**Record:**
- Fix is minimal, idiomatic, and matches existing kernel/amdgpu style
  (`check_add_overflow` is already used elsewhere in this file and in
  `amdgpu_vm.c`).
- Regression risk is very low.
- Minor note: the `dev_dbg()` on the error path still prints
  `args->va_address + args->map_size` without overflow protection; that
  only affects debug logging on the failure path.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Buggy check introduced in `c4aa8dff6091cc` (“drm/amdgpu: don't map BO
  in reserved region”, Oct 2020).
- `vm_size -= AMDGPU_VA_RESERVED_TOP` added in `00a11f977beb75` (Jan
  2024).
- This commit is an ancestor of the current tree; the buggy code is
  present in v6.18.44.

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: Related File History
**Record:**
- Related upstream commits on master: `cc768f4dd0bb9`, cherry-picked as
  `cd7cfcdb4dd45`.
- `98856136c485e` (“drm/amdgpu: validate the parameters of bo mapping
  operations more clearly”, Apr 2024) added
  `amdgpu_vm_verify_parameters()` with `check_add_overflow(saddr, size)`
  for `amdgpu_vm_bo_map()`, `amdgpu_vm_bo_replace_map()`, and
  `amdgpu_vm_bo_clear_mappings()`.
- `daf5d03ddb8cc` already backported a similar integer-overflow fix in
  the same file (`amdgpu_gem_align_pitch()`).
- Standalone one-commit fix; not part of a series.

### Step 3.4: Author Context
**Record:** Ce Sun is an AMD contributor with multiple amdgpu stable-
relevant fixes (reset, leak, PM). Tao Zhou reviewed; Alex Deucher
merged.

### Step 3.5: Dependencies
**Record:** No prerequisites. `linux/overflow.h` is already included in
`amdgpu_gem.c` in this tree. `check_add_overflow()` exists in
`include/linux/overflow.h`. Patch should apply cleanly.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c cc768f4dd0bb9` and `b4 dig -c cd7cfcdb4dd45` both
failed — no lore match found. Manual lore search blocked by bot
protection.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` unavailable due to failed match. From commit
metadata: Reviewed-by Tao Zhou; Signed-off-by Alex Deucher.

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot report, or crash trace
referenced.

### Step 4.4: Related Patches
**Record:** Not part of a multi-patch series. Related prior work:
`98856136c485e` (downstream VA parameter validation).

### Step 4.5: Stable List Discussion
**Record:** Could not verify stable-list discussion; lore fetch blocked.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `amdgpu_gem_va_ioctl()` modified.

### Step 5.2: Callers
**Record:** Registered in `amdgpu_drv.c` as:
`DRM_IOCTL_DEF_DRV(AMDGPU_GEM_VA, amdgpu_gem_va_ioctl,
DRM_AUTH|DRM_RENDER_ALLOW)`
Callable from authenticated DRM render clients — common userspace GPU VA
management path.

### Step 5.3: Callees
**Record:** After validation, ioctl may call `drm_gem_object_lookup()`,
`amdgpu_gem_add_input_fence()`, `drm_exec_*`, `amdgpu_vm_lock_pd()`, and
depending on operation:
- `amdgpu_vm_bo_map()`
- `amdgpu_vm_bo_unmap()`
- `amdgpu_vm_bo_clear_mappings()`
- `amdgpu_vm_bo_replace_map()`

### Step 5.4: Reachability / Downstream Mitigation
**Record:**
- **MAP / REPLACE / CLEAR:** All call `amdgpu_vm_verify_parameters()`,
  which already rejects `saddr + size` overflow via
  `check_add_overflow()`.
- **UNMAP:** Uses only `va_address`; `map_size` is not used in
  `amdgpu_vm_bo_unmap()`.
- **Important nuance for this tree:** The downstream overflow check
  means that for MAP/CLEAR/REPLACE, overflowed inputs would eventually
  fail at `amdgpu_vm_verify_parameters()` rather than creating a
  mapping. However, without this ioctl fix they still proceed through
  GEM lookup, fence setup, and VM locking first.
- The ioctl-level check also enforces the reserved-top region (`vm_size`
  subtracts `AMDGPU_VA_RESERVED_TOP`), which is stricter than
  `verify_parameters()`’s `lpfn >= max_pfn` check. Overflow cannot
  bypass into the reserved-top region for MAP operations because
  overflow is rejected downstream.

### Step 5.5: Similar Patterns
**Record:** `check_add_overflow()` already used in:
- `amdgpu_gem.c` (`amdgpu_gem_align_pitch()`)
- `amdgpu_vm.c` (`amdgpu_vm_verify_parameters()`)
- Other amdgpu files (vcn, etc.)

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** Yes. Current tree at
`drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c:845` still has:
`if (args->va_address + args->map_size > vm_size)`
Bug present since 2020; not introduced after the 6.18 branch.

### Step 6.2: Backport Complications
**Record:** Expected clean apply — 4-line change, `overflow.h` already
included, no structural conflicts observed.

### Step 6.3: Related Fixes Already Present?
**Record:** Downstream mitigation `amdgpu_vm_verify_parameters()` from
`98856136c485e` is already in this tree. The ioctl-level overflow fix
itself is **not** yet present. Similar overflow fix `daf5d03ddb8cc` in
the same file is already backported.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / Criticality
**Record:** `drivers/gpu/drm/amd/amdgpu` — GPU/DRM driver. **IMPORTANT**
for AMDGPU users; not universal core-kernel code, but ioctl validation
is security-sensitive.

### Step 7.2: Activity
**Record:** Actively maintained; recent stable-relevant amdgpu fixes in
this tree include overflow, lock leak, and NULL-check patches.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of AMDGPU with `CONFIG_DRM_AMDGPU` and render-node
access (games, compute, desktop compositors, ML workloads).

### Step 8.2: Trigger Conditions
**Record:** Userspace issues `DRM_IOCTL_AMDGPU_GEM_VA` with `va_address`
and `map_size` whose sum overflows `uint64_t`. Unprivileged users can
trigger ioctl validation if they have DRM render access (normal for GPU
users).

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix in this tree:** Overflow can bypass the ioctl reserved-
  top check; for MAP/CLEAR/REPLACE, operation later fails at
  `amdgpu_vm_verify_parameters()`. Primary consequence is incorrect
  early validation and unnecessary work (GEM lookup, fence handling, VM
  locking) on malformed input.
- **Severity:** **MEDIUM** for correctness and fail-fast behavior; **not
  CRITICAL** for crash/corruption in this tree because downstream
  validation already blocks dangerous MAP/CLEAR/REPLACE outcomes.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct ioctl input validation; fail-fast before
  expensive locking; consistent with other amdgpu overflow backports
  already in 6.18.y.
- **Risk:** Very low — 4 lines, standard helper, no API changes.
- **Ratio:** Moderate benefit, very low risk. Less urgent than fixes
  with demonstrated crash/corruption, but appropriate for stable.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real integer-overflow bug in userspace-reachable ioctl validation
- Small, obviously correct, self-contained
- Buggy code present since 2020 in this tree
- `linux/overflow.h` already included; patch applies cleanly
- Precedent: similar amdgpu integer-overflow fixes already backported to
  this tree (`daf5d03ddb8cc` in same file)
- Reviewed and merged by amdgpu maintainers

**AGAINST backport:**
- No user report, syzbot, or CVE cited
- Downstream `amdgpu_vm_verify_parameters()` already catches overflow
  for MAP/CLEAR/REPLACE
- Practical security/corruption impact in v6.18.44 appears limited to
  fail-late rather than fail-open mapping
- No lore/stable discussion found to confirm maintainer intent

**Unresolved:**
- No mailing-list thread retrieved (`b4 dig` failed; lore blocked)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard overflow helper;
   reviewed by AMD engineer; no Tested-by.
2. Fixes a real bug affecting users? **PASS** — real validation bug on
   reachable ioctl path.
3. Important issue? **PASS (moderate)** — input-validation overflow on
   DRM ioctl; not demonstrated crash/corruption in this tree, but
   incorrect validation on a security-sensitive path.
4. Small and contained? **PASS** — 4 lines, one function.
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS**

### Step 9.3: Exception Category
**Record:** None of the automatic exception categories (device ID,
quirk, DT, build fix, docs). This is a runtime input-validation bug fix.

### Step 9.4: Decision Rationale

For **v6.18.44**, the buggy unchecked addition exists and should be
fixed. Although `amdgpu_vm_verify_parameters()` already prevents
overflowed MAP/CLEAR/REPLACE operations from succeeding, the ioctl
boundary should validate inputs correctly and reject malformed VA ranges
before acquiring VM locks and doing GEM work. The patch is tiny, low-
risk, and consistent with other amdgpu overflow fixes already present in
this stable tree. It does not depend on newer code and does not add
features.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
  and `git show cd7cfcdb4dd45`
- [Phase 2] Read diff and current `amdgpu_gem.c` ioctl validation code
- [Phase 3] `git describe HEAD` → `v6.18.44`
- [Phase 3] `git blame -L 843,850` → buggy check from `c4aa8dff6091cc`
  (2020)
- [Phase 3] `git merge-base --is-ancestor c4aa8dff6091cc HEAD` → buggy
  code is in tree
- [Phase 3] `git show 98856136c485e` → downstream
  `amdgpu_vm_verify_parameters()` with `check_add_overflow`
- [Phase 3] `git merge-base --is-ancestor 98856136c485e HEAD` →
  downstream mitigation present
- [Phase 3] `git log --oneline -20 -- amdgpu_gem.c` → related amdgpu
  fixes in tree
- [Phase 3] `git show daf5d03ddb8cc` → similar overflow fix already
  backported to this tree
- [Phase 4] `b4 dig -c cc768f4dd0bb9` → no lore match
- [Phase 4] `b4 dig -c cd7cfcdb4dd45` → no lore match
- [Phase 4] WebFetch lore search → blocked by bot protection
- [Phase 5] `grep amdgpu_gem_va_ioctl` → ioctl registered with
  `DRM_AUTH|DRM_RENDER_ALLOW`
- [Phase 5] Read `amdgpu_vm_bo_map()`, `amdgpu_vm_bo_replace_map()`,
  `amdgpu_vm_bo_clear_mappings()`, `amdgpu_vm_bo_unmap()` → verified
  downstream validation behavior
- [Phase 5] Read `struct drm_amdgpu_gem_va` → `va_address` and
  `map_size` are `__u64`
- [Phase 6] Confirmed current tree still has unchecked addition at line
  845
- [Phase 6] Confirmed `#include <linux/overflow.h>` already present at
  line 30
- [Phase 6] Confirmed `check_add_overflow` exists in
  `include/linux/overflow.h`
- [Phase 8] Assessed failure mode: downstream catches overflow for
  MAP/CLEAR/REPLACE; primary remaining issue is incorrect early
  validation / unnecessary work

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
index 5fc9a6b1ec722..71038f4de7f9c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -818,7 +818,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 	struct dma_fence_chain *timeline_chain = NULL;
 	struct dma_fence *fence;
 	struct drm_exec exec;
-	uint64_t vm_size;
+	uint64_t vm_size, tmp;
 	int r = 0;
 
 	/* Validate virtual address range against reserved regions. */
@@ -842,7 +842,7 @@ int amdgpu_gem_va_ioctl(struct drm_device *dev, void *data,
 
 	vm_size = adev->vm_manager.max_pfn * AMDGPU_GPU_PAGE_SIZE;
 	vm_size -= AMDGPU_VA_RESERVED_TOP;
-	if (args->va_address + args->map_size > vm_size) {
+	if (check_add_overflow(args->va_address, args->map_size, &tmp) || tmp > vm_size) {
 		dev_dbg(dev->dev,
 			"va_address 0x%llx is in top reserved area 0x%llx\n",
 			args->va_address + args->map_size, vm_size);
-- 
2.53.0

