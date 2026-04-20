Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089873FB04E;
	Mon, 20 Apr 2026 13:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691580; cv=none; b=W/nXqkyKQ0jrAm/kFUajhRO1PMtkFWa9SPHHbrNbC3PDhXZ6kBQMOPcZdOBqdElTHedBeJhTts9lXRoAtjt57fJqvAUB+oDAkAJjj/s5c9puJnmMrN3FUKWP/MrSk13v+sA1fjLSsQWSGK0iIod0HqSrTW+wjxBjdepAVPxtt6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691580; c=relaxed/simple;
	bh=y22peYpMlpSzuER+C2gLxScD6Jxm+fW4HrEpcE8vri8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TEUWisG3vLYjdZEEaUpgV6lIVucKU5MqS11vYm61qw7SoWxAZx8FIDo1fNk2yz3l/XnZcf1SknQ2bsWpG4g7JTbHEDAW2Gr4i22DlvU+9I8YBJTgkfjmEF3JduxdMdLO8zlpgznaErgSew09e+qyOlMXg8xhVhQoKMxE/0OX224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YqyCHUeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YqyCHUeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FED0C2BCC6;
	Mon, 20 Apr 2026 13:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691579;
	bh=y22peYpMlpSzuER+C2gLxScD6Jxm+fW4HrEpcE8vri8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqyCHUeEC/t0W4qRTRY+/yUqP4l4oQeahUL4R8HwMqiSJuS4xhMs7BhZVY12Ptu0T
	 GktHsOFVxiU9wb0U3f8H75deCBAVli4idmM9l8faX+BmXbwvpkSaYPILASzNf2BlWk
	 rz7fIpMW55de5ScZP6+7gk6AP8Ak+1ARztP6+t571HgZ5cv27Z2x6urdHlk/3edPSX
	 vq2pb77p+A1NmwrwfWl+QMYugwVoNiUuO7/H38T78tqnNOihy7rVNiYm5WeytlDOkB
	 BX9ykWWvXMy/Hh9miTqVv5JKOIQ4e7KmgAxch6qtE95f6nk+snkDQ/hwm/sREOiyHd
	 raUjMhuO4/eXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>,
	kernel test robot <lkp@intel.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	Frank.Li@nxp.com,
	dri-devel@lists.freedesktop.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/imx: parallel-display: add DRM_DISPLAY_HELPER for DRM_IMX_PARALLEL_DISPLAY
Date: Mon, 20 Apr 2026 09:18:26 -0400
Message-ID: <20260420132314.1023554-112-sashal@kernel.org>
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

From: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>

[ Upstream commit 02df94d98ff837074788ce921edf67707dbad404 ]

When I build for an old imx53 platform I see the same as the test robot
saw before:

arm-buildroot-linux-gnueabihf-ld: drivers/gpu/drm/imx/ipuv3/parallel-display.o: in function `imx_pd_bind':
parallel-display.c:(.text+0xb8): undefined reference to `drm_bridge_connector_init'

Selecting DRM_DISPLAY_HELPER for DRM_IMX_PARALLEL_DISPLAY fixes the build.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512241721.jZgcwRfr-lkp@intel.com/

Signed-off-by: Martin Kepplinger-Novakovic <martin.kepplinger-novakovic@ginzinger.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patch.msgid.link/20260121102607.4087362-1-martin.kepplinger-novakovic@ginzinger.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** drm/imx: parallel-display
- **Action verb:** "add" (Kconfig dependency)
- **Summary:** Add missing `DRM_DISPLAY_HELPER` Kconfig select for
  `DRM_IMX_PARALLEL_DISPLAY`
- Record: [drm/imx subsystem] [add missing dependency] [fixes link error
  for drm_bridge_connector_init]

### Step 1.2: Tags
- **Reported-by:** kernel test robot `<lkp@intel.com>` — automated build
  testing found this
- **Closes:** lore link to kbuild error report
- **Signed-off-by:** Martin Kepplinger-Novakovic (author), Philipp Zabel
  (maintainer)
- **Reviewed-by:** Philipp Zabel (subsystem maintainer)
- **Link:** patch.msgid.link to original submission
- No Fixes: tag, no Cc: stable (expected for manual review candidates)
- Record: Kernel test robot reported build failure. Subsystem maintainer
  reviewed AND committed.

### Step 1.3: Body Text
The commit message includes the exact linker error:
```
arm-buildroot-linux-gnueabihf-ld: ... undefined reference to
`drm_bridge_connector_init'
```
The author confirms reproducing this on a real imx53 platform build. The
fix is explicitly stated: "Selecting DRM_DISPLAY_HELPER for
DRM_IMX_PARALLEL_DISPLAY fixes the build."

Record: [Build failure — linker error for undefined
`drm_bridge_connector_init`] [Symptom: build fails for imx53 parallel
display] [Confirmed by both author and test robot]

### Step 1.4: Hidden Bug Fix Detection
This is explicitly a build fix, not disguised. No hidden complexity.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** 1 (`drivers/gpu/drm/imx/ipuv3/Kconfig`)
- **Lines added:** 1 (`select DRM_DISPLAY_HELPER`)
- **Lines removed:** 0
- **Scope:** Single-file, single-line Kconfig change
- Record: [1 file, +1 line, single Kconfig select statement]

### Step 2.2: Code Flow
- **Before:** `DRM_IMX_PARALLEL_DISPLAY` selects `DRM_BRIDGE_CONNECTOR`
  but not `DRM_DISPLAY_HELPER`
- **After:** Also selects `DRM_DISPLAY_HELPER`

The root cause: `DRM_BRIDGE_CONNECTOR` is defined inside `if
DRM_DISPLAY_HELPER` in `drivers/gpu/drm/display/Kconfig` (line 15-17).
The `drm_bridge_connector.o` object is compiled as part of the
`drm_display_helper` module. Without `DRM_DISPLAY_HELPER` enabled,
`drm_bridge_connector_init()` is never compiled, causing the linker
error.

### Step 2.3: Bug Mechanism
Category: **Build fix** — missing Kconfig dependency causes link
failure.

### Step 2.4: Fix Quality
- Obviously correct: the function is in the `drm_display_helper` module,
  so the module must be selected
- Minimal: 1 line
- Zero runtime regression risk: only affects build-time dependency
  resolution
- Record: [Perfect quality, zero regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
From `git blame`, `DRM_BRIDGE_CONNECTOR` was added to this Kconfig by
commit f673055a46784 ("drm/imx: Add missing DRM_BRIDGE_CONNECTOR
dependency") in the v6.13 cycle. That commit itself was a partial fix —
it added the `DRM_BRIDGE_CONNECTOR` select but missed adding
`DRM_DISPLAY_HELPER`.

### Step 3.2: Root Cause Chain
- Commit 9da7ec9b19d8 ("drm/bridge-connector: move to DRM_DISPLAY_HELPER
  module") moved `drm_bridge_connector` under `DRM_DISPLAY_HELPER` —
  root cause
- Commit 5f6e56d3319d2 ("drm/imx: parallel-display: switch to
  drm_panel_bridge") introduced bridge usage
- Commit f673055a46784 added `select DRM_BRIDGE_CONNECTOR` but missed
  `DRM_DISPLAY_HELPER`
- The bug is that several commits were applied to bring bridge_connector
  to imx but the Kconfig dependency chain was incomplete

### Step 3.3: Prerequisite Check
All prerequisite commits (5f6e56d3319d2, f673055a46784, ef214002e6b38)
are already in v7.0. This fix applies standalone.

### Step 3.4: Author Context
Martin Kepplinger-Novakovic is a recognized contributor (has
MAINTAINERS/CREDITS changes). The fix was reviewed by Philipp Zabel, the
actual subsystem maintainer for drm/imx.

### Step 3.5: Stable Tree Applicability
- **v6.12:** Bug does NOT exist — `parallel-display.c` doesn't call
  `drm_bridge_connector_init()` (verified: 0 occurrences)
- **v6.13:** Bug EXISTS — Kconfig has `select DRM_BRIDGE_CONNECTOR` but
  not `select DRM_DISPLAY_HELPER`
- **v6.14:** Bug EXISTS — same Kconfig state as v6.13
- **v7.0:** Bug EXISTS — confirmed identical Kconfig state, fix applies
  cleanly

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.2: Original Discussion
- b4 dig for the prior commit (f673055a46784) found the thread at lore.
  It was a single-patch fix
- The current fix was submitted by the author after hitting the build
  failure on real hardware
- Reviewed-by from Philipp Zabel (the drm/imx maintainer who also
  committed it)

### Step 4.3: Bug Report
The kernel test robot (kbuild) reported the linker error, referenced in
the Closes: tag.

### Step 4.4-4.5: Series Context
Standalone single-patch fix, no dependencies on other uncommitted
patches.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Analysis
`drm_bridge_connector_init()` is called at line 206 of `parallel-
display.c` in `imx_pd_bind()`. This is the driver probe/bind path —
critical for anyone using the i.MX parallel display interface. Without
this fix, the driver simply cannot be built (link error).

### Step 5.5: Similar Patterns
Many other DRM drivers already `select DRM_DISPLAY_HELPER` alongside
`DRM_BRIDGE_CONNECTOR` (verified via grep: bridge/Kconfig,
panel/Kconfig, rockchip/Kconfig all have it). The IMX parallel display
was simply missed.

---

## PHASE 6: CROSS-REFERENCING

### Step 6.1: Bug Exists in Stable
Confirmed the bug exists in v7.0. The Kconfig file in v7.0 exactly
matches the "before" state of the diff.

### Step 6.2: Backport Complexity
**Clean apply** — the diff applies directly to v7.0 without any
modifications.

### Step 6.3: No Existing Fix
No alternative fix exists in v7.0 for this issue.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Path:** drivers/gpu/drm/imx/ipuv3
- **Criticality:** PERIPHERAL (embedded i.MX ARM platform, but has real
  users building kernels for imx53 boards)

### Step 7.2: Activity
The subsystem has moderate activity with several recent Kconfig fixes
for the same dependency chain.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
Anyone building a kernel with `CONFIG_DRM_IMX_PARALLEL_DISPLAY=y/m`
where `DRM_DISPLAY_HELPER` is not otherwise selected. This affects
embedded Linux developers targeting i.MX53 platforms.

### Step 8.2: Trigger
100% reproducible — any build with the right config fails. Not a timing
issue.

### Step 8.3: Severity
**Build failure** — the kernel cannot be compiled with this driver
enabled. Severity: HIGH for affected users.

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — fixes a hard build failure, enables compilation of
  i.MX parallel display driver
- **Risk:** NEAR-ZERO — 1-line Kconfig `select` addition, no runtime
  code change whatsoever
- **Ratio:** Excellent

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes a real, reproducible build failure (linker error)
- Single-line Kconfig change — minimal scope
- Zero runtime regression risk
- Reported by kernel test robot AND reproduced by author on real
  hardware
- Reviewed and committed by subsystem maintainer
- Bug exists in v7.0 (verified)
- Clean apply to v7.0

**AGAINST backporting:**
- None identified

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — Kconfig dependency is
   unambiguously needed
2. Fixes a real bug? **YES** — hard build failure
3. Important issue? **YES** — prevents building the driver entirely
4. Small and contained? **YES** — 1 line in 1 file
5. No new features or APIs? **YES** — purely a build dependency fix
6. Can apply to stable? **YES** — clean apply verified

### Step 9.3: Exception Category
This is a **BUILD FIX** — one of the explicitly allowed exception
categories for stable.

---

## Verification

- [Phase 1] Parsed tags: Reported-by kernel test robot, Reviewed-by
  Philipp Zabel (maintainer), Closes link to kbuild report
- [Phase 2] Diff analysis: +1 line `select DRM_DISPLAY_HELPER` in
  Kconfig
- [Phase 3] git blame: `DRM_BRIDGE_CONNECTOR` added by f673055a46784 in
  v6.13 cycle without matching `DRM_DISPLAY_HELPER`
- [Phase 3] git show v7.0:Kconfig: confirmed bug exists (missing select
  DRM_DISPLAY_HELPER)
- [Phase 3] git show v6.12:parallel-display.c: confirmed 0 calls to
  `drm_bridge_connector_init`, bug doesn't exist pre-6.13
- [Phase 3] git show v6.13/v6.14:Kconfig: confirmed bug present in both
- [Phase 4] b4 dig -c f673055a46784: found original thread for the
  incomplete fix
- [Phase 5] Grep: `drm_bridge_connector_init` called at line 206 in
  `imx_pd_bind()`
- [Phase 5] Grep: `DRM_BRIDGE_CONNECTOR` inside `if DRM_DISPLAY_HELPER`
  at display/Kconfig:15-17
- [Phase 5] Grep: `drm_display_helper-$(CONFIG_DRM_BRIDGE_CONNECTOR)` in
  display/Makefile confirms build dependency
- [Phase 6] v7.0 Kconfig state matches diff's "before" — clean apply
  guaranteed
- [Phase 8] Failure mode: 100% reproducible link error, severity HIGH
  for affected configs

This is a textbook build fix: one-line Kconfig dependency addition, zero
runtime risk, fixes a hard build failure for i.MX parallel display
users. It meets every stable kernel criterion.

**YES**

 drivers/gpu/drm/imx/ipuv3/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/imx/ipuv3/Kconfig b/drivers/gpu/drm/imx/ipuv3/Kconfig
index acaf250890019..b2240998df4f1 100644
--- a/drivers/gpu/drm/imx/ipuv3/Kconfig
+++ b/drivers/gpu/drm/imx/ipuv3/Kconfig
@@ -15,6 +15,7 @@ config DRM_IMX_PARALLEL_DISPLAY
 	depends on DRM_IMX
 	select DRM_BRIDGE
 	select DRM_BRIDGE_CONNECTOR
+	select DRM_DISPLAY_HELPER
 	select DRM_IMX_LEGACY_BRIDGE
 	select DRM_PANEL_BRIDGE
 	select VIDEOMODE_HELPERS
-- 
2.53.0

