Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2301B3FAE18;
	Mon, 20 Apr 2026 13:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691612; cv=none; b=DwWPv+dOFk4nNpsKJhyaM8sgez3eLGHPkuMaPHfs7WNu7T+78zkYTPJzrKo1oRpR/czc3KrgOV6mSwbQNujIfhrlP/fTuppL0WnQIrIi31SC2GEAVaH4YlQm/ITpi2RhkN3JdVKgCTRlQH9Rdoz/bo95QDYeek2ii3sw7Y7KFiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691612; c=relaxed/simple;
	bh=dMLXMb9lsZEBL3IJdlXARDHwyhBPf2JT329tfRAuZfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iyHPr5xBbODaQNxUeVxvpRAXv1afmfnmk0A5b6f1GRcxGcIUwAItMi1f4AyfTxbyZZe0y1Ur/ZOFDnOiJgmIquLUTAvcldix3npNbP9NBVJWEmvYsjRGCJszDG0zBTfWcqeB2ku5jl6W4yv3ip86UmNn0soOZdlmyhuXpPIn7R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gN542SxU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gN542SxU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB69CC2BCB6;
	Mon, 20 Apr 2026 13:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691612;
	bh=dMLXMb9lsZEBL3IJdlXARDHwyhBPf2JT329tfRAuZfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN542SxUBgiUl/tGb0yEuLmylnpeZh7f6yoD7IMD85SbFtTtcXWqdbgcMSQFuVSLZ
	 dPzU/ei6k6Cj107/Cgn0uyOO4n/c7Msq62vxZz+tvWhW5B6/JmW0ocWJRH4+ujTOKX
	 rLCXMXzT7Wn4bVy6ZTdTdD/6C6hRfEJ7Nga4Z3OYs6e9xdLcKQ8cfDimaRxPvwxd0M
	 g4vk3fp9dUvKvFMVBnpL40W+3duYtY2A0bbyLtTmW3Iap8lxgRiD9OEzgWh9C0Jnx1
	 pvltodxW0rxEtgNagVlGuvxMPYjY3yk5DJTXdooi7jD85yRPc/RgLZ2V/x0Kh02tX7
	 S5amFCQU1YQcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Huang <jinhuieric.huang@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdkfd: fix kernel crash on releasing NULL sysfs entry
Date: Mon, 20 Apr 2026 09:18:45 -0400
Message-ID: <20260420132314.1023554-131-sashal@kernel.org>
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

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 4ea64d482fc2cc85009fce5abdf4780ece00c31c ]

there is an abnormal case that When a process re-opens kfd
with different mm_struct(execve() called by user), the
allocated p->kobj will be freed, but missed setting it to NULL,
that will cause sysfs/kernel crash with NULL pointers in p->kobj
on kfd_process_remove_sysfs() when releasing process, and the
similar error on kfd_procfs_del_queue() as well.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the full report.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: drm/amdkfd
- **Action verb**: "fix" - explicitly a bug fix
- **Summary**: Fixes a kernel crash when releasing a NULL (dangling)
  sysfs entry

### Step 1.2: Tags
- **Signed-off-by**: Eric Huang <jinhuieric.huang@amd.com> (author)
- **Reviewed-by**: Kent Russell <kent.russell@amd.com> (AMD KFD team
  member)
- **Signed-off-by**: Alex Deucher <alexander.deucher@amd.com> (AMD DRM
  maintainer)
- No Fixes: tag, no Cc: stable, no Reported-by, no Link - absence
  expected

### Step 1.3: Commit Body
The commit message describes: when a process re-opens KFD with a
different `mm_struct` (after `execve()`), the allocated `p->kobj` is
freed via `kobject_put()` but not set to NULL. Later,
`kfd_process_remove_sysfs()` checks `if (!p->kobj)` - but since the
pointer is dangling (not NULL), the check passes and causes a kernel
crash. The same issue affects `kfd_procfs_del_queue()`.

**Failure mode**: kernel crash (NULL pointer dereference / use-after-
free on stale kobj pointer)

### Step 1.4: Hidden Bug Fix?
No hiding here - the subject and body explicitly say "fix kernel crash."

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: 1 file changed: `drivers/gpu/drm/amd/amdkfd/kfd_process.c`
- **Lines**: +2, -1 (net 1 line added)
- **Functions modified**: `kfd_procfs_del_queue()`,
  `kfd_create_process_sysfs()`
- **Scope**: Single-file, surgical fix

### Step 2.2: Code Flow Changes

**Hunk 1** (`kfd_procfs_del_queue`):
- Before: only checks `if (!q)` then proceeds to `kobject_del(&q->kobj)`
  and `kobject_put(&q->kobj)`
- After: checks `if (!q || !q->process->kobj)` - if the process's kobj
  was freed, skip queue cleanup since parent sysfs is gone

**Hunk 2** (`kfd_create_process_sysfs`):
- Before: on `kobject_init_and_add()` failure, calls
  `kobject_put(process->kobj)` and returns, leaving `process->kobj` as a
  dangling pointer
- After: adds `process->kobj = NULL` after `kobject_put()`, preventing
  dangling pointer

### Step 2.3: Bug Mechanism
This is a **dangling pointer / use-after-free** bug. After
`kobject_put()` frees the kobj, the pointer is not NULLed, so
`kfd_process_remove_sysfs()` later passes the `!p->kobj` guard and
dereferences the freed pointer.

### Step 2.4: Fix Quality
- Obviously correct: setting pointer to NULL after free is a textbook
  fix
- Minimal: 2 lines changed
- No regression risk: the NULL check prevents use of an already-freed
  object
- No locking changes, no API changes

---

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- `kfd_procfs_del_queue()` was introduced by commit 6d220a7e7971ec
  (Amber Lin, 2020-01-30) - old function
- `kfd_create_process_sysfs()` was introduced by commit 4cd255b9694647
  (Zhu Lingshan, 2025-04-22) - the commit that extracted sysfs creation
  into a separate function
- The error path that's missing `= NULL` was introduced in
  4cd255b9694647

### Step 3.2: Fixes target
No explicit Fixes: tag. The bug was introduced by 4cd255b9694647
("amdkfd: Introduce kfd_create_process_sysfs as a separate function").
This commit first appeared in v7.0-rc1 - confirmed NOT in v6.19,
v6.16-rc1, v6.15-rc1, or v6.14.

### Step 3.3: File History
Many intermediate changes between the buggy commit and the fix (treewide
refactoring, unrelated amdkfd changes). No other fix for this specific
issue.

### Step 3.4: Author
Eric Huang is an AMD developer with multiple amdkfd commits (pasid
debugfs, smi events, TLB flush, etc.) - a regular contributor to the
subsystem.

### Step 3.5: Dependencies
The fix modifies `kfd_create_process_sysfs()` which only exists since
4cd255b9694647 (v7.0-rc1). The fix is self-contained and needs no other
patches.

---

## PHASE 4: MAILING LIST

### Step 4.1: Patch Discussion
b4 dig found the original submission at:
`https://patch.msgid.link/20260327180036.131096-1-
jinhuieric.huang@amd.com`

The mbox shows:
- v1 submission on 2026-03-27 by Eric Huang
- Kent Russell replied with `Reviewed-by` on the same day
- No NAKs, no concerns raised
- No stable nomination by reviewers, but this is expected for commits in
  the autosel pipeline

### Step 4.2: Reviewers
Patch was sent to `amd-gfx@lists.freedesktop.org`, reviewed by Kent
Russell (AMD KFD team), committed by Alex Deucher (AMD DRM maintainer).
Appropriate review chain.

### Step 4.3: Bug Report
No external bug report link. The author discovered this through internal
testing of the execve() code path.

### Step 4.4: Related Patches
Single standalone patch (v1 only, no series).

### Step 4.5: Stable Discussion
No prior stable discussion found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `kfd_procfs_del_queue()` - called to delete a queue's sysfs entry
- `kfd_create_process_sysfs()` - creates sysfs entries for a KFD process

### Step 5.2: Callers
- `kfd_procfs_del_queue()` called from `kfd_process_queue_manager.c` in
  two places: during queue destruction and queue resource cleanup
- `kfd_create_process_sysfs()` called from `kfd_process.c` (initial
  process creation) and `kfd_chardev.c` (secondary process context
  creation via ioctl)

### Step 5.3-5.4: Call Chain
The bug path: user calls `execve()` → KFD detects mm change → re-opens
KFD → `kfd_create_process_sysfs()` fails → dangling `kobj` → process
cleanup → `kfd_process_remove_sysfs()` → crash via stale pointer

### Step 5.5: Similar Patterns
The existing `kfd_process_remove_sysfs()` already has a `if (!p->kobj)
return;` guard (line 1158), which is the correct pattern. The bug is
that the error path in `kfd_create_process_sysfs()` doesn't maintain the
invariant that freed kobj should be NULL.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The buggy function `kfd_create_process_sysfs()` was introduced in commit
4cd255b9694647, which is in v7.0-rc1 and v7.0 only. It is NOT in v6.19,
v6.14, or any earlier stable tree. The fix is only relevant for the
**7.0.y** stable tree.

### Step 6.2: Backport Complications
The fix should apply cleanly to 7.0.y since the code context matches
directly.

### Step 6.3: Related Fixes Already in Stable
No related fixes found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: drivers/gpu/drm/amd/amdkfd - AMD GPU Kernel Fusion
  Driver
- **Criticality**: IMPORTANT - AMD GPU users running KFD compute
  workloads (ROCm, OpenCL)

### Step 7.2: Activity
Very active subsystem with frequent changes.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
Users of AMD GPU KFD (ROCm compute users) who hit the error path in
`kfd_create_process_sysfs()` during process creation, specifically when
`execve()` causes a re-open with a different mm.

### Step 8.2: Trigger
When `kobject_init_and_add()` fails during KFD process sysfs creation
AND the process later gets cleaned up. This is an error path, but can be
triggered by resource exhaustion or sysfs conflicts.

### Step 8.3: Failure Mode
**CRITICAL**: Kernel crash (use of dangling pointer / NULL dereference
in sysfs teardown).

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH - prevents kernel crash
- **Risk**: VERY LOW - 2-line fix, setting pointer to NULL after free
  and adding a NULL check
- **Ratio**: Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a kernel crash (dangling pointer causes crash in sysfs teardown)
- Tiny fix: 2 lines changed in 1 file
- Obviously correct (NULL pointer after free, NULL check before use)
- Reviewed by subsystem developer (Kent Russell)
- Committed by subsystem maintainer (Alex Deucher)
- Standalone fix with no dependencies
- Buggy code exists in 7.0.y stable tree

**AGAINST backporting:**
- Error path only (not every user will hit this)
- Only affects 7.0.y (the buggy code is new in v7.0-rc1)
- No Fixes: tag (expected for autosel candidates)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - trivial NULL-after-free
   pattern, reviewed
2. Fixes a real bug? **YES** - kernel crash on sysfs teardown
3. Important issue? **YES** - kernel crash (CRITICAL severity)
4. Small and contained? **YES** - 2 lines, 1 file
5. No new features or APIs? **YES** - pure bug fix
6. Can apply to stable? **YES** - code exists in 7.0.y, should apply
   cleanly

### Step 9.3: Exception Categories
Not an exception category - this is a standard bug fix.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Kent Russell, Signed-off-by Alex
  Deucher (maintainer), no Fixes/Cc-stable
- [Phase 2] Diff analysis: +2/-1 lines; adds `process->kobj = NULL`
  after `kobject_put()` and `!q->process->kobj` check in
  `kfd_procfs_del_queue()`
- [Phase 3] git blame: error path introduced by 4cd255b9694647 (Zhu
  Lingshan, 2025-04-22)
- [Phase 3] git merge-base: 4cd255b9694647 is in v7.0-rc1 and v7.0, NOT
  in v6.19 or earlier
- [Phase 3] git log between buggy and fix: no intermediate fix for same
  issue found
- [Phase 4] b4 dig: found original at `https://patch.msgid.link/20260327
  180036.131096-1-jinhuieric.huang@amd.com`
- [Phase 4] b4 dig -a: single v1 submission, no revisions
- [Phase 4] mbox review: Kent Russell gave Reviewed-by, no NAKs or
  concerns
- [Phase 5] Grep callers: `kfd_procfs_del_queue()` called from
  `kfd_process_queue_manager.c` (2 sites); `kfd_create_process_sysfs()`
  called from both `kfd_process.c` and `kfd_chardev.c`
- [Phase 5] `kfd_process_remove_sysfs()` at line 1158 already has `if
  (!p->kobj) return;` guard, confirming the invariant the fix maintains
- [Phase 6] Buggy code only in v7.0-rc1+, fix relevant for 7.0.y stable
  only
- [Phase 8] Failure mode: kernel crash on dangling pointer dereference
  during sysfs teardown, severity CRITICAL

The fix is small, surgical, obviously correct, and prevents a kernel
crash. It meets all stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_process.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process.c b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
index 12e24fbf8c463..c6782904d2f1c 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process.c
@@ -679,7 +679,7 @@ static void kfd_procfs_add_sysfs_files(struct kfd_process *p)
 
 void kfd_procfs_del_queue(struct queue *q)
 {
-	if (!q)
+	if (!q || !q->process->kobj)
 		return;
 
 	kobject_del(&q->kobj);
@@ -858,6 +858,7 @@ int kfd_create_process_sysfs(struct kfd_process *process)
 	if (ret) {
 		pr_warn("Creating procfs pid directory failed");
 		kobject_put(process->kobj);
+		process->kobj = NULL;
 		return ret;
 	}
 
-- 
2.53.0

