Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A00A15E5BB;
	Sat, 14 Feb 2026 01:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030985; cv=none; b=D2NP9INwOY22YPd6iadbcyUrBzhSUxRsMfqipbUdR86pkn1n/7d/0oe6eRcKI2k3PjcgAJAf9RqlhSAbib6AeejPtTc1X5YzSIbv+oCx8de6ML+F2UXW+Cse+hHP7ROgvBaN2SAKyJU/8CTfOLxEKcvaGBP/1QHmItqOuxbu1Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030985; c=relaxed/simple;
	bh=SQImZMhCTVZnM1Yiox7tTnc0iVVS1xw8KwjmrbjwgfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NscIFpsr/ftBhnKGU9IE20j+76NEyS0mE//5Kh05TT31er98Ghlmsi0cItNYVntuF5UG/agByaukH7IGBVQ1+xdVjKksRh4CiXmzpivY/65Gj4/OfCeWb73C0QMsmuqdUhM4D9BXPBhq3++P2ymQgiSi2yeIJNd4LmVKuuQuVVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=exSiechR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="exSiechR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FFBC16AAE;
	Sat, 14 Feb 2026 01:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030985;
	bh=SQImZMhCTVZnM1Yiox7tTnc0iVVS1xw8KwjmrbjwgfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exSiechRTZLkqWZwmYGGsz3oUP3JFAp2YpgUgBpfhlzuKCVWtn/8mts/w5CKqEOGk
	 +VNbQNsSgD6GzaIW0OV4HOK8O+eN4Z6p37A7Bkl/TxNA4q2qbUbO1hSrclrysREMSa
	 Fm6NurJzEZ9sahH/XYybq+08UOQSWYgfiRKU/wslhYK8hxvyeVNBB50lTLZRiB9x2k
	 5yzf2QMpp7rKSDm7ILQO44BN8EDCu9pWTj5WtXdmEQZRJlrQFAg9J53DOqxI/o1Qby
	 QwL28mIU3qX10TaLfLoKPOIsExlXah6bDY03QmZ5WBI9UJqprRzHPf6j/2Kv0b1m21
	 VZrE632OTpo5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.12] drm/xe: Only toggle scheduling in TDR if GuC is running
Date: Fri, 13 Feb 2026 19:58:11 -0500
Message-ID: <20260214010245.3671907-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit dd1ef5e2456558876244795bb22a4d90cb24f160 ]

If the firmware is not running during TDR (e.g., when the driver is
unloading), there's no need to toggle scheduling in the GuC. In such
cases, skip this step.

v4:
 - Bail on wait UC not running (Niranjana)

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Link: https://patch.msgid.link/20260110012739.2888434-4-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding of this commit. Let me
summarize my analysis.

---

## Comprehensive Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message states: "If the firmware is not running during TDR
(e.g., when the driver is unloading), there's no need to toggle
scheduling in the GuC. In such cases, skip this step."

This is clearly a bug fix for a race condition during driver unloading.
The "v4" tag and review from Niranjana Vishwanathapura confirm this went
through review iterations. The specific mention of "Bail on wait UC not
running" in v4 notes shows the second hunk was specifically requested by
reviewers.

### 2. CODE CHANGE ANALYSIS

The patch makes exactly **two** small, surgical changes in
`guc_exec_queue_timedout_job()`:

**Change 1 (line 1307):** Adds `&& xe_uc_fw_is_running(&guc->fw)` to the
condition guarding `disable_scheduling()`:

```c
// Before:
if (!exec_queue_destroyed(q)) {
// After:
if (!exec_queue_destroyed(q) && xe_uc_fw_is_running(&guc->fw)) {
```

This prevents `disable_scheduling()` from being called when the GuC
firmware is not running. `disable_scheduling()` sends a command to the
GuC via `xe_guc_ct_send()` and sets the `exec_queue_pending_disable`
flag. If the firmware is dead, the send will fail (return `-ECANCELED`
from `__guc_ct_send_locked` when `ct->state ==
XE_GUC_CT_STATE_STOPPED`), but the `pending_disable` flag is already
set. This means the subsequent `wait_event_timeout` will wait a full 5
seconds for a G2H response that will **never** come, then trigger a
spurious GT reset via `trigger_reset`.

**Change 2 (line 1341):** Adds `!xe_uc_fw_is_running(&guc->fw) ||` to
the wait condition:

```c
// Before:
ret = wait_event_timeout(guc->ct.wq,
                         !exec_queue_pending_disable(q) ||
                         xe_guc_read_stopped(guc) ||
                         vf_recovery(guc), HZ * 5);
// After:
ret = wait_event_timeout(guc->ct.wq,
                         !xe_uc_fw_is_running(&guc->fw) ||
                         !exec_queue_pending_disable(q) ||
                         xe_guc_read_stopped(guc) ||
                         vf_recovery(guc), HZ * 5);
```

This is a safety net: even if `disable_scheduling` was somehow called
before firmware went down (a TOCTOU race between the first check and the
CT send), the wait will immediately resolve when firmware goes down
rather than hanging for 5 seconds.

### 3. BUG MECHANISM

Without this fix, during driver unloading:
1. TDR (Timeout Detection and Recovery) fires for a pending job
2. GuC firmware has already been stopped (driver is unloading)
3. `disable_scheduling()` sends a command to the dead GuC
4. The CT send fails but `exec_queue_pending_disable` is already set
5. The `wait_event_timeout` waits 5 full seconds for a response that
   never arrives
6. Timeout triggers `trigger_reset` path → spurious
   `xe_gt_reset_async()` + `xe_devcoredump()`
7. This causes unnecessary GT resets, devcoredumps, and potentially
   warnings/errors during teardown

### 4. COMPANION COMMIT

Commit `9b42321a02c50` ("drm/xe/guc: Check GuC running state before
deregistering exec queue") by Shuicheng Lin already fixed the
**identical** issue in the `__guc_exec_queue_process_msg_cleanup()`
path. That commit has `Fixes: dd08ebf6c352` and `Cc:
stable@vger.kernel.org` tags and is already in the tree. The commit
being analyzed is the same type of fix but for the TDR path — it's a
parallel fix for the same class of bug in a different code path.

### 5. DEPENDENCY CHECK

The patch depends on:
- `#include "xe_uc_fw.h"` being present — **already added** by
  `9b42321a02c50`
- The `xe_uc_fw_is_running()` function — **already exists** in
  `xe_uc_fw.h`
- The `guc->fw` field — **always existed** in `struct xe_guc`

The patch applies cleanly to the current tree. No additional
dependencies.

### 6. SCOPE AND RISK

- **Lines changed:** 2 lines modified (one condition added, one wait
  condition added)
- **Files affected:** 1 (`xe_guc_submit.c`)
- **Risk:** Very low — both changes are additive conditions that skip
  operations when firmware is not running. They can never make things
  worse because if firmware IS running, behavior is identical.
- **Subsystem:** GPU driver (xe), limited blast radius

### 7. USER IMPACT

This affects Intel Xe GPU users who experience:
- Spurious GT resets and warnings during driver unload/unbind
- 5-second hangs in TDR path when GuC firmware isn't running
- Unnecessary devcoredumps during teardown

Without the fix, the driver teardown sequence can be disrupted by TDR
firing at the wrong time, leading to error messages and potentially
slower/buggy driver unload.

### 8. STABILITY ASSESSMENT

- **Reviewed-by:** Niranjana Vishwanathapura (Intel)
- **Author:** Matthew Brost (Intel Xe maintainer and key contributor)
- **Pattern:** Identical to the already-accepted companion fix
  `9b42321a02c50`
- The fix is purely defensive — it adds a "firmware running" guard
  before sending commands

### 9. CLASSIFICATION

This is a **bug fix** that prevents:
- Spurious GT resets during driver unload
- Unnecessary 5-second timeouts/hangs
- False "Schedule disable failed to respond" warnings
- Unneeded devcoredumps

It is NOT a feature addition — it's a guard against calling into dead
firmware.

### Verdict

This commit fixes a real bug in the TDR path of the Xe GPU driver where
attempting to communicate with dead GuC firmware during driver unloading
causes spurious timeouts, unnecessary GT resets, and error messages. The
fix is small (2 line changes), surgically targeted, obviously correct,
reviewed by Intel engineers, and follows the exact same pattern as the
companion commit `9b42321a02c50` that is already accepted for stable.
The dependency on `xe_uc_fw.h` include is satisfied by the companion
commit. Risk is minimal as the change only skips operations when
firmware is not running.

**YES**

 drivers/gpu/drm/xe/xe_guc_submit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index f6ba2b0f074d2..ced13f17fb720 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1304,7 +1304,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		if (exec_queue_reset(q))
 			err = -EIO;
 
-		if (!exec_queue_destroyed(q)) {
+		if (!exec_queue_destroyed(q) && xe_uc_fw_is_running(&guc->fw)) {
 			/*
 			 * Wait for any pending G2H to flush out before
 			 * modifying state
@@ -1339,6 +1339,7 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		 */
 		smp_rmb();
 		ret = wait_event_timeout(guc->ct.wq,
+					 !xe_uc_fw_is_running(&guc->fw) ||
 					 !exec_queue_pending_disable(q) ||
 					 xe_guc_read_stopped(guc) ||
 					 vf_recovery(guc), HZ * 5);
-- 
2.51.0

