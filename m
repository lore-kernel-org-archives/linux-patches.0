Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455ED3FB7DF;
	Mon, 20 Apr 2026 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691583; cv=none; b=PCImIEWDJg77g4NfVejdCCrANr7Nv1wG9m6lYTO1As7fdAGR/s/nTMccjC7CyO1lhT0ATGSIWmARWfo5KRYRnxHyh37e2hWj03AjjN/ZT+acQTcdcxxiy6009FpBJjL4oppIooQhusgvsA3VwYDspU2+n9+0mXrpPQ/3kx/AK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691583; c=relaxed/simple;
	bh=4COp8xb5iO+Kg0G+zZIjHdRsnR2gbF62l8JK/WOAnOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aLvV5uvXjcA2vvUivQUlzL2Wh4KjugdM2FlP7H4DelBEm9euZ+zKyYE9NNtCbR09PyIB7hTZnJdQFfGUHC/l0NeD5dQ81s9L8dFWGOL9qnsh6uyWQy5cPKiGVosBU79uS1jy9o7V41ya4mf7PYxYnd7TXYH4bPDn2sgu1+2gFJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kXw2ap40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kXw2ap40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA3DC19425;
	Mon, 20 Apr 2026 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691582;
	bh=4COp8xb5iO+Kg0G+zZIjHdRsnR2gbF62l8JK/WOAnOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kXw2ap40PnjZqEJahn5cJxSR/zIjKNgmwOOYohhpHgTZ86goJs30oDDyeMqWFZI8B
	 ECJXVmhf+hTdaAXPI2ks0TvZPn4VYuTZTbix+Z/kjpTCP4Wo3fwpPbTl+WPVbwm4MT
	 8vhuQI35WSPQFRsq1m70S64Vv/1wkKuBP4G0RlPfPpvXNE0Qtos39ya6vqgPTpsEz4
	 PT2upwfwdVf9WbAgj/0ZGY+oMzXw7Ji27PSFB6Xa+i+wFS5PCYnWnv8gEHEZyNmGx8
	 HVnZEpFSPqZ4AXy0XCnQr4E0m8QKw752ccQ/S6HVC34vOn0UktJM9z1QMSAZzoxEqd
	 jINg/tOzucfOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: fix amdgpu_userq_evict
Date: Mon, 20 Apr 2026 09:18:28 -0400
Message-ID: <20260420132314.1023554-114-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 98dc529a27c57e184ab47453993ba9cfcfcec0ca ]

Canceling the resume worker synchonized can deadlock because it can in
turn wait for the eviction worker through the userq_mutex.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Sunil Khatri <sunil.khatri@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu` (AMD GPU DRM driver)
- Action verb: "fix"
- Summary: Fix deadlock in `amdgpu_userq_evict` function
- Record: [drm/amdgpu] [fix] [deadlock in userqueue eviction path]

**Step 1.2: Tags**
- Signed-off-by: Christian König (author, AMD's senior DRM/GPU
  maintainer)
- Reviewed-by: Alex Deucher (AMD's kernel graphics lead maintainer)
- Reviewed-by: Sunil Khatri
- Signed-off-by: Alex Deucher (committer)
- No Fixes: tag (expected - that's why manual review is needed)
- No Cc: stable (expected)
- Record: Author is subsystem maintainer. Two Reviewed-by tags from AMD
  developers. Strong quality signal.

**Step 1.3: Commit Body**
- Bug: Canceling the resume worker synchronously
  (`cancel_delayed_work_sync`) can deadlock because the resume worker
  waits for the eviction worker via `userq_mutex`.
- Record: Classic AB-BA deadlock between suspend_worker and
  resume_worker via `userq_mutex`.

**Step 1.4: Hidden Bug Fix Detection**
- This is explicitly labeled "fix" and describes a deadlock. Not hidden
  at all.
- Record: Obvious deadlock fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c`
- Lines removed: ~6, lines added: ~2 (net -4 lines)
- Function modified: `amdgpu_userq_evict()`
- Scope: single-file surgical fix in one function
- Record: Very small, contained change.

**Step 2.2: Code Flow Change**

BEFORE:
```c
if (evf_mgr->fd_closing) {
    cancel_delayed_work_sync(&uq_mgr->resume_work);
    return;
}
schedule_delayed_work(&uq_mgr->resume_work, 0);
```

AFTER:
```c
if (!evf_mgr->fd_closing)
    schedule_delayed_work(&uq_mgr->resume_work, 0);
```

Before: When `fd_closing`, synchronously cancel any pending resume work
and return. Otherwise, schedule resume work.
After: Simply don't schedule resume work when `fd_closing`. No
synchronous cancel.

**Step 2.3: Bug Mechanism**

This is a **deadlock** fix. The verified call chain:

1. `amdgpu_eviction_fence_suspend_worker()` acquires
   `uq_mgr->userq_mutex` (line 110 in `amdgpu_eviction_fence.c`), then
   calls `amdgpu_userq_evict()` (line 119)
2. `amdgpu_userq_evict()` calls
   `cancel_delayed_work_sync(&uq_mgr->resume_work)` when `fd_closing` -
   this waits for resume_work to finish
3. `amdgpu_userq_restore_worker()` (the resume_work callback) first
   calls `flush_delayed_work(&fpriv->evf_mgr.suspend_work)` (line 1277),
   which waits for the suspend_worker, then tries to acquire
   `userq_mutex` (line 1279)

Result: suspend_worker holds `userq_mutex` and waits for resume_worker;
resume_worker either flushes suspend_worker (direct circular wait) or
waits for `userq_mutex` (held by suspend_worker). Classic deadlock.

Record: [Deadlock] [suspend_worker holds userq_mutex ->
cancel_delayed_work_sync waits for resume_worker -> resume_worker
flushes suspend_worker or waits for userq_mutex = DEADLOCK]

**Step 2.4: Fix Quality**
- Obviously correct: Removing the `cancel_delayed_work_sync` eliminates
  the deadlock
- Minimal/surgical: Only removes the dangerous synchronous cancel, keeps
  the logic of not resuming when fd is closing
- Regression risk: Very low. The only concern would be if a stale
  resume_work runs after fd_closing, but other cleanup paths
  (`amdgpu_userq_destroy` at line 632 does `cancel_delayed_work_sync`
  safely before taking mutex) handle this properly.
- Record: High quality fix. No regression risk.

---

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The buggy `cancel_delayed_work_sync` in `amdgpu_userq_evict` was
  introduced by commit `f10eb185ad0552` (Arvind Yadav, 2025-05-07, "Fix
  NULL dereference in amdgpu_userq_restore_worker"), though the original
  `fd_closing` branch was from `44cfdf368fb72c` (Shashank Sharma,
  2024-11-20, "resume gfx userqueues").
- Record: Buggy code introduced in the v6.16 development cycle.

**Step 3.2:** No Fixes: tag to follow.

**Step 3.3: Related Changes**
- Commit `648a0dc0d78c3` fixed a different deadlock in the same file
  (mutex ordering between `adev->userq_mutex` and `uqm->userq_mutex`)
- Record: There have been multiple deadlock fixes in this subsystem,
  indicating active locking issues being resolved.

**Step 3.4: Author**
- Christian König is one of the most senior AMD DRM kernel developers
  and a core maintainer of the AMDGPU driver.
- Record: Author is THE subsystem expert. Very high trust signal.

**Step 3.5: Dependencies**
- The fix is self-contained and standalone. It modifies one conditional
  block in one function.
- Record: No dependencies. Clean standalone fix.

---

## PHASE 4: MAILING LIST

- b4 dig could not find the fix commit directly (it appears to be very
  recent, possibly not yet indexed)
- lore.kernel.org search was blocked by anti-scraping protection
- Record: Could not verify mailing list discussion, but the commit has
  two Reviewed-by tags confirming peer review.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions modified**
- Only `amdgpu_userq_evict()` is modified.

**Step 5.2: Callers**
- `amdgpu_userq_evict()` is called from
  `amdgpu_eviction_fence_suspend_worker()` in `amdgpu_eviction_fence.c`
  (line 119). This is a workqueue callback triggered by
  `amdgpu_eviction_fence_enable_signaling()` (line 141), which is a
  dma_fence_ops callback. This means eviction happens automatically when
  BO resources need to be moved, making this a common code path during
  normal GPU operation.

**Step 5.3-5.4: Call chains**
- The eviction path is triggered when dma_fence signaling is enabled on
  eviction fences attached to BOs. This happens during VM page table
  operations, memory allocation, etc. - very common GPU operations.
- Record: The buggy path is reachable during normal GPU usage by any
  userspace GPU application.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Does the buggy code exist in stable trees?**
- Verified `amdgpu_userq.c` does NOT exist in v6.12, v6.13, v6.14, or
  v6.15
- File first appears in v6.16
- The buggy `cancel_delayed_work_sync` in `amdgpu_userq_evict` exists in
  v6.16, v6.17, v6.18, v6.19, and v7.0
- This workspace is `linux-autosel-7.0`, evaluating for the 7.0.y stable
  tree
- Record: Bug exists in v7.0 (the target tree) and v6.19.y (current
  active stable).

**Step 6.2: Backport difficulty**
- The v7.0 version of the function is identical to the current HEAD -
  the patch should apply cleanly.
- Record: Clean apply expected.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/gpu/drm/amd/amdgpu` - AMD GPU driver, one of the most widely
  used GPU drivers
- Criticality: IMPORTANT - affects all AMD GPU users
- Record: [drm/amdgpu] [IMPORTANT]

**Step 7.2: Activity**
- Very active subsystem with frequent commits
- Multiple deadlock fixes in the userqueue code recently, indicating
  this is a new subsystem under active development and bug fixing
- Record: Very active, new code with multiple recent fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is affected**
- All users of AMD GPUs with userqueue support (modern AMD hardware)
- Record: Driver-specific but large user population (all AMD GPU users
  with newer hardware)

**Step 8.2: Trigger conditions**
- The deadlock triggers when: (1) an eviction fence signals while (2)
  `fd_closing` is true and (3) a resume_work is pending or running
- This can happen during normal application shutdown/close while GPU
  operations are in progress
- Record: Triggered during fd close with concurrent GPU eviction -
  realistic scenario during application exit.

**Step 8.3: Failure mode severity**
- DEADLOCK = system hang (at minimum the GPU tasks hang, potentially
  wider if other kernel threads wait on the locked mutex)
- Severity: CRITICAL
- Record: [Deadlock -> system hang] [CRITICAL]

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Very high - prevents deadlocks during normal GPU operation
- RISK: Very low - 2 lines added, 6 removed, obviously correct, written
  and reviewed by subsystem maintainers
- Record: [Very high benefit] [Very low risk] [Strongly favorable]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Compilation**

FOR backporting:
- Fixes a real deadlock (CRITICAL severity)
- Very small, surgical fix (net -4 lines)
- Written by Christian König (senior AMD DRM maintainer)
- Reviewed by Alex Deucher (AMD's kernel graphics lead) and Sunil Khatri
- Bug exists in v7.0 (the target stable tree)
- Deadlock is triggered during normal operations (fd close with GPU
  activity)
- Obviously correct - removes the synchronous cancel that causes the
  deadlock
- Self-contained, no dependencies

AGAINST backporting:
- No items identified

Unresolved:
- Could not verify mailing list discussion (lore blocked)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** - The deadlock mechanism is
   clear and verifiable from code. Fix is minimal. Two Reviewed-by tags.
2. Fixes a real bug? **YES** - Deadlock during GPU eviction with
   fd_closing.
3. Important issue? **YES** - Deadlock = system hang (CRITICAL).
4. Small and contained? **YES** - Net -4 lines in a single function.
5. No new features or APIs? **YES** - Pure bug fix.
6. Can apply to stable trees? **YES** - Code in v7.0 is identical; clean
   apply expected.

**Step 9.3: Exception Categories**
- Not applicable - this is a standard bug fix, not an exception
  category.

**Step 9.4: Decision**
All evidence strongly supports backporting. This is a textbook deadlock
fix: small, surgical, obviously correct, fixes a critical issue, written
and reviewed by the subsystem maintainers.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by Christian König (author),
  Reviewed-by Alex Deucher, Reviewed-by Sunil Khatri, Signed-off-by Alex
  Deucher (committer)
- [Phase 2] Diff analysis: Removes `cancel_delayed_work_sync()` call in
  `amdgpu_userq_evict()` (which is called under `userq_mutex`), replaces
  6-line if/cancel/return/else/schedule block with 2-line if-not-
  closing/schedule
- [Phase 3] git blame: `cancel_delayed_work_sync` at line 1391 was
  introduced by commit `f10eb185ad0552` (2025-05-07), fd_closing branch
  by `44cfdf368fb72c` (2024-11-20)
- [Phase 3] git log: Found related deadlock fix `648a0dc0d78c3` in same
  file, confirming pattern of locking issues
- [Phase 3] Author check: Christian König is a senior AMD DRM maintainer
  with extensive commit history
- [Phase 4] b4 dig: Could not find the specific fix commit (likely too
  recent); found original buggy series at lore
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org due to anti-
  scraping protection
- [Phase 5] Caller analysis: `amdgpu_userq_evict()` called from
  `amdgpu_eviction_fence_suspend_worker()` which holds `userq_mutex`
  (verified in amdgpu_eviction_fence.c lines 110-119)
- [Phase 5] Deadlock chain verified: suspend_worker(holds userq_mutex)
  -> cancel_delayed_work_sync(resume_work) -> resume_worker calls
  flush_delayed_work(suspend_work) at line 1277 AND
  mutex_lock(userq_mutex) at line 1279 = DEADLOCK
- [Phase 6] File existence check: `amdgpu_userq.c` does NOT exist in
  v6.12, v6.13, v6.14, v6.15; EXISTS in v6.16, v6.17, v6.18, v6.19, v7.0
- [Phase 6] Verified buggy `cancel_delayed_work_sync` in
  `amdgpu_userq_evict` exists in v6.16 through v7.0 (all versions
  checked)
- [Phase 6] Verified v7.0 code is identical to current HEAD - clean
  apply expected
- [Phase 8] Failure mode: Deadlock -> system hang during GPU fd close,
  severity CRITICAL

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 09f1d05328897..e8d12556d690a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1389,13 +1389,8 @@ amdgpu_userq_evict(struct amdgpu_userq_mgr *uq_mgr,
 	/* Signal current eviction fence */
 	amdgpu_eviction_fence_signal(evf_mgr, ev_fence);
 
-	if (evf_mgr->fd_closing) {
-		cancel_delayed_work_sync(&uq_mgr->resume_work);
-		return;
-	}
-
-	/* Schedule a resume work */
-	schedule_delayed_work(&uq_mgr->resume_work, 0);
+	if (!evf_mgr->fd_closing)
+		schedule_delayed_work(&uq_mgr->resume_work, 0);
 }
 
 int amdgpu_userq_mgr_init(struct amdgpu_userq_mgr *userq_mgr, struct drm_file *file_priv,
-- 
2.53.0

