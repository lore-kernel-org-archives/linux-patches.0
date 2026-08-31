Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD8B5875C5;
	Mon, 31 Aug 2026 13:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184215; cv=none; b=HBF02+sSgiBBG3pV74fuKo+RfCt66GVuNPkTQoPRLvtuAJIwr+lpEF1lVcjdFVre1dwEy8ycYAASuWNBK6YXwgeo6BqYuwT+yKgJilHAFjQkVwu0cYineLfMrqPWnAyNAlfE3CYtrZ9sidb8dqeWw4HmncHTWKgYJcG4jP6xWxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184215; c=relaxed/simple;
	bh=uHOsRr9AlSAAS6Gx0GwtXMFvJIT2ss8lf1xq9+LNe5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N6frd+431Sx4e/Lw2aFJ+F7BsSkFXPQKO3RH6YjqNrdEMCi2s5DlKkadVIZ5xToO9/UlbOH3s5p5SlV0ve/v3b3qFLFGHAExNk2DAX6oOzE5JiAz578YBvYFUVIJWUZxCztlDHP6sA5SEbWESE+xdFikuuGWThRGFpULefZykHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/ehLg/c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/ehLg/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694B81F000E9;
	Mon, 31 Aug 2026 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184213;
	bh=fk5hVOIDrn15yQGOza9z7T9PpSYIbdA5T28sdCLMpMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/ehLg/cS1IXx6e4+xeRmAAnCw4YEMUiPP48s8DxPwH0jmAy2BQkCvRAudD8JKvlp
	 Y4CNxo0kQqLeOOjgPm4e7X4R3cv8OpXErZOjdKIRrHtbLoZzJTSR3lseN/yHf6UFfw
	 EL9EkQZgujD5Jh2+4bUBqdrC0vrhJtjl2Qv5KBM49Z7MfDg9nQ6ntm2ehH1mt0RX0j
	 mLHecwsXRWy1m7YyXsZiC2XAkJCQbL24wo+Oy0lJn++2v+0TYWr6GsaqUy0+Q46aC5
	 dOr750i3Uul6r7hjKCPjO4GoLW8Wl5CeaBVjBqqBrcRCMwsFxGW45GQMHxmWAhkG3h
	 QcWLdwj7WsKiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dominik Kaszewski <dominik.kaszewski@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Chenyu Chen <chen-yu.chen@amd.com>,
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
Subject: [PATCH AUTOSEL 6.18-6.6] drm/amd/display: Fix DPMS using partially updated pipe context
Date: Mon, 31 Aug 2026 09:29:47 -0400
Message-ID: <20260831133314.4125787-559-sashal@kernel.org>
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

From: Dominik Kaszewski <dominik.kaszewski@amd.com>

[ Upstream commit 6fd45b5d8955bbc362ac3dfe181529f7b1cfd224 ]

[Why & How]
DPMS functions should not use partially updated pipe context passed
as argument of commit_planes_do_stream_update, and instead use the
one in current_state, which is guaranteed to be the most recently
programmed HW config.

Reviewed-by: Wenjing Liu <wenjing.liu@amd.com>
Signed-off-by: Dominik Kaszewski <dominik.kaszewski@amd.com>
Signed-off-by: Chenyu Chen <chen-yu.chen@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amd/display: Fix DPMS using partially
updated pipe context`

**Local tree:** `v6.18.43` (Makefile: 6.18.43, `DC_VER` "3.2.351")

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/amd/display]` `[Fix]` — DPMS operations must not use a
partially updated `pipe_ctx` from the in-flight commit `context`; they
should use the pipe context from `current_state` (last programmed HW
config).

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reviewed-by | Wenjing Liu \<wenjing.liu@amd.com\> |
| Signed-off-by | Dominik Kaszewski, Chenyu Chen, Alex Deucher |
| Fixes: | **Not present** (expected for candidate review) |
| Reported-by: | **Not present** |
| Cc: stable | **Not present** (not a negative signal) |
| Link: | **Not present** |

Notable: AMD display reviewer sign-off; no syzbot/user bug report.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `commit_planes_do_stream_update()` receives `context`
  (new/partial state). DPMS handlers were passed `pipe_ctx` from that
  partial state instead of the HW-backed state.
- **Symptom:** DPMS off/on and related link blanking can target wrong or
  unprogrammed hardware resources during commits that also update stream
  state.
- **Root cause:** DPMS manipulates live hardware (blank stream, disable
  audio, link training) but was using a pipe context that may not yet
  reflect programmed HW — the same class of problem the adjacent test-
  pattern comment already documents.
- **Version info:** Patch submitted April 15, 2026 as part of "DC
  Patches Apr 20 2026" (patch 17/19).

### Step 1.4: Hidden Bug Fix?
**Record:** No — explicitly labeled a fix. Correctness bug in display
power-management path, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/amd/display/dc/core/dc.c` (+14 / −7)
- **Function:** `commit_planes_do_stream_update()`
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| DPMS off | `set_dpms_off(pipe_ctx)` from `context` |
`set_dpms_off(dpms_pipe_ctx)` from `dc->current_state` |
| Audio disable | `az_disable` via `context` pipe_ctx | via
`current_state` pipe_ctx (with local `audio` pointer) |
| DPMS on | `set_dpms_on(dc->current_state, pipe_ctx)` |
`set_dpms_on(dc->current_state, dpms_pipe_ctx)` |
| OCS workaround | `set_dpms_on` + link checks on `context` pipe_ctx |
same operations on `current_state` pipe_ctx |

**Execution path:** Stream update commits where
`stream_update->dpms_off` is set, or the `blank_stream_on_ocs_change` DP
workaround fires — during `commit_planes_for_stream()` before front-end
programming completes.

### Step 2.3: Bug Mechanism
**Record:** **Logic / correctness fix** — wrong data source for hardware
operations.

`link_set_dpms_off()` and `link_set_dpms_on()` dereference
`pipe_ctx->stream_res` (stream encoders, timing generator),
`pipe_ctx->link_res`, and `pipe_ctx->link_config` to blank streams,
disable audio, and manage DP links. When `context` is only partially
built, those fields may not match what's actually programmed. The test-
pattern block immediately above already states front-end changes are not
yet applied at this stage.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Yes — `set_dpms_on()` already takes
  `dc->current_state`; only the `pipe_ctx` argument was wrong. Fix
  aligns DPMS with that intent.
- **Minimal:** Yes — one new pointer, no API changes.
- **Regression risk:** Very low — uses the same pipe index `j` already
  being iterated; reviewed by AMD display engineer.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy DPMS lines (3693–3714) blame to `5d324e5159d9e`
(shallow tree limits deeper history). Function and buggy pattern are
present in this checkout.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related File History
**Record:** Repo is shallow (~11,547 commits). `dc.c` shows only two
recent commits in this clone. Patch is **17/19** in "DC Patches Apr 20
2026" but this specific change only touches the DPMS block in `dc.c` and
does not depend on other series entries (dcn42 clock gating, power
module, etc.).

### Step 3.4: Author Context
**Record:** Dominik Kaszewski (AMD display). Reviewed by Wenjing Liu
(AMD). Signed off by Alex Deucher (AMD DRM maintainer). Author has other
DC display work in the broader ecosystem.

### Step 3.5: Dependencies
**Record:** **Standalone.** No prerequisite commits required; only
changes which `pipe_ctx` pointer DPMS uses. Applies cleanly against
current `dc.c` at lines 3693–3714.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Found at https://lists.freedesktop.org/archives/amd-
gfx/2026-April/142846.html (patch 17/19). No replies on that page; no
explicit stable nomination found.

### Step 4.2: Reviewers
**Record:** Cover letter CC'd AMD display maintainers (Harry Wentland,
Leo Li, Aurabindo Pillai, Roman Li, etc.). Patch has `Reviewed-by:
Wenjing Liu`.

### Step 4.3: Bug Reports
**Record:** No external bug report, syzbot, or KASAN report. Internal
AMD correctness fix.

### Step 4.4: Series Context
**Record:** Part of 19-patch DC drop (Apr 2026). This patch is
independent — other series items (power module, dcn42 changes, double-
free fix) are separate. Patch 5 ("Align HWSS fast commit path with
legacy path") may increase exposure but is not a prerequisite for this
fix's correctness.

### Step 4.5: Stable List
**Record:** lore.kernel.org stable search blocked (bot protection). No
stable discussion found via cover letter or patch page.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `commit_planes_do_stream_update()` — modified. Calls
`link_set_dpms_off()` / `link_set_dpms_on()` via `dc->link_srv`.

### Step 5.2: Callers
**Record:** `commit_planes_do_stream_update()` called from
`commit_planes_for_stream()` (line 4201), which is invoked from
`update_planes_and_stream_v2()` / v3 commit paths — the standard display
commit pipeline used by `dc_commit_updates_for_stream()`.

### Step 5.3: Callees
**Record:** `set_dpms_off` → `link_set_dpms_off()` (blanks stream,
disables audio, DP link teardown). `set_dpms_on` → `link_set_dpms_on()`
(link enable, infoframes, stream attribute setup). Both require valid
`stream_res` and `link_res` from programmed HW.

### Step 5.4: Reachability
**Record:**
- `link_set_all_streams_dpms_off_for_link()` →
  `dc_commit_updates_for_stream()` with `stream_update.dpms_off` (link
  hotplug/detection paths)
- DPMS during atomic commits when stream updates include power-state
  changes
- `blank_stream_on_ocs_change` workaround for DP output color-space
  changes

**Userspace reachable:** Yes — display blank/unblank, suspend/resume,
hotplug, and mode commits on AMDGPU systems with `CONFIG_DRM_AMD_DC`.

### Step 5.5: Similar Patterns
**Record:** Test-pattern handling in the same function (lines 3670–3690)
explicitly documents that only `current_state` can be used for HW
operations at this commit stage. DPMS was inconsistent with that
established pattern.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Lines 3693–3714 in
`drivers/gpu/drm/amd/display/dc/core/dc.c` use `pipe_ctx` from `context`
for all DPMS operations. The fix is **not** yet applied in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected** — single hunk, no structural
conflicts visible. Line numbers differ slightly from lore patch (3898 vs
3693) but code matches.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix found via grep or log search in this tree.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem & Criticality
**Record:** `drivers/gpu/drm/amd/display` — **IMPORTANT** (AMD GPU
display stack; affects all AMDGPU users with DC enabled, not core
kernel).

### Step 7.2: Activity
**Record:** Actively maintained; recent commit in tree is DMUB aux
validation fix (`1ecde19bfce65`).

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** AMDGPU users with `CONFIG_DRM_AMD_DC` — laptops/desktops
with AMD GPUs using the modern display core (DCN2+).

### Step 8.2: Trigger Conditions
**Record:** Any commit that includes a `stream_update` with `dpms_off`
(or OCS color-space workaround) while `context` has partially updated
pipe state. Common during screen blank/unblank, link power events, and
combined stream updates.

### Step 8.3: Failure Mode Severity
**Record:**
- Display fails to blank or wake correctly
- Wrong encoder/link programmed → black screen, flicker
- Audio endpoint disable on wrong resource
- Potential NULL/invalid `stream_res` dereference if partial context
  lacks populated resources

**Severity: HIGH** (user-visible display failures; possible oops on bad
pointers — not confirmed by report but plausible from code inspection of
`link_set_dpms_off()`).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — fixes real DPMS correctness on a widely used
  driver path
- **Risk:** VERY LOW — 7-line logical change, AMD-reviewed, mirrors
  existing in-function pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real correctness bug in DPMS HW programming path
- User-visible impact (screen power, suspend/resume, hotplug)
- Small, surgical, AMD-reviewed fix
- Buggy code confirmed present in v6.18.43
- Standalone — no series dependencies
- Consistent with documented constraint in adjacent test-pattern code

**AGAINST backport:**
- No user/syzbot report (internal discovery)
- Part of larger DC patchset (but this hunk is independent)
- AMDGPU-specific, not universal kernel path

**Unresolved:** Exact kernel version that introduced the buggy DPMS-
in-`commit_planes_do_stream_update` pattern (shallow history). Does not
affect the decision for this tree where the bug exists.

### Step 9.2: Stable Rules Checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — logic is clear;
Reviewed-by from AMD display |
| 2. Fixes a real user-affecting bug? | **PASS** — DPMS uses wrong pipe
context during commits |
| 3. Important issue? | **PASS** — display blank/wake failures, possible
crash |
| 4. Small and contained? | **PASS** — 1 file, ~14 lines |
| 5. No new features/APIs? | **PASS** |
| 6. Applies to local tree? | **PASS** — buggy code present, clean apply
expected |

### Step 9.3: Exception Categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix) —
standard bug fix.

### Step 9.4: Decision Rationale
For **v6.18.43**, the buggy DPMS path exists and the fix is a minimal,
obviously correct correction that ensures display power-management
operations use the hardware-backed `current_state` pipe context rather
than a partially built commit context. This prevents incorrect blanking,
wake failures, and potential resource dereference on a common AMDGPU
commit path. The fix is self-contained and low-risk.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and lore page
- **[Phase 2]** Read diff hunks; verified `link_set_dpms_off/on` use
  `pipe_ctx->stream_res` and `link_res` in `link_dpms.c`
- **[Phase 3]** `git describe HEAD` → v6.18.43; `git blame -L 3690,3715`
  → buggy lines present; shallow repo confirmed
- **[Phase 3]** `git log -S "set_dpms_off(pipe_ctx)" -- dc.c` → only
  merge commit (limited by shallow history)
- **[Phase 4]** WebFetch lore patch 17/19 at
  https://lists.freedesktop.org/archives/amd-gfx/2026-April/142846.html
- **[Phase 4]** WebFetch cover letter 00/19 — series context, no stable
  nomination
- **[Phase 4]** lore.kernel.org stable search — blocked by bot
  protection (UNVERIFIED for stable-list discussion)
- **[Phase 5]** `grep commit_planes_do_stream_update` — one call site at
  line 4201 in `commit_planes_for_stream()`
- **[Phase 5]** Traced `dc_commit_updates_for_stream()` →
  `update_planes_and_stream_v2/v3` → `commit_planes_for_stream()`
- **[Phase 5]** Read `link_set_all_streams_dpms_off_for_link()` — calls
  `dc_commit_updates_for_stream` with `dpms_off`
- **[Phase 6]** Read `dc.c` lines 3587–3735 — confirmed buggy code
  without fix
- **[Phase 6]** `DC_VER` in `dc.h` → "3.2.351"; fix not present
- **[Phase 7]** Subsystem path confirmed: `drivers/gpu/drm/amd/display`
- **[Phase 8]** Analyzed `link_set_dpms_off()` at line 2346 — uses
  stream_enc, blank_stream, audio disable on pipe_ctx resources

**YES**

 drivers/gpu/drm/amd/display/dc/core/dc.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 927837249479f..627a9fb4c551e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3690,27 +3690,34 @@ static void commit_planes_do_stream_update(struct dc *dc,
 				resource_build_test_pattern_params(&context->res_ctx, pipe_ctx);
 			}
 
+			// DPMS should not use partially updated pipe context
+			struct pipe_ctx *dpms_pipe_ctx = &dc->current_state->res_ctx.pipe_ctx[j];
+
 			if (stream_update->dpms_off) {
 				if (*stream_update->dpms_off) {
-					dc->link_srv->set_dpms_off(pipe_ctx);
+					dc->link_srv->set_dpms_off(dpms_pipe_ctx);
 					/* for dpms, keep acquired resources*/
-					if (pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only)
-						pipe_ctx->stream_res.audio->funcs->az_disable(pipe_ctx->stream_res.audio);
+					if (dpms_pipe_ctx->stream_res.audio && !dc->debug.az_endpoint_mute_only) {
+						struct audio *audio = dpms_pipe_ctx->stream_res.audio;
+
+						audio->funcs->az_disable(audio);
+					}
 
 					dc->optimized_required = true;
 
 				} else {
 					if (get_seamless_boot_stream_count(context) == 0)
 						dc->hwss.prepare_bandwidth(dc, dc->current_state);
-					dc->link_srv->set_dpms_on(dc->current_state, pipe_ctx);
+					dc->link_srv->set_dpms_on(dc->current_state, dpms_pipe_ctx);
 				}
-			} else if (pipe_ctx->stream->link->wa_flags.blank_stream_on_ocs_change && stream_update->output_color_space
-					&& !stream->dpms_off && dc_is_dp_signal(pipe_ctx->stream->signal)) {
+			} else if (dpms_pipe_ctx->stream->link->wa_flags.blank_stream_on_ocs_change &&
+					stream_update->output_color_space &&
+					!stream->dpms_off && dc_is_dp_signal(dpms_pipe_ctx->stream->signal)) {
 				/*
 				 * Workaround for firmware issue in some receivers where they don't pick up
 				 * correct output color space unless DP link is disabled/re-enabled
 				 */
-				dc->link_srv->set_dpms_on(dc->current_state, pipe_ctx);
+				dc->link_srv->set_dpms_on(dc->current_state, dpms_pipe_ctx);
 			}
 
 			if (stream_update->abm_level && pipe_ctx->stream_res.abm) {
-- 
2.53.0

