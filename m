Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CB40B6F2;
	Mon, 20 Apr 2026 13:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691635; cv=none; b=iyjDbmZH23iTcDh3vWByH/y/Mnrtj3D8epieedKO9OF1jAFknHUIUSQ4ondTz57tF8EPxCT3oo/ROYUEMsyOK01pZLGH5ZA6GwortDu6UDR0z5I2FRAaPXRcS2Yvf2myzji6mMTr/34xesHHk0NvGS7QeQnHZBTYUHyu4s2jWFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691635; c=relaxed/simple;
	bh=AJQ6JA3bSWogChV6szT/AXSZNnysG8AiXpnlWdYNJjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B2CcsN/MJyo25bjimjFBr39v+wZYbiUk4HRJU64S+vVP9EvGlCphCRvUbR/mpyy1nr4CU4QhPtjRJQc0fV3GVgwLuWqmJP+FeeL9tkjWzj7MpjOetnWcowRcBxYaMMxo6I7FXj7m5lwqN4ZbdQmwaadiLCryTeQAubxwDmlLpiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lGStd/FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lGStd/FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82705C2BCB4;
	Mon, 20 Apr 2026 13:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691635;
	bh=AJQ6JA3bSWogChV6szT/AXSZNnysG8AiXpnlWdYNJjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGStd/FUrUVmw23PO1ZGtELZMxA6Mb/83qvzOVby8miighiW7p+UcXs6QqlTOkgfr
	 Lqd8luMNOHd04G4NrwSiT3Gif599v4UHvSLwemSpu/qGCp3JcWPL27jxeIfQkcHDEQ
	 SV0IJbc6omQhZ1cAwnYIc1Cf6wNmmieGBpNt5hxLmT41VSF1qylR1e6tIvccTB59sm
	 APxnwoSF/LmQ0Ody00Pj0v9N1gcdTy2c75YvS6Kag0s7h55CDDQLunG4nQjKscrvKi
	 8H5sU4uu071Mrh14rwEB5LKm9X/EdS2LCeZ+Guc/XEpIbaUGzFzxr65hq45zMfZtB+
	 xtQ0u/PTruveA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu: clear related counter after RAS eeprom reset
Date: Mon, 20 Apr 2026 09:18:58 -0400
Message-ID: <20260420132314.1023554-144-sashal@kernel.org>
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

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 3d77ca68eb0b48f88cc891d1b98f109b68e2ffcf ]

Make eeprom data and its counter consistent.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/amdgpu` (AMD GPU driver, RAS subsystem)
- **Action verb**: "clear" (indicating missing cleanup / consistency
  fix)
- **Summary**: Clear the `count_saved` counter when RAS EEPROM table is
  reset

Record: [drm/amdgpu] [clear] [Ensure count_saved is zeroed when EEPROM
table is reset]

### Step 1.2: Tags
- **Signed-off-by**: Tao Zhou (author, regular AMD RAS contributor)
- **Reviewed-by**: Hawking Zhang (AMD subsystem lead for RAS)
- **Signed-off-by**: Alex Deucher (AMD GPU maintainer, final commit)
- No Fixes: tag, no Reported-by:, no Cc: stable

Record: Author is a regular AMD RAS contributor. Reviewed by AMD's RAS
lead.

### Step 1.3: Commit Body
- "Make eeprom data and its counter consistent"
- Terse description, but the intent is clear: a data consistency issue
  between EEPROM state and in-memory counters.

Record: Bug is a data consistency issue. After EEPROM reset,
`count_saved` retains a stale value while all other counters are zeroed.

### Step 1.4: Hidden Bug Fix Detection
This is a data consistency bug disguised as a minor cleanup. The word
"consistent" signals that the code was **inconsistent** before—i.e., the
counter was wrong after a reset. This is a real bug fix.

Record: Yes, this is a hidden bug fix. The "consistent" language masks
the fact that stale `count_saved` causes wrong data to be written to
EEPROM on subsequent saves.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files**: 1 file modified (`amdgpu_ras_eeprom.c`)
- **Lines**: +3 (one comment, one NULL check, one assignment)
- **Function modified**: `amdgpu_ras_eeprom_reset_table()`
- **Scope**: Single-file surgical fix

### Step 2.2: Code Flow Change
- **Before**: `amdgpu_ras_eeprom_reset_table()` zeroed `ras_num_recs`,
  `ras_num_bad_pages`, `ras_num_mca_recs`, `ras_num_pa_recs`, `ras_fri`,
  `bad_channel_bitmap`, and `update_channel_flag`, but left
  `eh_data->count_saved` unchanged.
- **After**: Also zeroes `con->eh_data->count_saved` (with NULL guard on
  `eh_data`).

### Step 2.3: Bug Mechanism
This is a **data consistency / correctness bug**. `count_saved` is used
as an array index in `amdgpu_ras_save_bad_pages()`:

```3341:3341:drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
                                        &data->bps[data->count_saved],
unit_num)) {
```

If EEPROM is reset but `count_saved` retains value N from before, the
next save operation starts writing from `bps[N]` instead of `bps[0]`.
This means:
1. **Wrong data is written to EEPROM** (skipping the first N entries)
2. **Potential out-of-bounds access** if bps array was reorganized

There are direct call sequences that trigger this: `reset_table` ->
`save_bad_pages` at lines 1783-1784 and 3837-3838.

### Step 2.4: Fix Quality
- Obviously correct: when all EEPROM records are cleared, the "saved
  count" must be 0
- Minimal: 3 lines, single variable assignment with NULL guard
- No regression risk: the NULL check prevents any potential NULL deref

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The reset function's body was built incrementally since v5.3 (2019) by
Andrey Grodzovsky, with additions by Luben Tuikov (2021), Stanley Yang
(2022), and Tao Zhou (2024). The `count_saved` field was introduced in
commit d45c5e6845a76 by Tao Zhou (2025-07-04), first appearing in v6.18.

### Step 3.2: No Fixes: tag
No Fixes: tag present. The logical "fixes" target would be d45c5e6845a76
which introduced `count_saved` without clearing it in the reset path.

### Step 3.3: File History
The file is actively developed with 20+ recent commits. Patch 1/2 of
this series ("compatible with specific RAS old eeprom format") modifies
`amdgpu_ras.c` and is thematically related but functionally independent.

### Step 3.4: Author
Tao Zhou is a frequent AMD RAS contributor (10+ recent commits to RAS
code) and the same author who introduced `count_saved`.

### Step 3.5: Dependencies
- **Requires** d45c5e6845a76 (introduces `count_saved` field) - present
  only in v6.18+
- **Does NOT depend on** patch 1/2 of the series (separate bug fix)
- Standalone fix

---

## PHASE 4: MAILING LIST RESEARCH

- Found at `lists.freedesktop.org/archives/amd-
  gfx/2026-February/139281.html`
- Part of a 2-patch series; b4 dig did not find a match (AMD internal
  submission path)
- Reviewed-by from Hawking Zhang (AMD RAS lead) for the entire series
- No NAKs or concerns raised
- No explicit stable nomination by reviewers

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function/Caller Analysis
`amdgpu_ras_eeprom_reset_table()` is called from:
1. **`amdgpu_ras_debugfs_eeprom_write()`** - user-triggered via debugfs
   (privileged only)
2. **`amdgpu_ras_eeprom_init()`** - during driver initialization (new
   table creation)
3. **`amdgpu_ras_eeprom_check_and_recover()`** - reset + immediate
   save_bad_pages
4. **`amdgpu_ras_init_badpage_info()`** - reset + immediate
   save_bad_pages (format upgrade path)

Call sites 3 and 4 are the dangerous ones: they call `reset_table`
immediately followed by `save_bad_pages`, which will use the stale
`count_saved` as an array index.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Which stable trees have the buggy code?
`count_saved` was introduced in d45c5e6845a76, first in v6.18. This fix
is only relevant for **v6.18.y and newer** stable trees.

### Step 6.2: Backport Difficulty
The patch is 3 lines, no surrounding context changes. Clean apply
expected on any tree containing d45c5e6845a76.

---

## PHASE 7: SUBSYSTEM CONTEXT

- **Subsystem**: drm/amdgpu RAS (Reliability, Availability,
  Serviceability)
- **Criticality**: IMPORTANT - RAS tracks and retires bad GPU memory
  pages. Incorrect tracking means potentially using defective memory, or
  incorrectly retiring good memory.
- Active subsystem with frequent development.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with AMD GPUs that support RAS (datacenter GPUs like MI200, MI300
series). This is a significant enterprise/HPC user population.

### Step 8.2: Trigger Conditions
- Triggered when EEPROM table is reset and new bad pages are
  subsequently saved
- Can occur during: checksum recovery (automatic), table format upgrade
  (automatic), debugfs user action

### Step 8.3: Failure Mode
- **Data corruption**: Wrong records written to EEPROM (persists across
  reboots)
- **Potential OOB access**: If `count_saved` points beyond current `bps`
  array bounds
- Severity: **MEDIUM-HIGH** - corrupted RAS data means bad memory pages
  might not be properly tracked

### Step 8.4: Risk-Benefit
- **Benefit**: Prevents EEPROM data corruption and potential OOB access.
  Medium-high benefit for datacenter GPU users.
- **Risk**: Very low. 3 lines, single variable zeroed with NULL guard.
  Impossible to introduce a regression.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence

**FOR backporting:**
- Fixes a real data consistency bug: stale `count_saved` causes wrong
  data written to EEPROM
- Potential OOB array access from stale index
- 3-line fix, surgical, obviously correct
- Reviewed by AMD RAS subsystem lead (Hawking Zhang)
- Author is the same person who introduced `count_saved` (understands
  the code)
- Direct trigger paths exist (reset_table -> save_bad_pages sequences)
- Affects enterprise/datacenter GPU users (RAS is critical for data
  integrity)

**AGAINST backporting:**
- Only applicable to v6.18+ trees (where `count_saved` exists)
- No user-reported crash or bug report - preventive fix by the developer
- Limited user population (AMD datacenter GPUs with RAS)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** - zeroing a counter when table
   is reset is trivially correct
2. Fixes a real bug? **YES** - stale index causes wrong EEPROM writes
   and potential OOB access
3. Important issue? **YES** - data corruption of persistent RAS bad page
   table
4. Small and contained? **YES** - 3 lines in 1 file
5. No new features? **YES** - pure fix
6. Can apply to stable? **YES** - clean apply on v6.18+

### Step 9.3: Exception Categories
Not applicable (standard bug fix, not a quirk/ID/DT addition).

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Hawking Zhang, Signed-off-by Alex
  Deucher, Tao Zhou as author
- [Phase 2] Diff analysis: 3 lines added in
  `amdgpu_ras_eeprom_reset_table()`, clearing `count_saved` with NULL
  guard
- [Phase 2] Traced `count_saved` usage: used as array index in
  `amdgpu_ras_save_bad_pages()` at lines 3341, 3348
- [Phase 3] git blame: surrounding code added by various AMD developers
  2019-2024; `count_saved` introduced in d45c5e6845a76 (v6.18)
- [Phase 3] git merge-base --is-ancestor: confirmed d45c5e6845a76 NOT in
  v6.17, IS in v6.18
- [Phase 3] Author check: Tao Zhou has 10+ recent RAS commits,
  introduced `count_saved` himself
- [Phase 4] Found patch discussion at lists.freedesktop.org, Hawking
  Zhang reviewed both patches
- [Phase 4] Series is 2/2, patch 1/2 is independent (different file,
  different bug)
- [Phase 5] Traced callers of `amdgpu_ras_eeprom_reset_table`: found 4
  call sites, 2 immediately follow with `save_bad_pages` (lines
  1783-1784, 3837-3838) - confirming the bug is triggerable
- [Phase 6] Fix only applies to v6.18+ stable trees
- [Phase 8] Failure mode: wrong records written to EEPROM (data
  corruption), potential OOB array access

The fix is small, surgical, obviously correct, and addresses a real data
consistency bug that can cause EEPROM corruption and potential out-of-
bounds access. It meets all stable kernel criteria for applicable trees
(v6.18+).

**YES**

 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 6fba9d5b29ea6..44fba4b6aa92a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -508,6 +508,9 @@ int amdgpu_ras_eeprom_reset_table(struct amdgpu_ras_eeprom_control *control)
 	control->bad_channel_bitmap = 0;
 	amdgpu_dpm_send_hbm_bad_channel_flag(adev, control->bad_channel_bitmap);
 	con->update_channel_flag = false;
+	/* there is no record on eeprom now, clear the counter */
+	if (con->eh_data)
+		con->eh_data->count_saved = 0;
 
 	amdgpu_ras_debugfs_set_ret_size(control);
 
-- 
2.53.0

