Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64CD34A015E;
	Mon, 31 Aug 2026 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183682; cv=none; b=h4AppXIro0R1+0aOEoTP5u+muGN9x6DV9/wro/bK4j1t2T8Yc/R8bbFaRgcMHzeVU92u9PhhTtuyE0apbPBlE60FJJVyBOXfJudcuVAZPQ0OK5WHZ0XkUKptg/vcem3Uh8B/5RT3ESNd0zOKNm5D47Nv3AHwO1LlD7WRsN08Hwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183682; c=relaxed/simple;
	bh=gMV3plt5lRkLAfiFUxjjzTiY7VOmR+ppSHPAerh0wmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eQFogVGA0lzD2kjlji6dEe2SSxHMo7/aBB1VnaMMi7vekf3oxWjz1QLzMdixrTUOx1czGUzH0oQpwUcrWNlWqj48oDippTMVRIglwbNvrob1uD/ZhjGP+aX1k0DKyQnJpqT82PYL318YmPI7nBtBUqvceiuwPHzDqtw6Wq7ZXAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaUXyegc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaUXyegc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7282D1F00A3E;
	Mon, 31 Aug 2026 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183679;
	bh=0EYoE+iucVhU+9I9SD8X8rbvJ6Xg9Z+L6r01HOtL3/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZaUXyegcmCbH1FdnmJLs+DaYjfT+TbcZG0BPJGENIPPHQkQow39MvGwwWo4qKugHb
	 N+xJTmDeUGK5WL03g7Gz8kuX/c+X7KeP7MRUN5JoA5OR8RdnmfGAlwLg+Zwhr77XOd
	 bBj+lZUlG9RlofH//s6teNGV1ZRLqd3uCZ4z71eoB6i9dYjJkuU0ctA3LMtk/84ipP
	 8jh64vnFMT3KVmTVn//vNIRa/bTd2JPdHHMmU8Ls0TeL+WVuxwU0ku3KZuSGqo9CGX
	 ASn0Z1VtWmFmYTBkxuTUoNXVO6Yu0MZjtbngur5mT2KvTH4jzzQIyOrQ/NYmUVhLM2
	 c0ZprL33f8cDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>,
	Sasha Levin <sashal@kernel.org>,
	alessio.belle@imgtec.com,
	luigi.santivetti@imgtec.com,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	imagination@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/imagination: Don't timeout job if its fence has been signaled
Date: Mon, 31 Aug 2026 09:24:27 -0400
Message-ID: <20260831133314.4125787-239-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Brajesh Gupta <brajesh.gupta@imgtec.com>

[ Upstream commit ee7cb742531432ec1bb29b996e3363aacd860054 ]

Verify the job’s fence in the timeout handler; if the firmware has since
signaled completion, then report NO HANG.

Signed-off-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Reviewed-by: Matt Coster <matt.coster@imgtec.com>
Link: https://patch.msgid.link/20260519-b4-context_reset-v2-2-931018a7131d@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/imagination: Don't timeout job if its
fence has been signaled

**Local tree:** `v6.18.43` (`6.18.43`, Makefile VERSION=6 PATCHLEVEL=18
SUBLEVEL=43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[drm/imagination]` `[Don't]` (preventive fix) — Don't treat
a completed job as a GPU hang when its fence has already been signaled.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Signed-off-by:** Brajesh Gupta \<brajesh.gupta@imgtec.com\> (author)
- **Reviewed-by:** Matt Coster \<matt.coster@imgtec.com\> (IMG reviewer)
- **Link:** https://patch.msgid.link/20260519-b4-context_reset-v2-2-
  931018a7131d@imgtec.com (patch 2 of a `context_reset` v2 series)
- **Signed-off-by:** Matt Coster \<matt.coster@imgtec.com\>
- No Fixes:, Reported-by:, Tested-by:, Acked-by:, or Cc: stable tags
- Notable: Reviewed-by from driver vendor; no syzbot/user bug report
  tags

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** The timeout handler does not verify whether the
  job's fence was already signaled before treating the event as a hang.
- **Symptom/failure mode:** Spurious "Job timeout" handling and
  unnecessary scheduler reset even though the firmware already completed
  the job.
- **Version information:** None stated.
- **Root cause:** Race between job completion (fence signaled) and the
  drm_sched timeout worker running before the free-job worker cleans up
  the completed job.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Yes — despite the subject not using "fix", this is a real
bug fix. It prevents false-positive GPU hang recovery, matching the
established pattern used by panfrost, etnaviv, v3d, and xe drivers.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/gpu/drm/imagination/pvr_queue.c` (+5 lines,
  comment update)
- **Functions modified:** `pvr_queue_timedout_job()`
- **Scope:** Single-file surgical fix in timeout error path

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (early return):** BEFORE: timeout handler always proceeds to
  `dev_err`, `drm_sched_stop()`, fence reassignment, and scheduler
  restart. AFTER: if `s_job->s_fence->parent` is already signaled,
  return `DRM_GPU_SCHED_STAT_NO_HANG` immediately and skip all reset
  logic.
- **Hunk 2 (comment):** Documents the new possible return value.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** Race condition / logic correctness in timeout
  handler
- **Mechanism:** `pvr_queue_run_job()` returns `job->done_fence` as the
  sched fence parent. When the GPU completes the job, that fence is
  signaled. If the drm_sched timeout fires before the free-job worker
  runs, the old code incorrectly enters full hang-recovery:
  `drm_sched_stop()`, queue list manipulation, parent-fence
  reassignment, and potentially `atomic_set(&queue->ctx->faulty, 1)` for
  other pending jobs. The fix detects completion and returns
  `DRM_GPU_SCHED_STAT_NO_HANG`, which causes
  `drm_sched_job_reinsert_on_false_timeout()` in the scheduler core to
  properly reinsert the job for cleanup.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Fix quality:** Obviously correct; identical pattern to panfrost
  (`dma_fence_is_signaled` → `DRM_GPU_SCHED_STAT_NO_HANG`).
- **Regression risk:** Very low. Only affects the spurious-timeout path;
  real hangs still proceed to reset. Must not call `drm_sched_stop()`
  when returning `NO_HANG` — the fix correctly returns before that call,
  per scheduler documentation.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `pvr_queue_timedout_job()` introduced in `eaf01ee5ba28b`
(Sarah Walker, 2023-11-22, "drm/imagination: Implement job submission
and scheduling"). The missing fence check has been present since driver
inception. Confirmed ancestor of HEAD.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Recent `pvr_queue.c` changes include fence/dependency fixes
(`943fa73ea0efa`, `68c3de7f707e8`, `df1a1ed5e1bdd`) but none address
this timeout race. The `DRM_GPU_SCHED_STAT_NO_HANG` infrastructure was
added earlier (`0b1217bfdfddf`) and adopted by panfrost, xe, etnaviv,
v3d — imagination was never updated. Standalone fix, not part of an
applied series in this tree.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Brajesh Gupta has two imagination commits in this tree:
`c88fdbf3da26e` (double `drm_sched_entity_fini` fix) and `902fd1026ca42`
(FW trace wait). Regular IMG contributor, not subsystem maintainer.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** Link suggests patch 2 of `context_reset-v2` series, but the
diff is self-contained — no new structures, APIs, or prior-patch
symbols. Uses only existing `dma_fence_is_signaled()` and
`DRM_GPU_SCHED_STAT_NO_HANG`. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:** `b4 dig -c` failed (commit not in this tree). `b4 shazam`
did not find the message. WebFetch of lore.kernel.org and
patch.msgid.link blocked by Anubis bot protection. Link tag indicates
submission as patch 2 of `context_reset-v2` series to dri-devel, with
Reviewed-by from IMG engineer.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** Reviewed-by: Matt Coster (IMG). Full recipient list
unavailable due to lore access failure.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No Reported-by or bugzilla/syzbot links. Bug mechanism is
well-established from identical panfrost/etnaviv fixes with explicit
comments about "timeout fired before free-job worker."

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Part of `context_reset-v2` series (patch 2 per message-id).
This specific change is independent — only adds an early-return guard in
`pvr_queue_timedout_job()`.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Could not search lore stable list (bot protection). No
stable nomination found in commit tags.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `pvr_queue_timedout_job()` (modified), called via
`pvr_queue_sched_ops.timedout_job`.

### Step 5.2: TRACE CALLERS
**Record:** `pvr_queue_timedout_job` → registered in
`pvr_queue_sched_ops` → called from `drm_sched_job_timedout()` work item
when scheduler timeout fires on a pending job. Triggered during normal
GPU rendering under load or slow interrupt handling.

### Step 5.3: TRACE CALLEES
**Record:** Without fix: `dev_err`, `mutex_lock`, `list_del_init`,
`drm_sched_stop`, fence reassignment loop, `drm_sched_start`. With fix:
only `dma_fence_is_signaled()` then early return.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Userspace Mesa/OpenGL/Vulkan → DRM ioctl job submission →
`pvr_queue_job_init/push` → drm_sched → `pvr_queue_run_job` → firmware →
fence signal → (race) timeout worker. Reachable from normal graphics
workloads on PowerVR/IMG hardware.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** Identical pattern in:
- `panfrost_job_timedout()` — checks `job->done_fence`, returns
  `NO_HANG` with comment "timeout has fired before free-job worker"
- `etnaviv_sched_timedout_job()` — same comment and pattern
- `v3d`, `xe` — also use `DRM_GPU_SCHED_STAT_NO_HANG`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** YES. `pvr_queue_timedout_job()` at line 824 in
`drivers/gpu/drm/imagination/pvr_queue.c` lacks the fence check and
proceeds directly to `dev_err("Job timeout")` and reset logic. Driver
present since `eaf01ee5ba28b` (Nov 2023).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected clean apply — 5 lines added at function entry,
comment update. No conflicting recent changes to this function.
`DRM_GPU_SCHED_STAT_NO_HANG` and
`drm_sched_job_reinsert_on_false_timeout()` exist in this tree's
scheduler.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No equivalent fix present. `git log --grep` found no "Don't
timeout job" commit. Panfrost/etnaviv/v3d/xe already have this pattern;
imagination does not.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/gpu/drm/imagination/` — DRM GPU driver
(CONFIG_DRM_POWERVR). **IMPORTANT** for users with Imagination
PowerVR/IMG GPUs on ARM64/RISC-V; not universal but critical for those
platforms.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively developed — recent commits include fence dependency
fixes, paired-job handling, and `drm_sched_entity_fini` double-call fix.
Mature enough for real hardware deployments.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users with `CONFIG_DRM_POWERVR` on ARM64 or RISC-V systems
with Imagination GPUs. Driver-specific but affects all GPU workloads on
that hardware.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Job completes and fence is signaled, but drm_sched timeout
fires before the free-job worker processes it. Can occur under IRQ
latency, system load, or near-timeout job durations. Triggerable during
normal rendering; no special privileges needed beyond GPU access.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** Without fix: spurious hang recovery — unnecessary
`drm_sched_stop()`/`drm_sched_start()`, erroneous "Job timeout" log,
potential `atomic_set(&queue->ctx->faulty, 1)` marking context
permanently unusable (blocks all future job submission via
`pvr_queue_job_init` returning `-EIO`). **Severity: HIGH** — can break
GPU rendering until process/driver restart.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH for affected hardware — prevents spurious GPU resets
  and permanent context faulting
- **Risk:** VERY LOW — 5-line early return, proven pattern across
  multiple DRM drivers
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real race causing spurious GPU hang recovery
- Can permanently fault a GPU context (`ctx->faulty`), breaking all
  subsequent rendering
- Small, surgical, obviously correct fix
- Identical pattern already in panfrost, etnaviv, v3d, xe in this tree
- Bug present since imagination driver's initial scheduling code (2023)
- Reviewed-by from IMG engineer
- `DRM_GPU_SCHED_STAT_NO_HANG` infrastructure already in 6.18.43
- Applies cleanly to this tree

**AGAINST backporting:**
- Limited to Imagination GPU users (smaller population)
- No explicit user bug report or syzbot finding in commit message
- Part of a larger series (though this patch is standalone)

**UNRESOLVED:**
- Full lore review thread inaccessible (Anubis bot protection)
- Whether patch 1 of `context_reset-v2` series is also needed for stable
  (this patch appears independent)

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches proven
   panfrost/etnaviv pattern; Reviewed-by present
2. Fixes a real bug affecting users? **PASS** — spurious timeout on
   completed jobs
3. Important issue? **PASS** — spurious GPU reset, context permanent
   fault, rendering failure (HIGH)
4. Small and contained? **PASS** — 5 lines, 1 file, 1 function
5. No new features or APIs? **PASS** — uses existing
   `DRM_GPU_SCHED_STAT_NO_HANG`
6. Can apply to the local tree? **PASS** — buggy code present,
   infrastructure exists, clean apply expected

### Step 9.3: EXCEPTION CATEGORIES
**Record:** None (not device ID, quirk, DT, build fix, or docs).
Standard driver bug fix.

### Step 9.4: DECISION RATIONALE

This commit fixes a well-understood race in the drm_sched timeout path
that the imagination driver has had since its introduction. Without the
fix, a completed job can trigger full hang-recovery logic including
scheduler stop/start and potentially marking the GPU context as
permanently faulty — a serious, user-visible failure for anyone running
graphics on PowerVR/IMG hardware. The fix is minimal, follows an
established pattern already present in four other DRM drivers in this
tree, and applies cleanly to the 6.18.43 checkout where the buggy code
is confirmed present.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified preventive timeout
  fix
- [Phase 1] No Fixes:/Reported-by:/syzbot tags; Reviewed-by: Matt Coster
  present
- [Phase 2] Diff: +5 lines in `pvr_queue_timedout_job()`, early
  `dma_fence_is_signaled` check
- [Phase 2] Read `drm_sched_job_timedout()` — `NO_HANG` triggers
  `drm_sched_job_reinsert_on_false_timeout()`
- [Phase 2] Read scheduler doc: must NOT call `drm_sched_stop()` when
  returning `NO_HANG`
- [Phase 3] `git blame`: `pvr_queue_timedout_job` from `eaf01ee5ba28b`
  (2023-11-22)
- [Phase 3] `git merge-base --is-ancestor`: driver commit is ancestor of
  HEAD
- [Phase 3] `git log -20 -- pvr_queue.c`: no prior timeout-fence fix
- [Phase 3] Author commits: `c88fdbf3da26e`, `902fd1026ca42` in
  imagination driver
- [Phase 4] `b4 dig -c`: failed (commit not in tree)
- [Phase 4] `b4 shazam`: message not found on lore
- [Phase 4] WebFetch lore.kernel.org: blocked by Anubis
- [Phase 4] WebFetch patch.msgid.link: blocked by Anubis
- [Phase 5] `pvr_queue_timedout_job` registered at
  `pvr_queue_sched_ops.timedout_job` line 895
- [Phase 5] `pvr_queue_run_job` returns `dma_fence_get(job->done_fence)`
  as sched parent
- [Phase 5] panfrost/etnaviv: identical `dma_fence_is_signaled` →
  `NO_HANG` pattern confirmed
- [Phase 6] `git describe HEAD`: v6.18.43
- [Phase 6] Buggy code confirmed at lines 824-872 without fence check
- [Phase 6] `DRM_GPU_SCHED_STAT_NO_HANG` exists in
  `include/drm/gpu_scheduler.h`
- [Phase 6] `drm_sched_job_reinsert_on_false_timeout` exists in
  `sched_main.c`
- [Phase 7] CONFIG_DRM_POWERVR depends on ARM64 or RISC-V 64-bit
- [Phase 8] `pvr_context.h`: `faulty` flag makes context permanently
  unusable
- [Phase 8] `pvr_queue_job_init` line 1108: returns `-EIO` if
  `ctx->faulty` is set
- [Phase 8] Without fix: `pvr_queue_start` sets `ctx->faulty` for
  unfinished pending jobs during reset

**YES**Those background lookups are done and line up with the earlier
analysis:

- **Commit search / b4 dig:** The patch isn’t in this `v6.18.43` tree
  yet, so `git log --grep` and `b4 dig -c` couldn’t resolve it by hash.
- **Related history:** `pvr_queue_timedout_job()` dates to the original
  imagination scheduling commit (`eaf01ee5ba28b`, Nov 2023); recent
  nearby fixes are fence/dependency work, not this timeout race.
- **Prior art:** `DRM_GPU_SCHED_STAT_NO_HANG` is already used the same
  way in panfrost, xe, etnaviv, and v3d in this tree; imagination is the
  outlier.
- **Author context:** Brajesh Gupta has two other imagination fixes here
  (`drm_sched_entity_fini` double-call, FW trace wait).

That reinforces the earlier call: small, standalone fix for a real
spurious-timeout bug on PowerVR/IMG hardware.

**YES**

 drivers/gpu/drm/imagination/pvr_queue.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_queue.c b/drivers/gpu/drm/imagination/pvr_queue.c
index bb5835ede6660..7497bca2e7e83 100644
--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -818,7 +818,9 @@ static void pvr_queue_start(struct pvr_queue *queue)
  * the scheduler, and re-assign parent fences in the middle.
  *
  * Return:
- *  * DRM_GPU_SCHED_STAT_RESET.
+ *  *%DRM_GPU_SCHED_STAT_NO_HANG if the job fence has already been
+ *   signaled, or
+ *  *%DRM_GPU_SCHED_STAT_RESET otherwise.
  */
 static enum drm_gpu_sched_stat
 pvr_queue_timedout_job(struct drm_sched_job *s_job)
@@ -829,6 +831,9 @@ pvr_queue_timedout_job(struct drm_sched_job *s_job)
 	struct pvr_job *job;
 	u32 job_count = 0;
 
+	if (dma_fence_is_signaled(s_job->s_fence->parent))
+		return DRM_GPU_SCHED_STAT_NO_HANG;
+
 	dev_err(sched->dev, "Job timeout\n");
 
 	/* Before we stop the scheduler, make sure the queue is out of any list, so
-- 
2.53.0

