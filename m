Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0952B3E4C8A;
	Mon, 20 Apr 2026 13:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691489; cv=none; b=eHlUCcAaGtYA/2Q7Hfyg1/GPPAgfNPX/zyE7Ku8xN5AWGKIReUP8ZCmGclUNHCZXketzIJJhd2LUCC+tPxHWwNgR+xEJdQ8JhRWJ701alvTQvALjoI+BYR2NN3HMRdig1/AdqBvOYznBfjM3VvK8tc7R4LtkRaUJYYuoOt+SPRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691489; c=relaxed/simple;
	bh=K+abhW/puOvk0GiLGkZxTD+eABJaQ50Ve9fCR3OGFe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BttHDce/vkG0/sx134wWLCfG7mGbvsr/KXyvAsE3HkuQTrNyvHBBa956SxcMb17a4koJzcDTrDiGmae8Zr4wLNTbY/dTxcMHcBhaMqjIHhBZY2Q+ENC2It48+aF6sravsy/LgsRxKk1uaZ+smSVNR1rDGmCfgU5/tP/eQ9Lh52k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vGynKn33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vGynKn33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729B6C2BCB6;
	Mon, 20 Apr 2026 13:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691488;
	bh=K+abhW/puOvk0GiLGkZxTD+eABJaQ50Ve9fCR3OGFe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGynKn337kPdSCNCMySywj+EX3uGFeppBH7nUjEGXJ2OAGP58RLV5PTHJM+0iRYU8
	 qiKCZGgaXWIx60zYuzEHvqkAu/NzpcaUYev2X8/PkDB9GcEWuo1plck/oVp4rBtgP4
	 nB4PrkIrws94+yCPqtxzwM+zPxMRcs3chVyNNnCUIqMuCEkvT9FVIY0NMozlEb4K8V
	 bTfrgJdw6KiWLDqBoQ8UFT98kmfNq/pEaZX6OzJFzmmlG6X8KkHFunxynqrxSJjDQf
	 3EymuTVS42rWyCzKutsdx8jHbVgKal5bdU7BMrwcdQhMJaPJO23vgTvg/saEo+Jls9
	 wlFQtSQEabgfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Nguyen <brian3.nguyen@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/xe: Skip adding PRL entry to NULL VMA
Date: Mon, 20 Apr 2026 09:17:33 -0400
Message-ID: <20260420132314.1023554-59-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Nguyen <brian3.nguyen@intel.com>

[ Upstream commit 1b12096b4bc5177d685ae098fdb90260ffd5db6b ]

NULL VMAs have no corresponding PTE, so skip adding a PRL entry to avoid
an unnecessary PRL abort during unbind.

Signed-off-by: Brian Nguyen <brian3.nguyen@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260305171546.67691-8-brian3.nguyen@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: drm/xe (Intel Xe GPU driver)
- **Action verb**: "Skip" - implies avoiding an incorrect/unnecessary
  operation
- **Summary**: Skip adding Page Reclaim List (PRL) entry for NULL VMAs

### Step 1.2: Tags
- **Signed-off-by**: Brian Nguyen (author), Matt Roper (xe maintainer
  applied it)
- **Reviewed-by**: Matthew Brost (xe subsystem maintainer) - strong
  quality signal
- **Link**: `https://patch.msgid.link/20260305171546.67691-8-
  brian3.nguyen@intel.com` - patch 8 of a series
- No Fixes: tag (expected for manual review candidates)
- No Reported-by: (indicates developer-found issue during
  development/testing)
- No Cc: stable (expected)

### Step 1.3: Commit Body
- Bug: NULL VMAs have no corresponding PTE, so they shouldn't have PRL
  entries
- Consequence: "an unnecessary PRL abort during unbind"
- When PRL aborts, it invalidates the entire PRL batch and falls back to
  full PPC (Page-Private Cache) invalidation

### Step 1.4: Hidden Bug Fix Detection
This is a correctness fix disguised as optimization. The word "skip" and
"unnecessary" might sound like optimization, but the actual issue is:
NULL VMAs being processed through page reclaim creates incorrect PRL
entries with bogus physical addresses (address 0), which triggers PRL
abort for the entire unbind batch.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Single file**: `drivers/gpu/drm/xe/xe_page_reclaim.c`
- **+8 lines / -0 lines** (3 doc comment lines, 3 code lines including
  blank, 2 context lines)
- **Function modified**: `xe_page_reclaim_skip()`
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
**Before**: `xe_page_reclaim_skip()` directly accesses
`vma->attr.pat_index` and checks L3 policy. For NULL VMAs, this produces
a potentially meaningless L3 policy result, and the function returns
false (don't skip), leading to PRL entry generation.

**After**: An `xe_vma_is_null(vma)` check at the top returns true (skip)
immediately for NULL VMAs, preventing any page reclaim processing.

### Step 2.3: Bug Mechanism
**Category**: Logic/correctness fix. NULL VMAs (`DRM_GPUVA_SPARSE`) have
PTEs with `XE_PTE_NULL` bit set (bit 9) but no real physical backing.
When processed through the PRL generation during unbind:
1. The PTE is non-zero (has `XE_PTE_NULL` set), so it passes the `if
   (!pte)` check
2. `generate_reclaim_entry()` extracts `phys_addr = pte &
   XE_PTE_ADDR_MASK` which gives address 0
3. This creates bogus PRL entries or triggers PRL abort, invalidating
   the ENTIRE PRL for the batch

### Step 2.4: Fix Quality
- **Obviously correct**: NULL VMAs have no physical backing, so page
  reclaim is meaningless for them
- **Minimal/surgical**: 2 lines of actual code
- **Regression risk**: Near zero - `xe_vma_is_null()` is used throughout
  the codebase for exactly this purpose
- **No red flags**: Uses existing well-tested inline function

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy code (`xe_page_reclaim_skip` without NULL VMA check) was
introduced by commit `7c52f13b76c531` (2025-12-13) "drm/xe: Optimize
flushing of L2$ by skipping unnecessary page reclaim". This was part of
the initial page reclaim feature series.

### Step 3.2: Fixes Tag
No Fixes: tag present. The root cause is `7c52f13b76c53` which didn't
account for NULL VMAs when implementing the skip logic.

### Step 3.3: File History
The entire `xe_page_reclaim.c` was introduced in v7.0-rc1 (commit
`b912138df2993`, 2025-12-13). 6 commits have touched this file. The
sibling patch from the same series (`38b8dcde23164` "Skip over non leaf
pte for PRL generation") was already cherry-picked to
`stable/linux-7.0.y`.

### Step 3.4: Author
Brian Nguyen is the primary developer of the page reclaim feature
(authored all ~15 page reclaim commits). He is the domain expert for
this code.

### Step 3.5: Dependencies
This fix is standalone - it only adds a guard check to an existing
function. No prerequisite patches needed. The function
`xe_vma_is_null()` exists in all v7.0 trees.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
b4 dig found the series as "Page Reclamation Fixes" (v3/v4 series, 3
patches). The series went through at least 3 revisions (v2, v3, v4)
before being accepted, indicating thorough review.

### Step 4.2: Reviewers
- Matthew Brost (xe maintainer) reviewed the patch
- Stuart Summers was CC'd
- Applied by Matt Roper (Intel xe maintainer)

### Steps 4.3-4.5:
Lore.kernel.org was inaccessible due to anti-bot protection. Could not
verify mailing list discussion details.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Callers
`xe_page_reclaim_skip()` is called from a single location in `xe_pt.c`
line 2084:

```2083:2084:drivers/gpu/drm/xe/xe_pt.c
pt_op->prl = (xe_page_reclaim_list_valid(&pt_update_ops->prl) &&
             !xe_page_reclaim_skip(tile, vma)) ? &pt_update_ops->prl :
NULL;
```

This is in the unbind preparation path, called whenever a VMA is being
unbound from a tile.

### Step 5.3-5.4: Call Chain
The unbind path is reachable from userspace via
`ioctl(DRM_IOCTL_XE_VM_BIND)` with `DRM_XE_VM_BIND_OP_UNMAP`. NULL VMAs
are created via sparse binding operations, which are a normal GPU usage
pattern.

### Step 5.5: Similar Patterns
`xe_vma_is_null()` is already checked at multiple points in the Xe
driver:
- `xe_pt.c` line 449/479 (page table walk: "null VMA's do not have dma
  addresses")
- `xe_vm.c` line 4033 (invalidation: `xe_assert(!xe_vma_is_null(vma))`)
- `xe_vm_madvise.c` line 209 (madvise: skip null VMAs)

This confirms the established pattern: NULL VMAs need special handling
throughout the driver.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable
- **v7.0.y**: YES - file exists, code is present, fix is needed
- **v6.13.y and older**: NO - `xe_page_reclaim.c` does not exist
  (`fatal: path exists on disk, but not in 'v6.13'`)

### Step 6.2: Backport Complications
The fix would apply cleanly to 7.0.y - the file in `stable/linux-7.0.y`
is identical to the file on the main branch at v7.0.

### Step 6.3: Related Fixes in Stable
The sibling patch `38b8dcde23164` ("Skip over non leaf pte for PRL
generation") from the same "Page Reclamation Fixes" series was already
cherry-picked to 7.0.y stable (has explicit `Fixes:` tag).

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: GPU driver (drivers/gpu/drm/xe) - Intel Xe
  discrete/integrated GPU
- **Criticality**: IMPORTANT - Intel Xe GPU users on newer hardware
  (Lunar Lake, Arrow Lake, etc.)

### Step 7.2: Activity
Very active subsystem with many fixes flowing to 7.0.y stable (20+ xe
patches already cherry-picked).

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Intel Xe GPU users with hardware that supports page reclaim (specific
newer GPUs with `has_page_reclaim_hw_assist`).

### Step 8.2: Trigger Conditions
Triggered when unbinding sparse/NULL VMAs, which happens during normal
GPU memory management operations. Common in graphics workloads using
sparse resources.

### Step 8.3: Failure Mode
- PRL abort -> fallback to full PPC (Page-Private Cache) invalidation
- Severity: MEDIUM - performance degradation (full cache flush instead
  of targeted reclaim), not crash/corruption
- The abort invalidates the ENTIRE PRL batch, affecting all VMAs in the
  unbind operation, not just the NULL one

### Step 8.4: Risk-Benefit
- **Benefit**: MEDIUM - prevents incorrect PRL processing and
  unnecessary PRL aborts for all unbind batches containing NULL VMAs
- **Risk**: VERY LOW - 2-line guard check using existing well-tested
  function
- **Ratio**: Favorable

## PHASE 9: SYNTHESIS

### Step 9.1: Evidence Compilation

**FOR backporting:**
- Small, surgical fix (2 lines of code)
- Obviously correct (NULL VMAs have no physical backing, well-
  established pattern)
- Reviewed by subsystem maintainer (Matthew Brost)
- Same series as another commit already cherry-picked to 7.0.y
- Prevents incorrect behavior in page reclaim path
- Near-zero regression risk
- Author is the page reclaim feature developer

**AGAINST backporting:**
- No explicit Fixes: tag
- Not a crash/corruption/security fix - primarily
  performance/correctness
- Only applicable to 7.0.y (code doesn't exist in older stable trees)
- PRL abort is handled gracefully (fallback mechanism exists)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial guard check, reviewed
   by maintainer
2. Fixes a real bug? **YES** - NULL VMAs incorrectly processed through
   page reclaim
3. Important issue? **MEDIUM** - causes PRL abort and full cache flush
   fallback for all VMAs in batch
4. Small and contained? **YES** - 2 lines in one file
5. No new features? **YES** - just a guard check
6. Applies to stable? **YES** for 7.0.y only

### Step 9.3: Exception Categories
Not applicable.

### Step 9.4: Decision
This is a small, correct, well-reviewed fix for a real logic bug in the
Xe page reclaim path. While the consequence is primarily performance
(PRL abort causing full cache flush fallback) rather than crash, the fix
is extremely low-risk and the sibling patch from the same series was
already selected for 7.0.y stable. The fix prevents incorrect behavior
for a common GPU operation (unbinding sparse VMAs).

## Verification

- [Phase 1] Parsed tags: Reviewed-by Matthew Brost (xe maintainer),
  applied by Matt Roper
- [Phase 2] Diff analysis: 2 functional lines added to
  `xe_page_reclaim_skip()`, adding NULL VMA guard check
- [Phase 3] git blame: buggy code introduced in `7c52f13b76c531`
  (v7.0-rc1, 2025-12-13)
- [Phase 3] git log: entire `xe_page_reclaim.c` file created in v7.0-rc1
- [Phase 3] git show: author Brian Nguyen wrote all page reclaim commits
  (domain expert)
- [Phase 4] b4 dig -a: series "Page Reclamation Fixes" went through
  v2→v3→v4, indicating thorough review
- [Phase 4] b4 dig -w: Matthew Brost, Stuart Summers, intel-xe@ involved
  in review
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org discussion due
  to anti-bot protection
- [Phase 5] Grep for callers: `xe_page_reclaim_skip()` called only from
  `xe_pt.c:2084` (unbind path)
- [Phase 5] Grep for `xe_vma_is_null`: used at 10+ locations in xe
  driver, well-established pattern
- [Phase 6] `git show v6.13:drivers/gpu/drm/xe/xe_page_reclaim.c`
  confirmed file does NOT exist in v6.13 or v6.12
- [Phase 6] `git show
  stable/linux-7.0.y:drivers/gpu/drm/xe/xe_page_reclaim.c` confirmed
  code exists in 7.0.y without fix
- [Phase 6] Sibling patch `38b8dcde23164` already in stable/linux-7.0.y
  (confirmed via `git log stable/linux-7.0.y`)
- [Phase 8] PRL abort path verified: invalidates PRL, increments
  counter, logs debug message - graceful fallback

**YES**

 drivers/gpu/drm/xe/xe_page_reclaim.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_page_reclaim.c b/drivers/gpu/drm/xe/xe_page_reclaim.c
index e13c71a89da2c..390bcb82e4c5c 100644
--- a/drivers/gpu/drm/xe/xe_page_reclaim.c
+++ b/drivers/gpu/drm/xe/xe_page_reclaim.c
@@ -26,12 +26,18 @@
  * flushes.
  * - pat_index is transient display (1)
  *
+ * For cases of NULL VMA, there should be no corresponding PRL entry
+ * so skip over.
+ *
  * Return: true when page reclamation is unnecessary, false otherwise.
  */
 bool xe_page_reclaim_skip(struct xe_tile *tile, struct xe_vma *vma)
 {
 	u8 l3_policy;
 
+	if (xe_vma_is_null(vma))
+		return true;
+
 	l3_policy = xe_pat_index_get_l3_policy(tile->xe, vma->attr.pat_index);
 
 	/*
-- 
2.53.0

