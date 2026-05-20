Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDF7A3976B2;
	Wed, 20 May 2026 11:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779275991; cv=none; b=IrlP+xNqmaOmRSbuqR8ZpgQScLJrcppHNMNGuRwzLZBLfQSEUQvvGsvKO3KG3PWN2z4u1ID31UpczC2TBzylr6XkhYDVjSwRzf3/qVMC8xt+TpRJGdyohYUsz5DLD1JvUO+VrtupvxOgiWdHBUkfcwt+QVp42LulMgmw9PQjsVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779275991; c=relaxed/simple;
	bh=13u2QvD9hyPqBZjwx0x3dGEFE4ptFUdjDMUqqa62g3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LvjjUKyTvh4rrOWrtcJCdqhoHZL+uF12I2z0OsJ6r4vLaks8xLTOSzRv+rzqE/20OaTpeVPktNQZvu0HOGS6JCcAwUw/jwxArwkpTxpWPbKNnheGqPflTlbBFmZgemMtz16WOwAX2elI+Adk+Meq6rLPvDou0YbPXJUgsHc6+YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MvQF/Ydj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MvQF/Ydj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3D61F00894;
	Wed, 20 May 2026 11:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779275987;
	bh=mcqkHPast5WaMmLnbX6eWr/yFuCYSCjUIJOTaNfPubo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvQF/YdjYaGupaCD3AK1UqEIAYBYB4qTSmkY8nRhJ4tw48PLl7E3BjjtykUtfjLqY
	 hUlNTb9g+oR0j6wTmEsipCgy/1Af7DhHynfR5Z/uejlUO89a58Sb7l+bQO2Wtq341K
	 Tc4+TOqm3ldyH01WT5DnQDn8eo78fi/MPLQZzNEz5N9yWOvn+Pkte0Pd4hYBZfkkN5
	 cf7UCL+PTjLL2FO3HRsdPmH9x58+1TjTtzfJyb+uz+J/7qWVGoeWnPGCLerIsHLEN4
	 p4FEzxyhqW/cjq+FIyKQ4kfT7XgZH65uRmUSv2Dxk3WW4Bz6NwMrvNa0yLrv9EPQI/
	 HF+//0igbC/bw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: remove deadlocks from amdgpu_userq_pre_reset
Date: Wed, 20 May 2026 07:18:34 -0400
Message-ID: <20260520111944.3424570-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Transfer-Encoding: 8bit

From: Christian König <christian.koenig@amd.com>

[ Upstream commit d5971c5c34303a00bf841a902ca00a703602c500 ]

The purpose of a GPU reset is to make sure that fence can be signaled
again and the signal and resume workers can make progress again.

So waiting for the resume worker or any fence in the GPU reset path is
just utterly nonsense.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fcd5f065eab46993af43442fd77ee8d9eb9c5bdf)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
This should be backported for stable trees that contain
`amdgpu_userq_pre_reset()`. It removes two blocking waits from the GPU
reset path: `cancel_delayed_work_sync(&uqm->resume_work)` and
`amdgpu_userq_wait_for_last_fence()`, where the latter waits on
`dma_fence_wait_timeout(..., MAX_SCHEDULE_TIMEOUT)`. The reset path is
precisely what is supposed to let those fences/workers make progress, so
waiting there can deadlock GPU recovery.

The patch is one-function, one-file, no new API, and `git apply --check`
succeeds against this `7.0.y` checkout. Main concern: the review thread
confirms broader queue-state locking concerns remain, but those are pre-
existing and the accepted patch was explicitly scoped to removing the
obvious deadlock.

## Phase Walkthrough
Phase 1:
- Record 1.1: subsystem `drm/amdgpu`; action `remove`; intent is to
  remove deadlocks from `amdgpu_userq_pre_reset()`.
- Record 1.2: tags present: `Signed-off-by: Christian König`, `Reviewed-
  by: Prike Liang`, `Signed-off-by: Alex Deucher`; no `Fixes:`,
  `Reported-by:`, `Tested-by:`, `Acked-by:`, `Link:`, or `Cc: stable`.
- Record 1.3: commit body says GPU reset exists to allow fences and
  signal/resume workers to progress; waiting for resume worker or fences
  inside reset is wrong. Failure mode: reset can hang/deadlock.
- Record 1.4: not hidden; it is explicitly a deadlock fix.

Phase 2:
- Record 2.1: one file, `drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c`,
  `+12/-14`; only `amdgpu_userq_pre_reset()` changed; single-file
  surgical fix.
- Record 2.2: before, reset path canceled `resume_work` synchronously
  and waited for `last_fence` before unmapping mapped queues. After, it
  skips non-mapped queues and directly unmaps/marks hung/force-completes
  mapped queues.
- Record 2.3: bug category is deadlock/hang. Mechanism: reset path
  waited on work/fences that may require reset progress to complete.
- Record 2.4: fix is minimal. Regression risk is low-to-medium because
  queue-state locking is still called out by the TODO and review
  discussion, but no new API or broad behavior is added.

Phase 3:
- Record 3.1: `git blame` shows the reset function came from
  `290f46cf57265` (`drm/amdgpu: Implement user queue reset
  functionality`); current textual lines were later touched by
  `473f12f820956` and `dc21e39fd20c7` helper/signature cleanups. `git
  describe --contains 290f46cf...` points to `v6.19-rc1`, so older
  stable trees before v6.19 likely do not contain this exact code.
- Record 3.2: no `Fixes:` tag, so no Fixes target to follow.
- Record 3.3: recent file history shows active userq work and related
  reset/fence changes; this patch applies standalone to current `7.0.y`.
- Record 3.4: `MAINTAINERS` lists Christian König and Alex Deucher as
  AMDGPU DRM maintainers; author/committer are subsystem maintainers.
- Record 3.5: no compile dependency found; patch is part of an 11-patch
  series but applies cleanly by itself.

Phase 4:
- Record 4.1: `b4 dig` failed because the commit object is absent
  locally. Fallback found the original patch at
  `lists.freedesktop.org/archives/amd-gfx/2026-April/143199.html`;
  committed version matches the patch content with `Reviewed-by` added.
- Record 4.2: `b4 -w` failed; lore thread shows Alex Deucher, Prike
  Liang, Sunil Khatri, and `amd-gfx` were involved.
- Record 4.3: no external bug report or syzbot link found.
- Record 4.4: series context exists (`[PATCH 02/11]`), with later
  userq/fence/reset cleanups, but no hard prerequisite was identified
  for this specific deadlock removal.
- Record 4.5: web search did not find stable-list discussion for this
  exact patch.

Phase 5:
- Record 5.1: modified function: `amdgpu_userq_pre_reset()`.
- Record 5.2: callers: local search shows only
  `amdgpu_device_halt_activities()`, called from
  `amdgpu_device_gpu_recover()` and PCI error handling.
- Record 5.3: affected callees include `userq_funcs->unmap()` and
  `amdgpu_userq_fence_driver_force_completion()`; removed callees
  include `cancel_delayed_work_sync()` and
  `amdgpu_userq_wait_for_last_fence()`.
- Record 5.4: reachable through AMDGPU recovery paths, including job
  timeout/GPU recovery paths; exact unprivileged trigger policy was not
  fully verified.
- Record 5.5: similar wait/cancel patterns remain in non-reset paths
  such as destroy/suspend/eviction, but the reset-path instance is the
  one fixed here.

Phase 6:
- Record 6.1: buggy code exists in this `7.0.y` tree and appears
  introduced for `v6.19-rc1`; likely relevant to v6.19+ stable trees
  containing userq reset support.
- Record 6.2: `git apply --check` succeeds against this checkout, so
  current `7.0.y` backport difficulty is clean.
- Record 6.3: no exact related stable replacement fix found locally or
  in web stable search.

Phase 7:
- Record 7.1: subsystem is AMDGPU DRM driver; criticality is IMPORTANT,
  driver-specific but for widely used GPU hardware.
- Record 7.2: subsystem/file is active; recent history contains many
  userq reset/fence fixes and refactors.

Phase 8:
- Record 8.1: affected users are AMDGPU users with user queues enabled
  who hit GPU reset/recovery.
- Record 8.2: trigger is GPU reset while user queues have pending resume
  work or unsignaled fences; commonality depends on userq usage and GPU
  hangs.
- Record 8.3: failure mode is GPU reset deadlock/hang; severity HIGH to
  CRITICAL because recovery can stall.
- Record 8.4: benefit is high for affected systems; risk is low-to-
  medium due small scope but reset-path concurrency sensitivity. Ratio
  favors backport.

Phase 9:
- Record 9.1 FOR: fixes deadlock, reset-path hang, small one-function
  diff, maintainer-authored, reviewed, applies cleanly. AGAINST: no
  reported user bug, no stable tag, part of a larger userq series,
  residual queue-state locking TODO. UNRESOLVED: no runtime
  reproduction/build, exact applicability to every active stable branch
  not verified.
- Record 9.2 stable rules: obviously correct enough by code and
  maintainer review: yes; fixes real bug: yes, deadlock; important
  issue: yes, recovery hang; small/contained: yes; no new API/features:
  yes; can apply to current stable tree: yes.
- Record 9.3 exception category: none.
- Record 9.4 decision: backport to stable trees containing this userq
  reset code.

## Verification
- [Phase 1] Parsed GitHub patch and lore message: confirmed subject,
  body, tags, and lack of `Fixes`/`Cc stable`.
- [Phase 2] Compared diff: confirmed one-file `+12/-14` change removing
  `cancel_delayed_work_sync()` and `amdgpu_userq_wait_for_last_fence()`.
- [Phase 3] `git blame`: confirmed reset code origin/refactor history
  around `amdgpu_userq_pre_reset()`.
- [Phase 3] `git describe --contains`: confirmed introduction is in the
  v6.19 era.
- [Phase 3] `MAINTAINERS`: confirmed Christian König and Alex Deucher
  maintain AMDGPU DRM.
- [Phase 4] `b4 dig -c/-a/-w`: failed because commit object is not in
  this checkout.
- [Phase 4] WebFetch GitHub patch and freedesktop lore: confirmed
  original patch, review discussion, and `Reviewed-by: Prike Liang`.
- [Phase 5] `rg` and file reads: confirmed caller path through
  `amdgpu_device_halt_activities()` and `amdgpu_device_gpu_recover()`.
- [Phase 6] `git apply --check`: confirmed clean application to current
  `7.0.y`.
- UNVERIFIED: no kernel build or runtime reproduction was performed;
  exact applicability to all non-`7.0.y` stable trees was not fully
  checked.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c | 26 +++++++++++------------
 1 file changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
index 0a1b93259887a..6f49ba3bd0394 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -1583,23 +1583,21 @@ void amdgpu_userq_pre_reset(struct amdgpu_device *adev)
 {
 	const struct amdgpu_userq_funcs *userq_funcs;
 	struct amdgpu_usermode_queue *queue;
-	struct amdgpu_userq_mgr *uqm;
 	unsigned long queue_id;
 
+	/* TODO: We probably need a new lock for the queue state */
 	xa_for_each(&adev->userq_doorbell_xa, queue_id, queue) {
-		uqm = queue->userq_mgr;
-		cancel_delayed_work_sync(&uqm->resume_work);
-		if (queue->state == AMDGPU_USERQ_STATE_MAPPED) {
-			amdgpu_userq_wait_for_last_fence(queue);
-			userq_funcs = adev->userq_funcs[queue->queue_type];
-			userq_funcs->unmap(queue);
-			/* just mark all queues as hung at this point.
-			 * if unmap succeeds, we could map again
-			 * in amdgpu_userq_post_reset() if vram is not lost
-			 */
-			queue->state = AMDGPU_USERQ_STATE_HUNG;
-			amdgpu_userq_fence_driver_force_completion(queue);
-		}
+		if (queue->state != AMDGPU_USERQ_STATE_MAPPED)
+			continue;
+
+		userq_funcs = adev->userq_funcs[queue->queue_type];
+		userq_funcs->unmap(queue);
+		/* just mark all queues as hung at this point.
+		 * if unmap succeeds, we could map again
+		 * in amdgpu_userq_post_reset() if vram is not lost
+		 */
+		queue->state = AMDGPU_USERQ_STATE_HUNG;
+		amdgpu_userq_fence_driver_force_completion(queue);
 	}
 }
 
-- 
2.53.0

