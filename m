Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7A85FC7A8;
	Mon, 19 Oct 2026 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418571; cv=none; b=LZdBhOA/ZUsuwJ6LuQgp6vwR9cKSFWpHjnTVNTo5W5rBqG6AlDBauP4vHm07i949WdIqmWRKGnD0Z+hKlCVuVkclo9T5uwixPpJT5q19lfcd7lLc4QNvrRKRTnivFKVIU/Y7ljn4kVyzIQDxHHWVHA3KnnKb0iIdE4VLcReA8oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418571; c=relaxed/simple;
	bh=k/fxEd+Mw6yldXC9WnQz48+bNt4sf4NgeMRR214mN0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GSqhKPNdn6VS3K02EHiGSRqCjIiqroFc4c7zjCnU0MWnt5BQde1hYEDzrF6kt0NFwdAWI5rxUhY2b38L0jrcMrt8HK7JK8XNBPeN3p83pGBhbcohWAeepXP4Wv5a+wFl8ohTBGzmXbHB6BM7c2wqCqu/nZeJ3QHKdh2XGHkFnAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AmJXm+m/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AmJXm+m/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011911F000C5;
	Mon, 19 Oct 2026 14:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418568;
	bh=OC8GhUqh3bS6U7IO72fCtcHGRln1xRSC2VSLtJFjCHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmJXm+m/z4ghHUYoGy9demgxWvjQxyAbttpTTiicQFI746fvWCKvt1P6uduAHGkgK
	 /fiNnkX4Bb7fnGw32tU8om7FTbKDA40AAnIiEH1GijVqg05vHedUOuznTqxwWS4Kl0
	 IzRFA/+mJazLLMeutUxh+4kYIsIyXy7k+QjoqYOWhy9Vs+rMa7XO4NwrKzYUURizGy
	 nGdWFC8cjbFE50h2GWJPAnAEJdY5EkiMGU+Lu44UkN+Nn7/p6JTQvjEwgeCzPKI2sM
	 IBSggpxEnM1e3O4hbB8+1QFP5KFdFfQlVRNdjbA4tUBdvfH4T+NpVzQa6VUiEfPLA7
	 HV+icSvDXGm6w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	sunpeng.li@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/amd/display: fix max dispclk_khz/dppclk_khz double 1000
Date: Mon, 19 Oct 2026 09:50:31 -0400
Message-ID: <20261019135441.1420968-340-sashal@kernel.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit f48124ff35357d05a98d9cd5cb7982e7e5509003 ]

[why]
Fix regresson caused by double roundup and index out of range

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to judge this for 6.18.y: the DML21 clock-table bug is
present here, the fix is four lines, and it applies to the local
`dml21_wrapper.c` path.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[drm/amd/display] [fix] correct max dispclk_khz/dppclk_khz
(remove double *1000 and fix last-index)`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reviewed-by: Dillon Varone <dillon.varone@amd.com>` (AMD DC)
- `Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>` (AMD
  DC)
- `Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>` (author)
- `Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>` (AMD DC,
  series submitter)
- `Tested-by: Dan Wheeler <daniel.wheeler@amd.com>` (AMD QA)
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` (amdgpu
  maintainer)
- No `Fixes:` tag (expected for this review)
- No `Cc: stable` (expected)
- No `Reported-by:` / syzbot / Link
- Ignore pipeline `Signed-off-by: Sasha Levin` and `[Upstream commit
  ...]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: “regression caused by double roundup and index out of range.”
- Symptom: wrong `max_supported_dispclk_khz` /
  `max_supported_dppclk_khz` (0 from off-by-one into a zero pad, or
  ~1000× too large from a second `* 1000`).
- No stack trace, no public repro, no version list.
- Root cause as stated: double unit conversion plus using
  `num_clk_values` as an index instead of `num_clk_values - 1`.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body both describe a correctness fix
(units + indexing).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- User/mainline path:
  `drivers/gpu/drm/amd/display/dc/dml2_0/dml21/dml21_wrapper_fpu.c`
- This tree: `drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c`
  (DML21 not yet split into `dml2_0` + `_fpu`)
- 4 lines changed, same function: `dml21_calculate_rq_and_dlg_params`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before, if `num_clk_values > 1`: read `clk_values_khz[num_clk_values]`
  (one past last valid entry) and multiply by 1000.
- Before, else: read `[0]` and multiply by 1000.
- After: last valid entry `[num_clk_values - 1]`, no extra `* 1000`.
- Same for dispclk and dppclk. Path is normal modeset validation on
  DML21, not an error path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: logic/correctness + off-by-one (g, plus memory-safety-class
  indexing).
- Table fill in `dcn401_soc_and_ip_translator.c` already does
  `dispclk_mhz * 1000` into `clk_values_khz[]`. Unused slots are 0.
  Valid indices are `0 .. num_clk_values-1`.
- Mechanism: copy-paste of DML2.0’s `*_mhz * 1000` onto a table that is
  already kHz, plus using count as an index.
- Verified sibling: `dml2_utils.c` still converts from `dispclk_mhz *
  1000` because that path stores MHz.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct vs the type name `clk_values_khz` and vs every other
  DML21 use of `clk_values_khz[num_clk_values - 1]` (e.g.
  `dml2_dpmm_dcn4.c`, `dml2_core_dcn4_calcs.c`).
- Minimal; no API or struct change.
- Regression risk: very low. Correcting max-clock metadata; does not
  change DML’s `min_clocks` programming path.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Introduced in `70839da6360500` (“drm/amd/display: Add new DCN401
  sources”, Aurabindo Pillai, 2024-04-19).
- `git merge-base --is-ancestor 70839da6360500 HEAD` → yes. Present
  since DCN401 landed; in this 6.18.y tree from day one of DML21.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy commit is the DCN401/DML21 introduction
above, which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent file history is DML21 FPU guards, init refactor, mcache, etc.
- Related later change on this branch: `5d22a3f28b5b9` (“add
  DalForceMaxDisplayClock debug option to DML2”) copies
  `max_supported_*` into `bw_dispclk_khz` / `bw_dppclk_khz` when
  `forced_clocks` or `debug.max_disp_clk`. That is **not** in
  `v6.18.53`.
- This fix is standalone; it is not patch N/M of a required sequence in-
  tree.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Charlene Liu is a regular AMD DC contributor. Series was signed
off by Aurabindo Pillai and Alex Deucher. AMD QA `Tested-by` present.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Submitted as `[PATCH 07/24]` in “DC Patches for 8 June 2026”.
Neighbors are unrelated (PHY SSC, writeback, KUnit, dead code). Diff
needs no new helpers. Can apply standalone to this tree’s
`dml21_wrapper.c`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c f48124ff35357d05a98d9cd5cb7982e7e5509003`: lore search
  failed (server error / 403).
- Found on amd-gfx: https://www.mail-archive.com/amd-
  gfx@lists.freedesktop.org/msg144416.html
- Message-id: `20260604145428.809959-8-aurabindo.pillai@amd.com`
- From Charlene Liu, submitted by Aurabindo Pillai, 2026-06-04, `[PATCH
  07/24]`.
- Body matches the committed patch. No v2/v3 of this hunk found.
- No reviewer NAK in the archived message; R-b already on the patch
  (internal AMD review before list).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Dillon Varone, Dmytro Laktyushkin (AMD DC); maintainer SOB Alex
Deucher. Appropriate reviewers.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No public bugzilla/syzbot. “Regression” is AMD-internal. QA
`Tested-by: Dan Wheeler`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 24-patch DC drop; this hunk is independent. Later
DalForceMaxDisplayClock uses the fields this commit corrects; it is not
a prerequisite for this fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search not usable here (403). No evidence
this was rejected for stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `dml21_calculate_rq_and_dlg_params` only.

**Step 5.2: TRACE CALLERS**
Record:
- Called from `dml21_validate()` after mode programming
  (`dml21_wrapper.c` ~line 262).
- `dml2_validate()` dispatches to `dml21_validate` when `architecture ==
  dml2_architecture_21`.
- `dml2_create()` selects DML21 when `debug.using_dml21 && dce_version
  >= DCN_VERSION_4_01`.
- DCN401 debug defaults: `.using_dml21 = true` in `dcn401_resource.c`.
- DCN401 is `AMDGPU_FAMILY_GC_12_0_0` (RDNA4, e.g. Navi 48).
- Call context: modeset / bandwidth validation, not IRQ.

**Step 5.3: TRACE CALLEES**
Record: This hunk only indexes
`soc_bb.clk_table.{dispclk,dppclk}.clk_values_khz`. Actual pipe clocks
are set earlier in the same function via `dml21_program_dc_pipe` →
`dml21_utils.c` (`dppclk_khz` from DML `min_clocks`), then
`dml21_copy_clocks_to_dc_state` overwrites `dispclk_khz` from
programming output. It does **not** overwrite `max_supported_*`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace modeset on DCN401 reaches this on every validate-and-
program. Buggy **fields** are written on that path. Verified DCN401
consumers of `max_supported_*`:
- `dcn401_update_clocks` / `dcn401_are_clock_states_equal`: do **not**
  read them.
- `dcn401_get_max_clock_khz`: uses SMU DPM table, not these fields.
- `amdgpu_dm_trace.h` and `dcn10_hwseq.c` log them.
- `dcn20_clk_mgr.c` does use them for `clock_cfg->max_clock_khz`, but
  that clk_mgr is not DCN401.
- In **this checkout**, after a later candidate, `forced_clocks` /
  `debug.max_disp_clk` copy them into `bw_*clk_khz`. That later commit
  is **not** in `v6.18.53`.

So the default 6.18.y DCN401 clock request path does not program SMU
from these two fields. They are still wrong on every modeset.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No remaining `clk_values_khz[num_clk_values]` (without `- 1`)
under `dc/dml2`. Other DML21 code already uses `num_clk_values - 1`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`
- `make kernelversion` → `6.18.53`
- `v6.18.53` `dml21_wrapper.c` still has `clk_values_khz[num_clk_values]
  * 1000`.
- `dml2_0/.../dml21_wrapper_fpu.c` does **not** exist here; equivalent
  file is `dml2/dml21/dml21_wrapper.c`.
- Bug introduced with DCN401 (2024); this series has it.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected apply: **clean** on this tree’s file (4-line context
matches `v6.18.53`). Path rename vs mainline only.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier fix of this indexing/unit bug in `v6.18.53`.
DalForceMaxDisplayClock is a separate later change, not an alternate
fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/gpu/drm/amd/display` DML21 / DCN401. Criticality:
**IMPORTANT** (shipping RDNA4 display), not core mm/net. Peripheral to
machines without DCN401.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: High churn (DC drops). Bug is old (initial DCN401), not last-
week code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific: AMD DCN 4.0.1 (GC 12.0.0) with DML21, which is
the default. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every DML21 validate-and-program (typical modeset). Not a race.
Unprivileged DRM modeset can run the writer. Common: `num_clk_values` is
> 1 (DPM table); then the off-by-one hits a 0 pad. Rare: single-level
table takes the `* 1000` branch.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Not a C-array OOB crash: `DML_MAX_CLK_TABLE_SIZE` is 20, fill is
  `min(20, MAX_NUM_DPM_LVL=8)`, so index `num_clk_values` (≤8) stays in-
  bounds. “Index out of range” is **logical** OOB of valid entries.
- Wrong stored max: typically **0** (multi-level) or **1000×** (single-
  level). `max_supported_*` are `int`; `value_khz * 1000` can overflow
  signed 32-bit if kHz > ~2.147e6 (clocks ≳ 2147 MHz).
- Default DCN401 programming does not consume these fields for SMU
  (verified). User-visible black screen / wrong clocks on stock 6.18.y
  is **not verified**.
- Author still called it a **regression**; AMD QA tested the fix.
- Severity for stock 6.18.y runtime: **MEDIUM** (wrong clock caps in DC
  state / traces; debug force-max path would mis-program). Class of bug
  (bad max clocks / logical OOB) is what stable takes for GPU display.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: correct max disp/dpp clocks on DCN401 DML21; unblocks any
  path that reads them (including later force-max debug); matches
  DML21’s kHz units.
- Risk: very low (4 lines, local assignment).
- Ratio: high benefit/risk for a contained DC correctness fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real unit + off-by-one bug in code that runs on every DCN401 modeset.
- Tiny, obviously correct; AMD DC review + QA `Tested-by`.
- Buggy code is in this 6.18.y tree; applies cleanly.
- No new API; no series dependency.
- Shipping RDNA4 hardware.

AGAINST:
- Stock DCN401 clk_mgr does not program SMU from these two fields
  (verified).
- No public crash/syzbot; sparse “[why]” text.
- Logical OOB, not a KASAN-class overflow of the 20-entry array.

UNRESOLVED:
- Exact AMD-internal regression symptom (black screen vs wrong debug
  clocks) not in the public thread.
- lore.kernel.org/stable not readable here (403).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — units + last index; R-b +
   Tested-by.
2. Fixes a real bug that affects users? **PASS** — wrong max clocks on
   DCN401 DML21; hardware is in this kernel.
3. Important issue? **PASS** — display clock-limit correctness / logical
   OOB; not a proven panic, but a real modeset-path clock bug on
   shipping GPUs, which stable routinely takes for amdgpu DC.
4. Small and contained? **PASS** — 4 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same hunk in
   `dml2/dml21/dml21_wrapper.c`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/doc exception). Ordinary bugfix.

**Step 9.4: MAKE YOUR DECISION**
Backport. The tree has the bug, the fix is surgical and correct, and
DML21 is the default path for DCN401. Limited SMU use of these fields
lowers severity but does not make the fix inappropriate for 6.18.y.

===============================================================
Detailed explanation
===============================================================

This commit repairs `dml21_calculate_rq_and_dlg_params` so
`max_supported_dispclk_khz` and `max_supported_dppclk_khz` take the last
DPM table entry already stored in kHz. The old code indexed one past the
last valid slot (usually a 0 pad) and multiplied by 1000 again even
though `dcn401_soc_and_ip_translator.c` already converted MHz→kHz.

On this tree that matters: DCN401 defaults `using_dml21 = true`, so
RDNA4 modesets hit DML21. The patch is four assignment lines, reviewed
and tested at AMD, and matches existing `num_clk_values - 1` use
elsewhere in DML21.

It meets the stable rules: obviously correct, real bug, small, no new
API, applies to local `dml21_wrapper.c`. Risk is negligible. Benefit is
correct max-clock state for DCN401 and any consumer of those fields
(trace, later force-max debug). The main caveat is that `dcn401_clk_mgr`
does not currently feed these fields to SMU on the default path, so this
is not a verified oops; it is still a real clock-table bug on hardware
this kernel supports.

===============================================================
Verification
===============================================================
- [Phase 1] Subject/tags: fix + AMD R-b/Tested-by/SOB; no Fixes/syzbot.
  Pipeline SOB/Upstream ignored.
- [Phase 2] Diff: 4 lines in `dml21_calculate_rq_and_dlg_params`; drop
  `* 1000`, index `num_clk_values - 1`.
- [Phase 2] Table fill: `dcn401_soc_and_ip_translator.c` `dispclk_mhz *
  1000` into `clk_values_khz`; unused = 0.
- [Phase 2] Array: `DML_MAX_CLK_TABLE_SIZE` 20; `MAX_NUM_DPM_LVL` 8 — C
  OOB not hit; logical OOB is real.
- [Phase 3] Blame parent: `70839da6360500` DCN401 sources; ancestor of
  HEAD.
- [Phase 3] `v6.18.53` file still has `* 1000` and `num_clk_values`
  without `- 1`.
- [Phase 3] No Fixes tag; no other in-tree fix of this bug at v6.18.53.
- [Phase 4] `b4 dig` failed (lore error). Thread: mail-archive amd-gfx
  `[PATCH 07/24]`, 2026-06-04, standalone in a 24-patch DC drop.
- [Phase 5] Callers: `dml21_validate` ← `dml2_validate` when arch 21;
  `using_dml21` true on DCN401; GC 12.0.0.
- [Phase 5] `dcn401_update_clocks` / `are_clock_states_equal` do not
  read `max_supported_*`.
- [Phase 5] `dml21_copy_clocks_to_dc_state` does not overwrite
  `max_supported_*`.
- [Phase 6] Tree is 6.18.53; file exists as
  `dml2/dml21/dml21_wrapper.c`, not `dml2_0/..._fpu.c`.
- [Phase 6] Apply difficulty: clean on this path.
- [Phase 8] Failure mode: wrong max clocks (0 or 1000× / possible int
  overflow); default SMU programming impact not verified.
- UNVERIFIED: exact user-visible regression AMD saw; stable-list
  discussion (lore 403).

**YES**

 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index 08f7f03b10231..0167d936feaf5 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -152,16 +152,16 @@ static void dml21_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_sta
 	context->bw_ctx.bw.dcn.clk.bw_dispclk_khz = context->bw_ctx.bw.dcn.clk.dispclk_khz;
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0];
 	}
 
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0];
 	}
 
 	/* get global mall allocation */
-- 
2.53.0

