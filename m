Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45D54A2E21;
	Mon, 31 Aug 2026 13:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183537; cv=none; b=JIPSvRW6EbYgMR01CKkYlnnxXLsXiwb6jF8OBgZzvqG5EVfssuvKLEyOGCPW627lmce3IYTHlyYjArZV1Mm0Uwz0INtBRlNrmxArm35z5lAmfLuqQueAAciA1UInIPkkX6wdaD6FLKI1oBWp8vvSh6H4KBvBImZdaTC/95LwuLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183537; c=relaxed/simple;
	bh=Mg6cn8wPN/5wsaI6yxBLBmmxHQ9VttDdM8eAvANPoW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vALoq0TQb/gxUXUhH8FbEqxLqrV1D9WUXqHL7MeniHPR0FosAf0ZJBpxIdPbSrSi4Xc4u0SS7XeM+sL7qvffNamRXLKvamEECYGSjCkZfxuzOrh5K0o7lX2kmpCkXVoMRj2jmF1sqTtZgSffaram6CxVH4Xw4uambDbczcCJRpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E/6V0Gdd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E/6V0Gdd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E1D1F00A3F;
	Mon, 31 Aug 2026 13:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183534;
	bh=wOW0ZfBeyWJuYHQLhB25GOFyKp0J9Uk15Hii1aRJ9iU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/6V0GddSxBbniGU/HoguwIHYU8MrfoM4pMpIPTq8YsKyW3gYICuClrZExcRDsee1
	 EZS7bH84/6MqKk6m5MGPJ9ESLr58kTWyZTqjF4UoRkFsZgSTQ3vYX2gWn4UqyPWw0A
	 HujaGm0bwIa0c4WptJA9kaCS6wDInf2azKjAr4BTiRi1gj3n3dx2HMuIHQZ6++VTiu
	 cSoeEZlFpiMMW/WeaG0Dea7n0dRqswWfx1VAmmznIMM5m/pXW2A2MDVshqlVjwhtUi
	 d/bixS/ixLKw043EDcZDrRckbwyUmFQaYYtu1lLOht3ZEgdJHuXfmz7gbg753rt756
	 T9rq/2dqJGcqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Heidelberg <david@ixit.cz>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/panel: Enable GPIOLIB for panels which uses functions from it
Date: Mon, 31 Aug 2026 09:23:02 -0400
Message-ID: <20260831133314.4125787-154-sashal@kernel.org>
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

From: David Heidelberg <david@ixit.cz>

[ Upstream commit ae3aa8cf5fd5ccb428a814e7eb38ae33ad1cfa34 ]

These panels used on sdm845 devices are using GPIOLIB functions,
ensure it's enabled.

Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260505-panel-clean-up-kconfig-dep-v2-4-9cc31d6e6919@ixit.cz
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `drm/panel: Enable GPIOLIB for panels which
uses functions from it`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[drm/panel]` `[Enable]` — Add missing `GPIOLIB` Kconfig
dependencies for DRM panel drivers that call GPIO descriptor APIs.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** David Heidelberg `<david@ixit.cz>` (author)
- **Reviewed-by:** Neil Armstrong `<neil.armstrong@linaro.org>`
  (drm/panel maintainer)
- **Signed-off-by:** Neil Armstrong `<neil.armstrong@linaro.org>`
- **Link:** https://patch.msgid.link/20260505-panel-clean-up-kconfig-
  dep-v2-4-9cc31d6e6919@ixit.cz
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, or syzbot
  tags
- Notable: Reviewed-by from subsystem maintainer; patch 4/4 of a Kconfig
  cleanup series (v2)

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Five panel Kconfig entries can be enabled without `GPIOLIB`,
  even though their `.c` drivers call `devm_gpiod_get()` /
  `gpiod_set_value*()`.
- **Symptom:** Broken or invalid kernel configuration on SDM845-class
  devices (Poco F1, etc.); panel drivers selected without GPIO support
  compiled in.
- **Root cause:** Missing `depends on GPIOLIB` in Kconfig for drivers
  that use GPIO consumer APIs.
- **Version info:** None in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Yes — presented as Kconfig cleanup, but it fixes a real
configuration correctness bug. Without `GPIOLIB`, `devm_gpiod_get()`
stubs return `-ENOSYS` and probe fails (verified in `panel-ebbg-
ft8719.c`). Not a crash, but a broken driver configuration path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/gpu/drm/panel/Kconfig` only (+9 / -2)
- **Configs modified:** 7 entries
  - **Adds `depends on GPIOLIB`:** `DRM_PANEL_EBBG_FT8719`,
    `DRM_PANEL_LG_SW43408`, `DRM_PANEL_NOVATEK_NT36672A`,
    `DRM_PANEL_NOVATEK_NT36672E`, `DRM_PANEL_VISIONOX_RM69299`
  - **Reformats only (already had GPIOLIB):**
    `DRM_PANEL_JDI_LPM102A188A`, `DRM_PANEL_RAYDIUM_RM69380` (`depends
    on OF && GPIOLIB` → separate lines)
- **Scope:** Single-file, surgical Kconfig fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Kconfig allows `CONFIG_DRM_PANEL_*=y/m` with
  `CONFIG_GPIOLIB=n`.
- **After:** Panel options are only visible/selectable when `GPIOLIB` is
  enabled, ensuring GPIO infrastructure is present when these drivers
  are built.
- **Affected path:** Kernel configuration / module build selection, not
  runtime hot path.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Kconfig dependency / configuration correctness (related
  to build-fix exception)
- **Mechanism:** Drivers include `<linux/gpio/consumer.h>` and call
  `devm_gpiod_get()` / `gpiod_set_value*()`. Without `depends on
  GPIOLIB`, Kconfig does not enforce the dependency. With `GPIOLIB=n`,
  header stubs compile but return `-ENOSYS` at probe time.

### Step 2.4: Fix quality
**Record:** Obviously correct and minimal. Each affected driver verified
to use GPIO APIs. No runtime logic changed. Regression risk: very low
(Kconfig-only). Two entries already had GPIOLIB — only formatting
changes there.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Affected Kconfig entries trace to `19eef1d98eeda` in this
tree's history. Drivers have used `devm_gpiod_get` since introduction
(verified via `git log -S devm_gpiod_get`). Bug present since drivers
were added without GPIOLIB dependency.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: File history for related changes
**Record:** Recent `Kconfig` changes in this tree:
- `3139b806923b1` — `drm/panel: s6e3ha8: fix unmet dependency on
  DRM_DISPLAY_HELPER` (already backported)
- `d003d9bb44da1` — `drm/panel: Clean up S6E3HA2 config dependencies` —
  **patch 3/4 of same series**, adds GPIOLIB to S6E3HA8 (already
  backported)
- This commit (patch 4/4) is **not** in HEAD (`ae3aa8cf5fd5` is not an
  ancestor of HEAD)

### Step 3.4: Author's other commits
**Record:** David Heidelberg authored `d003d9bb44da1` (patch 3, already
in 6.18.y). Neil Armstrong reviewed both.

### Step 3.5: Prerequisites
**Record:** Standalone Kconfig change. Patch 3 of the series is already
in this tree; patch 1 (S6E3FC2X01) is not present (that config doesn't
exist here). This patch applies independently for the five panels
missing GPIOLIB.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c ae3aa8cf5fd5 -a` found v1 and v2 series on lore.
v2 message ID matches commit Link tag. `b4 dig -w` failed (lore fetch
error). WebFetch of lore blocked by Anubis bot protection. Web search
confirmed upstream commit `ae3aa8cf5fd5` and series context.

### Step 4.2: Reviewers
**Record:** Neil Armstrong (drm/panel maintainer) provided `Reviewed-
by`. Series cover letter (from search) describes Kconfig dependency
cleanup verified against all driver source files.

### Step 4.3: Bug report
**Record:** No formal bug report or syzbot link. Issue identified
through Kconfig dependency audit (same class as `kconfirm`-found s6e3ha8
fix already in this tree).

### Step 4.4: Related patches
**Record:** 4-patch series:
1. S6E3FC2X01 cleanup — not applicable (config absent in 6.18.y)
2. (unclear numbering in resends)
3. S6E3HA2 GPIOLIB + help text — **already in tree** (`d003d9bb44da1`)
4. **This commit** — GPIOLIB for 5 additional panels

### Step 4.5: Stable mailing list
**Record:** UNVERIFIED — lore stable search blocked. No evidence against
backport found.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No C functions modified. Affected probe functions in driver
`.c` files use GPIO APIs:
- `panel_ebbg_ft8719_probe()` — `devm_gpiod_get()`,
  `gpiod_set_value_cansleep()`
- `panel_lg_sw43408` — `devm_gpiod_get()`, `gpiod_set_value()`
- `panel_novatek_nt36672a/e` — `devm_gpiod_get()`, `gpiod_set_value()`
- `panel_visionox_rm69299` — `devm_gpiod_get()`, `gpiod_set_value()`

### Step 5.2: Callers
**Record:** Probe functions called from module init / device
registration during boot on platforms with these panels (SDM845 phones,
Poco F1, etc.).

### Step 5.3: Callees
**Record:** `devm_gpiod_get()`, `gpiod_set_value()`,
`gpiod_set_value_cansleep()` from GPIOLIB (or stubs when `GPIOLIB=n`).

### Step 5.4: Reachability
**Record:** Reachable on ARM64 platforms with these panel device trees
when the panel driver is enabled. Common on SDM845 devices mentioned in
the commit message.

### Step 5.5: Similar patterns
**Record:** Many other panel Kconfig entries in the same file already
have `depends on GPIOLIB`. S6E3HA8 received the same fix in
`d003d9bb44da1` already backported here. Consistent with established
pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** In 6.18.43, these five configs lack `GPIOLIB`:
- `DRM_PANEL_EBBG_FT8719` (line 110: `depends on OF` only)
- `DRM_PANEL_LG_SW43408` (line 421)
- `DRM_PANEL_NOVATEK_NT36672A` (line 525)
- `DRM_PANEL_NOVATEK_NT36672E` (line 535)
- `DRM_PANEL_VISIONOX_RM69299` (line 1121)

All five driver `.c` files confirmed to use GPIO APIs.

### Step 6.2: Backport complications
**Record:** Clean apply expected — single Kconfig file, no conflicts
with recent changes. Two configs (`JDI_LPM102A188A`, `RAYDIUM_RM69380`)
already have GPIOLIB; only formatting differs.

### Step 6.3: Related fixes already present?
**Record:** Patch 3 of same series (`d003d9bb44da1`) and similar unmet-
dependency fix (`3139b806923b1`) already backported. **This specific fix
is not yet in the tree.**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/gpu/drm/panel` — **IMPORTANT** (display subsystem,
mobile/embedded hardware).

### Step 7.2: Subsystem activity
**Record:** Active — recent Kconfig dependency fixes backported to this
6.18.y tree in the same subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of SDM845-class mobile devices (Poco F1, etc.) and
anyone building custom kernels with these panel drivers. Config-
specific, not universal.

### Step 8.2: Trigger conditions
**Record:** Triggered when `CONFIG_DRM_PANEL_<name>=y/m` with
`CONFIG_GPIOLIB=n`. Uncommon on ARM mobile defconfigs (GPIOLIB typically
enabled), but possible with custom/randconfig builds. Not a security
issue.

### Step 8.3: Failure mode severity
**Record:** Panel probe fails with `-ENOSYS` from `devm_gpiod_get()`
stub; display non-functional. **Severity: MEDIUM** (broken hardware
support, not crash/corruption). Kconfig tools may also report unmet
dependencies.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — correct Kconfig dependencies; prevents broken
  panel configs; completes a series partially already backported
- **Risk:** VERY LOW — Kconfig-only, 9 lines, maintainer-reviewed
- **Ratio:** Favorable for backport, especially given precedent in this
  tree

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real Kconfig bug: 5 drivers use GPIOLIB APIs without declaring
  dependency
- Verified in source for all 5 drivers
- Small, surgical, maintainer-reviewed (Neil Armstrong)
- Patch 3 of same series already backported to 6.18.y
- Similar Kconfig unmet-dependency fix (`3139b806923b1`) already in this
  tree
- Build/config fix exception category
- Affects real mobile hardware (SDM845 panels)
- Zero runtime regression risk

**AGAINST backport:**
- Does not cause compile failure (`gpio/consumer.h` provides stubs when
  `GPIOLIB=n`)
- Runtime failure is graceful probe error, not crash/UAF/corruption
- Typical ARM mobile defconfigs already enable GPIOLIB
- Low practical impact for most production users

**Unresolved:**
- Full lore review thread (Anubis blocked WebFetch)
- Whether randconfig/kconfirm explicitly flagged these five panels

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — verified driver/GPIO usage;
   Reviewed-by from maintainer
2. Fixes a real bug? **PASS** — Kconfig allows invalid configuration for
   real hardware
3. Important issue? **PASS (MEDIUM)** — broken display driver config,
   not crash/security
4. Small and contained? **PASS** — 1 file, +9/-2 lines
5. No new features/APIs? **PASS** — Kconfig dependency only
6. Can apply to local tree? **PASS** — buggy code present; clean apply
   expected

### Step 9.3: Exception categories
**Record:** **Build/config fix** — Kconfig dependency correction (same
class as `3139b806923b1` and `d003d9bb44da1` already in 6.18.y).

### Step 9.4: Decision rationale

This is not a critical crash fix, but it is a correct, zero-risk Kconfig
dependency fix for real hardware panel drivers. The 6.18.y tree has
already accepted two nearly identical drm/panel Kconfig dependency fixes
from the same author and reviewer, including patch 3 of this very
series. Leaving patch 4 out leaves five panel drivers with the same
class of bug that was already fixed for S6E3HA8. The fix is small,
obviously correct, and completes consistent Kconfig hygiene in a
subsystem where this tree has established precedent.

---

## Verification

- [Phase 1] Parsed subject, tags; found Reviewed-by Neil Armstrong, Link
  to v2-4 patch
- [Phase 2] Diff: 1 file, +9/-2; 5 configs gain GPIOLIB, 2 reformat only
- [Phase 2] Verified `panel-ebbg-ft8719.c` uses `devm_gpiod_get` +
  `gpiod_set_value_cansleep`
- [Phase 2] Verified `panel-lg-sw43408.c`, `panel-novatek-nt36672a.c`,
  `panel-novatek-nt36672e.c`, `panel-visionox-rm69299.c` use GPIO APIs
- [Phase 2] Read `include/linux/gpio/consumer.h`: stubs provided when
  `CONFIG_GPIOLIB` disabled (no link error, `-ENOSYS` at probe)
- [Phase 3] `git describe HEAD`: v6.18.43; `make kernelversion`: 6.18.43
- [Phase 3] `git merge-base --is-ancestor ae3aa8cf5fd5 HEAD`: NOT IN
  TREE
- [Phase 3] `d003d9bb44da1` (patch 3, S6E3HA2 GPIOLIB) confirmed in tree
- [Phase 3] `3139b806923b1` (s6e3ha8 unmet dependency) confirmed in tree
- [Phase 4] `b4 dig -c ae3aa8cf5fd5 -a`: found v1/v2 series on lore
- [Phase 4] UNVERIFIED: `b4 dig -w` failed; lore WebFetch blocked by
  Anubis
- [Phase 5] Grep confirmed all 5 drivers in `Makefile` and use GPIO
  consumer APIs
- [Phase 6] Grep of `Kconfig`: 5 panels missing GPIOLIB dependency in
  6.18.43
- [Phase 6] `JDI_LPM102A188A` and `RAYDIUM_RM69380` already have GPIOLIB
- [Phase 7] Neil Armstrong is drm/panel maintainer (Reviewed-by)
- [Phase 8] Failure mode: probe `-ENOSYS`, display broken; severity
  MEDIUM
- [Phase 8] Typical ARM defconfigs: GPIOLIB usually enabled; impact
  lower for default configs

**YES**The background check finished: upstream commit `ae3aa8cf5fd5` is
**not** in the current 6.18.43 tree, so the GPIOLIB Kconfig fix still
needs to be backported.

The five affected panel drivers (`EBBG_FT8719`, `LG_SW43408`,
`NOVATEK_NT36672A/E`, `VISIONOX_RM69299`) are still missing the `depends
on GPIOLIB` entries in this tree. Verdict from the analysis: **YES** for
stable backport.

 drivers/gpu/drm/panel/Kconfig | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/Kconfig b/drivers/gpu/drm/panel/Kconfig
index 7354dc85a6aa7..967265ed6fc96 100644
--- a/drivers/gpu/drm/panel/Kconfig
+++ b/drivers/gpu/drm/panel/Kconfig
@@ -107,6 +107,7 @@ config DRM_PANEL_BOE_TV101WUM_LL2
 
 config DRM_PANEL_EBBG_FT8719
 	tristate "EBBG FT8719 panel driver"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -316,7 +317,8 @@ config DRM_PANEL_JADARD_JD9365DA_H3
 
 config DRM_PANEL_JDI_LPM102A188A
 	tristate "JDI LPM102A188A DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -418,6 +420,7 @@ config DRM_PANEL_LG_LG4573
 
 config DRM_PANEL_LG_SW43408
 	tristate "LG SW43408 panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -522,6 +525,7 @@ config DRM_PANEL_NOVATEK_NT36523
 
 config DRM_PANEL_NOVATEK_NT36672A
 	tristate "Novatek NT36672A DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -532,6 +536,7 @@ config DRM_PANEL_NOVATEK_NT36672A
 
 config DRM_PANEL_NOVATEK_NT36672E
 	tristate "Novatek NT36672E DSI panel"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
@@ -660,7 +665,8 @@ config DRM_PANEL_RAYDIUM_RM692E5
 
 config DRM_PANEL_RAYDIUM_RM69380
 	tristate "Raydium RM69380-based DSI panel"
-	depends on OF && GPIOLIB
+	depends on GPIOLIB
+	depends on OF
 	depends on DRM_MIPI_DSI
 	depends on BACKLIGHT_CLASS_DEVICE
 	help
@@ -1118,6 +1124,7 @@ config DRM_PANEL_VISIONOX_R66451
 
 config DRM_PANEL_VISIONOX_RM69299
 	tristate "Visionox RM69299"
+	depends on GPIOLIB
 	depends on OF
 	depends on DRM_MIPI_DSI
 	help
-- 
2.53.0

