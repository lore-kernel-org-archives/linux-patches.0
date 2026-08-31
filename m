Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE194E141B;
	Mon, 31 Aug 2026 13:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183597; cv=none; b=ZMvsrtYvNbAFntsfrcFjdEIyaNTiCgKgqBJwCOq1xXibP5VypE6WKC1tFqGSi74eYp+kJoRECAypuApdUTqWid8rMC00GW2eBLtEY8RF7QHhK0XvXoX7h0V9C2e5XA3arQWm1Ti0bDL+VwJ4ZR/MUQp/32zwEUNh8k9DPYf3D1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183597; c=relaxed/simple;
	bh=4HBuT0m+OuWtdW3B/lNZ3qAi+Cey7F4xPY7aqRclvRE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e9LiQ3GYlv+/YDYXllgSHP+6XSgBswrO6/PgBJLFRVdjbs50rU41/dL+77CWivG+Mlu2mDdn037CdOIdI5Es0WXgJE3ZO7IpC4eI5zcCc94onewGUVoCPiKVtGHjUjw2H2nz5R5dK/5ujLJo5BadrirctQ9Wlh+ofeTNfriY6Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IW6pLgr9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IW6pLgr9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803B51F00A3E;
	Mon, 31 Aug 2026 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183595;
	bh=nlCQIUoWbG2Xc+D5e9bO/5vr2cXjHLtz5iTeimalskk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IW6pLgr97JoK/DB2ELJnTGXUkpxFhwb0SrBraCNuCe1mI7CnO9P5TFT4trJAyc7vx
	 GpRvXYN987m+LkfDf/bHvQUyUdyGstfOAsziEA9hMKOSe8wUBbQm49uxbnHj+6Wb5e
	 JkysJ4iwIhij42qTisIBEcaxv9+xMVQhDlNJ7jCwCTLvJQjmqDSKTctF+goewljQsT
	 /Ggw29ySOGWrOyAXO+j+xkF2s/Nu3jjnEXxC+QF1cprpOMwILFlPSeRdoskEmkbkLx
	 zWE//+Qva4kwOjWZo6HKDt+h/nmxwLz39jclR1s+9lMcv7uaDPrAXVDGaFs2jrHsBo
	 j7iL6kBfJMHlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	nas.chung@chipsnmedia.com,
	jackson.lee@chipsnmedia.com,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] media: chips-media: wave5: Add range checks for dec_output_info
Date: Mon, 31 Aug 2026 09:23:36 -0400
Message-ID: <20260831133314.4125787-188-sashal@kernel.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 79aef69bb0903616f4867f0168aea717a11c439c ]

If the driver's dec_output_info contains invalid data the driver can
write in invalid memory. Add a range check for that.

This fixes this smatch error:
drivers/media/platform/chips-media/wave5/wave5-vpuapi.c:588 wave5_vpu_dec_get_output_info() error: buffer overflow 'inst->frame_buf' 64 <= 127

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `media: chips-media: wave5: Add range checks
for dec_output_info`

**Local tree:** Linux **6.18.43** (`v6.18.43-1-gc7f0dac02d232`, branch
`stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[media: chips-media: wave5]` `[Add]` — Add range checks for
`dec_output_info` in the Wave5 VPU decoder driver.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Ricardo Ribalda `<ribalda@chromium.org>` (author)
- **Reviewed-by:** Nicolas Dufresne `<nicolas.dufresne@collabora.com>`
  (media subsystem reviewer)
- **Signed-off-by:** Hans Verkuil `<hverkuil+cisco@kernel.org>` (media
  maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable@ in the
  commit message itself
- Part of series `[PATCH v4 4/6] media: Fix new smatch warnings`; cover
  letter CC'd `stable@vger.kernel.org` and Greg Kroah-Hartman

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `dec_output_info` can contain invalid index data; driver
  indexes `inst->frame_buf[]` without validating the computed index.
- **Symptom:** Out-of-bounds access on `inst->frame_buf` (smatch:
  `buffer overflow 'inst->frame_buf' 64 <= 127`).
- **Root cause:** Existing check bounds `index_frame_display` against
  `max_dec_index`, but the actual index is `num_of_decoding_fbs +
  index_frame_display` (fb_offset), which can exceed `MAX_REG_FRAME`
  (64).

### Step 1.4: Hidden Bug Fix?
**Record:** Yes — despite smatch-driven origin, this is a real bounds-
check bug fix, not cosmetic cleanup. The commit message explicitly
states invalid data can cause invalid memory access.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/media/platform/chips-media/wave5/wave5-vpuapi.c`
  (+9 / -2 lines)
- **Function:** `wave5_vpu_dec_get_output_info()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `info->disp_frame = inst->frame_buf[val +
  info->index_frame_display]` when `index_frame_display <
  max_dec_index`.
- **After:** Computes `idx = val + info->index_frame_display`, validates
  `idx < MAX_REG_FRAME`, returns `-EINVAL` on failure, then assigns
  `inst->frame_buf[idx]`.
- **Path:** Normal decode output-info retrieval after firmware query.

### Step 2.3: Bug Mechanism
**Record:** **Buffer overflow / out-of-bounds access (memory safety).**
`frame_buf` has `MAX_REG_FRAME` (64) elements. Index uses fb_offset
(`num_of_decoding_fbs`) plus display index from firmware, but only the
display index was bounded — not the sum. Smatch correctly identified
index up to 127.

### Step 2.4: Fix Quality
**Record:** Obviously correct; matches existing patterns in the same
file (`reset_auxiliary_buffers()` line 189,
`wave5_vpu_dec_reset_framebuffer()` line 626). Minimal, uses existing
`err_out` path. Low regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy line introduced when `wave5-vpuapi.c` entered this
tree (commit `5d324e5159d9e`, Nov 2025). Present since Wave5 driver
landed in 6.18.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File History
**Record:** Wave5 driver has had multiple stable-worthy fixes in 6.18.y
(panics, memory leaks, spinlock issues). This fix is not yet in the
tree. Part of a 6-patch smatch series, but each patch touches a
different file — **standalone**.

### Step 3.4: Author Context
**Record:** Ricardo Ribalda is an active media contributor (Chromium).
Hans Verkuil merged; Nicolas Dufresne reviewed.

### Step 3.5: Dependencies
**Record:** None. Patch 4/6 is self-contained; `MAX_REG_FRAME` and
`err_out` already exist in this tree. No prerequisite commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Series cover at https://lists.openwall.net/linux-
kernel/2026/05/07/2079. Patch v4 submitted May 7, 2026; evolved v1→v4.
v2 note: removed `WARN_ON()` from user-triggerable paths; this patch
retains `WARN_ON()` because invalid data comes from firmware/hardware
registers, not direct userspace input.

### Step 4.2: Reviewers
**Record:** Cover CC'd Mauro Chehab, Hans Verkuil, Greg Kroah-Hartman,
linux-media@, stable@. Reviewed-by from Nicolas Dufresne; merged by Hans
Verkuil.

### Step 4.3: Bug Report
**Record:** Smatch static analysis finding; no syzbot or user crash
report. Cover letter classifies some warnings as "inoffensive" but
includes fixes for user-triggerable errors; this wave5 issue is a
genuine missing bounds check.

### Step 4.4: Related Patches
**Record:** Series has 5 other independent patches (v4l2-dev, mt9p031,
adv7604, ipu3-imgu, amlogic-c3). None required for this fix.

### Step 4.5: Stable List
**Record:** Cover letter explicitly CC'd `stable@vger.kernel.org`. No
objection found in available thread excerpts.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `wave5_vpu_dec_get_output_info()` modified.

### Step 5.2: Callers
**Record:**
- `wave5-vpu-dec.c:354` — `wave5_vpu_dec_finish_decode()` (normal decode
  completion)
- `wave5-vpu-dec.c:1407` — flush/stop path
- `wave5-vpu-dec.c:1499` — another decode path
- `wave5-vpuapi.c:82` — busy-retry during instance flush

All are active V4L2 mem2mem decode paths.

### Step 5.3: Callees
**Record:** Calls `wave5_vpu_dec_get_result()` which reads
`W5_RET_DEC_DISPLAY_INDEX` from VPU hardware (line 1059–1060 in
`wave5-hw.c`). `index_frame_display` is firmware-provided.

### Step 5.4: Reachability
**Record:** Reachable during video decode on systems with
`CONFIG_VIDEO_WAVE_VPU` (ARCH_K3 or COMPILE_TEST). Users with access to
`/dev/video*` can trigger decode operations; malformed streams or
firmware edge cases can produce bad indices.

### Step 5.5: Similar Patterns
**Record:** Same file already bounds-checks `index >= MAX_REG_FRAME` in
`reset_auxiliary_buffers()` and `wave5_vpu_dec_reset_framebuffer()`.
This fix closes a gap in `wave5_vpu_dec_get_output_info()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** At lines 561–563 in this tree:

```561:563:drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
        if (info->index_frame_display >= 0 &&
            info->index_frame_display < (int)max_dec_index)
                info->disp_frame = inst->frame_buf[val +
info->index_frame_display];
```

Fix is **not** yet applied. Wave5 driver present since 6.18.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 9-line hunk, no structural conflicts.
`MAX_REG_FRAME` defined as `WAVE5_MAX_FBS * 2` (= 64) in
`wave5-vpuapi.h:47`.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent bounds check for this access path. Other wave5
stable fixes exist but not this one.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/media/platform/chips-media/wave5/` — V4L2 hardware
video codec driver. **Criticality: IMPORTANT** (peripheral driver, but
memory-safety bugs in kernel drivers are serious).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y with multiple bugfix commits
since initial merge.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** Users of TI K3 (and COMPILE_TEST) systems with Chips&Media
Wave5 VPU (`CONFIG_VIDEO_WAVE_VPU`). Not universal, but real production
hardware.

### Step 8.2: Trigger Conditions
**Record:** During decode when firmware returns display index data that
passes the incomplete `max_dec_index` check but produces `idx >=
MAX_REG_FRAME`. Possible with firmware edge cases, resolution changes,
or error recovery. Not every boot, but reachable in normal decode
operation.

### Step 8.3: Failure Mode
**Record:** Out-of-bounds read of `struct frame_buffer` from kernel
stack/static data → kernel oops/panic or memory corruption. **Severity:
HIGH** (memory safety in kernel context).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents OOB kernel memory
  access
- **Risk:** VERY LOW — 7-line bounds check, consistent with existing
  code, reviewed by subsystem maintainer
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real out-of-bounds array access bug (smatch-verified)
- Fixes potential kernel crash/memory corruption
- Small, surgical, obviously correct
- Reviewed by Nicolas Dufresne; merged by Hans Verkuil
- Standalone — no series dependencies
- Buggy code exists in this 6.18.43 tree; fix not yet applied
- Cover letter CC'd stable@
- Consistent with existing `MAX_REG_FRAME` checks in same driver

**AGAINST backport:**
- Driver is platform-specific (K3), not all users affected
- Trigger requires firmware returning bad index data (not directly
  proven in field)
- Smatch-driven, not syzbot/user-reported crash
- Retains `WARN_ON()` (acceptable for firmware-provided data per series
  rationale)

**Unresolved:** No runtime crash report verified; impact inferred from
static analysis and code review.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is clear; Reviewed-by
   present; smatch warning resolved
2. Fixes a real bug? **PASS** — missing bounds check on kernel array
   access
3. Important issue? **PASS** — OOB kernel memory access (HIGH severity)
4. Small and contained? **PASS** — 1 file, ~9 lines
5. No new features/APIs? **PASS** — defensive bounds check only
6. Can apply to local tree? **PASS** — driver and all symbols exist;
   clean apply expected

### Step 9.3: Exception Category
**Record:** Not a device ID/quirk/DT/build/docs exception — standard
memory-safety bug fix.

### Step 9.4: Decision Rationale
This commit closes a genuine bounds-check gap in
`wave5_vpu_dec_get_output_info()`. The Wave5 driver exists in Linux
6.18.y, the buggy code is present, and the fix is minimal, reviewed, and
standalone. For users decoding video on K3 hardware with the Wave5 VPU,
an out-of-bounds access on `inst->frame_buf[]` can cause kernel crashes
or memory corruption. The fix aligns with existing `MAX_REG_FRAME`
checks elsewhere in the driver and carries negligible regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags: Reviewed-by Nicolas Dufresne, SOB Hans
  Verkuil; no Fixes/Reported-by
- [Phase 1] Commit body: smatch OOB on `inst->frame_buf` 64 <= 127
- [Phase 2] Diff: +9/-2 in `wave5_vpu_dec_get_output_info()`, adds `idx`
  bounds check against `MAX_REG_FRAME`
- [Phase 3] `git describe HEAD`: v6.18.43-1-gc7f0dac02d232 (6.18.43)
- [Phase 3] `git blame`: buggy line from driver introduction in this
  tree
- [Phase 3] No Fixes: tag; no prerequisite commits identified
- [Phase 3] `git log --oneline -20 -- wave5-vpuapi.c`: multiple wave5
  fixes; this one not present
- [Phase 4] Cover letter at lists.openwall.net/2026/05/07/2079: series
  v4, CC stable@, 6 independent patches
- [Phase 4] b4 dig failed (commit not in local repo); used web
  search/lkml archives instead
- [Phase 4] v2 series note: WARN_ON kept for non-user-triggerable paths
- [Phase 5] Callers verified via grep: `wave5-vpu-dec.c:354,1407,1499`,
  `wave5-vpuapi.c:82`
- [Phase 5] `wave5_vpu_dec_get_result()`: `index_frame_display` from
  `W5_RET_DEC_DISPLAY_INDEX` hardware register
- [Phase 5] `MAX_REG_FRAME` = 64 (`WAVE5_MAX_FBS * 2`),
  `frame_buf[MAX_REG_FRAME]` at `wave5-vpuapi.h:808`
- [Phase 6] Buggy code confirmed at lines 561–563; fix not applied
- [Phase 6] `CONFIG_VIDEO_WAVE_VPU` depends on `ARCH_K3 || COMPILE_TEST`
  per Kconfig
- [Phase 6] `num_of_decoding_fbs` validated `< WAVE5_MAX_FBS` at
  registration (line 305), but OOB path doesn't validate sum
- [Phase 8] Failure mode: OOB read → kernel memory safety issue,
  severity HIGH

**YES**

 .../media/platform/chips-media/wave5/wave5-vpuapi.c   | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
index e94d6ebc9f816..e7ea2f6a99d5b 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -559,8 +559,15 @@ int wave5_vpu_dec_get_output_info(struct vpu_instance *inst, struct dec_output_i
 		p_dec_info->num_of_decoding_fbs : p_dec_info->num_of_display_fbs;
 
 	if (info->index_frame_display >= 0 &&
-	    info->index_frame_display < (int)max_dec_index)
-		info->disp_frame = inst->frame_buf[val + info->index_frame_display];
+	    info->index_frame_display < (int)max_dec_index) {
+		u32 idx = val + info->index_frame_display;
+
+		if (WARN_ON(idx >= MAX_REG_FRAME)) {
+			ret = -EINVAL;
+			goto err_out;
+		}
+		info->disp_frame = inst->frame_buf[idx];
+	}
 
 	info->rd_ptr = p_dec_info->stream_rd_ptr;
 	info->wr_ptr = p_dec_info->stream_wr_ptr;
-- 
2.53.0

