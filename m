Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57183BE632;
	Mon, 20 Apr 2026 13:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691036; cv=none; b=uai+LCeYrXHlRnHWazs9CNWHzo86nbczqfUroENui8nd94b/RlX8+CWQwY4+x820RnBPZU8xp7VHl6tYLZwkU5S89lJwxa6DeD3cLrY+CXqdE9ESOkqrDmkXsorHk30h0Qq3JkKJKp+4eM8U8xYWz5LaKol97IoAnvTZROlwY5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691036; c=relaxed/simple;
	bh=v+YKt47OzZz2vi95JOA5Cavf8tQENiTTUFpgqDmIr2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UMkDYah8sxhSK4Ud5DZJhub25SPFJkaB3VWewOtDYw+fJnoNWO7q3GCWhGrmfASEJhiN2sk9tSQepN5Ki+lbyuKQcLooK1o/z6hikcMFo2oVBAVKf86pQzygBi9G18tZSxuYWchTjAQ88gwD9BZBzeimx6fkdFzREDvFmL9UKh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QTEE//Ss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QTEE//Ss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE6C2BCB9;
	Mon, 20 Apr 2026 13:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691036;
	bh=v+YKt47OzZz2vi95JOA5Cavf8tQENiTTUFpgqDmIr2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTEE//SsQ2XbVShuOKIKQEMkFJoCxFOOePx786YOMLDofpg+q1u52B4/MJJ3Hqk8p
	 keGPzl2PmBJnbzWBclWtehKxN57zYoZCwKfYspr3oJ23KmrWuQ375N0Gcl2410Ahhb
	 tKwEE/AwH2ljVg+vWMTKT7OTuR8EgEqnMsYVWDLmnAFafK2ppCCouK8CiVH6UqwFEB
	 XAq8vHPDC8c+zQgjnChQq2T8hbnwoVY5pNywtt0VU2oxNWC6gSqVbdI4V/oj3xkNBY
	 PGtidE9TKKEFMG9iRxKfO2DTU8QHWOyn3wDlEdiDyeU2r9FQ2a7TN4gTGy2YP7lpbe
	 lPkpHh5NrzmLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Charlene Liu <Charlene.Liu@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amd/display: Fix dcn401_optimize_bandwidth
Date: Mon, 20 Apr 2026 09:08:42 -0400
Message-ID: <20260420131539.986432-56-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit 002f32db0d4292f117994c330928d2374887b28e ]

[Why&How]
We should check for != zstate disallow and programming extend blank from a
different struct.

Reviewed-by: Leo Chen <leo.chen@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amd/display` (AMD GPU display controller)
- Action verb: "Fix"
- Summary: Fix dcn401_optimize_bandwidth function

Record: [drm/amd/display] [Fix] [Corrects zstate condition and struct
access in dcn401_optimize_bandwidth]

**Step 1.2: Tags**
- Reviewed-by: Leo Chen, Dmytro Laktyushkin (AMD display engineers)
- Tested-by: Dan Wheeler (AMD test engineer)
- Signed-off-by: Charlene Liu (author), Ivan Lipski (submitter), Alex
  Deucher (AMD GPU maintainer)
- No Fixes: tag, no Cc: stable (expected for autosel candidates)

Record: Two reviewers, one tester, submitted through AMD's standard
display patch process. Author is an AMD display team member.

**Step 1.3: Commit Body**
The message says "We should check for != zstate disallow and programming
extend blank from a different struct." This describes two bugs:
1. The zstate check condition was too restrictive
2. The extended blank register value was being read from the wrong
   struct

Record: Two bugs described. Both relate to incorrect programming of
extended blank during bandwidth optimization for DCN4.01 display
hardware.

**Step 1.4: Hidden Bug Fix Detection**
Not hidden — explicitly labeled as "Fix" with clear description.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file changed:
  `drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c`
- 2 lines changed (1 condition, 1 struct access)
- Function modified: `dcn401_optimize_bandwidth`
- Scope: Single-file, single-function surgical fix

**Step 2.2: Code Flow Change**

Change 1 (line 1476→1486):
- Before: `if (zstate_support == DCN_ZSTATE_SUPPORT_ALLOW)` — only
  enters the extended blank programming block when zstate is exactly
  `ALLOW`
- After: `if (zstate_support != DCN_ZSTATE_SUPPORT_DISALLOW)` — enters
  for ALL allow modes

The enum `dcn_zstate_support_state` has values: UNKNOWN, ALLOW,
ALLOW_Z8_ONLY, ALLOW_Z8_Z10_ONLY, ALLOW_Z10_ONLY, DISALLOW. The old code
missed Z8_ONLY, Z8_Z10_ONLY, and Z10_ONLY modes.

Change 2 (line 1484):
- Before: `pipe_ctx->dlg_regs.min_dst_y_next_start` — reads from old
  DML1 struct `_vcs_dpi_display_dlg_regs_st`
- After: `pipe_ctx->hubp_regs.dlg_regs.min_dst_y_next_start` — reads
  from DML2.1 struct `dml2_dchub_per_pipe_register_set`

**Step 2.3: Bug Mechanism**

Bug 1 (Logic/correctness): Wrong condition excludes valid z-state power
modes from extended blank programming. This is a logic bug where the
original code was copied from DCN20 which only had ALLOW/DISALLOW, but
DCN401 has additional modes (Z8, Z10, etc.).

Bug 2 (Wrong struct access): DCN401 uses DML2.1 which populates
`pipe_ctx->hubp_regs`. The old `pipe_ctx->dlg_regs` is populated by
DML2.0's `dml21_update_pipe_ctx_dchub_regs`, which was removed in commit
63ab80d9ac0a. Reading from the wrong struct yields zero/stale data.

**Step 2.4: Fix Quality**
- Obviously correct: aligns with how all other DCN clk_mgr code checks
  zstate (`!= DISALLOW`), and aligns with how all other DCN401 code
  accesses hubp_regs
- Minimal/surgical: exactly 2 lines
- No regression risk: both changes narrow in on the correct behavior

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code was introduced by commit `70839da636050` (Aurabindo
Pillai, 2024-04-19) "drm/amd/display: Add new DCN401 sources". This
commit first appeared in v6.11.

The dlg_regs bug was latent until commit `63ab80d9ac0a` (Rafal
Ostrowski, 2024-12-17) "drm/amd/display: DML2.1 Post-Si Cleanup" which
removed `dml21_update_pipe_ctx_dchub_regs` that was populating
`pipe_ctx->dlg_regs`. This commit is in v6.14+ only.

Record: zstate bug exists since v6.11. dlg_regs bug became active in
v6.14 when the function populating the old struct was removed.

**Step 3.2: No Fixes: tag** (expected)

**Step 3.3: File History**
Recent file changes are mostly unrelated (NULL ptr deref fix, DPP
guards, cursor offload). No prerequisites for this fix.

**Step 3.4: Author**
Charlene Liu is a regular AMD display team contributor with many commits
in the subsystem. Ivan Lipski is the submitter who regularly contributes
AMD display fixes.

**Step 3.5: Dependencies**
No dependencies. The fix is standalone — both `hubp_regs` and the zstate
enum values exist since v6.11.

## PHASE 4: MAILING LIST

**Step 4.1: Original Submission**
Found at: `https://yhbt.net/lore/amd-
gfx/20260218165116.155001-6-IVAN.LIPSKI@amd.com/`
Part of a 9-patch series "DC Patches February 18, 2026". This is patch
5/9. The series includes other display fixes (cursor, DPIA, compiler
warnings).

**Step 4.2: Reviewers**
Appropriate AMD display maintainers and engineers were CC'd: Harry
Wentland, Leo Li, Aurabindo Pillai, Wayne Lin, Tom Chung, and the
specific reviewers Leo Chen and Dmytro Laktyushkin.

**Step 4.3: Bug Report**
No specific bug report link found. This appears to be found during
internal code review/testing at AMD.

**Step 4.4: Series Independence**
Other patches in the series (cursor pos fix, DPIA fix, type mismatch)
are independent. This fix is standalone.

**Step 4.5: No stable-specific discussion found.**

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Modified Function**
`dcn401_optimize_bandwidth` — called during display bandwidth
optimization after clock updates.

**Step 5.2: Callers**
`dcn401_optimize_bandwidth` is a hardware sequencer function registered
in the DCN401 init table. It is called during DC bandwidth optimization,
which occurs on display mode changes, resolution changes, and power
state transitions.

**Step 5.3: Callees**
The affected code calls
`pipe_ctx->plane_res.hubp->funcs->program_extended_blank()` which
programs display hardware registers for extended blanking during z-state
power saving.

**Step 5.4: Call Chain**
Reachable via standard display mode setting paths (user-triggered via
xrandr, display manager, etc.) and power management transitions. This is
not an obscure path.

**Step 5.5: Similar Patterns**
DCN20 (`dcn20_hwseq.c:2458`) has the same `== DCN_ZSTATE_SUPPORT_ALLOW`
pattern, which is potentially also a bug but uses the old DML path where
`pipe_ctx->dlg_regs` IS populated.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence**
- DCN401 code exists since v6.11
- `hubp_regs` field exists since v6.11 (commit 00c391102abc)
- The dlg_regs regression was introduced in v6.14 (commit 63ab80d9ac0a)
- Both bugs are present in v7.0

**Step 6.2: Backport Difficulty**
The patch should apply cleanly to v7.0.y — the modified lines are
unchanged from when they were introduced. For v6.14.y+, both fixes
apply. For v6.12.y and earlier, only the zstate fix applies (dlg_regs is
still populated there).

**Step 6.3: No related fixes in stable.**

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** drm/amd/display — IMPORTANT subsystem. DCN401 is AMD's
display controller for newer GPUs. Display bugs directly affect user
experience.

**Step 7.2:** Actively developed subsystem with frequent commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of AMD GPUs with DCN4.01 display controller
hardware.

**Step 8.2:** Triggers during power management transitions (z-state
changes) — common on laptops and energy-efficient desktops. The zstate
bug triggers whenever Z8/Z10 power modes are selected instead of full
Z-state.

**Step 8.3:** Failure mode is incorrect display hardware programming:
- Without extended blank programming during z-states: display artifacts,
  flickering, or incorrect power management behavior
- With wrong/zero value for min_dst_y_next_start: incorrect blank
  timing, potential display corruption
- Severity: HIGH (visible display issues for affected hardware)

**Step 8.4:**
- Benefit: HIGH — fixes real display hardware programming bugs for
  DCN401 users
- Risk: VERY LOW — 2-line change, obviously correct, reviewed and tested
- Ratio: Strongly favors backporting

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Fixes two real bugs: incorrect zstate condition and wrong struct
  access
- Small, surgical fix (2 lines)
- Reviewed by two AMD display engineers, tested
- Affects real hardware (DCN401 GPUs)
- Display bugs directly affect user experience
- Consistent with how other DCN code handles zstate and hubp_regs

AGAINST backporting:
- DCN401 is relatively new hardware (v6.11+)
- No user bug reports (found during code review)
- The dlg_regs bug only manifests in v6.14+ (after DML2.1 cleanup)

**Step 9.2: Stable Rules**
1. Obviously correct? YES — aligns with all other zstate checks and
   hubp_regs usage
2. Fixes real bug? YES — wrong hardware programming values
3. Important issue? YES — display correctness on affected hardware
4. Small and contained? YES — 2 lines, 1 function, 1 file
5. No new features? CORRECT — pure bug fix
6. Applies to stable? YES — cleanly for v7.0.y

**Step 9.3:** No exception category — standard bug fix.

**Step 9.4:** The evidence clearly supports backporting.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Leo Chen and Dmytro Laktyushkin,
  Tested-by Dan Wheeler, author Charlene Liu
- [Phase 2] Diff analysis: 2 lines changed in
  dcn401_optimize_bandwidth(): broadened zstate condition and fixed
  struct access
- [Phase 2] Verified enum values at `dc.h:665-671`: 6 states including
  ALLOW, Z8_ONLY, Z8_Z10_ONLY, Z10_ONLY, DISALLOW
- [Phase 2] Verified `pipe_ctx->hubp_regs` is `struct
  dml2_dchub_per_pipe_register_set` containing `dlg_regs` with
  `min_dst_y_next_start` field
- [Phase 2] Verified `pipe_ctx->dlg_regs` is the OLD
  `_vcs_dpi_display_dlg_regs_st` struct (different type)
- [Phase 3] git blame: buggy code introduced in commit 70839da636050
  (v6.11, "Add new DCN401 sources")
- [Phase 3] Confirmed `hubp_regs` added in commit 00c391102abc (also
  v6.11)
- [Phase 3] Confirmed dlg_regs regression introduced by 63ab80d9ac0a
  (v6.14, "DML2.1 Post-Si Cleanup") which removed
  `dml21_update_pipe_ctx_dchub_regs`
- [Phase 3] Verified `dml21_utils.c:225` populates `pipe_ctx->hubp_regs`
  via memcpy for DCN401 (DML2.1 path)
- [Phase 3] Verified DCN401 uses DML2.1 (`dcn401_resource.c` has
  `.using_dml21 = true`)
- [Phase 3] Verified other DCN401 code uses
  `pipe_ctx->hubp_regs.dlg_regs` (dcn401_hwseq.c:2889-2892)
- [Phase 4] Found original submission at lore (patch 5/9 in DC Patches
  Feb 18 2026 series)
- [Phase 4] Appropriate AMD display maintainers were CC'd
- [Phase 5] Confirmed `program_extended_blank` is registered in hubp
  function tables for DCN31/DCN35
- [Phase 6] Verified 63ab80d9ac0a is NOT in v6.12/v6.13 but IS in v6.14+
- [Phase 6] Both bugs present in v7.0
- [Phase 8] Display correctness issue for DCN401 GPU users during power
  state transitions

The fix is small, surgical, obviously correct, reviewed, tested, and
fixes real display hardware programming bugs for DCN401 users. It meets
all stable kernel criteria.

**YES**

 drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
index 4973d36aadc5d..a3d33d10853b8 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn401/dcn401_hwseq.c
@@ -1492,7 +1492,7 @@ void dcn401_optimize_bandwidth(
 			dc->clk_mgr,
 			context,
 			true);
-	if (context->bw_ctx.bw.dcn.clk.zstate_support == DCN_ZSTATE_SUPPORT_ALLOW) {
+	if (context->bw_ctx.bw.dcn.clk.zstate_support != DCN_ZSTATE_SUPPORT_DISALLOW) {
 		for (i = 0; i < dc->res_pool->pipe_count; ++i) {
 			struct pipe_ctx *pipe_ctx = &context->res_ctx.pipe_ctx[i];
 
@@ -1500,7 +1500,7 @@ void dcn401_optimize_bandwidth(
 				&& pipe_ctx->stream->adjust.v_total_min == pipe_ctx->stream->adjust.v_total_max
 				&& pipe_ctx->stream->adjust.v_total_max > pipe_ctx->stream->timing.v_total)
 					pipe_ctx->plane_res.hubp->funcs->program_extended_blank(pipe_ctx->plane_res.hubp,
-						pipe_ctx->dlg_regs.min_dst_y_next_start);
+						pipe_ctx->hubp_regs.dlg_regs.min_dst_y_next_start);
 		}
 	}
 }
-- 
2.53.0

