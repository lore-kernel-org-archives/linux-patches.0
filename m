Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DE8488220;
	Mon, 31 Aug 2026 13:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183492; cv=none; b=cONr7/f18yY3hjWfp6uessCPZPs1I1dngDg9s8yIVb9iTFpVPReyOI0QwiNBUdQNSqHnyOyyQGiP20p+0er207a2+9x0IcKjC05Re+rgePkJ0htVOI7LPtsx6wjqR0a+Ig1iGY4k6L/DMwOknfigZKqaO7lIddBPDZyvWk+DwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183492; c=relaxed/simple;
	bh=igJpQ2+b/DsIumtd3nbGGpq60b6OsY4v6n8eMlQJtQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m1IyZS8vrwc+ewj7x+m/HgTbKMa/c5GbvXJNzqLab6/N3HWnoWFpri1pLprpLpIW6nCl+Et3oZaYBwgAvkwES7IXL25CElEITol6u7ox3Xxp7N6Kwt8cbzqpHmod8sCQujwu311f3VJZKTaNabnYAw/Lt7Gw/meec4f6WJfk8o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f6Kduyzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f6Kduyzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8C041F00A3E;
	Mon, 31 Aug 2026 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183490;
	bh=OwyQs7/xmQtiE48ERpgIMcjpcG+CGJsvatd3D6VjQYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f6KduyzxCUe+tEgSMVuBeTUINKpebs2sxPJdXss1IZLaA1zb/wjU6HCSlbN4tDE4G
	 /8DB8hV1pVNPBVI1KDlVpVIvZAAvez1AZhRavInno8h8PezxCL5JPMjrYRAFzfe1kN
	 0RXqWvFLqWqKsp+PtGlwGeauueLl9dFR/H+9UVNrBSz7NcKGtdfWVgNcVH5IEdH1rH
	 vgMGIMa16FaBx9gZkfCTW6ogH/SVEk5Tq+oO3FW5FEgV5iQdSYjmsfHwZ4cyV2A4Qi
	 qIZ5JnkZbuOlaEUl+b+zATWrSNbFth0rj4AUyvAa+PnL4oSIsEnowfemdBdFmO/oZL
	 cQ9UdXQWdmuoQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
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
Subject: [PATCH AUTOSEL 6.18] drm/amd/display: Avoid DPMS-on for phantom stream
Date: Mon, 31 Aug 2026 09:22:35 -0400
Message-ID: <20260831133314.4125787-127-sashal@kernel.org>
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

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 10f5f9c0ef32d08b228bfee3684b62f36f395852 ]

[Why & How]
Calling dc_update_planes_and_stream separately for stream and its
phantom stream causes a NULL pointer dereference, since the phantom is
destroyed on the first call.

Skip the call for phantom streams.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/amd/display: Avoid DPMS-on for phantom
stream`

**Local tree:** `stable/linux-6.18.y` at **v6.18.44** (`git describe
HEAD` / `make kernelversion` → 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/amd/display]` `[Avoid]` — Skip DPMS-on stream updates
for phantom (SubVP) streams during DP link-training automation to
prevent a NULL pointer dereference.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Alvin Lee \<alvin.lee2@amd.com\>
- **Tested-by:** Daniel Wheeler \<daniel.wheeler@amd.com\>
- **Signed-off-by:** Ilya Bakoulin, Ray Wu, Alex Deucher (maintainer)
- **No** Fixes:, Reported-by:, Link:, Cc: stable@vger.kernel.org
- Notable: Reviewed and tested by AMD display engineers; Alex Deucher
  acked (subsystem maintainer).

### Step 1.3: Body analysis
**Record:**
- **Bug:** Calling `dc_update_planes_and_stream()` separately for a real
  stream and its paired phantom stream causes a NULL pointer
  dereference.
- **Symptom:** Kernel oops / crash in the display driver during DP link
  retrain automation.
- **Root cause (author):** The phantom stream is destroyed on the first
  `dc_update_planes_and_stream()` call; a second call uses a stale/freed
  pointer.
- **Fix:** Skip phantom streams when building the list of streams to
  update with DPMS-on.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit NULL-deref fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:**
  `drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c` (+2
  lines)
- **Function:** `dp_retrain_link_dp_test()`
- **Scope:** Single-file, surgical fix (2 lines added)

### Step 2.2: Code flow change
**Record:**
- **Before:** Loop over `state->streams[i]` on the link caches every
  stream (including phantoms), then calls
  `dc_update_planes_and_stream()` for each.
- **After:** Streams with `is_phantom == true` are skipped during
  caching; only real streams get DPMS-on updates.
- **Path affected:** DP link retrain / compliance-test automation error
  path in `dp_retrain_link_dp_test()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** NULL pointer dereference (memory safety)
- **Mechanism:** `dc_update_planes_and_stream()` with
  `stream_update->dpms_off` forces `UPDATE_TYPE_FULL` (verified in
  `check_update_surfaces_for_stream()` at lines 2966–2996 of `dc.c`).
  Full updates call `dc_state_remove_phantom_streams_and_planes()` and
  `dc_state_release_phantom_streams_and_planes()` (lines 3529–3530 of
  `dc.c`), freeing phantom streams. The second loop iteration still
  holds a cached phantom pointer → NULL deref.

### Step 2.4: Fix quality
**Record:**
- Fix is obviously correct and minimal.
- Matches existing convention: `resource_log_pipe_topology_update()`
  already skips `is_phantom` streams (`dc_resource.c:2419`).
- Regression risk: very low — phantom streams should not receive
  independent DPMS-on updates.
- No API or structural changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- Buggy loop introduced by **f5b69101f956f** (2025-07-17): "Cache
  streams targeting link when performing LT automation"
- That commit is an ancestor of v6.18.0 and of current HEAD.
- `is_phantom` on `struct dc_stream_state` dates to **012a04b1d6af6**
  (2023-11-21).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:**
- **f5b69101f956f** — introduced stream caching loop (root of this bug
  pattern)
- **89939cf252d80** (2025-09-29) — different NULL-deref fix in same
  function: cache `dc` from `link->dc` instead of stale
  `state->clk_mgr->ctx->dc` after first stream update. Already in
  6.18.44 but does **not** fix the phantom-stream issue.
- Fix commit **10f5f9c0ef32d** (upstream) / **56337aae2421b** (stable
  candidate) is **not** in 6.18.44.
- Standalone fix; not part of a multi-patch series.

### Step 3.4: Author context
**Record:** Ilya Bakoulin is an active AMD display contributor (link/DP
fixes). Alex Deucher is amdgpu/drm maintainer.

### Step 3.5: Dependencies
**Record:**
- Requires `is_phantom` field — present in this tree
  (`dc_stream.h:313`).
- Requires stream-caching loop from f5b69101 — present in this tree.
- Cherry-pick of upstream **10f5f9c0ef32d** auto-merges cleanly against
  6.18.44 (verified).
- **Standalone:** PASS.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5
**Record:**
- `b4 dig -c 10f5f9c0ef32d`: no lore match found.
- lore.kernel.org fetch: 403 Forbidden (bot protection).
- **UNVERIFIED:** No mailing-list thread or stable-list discussion
  retrieved.
- Tags show AMD internal review (Reviewed-by, Tested-by) and maintainer
  sign-off.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dp_retrain_link_dp_test()` modified; calls
`dc_update_planes_and_stream()`.

### Step 5.2: Callers
**Record:**
- `dp_test_send_link_training()` → `dp_handle_automated_test()` (DP
  compliance test / link-training automation)
- `dp_set_preferred_training_settings()` path at line 991 (preferred
  link settings retrain during normal DP operation)

### Step 5.3: Callees
**Record:** `dc_update_planes_and_stream()` →
`update_planes_and_stream_v3/v2()` → phantom removal on FULL updates.

### Step 5.4: Reachability
**Record:**
- Trigger requires SubVP/MALL phantom streams on a DP link (`is_phantom
  == true`).
- Triggered during DP link retrain (compliance testing or preferred-
  settings retrain).
- Not a direct unprivileged syscall path, but reachable during normal
  display hotplug/link-rate changes on AMD GPUs with SubVP enabled.
- Config: `CONFIG_DRM_AMD_DC` (common on AMD systems).

### Step 5.5: Similar patterns
**Record:** `dc_resource.c:2419` skips phantom streams in topology
logging — same semantic rule applied here.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Lines 145–148 of `link_dp_cts.c` cache all link
streams without phantom skip. Bug present since v6.18.0 (f5b69101 is
ancestor of v6.18).

### Step 6.2: Backport complications
**Record:** Clean apply — cherry-pick test succeeded with auto-merge.
Only contextual difference from upstream is the already-applied `struct
dc *dc = link->dc` from 89939cf; phantom skip is independent.

### Step 6.3: Related fixes already present?
**Record:** 89939cf fixes a **different** NULL deref in the same
function (stale `dc` context). Phantom-stream NULL deref remains unfixed
in 6.18.44.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/gpu/drm/amd/display` — **IMPORTANT** (AMD GPU
display driver; crash on affected hardware configs).

### Step 7.2: Activity
**Record:** Actively maintained; multiple recent fixes in
`link_dp_cts.c` on this branch.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** AMD GPU users with SubVP/MALL phantom streams on a
DisplayPort link during link retrain or DP compliance-test automation.

### Step 8.2: Trigger conditions
**Record:**
- SubVP phantom stream active on the DP link
- DP link retrain via `dp_retrain_link_dp_test()`
- Moderately rare compared to general kernel paths, but real on modern
  AMD APUs/laptops with power-saving display features

### Step 8.3: Failure mode
**Record:** NULL pointer dereference → kernel oops. **Severity: HIGH**
(system crash when triggered).

### Step 8.4: Risk vs benefit
**Record:**
- **Benefit:** Prevents kernel crash on a real, reproducible code path;
  2-line fix.
- **Risk:** Very low — aligns with existing phantom-skip patterns
  elsewhere.
- **Ratio:** Favorable for stable backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes verified NULL pointer dereference
- Small (2 lines), obviously correct
- Buggy code confirmed in 6.18.44 since v6.18.0
- Applies cleanly
- Reviewed, tested, maintainer-signed
- Complements but does not duplicate existing 89939cf fix

**AGAINST backport:**
- Narrow trigger (SubVP + DP link retrain)
- No public bug report or syzbot trace in commit message

**UNRESOLVED:**
- Mailing-list discussion (b4/lore unavailable)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (code review + Tested-by)
2. Fixes real bug affecting users? **PASS** (NULL deref on real path)
3. Important issue? **PASS** (kernel crash — HIGH severity when
   triggered)
4. Small and contained? **PASS** (2 lines, 1 file)
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** (verified cherry-pick)

### Step 9.3: Exception categories
**Record:** None — standard bug fix.

### Step 9.4: Decision rationale
This commit fixes a real NULL pointer dereference in the 6.18.y tree.
The buggy stream-caching loop has been present since v6.18.0; the fix is
not yet in 6.18.44. The existing 89939cf fix addresses a separate stale-
context NULL deref in the same function. The phantom-stream skip is
minimal, follows established conventions, applies cleanly, and prevents
a kernel oops on AMD systems using SubVP during DP link retrain.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show 10f5f9c0ef32d`
- **[Phase 2]** Read `link_dp_cts.c:65-157`, `dc.c:2927-2996`,
  `dc.c:3526-3530`, `dc_state.c:916-956`
- **[Phase 3]** `git blame -L 145,148 link_dp_cts.c` → f5b69101f956f
- **[Phase 3]** `git log --oneline` on `link_dp_cts.c` → f5b69101,
  89939cf present; phantom fix absent
- **[Phase 3]** `git merge-base --is-ancestor f5b69101 HEAD` → in tree;
  `10f5f9c0ef32d` → NOT in tree
- **[Phase 3]** `git merge-base --is-ancestor f5b69101 v6.18` → buggy
  code in v6.18.0
- **[Phase 4]** `b4 dig -c 10f5f9c0ef32d` → no match; lore fetch → 403
- **[Phase 5]** `grep dp_retrain_link_dp_test` → callers at lines 185,
  601, 991
- **[Phase 5]** `grep is_phantom` → field exists in `dc_stream.h:313`;
  skip pattern in `dc_resource.c:2419`
- **[Phase 6]** `git describe HEAD` → v6.18.44; buggy code confirmed at
  lines 145-148 without phantom skip
- **[Phase 6]** Cherry-pick test of 10f5f9c0ef32d → auto-merge success
- **[Phase 8]** Failure mode: NULL deref on second
  `dc_update_planes_and_stream()` call after phantom freed

**YES**

 drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
index 2676ae9f6fe83..5f70793b8372e 100644
--- a/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
+++ b/drivers/gpu/drm/amd/display/dc/link/accessories/link_dp_cts.c
@@ -143,6 +143,8 @@ static void dp_retrain_link_dp_test(struct dc_link *link,
 	// Set DPMS on with stream update
 	// Cache all streams on current link since dc_update_planes_and_stream might kill current_state
 	for (i = 0; i < MAX_PIPES; i++) {
+		if (state->streams[i] && state->streams[i]->is_phantom)
+			continue;
 		if (state->streams[i] && state->streams[i]->link && state->streams[i]->link == link)
 			streams_on_link[num_streams_on_link++] = state->streams[i];
 	}
-- 
2.53.0

