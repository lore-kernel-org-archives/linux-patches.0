Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B594B5132;
	Mon, 31 Aug 2026 13:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184341; cv=none; b=uUMcKYw36eE78Aoyc6BbegvGX3XBJ17aCkadwCxXdlGscyCeJFqrb9znimDEcLClL4kVTnBaNsp0vKsP/KvvYX6eWKcipNlx43WMlvZS6Eze5NtfULT8Ms/qPTljMPLQ6SN9gJFWaChiKiquyt9/6g4G0zPgmTITGmhcdNdT3Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184341; c=relaxed/simple;
	bh=HzEe29KoGyGWZBCFWu0kK75awybvPLxgzeAdmm8N+nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j/LafJHNpahP99GbglYjki5+aiHomcIAJdH3JzqP8zkTfJZFXvMuLl4wOQeBObnwWq7Amei7eShNxxepwIbaM3SnbpMKSfmQ/B4JZXwSAev6xmi/qx1aFY96zmIGZYIS3BJFWuoLup9ahXBQ4rLn2jD2hbcca2hbMiMppxtDczw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/AIbJ83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/AIbJ83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA921F00A3D;
	Mon, 31 Aug 2026 13:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184339;
	bh=QQjJUuwqF3dl/BsR9mTs4/kOQd2wo43GQXcvfc26Dc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j/AIbJ83WoxEzQsG+uHKBnqX7EmB84bQrNan1Ni9YU+/3HbXlycJpafC/5dRJQXwo
	 zIByS93zfUNf27JjTMHKWh2xcJy6sFQxNnC7AZLx7bfhgZawkeqlukwRQy1oPv4obS
	 G/zNLMoX1RVLzfPM5ZaIEF558e4aKZaH4o38+iM7ROCeNBPBwXRdEyKQ3bZf2lqvmI
	 kgHHs3G+1CzUNlJGkyLlfQYGNDifDeP3SxPdSChjmfSZ3aL6Z1ewx7meHg3dyoOsfG
	 Rsl4Y58Yr8aB4eghvVropM7ykRpxDxCEroSMM1L3lTx7bJlb/WZVtnkvz/2GGC2pb3
	 ZhdF7oskK5lpA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Francis <David.Francis@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/amdkfd: Check bounds on allocate_doorbell
Date: Mon, 31 Aug 2026 09:31:03 -0400
Message-ID: <20260831133314.4125787-635-sashal@kernel.org>
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

From: David Francis <David.Francis@amd.com>

[ Upstream commit 1f087bb8cf9e8797633da35c85435e557ef74d06 ]

allocated_doorbell has an option to set the doorbell id
to a specific value (used by CRIU). This value was not
bounds checked.

Check to confirm it's less than KFD_MAX_NUM_OF_QUEUES_PER_PROCESS.

Signed-off-by: David Francis <David.Francis@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amdkfd: Check bounds on
allocate_doorbell`

**Local tree:** Linux 6.18.43 (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/amdkfd]` `[Check]` — Add bounds validation on doorbell
ID during CRIU restore allocation in `allocate_doorbell()`.

### Step 1.2: Commit Tags
**Record:**
| Tag | Value |
|-----|-------|
| Signed-off-by | David Francis \<David.Francis@amd.com\> |
| Reviewed-by | Harish Kasiviswanathan
\<Harish.Kasiviswanathan@amd.com\> |
| Signed-off-by | Alex Deucher \<alexander.deucher@amd.com\>
(committer/maintainer) |
| Fixes: | None |
| Reported-by: | None |
| Cc: stable | None (expected for manual review) |
| Link: | None |

Notable: Reviewed by AMD colleague; committed by subsystem maintainer.
No syzbot or user bug reports.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `allocate_doorbell()` accepts a user-specified doorbell ID
  via `restore_id` (CRIU restore path) without validating it is within
  `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS`.
- **Symptom:** Out-of-bounds `__test_and_set_bit()` on
  `qpd->doorbell_bitmap` → kernel memory corruption or crash.
- **Root cause:** CRIU restore copies `doorbell_id` from userspace
  (`kfd_criu_queue_priv_data`) and passes it directly to
  `allocate_doorbell()` with no upper-bound check.
- **Version info:** None in commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly a missing bounds check. Same
class of bug as the parallel event-restore fix in `kfd_events.c` (`if
(*restore_id >= KFD_SIGNAL_EVENT_LIMIT)`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c` | +3 lines |

- **Function modified:** `allocate_doorbell()`
- **Scope:** Single-file, surgical fix (3 lines added)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (CP queues on SOC15, `restore_id` path):**
  - **Before:** `__test_and_set_bit(*restore_id, qpd->doorbell_bitmap)`
    called with no validation.
  - **After:** Return `-EINVAL` if `*restore_id >=
    KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` (1024) before the bit operation.
- **Affected path:** CRIU queue restore on SOC15+ compute (CP) queues
  only.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer out-of-bounds / memory safety.
- **Mechanism:** `qpd->doorbell_bitmap` is allocated with
  `bitmap_zalloc(KFD_MAX_NUM_OF_QUEUES_PER_PROCESS, GFP_KERNEL)` (1024
  bits). An out-of-range `restore_id` causes `__test_and_set_bit()` to
  write beyond the allocation.

### Step 2.4: Fix Quality
**Record:**
- Obviously correct; mirrors existing pattern in
  `allocate_event_notification_slot()`.
- Minimal, no unrelated changes.
- Low regression risk: only rejects invalid IDs that should never
  succeed.
- No API or behavioral changes for valid inputs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy `restore_id` path is present in this tree at lines
474–479. Git blame in this stable checkout is unreliable (squashed
history), but the vulnerable code is confirmed present.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:**
- Commit on `master`: `a1d4b228e3dc5` (May 19, 2026), cherry-picked from
  `1f087bb8cf9e`.
- Part of a 2-patch series; patch 2/2 (`6dc2c49a70519` on master) fixes
  the same class of bug for `allocate_sdma_queue()` — separate,
  standalone fix.
- Fix is **not** in the local 6.18.43 tree.

### Step 3.4: Author Context
**Record:** David Francis (AMD). Reviewed by Harish Kasiviswanathan;
committed by Alex Deucher (amdgpu/amdkfd maintainer).

### Step 3.5: Dependencies
**Record:** Standalone. No prerequisite commits. Applies cleanly to the
local tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **URL:** https://patch.msgid.link/20260512192824.3682569-1-
  David.Francis@amd.com
- **Series:** v1 only (no further revisions via `b4 dig -a`)
- **Review feedback:** No stable nominations, NAKs, or substantive
  objections found in the mbox thread.

### Step 4.2: Reviewers
**Record:** CC'd to `amd-gfx@lists.freedesktop.org`. Reviewed-by on
commit.

### Step 4.3: Bug Reports
**Record:** N/A — no external bug report or syzbot link.

### Step 4.4: Related Patches
**Record:** Patch 2/2 bounds-checks `restore_sdma_id` in
`allocate_sdma_queue()`. Same bug class; also missing in this tree.
Independent backport candidate.

### Step 4.5: Stable List History
**Record:** Not searched; no stable-list discussion found in mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `allocate_doorbell()` — only function modified.

### Step 5.2: Callers
**Record:**
- `create_queue_nocpsch()` → `allocate_doorbell(qpd, q, qd ?
  &qd->doorbell_id : NULL)` (line 670)
- `create_queue_cpsch()` → same pattern (line 1991)
- Both reached from `pqm_create_queue()` → `kfd_criu_restore_queue()`
  during CRIU restore

### Step 5.3: Callees
**Record:** `__test_and_set_bit()`, `find_first_zero_bit()`,
`set_bit()`, `amdgpu_doorbell_index_on_bar()`.

### Step 5.4: Call Chain / Reachability
**Record:**
```
userspace AMDKFD_IOC_CRIU_OP (restore)
  → criu_restore() → criu_restore_objects()
  → kfd_criu_restore_queue() [copy_from_user q_data including
doorbell_id]
  → pqm_create_queue(..., q_data, ...)
  → create_queue_*() → allocate_doorbell(..., &qd->doorbell_id)
```
Reachable from userspace via CRIU restore ioctl. Requires
`CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN` (see `kfd_chardev.c` lines
3332–3337).

### Step 5.5: Similar Patterns
**Record:** `kfd_events.c:110` already bounds-checks `*restore_id >=
KFD_SIGNAL_EVENT_LIMIT` for CRIU event restore. This commit closes the
same gap for doorbells.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Lines 474–479 in `kfd_device_queue_manager.c` lack
the bounds check. CRIU support (`kfd_criu_restore_queue`,
`AMDKFD_IOC_CRIU_OP`) is present. `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` is
1024.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 3-line addition with no conflicts.
File structure matches mainline.

### Step 6.3: Related Fixes Already Present?
**Record:** No. `git show master:a1d4b228e3dc5` has the fix; local HEAD
does not. SDMA bounds fix (patch 2/2) is also absent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/gpu/drm/amd/amdkfd` — AMDGPU KFD compute driver.
**IMPORTANT** (GPU compute users; not core kernel, but widely deployed
on AMD hardware).

### Step 7.2: Subsystem Activity
**Record:** Active — CRIU support and related hardening commits exist on
master for this subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of AMDGPU KFD with CRIU checkpoint/restore on SOC15+
hardware (CP compute queues). Narrow feature set, but real production
use (containers, HPC migration).

### Step 8.2: Trigger Conditions
**Record:**
- CRIU restore with `doorbell_id >= 1024` in checkpoint private data.
- Requires privileged capability (`CAP_CHECKPOINT_RESTORE` or
  `CAP_SYS_ADMIN`).
- Corrupted or malicious checkpoint image during restore can trigger it.
- Not triggerable by unprivileged users directly.

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds kernel heap write via `__test_and_set_bit()` →
memory corruption, potential kernel oops/panic. **Severity: HIGH**
(memory corruption); mitigated by privileged-only ioctl path.

### Step 8.4: Risk-Benefit
**Record:**
| | Assessment |
|--|------------|
| **Benefit** | Prevents kernel memory corruption on CRIU restore;
defense-in-depth for untrusted checkpoint data |
| **Risk** | Very low — 3-line bounds check, no behavior change for
valid IDs |
| **Ratio** | Favorable |

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real out-of-bounds bitmap access bug
- Kernel memory corruption possible
- Fix is minimal, obviously correct, maintainer-reviewed
- Buggy code and CRIU infrastructure exist in 6.18.43
- Matches existing bounds-check pattern in `kfd_events.c`
- Standalone, clean apply

**AGAINST backport:**
- CRIU is a niche feature
- Requires privileged capability (not unprivileged attack surface)
- No user reports or syzbot findings
- Patch 2/2 (SDMA) addresses a related gap but is separate

**Unresolved:** None affecting the decision.

### Step 9.2: Stable Rules Checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — trivial bounds check;
Reviewed-by present |
| 2. Fixes a real bug? | **PASS** — OOB `__test_and_set_bit()` on
1024-bit bitmap |
| 3. Important issue? | **PASS** — memory corruption (HIGH, privileged
path) |
| 4. Small and contained? | **PASS** — 3 lines, one function |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — code present, fix absent |

### Step 9.3: Exception Categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Qualifies as a standard memory-safety bug fix.

### Step 9.4: Decision Rationale

For Linux **6.18.43**, the vulnerable CRIU restore path exists, the fix
is absent, and the patch prevents out-of-bounds kernel memory writes
from userspace-supplied `doorbell_id` values. Although CRIU restore
requires elevated privileges, stable trees routinely take such defense-
in-depth fixes — especially when they mirror an existing pattern
(`kfd_events.c`) and are three lines with no regression risk for valid
inputs.

**Note:** Patch 2/2 (`Check bounds for allocate_sdma_queue
restore_sdma_id`) fixes the same bug class for SDMA queues and is also
absent from this tree; it should be evaluated separately.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and `git
  show a1d4b228e3dc5`
- **[Phase 1]** No Fixes:/Reported-by:/Cc: stable tags
- **[Phase 2]** Diff analysis: +3 lines in `allocate_doorbell()` before
  `__test_and_set_bit()`
- **[Phase 3]** `git describe HEAD`: v6.18.43; `make kernelversion`
  equivalent from Makefile: 6.18.43
- **[Phase 3]** `git show a1d4b228e3dc5`: commit exists on master, not
  in HEAD
- **[Phase 3]** `b4 dig -c a1d4b228e3dc5`: found lore thread at
  patch.msgid.link/20260512192824.3682569-1
- **[Phase 3]** `b4 dig -a`: v1 only, no further revisions
- **[Phase 3]** `b4 dig -w`: CC'd amd-gfx@lists.freedesktop.org
- **[Phase 4]** `b4 dig -m /tmp/doorbell_thread.mbox`: patch 2/2 content
  retrieved; no stable Cc in thread
- **[Phase 5]** Grep callers: `allocate_doorbell` called from
  `create_queue_nocpsch` and `create_queue_cpsch` with
  `&qd->doorbell_id`
- **[Phase 5]** Traced CRIU path: `kfd_criu_restore_queue` →
  `pqm_create_queue` → `allocate_doorbell`
- **[Phase 5]** `kfd_events.c:110`: confirmed analogous bounds check
  exists for event restore
- **[Phase 6]** Read local `kfd_device_queue_manager.c:474-479`: bounds
  check **missing**
- **[Phase 6]** `kfd_doorbell.c:259`: `doorbell_bitmap` allocated with
  `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` (1024)
- **[Phase 6]** `kfd_priv.h:97`: `KFD_MAX_NUM_OF_QUEUES_PER_PROCESS` =
  1024
- **[Phase 6]** `kfd_chardev.c:3332-3337`: CRIU ioctl requires
  `CAP_CHECKPOINT_RESTORE` or `CAP_SYS_ADMIN`
- **[Phase 6]** CRIU infrastructure confirmed present
  (`kfd_criu_restore_queue`, `AMDKFD_IOC_CRIU_OP`)
- **[Phase 8]** Failure mode: OOB bit operation → memory corruption;
  privileged ioctl mitigates unprivileged exploitability

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 2f8df95382bc3..d9f09f25911a7 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -472,6 +472,9 @@ static int allocate_doorbell(struct qcm_process_device *qpd,
 	} else {
 		/* For CP queues on SOC15 */
 		if (restore_id) {
+			if (*restore_id >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+				return -EINVAL;
+
 			/* make sure that ID is free  */
 			if (__test_and_set_bit(*restore_id, qpd->doorbell_bitmap))
 				return -EINVAL;
-- 
2.53.0

