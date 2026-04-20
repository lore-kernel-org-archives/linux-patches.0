Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D223A63E8;
	Mon, 20 Apr 2026 13:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691594; cv=none; b=W+q/TrH1Ng5ZyxMJ/YTNC4Y+kVdu3tRdtJ8ffMPtOWZfVDX/Q8EW9tYkb9sDSmne/L1dnejWR76Kxaryv89nvUSc4bmT0e8pdqDtTbK2ASIVJrPJtYhr02j0YT2KJyZSnC9XeAM7BK3D36PD3f89mF9hNAUGKzwtQlgK6jak+uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691594; c=relaxed/simple;
	bh=wLTZhSqR6+iIGqqUoKmdfZoxBhEtjG1NaYbhHbNN0a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bYvBj2Z0blq6EEM1kh+wkmTewT56gfJoZtAgqVDycTJi7MUsuRQrHYF85Ih4rwEg97yZxezt6F0H6g3og/ElDSEAHgiYbvxcB+BAmTfAcOt8EKLjXH1IjVVPuDzM8a1wyIN004y6vpZ+o/35TRU4UBt0MbA16BmLvlymaxQDN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn9QGgbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn9QGgbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0876C19425;
	Mon, 20 Apr 2026 13:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691594;
	bh=wLTZhSqR6+iIGqqUoKmdfZoxBhEtjG1NaYbhHbNN0a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dn9QGgbWkI27tbZ0droPAldajP8QNGjCS1mVi8nJmAqveOIcLjQRTC8yInb2d1t8i
	 FZK8LVvssVDD92HJEHk3nmTVhaTmwq338jerKaxfGokkqCUby45RVHZatW/shA8Q3R
	 ySqxcr9pzBzkYChEQhJPey3Y5HZAz1w+QKzRULTZIvx7pZnQpQmA3FE+w4a2E1QQfe
	 dov/YNnluz+ywMEtqSO+ARjUYcHyMzql07ujydFkk9U3SS86++EPyRcj5gSip+c+oo
	 5uEOQEbrDf5nNijI77kVLK5OSanKBoUhtIh4I8ruFaxZVViZv0UHAn5SMmvzPbq7z3
	 B+Rdb4ku65kwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Hawking Zhang <Hawking.Zhang@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] drm/amdgpu: fix shift-out-of-bounds when updating umc active mask
Date: Mon, 20 Apr 2026 09:18:35 -0400
Message-ID: <20260420132314.1023554-121-sashal@kernel.org>
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

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit 1394a4926f4bcff0dc6ac6deea5beeb2844297f0 ]

UMC node_inst_num can exceed 32, causing
(1 << node_inst_num) to shift a 32-bit int
out of bounds

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a comprehensive analysis. Let
me compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu`
- Action verb: "fix"
- Summary: Fixes shift-out-of-bounds when computing UMC active mask
Record: [drm/amdgpu] [fix] [shift-out-of-bounds in UMC active mask
calculation]

**Step 1.2: Tags**
- Signed-off-by: Hawking Zhang (author), Alex Deucher (maintainer)
- Reviewed-by: Likun Gao
- No Fixes: tag, no Reported-by:, no Cc: stable (expected for a
  candidate commit)
Record: Patch reviewed by AMD colleague, signed off by amdgpu maintainer
Alex Deucher. No bug reporter or explicit stable nomination.

**Step 1.3: Commit Body**
The commit message is concise: `node_inst_num` can exceed 32, causing
`(1 << node_inst_num)` to shift a 32-bit int out of bounds. This is
undefined behavior in C.
Record: Bug = shift of a 32-bit `1` by >= 32 positions. Symptom =
undefined behavior, incorrect computation of `umc.active_mask`. Root
cause = using `int` literal `1` instead of `1ULL` for a shift that can
reach 32 or more.

**Step 1.4: Hidden Bug Fix Detection**
Not hidden at all - the subject says "fix" and the bug mechanism is
clearly stated.
Record: This is a straightforward bug fix for UB.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed: `drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c`
- 2 lines changed: `uint32_t` -> `u64` (variable type) and `1` -> `1ULL`
  (shift operand)
- Function modified: `amdgpu_discovery_read_from_harvest_table()`
Record: Single-file, 2-line surgical fix. Scope is minimal.

**Step 2.2: Code Flow Change**

Hunk 1 (line 777 equivalent):
- Before: `uint32_t umc_harvest_config = 0;` (32-bit variable)
- After: `u64 umc_harvest_config = 0;` (64-bit variable)
- Purpose: Allow storing harvest config bits for node instances >= 32

Hunk 2 (line 833):
- Before: `((1 << adev->umc.node_inst_num) - 1)` — `1` is `int` (32
  bits); shifting by >= 32 is UB
- After: `((1ULL << adev->umc.node_inst_num) - 1ULL)` — `1ULL` is
  `unsigned long long` (64 bits); safe for node_inst_num up to 63

Record: The fix widens both the intermediate shift result and the
accumulation variable to 64 bits, eliminating the UB.

**Step 2.3: Bug Mechanism**
This is category (f) **type/correctness fix** — specifically, a shift-
out-of-bounds / undefined behavior fix. In C, shifting an `int` by >=
its bit width (32) is undefined behavior per the standard. The result is
unpredictable and could yield an incorrect `active_mask`, which is used
to track which UMC (memory controller) instances are active.
Record: [Type/UB bug] [32-bit shift by >= 32 causes UB; fix uses 64-bit
types]

**Step 2.4: Fix Quality**
- Obviously correct: widening types to match the range of possible
  values is textbook UB fix
- Minimal/surgical: 2 lines
- Regression risk: extremely low — only changes type widths;
  `active_mask` is already `unsigned long` (64 bits on 64-bit systems)
Record: Fix is obviously correct, minimal, with near-zero regression
risk.

---

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
From git blame, the buggy code at lines 777 and 833 was introduced by
commit `2b595659d5aec7` (Candice Li, Feb 2023) — "drm/amdgpu: Support
umc node harvest config on umc v8_10". This commit was first included in
v6.4.
Record: Bug introduced in v6.4, present in all stable trees since
(6.6.y, 6.12.y, etc.).

**Step 3.2: Original Buggy Commit**
Verified via `git merge-base --is-ancestor`: commit 2b595659d5aec7 is
NOT in v6.1 or v6.3, but IS in v6.4 and v6.6.
Record: Bug exists in stable trees 6.4+, 6.6+. NOT in 6.1.y.

**Step 3.3: File History**
Recent changes to the file are mostly kmalloc refactoring (tree-wide
changes) and an IP block addition. No conflicting fixes for this
specific issue.
Record: Standalone fix, no prerequisites needed.

**Step 3.4: Author**
Hawking Zhang is a prolific AMD GPU contributor with 10+ recent commits
to the amdgpu subsystem, working on IP blocks, initialization, and RAS
features. He is an AMD engineer and a core contributor to this
subsystem.
Record: Author is a core amdgpu developer at AMD.

**Step 3.5: Dependencies**
The diff context shows `amdgpu_discovery_get_table_info()` and `struct
table_info *info`, which are NOT present in the 7.0 tree (which uses
`struct binary_header *bhdr` and direct access). The actual fix lines
(`uint32_t` -> `u64` and `1` -> `1ULL`) are present in both versions.
Record: Minor context differences for backport, but the fix itself is
trivially adaptable.

---

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** b4 dig could not find the original buggy commit on
lore (AMD GPU patches often go through freedesktop.org/amd-gfx list
rather than lore). Web search found related shift-out-of-bounds fixes in
the amdgpu subsystem but not the exact commit being analyzed — it may be
very recent (2026).
Record: Could not find the exact patch thread. This is common for AMD
GPU patches which flow through the amd-gfx list.

**Step 4.3-4.5:** No bug reports or stable-specific discussions found
for this exact issue.
Record: No external bug reports found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
Modified function: `amdgpu_discovery_read_from_harvest_table()`

**Step 5.2-5.3: Impact Surface**
`adev->umc.active_mask` is used by:
1. `LOOP_UMC_NODE_INST()` macro — iterates over active UMC nodes for RAS
   error counting
2. `amdgpu_umc_loop_all_aid()` — iterates over UMC instances for RAS
   queries
3. `amdgpu_psp.c` — passed to PSP firmware as `active_umc_mask`

An incorrect `active_mask` could cause:
- Missing or incorrect RAS error reporting
- Wrong UMC instances being queried for errors
- Incorrect firmware configuration
Record: active_mask affects RAS error handling and firmware
configuration.

**Step 5.4: Call Chain**
`amdgpu_discovery_read_from_harvest_table()` is called during GPU
initialization (probe path). This is a one-time setup function, but its
result persists for the lifetime of the driver.
Record: Called during init, result affects ongoing UMC/RAS operations.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:** The buggy code was introduced in v6.4 (commit
2b595659d5aec7). It exists in stable trees 6.6.y and later.
Record: Bug exists in 6.6.y, 6.12.y, and 7.0.y.

**Step 6.2:** The patch context differs slightly between the diff and
the 7.0 tree (helper function refactoring). The actual fix lines apply
conceptually with minor context adjustment.
Record: May need minor context adaptation for clean apply.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** drm/amdgpu is an IMPORTANT subsystem (widely used GPU
driver on AMD hardware).
**Step 7.2:** Very actively developed.
Record: [IMPORTANT] [Very active subsystem]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of AMD GPUs with >= 32 UMC node instances
(large server/datacenter GPUs like MI300 series, where `node_inst_num`
can reach 32+).
Record: Driver-specific, primarily affects large AMD datacenter GPUs.

**Step 8.2:** Triggers during GPU initialization when the hardware has
>= 32 UMC instances. Deterministic, not a race condition.
Record: Deterministic trigger on specific hardware configurations.

**Step 8.3:** The undefined behavior from the shift can produce an
incorrect `active_mask`, leading to wrong RAS error reporting and
potentially incorrect firmware configuration. While not a crash, UB can
cause any result including crashes on some compilers/architectures.
Record: Severity = MEDIUM-HIGH (UB, incorrect hardware config, potential
RAS malfunction).

**Step 8.4:**
- BENEFIT: Fixes real UB on production hardware (large AMD GPUs),
  ensures correct memory controller tracking
- RISK: 2-line type widening change, extremely low risk of regression
Record: High benefit, very low risk.

---

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR backporting:**
- Fixes undefined behavior (shift-out-of-bounds) that is a clear
  violation of the C standard
- Affects real hardware (AMD GPUs with >= 32 UMC instances, e.g., MI300
  series)
- Minimal, 2-line fix that is obviously correct
- Reviewed by AMD engineer, signed off by amdgpu maintainer
- `active_mask` is used in RAS (reliability) error handling — getting
  this wrong affects hardware reliability monitoring
- Bug has existed since v6.4, present in all current stable trees except
  6.1.y
- Pattern matches other accepted stable fixes (shift-type fixes in
  amdgpu, e.g., `BIT()` -> `BIT_ULL()`)

**Evidence AGAINST backporting:**
- No Fixes: tag (expected)
- No explicit bug report or syzbot report
- Impact is limited to specific large GPU configurations
- Context differs slightly from stable trees (may need minor adaptation)

**Stable Rules Checklist:**
1. Obviously correct and tested? **YES** — type widening is trivially
   correct
2. Fixes a real bug? **YES** — undefined behavior per C standard
3. Important issue? **YES** — UB can cause incorrect hardware
   configuration
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features/APIs? **YES** — pure fix
6. Can apply to stable? **YES** — with minor context adaptation

---

## Verification

- [Phase 1] Parsed subject: "drm/amdgpu: fix shift-out-of-bounds" —
  clear fix commit
- [Phase 2] Diff analysis: 2 lines changed — `uint32_t` -> `u64` and `1`
  -> `1ULL` in `amdgpu_discovery_read_from_harvest_table()`
- [Phase 3] git blame: buggy code introduced by commit 2b595659d5aec7
  (Candice Li, Feb 2023, v6.4)
- [Phase 3] git merge-base: confirmed commit 2b595659d5aec7 is in v6.4
  and v6.6, NOT in v6.1
- [Phase 3] git log --author: Hawking Zhang is a prolific AMD GPU
  contributor
- [Phase 4] b4 dig: could not find original submission on lore (AMD GPU
  patches go through freedesktop.org)
- [Phase 4] Web search: found related shift fixes in amdgpu but not
  exact patch thread
- [Phase 5] Grep: `active_mask` is `unsigned long` (64-bit), used by
  LOOP_UMC_NODE_INST macro, PSP firmware init, and RAS error queries
- [Phase 5] Grep: `node_inst_num` is `uint32_t`, incremented per
  UMC_HWID found; on gmc_v9_0, divided by 4 (can be 32+ on large GPUs)
- [Phase 6] Code exists in stable trees 6.6.y+; context differs slightly
  (bhdr vs table_info helper)
- [Phase 8] Failure mode: UB from shift, potentially incorrect
  active_mask affecting RAS operations
- UNVERIFIED: Exact patch discussion on amd-gfx mailing list (not found
  via search)
- UNVERIFIED: Whether UBSAN has actually fired on this in practice (no
  syzbot report)

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index af3d2fd61cf3f..32455b01bceb1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -774,7 +774,7 @@ static void amdgpu_discovery_read_from_harvest_table(struct amdgpu_device *adev,
 	struct harvest_table *harvest_info;
 	u16 offset;
 	int i;
-	uint32_t umc_harvest_config = 0;
+	u64 umc_harvest_config = 0;
 
 	bhdr = (struct binary_header *)discovery_bin;
 	offset = le16_to_cpu(bhdr->table_list[HARVEST_INFO].offset);
@@ -830,7 +830,7 @@ static void amdgpu_discovery_read_from_harvest_table(struct amdgpu_device *adev,
 		}
 	}
 
-	adev->umc.active_mask = ((1 << adev->umc.node_inst_num) - 1) &
+	adev->umc.active_mask = ((1ULL << adev->umc.node_inst_num) - 1ULL) &
 				~umc_harvest_config;
 }
 
-- 
2.53.0

