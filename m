Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFF855C304;
	Mon, 31 Aug 2026 13:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184029; cv=none; b=WZ0rHRFtmvnLBWjbqqZ2Fh1m4ZWN6yQ2KrYwp88QoCejCUq0Nh4PbrjndLZiMGGDy7lWScZn8d9h87Gkg405aKlr5N5eCaLwAmTYi6tiyCIwHvDO+lF7ukmeQdXX5Zf/vpBwNigv+dZvN8QPDVqchFRILGF6seOOPDXcou7JczE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184029; c=relaxed/simple;
	bh=0SBJj+94/IIrBjTN447h/e88FTDDCZISgzXML3hCR/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XCU0K9SoQ08o8Shsh6Xqxx6qj0F5wvg6arc5y7eesZ1EHwp25n2Gs8Oel9gI03o8oYx1ZvQkrLae0eVrcfzwu160eJ+Ze8U5wlRguYuvn6IDAoSo0p9Mx4+PRj0sHn1nA8cXeDSRWMdzOdeW/OR0tJgcUpf192c4i92lPL7LiLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFHRGN7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFHRGN7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58EFE1F00ADB;
	Mon, 31 Aug 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184026;
	bh=JC+LdObHYChlN/X+C+HSrZCgmLDlu+X4i/jklFPJIMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFHRGN7OoCqW+0gP91emMEFKaBFwWBaZOat67U7Ok7vQaZaoX3H6A3wqJThv87RcT
	 lOgeC3GFP6EqHE/2sRjYAbBtBjr4+MvVUtR/t/bKYr+ygG9J7Wy1fPbYhqFSpiTfNK
	 Fn2IjHc/PFEltu+i3dg1qkE74uwZdOkowtbN+tqweGSpQZzuNsHhoWYowdgGbL4kv7
	 Rj4+kZG1zjDC8Q/zbSeuFpno5TLjlMdK5pvTutEg0qrjmaRiFqokeKr1E/s3DaCTfA
	 bP7BY7IqnICB7b3Mi9X+H1/Jqxl2kh2YhJUBrBbh2PvYkortbXzwtyVbMfl8m6asFo
	 79CjRFaG1s9uQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alysa Liu <Alysa.Liu@amd.com>,
	Amir Shetaia <Amir.Shetaia@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amdkfd: fix UAF race in destroy_queue_cpsch
Date: Mon, 31 Aug 2026 09:27:54 -0400
Message-ID: <20260831133314.4125787-446-sashal@kernel.org>
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

From: Alysa Liu <Alysa.Liu@amd.com>

[ Upstream commit ac081deaf16a639ea7dff2f285fe421a33c1ade0 ]

wait_on_destroy_queue() drops locks to wait for queue resume, allowing
a concurrent destroy to free the queue. Use is_being_destroyed flag to
serialize destruction.

Reviewed-by: Amir Shetaia <Amir.Shetaia@amd.com>
Signed-off-by: Alysa Liu <Alysa.Liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[drm/amdkfd]` `[fix]` — UAF race in `destroy_queue_cpsch`
during concurrent queue destruction.

### Step 1.2: Commit Message Tags
**Record:**
- **Reviewed-by:** Amir Shetaia \<Amir.Shetaia@amd.com\> (AMD reviewer)
- **Signed-off-by:** Alysa Liu \<Alysa.Liu@amd.com\> (author)
- **Signed-off-by:** Alex Deucher \<alexander.deucher@amd.com\> (DRM/AMD
  maintainer)
- **Absent (expected):** Fixes:, Reported-by:, Link:, Tested-by:, Cc:
  stable@vger.kernel.org

Notable: maintainer sign-off and subsystem reviewer present; no syzbot
or user bug report.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `wait_on_destroy_queue()` drops `dqm` lock and process mutex
  while waiting for a suspended queue to resume. A concurrent destroy
  can complete and free the queue while the first caller still holds a
  pointer to it.
- **Symptom:** Use-after-free when the first destroy path resumes after
  the wait.
- **Root cause:** No serialization of concurrent destruction;
  `is_being_destroyed` was set but not checked at entry; not cleared on
  error paths.
- **Fix:** Check `is_being_destroyed` and return `-EBUSY` for concurrent
  destroyers; clear the flag on wait failure and on the debug-queue
  error path.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly labeled UAF race. The
`failed_try_destroy_debugged_queue` cleanup also fixes a stuck-flag bug
(queue permanently marked as being destroyed after `-EBUSY`).

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c` (+6
  lines net)
- **Functions:** `wait_on_destroy_queue()`, `destroy_queue_cpsch()`
  error path
- **Scope:** Single-file, surgical fix (3 small hunks)

### Step 2.2: Code Flow Changes
**Record:**
- **Hunk 1 (wait_on_destroy_queue entry):** Before → unconditionally set
  `is_being_destroyed = true`. After → if already set, return `-EBUSY`
  immediately (serialize concurrent destroys).
- **Hunk 2 (wait_on_destroy_queue exit):** Before → on
  `wait_event_interruptible()` failure (signal), flag stayed true
  forever. After → clear `is_being_destroyed` on non-zero `ret` so
  destroy can be retried.
- **Hunk 3 (failed_try_destroy_debugged_queue):** Before → returned
  `-EBUSY` for debug queues but left `is_being_destroyed = true`. After
  → clears flag before unlock/return.

### Step 2.3: Bug Mechanism
**Record:** **Category:** Use-after-free / race condition (reference-
counting-like serialization via flag).

**Mechanism verified in code:**
1. `kfd_ioctl_destroy_queue()` holds `p->mutex`.
2. `destroy_queue_cpsch()` → `dqm_lock()` → `wait_on_destroy_queue()`.
3. When `debug_trap_enabled && is_suspended`, `wait_on_destroy_queue()`
   calls `dqm_unlock()`, `mutex_unlock(&q->process->mutex)`, then blocks
   on `wait_event_interruptible(dqm->destroy_wait,
   !q->properties.is_suspended)`.
4. With mutex released, a second thread can enter
   `kfd_ioctl_destroy_queue()` for the same queue.
5. Without the fix, the second thread proceeds through destruction;
   `pqm_destroy_queue()` calls `uninit_queue()` and frees resources.
6. First thread wakes and continues using freed `struct queue` → UAF.

The `is_being_destroyed` flag was already used in
`suspend_single_queue()` (line 1075) to block suspend during destroy,
but was never checked at the destroy entry point.

### Step 2.4: Fix Quality
**Record:** Fix is minimal and obviously correct — standard serialize-
with-flag pattern. Low regression risk: `-EBUSY` on concurrent destroy
is consistent with existing error handling in `pqm_destroy_queue()`
(non-`-ETIME`/non-`-EIO` errors skip freeing). No new APIs or data
structures.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** `wait_on_destroy_queue()` and `is_being_destroyed` usage
introduced in commit `a70a93fa568b4` ("drm/amdkfd: add debug suspend and
resume process queues operation", 2023-06-09, Jonathan Kim). Confirmed
ancestor of HEAD in this tree. Bug has existed since that commit.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent `amdkfd` stable-relevant fixes in this tree include
NULL deref, overflow, list corruption, and UAF fixes — active
maintenance area. No prior fix for this specific race found (`git log
--grep="destroy_queue_cpsch"` and `--grep="is_being_destroyed"` show
only the introducing commit).

### Step 3.4: Author Context
**Record:** Alysa Liu has other security/reliability fixes in
amdgpu/amdkfd in this tree (e.g., `7885eb335d8f9` VM acquire UAF). Alex
Deucher is AMDGPU maintainer.

### Step 3.5: Dependencies
**Record:** Standalone — uses existing `is_being_destroyed` field in
`kfd_priv.h` (line 521), already present since `a70a93fa568b4`. No
series dependencies.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` could not be run — commit is not in
this checkout. Lore.kernel.org search blocked (Anubis bot protection).
**UNVERIFIED:** full mailing list review thread.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 dig -w. Commit message shows Reviewed-
by from AMD and Signed-off-by from maintainer.

### Step 4.3: Bug Report
**Record:** N/A — no Reported-by or Link tags.

### Step 4.4: Related Patches/Series
**Record:** Appears standalone; not part of a multi-patch series.

### Step 4.5: Stable List History
**Record:** **UNVERIFIED** — could not search lore stable archive.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `wait_on_destroy_queue()`, `destroy_queue_cpsch()`, callers
`pqm_destroy_queue()`, `kfd_ioctl_destroy_queue()`.

### Step 5.2: Callers
**Record:**
- `destroy_queue_cpsch` assigned at line 2953 as
  `dqm->ops.destroy_queue` (CP scheduling path).
- Called from `pqm_destroy_queue()` (line 550).
- `pqm_destroy_queue()` called from `kfd_ioctl_destroy_queue()` (line
  429) under `p->mutex`.
- Userspace entry: `KFD_IOC_DESTROY_QUEUE` ioctl on `/dev/kfd`.

### Step 5.3: Callees
**Record:** `wait_on_destroy_queue()` calls `dqm_unlock/lock`,
`mutex_unlock/lock`, `wait_event_interruptible()`. On success path,
`destroy_queue_cpsch()` calls `mqd_mgr->free_mqd()` after unlock — the
UAF window is between wait return and completion of destroy.

### Step 5.4: Reachability
**Record:** **Userspace-reachable** for processes with KFD access.
Trigger requires:
- `debug_trap_enabled` on the process (KFD debugger path)
- Queue `is_suspended`
- Concurrent destroy while first destroy waits (mutex dropped during
  wait)

Narrower than everyday compute, but real for ROCm debugger / debug-trap
workloads.

### Step 5.5: Similar Patterns
**Record:** `suspend_single_queue()` already checks `is_being_destroyed`
(line 1075) — this fix completes the symmetric protection for the
destroy side.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Tree is `v6.18.44` (Makefile: 6.18.44). Current
`wait_on_destroy_queue()` at lines 2480–2506 lacks all three fix hunks.
`is_being_destroyed` field exists. Introducing commit `a70a93fa568b4` is
an ancestor of HEAD.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` succeeded for all three
hunks against current file (minor 1-line offset on first hunk). No
structural refactoring conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** **NO** — grep and `git log -S "is_being_destroyed"` show no
subsequent fix for this race in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpu/drm/amd/amdkfd/` — **IMPORTANT** (AMD GPU
compute/KFD/ROCm). Not universal like mm/VFS, but affects all KFD users
on AMDGPU.

### Step 7.2: Activity Level
**Record:** Actively maintained — multiple recent amdkfd security and
stability fixes in 6.18.y (NULL deref, overflow, list corruption, CRIU
fixes).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** AMD GPU users with `CONFIG_DRM_AMDGPU` + KFD enabled,
specifically processes using debug-trap with suspended queues.
Config/driver-specific, not platform-specific.

### Step 8.2: Trigger Conditions
**Record:**
- Process has `debug_trap_enabled`
- Target queue is `is_suspended`
- Two concurrent destroy attempts (or destroy during wait after mutex
  drop)
- **Likelihood:** Uncommon but realistic in debugger scenarios (multi-
  threaded teardown, signal interruption + retry)
- **Privilege:** Requires access to `/dev/kfd` (not arbitrary
  unprivileged, but reachable by compute users)

### Step 8.3: Failure Mode Severity
**Record:** **UAF** on `struct queue` → kernel oops/crash, potential
memory corruption. **Severity: HIGH** (approaching CRITICAL for
exploitable UAF, though trigger is somewhat specialized).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents real UAF crash in production KFD debugger
  paths
- **Risk:** LOW — 6 lines, uses existing flag, `-EBUSY` is
  safe/conventional
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Explicit UAF race fix with clear mechanism
- Bug present since 2023 in code that exists in 6.18.44
- Small, surgical, applies cleanly
- Userspace-reachable via KFD ioctl
- Maintainer + reviewer sign-off
- Matches pattern of other amdkfd stable fixes (UAF, NULL deref, races)
- Error-path flag cleanup prevents stuck "being destroyed" state

**AGAINST backport:**
- Narrow trigger (debug_trap + suspended queue + concurrency)
- No syzbot/user report in commit message
- Mailing list discussion unverified

**Unresolved:**
- Full lore review thread (blocked)
- Whether fix commit hash exists on mainline (not in this tree)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; AMD reviewer
   + maintainer SOB; no Tested-by but pattern is standard
2. Fixes a real bug? **PASS** — verified UAF race in code
3. Important issue? **PASS** — UAF / crash (HIGH severity)
4. Small and contained? **PASS** — 6 lines, 1 file, 2 functions
5. No new features/APIs? **PASS** — uses existing `is_being_destroyed`
   field
6. Can apply to local tree? **PASS** — verified with `git apply --check`

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a quirk/ID/DT/build/doc
exception.

### Step 9.4: Decision Rationale
This is a textbook stable backport: a real use-after-free in KFD queue
destruction, introduced years ago, still present in 6.18.44, fixed with
a minimal flag-based serialization that mirrors existing suspend-side
logic. The trigger is specialized (debugger + suspended queue) but the
consequence is a kernel crash. The patch applies cleanly and carries low
risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed no Fixes:/Reported-by:/Link: tags
- **[Phase 2]** Read current `wait_on_destroy_queue()` at lines
  2480–2506: missing all fix hunks
- **[Phase 2]** Read `destroy_queue_cpsch()` at lines 2508–2601: missing
  flag cleanup on error path
- **[Phase 2]** Read `suspend_single_queue()` line 1075: existing
  `is_being_destroyed` check confirms flag infrastructure
- **[Phase 2]** Read `kfd_priv.h` line 521: `is_being_destroyed` field
  exists
- **[Phase 3]** `git describe HEAD`: v6.18.44
- **[Phase 3]** `git blame -L 2480,2506`: `wait_on_destroy_queue` from
  `a70a93fa568b4` (Jonathan Kim, 2023-06-09)
- **[Phase 3]** `git show a70a93fa568b4f`: introduced debug
  suspend/resume and `wait_on_destroy_queue`
- **[Phase 3]** `git merge-base --is-ancestor a70a93fa568b4f HEAD`:
  buggy commit is in tree
- **[Phase 3]** `git log -S "is_being_destroyed"`: only introducing
  commit, no fix
- **[Phase 3]** `git log --oneline -20 -- kfd_device_queue_manager.c`:
  recent amdkfd activity confirmed
- **[Phase 4]** `b4 dig -c`: N/A — commit not in checkout
- **[Phase 4]** lore.kernel.org fetch: blocked by Anubis (UNVERIFIED)
- **[Phase 5]** `grep destroy_queue`: traced call chain ioctl →
  pqm_destroy_queue → destroy_queue_cpsch
- **[Phase 5]** Read `pqm_destroy_queue()` lines 505–574: frees queue
  only after successful destroy
- **[Phase 5]** Read `kfd_ioctl_destroy_queue()` lines 417–433:
  holds/releases `p->mutex`
- **[Phase 6]** Confirmed buggy code at lines 2493, 2495–2503 (drops
  locks during wait)
- **[Phase 6]** `git apply --check`: patch applies cleanly to 6.18.44
- **[Phase 6]** `grep "fix UAF race in destroy_queue_cpsch"`: not in
  tree (fix not yet applied)
- **[Phase 8]** Race mechanism verified: mutex dropped at line 2497
  enables concurrent destroy

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index d9f09f25911a7..b02fe5d08c79f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -2499,6 +2499,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 	if (pdd->qpd.is_debug)
 		return ret;
 
+	if (q->properties.is_being_destroyed)
+		return -EBUSY;
+
 	q->properties.is_being_destroyed = true;
 
 	if (pdd->process->debug_trap_enabled && q->properties.is_suspended) {
@@ -2511,6 +2514,9 @@ static int wait_on_destroy_queue(struct device_queue_manager *dqm,
 		dqm_lock(dqm);
 	}
 
+	if (ret)
+		q->properties.is_being_destroyed = false;
+
 	return ret;
 }
 
@@ -2604,7 +2610,7 @@ static int destroy_queue_cpsch(struct device_queue_manager *dqm,
 	return retval;
 
 failed_try_destroy_debugged_queue:
-
+	q->properties.is_being_destroyed = false;
 	dqm_unlock(dqm);
 	return retval;
 }
-- 
2.53.0

