Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F193CD8CB;
	Mon, 20 Apr 2026 13:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691750; cv=none; b=SnTgFYKnsZAkBOkLOV4/JDusQhdK73ZAEG9WPM47QrV1P8Ew2fDs6WImBuQP8QB5pcwO65LyEZGFNVZLzlgipQAVtTn40YvH7sq8Cme7+MjHzYxJL9NsPc35jIj1HoYNRKTnF7lnwRyxnVvxL8EdrV8I2kljjn1JfzmSQA7mpjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691750; c=relaxed/simple;
	bh=V0VFj8aZzqmCnTuc3+SedQ4MvFev3ZEavBb0Ggnm2WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bSPrgBAQynUeqJ0Sr8A+V2CzJ5dhL7/f6JYbhT3w8Zd24mYwgxsmdud2W+zzUAK2V6yA+CH/TzRO/xp2Mwgh7ibVu9J8AqHPj81gWHfY63FeZ/Fed5jDQcQRLr9grz5Wbcmbfi8TtmXdoITIZhH1j02FRCuAYD/lZsmXjmbe8B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRbqZn9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRbqZn9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC0CC2BCB6;
	Mon, 20 Apr 2026 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691750;
	bh=V0VFj8aZzqmCnTuc3+SedQ4MvFev3ZEavBb0Ggnm2WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GRbqZn9TH0Y8eVwo2bjF/K40fO5H2IJrsx+HET535VhhZmtRBIzkeTsRwaeh+XDRl
	 xeSTcAjFVVKghwFrztGyAI/I1ouchs4D5YDnqRTWyzYGvVj5eZqbtIhcbCWnXj+fOx
	 VPwd+jPBwrhKjf/HroKhlA8sEc1X/QhnuglQ+ynN7Dqep0BnaHTnRFx4NcPth9hh//
	 GSeWjYeJ6IS98rqrdkR3MSI5kFNudzNoyIHbBxq0Sv2Ll+VlmSW4FTIXdI6t+uvqme
	 Ci5OCJBR8LgYa6mPtBLK46QljOUCRBr6+S0aTZ0hRZMPSMpbIgc/by7+L97VgOgTsn
	 3anHUavsg7clw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Le Ma <le.ma@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: fix array out of bounds accesses for mes sw_fini
Date: Mon, 20 Apr 2026 09:19:25 -0400
Message-ID: <20260420132314.1023554-171-sashal@kernel.org>
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

From: Le Ma <le.ma@amd.com>

[ Upstream commit 418b4e397570f1b0ffb6d5c8aa0872bc33071d49 ]

The mes.fw[] is per-pipe resource shared accross xcc inst.
And enlarge hung_queue array to max inst_pipes.

Signed-off-by: Le Ma <le.ma@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/amdgpu` (AMD GPU DRM driver)
- **Action verb**: "fix" — explicitly a bug fix
- **Summary**: Fixes array out-of-bounds accesses in MES sw_fini path

Record: [drm/amdgpu] [fix] [Out-of-bounds array accesses in MES sw_fini
due to incorrect array sizing and indexing]

### Step 1.2: Tags
- **Signed-off-by**: Le Ma (author), Alex Deucher (AMD DRM maintainer)
- **Reviewed-by**: Hawking Zhang (AMD engineer/reviewer)
- No Fixes: tag, no Cc: stable, no Reported-by, no Link
- Absence of tags is expected for autoselection candidates

Record: Author is Le Ma (AMD engineer). Reviewed by Hawking Zhang.
Merged by Alex Deucher (AMD DRM maintainer). No syzbot or external
reporter.

### Step 1.3: Commit Body
The message states: "The mes.fw[] is per-pipe resource shared accross
xcc inst. And enlarge hung_queue array to max inst_pipes."

Two distinct bugs are described:
1. `mes.fw[]` is per-pipe (size 2) but was accessed with per-instance
   index (`inst = xcc_id * 2 + pipe`) → OOB when xcc_id > 0
2. `hung_queue_db_array_*` arrays were sized at `AMDGPU_MAX_MES_PIPES`
   (2) but accessed up to `AMDGPU_MAX_MES_INST_PIPES` (16) → OOB when
   num_xcc > 1

Record: Bug is OOB array access. Affects multi-xcc (multi-die) AMD GPU
configurations (e.g., MI300 series). The sw_fini path runs during driver
unload/cleanup.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly labeled as a "fix" — no hiding here. Both are clear
out-of-bounds memory accesses.

Record: This is an explicit, clearly-described bug fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- `amdgpu_mes.h`: 3 lines changed (array size `AMDGPU_MAX_MES_PIPES` →
  `AMDGPU_MAX_MES_INST_PIPES`)
- `mes_v12_1.c`: 1 line removed, 3 lines added (move
  `amdgpu_ucode_release` call out of xcc loop)
- Total: +6/-4 lines — very small, surgical fix
- Functions modified: `mes_v12_1_sw_fini()`
- Scope: Single-subsystem, single-driver fix

### Step 2.2: Code Flow Change
**Hunk 1 (amdgpu_mes.h)**:
- Before: `hung_queue_db_array_*[AMDGPU_MAX_MES_PIPES]` — arrays of size
  2
- After: `hung_queue_db_array_*[AMDGPU_MAX_MES_INST_PIPES]` — arrays of
  size 16
- `amdgpu_mes_init()` and `amdgpu_mes_fini()` iterate `for (i = 0; i <
  AMDGPU_MAX_MES_PIPES * num_xcc; i++)` and access these arrays with
  index `i`. When num_xcc > 1, `i` exceeds 2.

**Hunk 2 (mes_v12_1.c)**:
- Before: `amdgpu_ucode_release(&adev->mes.fw[inst])` inside the
  xcc×pipe double loop, where `inst = xcc_id * AMDGPU_MAX_MES_PIPES +
  pipe` can be up to 15
- After: Separate loop `for (pipe = 0; pipe < AMDGPU_MAX_MES_PIPES;
  pipe++)` outside the xcc loop, using `pipe` (0 or 1) as index

### Step 2.3: Bug Mechanism
**Category**: Buffer overflow / out-of-bounds array access

Bug 1: `mes.fw[AMDGPU_MAX_MES_PIPES]` (size 2) accessed at index `inst`
(up to 15). This is OOB write/read during sw_fini.

Bug 2: `hung_queue_db_array_*[AMDGPU_MAX_MES_PIPES]` (size 2) accessed
at indices up to `AMDGPU_MAX_MES_PIPES * num_xcc - 1` (up to 15). OOB
access during init, fini, and hung queue detection.

### Step 2.4: Fix Quality
- Obviously correct: array sizing matches access patterns
- Minimal and surgical: no unrelated changes
- Regression risk: extremely low — just correcting array bounds and
  indexing
- The `fw[]` fix is semantically correct: firmware IS per-pipe, loaded
  via `amdgpu_mes_init_microcode()` which uses pipe index (verified in
  `amdgpu_mes.c` line 694)

Record: Fix quality is HIGH. Minimal risk of regression. Obviously
correct.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
- The buggy `sw_fini` function was introduced by `e220edf2d6fd6d`
  ("drm/amdgpu/mes_v12_1: initial support for mes_v12_1" by Jack Xiao,
  2025-05-14), which appeared in v7.0-rc1.
- The buggy `hung_queue_db_array_*` array declarations were introduced
  by `d09c7e266c8cd` ("drm/amdgpu/mes: add multi-xcc support" by Jack
  Xiao, 2024-11-21), also in v7.0-rc1.

### Step 3.2: No Fixes: tag present, but root cause commits identified
above.

### Step 3.3: File History
Related commits to `mes_v12_1.c` after initial creation:
- `a5192fbb2ee42`: "fix mes code error for muti-xcc" — different fix for
  different multi-xcc issues
- `75053887d6d8f`: "add cooperative dispatch support" — added
  `shared_cmd_buf_obj` arrays
- Multiple other features added during v7.0 development

### Step 3.4: Author
Le Ma is an AMD engineer who has contributed multiple amdgpu patches.
The fix was reviewed by Hawking Zhang and merged by Alex Deucher, the
AMD DRM maintainer.

### Step 3.5: Dependencies
No prerequisites beyond what's already in v7.0. The fix modifies only
existing code in a self-contained way.

---

## PHASE 4: MAILING LIST RESEARCH

The patch was found at `https://www.spinics.net/lists/amd-
gfx/msg138868.html`, submitted by Alex Deucher on March 6, 2026. It was
a single standalone patch (not part of a series). No objections or NAKs
found in the thread.

Record: No stable nomination in the mailing list discussion. No NAKs or
concerns raised.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
- `mes_v12_1_sw_fini()` — called during driver teardown/module unload

### Step 5.2: Callers of sw_fini
This is registered as the `sw_fini` callback in the amdgpu IP block
framework. It's called during:
- Module unload
- Driver teardown
- Error recovery paths

### Step 5.3: The OOB access in `amdgpu_mes_init()` /
`amdgpu_mes_fini()` (hung_queue arrays)
These are called during driver initialization and teardown — common
paths for any AMD GPU.

### Step 5.4: Reachability
The `hung_queue_db_array_*` OOB accesses are triggered on ANY multi-xcc
GPU (MI300 series) during normal driver init/fini. The `fw[]` OOB is
triggered during driver teardown on multi-xcc.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Which stable trees contain the buggy code?

| Stable Tree | mes_v12_1.c exists? | hung_queue arrays? | multi-xcc
MES? |
|-------------|--------------------|--------------------|---------------
-|
| v6.6        | NO                 | NO (not arrays)    | NO
|
| v6.12       | NO                 | NO                 | NO
|
| v6.19       | NO                 | Scalar, not arrays | NO
|
| **v7.0**    | **YES**            | **YES (buggy)**    | **YES**
|

**The buggy code exists ONLY in v7.0.** The `mes_v12_1.c` file was
created during the 7.0 development cycle. The `hung_queue_db_array_*`
arrays (with multi-xcc indexing) were introduced by `d09c7e266c8cd`
which is also 7.0-only.

### Step 6.2: Backport Complications
The fix should apply cleanly to 7.0.y since the code is identical.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **drm/amdgpu** — AMD GPU driver. IMPORTANT subsystem: used by data
  center GPUs (MI300 series uses multi-xcc), desktop/workstation GPUs.
- Criticality: IMPORTANT (driver-specific but affects high-value
  enterprise hardware)

### Step 7.2: Activity
Extremely active subsystem with many recent commits.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected?
Users with multi-xcc AMD GPUs (MI300 series, data center/AI
accelerators). The single-xcc path (num_xcc = 1) would not trigger the
OOB because `inst` maxes at 1.

### Step 8.2: Trigger conditions
- **hung_queue OOB**: Triggered during driver initialization
  (`amdgpu_mes_init`) — EVERY BOOT on multi-xcc hardware
- **fw[] OOB**: Triggered during driver teardown (`sw_fini`) — every
  module unload or error recovery

### Step 8.3: Failure mode severity
Out-of-bounds array access in kernel structures:
- Can corrupt adjacent struct members in `amdgpu_mes`
- Can cause kernel oops/panic from corrupted pointers
- Severity: **CRITICAL** (memory corruption, potential crash, affects
  every boot on affected hardware)

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: HIGH — prevents memory corruption and potential crashes
  on multi-xcc AMD GPUs
- **Risk**: VERY LOW — 10 lines, obviously correct array sizing and
  indexing fix
- **Ratio**: Very favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes real OOB array accesses (memory corruption)
- Triggered on every boot/shutdown of multi-xcc AMD GPUs
- Small, surgical fix (+6/-4 lines)
- Obviously correct: array sizing matches access patterns
- Reviewed by AMD maintainer (Hawking Zhang)
- Merged by subsystem maintainer (Alex Deucher)
- Self-contained, no dependencies

**AGAINST backporting:**
- Only applicable to 7.0.y (no older stable trees have this code)
- Only affects multi-xcc configurations (MI300 series)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — array sizing fix is trivially
   verifiable
2. Fixes a real bug? **YES** — OOB array access causing memory
   corruption
3. Important issue? **YES** — memory corruption, potential kernel crash
4. Small and contained? **YES** — 10 lines across 2 files in same driver
5. No new features? **YES** — pure bug fix
6. Can apply to stable? **YES** — 7.0.y only, should apply cleanly

### Step 9.3: Exception categories
Not an exception category — this is a standard bug fix.

### Step 9.4: Decision
This is a clear bug fix for out-of-bounds array accesses that cause
memory corruption on multi-xcc AMD GPUs. The fix is small, obvious, and
well-reviewed. It should be backported to the 7.0.y stable tree.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by Le Ma (author), Reviewed-by
  Hawking Zhang, Signed-off-by Alex Deucher (maintainer)
- [Phase 2] Diff analysis: 3 lines in header change array sizes, 4 lines
  in .c restructure fw release loop. Total +6/-4.
- [Phase 2] Confirmed `fw[]` declared as `AMDGPU_MAX_MES_PIPES` (size 2)
  at amdgpu_mes.h:98
- [Phase 2] Confirmed `fw[]` loaded per-pipe in `amdgpu_mes.c:694` using
  pipe index (0 or 1)
- [Phase 2] Confirmed `hung_queue_db_array_*` accessed at index up to
  `AMDGPU_MAX_MES_PIPES * num_xcc` in `amdgpu_mes.c:220,266`
- [Phase 2] Confirmed `AMDGPU_MAX_MES_PIPES = 2`,
  `AMDGPU_MAX_GC_INSTANCES = 8`, `AMDGPU_MAX_MES_INST_PIPES = 16`
- [Phase 3] git blame: `sw_fini` introduced by `e220edf2d6fd6d`
  (v7.0-rc1), hung_queue arrays by `d09c7e266c8cd` (v7.0-rc1)
- [Phase 3] git tag --contains: both commits only in v7.0-rc1, v7.0
- [Phase 3] git show v6.19: `mes_v12_1.c` does not exist;
  `hung_queue_db_array_*` are scalar not arrays; no
  `AMDGPU_MAX_MES_INST_PIPES` macro
- [Phase 3] git show v6.12, v6.6: none of this code exists
- [Phase 4] Found patch on spinics.net amd-gfx list (March 6, 2026),
  standalone patch, no objections
- [Phase 5] `sw_fini` is IP block teardown callback, called during
  driver unload
- [Phase 5] `amdgpu_mes_init()`/`amdgpu_mes_fini()` access hung_queue
  arrays with multi-xcc indices
- [Phase 6] Buggy code exists ONLY in v7.0 tree — not in v6.19, v6.12,
  or v6.6
- [Phase 8] Failure mode: OOB memory access → memory corruption →
  potential kernel crash. Severity CRITICAL on multi-xcc hardware.

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h | 6 +++---
 drivers/gpu/drm/amd/amdgpu/mes_v12_1.c  | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
index bcf2a067dc410..f80e3aca9c78e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -159,9 +159,9 @@ struct amdgpu_mes {
 
 	int				hung_queue_db_array_size;
 	int				hung_queue_hqd_info_offset;
-	struct amdgpu_bo		*hung_queue_db_array_gpu_obj[AMDGPU_MAX_MES_PIPES];
-	uint64_t			hung_queue_db_array_gpu_addr[AMDGPU_MAX_MES_PIPES];
-	void				*hung_queue_db_array_cpu_addr[AMDGPU_MAX_MES_PIPES];
+	struct amdgpu_bo		*hung_queue_db_array_gpu_obj[AMDGPU_MAX_MES_INST_PIPES];
+	uint64_t			hung_queue_db_array_gpu_addr[AMDGPU_MAX_MES_INST_PIPES];
+	void				*hung_queue_db_array_cpu_addr[AMDGPU_MAX_MES_INST_PIPES];
 
 	/* cooperative dispatch */
 	bool                enable_coop_mode;
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
index 7b8c670d0a9ed..d8e4b52bdfd50 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_1.c
@@ -1611,7 +1611,6 @@ static int mes_v12_1_sw_fini(struct amdgpu_ip_block *ip_block)
 			amdgpu_bo_free_kernel(&adev->mes.eop_gpu_obj[inst],
 					      &adev->mes.eop_gpu_addr[inst],
 					      NULL);
-			amdgpu_ucode_release(&adev->mes.fw[inst]);
 
 			if (adev->enable_uni_mes || pipe == AMDGPU_MES_SCHED_PIPE) {
 				amdgpu_bo_free_kernel(&adev->mes.ring[inst].mqd_obj,
@@ -1622,6 +1621,9 @@ static int mes_v12_1_sw_fini(struct amdgpu_ip_block *ip_block)
 		}
 	}
 
+	for (pipe = 0; pipe < AMDGPU_MAX_MES_PIPES; pipe++)
+		amdgpu_ucode_release(&adev->mes.fw[pipe]);
+
 	for (xcc_id = 0; xcc_id < num_xcc; xcc_id++) {
 		if (!adev->enable_uni_mes) {
 			amdgpu_bo_free_kernel(&adev->gfx.kiq[xcc_id].ring.mqd_obj,
-- 
2.53.0

