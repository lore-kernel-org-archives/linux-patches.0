Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CE1509EEB;
	Mon, 19 Oct 2026 13:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418104; cv=none; b=rGDQOeEy+G8Ck/8wCBpFSn1uIP1z/pKvaqtpNvJ7a8/3OYroIM3s8G5iSx9zJWM69eKk2rsEnRfLHwaA6dY21qLzZy+EPdR5qTZtYk1SxMo2uOyH/6+c5/MgnTyp02tLD/hm0NliBnRgGaiLwOWBGvpm6c19fKA33tSBrY9/PiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418104; c=relaxed/simple;
	bh=DakqrA9y3AHrpg1aWOp18RegMHVVjlWOXKNc4PTb6Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lSwyTRTIZ2hgqMvyoka7jm56OrHsJhZgnFRlX0saLmV914p1ny2MiRuigf5fVfeW1C60Nfz8XNgxNKJg89TmFASy3JT24iilbLHavmdzcHgMydAmEutQHMS+EMble8RdzBLgXbarNEtE1AvW8x03zjlXXraHTcG9y0weYznppXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c4ZDmwY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c4ZDmwY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC6C1F000C5;
	Mon, 19 Oct 2026 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418101;
	bh=fvrPgiYUc6CpeaWUNjtwgn7ycls/DoGi4go9Us7AXbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c4ZDmwY0s1V7ID8N3HpRfzLRv7eYK8Ge+qSZRanqqLM6KWec/hElysxf2v94LLtWW
	 jmfKApPRQtKF5b3l3xqwMflzkkhP/ETsGjGmqHMwR1L4OzCMBzujoayTmNEHvu8ewA
	 yvYmOUIyH3dTLV3hBkBMj3S9fc8YEvCQT1FrdHt/tDfxInUtegFU5D8GPM1J/YDq6N
	 6R7kB91JP0WecbXhDLb/BiG4Uc2QGJ4w0jO5xd2w0ulNWL/YNSnhv/lctN0Ng082zw
	 DTsGT45tGgtcwyUmsf5j0kFCbSLO/VCMfamE6uToGXSjFRl0OLEziMSNAkGXKwaqpu
	 KxT0VpoLpmerg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yang Wang <kevinyang.wang@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	kenneth.feng@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/amd/pm: Validate Vega hwmgr PowerPlay table bounds
Date: Mon, 19 Oct 2026 09:45:04 -0400
Message-ID: <20261019135441.1420968-13-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Wang <kevinyang.wang@amd.com>

[ Upstream commit 3a8d8e0b7f61cd759d5d4870b6220161f8a5b114 ]

The Vega hwmgr PowerPlay table parsers read fixed table fields,
state array entries, or SMC PPT fields before validating that the
VBIOS table buffer covers those structures. A truncated table can
therefore lead to out-of-bounds reads during hwmgr initialization.

Reject tables smaller than the fixed PowerPlay table. For Vega10, also
validate the state array offset and entry range before dereferencing
the state array.

Signed-off-by: Yang Wang <kevinyang.wang@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: the 6.18.53 tree still has the unvalidated Vega
parsers, the patch applies cleanly, and it closes a real out-of-bounds
read on init and `pp_table` upload.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amd/pm] [Validate] Vega hwmgr PowerPlay table bounds` —
add missing size/offset checks before parsing Vega10/12/20 PowerPlay
tables.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Yang Wang <kevinyang.wang@amd.com>` (author)
- `Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>` (AMD)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (drm/amd
  maintainer)
- Pipeline-added tags ignored per instructions (`[Upstream commit
  3a8d8e0b7f61...]`, `Signed-off-by: Sasha Levin`)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable`, `Link:`, or
  syzbot tags (absence is expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: Vega hwmgr parsers read fixed PowerPlay fields, Vega10 state-
  array entries, or Vega12/20 SMC PPT fields without checking that
  `soft_pp_table` is large enough.
- Symptom: out-of-bounds reads during hwmgr initialization (GPU probe /
  table re-init).
- Root cause: truncated or offset-corrupt VBIOS/custom PPTable; pointer
  arithmetic from `usStateArrayOffset` and struct-sized reads happen
  before a size check.
- No specific kernel-version range in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit memory-safety fix (OOB read). Also
corrects `entry_index <= ucNumEntries` to `<` (off-by-one).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `vega10_processpptables.c`: +43/−21 (refactor `check_powerplay_tables`
  into `get_vega10_state_array`; reuse it from entry lookup)
- `vega12_processpptables.c`: +7
- `vega20_processpptables.c`: +7
- Net: 52 insertions, 21 deletions; three files, one subsystem
- Functions: `get_vega10_state_array` (new), `check_powerplay_tables`
  (all three), `vega10_get_number_of_powerplay_table_entries`,
  `vega10_get_powerplay_table_entry`
- Scope: surgical, same-family parsers only

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Vega10 before: `check_powerplay_tables` / entry getters add
  `usStateArrayOffset` to the table pointer, then read `ucNumEntries`
  with no size check. Offset/revision checks happen *after* that
  dereference.
- Vega10 after: require `soft_pp_table_size >=
  sizeof(*powerplay_table)`; then offset `<= table_size -
  sizeof(*state_arrays)`; then `struct_size(..., ucNumEntries) <=
  remaining`.
- Vega12/20 before: only format_revision / structuresize (and Vega20 SMC
  version).
- Vega12/20 after: also `table_size >= offsetofend(..., smcPPTable)`
  before those field reads.
- Vega10 entry lookup: `entry_index <= ucNumEntries` → `entry_index <
  ucNumEntries`.
- Path: init/error-reject of bad tables, not a new feature path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / OOB read**, plus a **logic off-by-one**.
- Mechanism: VBIOS/custom table is smaller than the structures, or
  `usStateArrayOffset`/`ucNumEntries` describe data past the buffer. The
  driver still computed pointers and read them.
- Fix: reject before dereference using `soft_pp_table_size` (already
  filled by `smu_atom_get_data_table` / cached table).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct integer bounds checks. Uses existing
`struct_size` / `offsetofend`. Reject path is the same
`PP_ASSERT_WITH_CODE(... return -1)` style already used. Regression risk
is low: a genuine Vega PPTable is at least the header/SMC-PPT size.
Worst case a truncated table that previously “worked” by reading
adjacent BIOS bytes would now fail init instead of over-reading — that
is the intended failure mode. No API/lock/data-structure changes.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Vega10 `check_powerplay_tables`: `f83a9991648bb4` (Eric Huang,
  2017-03-06)
- Vega12: `2cac05dee6e309` (Evan Quan, 2018-03-19)
- Vega20: `da958630d53025` (Evan Quan, 2018-08-02)
- Bug is long-standing (4.x/5.x era), present throughout 6.18.y.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-author series (2026-06-23), of which this is **patch 4/5**:
1. `Validate pp_table header before reading size` (swsmu)
2. `Use uploaded size for legacy custom PPTable` (`amd_powerplay.c`)
3. `Validate Tonga PowerPlay state array bounds`
4. **This commit**
5. `Validate legacy hwmgr PP table offsets`

Follow-up (separate series): `Validate Vega10 PPTable subtable bounds` —
more subtables, not a prerequisite for these checks.

None of 1–5 are in `v6.18.53`. This hunk does not need 1–3 to compile or
run: it only uses `hwmgr->soft_pp_table_size`, which
`get_powerplay_table()` already sets in this tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Yang Wang is an AMD pm contributor with a run of PPTable
bounds/UAF fixes (`fix pptable use-after-free` is already in v6.18.53).
Hawking Zhang reviewed; Alex Deucher merged.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone for these three files. `struct_size` and
`offsetofend` exist (`include/linux/overflow.h`,
`include/linux/stddef.h`). Flexible-array `states[]` is already in
v6.18.53 (`bae82e8418234` is an ancestor). Patch 2/5 (upload size) makes
short sysfs uploads match `soft_pp_table_size`; this patch still stops
offsets past the *allocated* buffer on 6.18.53, because that tree keeps
the original VBIOS size as the buffer size.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 3a8d8e0b7f61...` → https://patch.msgid.link/20260623034151.
  263746-4-kevinyang.wang@amd.com
- Series: v1 `[PATCH 1/5] ... [PATCH 5/5]`; this is 4/5. `b4 dig -a`
  showed only this v1 (no later revision of *this* patch).
- Mbox: Hawking Zhang: “Series is Reviewed-by: Hawking Zhang”. No NAK,
  no stable-risk comments.
- lore.kernel.org HTTP fetch returned 403; discussion recovered via `b4
  dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `amd-gfx@lists.freedesktop.org`, Alex
Deucher, Hawking Zhang, Kenneth Feng. Maintainer merge + AMD review.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Author-driven audit of
PPTable parsers, consistent with the rest of the series. Trigger is
still real (init + sysfs upload), not speculative code.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Self-contained Vega header/state-array/SMC-PPT checks. Follow-up
subtable patch is extra coverage, not required for these checks to be
correct.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED — `lore.kernel.org/stable/` returned 403. No evidence
in-tree of a prior rejection.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `get_vega10_state_array`, `check_powerplay_tables`
(vega10/12/20), `vega10_get_number_of_powerplay_table_entries`,
`vega10_get_powerplay_table_entry`.

**Step 5.2: TRACE CALLERS**
Record:
- `check_powerplay_tables` ← `vega10_pp_tables_initialize` / vega12/20
  equivalents, and `vega10_baco_set_cap`
- `pptable_init` ← `hwmgr.c` during hwmgr init
- `vega10_get_number_of_powerplay_table_entries` / `get_pp_table_entry`
  ← `psm_init_power_state_table()` (`for (i = 0; i < table_entries;
  i++)`)
- Context: process/workqueue GPU init, not IRQ. Also re-entered from
  `pp_dpm_set_pp_table` → `amd_powerplay_reset` → `hwmgr_hw_init`.

**Step 5.3: TRACE CALLEES**
Record: `get_powerplay_table` → `smu_atom_get_data_table` (pointer into
ATOM BIOS + ATOM-reported size). `PP_ASSERT_WITH_CODE` warns and runs
`return -1`. No new allocations/locks.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable on every Vega10/12/20 GPU probe. Also reachable from
sysfs `pp_table` (`AMDGPU_DEVICE_ATTR_RW` → `S_IRUGO | S_IWUSR`, root
write). Unprivileged users cannot write it; root/firmware can still
drive the OOB.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same pattern in Tonga (`process_pptables_v1_0.c`) and legacy
(`processpptables.c`) in the same series. Vega12
`get_powerplay_table_entry` still uses a raw offset after this patch;
Vega10 is the family that actually walks a state array here. Remaining
holes are why the follow-up exists; they do not invalidate this patch.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local tree is **6.18.53** (`git describe HEAD` →
`v6.18.53-5049-g0f0bdc2b0dffb`, `make kernelversion` → 6.18.53). `git
merge-base --is-ancestor 10510a4c2c397 v6.18.53` is false. `v6.18.53`
`check_powerplay_tables` still dereferences the state array / SMC PPT
with no size check.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply onto v6.18.53 file contents (`patch --dry-run` on
the three files succeeded). `git apply --check` on current HEAD fails
only because the candidate + follow-up are already stacked on the
autosel branch.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: The older `fix pptable use-after-free` is in v6.18.53. No
equivalent Vega bounds check is. v6.18.53 `pp_dpm_set_pp_table` still
`memcpy`s into a buffer sized from the original VBIOS table and does
**not** shrink `soft_pp_table_size`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/pm/powerplay` — Vega PowerPlay table
parsing. **IMPORTANT** (common AMD dGPU driver; Vega10/12/20 still in
the field). Not core mm/net, not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature parser (2017–2018) with recent bounds-hardening. Long-
lived bug, not churn from a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: Vega10/Vega12/Vega20 amdgpu powerplay. Also
anyone writing `/sys/class/drm/card*/device/pp_table` on those GPUs.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Normal good VBIOS: not triggered.
- Truncated/corrupt ATOM PPTable at probe: GPU init OOB.
- Root write of a crafted `pp_table` that re-inits hwmgr: same path.
- Unprivileged: no (sysfs is `S_IWUSR`).
- Off-by-one `<=` is latent: `psm_init_power_state_table` uses `i <
  table_entries`, so the common loop never passes `entry_index ==
  ucNumEntries`. Still a real bounds bug if any caller passes
  `ucNumEntries`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Kernel OOB read (KASAN/oops, possible info leak from adjacent
BIOS/kmalloc). Init failure on reject is the safe outcome. Severity:
**HIGH** (memory safety). Not a guaranteed panic on every boot.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for Vega + custom PPTable users; stops OOB on init.
- Risk: LOW (~50 lines, assert-and-return, no locking/API).
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read in GPU power-management init, present since 2017/2018 in
  this 6.18 tree
- Triggerable from truncated VBIOS and from root `pp_table` sysfs re-
  init
- Small, obviously correct bounds checks; AMD Reviewed-by + maintainer
  SOB
- Applies cleanly to v6.18.53; helpers already present
- Matches stable’s buffer-overflow / memory-safety class

AGAINST:
- No public crash/syzbot/CVE write-up
- Privileged sysfs / firmware trigger, not unprivileged
- Series 4/5; later patch covers more Vega10 subtables (not required for
  this hunk)
- Good VBIOS never hits it

UNRESOLVED:
- Stable-list discussion (lore.kernel.org/stable 403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — integer bounds; reviewed and
   merged by AMD
2. Fixes a real bug that affects users? **PASS** — OOB read of PPTable
   buffer
3. Important issue? **PASS** — memory-safety OOB (HIGH), not a style fix
4. Small and contained? **PASS** — 3 files, ~50 net lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — v6.18.53 still has the bug;
   dry-run apply clean

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary memory-safety
bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. This tree still performs unvalidated Vega PPTable pointer math
during hwmgr init. The patch is the minimal, already-reviewed guard for
that path.

What it solves for 6.18.y users: Vega probe and `pp_table` reload can
read past the PowerPlay buffer if the table is short or
`usStateArrayOffset`/`ucNumEntries` (Vega10) / SMC PPT (Vega12/20) stick
past `soft_pp_table_size`. That is an OOB read, not a feature.

Risk vs benefit: low-risk reject-invalid-table change vs stopping kernel
over-reads on a supported amdgpu path.

Concerns: more complete subtable checks come later; v6.18.53 custom-
upload still keeps the old VBIOS size (patch 2/5). Neither blocks this
patch: it still applies and still stops offsets past the allocated
buffer.

Verification:
- [Phase 1] Tags: author Yang Wang; Reviewed-by Hawking Zhang; SOB Alex
  Deucher; no Fixes/syzbot
- [Phase 2] Diff: 52/21 across three Vega processpptables files;
  size/offset checks + off-by-one
- [Phase 3] Blame: Vega10 2017 (`f83a9991648bb4`), Vega12 2018, Vega20
  2018; present in v6.18.53
- [Phase 3] Series 4/5; no code dependency on 1–3 for these files
- [Phase 3] `struct_size`/`offsetofend` and flexible `states[]` already
  in this tree
- [Phase 4] `b4 dig -c 3a8d8e0b7f61...` → msgid 20260623034151.263746-4;
  series R-b from Hawking; no NAK
- [Phase 4] lore.kernel.org HTTP 403; mbox via `b4 dig -m` used instead
- [Phase 5] Callers: `pptable_init` from `hwmgr.c`;
  `psm_init_power_state_table`; `pp_dpm_set_pp_table` reset
- [Phase 5] `smu_atom_get_data_table` returns BIOS pointer + ATOM size
- [Phase 6] `git describe HEAD` v6.18.53-5049; `merge-base --is-
  ancestor` vs v6.18.53: not present; buggy code confirmed in `git show
  v6.18.53:...`
- [Phase 6] `patch --dry-run` on v6.18.53 copies of the three files:
  clean
- [Phase 8] Failure mode: OOB read during hwmgr init; sysfs `pp_table`
  is `S_IWUSR`
- UNVERIFIED: stable@ mailing-list thread (HTTP 403)

**YES**

 .../powerplay/hwmgr/vega10_processpptables.c  | 59 ++++++++++++-------
 .../powerplay/hwmgr/vega12_processpptables.c  |  7 +++
 .../powerplay/hwmgr/vega20_processpptables.c  |  7 +++
 3 files changed, 52 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
index 3be616af327ef..64cff9f4850a6 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_processpptables.c
@@ -63,14 +63,17 @@ static const void *get_powerplay_table(struct pp_hwmgr *hwmgr)
 	return table_address;
 }
 
-static int check_powerplay_tables(
-		struct pp_hwmgr *hwmgr,
-		const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
+static int get_vega10_state_array(struct pp_hwmgr *hwmgr,
+	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table,
+	const ATOM_Vega10_State_Array **state_array)
 {
 	const ATOM_Vega10_State_Array *state_arrays;
+	u16 state_array_offset;
+	size_t state_array_size;
+	size_t table_size = hwmgr->soft_pp_table_size;
 
-	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
-		le16_to_cpu(powerplay_table->usStateArrayOffset));
+	PP_ASSERT_WITH_CODE((table_size >= sizeof(*powerplay_table)),
+			    "Invalid PowerPlay Table!", return -1);
 
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 			ATOM_Vega10_TABLE_REVISION_VEGA10),
@@ -79,12 +82,34 @@ static int check_powerplay_tables(
 		"State table is not set!", return -1);
 	PP_ASSERT_WITH_CODE(powerplay_table->sHeader.structuresize > 0,
 		"Invalid PowerPlay Table!", return -1);
+
+	state_array_offset = le16_to_cpu(powerplay_table->usStateArrayOffset);
+	PP_ASSERT_WITH_CODE((state_array_offset <=
+			     table_size - sizeof(*state_arrays)),
+			    "Invalid PowerPlay Table!", return -1);
+
+	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)powerplay_table) +
+		state_array_offset);
 	PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
 		"Invalid PowerPlay Table!", return -1);
 
+	state_array_size = struct_size(state_arrays, states, state_arrays->ucNumEntries);
+	PP_ASSERT_WITH_CODE((state_array_size <= table_size - state_array_offset),
+			    "Invalid PowerPlay Table!", return -1);
+
+	*state_array = state_arrays;
+
 	return 0;
 }
 
+static int check_powerplay_tables(struct pp_hwmgr *hwmgr,
+	const ATOM_Vega10_POWERPLAYTABLE *powerplay_table)
+{
+	const ATOM_Vega10_State_Array *state_arrays;
+
+	return get_vega10_state_array(hwmgr, powerplay_table, &state_arrays);
+}
+
 static int set_platform_caps(struct pp_hwmgr *hwmgr, uint32_t powerplay_caps)
 {
 	set_hw_cap(
@@ -1249,15 +1274,14 @@ int vega10_get_number_of_powerplay_table_entries(struct pp_hwmgr *hwmgr)
 {
 	const ATOM_Vega10_State_Array *state_arrays;
 	const ATOM_Vega10_POWERPLAYTABLE *pp_table = get_powerplay_table(hwmgr);
+	int result;
 
 	PP_ASSERT_WITH_CODE((pp_table != NULL),
 			"Missing PowerPlay Table!", return -1);
-	PP_ASSERT_WITH_CODE((pp_table->sHeader.format_revision >=
-			ATOM_Vega10_TABLE_REVISION_VEGA10),
-			"Incorrect PowerPlay table revision!", return -1);
 
-	state_arrays = (ATOM_Vega10_State_Array *)(((unsigned long)pp_table) +
-			le16_to_cpu(pp_table->usStateArrayOffset));
+	result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
+	PP_ASSERT_WITH_CODE((result == 0),
+			    "Invalid PowerPlay Table State Array.", return result);
 
 	return (uint32_t)(state_arrays->ucNumEntries);
 }
@@ -1308,17 +1332,11 @@ int vega10_get_powerplay_table_entry(struct pp_hwmgr *hwmgr,
 
 	if (pp_table->sHeader.format_revision >=
 			ATOM_Vega10_TABLE_REVISION_VEGA10) {
-		state_arrays = (ATOM_Vega10_State_Array *)
-				(((unsigned long)pp_table) +
-				le16_to_cpu(pp_table->usStateArrayOffset));
-
-		PP_ASSERT_WITH_CODE(pp_table->usStateArrayOffset > 0,
-				"Invalid PowerPlay Table State Array Offset.",
-				return -1);
-		PP_ASSERT_WITH_CODE(state_arrays->ucNumEntries > 0,
+		result = get_vega10_state_array(hwmgr, pp_table, &state_arrays);
+		PP_ASSERT_WITH_CODE((result == 0),
 				"Invalid PowerPlay Table State Array.",
-				return -1);
-		PP_ASSERT_WITH_CODE((entry_index <= state_arrays->ucNumEntries),
+				return result);
+		PP_ASSERT_WITH_CODE((entry_index < state_arrays->ucNumEntries),
 				"Invalid PowerPlay Table State Array Entry.",
 				return -1);
 
@@ -1360,4 +1378,3 @@ int vega10_baco_set_cap(struct pp_hwmgr *hwmgr)
 			PHM_PlatformCaps_BACO);
 	return result;
 }
-
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
index 89148f73b514a..8e6b1565d00de 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega12_processpptables.c
@@ -64,6 +64,13 @@ static int check_powerplay_tables(
 		struct pp_hwmgr *hwmgr,
 		const ATOM_Vega12_POWERPLAYTABLE *powerplay_table)
 {
+	size_t smc_pptable_size =
+		offsetofend(ATOM_Vega12_POWERPLAYTABLE, smcPPTable);
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
+			    "Invalid PowerPlay Table!", return -1);
+
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 		ATOM_VEGA12_TABLE_REVISION_VEGA12),
 		"Unsupported PPTable format!", return -1);
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
index 2b446f8866bac..0d008573c0388 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega20_processpptables.c
@@ -66,6 +66,13 @@ static int check_powerplay_tables(
 		struct pp_hwmgr *hwmgr,
 		const ATOM_Vega20_POWERPLAYTABLE *powerplay_table)
 {
+	size_t smc_pptable_size =
+		offsetofend(ATOM_Vega20_POWERPLAYTABLE, smcPPTable);
+	size_t table_size = hwmgr->soft_pp_table_size;
+
+	PP_ASSERT_WITH_CODE((table_size >= smc_pptable_size),
+			    "Invalid PowerPlay Table!", return -1);
+
 	PP_ASSERT_WITH_CODE((powerplay_table->sHeader.format_revision >=
 		ATOM_VEGA20_TABLE_REVISION_VEGA20),
 		"Unsupported PPTable format!", return -1);
-- 
2.53.0

