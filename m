Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403383A381E;
	Mon, 20 Apr 2026 13:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691878; cv=none; b=EABHiucHCsVa3OUm7i+o+SyJ3zR5Vgh3tjf2TIw/NuvSBEVt8rxRCLlu9ppE9POGwH7cyGDDvPpy48zRCTTfQMZevbz2+dzEwyhpypGFjPE/gLNSIAkin7df8/I1G/zCz7WeN/TrNl0UcuBhFi9yY2LJiKTm2evNcHk9ZRJYttI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691878; c=relaxed/simple;
	bh=1VT6tlFrlUK8WOAd+dzOVnbdWLK8JPn8qKU+z7+uWnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ry/TwpTzl4XybFeFvtWk8/JXvZzt8ZNcU8q3OX+5SP7XQG1DG6pmZ1kXBwiocxkEc2CnsJl/QvIo+W+rJjH0IrBcW6oeYucnepZKNSB84VrIH2jvNyvEvGPza4CqG5/5ziKymymditzPO1sSvdsEiUeblkuyl2PeS3znnDef5kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FfCM4MxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FfCM4MxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7659C2BCB4;
	Mon, 20 Apr 2026 13:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691878;
	bh=1VT6tlFrlUK8WOAd+dzOVnbdWLK8JPn8qKU+z7+uWnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfCM4MxTfjwnaoamVCEHCtuPscWiiVHEWtc6HKGpcpBTrwx3hVmv23YkxJaE8ajVM
	 H6GcsLi6wHSDOP7rz/biNjxFDmvr3xOfKNSt6OowuRzmfO+3mVUMY4sYWfCD4XfgXj
	 eknbLIjnY2SzNpC2MqfaIRUK2kYZpoVoFU3dWzGqojIS89aeU+sis/G2RSMyPmR7tW
	 OnarQZzqbrr86ngaoInTSFDRVpU7GkGp3g2qLzTYBmVPVwHFWNrOLr2VC/6RCrBpo7
	 mobJ6yl/hXeqkU8HUAolks8rjnnglPJN3vMXvLI/dMbhyXmnMio+HC6AZnNFLkKgFO
	 hu8dh2oSZOTDg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amd/pm: Avoid overflow when sorting pp_feature list
Date: Mon, 20 Apr 2026 09:20:41 -0400
Message-ID: <20260420132314.1023554-247-sashal@kernel.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit 8e8f6bda8a84f41c4002bca44ac89a5b3f8c7df2 ]

pp_features sorting uses int8_t sort_feature[] to store driver
feature enum indices. On newer ASICs the enum index can exceed 127,
causing signed overflow and silently dropping entries from the output.
Switch the array to int16_t so all enum indices are preserved.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the full walkthrough.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `drm/amd/pm` (AMD GPU power management)
- **Action verb:** "Avoid" (preventing a bug)
- **Summary:** Avoid integer overflow in `sort_feature[]` array when
  enum indices exceed `int8_t` max (127)

### Step 1.2: Tags
- `Signed-off-by: Asad Kamal <asad.kamal@amd.com>` - AMD employee,
  author
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>` - AMD GPU PM subsystem
  reviewer
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` - AMD DRM
  maintainer
- No Fixes: tag, no Cc: stable, no Reported-by (expected for autosel
  candidates)

### Step 1.3: Commit Body
Bug: `int8_t sort_feature[]` stores enum indices that can exceed 127 on
newer ASICs. Signed overflow wraps values to negative, and the
subsequent `< 0` check silently drops those entries from the sysfs
output. Fix: widen to `int16_t`.

### Step 1.4: Hidden Bug Fix Detection
This is explicitly described as an overflow fix. Not hidden.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- 1 file changed: `drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c`
- 1 line added, 1 line removed
- Function modified: `smu_cmn_get_pp_feature_mask()`

### Step 2.2: Code Flow
**Before:** `int8_t sort_feature[MAX(SMU_FEATURE_COUNT,
SMU_FEATURE_MAX)]` - can hold values -128 to 127.
**After:** `int16_t sort_feature[MAX(SMU_FEATURE_COUNT,
SMU_FEATURE_MAX)]` - can hold values -32768 to 32767.

The array is initialized to `-1` via `memset(sort_feature, -1,
sizeof(...))`, then populated with enum index `i` (0 to
`SMU_FEATURE_COUNT-1`). Entries remaining `-1` are skipped via the `< 0`
check. With `int8_t`, any `i >= 128` overflows to a negative value,
falsely triggering the skip.

### Step 2.3: Bug Mechanism
**Integer overflow / type bug.** `SMU_FEATURE_COUNT = 135` (verified by
counting enum entries). Indices 128-134 (7 features: `APT_SQ_THROTTLE`,
`APT_PF_DCS`, `GFX_EDC_XVMIN`, `GFX_DIDT_XVMIN`, `FAN_ABNORMAL`, `PIT`,
`HROM_EN`) overflow `int8_t`, wrapping to negative values and being
silently dropped.

### Step 2.4: Fix Quality
- Obviously correct: widening the type eliminates the overflow
- `memset(-1)` still works correctly: fills all bytes with `0xFF`,
  making each `int16_t` element `0xFFFF = -1` in two's complement
  (confirmed by the author in review discussion and correct by C
  standard)
- No regression risk: the type widening is strictly safe; no logic
  changes
- Minimal and surgical: 1-line change

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
The `int8_t` type was introduced in commit `6f73d6762694c` ("drm/amd/pm:
optimize the interface for dpm feature status query", dated 2022-05-25,
by Evan Quan). Originally (commit `7dbf78051f75f1`, 2020), the array was
`uint32_t sort_feature[SMU_FEATURE_COUNT]` with no overflow possibility.
The refactoring in 6f73d6762694c downsized the type to `int8_t` (using
`-1` as sentinel).

### Step 3.2: Fixes: tag
No Fixes: tag present. The logical "Fixes:" would be `6f73d6762694c`
(introduced `int8_t`) + `25d48f2eb0af1` (pushed enum count past 127).

### Step 3.3: Related Changes
Recent changes to `smu_cmn.c` include significant refactoring of feature
mask handling (`7b88453a476c9` etc.), but none address this specific
overflow.

### Step 3.4: Author
Asad Kamal is an AMD employee who regularly contributes to `drm/amd/pm`.
Multiple recent commits in the subsystem.

### Step 3.5: Dependencies
No dependencies. The fix is self-contained.

## PHASE 4: MAILING LIST DISCUSSION

### Step 4.1: Original Submission
Found via `b4 dig -c 8e8f6bda8a84f`:
https://patch.msgid.link/20260302061242.3062232-1-asad.kamal@amd.com

### Step 4.2: Review Discussion
- **Lijo Lazar** (AMD reviewer): Gave `Reviewed-by` immediately
- **Kevin Wang** raised a concern about `memset(-1)` correctness with
  `int16_t` — asking whether it would correctly initialize all elements
  to `-1`
- **Asad Kamal** correctly explained: "memset fills all bytes with 0xFF.
  For int16_t, that becomes 0xFFFF, which is -1 in two's complement."
- **Kevin Wang** accepted the explanation: "Based on private
  discussions, please continue to submit the code."
- No NAKs, no concerns about the fix itself, only a clarification
  question that was satisfactorily resolved.

### Step 4.3-4.5: No external bug reports. No stable-specific discussion
found.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: Call Chain
`smu_cmn_get_pp_feature_mask()` is called via sysfs: user reads
`pp_features` -> `amdgpu_pm.c:amdgpu_dpm_get_ppfeature_status()` ->
`smu_sys_get_pp_feature_mask()` -> `smu_cmn_get_pp_feature_mask()`. Used
by **17 different GPU backends** (verified: SMU v11, v12, v13, v14, v15
variants).

### Step 5.4: User Reachability
Directly reachable from userspace via sysfs read. Any user or monitoring
tool reading GPU feature status triggers this code.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
- `int8_t` introduced in `6f73d6762694c` (v5.19/v6.0 era)
- Overflow-triggering features added in `25d48f2eb0af1` (v6.12)
- **The overflow is triggerable in v6.12+ stable trees** where both the
  `int8_t` type and the >127 enum count coexist
- For older stable trees (6.6.y, 6.1.y), SMU_FEATURE_COUNT is still <
  128, so no overflow yet — but future backported features could trigger
  it

### Step 6.2: Backport Difficulty
Clean apply expected — the change is a single-line type change with no
context dependencies.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **drm/amd/pm** — AMD GPU power management, IMPORTANT criticality
- Affects all users with AMD GPUs using swSMU (modern AMD GPUs: RDNA2+,
  CDNA)

### Step 7.2: Activity
Very actively developed — many recent commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
All users with AMD GPUs running SMU v14.0.2/3 or newer (Radeon RX 8000
series and similar), or any ASIC whose feature mapping exceeds index
127.

### Step 8.2: Trigger Conditions
- **Trigger:** Any read of `pp_features` sysfs node
- **Frequency:** Common — monitoring tools, manual inspection, power
  management tools read this
- **Unprivileged:** Yes, sysfs readable by any user

### Step 8.3: Severity
- **MEDIUM:** Incorrect/incomplete sysfs output. Not a crash or security
  issue, but features are silently dropped, making power management
  monitoring unreliable.

### Step 8.4: Risk-Benefit
- **Benefit:** Fixes incorrect sysfs output for AMD GPU users; prevents
  silent data loss in feature reporting
- **Risk:** Extremely low — 1-line type change, no logic modification,
  correctness of `memset(-1)` with `int16_t` verified in review and
  mathematically sound
- **Stack increase:** `sort_feature` grows from 128 bytes
  (`int8_t[128]`) to 256 bytes (`int16_t[128]`); negligible for a stack-
  allocated array

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes a real, verifiable integer overflow bug
- SMU_FEATURE_COUNT = 135 > 127, confirmed to overflow `int8_t`
- 7 power management features silently dropped from sysfs output
- 1-line fix, obviously correct, minimal risk
- Reviewed by AMD engineer, no objections after clarification
- Used by 17 GPU backends across all modern AMD GPUs
- Signed off by Alex Deucher (AMD DRM maintainer)

**AGAINST backporting:**
- Not a crash or security issue (incorrect output only)
- Only affects v6.12+ trees where enum count exceeds 127
- No Fixes: tag or Cc: stable

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — trivial type widening,
   reviewed
2. **Fixes a real bug?** YES — integer overflow causing features to be
   silently dropped
3. **Important issue?** MEDIUM — not crash/security, but correctness bug
   in user-visible output
4. **Small and contained?** YES — 1 line, 1 file
5. **No new features or APIs?** Correct — no new features
6. **Can apply to stable?** YES — clean apply expected

### Step 9.3: Exception Categories
None applicable — this is a standard bug fix.

### Step 9.4: Decision
This is a clean, minimal, well-reviewed bug fix for a verifiable integer
overflow that causes incorrect user-visible behavior on modern AMD GPUs.
It meets all stable criteria.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Lijo Lazar, SOB from Alex Deucher
  (AMD maintainer)
- [Phase 2] Diff analysis: 1 line changed, `int8_t` -> `int16_t` in
  `smu_cmn_get_pp_feature_mask()`
- [Phase 2] Verified SMU_FEATURE_COUNT = 135 by counting enum entries in
  `smu_types.h` — 7 features exceed index 127
- [Phase 3] git blame: `int8_t` introduced in `6f73d6762694c`
  (v5.19/v6.0 era, Evan Quan, 2022)
- [Phase 3] Overflow-triggering features added in `25d48f2eb0af1`
  (v6.12, 2024-09-10)
- [Phase 3] Original type was `uint32_t` in `7dbf78051f75f1` (2020) — no
  overflow possible
- [Phase 4] b4 dig -c found submission:
  https://patch.msgid.link/20260302061242.3062232-1-asad.kamal@amd.com
- [Phase 4] b4 dig -w: AMD team members CC'd (lijo.lazar, hawking.zhang,
  le.ma, alexander.deucher, kevinyang.wang)
- [Phase 4] Review discussion decoded from base64: Kevin Wang raised
  memset concern, Asad explained correctly, Kevin approved
- [Phase 5] Traced call chain: sysfs read ->
  `amdgpu_dpm_get_ppfeature_status()` -> `smu_sys_get_pp_feature_mask()`
  -> target function
- [Phase 5] Verified 17 GPU backends use this function (SMU v11, v12,
  v13, v14, v15)
- [Phase 6] Bug triggerable in v6.12+ (both int8_t type and >127 enum
  present)
- [Phase 8] Severity: MEDIUM (incorrect sysfs output, not
  crash/security)
- [Phase 8] Risk: Very low (1-line type change, no logic change, stack
  grows by 128 bytes)

**YES**

 drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
index 6fd50c2fd20e0..97ed66cb47472 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu_cmn.c
@@ -880,7 +880,7 @@ static const char *smu_get_feature_name(struct smu_context *smu,
 size_t smu_cmn_get_pp_feature_mask(struct smu_context *smu,
 				   char *buf)
 {
-	int8_t sort_feature[MAX(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
+	int16_t sort_feature[MAX(SMU_FEATURE_COUNT, SMU_FEATURE_MAX)];
 	struct smu_feature_bits feature_mask;
 	uint32_t features[2];
 	int i, feature_index;
-- 
2.53.0

