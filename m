Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2A8529F07;
	Mon, 19 Oct 2026 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418161; cv=none; b=N4mHDljI4Uuizq8IU5csmykMuBiELqTjnLDhmIKSuqRtKXK0YUvnI7IOcH7a7oUFZfTgBeOn84AvIb14PlnZHvpQvFpKKAfCXUBu1mSGQtRtWV1nuoqOziwV2FmuGspSWHEDA3JdJZPk4GkDxbwxzXUm0FV3Gr3h7dWTrzexgBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418161; c=relaxed/simple;
	bh=jFZvQKQaMwn/eXDpXskzGJUTkr7fBuyV/lEtiuJIDrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFTBS/1BDbLYkTAQ++cbjuTmD3+M4JZ3+szbrNdPYT/VuVxFmFAY+DJPpCvi0OchpD1AqJfxHaH2P0C7cW61WH3HaftSRVWmewV/MkariI2rbumcrEABkZZEXrcPtJFcDoqsNX+nLcBec6lf9S6EcrM9Ct4mSF//TSbo/BLDTsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMBg0D7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMBg0D7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9C41F000C7;
	Mon, 19 Oct 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418158;
	bh=JheI5Tzajxmtbm//DK9m67k08ulfuXAgWeDjTXp1vjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eMBg0D7eN93uqaaz07uMVaruPe8FY98kHMVjKlhXvvQCx/yEQThOwjfu/x2M17qpq
	 5bZ+mpdI0Fv7frdg9nf2v4+236n5H9OhNLYVS3Iowsto73QQwpb6mrjUEZ4zBKQCKy
	 /lFapI6TaokWo01SIM8WirfRjveNHd8KkqOnV4dzTC1mYn8tjSfs0ey2IEH5+16e4o
	 BO2Dvan3z9GNR3lvATc8jz3ZZ8at3JX5sJh0pbPSSdWva6A0Y+82I1zmPt/QSzaWjf
	 QQxYge+IJRf27gMn39yP1QO2b6r7uJrtpQoSnxNXtmTdvhCiK+COYCEHm2pMpkkT45
	 nOWjosCrtR5Pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Stewart <Matthew.Stewart2@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
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
Subject: [PATCH AUTOSEL 6.18] drm/amd/display: Fix rounding errors in CalculatePrefetchSchedule
Date: Mon, 19 Oct 2026 09:45:44 -0400
Message-ID: <20261019135441.1420968-53-sashal@kernel.org>
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

From: Matthew Stewart <Matthew.Stewart2@amd.com>

[ Upstream commit fa0300333db07ca4ad56c9879f155faafd3f7079 ]

[why]

Rounding errors were causing mode validation to fail in some cases when
it should not. (IE. Increasing fclk from a lower value could lead to
validation failure, which should not happen.)

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Matthew Stewart <Matthew.Stewart2@amd.com>
Signed-off-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
I have enough to decide: this is a small DCN4 DML prefetch-rounding fix
in 7.3-rc4, and the remaining work is to write the phase-by-phase
verdict.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [drm/amd/display] [Fix] [rounding errors in
CalculatePrefetchSchedule causing false mode-validation failures]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Reviewed-by: Dillon Varone &lt;dillon.varone@amd.com&gt;
- Signed-off-by: Matthew Stewart &lt;Matthew.Stewart2@amd.com&gt;
  (author)
- Signed-off-by: Fangzhi Zuo &lt;jerry.zuo@amd.com&gt; (DC series
  collector)
- Tested-by: Dan Wheeler &lt;daniel.wheeler@amd.com&gt;
- Signed-off-by: Alex Deucher &lt;alexander.deucher@amd.com&gt; (amdgpu
  maintainer)
- No Fixes: tag (expected)
- No Reported-by, no syzbot, no Link:, no Cc: stable
- Ignore any Sasha Levin SOB / Upstream-commit markers if present in a
  candidate wrapper; none are in the real commit

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: rounding in the DCN4 DML21 prefetch scheduler made mode
  validation fail for configurations that are actually valid.
- Symptom: increasing fclk (fabric clock) from a working lower value can
  cause validation to fail. That is non-monotonic and should not happen.
- Failure mode: Display Core rejects a mode (`PrefetchSupported` /
  `NoTimeForPrefetch`), so a modeset or clock bump that should work is
  refused.
- No stack trace, no CVE, no named kernel version range in the message.
- Root cause (from message + comments in the diff): VM/row prefetch
  times are later ceiled to quarter-line units, which steals time from
  the swath (SW) stage. `Tsw_est*` did not account for that, so the
  wrong prefetch-bandwidth case was selected.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. Subject and body state a real
validation bug. The three subtracted LineTime fractions are the actual
fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/amd/display/dc/dml2_0/dml21/src/dml2_core/dml2_
  core_dcn4_calcs.c`
- +6 / -3 (stat of fa0300333db07)
- Function: `CalculatePrefetchSchedule`
- Scope: single-file surgical change to three assignments

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: `Tsw_est1/2/3 = prefetch_sw_bytes / prefetch_bwN` (SW time
  estimated with no rounding slack).
- After:
  - `Tsw_est1 -= 3/4 LineTime` (VM +1/4, two rows +2/4)
  - `Tsw_est2 -= 1/4 LineTime` (VM only)
  - `Tsw_est3 -= 2/4 LineTime` (two rows)
- Affected path: DML mode-support / mode-programming prefetch bandwidth
  selection, not an error-path or init-only path.
- Those `Tsw_est*` values feed `if (Tsw_estN < min_Lsw_equ * LineTime)`
  which already subtracts 0.75 / 0.25 / 0.5 LineTime when recalculating
  `prefetch_bw1/2/3`. The initial estimate is now consistent with that
  later quarter-line rounding.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Logic / correctness] [DML prefetch time rounding]
- Later in the same function, VM and row times are ceiled to U2.2
  quarter-lines:
  `dst_y_per_vm_vblank = ceil(4 * Tvm / LineTime) / 4` and the same for
  rows.
- That can consume up to +1/4 line (VM) and +1/4 line × 2 rows. SW then
  has less time than `Tsw_est` assumed, so the equalized bandwidth case
  is wrong and validation fails even though the mode is feasible
  (including after an fclk increase).
- Category is not UAF/leak/race/NULL; it is display-mode calculator
  incorrectness.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Quality: high. The 3/4, 1/4, 2/4 constants match the existing 0.75 /
  0.25 / 0.5 LineTime terms and the documented quarter-line clamp.
- Minimal: three expressions plus comments.
- Regression risk: changing DML bandwidth can theoretically accept a
  mode that underflows, or reject a previously accepted one. Here the
  change only makes `Tsw_est` pessimistic so the already-margined
  recalculation path runs; the author states the old path rejected valid
  modes. Reviewed and Tested-by AMD display.
- No public API / data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- File added as DCN401 DML21 in 70839da636050 (`drm/amd/display: Add new
  DCN401 sources`, 2024-04-26). Present from v6.11 onward.
- Surrounding `Tpre_rounded` / `Tsw_est` logic largely from
  be4e3509314af7 (`DML21 Reintegration For Various Fixes`, 2024-12-18).
- The three `Tsw_est*` lines are fa0300333db07 itself (2026-06-19 /
  committed 2026-07-28).
- Bug has been in DCN4 DML21 since that IP was added, not a last-month
  regression.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. Not applicable. Buggy code is the original DCN4
prefetch estimator, not a one-commit regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- Recent file commits include DCN6 compile, PMO pstate plumbing, this
  fix, UCLK pstate, divide-by-zero, HDMI FRL, HostVM units.
- Follow-ups after this fix (9fcd9c7545654, 992694ad28584) do not revert
  or rework these three lines.
- Standalone mathematically; landed as patch 46/49 of a bulk DC drop,
  but the hunk has no dependency on 45/47/etc.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Matthew Stewart is an AMD display engineer (DCN42B enablement,
soc_bb, register masks). Not the drm/amd maintainer; Alex Deucher signed
it off. Related nearby work is DCN42B, not a prerequisite for this
rounding change.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: No extra helpers or struct fields. Can apply standalone wherever
this `CalculatePrefetchSchedule` exists. This tree uses `dml2_0/`
(rename e6a8a000cfe6a, 2025-10-28); older stables still on `dml2/` would
only need a path tweak. No missing prerequisites in this checkout.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c fa0300333db07` failed: lore.kernel.org returned errors.
- Found on amd-gfx: [PATCH 46/49] in “DC Patches July 20th, 2026”
  - Cover: https://lists.freedesktop.org/archives/amd-
    gfx/2026-July/149310.html
  - Patch: https://lists.freedesktop.org/archives/amd-
    gfx/2026-July/149359.html
- Cover letter summary: KUnit expansion, dm refactor, Apple 5K tiled
  monitor, FRL/DSC, dcn42 fixes. This rounding fix is not called out as
  a highlight.
- Diff on the list matches the committed change. No v2/v3 of this
  specific patch.
- No reviewer NAK, no Cc: stable in the mail.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Reviewed-by Dillon Varone (DML/DCN4). Tested-by Dan Wheeler.
Collected by Fangzhi Zuo, merged by Alex Deucher. Appropriate AMD
display reviewers.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No user bugzilla/syzbot/lore bug report found. Evidence is AMD
internal: “some cases”, fclk monotonicity example. Severity from the
author: false mode-validation failure, not oops.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Independent of the rest of the 49-patch DC drop (KUnit,
refactors, Apple tiled display, etc.). DCN5
`dml2_core_dcn5_calcs_dchub.c` still uses unadjusted `Tsw_est*`; this
fix is DCN4 DML21 only.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403.
lists.freedesktop.org has no AUTOSEL of this subject. Unverified whether
stable@ ever discussed it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `CalculatePrefetchSchedule` only (static in
dml2_core_dcn4_calcs.c).

Step 5.2: TRACE CALLERS
Record: Two call sites in the same file:
- Mode support (~line 7645): `mode_lib->ms.NoTimeForPrefetch[k] =
  CalculatePrefetchSchedule(...)` then `PrefetchSupported &=
  !NoTimeForPrefetch[k]`
- Mode programming (~line 11473): `mode_lib->mp.NoTimeToPrefetch[k] =
  CalculatePrefetchSchedule(...)`
`dml2_core_calcs_mode_support_ex` is used from `dml2_core_dcn4.c` during
DC mode validation.

Step 5.3: TRACE CALLEES
Record: Floating-point DML math (`math_max2/3`, `math_ceil2`), no
alloc/lock/I/O. Pure calculator.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace DRM atomic modeset / DC validate → DML21 mode_support
→ CalculatePrefetchSchedule. Reachable on DCN4 family (DCN401/42/42B;
dcn401_resource.c sets `.using_dml21 = true`). Not a syscall crash path;
it is the normal display-mode path for those GPUs.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same unadjusted `Tsw_est` pattern remains in DCN5 DML21 and
older VBA DML (dcn31/32/314). Not a tree-wide systematic fix;
DCN4-specific.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4.
- File and function exist. Current tree already has the fixed `Tsw_est*`
  lines (fa0300333db07 is an ancestor of HEAD; also in v7.3-rc1).
- Bug introduced with DCN401 sources (v6.11). This 7.3 codebase includes
  that IP.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Expected apply on this tree: clean (context matches). No
conflicting local changes around those three assignments.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No earlier alternate fix of these `Tsw_est*` lines. No revert.
DCN5 still unfixed (different file).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [drm/amd/display DML21 DCN4] [IMPORTANT] — not mm/core, but
current AMD dGPU/APU display mode library. DCN401 is GC 12.0
(RDNA4-class). Affects all users of that display IP.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Very active (DC drops, DCN42B, DCN6). This is a calculator
correction in a mature DCN4 path, not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / DCN4-family AMD display (DCN401/42/42B with
DML21). Not universal; not staging.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Trigger is DML prefetch scheduling during mode validation,
especially near rounding boundaries and when fclk changes. Common for
anyone setting modes or changing clocks on those GPUs. Unprivileged
userspace can trigger via KMS modeset. Not a rare CONFIG-only path.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: [False mode validation failure / non-monotonic fclk] [MEDIUM,
user-visible HIGH on affected HW]
- Not panic, UAF, deadlock, or filesystem corruption.
- Result: atomic commit / mode rejected; valid timing or a clock
  increase can fail. That is a real display functional bug (blank / mode
  not available / DPM clock bump fails), not cosmetic logging.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: DCN4 users keep modes that should work; fclk increases remain
  monotonic. High for that hardware, moderate globally.
- Risk: 3-line DML tweak, internally consistent with existing margins,
  reviewed/tested. Low.
- Ratio: favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real user-visible bug: DML falsely fails prefetch/mode validation.
- Concrete symptom: raising fclk can make validation fail.
- Small, obviously correct vs quarter-line VM/row ceils already in this
  function.
- Reviewed-by Dillon Varone, Tested-by Dan Wheeler, SOB Alex Deucher.
- DCN4 DML21 is in this 7.3-rc4 tree; fix applies cleanly.
- Similar DML prefetch correctness patches have historically been stable
  material (underflow/clamp fixes).
- Standalone; no new API.

AGAINST:
- Not a crash, security hole, leak, or data-corruption bug.
- No external reporter / syzbot / Fixes: tag.
- Landed inside a 49-patch DC dump, not highlighted as a stable item.
- DML float tweaks can in principle change which modes pass; residual
  underflow risk is low but non-zero.
- DCN5 sibling calculator left unchanged (DCN4-only).

UNRESOLVED:
- lore.kernel.org (b4 dig and stable list) returned HTTP errors; amd-gfx
  archive was used instead.
- No public reproducer beyond the author’s fclk example.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — quarter-line math matches
   existing 0.75/0.25/0.5 paths; Tested-by + Reviewed-by.
2. Fixes a real bug that affects users? PASS — false mode reject on DCN4
   validation, including fclk increase.
3. Important issue? PASS — display mode / clock-validation failure on
   current AMD DCN4 hardware is a serious functional bug for those users
   (not a panic, but modeset/DPM can fail).
4. Small and contained? PASS — 6 insertions / 3 deletions, one function.
5. No new features or APIs? PASS.
6. Can apply to the local tree? PASS — file/function present; hunk
   matches this tree.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None of device-ID / quirk / DT / build / docs. Qualifies as a
normal small correctness fix.

Step 9.4: MAKE YOUR DECISION
This tree is 7.3.0-rc4 and contains DCN4 DML21. The patch is a small,
reviewed correction so prefetch time estimates match the quarter-line
rounding the hardware/DML already applies. Without it, valid modes can
be rejected and raising fclk can fail validation. That is a real display
bug, not a feature or cleanup. Risk is low relative to the benefit for
DCN4 users of this codebase.

Verification:
- [Phase 1] Parsed tags: Reviewed-by Dillon Varone; Tested-by Dan
  Wheeler; SOB Matthew Stewart, Fangzhi Zuo, Alex Deucher; no
  Fixes:/Reported-by/Cc: stable
- [Phase 2] Diff: 3 `Tsw_est*` assignments in
  `CalculatePrefetchSchedule`; subtract 3/4, 1/4, 2/4 LineTime
- [Phase 2] Confirmed later code ceils VM/row to quarter-lines and
  already uses 0.75/0.25/0.5 LineTime in the BW-update path
- [Phase 3] `git merge-base --is-ancestor fa0300333db07 HEAD` → yes
  (exit 0)
- [Phase 3] File added in 70839da636050; in v6.11+, not in v6.10; fix in
  v7.3-rc1+
- [Phase 3] blame: original DCN401 DML (Aurabindo Pillai) / DML21
  reintegration (Austin Zheng)
- [Phase 4] b4 dig: lore server error (UNVERIFIED via b4)
- [Phase 4] amd-gfx: patch 46/49 of DC July 20 2026 (149310 cover,
  149359 patch); no NAK; not Cc: stable
- [Phase 4] lore.kernel.org/stable: 403 (UNVERIFIED)
- [Phase 5] Callers: mode_support and mode_programming in the same file;
  `PrefetchSupported &= !NoTimeForPrefetch`
- [Phase 5] dcn401_resource.c `.using_dml21 = true`
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37;
  kernelversion 7.3.0-rc4; buggy/fixed code present
- [Phase 6] DCN5 still has unadjusted Tsw_est (different IP)
- [Phase 8] Failure mode: false DML mode validation fail, not oops
- UNVERIFIED: whether older LTS trees need a `dml2/` vs `dml2_0/` path
  tweak (out of scope for this checkout)

**YES**

 .../dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c   | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
index da865bd466c9a..c32b704627085 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c
@@ -5554,7 +5554,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 				+ 2 * (p->PixelPTEBytesPerRow * p->HostVMInefficiencyFactor + p->meta_row_bytes + tdlut_row_bytes)
 				+ *p->prefetch_sw_bytes)
 				/ (*p->Tpre_rounded - *p->Tno_bw);
-			s->Tsw_est1 = *p->prefetch_sw_bytes / s->prefetch_bw1;
+			/* due to rounding, VM can clamp to +1/4, Row can clamp to +2/4, giving SW less time */
+			s->Tsw_est1 = *p->prefetch_sw_bytes / s->prefetch_bw1 - 3.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw1 = 0;
 
@@ -5578,7 +5579,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 		if (*p->Tpre_rounded - *p->Tno_bw - 2.0 * s->Tr0_trips_rounded > 0) {
 			s->prefetch_bw2 = (vm_bytes * p->HostVMInefficiencyFactor + *p->prefetch_sw_bytes) /
 			(*p->Tpre_rounded - *p->Tno_bw - 2.0 * s->Tr0_trips_rounded);
-			s->Tsw_est2 = *p->prefetch_sw_bytes / s->prefetch_bw2;
+			/* due to rounding, VM can clamp to +1/4  */
+			s->Tsw_est2 = *p->prefetch_sw_bytes / s->prefetch_bw2 - 1.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw2 = 0;
 
@@ -5592,7 +5594,8 @@ static bool CalculatePrefetchSchedule(struct dml2_core_internal_scratch *scratch
 		if (*p->Tpre_rounded - s->Tvm_trips_rounded > 0) {
 			s->prefetch_bw3 = (2 * (p->PixelPTEBytesPerRow * p->HostVMInefficiencyFactor + p->meta_row_bytes + tdlut_row_bytes) + *p->prefetch_sw_bytes) /
 				(*p->Tpre_rounded - s->Tvm_trips_rounded);
-			s->Tsw_est3 = *p->prefetch_sw_bytes / s->prefetch_bw3;
+			/* due to rounding, Row can clamp to +2/4  */
+			s->Tsw_est3 = *p->prefetch_sw_bytes / s->prefetch_bw3 - 2.0 * s->LineTime / 4.0;
 		} else
 			s->prefetch_bw3 = 0;
 
-- 
2.53.0

