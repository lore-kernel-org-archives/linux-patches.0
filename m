Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C9B16132F;
	Sat, 25 Oct 2025 16:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408916; cv=none; b=Bvs1221ZcU7Hvs4l42Br3uIxOCBFNmnlPtfb7GEPI42+lsLM7RgRmLR8H2g7woJ11m3m4bj2Dngp0A1WAbQ0yHNzFK947UfmAAwE8g8IR2xoErGh9COU2N90pBHoJ9ulBv8heasFh3tAQjJk0xXC/COF+jvniHr1RVWNcnlwvnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408916; c=relaxed/simple;
	bh=fYpM4OCadbsv58G8fyRyUlNKco7Ezbjct5Df9ZTEAEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdocYHEHMTCIjEPC+ZeVK2IfdV0XNZpjKGysi4205qG9hCMvGsupKYV6ujv6LYGCZSIYSzihBWRNxDjPDCB4KFy/od8ONe9o8+bCMC48MgQU1qZ1shvdu0s8kOV4GtAdohL9h3y20EdUPYZLRlrRUlhgtp+6HH/vsZNc8OvGQVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=boY/eyXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="boY/eyXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06A55C4CEFF;
	Sat, 25 Oct 2025 16:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408916;
	bh=fYpM4OCadbsv58G8fyRyUlNKco7Ezbjct5Df9ZTEAEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boY/eyXLzOJqNlZwjV8nhMXM/nxfFGoDYYAGVcACMsUiPVyStbLlU/0BURTjrUUIB
	 xC9DLeHDN8xeNhD6prGYrqjDfOBtXkWc3cbEVUN1ZMmDI30LabSeMWP7aCH3KvAeTU
	 sn7Xyr/otCe0l+t8080LxIFrONppWZddyLiulMVF0o1rfoA9a2cbAAPpdUEVSzz71l
	 rCZ3a+dFppRYCidtx9Wuoaxzae4Q4URbmdqMTOgAWKHgbOLvTwwGDtpX+elwOHiwH2
	 eZxrnhzUSHnZvGZmyuq7erIQrUVbzI3PqpjyvbHDA7i4PwCTCSnCj7fyc87rebYjrl
	 k54M/nhUiRLiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Karunika Choo <karunika.choo@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Dennis Tsiang <dennis.tsiang@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>,
	boris.brezillon@collabora.com,
	dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/panthor: Serialize GPU cache flush operations
Date: Sat, 25 Oct 2025 11:56:00 -0400
Message-ID: <20251025160905.3857885-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Karunika Choo <karunika.choo@arm.com>

[ Upstream commit e322a4844811b54477b7072eb40dc9e402a1725d ]

In certain scenarios, it is possible for multiple cache flushes to be
requested before the previous one completes. This patch introduces the
cache_flush_lock mutex to serialize these operations and ensure that
any requested cache flushes are completed instead of dropped.

Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Co-developed-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Dennis Tsiang <dennis.tsiang@arm.com>
Signed-off-by: Karunika Choo <karunika.choo@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250807162633.3666310-6-karunika.choo@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a real bug that users can hit
- Dropped flush requests: In the current code, if a cache flush is
  already in progress, a second caller does not issue another flush and
  simply waits for the first one to complete. See the conditional in
  `drivers/gpu/drm/panthor/panthor_gpu.c:358` and command write at
  `drivers/gpu/drm/panthor/panthor_gpu.c:360`. When
  `GPU_IRQ_CLEAN_CACHES_COMPLETED` is set, the second call skips issuing
  `GPU_FLUSH_CACHES(...)` and only waits for the existing flush to
  finish. If new CPU writes requiring a flush occur between the first
  flush’s command and the second caller’s request, those writes are not
  covered by the first flush. The second caller returns success without
  a flush that includes its writes. This is a correctness/coherency bug.
- WARN indicates it was unintended: The code explicitly warns if a flush
  is requested while one is pending (`drm_WARN_ON(...)` at
  `drivers/gpu/drm/panthor/panthor_gpu.c:358`), which already signals
  that concurrent callers were expected to be serialized at a higher
  level. The fact this commit adds serialization in the driver indicates
  concurrency can and does happen in practice.

What the patch changes
- Adds a dedicated mutex to serialize flush callers:
  - New field `struct mutex cache_flush_lock` in `struct panthor_gpu`
    (struct currently starts at
    `drivers/gpu/drm/panthor/panthor_gpu.c:26`).
  - Initializes it in `panthor_gpu_init()` alongside existing locks/wq
    (near `drivers/gpu/drm/panthor/panthor_gpu.c:166` where
    `spin_lock_init()` and `init_waitqueue_head()` are done).
  - Wraps `panthor_gpu_flush_caches()` entry with
    `guard(mutex)(&ptdev->gpu->cache_flush_lock);`, ensuring only one
    caller issues a flush command and waits at a time (function starts
    at `drivers/gpu/drm/panthor/panthor_gpu.c:350`).
- Effectively guarantees that each flush request results in a hardware
  flush. Without the mutex, concurrent callers can “piggyback” on a
  previous flush and return without their own flush, losing the ordering
  guarantee they expect.

Scope and risk assessment
- Small and contained: One file touched
  (`drivers/gpu/drm/panthor/panthor_gpu.c`), adding a `struct mutex`
  field, its init, and a single guard in one function. No ABI, uAPI, or
  architectural changes.
- Minimal regression risk: The function already sleeps
  (`wait_event_timeout(...)` at
  `drivers/gpu/drm/panthor/panthor_gpu.c:365`), so adding a mutex
  doesn’t alter the sleepability requirements. The only in-tree caller
  is from the scheduler path
  (`drivers/gpu/drm/panthor/panthor_sched.c:2742`) under `sched->lock`,
  not IRQ/atomic context.
- Locking safety: The IRQ handler uses only the spinlock `reqs_lock`
  (see `drivers/gpu/drm/panthor/panthor_gpu.c:156`-
  `drivers/gpu/drm/panthor/panthor_gpu.c:167`) and doesn’t touch the new
  mutex, so there’s no new lock inversion with the interrupt path. The
  flush function’s existing spinlock section remains unchanged and still
  protects `pending_reqs`.
- Guard macro availability: This stable tree already uses `guard(mutex)`
  widely (for example in `virt/lib/irqbypass.c:102` et al.), so the new
  `guard(mutex)` in this driver is compatible. If needed for strict
  include hygiene, `#include <linux/cleanup.h>` can be added, but
  similar files compile without explicitly adding it.

User impact and stable policy fit
- Fixes a real concurrency/coherency bug affecting correctness: A later
  flush request can be silently dropped, potentially leading to stale
  data observed by the GPU and spurious faults or subtle rendering/data
  corruption. This clearly affects users under certain timing
  conditions.
- No new features or behavior changes beyond making the existing API
  reliable under concurrency.
- Minimal risk, localized change in a driver subsystem.
- Although the commit message doesn’t carry a “Fixes:” or “Cc:
  stable@...” tag, it is a straightforward bug fix that meets stable
  backport criteria.

Cross-checks in the tree
- Current implementation demonstrating the bug:
  - Conditional suppression of a second flush:
    `drivers/gpu/drm/panthor/panthor_gpu.c:358`
  - Single flush command write:
    `drivers/gpu/drm/panthor/panthor_gpu.c:360`
  - Wait and timeout handling (unchanged by the patch): `drivers/gpu/drm
    /panthor/panthor_gpu.c:365`-
    `drivers/gpu/drm/panthor/panthor_gpu.c:375`
- Only in-tree caller identified:
  `drivers/gpu/drm/panthor/panthor_sched.c:2742`, but concurrency can
  still arise across scheduler/reset/suspend sequences or multiple
  threads.

Conclusion
- This is an important correctness fix with low risk and a small diff,
  preventing flushed-from-under-you race conditions. It should be
  backported to stable.

 drivers/gpu/drm/panthor/panthor_gpu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/panthor/panthor_gpu.c b/drivers/gpu/drm/panthor/panthor_gpu.c
index cb7a335e07d7c..030409371037b 100644
--- a/drivers/gpu/drm/panthor/panthor_gpu.c
+++ b/drivers/gpu/drm/panthor/panthor_gpu.c
@@ -35,6 +35,9 @@ struct panthor_gpu {
 
 	/** @reqs_acked: GPU request wait queue. */
 	wait_queue_head_t reqs_acked;
+
+	/** @cache_flush_lock: Lock to serialize cache flushes */
+	struct mutex cache_flush_lock;
 };
 
 /**
@@ -204,6 +207,7 @@ int panthor_gpu_init(struct panthor_device *ptdev)
 
 	spin_lock_init(&gpu->reqs_lock);
 	init_waitqueue_head(&gpu->reqs_acked);
+	mutex_init(&gpu->cache_flush_lock);
 	ptdev->gpu = gpu;
 	panthor_gpu_init_info(ptdev);
 
@@ -353,6 +357,9 @@ int panthor_gpu_flush_caches(struct panthor_device *ptdev,
 	bool timedout = false;
 	unsigned long flags;
 
+	/* Serialize cache flush operations. */
+	guard(mutex)(&ptdev->gpu->cache_flush_lock);
+
 	spin_lock_irqsave(&ptdev->gpu->reqs_lock, flags);
 	if (!drm_WARN_ON(&ptdev->base,
 			 ptdev->gpu->pending_reqs & GPU_IRQ_CLEAN_CACHES_COMPLETED)) {
-- 
2.51.0

