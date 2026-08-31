Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7464D991E;
	Mon, 31 Aug 2026 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183561; cv=none; b=MegFHdemMlMWIDcFa6OPgxWWYjhXypwxfeJ3Bf4aEUJIj7fxVUubs2ZppppymhRG8n8ESBWbuVVZg7bejWYPHToLr56annJssQ43mdQEVrPQ5BMT4X4tziP67vom3MAwjYKFaX8lwysX/t9cJndqJxTYz3EBLjwYXlW1Y1IUNr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183561; c=relaxed/simple;
	bh=vHY6Jl553VJECQYLU+oMDKjivkF3q1QFmQGI+oEUIO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tzwc82LweDvoFnYmseZ712f6syniMFs1zVB4zFcWJUHRGwObxcXyWl9x4jix1SiugI0DB2aA1iy/keN2wGdfAthMJj+RaghPQYjF0a9kpHoFKqNl3NJ/gI8XjR1zLNK4LFdhnRp2u9kmOxYjfBsRuoEDCfPyhKW/K3eV5MqOopI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOflBWEl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOflBWEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C488F1F00A3E;
	Mon, 31 Aug 2026 13:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183558;
	bh=rxlzSke5dx2lewStC/NwKN5pYRFhAhn0IpokOQCE2lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOflBWEldI3qPyGN6cRnK1Vz2AljcC3VrQyaND+QoCfPXQgJBUC6d031g4B1CSXZD
	 D3d8Jk//3B1ajCI8yY22bnmOMmgjzQEuSJ3Vb4Bsfzj8scNCeFVrLsMy1U1g5IOQ7A
	 KJ+9Nk2l+wc/KtNjDWcE7FCiuTzOzNw/wDPNkv1hQzwct8/lU65KiBJYxud8w9puj2
	 OdcEzim0+dGDRKgIVyZOgCQfnUv5HwY7DOn8dws41YNq/yudBmQ4xr+4BIq4Qbx4Yp
	 EiXMgGTVAAiva8s9TMyYcPyNDFF93EHXsOK5+tRP/GPEfR3+LT/hKc3JQkgXMGLzbt
	 XFHVfDN/nsfYQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Parth Pancholi <parth.pancholi@toradex.com>,
	=?UTF-8?q?Jo=C3=A3o=20Paulo=20Gon=C3=A7alves?= <joao.goncalves@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>,
	andrzej.hajda@intel.com,
	neil.armstrong@linaro.org,
	rfoss@kernel.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] drm/bridge: tc358768: Set pre_enable_prev_first for reverse order
Date: Mon, 31 Aug 2026 09:23:16 -0400
Message-ID: <20260831133314.4125787-168-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Parth Pancholi <parth.pancholi@toradex.com>

[ Upstream commit 6b2bb5438bcfd7bad868665cd2aed1caf9ba3f2b ]

Enable the pre_enable_prev_first flag on the tc358768 bridge to reverse
the pre-enable order, calling bridge pre_enable before panel prepare.
This ensures the bridge is ready before sending panel init commands in
the case of panels sending init commands in panel prepare function.

Signed-off-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: João Paulo Gonçalves <joao.goncalves@toradex.com> # Toradex Verdin AM62
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260311-tc358768-v2-2-e75a99131bd5@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/bridge: tc358768: Set
pre_enable_prev_first for reverse order`

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/bridge: tc358768]` `[Set]` — bridge initialization
ordering fix for the Toshiba TC358768 DSI-to-RGB bridge.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Parth Pancholi, Tomi Valkeinen (ignore pipeline
  SOB)
- **Tested-by:** João Paulo Gonçalves (Toradex Verdin AM62)
- **Reviewed-by:** Francesco Dolcini (Toradex)
- **Link:** https://patch.msgid.link/20260311-tc358768-v2-2-
  e75a99131bd5@ideasonboard.com
- No Fixes:, Reported-by:, Cc: stable@vger.kernel.org
- Notable: hardware-tested on real Toradex platform; reviewed by vendor
  engineer

### Step 1.3: Body analysis
**Record:**
- **Bug:** Default bridge `pre_enable` order runs panel `prepare` before
  the tc358768 bridge is initialized.
- **Symptom:** Panels that send DSI init commands in `panel->prepare()`
  fail because the bridge/host is not ready.
- **Root cause:** Missing `pre_enable_prev_first` flag to request
  upstream bridge init first.
- **Version info:** Part of v2 7-patch series “Long command support”;
  this patch is standalone (patch 2/7).

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite “Set” wording, this is a functional display-
init bug fix, not cleanup. Same class as `prepare_prev_first` panel
fixes already in this stable tree.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/bridge/tc358768.c` (+2 lines)
- **Function:** `tc358768_dsi_host_attach()`
- **Scope:** Single-file, surgical one-liner

### Step 2.2: Code flow change
**Record:**
- **Before:** Panel bridge created via `drm_panel_bridge_add_typed()`
  with default ordering (`pre_enable_prev_first` only if panel sets
  `prepare_prev_first`).
- **After:** Panel bridge unconditionally gets
  `bridge->pre_enable_prev_first = true`, forcing tc358768
  `atomic_pre_enable` before `drm_panel_prepare()`.
- **Path:** Display modeset / atomic commit enable sequence.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix — DSI initialization ordering.**
- `panel_bridge_atomic_pre_enable()` calls `drm_panel_prepare()`.
- `tc358768_bridge_atomic_pre_enable()` initializes PLL, hardware, DSI
  TX path.
- Without the flag, panel init commands can be sent before the bridge is
  ready → display fails to initialize.
- Setting `pre_enable_prev_first` on the downstream panel bridge
  triggers `drm_atomic_bridge_chain_pre_enable()` to call the previous
  (tc358768) bridge first.

### Step 2.4: Fix quality
**Record:**
- Obviously correct; matches sibling drivers (`tc358762`, `tc358764`,
  `tc358775`, `dw-mipi-dsi`).
- Minimal, no API changes.
- Regression risk: very low — only affects enable ordering for
  tc358768+panel chains.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `tc358768_dsi_host_attach()` panel-bridge block dates to
initial driver import in this tree (`^5d324e5159d9e`). Driver copyright
2020 (Peter Ujfalusi). Bug present since driver lacked this flag.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- `pre_enable_prev_first` infrastructure present in
  `include/drm/drm_bridge.h` and `drivers/gpu/drm/drm_bridge.c`.
- Revert `c12df0f5ca410` (“Revert drm/atomic-helper: Re-order bridge
  chain pre-enable”) by Tomi Valkeinen — global ordering change caused
  regressions; per-bridge flags are the correct targeted approach.
- This tree already has stable backports for the same bug class:
  - `09fe52c728e09` — `drm/panel: sony-td4353-jdi: Enable
    prepare_prev_first`
  - `31b2d7be7540c` — `drm/panel: sharp-ls043t1le01: make use of
    prepare_prev_first`

### Step 3.4: Author context
**Record:** Parth Pancholi (Toradex), Tomi Valkeinen (Ideas On Board,
DRM bridge maintainer). Tomi also authored the global ordering revert.

### Step 3.5: Dependencies
**Record:** Patch 2/7 of “Long command support” series, but
**standalone** — no dependency on patches 1, 3–7. Only adds one flag
assignment.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- Lore/patch URL from commit message blocked by bot protection.
- Retrieved from freedesktop dri-devel archive:
  https://lists.freedesktop.org/archives/dri-
  devel/2025-October/531685.html
- v1 (Oct 2025) and v2 (Mar 2026) versions; committed version matches v2
  with Tested-by/Reviewed-by.
- Part of series: https://patchew.org/linux/20260311-tc358768-v2-0-
  e75a99131bd5@ideasonboard.com/

### Step 4.2: Reviewers
**Record:** CC'd to dri-devel, DRM maintainers (from lore metadata).
Reviewed-by Francesco Dolcini; Tested-by on Toradex Verdin AM62.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla. Hardware validation on Toradex Verdin
AM62. Failure mode: display does not initialize when panel sends DSI
commands in `prepare()`.

### Step 4.4: Series context
**Record:** 7-patch series for long DSI command support. This patch is
independent; other patches add features (long command TX, LP mode, etc.)
not required here.

### Step 4.5: Stable list
**Record:** No explicit stable nomination found in retrieved thread. Not
a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `tc358768_dsi_host_attach()`,
`tc358768_bridge_atomic_pre_enable()`,
`panel_bridge_atomic_pre_enable()`,
`drm_atomic_bridge_chain_pre_enable()`.

### Step 5.2: Callers
**Record:**
- `tc358768_dsi_host_attach()` — DSI host attach during driver probe.
- Enable chain: atomic commit → `drm_atomic_bridge_chain_pre_enable()` →
  bridge `pre_enable` callbacks.
- Reachable on every display modeset for tc358768-based systems.

### Step 5.3: Callees
**Record:** `drm_panel_bridge_add_typed()`, `drm_panel_prepare()` (via
panel bridge), tc358768 HW init in `atomic_pre_enable`.

### Step 5.4: Reachability
**Record:** Triggered on display enable for any system using
`CONFIG_DRM_TOSHIBA_TC358768` with a downstream panel. Common
embedded/industrial use (Toradex AM62).

### Step 5.5: Similar patterns
**Record:** Multiple bridges set `pre_enable_prev_first` (`tc358762`,
`tc358764`, `tc358775`, `dw-mipi-dsi`, `ti-sn65dsi83`). Many panels set
`prepare_prev_first`. Same bug class already backported to this tree for
individual panels.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** `drivers/gpu/drm/bridge/tc358768.c` lines 446–451
lack `pre_enable_prev_first`. Driver built via
`CONFIG_DRM_TOSHIBA_TC358768`.

### Step 6.2: Backport complications
**Record:** **Clean apply** — single line insertion after
`drm_panel_bridge_add_typed()` success path. No conflicts expected.

### Step 6.3: Related fixes already present?
**Record:** Same bug class fixed in this tree for specific panels
(`prepare_prev_first` on sony-td4353-jdi, sharp-ls043t1le01). This
tc358768 fix is the bridge-side equivalent and is **not** yet applied.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/gpu/drm/bridge` — DRM display bridges.
**Criticality: PERIPHERAL** (driver-specific), but affects production
embedded platforms.

### Step 7.2: Activity
**Record:** Active DRM bridge subsystem; recent bridge-chain ordering
work and targeted per-bridge flag fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of TC358768-based boards (e.g., Toradex Verdin AM62)
with panels that initialize over DSI during `prepare()`. Config-
specific: `CONFIG_DRM_TOSHIBA_TC358768`.

### Step 8.2: Trigger conditions
**Record:** Display modeset/enable. Common operation (every boot /
resume). Not a security issue; not unprivileged attack surface.

### Step 8.3: Failure severity
**Record:** **Display fails to initialize** (blank/non-functional
display). **Severity: MEDIUM-HIGH** for affected hardware — system runs
but primary output is broken. Not kernel crash/oops/corruption.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected embedded users; restores display on
  tested hardware.
- **Risk:** VERY LOW — one-line flag set, established pattern, reviewed
  and tested.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real, reproducible hardware bug (Toradex tested)
- One-line, obviously correct fix following established kernel pattern
- Same bug class already backported to **this** 6.18.y tree (panel
  `prepare_prev_first` fixes)
- Infrastructure (`pre_enable_prev_first`) present in tree
- Reviewed and tested
- Standalone — no series dependencies
- Global bridge reorder was reverted; per-bridge flags are the intended
  fix mechanism

**AGAINST backport:**
- Not a crash, security, or data-corruption bug
- Affects specific hardware configuration only
- Part of a larger feature series (though this hunk is independent)

**Unresolved:** b4 dig on commit hash did not match this patch (tree
HEAD is unrelated). Lore primary URL blocked; used freedesktop archive
instead.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — one line, Tested-by +
   Reviewed-by
2. Fixes a real bug? **PASS** — display init ordering on real hardware
3. Important issue? **PASS** — non-functional display on production
   embedded platform (MEDIUM-HIGH; same class as already-accepted stable
   panel fixes)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features/APIs? **PASS** — uses existing
   `pre_enable_prev_first`
6. Can apply to local tree? **PASS** — driver and API present, clean
   apply

### Step 9.3: Exception categories
**Record:** Hardware workaround / bridge initialization quirk — same
category as existing `prepare_prev_first` stable backports in this tree.

### Step 9.4: Decision rationale
This fix addresses the same DSI host-before-panel-init ordering problem
that stable maintainers already accepted in this 6.18.y tree for
individual panel drivers. The tc358768 change applies the fix at the
bridge level for all attached panels, is minimal and tested, and carries
negligible regression risk. For users of TC358768 hardware on stable
kernels, display initialization is broken without it.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Diff: +1 functional line in `tc358768_dsi_host_attach()`
  after `drm_panel_bridge_add_typed()`
- **[Phase 3]** `git describe HEAD`: v6.18.43; `make kernelversion`:
  6.18.43
- **[Phase 3]** `git blame -L 446,451
  drivers/gpu/drm/bridge/tc358768.c`: buggy code present, no
  `pre_enable_prev_first`
- **[Phase 3]** `grep pre_enable_prev_first`: infrastructure in
  `drm_bridge.h`, `drm_bridge.c`; siblings set flag
- **[Phase 3]** `git show c12df0f5ca410`: global bridge reorder
  reverted; per-bridge flags preferred
- **[Phase 3]** `git show 09fe52c728e09`, `31b2d7be7540c`: same bug
  class already backported to this tree by Greg KH
- **[Phase 4]** WebFetch lore URL: blocked (Anubis)
- **[Phase 4]** Retrieved patch from
  https://lists.freedesktop.org/archives/dri-
  devel/2025-October/531685.html
- **[Phase 4]** Patchew series context: patch 2/7, standalone
- **[Phase 4]** b4 dig -c HEAD: did not find this patch (matched
  unrelated series)
- **[Phase 5]** Read `panel_bridge_atomic_pre_enable()`: calls
  `drm_panel_prepare()`
- **[Phase 5]** Read `drm_atomic_bridge_chain_pre_enable()`:
  `pre_enable_prev_first` reverses order
- **[Phase 5]** Read `tc358768_bridge_atomic_pre_enable()`: HW/DSI init
- **[Phase 6]** `grep pre_enable_prev_first
  drivers/gpu/drm/bridge/tc358768.c`: no match — fix not present
- **[Phase 6]** `grep tc358768 Makefile`: `CONFIG_DRM_TOSHIBA_TC358768`
  exists
- **[Phase 8]** Failure mode: display init failure, not kernel crash

**YES**The background `git log -S "tc358768"` search finished. It didn’t
turn up a clean “add tc358768 driver” commit — only merge commits like
`5d324e5159d9e` — which fits this tree’s shallow/squashed history. The
driver is still present in 6.18.43 (`drivers/gpu/drm/bridge/tc358768.c`,
copyright 2020), and the missing `pre_enable_prev_first` line is the
real issue.

**Backport verdict for this 6.18.y tree: YES** — same DSI init-ordering
bug class already accepted here via panel `prepare_prev_first` fixes;
this is a one-line, tested bridge-side fix with negligible risk.

 drivers/gpu/drm/bridge/tc358768.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index fbdc44e162293..b7a9d3fca07ea 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -448,6 +448,8 @@ static int tc358768_dsi_host_attach(struct mipi_dsi_host *host,
 						    DRM_MODE_CONNECTOR_DSI);
 		if (IS_ERR(bridge))
 			return PTR_ERR(bridge);
+
+		bridge->pre_enable_prev_first = true;
 	}
 
 	priv->output.dev = dev;
-- 
2.53.0

