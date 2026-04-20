Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F13BD62C;
	Mon, 20 Apr 2026 13:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691029; cv=none; b=O5Wq4RaelXhbPPwRmG388m+Aqm46t06GqMmy5mtQ6X9dkaTGPLcsFPFggqde1NKpqQXWjpJ0O368pIlm8dy4v1yew/cR3Zcswnso1i8TNWHjokQ6VzOjC88PoKTjXgqDBILoN7a+7wuLVjQEi6dfo+TLp5DtEtoB1q7oLLmkuag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691029; c=relaxed/simple;
	bh=DZpahuMZuqCNd1jPzatGrPOZ6xoX1xfgs8kTTvQ4FCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xyt+gH9q4rrDv/1V11Bth0YYTznlOzO1l5Fid4MNwtl8R7ndT0jQe3gNjOBUzdlwdftJWLO36k1YGIjKAhmxfbqeJhhMD0y/6skXcceTWm2xT3SeGnB5fRRIoqse0uPA4YESV3jJLJ/Df/dmtFlYJcL7D66fGqr754xIGo+lz1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=llYjXabH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="llYjXabH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3893C2BCB7;
	Mon, 20 Apr 2026 13:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691029;
	bh=DZpahuMZuqCNd1jPzatGrPOZ6xoX1xfgs8kTTvQ4FCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llYjXabHDskLhCbjyt9SsLoJD/RT91NY5yvJwD7Yo1Z5qRudNzlyZ5whtb2v2hmif
	 q/662MZE6KP7Sfm/Hc9lLV6yGJPjpMbMJiDIfTkBK/gPq5ZASMM+SPIH6kxqVrXL3W
	 rqOhUxxBRNpuY2RnAKGrcbVgNZB0mGM0tya+vdvgOV1hpNjidhCk6S0dWprwXj2u6X
	 H7K6cTxObAP5emlbNN7X1051e+9HCdby1WwvoWZj/6K76dJuZL0m3zD/3a6lgJNhbY
	 Y9SaPXyxdOirSIf4D0uECRa78XaJ4Gz+6dmQEbhYcTA1+9oPk9Os336gFWboaCWDIb
	 cejOkaVGCqgrA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu/userq: remove queue from doorbell xarray
Date: Mon, 20 Apr 2026 09:08:38 -0400
Message-ID: <20260420131539.986432-52-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit f0e46fd06c3f7590b0f06aea3c877f441c2cbccc ]

In case of failure in xa_alloc, remove the queue during
clean up from the userq_doorbell_xa.

Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Here is my complete analysis:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu/userq`
- Action verb: "remove" (corrective: removing a stale entry from data
  structure on error path)
- Summary: Remove queue from doorbell xarray during cleanup when
  xa_alloc fails

**Step 1.2: Tags**
- `Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>` - author, regular
  AMD GPU contributor
- `Reviewed-by: Christian König <christian.koenig@amd.com>` - AMD GPU
  subsystem co-maintainer
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` - AMD GPU
  subsystem maintainer
- No Fixes: tag (expected for manual review candidates)
- No Cc: stable tag

**Step 1.3: Commit Body Analysis**
The message says: "In case of failure in xa_alloc, remove the queue
during clean up from the userq_doorbell_xa." This clearly describes a
missing cleanup in an error path: the queue gets stored in
`userq_doorbell_xa` but is not removed if the subsequent `xa_alloc`
fails.

**Step 1.4: Hidden Bug Fix Detection**
This is not hidden - it's straightforwardly described as an error path
cleanup fix. However, the severity is greater than the commit message
suggests. It's actually a **use-after-free**: the queue is freed
(`kfree(queue)`) but its pointer remains in the doorbell xarray.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c`
- 1 line added: `xa_erase_irq(&adev->userq_doorbell_xa, index);`
- Function modified: `amdgpu_userq_create()`
- Scope: Single-file surgical fix, error path only

**Step 2.2: Code Flow Change**
In `amdgpu_userq_create()`:

1. Line 863: `xa_store_irq(&adev->userq_doorbell_xa, index, queue,
   GFP_KERNEL)` - stores queue in global doorbell xarray
2. Line 870: `xa_alloc(&uq_mgr->userq_xa, &qid, queue, ...)` - attempts
   to allocate a queue ID
3. If xa_alloc fails (line 872): error path calls
   `amdgpu_userq_fence_driver_free()`, `mqd_destroy()`, `kfree(queue)` -
   but did NOT remove the entry from `userq_doorbell_xa`
4. Fix adds `xa_erase_irq(&adev->userq_doorbell_xa, index)` before the
   kfree

**Step 2.3: Bug Mechanism**
This is a **use-after-free** caused by a missing cleanup on error path.
After `kfree(queue)`, the freed pointer remains in `userq_doorbell_xa`.
Six functions in the same file iterate `userq_doorbell_xa` with
`xa_for_each()` and dereference the queue pointer:
- `amdgpu_userq_suspend()` (line 1445)
- `amdgpu_userq_resume()` (line 1471)
- `amdgpu_userq_stop_sched_for_enforce_isolation()` (line 1501)
- `amdgpu_userq_start_sched_for_enforce_isolation()` (line 1535)
- `amdgpu_userq_pre_reset()` (line 1589)
- `amdgpu_userq_post_reset()` (line 1617)

All would crash or corrupt memory by accessing `queue->userq_mgr`,
`queue->state`, etc.

**Step 2.4: Fix Quality**
The fix is obviously correct: it mirrors the cleanup in the normal
destroy path (`amdgpu_userq_cleanup()` at line 463 already calls
`xa_erase_irq(&adev->userq_doorbell_xa, queue->doorbell_index)`). The
fix uses `xa_erase_irq()` matching the `xa_store_irq()` used during
insertion. No regression risk.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
The buggy error path (xa_alloc failure without doorbell cleanup) was
introduced by commit `f18719ef4bb7b` (Jesse.Zhang, October 2025) which
converted IDR to XArray. When the XArray conversion added
`xa_store_irq(&adev->userq_doorbell_xa, ...)` before `xa_alloc`, the
error cleanup for `xa_alloc` failure was not updated to remove the
doorbell entry.

**Step 3.2: Fixes Target**
No Fixes: tag present. The bug was introduced by f18719ef4bb7b.

**Step 3.3: Related Changes**
The companion commit `65b5c326ce410` ("refcount userqueues to avoid race
conditions") was cherry-picked with `Cc: stable@vger.kernel.org`,
showing this area is actively being stabilized for stable trees.

**Step 3.4: Author**
Sunil Khatri is a regular AMD GPU contributor with 11 commits to this
file alone. He also authored the refcount fix.

**Step 3.5: Dependencies**
This fix is standalone - it requires only that the doorbell xarray code
(from f18719ef4bb7b) exists, which it does in 7.0.

## PHASE 4: MAILING LIST RESEARCH

The exact commit "remove queue from doorbell xarray" was not found
independently on lore.kernel.org. However, the v2 series of the refcount
patchset (20260302180852) was a 2-patch series that included related
doorbell cleanup work. The patch was reviewed by Christian König (AMD
GPU co-maintainer) and committed through Alex Deucher (AMD GPU
maintainer).

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Modified Function**
`amdgpu_userq_create()` - creates usermode queues for AMD GPU userspace
queue submission.

**Step 5.2: Callers**
`amdgpu_userq_create()` is called from `amdgpu_userq_ioctl()` via
`AMDGPU_USERQ_OP_CREATE`, which is a DRM IOCTL callable from userspace.
This is a user-triggerable code path.

**Step 5.3-5.4: Impact Surface**
The stale entry in `userq_doorbell_xa` will be accessed by any
subsequent suspend, resume, reset, or isolation enforcement operation on
the GPU device. These are triggered by:
- System suspend/resume (S3, S0ix) - common laptop operation
- GPU reset (triggered by hang detection)
- Enforce isolation mode changes

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code in Stable Trees**
The file `amdgpu_userq.c` was first added in the v6.16/6.17 timeframe.
The `userq_doorbell_xa` was introduced by f18719ef4bb7b in the kernel
7.0 development cycle. This code exists in the 7.0 stable tree.

**Step 6.2: Backport Complexity**
This is a clean 1-line addition with no context conflicts expected.

## PHASE 7: SUBSYSTEM CONTEXT

- Subsystem: `drivers/gpu/drm/amd/amdgpu` - AMD GPU driver
- Criticality: IMPORTANT - widely used GPU driver on desktop/laptop
  systems
- Actively developed subsystem with heavy recent churn

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who is Affected**
Users with AMD GPUs using the usermode queue feature (GFX/Compute/DMA
queues).

**Step 8.2: Trigger Conditions**
The bug requires:
1. A userqueue creation attempt where `xa_store_irq` succeeds but
   `xa_alloc` fails (e.g., hitting `AMDGPU_MAX_USERQ_COUNT` limit or
   memory pressure)
2. Followed by any suspend, resume, reset, or isolation operation

The `xa_alloc` failure can be triggered by resource exhaustion or
concurrent queue creation under memory pressure.

**Step 8.3: Failure Mode Severity**
- **CRITICAL**: Use-after-free on freed queue pointer leads to kernel
  crash (oops/panic), potential memory corruption, or security
  vulnerability. The freed pointer is dereferenced to access
  `queue->userq_mgr`, `queue->state`, etc.

**Step 8.4: Risk-Benefit Ratio**
- BENEFIT: Very high - prevents UAF crash on a common GPU driver
- RISK: Very low - single line addition, mirrors existing cleanup
  pattern, obviously correct
- Ratio: Strongly favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes a real use-after-free bug (stale pointer in xarray after kfree)
- Single-line fix, surgically targeted to one error path
- Reviewed by Christian König (AMD GPU co-maintainer)
- Obviously correct (mirrors cleanup in normal destroy path)
- Related refcount commit already tagged Cc: stable
- User-triggerable code path (IOCTL)
- Failure mode is kernel crash or memory corruption

**Evidence AGAINST backporting:**
- Relatively new code (userq feature added in v6.16-7.0 timeframe)
- Trigger requires specific failure condition (xa_alloc failure)

**Stable Rules Checklist:**
1. Obviously correct and tested? YES - mirrors existing cleanup,
   reviewed by maintainer
2. Fixes a real bug? YES - use-after-free
3. Important issue? YES - potential crash, memory corruption, security
4. Small and contained? YES - 1 line added
5. No new features? YES - pure bug fix
6. Can apply to stable? YES - clean 1-line addition

## Verification

- [Phase 1] Parsed tags: Reviewed-by Christian König, Signed-off-by Alex
  Deucher and Sunil Khatri
- [Phase 2] Diff analysis: 1 line added in xa_alloc error path of
  amdgpu_userq_create(), adds missing xa_erase_irq() for doorbell xarray
- [Phase 3] git blame: buggy code introduced in f18719ef4bb7b (Oct
  2025), XArray conversion commit
- [Phase 3] git show f18719ef4bb7b: confirmed it added xa_store_irq to
  doorbell_xa without corresponding xa_erase_irq in xa_alloc failure
  path
- [Phase 3] Related commit 65b5c326ce410 already has Cc: stable
  (confirmed via git show)
- [Phase 4] b4 dig -c 65b5c326ce410: found patch at
  https://patch.msgid.link/20260303120849.2583663-1-sunil.khatri@amd.com
- [Phase 4] Mailing list archive: found v2 series and review discussion,
  Christian König reviewed
- [Phase 5] Grep for userq_doorbell_xa: found 6 xa_for_each iteration
  sites that would dereference the freed pointer
- [Phase 5] amdgpu_userq_create called from amdgpu_userq_ioctl (user-
  triggerable via DRM IOCTL)
- [Phase 6] amdgpu_userq.c first added around v6.16, doorbell_xa added
  in v7.0 cycle
- [Phase 8] Failure mode: UAF -> kernel crash/memory corruption,
  severity CRITICAL

This is a small, surgical, obviously correct fix for a real use-after-
free bug in the AMD GPU driver's error handling path. It was reviewed by
the subsystem co-maintainer and carries essentially zero regression
risk.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 0a1b93259887a..819c4c26416c3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -872,6 +872,7 @@ amdgpu_userq_create(struct drm_file *filp, union drm_amdgpu_userq *args)
 	if (r) {
 		drm_file_err(uq_mgr->file, "Failed to allocate a queue id\n");
 		amdgpu_userq_fence_driver_free(queue);
+		xa_erase_irq(&adev->userq_doorbell_xa, index);
 		uq_funcs->mqd_destroy(queue);
 		kfree(queue);
 		r = -ENOMEM;
-- 
2.53.0

