Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D413D16F9;
	Mon, 30 Mar 2026 12:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874339; cv=none; b=M8qnUp21I7okXRj2KJPZFboEvAFiVW/50EjzKtvH1a/xF8keENjyu/YUoFoY9dBq9BaZdHS7fmLfNVZl2GAkoinPMBED/86uAK5U5Fl4aJgkLYVS0jwsIyF+0eMFY1h0N4qJFsNEuf8+YfqAJvyDsEPmJvjtHHnE8LnE7XaYZA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874339; c=relaxed/simple;
	bh=DTgQ3ZVL3YQNnCCvLHu6gPbakMl8yNJQZvukj6+F8W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n/eD9aNiCFBYE+aKHURcCWYcpnMJdQPtSIOsNan2GCqLNv6BUjUN0j0OchqYXLeTCI2tMNQlIRlIyG4qd6YXr8LdDPWpqFKxrPfOyivsoBbN5dW7CXCTpXd9anmfJi8bNIDnfZVVfTNlY7DNhZs034QP3+vBDDsDBf3XQrycRMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8J7vLab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8J7vLab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691FCC2BCB0;
	Mon, 30 Mar 2026 12:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874337;
	bh=DTgQ3ZVL3YQNnCCvLHu6gPbakMl8yNJQZvukj6+F8W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8J7vLab4uBV+gbZmJLTQkz1dzsrjJEOUXGT9IMdfSZCmdgpOP2J5RTDr/uSQJE/o
	 DDsZ+iZjSdgXvGAsJJ5YxK8hagpPwSb/KDfIcEAZDsG+YFEyJMaA8pcW+eAGxfSM2L
	 Kewxf3wmxrn5BkqVLbX99J7Yl6N2oahkB/PjpsqPfpCj0ELgXXMKrCB0PJ+w3VQnwO
	 DeP0zfX8/ImK4L9Cc1qxmFR6KaVc96hkEjHI9P5ENG/9cJkXWEy0QsOgcPv+x92fyD
	 4QMY8htoxv5Ip6g3ZqOhx15X3vNlY1RgH2JABYQragddOz4IrUgScXjKbHE4Sz/2FY
	 Srzquvoa8c2eg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Frank Zhang <rmxpzlb@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] ALSA:usb:qcom: add AUXILIARY_BUS to Kconfig dependencies
Date: Mon, 30 Mar 2026 08:38:23 -0400
Message-ID: <20260330123842.756154-10-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Zhang <rmxpzlb@gmail.com>

[ Upstream commit b8bee48e38f2ddbdba5e58bc54ef54bb7d8d341b ]

The build can fail with:

ERROR: modpost: "__auxiliary_driver_register"
[sound/usb/qcom/snd-usb-audio-qmi.ko] undefined!
ERROR: modpost: "auxiliary_driver_unregister"
[sound/usb/qcom/snd-usb-audio-qmi.ko] undefined!

Select AUXILIARY_BUS when SND_USB_AUDIO_QMI is enabled.

Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>
Link: https://patch.msgid.link/20260317102527.556248-1-rmxpzlb@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the technical verification I need. Let me produce the
final answer.

---

## Phase 1: Commit Message Forensics

**Step 1.1: Subject Line**
Record: [ALSA:usb:qcom] [add] [Add missing AUXILIARY_BUS Kconfig
dependency to fix modpost build failure]

**Step 1.2: Tags**
- `Signed-off-by: Frank Zhang <rmxpzlb@gmail.com>` — patch author
- `Link:
  https://patch.msgid.link/20260317102527.556248-1-rmxpzlb@gmail.com` —
  patch submission
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA subsystem
  maintainer accepted the patch
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (expected for candidates under manual review)

Record: Accepted by subsystem maintainer Takashi Iwai. Standalone patch
(not part of a series).

**Step 1.3: Commit Body**
Record: Bug: Enabling `SND_USB_AUDIO_QMI` without `AUXILIARY_BUS` causes
modpost failures: `__auxiliary_driver_register` and
`auxiliary_driver_unregister` are undefined in `snd-usb-audio-qmi.ko`.
Symptom: hard build failure. Root cause: the Kconfig entry for
`SND_USB_AUDIO_QMI` omits the required `select AUXILIARY_BUS`.

**Step 1.4: Hidden Bug Fix?**
Record: Not really hidden — the commit message explicitly describes a
build failure. The word "add" in the subject could be misleading, but
the body makes the bug fix intent clear.

---

## Phase 2: Diff Analysis

**Step 2.1: Inventory**
Record: 1 file changed (`sound/usb/Kconfig`), +1 line added (`select
AUXILIARY_BUS`), 0 lines removed. No functions modified (Kconfig only).
Scope: single-line surgical build fix.

**Step 2.2: Code Flow Change**
Record: Before: `SND_USB_AUDIO_QMI` could be enabled without
`CONFIG_AUXILIARY_BUS`, causing the auxiliary bus object files not to be
compiled, leaving
`__auxiliary_driver_register`/`auxiliary_driver_unregister` unresolved
at link time. After: enabling `SND_USB_AUDIO_QMI` forces
`AUXILIARY_BUS=y`, guaranteeing the symbols are available.

**Step 2.3: Bug Mechanism**
Record: Category: build fix / Kconfig dependency bug. The driver's
source (`qc_audio_offload.c` line 1990) uses
`module_auxiliary_driver()`, which expands to
`auxiliary_driver_register`/`auxiliary_driver_unregister` (declared in
`include/linux/auxiliary_bus.h`). These are implemented in
`drivers/base/auxiliary.o`, which is only built when
`CONFIG_AUXILIARY_BUS` is enabled. Without the `select`, the symbols may
not exist.

**Step 2.4: Fix Quality**
Record: Obviously correct — the driver uses auxiliary bus APIs, so it
must depend on the auxiliary bus. Minimal (1 line). Matches the
established tree-wide pattern (50+ other Kconfig entries use `select
AUXILIARY_BUS`). Regression risk: effectively zero — it only ensures a
core infrastructure module is built.

---

## Phase 3: Git History Investigation

**Step 3.1: Blame**
Record: `git blame` confirms the `SND_USB_AUDIO_QMI` block was
introduced in commit `326bbc348298a` ("ALSA: usb-audio: qcom: Introduce
QC USB SND offloading support", Wesley Cheng, 2025-04-09). The `depends
on USB_XHCI_HCD && USB_XHCI_SIDEBAND` line was later added by
`882826f58b2c4` (Arnd Bergmann, 2025-05-21) — another build fix for the
same driver. No `select AUXILIARY_BUS` exists in the current tree.

**Step 3.2: Fixes Tag**
Record: N/A — no `Fixes:` tag. However, the implied fix target is
`326bbc348298a` which introduced the driver without the AUXILIARY_BUS
dependency.

**Step 3.3: File History**
Record: `git log --oneline -20 -- sound/usb/Kconfig` shows the
SND_USB_AUDIO_QMI entry and the prior Kconfig build fix
(`882826f58b2c4`). This is the **second** Kconfig dependency fix for the
same new driver — a pattern consistent with a recently-introduced driver
stabilizing its build dependencies. This patch is standalone; no multi-
patch series dependency.

**Step 3.4: Author**
Record: Frank Zhang has no other commits under `sound/usb/` in this
tree. However, the patch was accepted by Takashi Iwai, the ALSA
subsystem maintainer, providing quality assurance.

**Step 3.5: Dependencies**
Record: No prerequisites needed. The patch is self-contained: it only
requires the `SND_USB_AUDIO_QMI` Kconfig block to already exist in the
tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1–4.4:**
Record: Lore access was blocked by Anubis anti-bot protection. The patch
link
(`https://patch.msgid.link/20260317102527.556248-1-rmxpzlb@gmail.com`)
and lore search URLs could not be fetched. Reviewer comments, explicit
stable nominations, or NAKs remain unverified. However, the maintainer
sign-off from Takashi Iwai confirms acceptance through the standard
review process.

---

## Phase 5: Code Semantic Analysis

**Step 5.1: Key Functions**
Record: N/A for C functions — this is a Kconfig-only change. The
relevant code reference is
`module_auxiliary_driver(qc_usb_audio_offload_drv)` at
`sound/usb/qcom/qc_audio_offload.c:1990`.

**Step 5.2–5.4: Code Tracing**
Record: Verified the dependency chain:
1. `sound/usb/qcom/qc_audio_offload.c` line 6: `#include
   <linux/auxiliary_bus.h>`
2. `sound/usb/qcom/qc_audio_offload.c` line 1990:
   `module_auxiliary_driver(qc_usb_audio_offload_drv)`
3. `include/linux/auxiliary_bus.h` defines `module_auxiliary_driver()`
   expanding to
   `auxiliary_driver_register`/`auxiliary_driver_unregister`
4. `drivers/base/Kconfig` line 4-5: `config AUXILIARY_BUS` is a
   promptless `bool` (cannot be enabled by the user directly — must be
   selected by a consumer)
5. Without `select AUXILIARY_BUS`, if no other enabled config selects
   it, the symbols are unavailable → modpost failure

**Step 5.5: Similar Patterns**
Record: `select AUXILIARY_BUS` appears in 50+ Kconfig files across the
tree (drivers/gpu, drivers/net, drivers/clk, drivers/reset, sound/soc,
etc.). This is the standard established pattern for auxiliary bus
consumers. The fix is entirely consistent with tree-wide convention.

---

## Phase 6: Stable Tree Analysis

**Step 6.1: Does the buggy code exist in stable trees?**
Record: Verified via `git show <tag>:sound/usb/Kconfig`:
- `v6.6` — `SND_USB_AUDIO_QMI` does NOT exist (grep returns 0 matches)
- `v6.12` — does NOT exist (0 matches)
- `v6.16` — EXISTS, missing `select AUXILIARY_BUS` (confirmed)
- `v6.19` — EXISTS, missing `select AUXILIARY_BUS` (confirmed)

The introducing commit `326bbc348298a` first appears in `v6.16` and all
subsequent releases. Older LTS branches (6.6.y, 6.12.y, 6.1.y) are
unaffected — the driver does not exist there.

**Step 6.2: Backport complications**
Record: Clean apply expected. The `SND_USB_AUDIO_QMI` Kconfig block is
materially identical across affected tags. One-line insertion should
apply without conflicts.

**Step 6.3: Related fixes in stable**
Record: No `AUXILIARY_BUS` fix found in any of the affected stable tags.
The prior related build fix (`882826f58b2c4` for USB_XHCI_HCD) is
already present in v6.19 but addresses a different missing dependency.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1: Subsystem**
Record: `sound/usb` — ALSA USB audio, Qualcomm offload driver.
Criticality: PERIPHERAL (hardware- and config-specific). However, build
fixes are explicitly listed as stable-appropriate regardless of
subsystem criticality.

**Step 7.2: Activity**
Record: Active development — multiple follow-up fixes since the driver's
introduction in v6.16, indicating a young subsystem still being
stabilized.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who is affected**
Record: Anyone building a kernel with `CONFIG_SND_USB_AUDIO_QMI` enabled
in a configuration where `AUXILIARY_BUS` is not otherwise selected by
another driver. Primarily Qualcomm SoC users and distributions enabling
this driver.

**Step 8.2: Trigger conditions**
Record: Build-time trigger, not runtime. 100% reproducible when the
Kconfig condition is met. Note: the upstream arm64 defconfig
incidentally enables `AUXILIARY_BUS` through `QCOM_PMIC_GLINK`, which
masks the bug in that specific configuration. However, non-default
configs can easily trigger it.

**Step 8.3: Severity**
Record: Build failure at modpost stage — HIGH for affected
configurations (impossible to build the module). Not a runtime crash,
but prevents kernel builds entirely for this config.

**Step 8.4: Risk-benefit ratio**
Record: BENEFIT: High — fixes a hard build break for a supported in-tree
driver. RISK: Effectively zero — one-line Kconfig `select` addition with
no runtime behavior change, matching an established tree-wide pattern.
Ratio: Very strongly favorable.

---

## Phase 9: Final Synthesis

**Step 9.1: Evidence**
FOR backporting:
- Real build failure (modpost undefined symbols) — documented with exact
  error messages
- Single-line, obviously correct Kconfig fix
- Matches established tree-wide pattern (`select AUXILIARY_BUS` used in
  50+ other Kconfig entries)
- Code path verified: driver uses `module_auxiliary_driver()` → needs
  `AUXILIARY_BUS`
- `AUXILIARY_BUS` is a promptless bool — must be selected, not user-
  enabled
- Zero runtime regression risk
- Accepted by ALSA subsystem maintainer (Takashi Iwai)
- Second build fix for the same driver (pattern of missing deps from
  initial introduction — `882826f58b2c4` was the first)
- Bug confirmed present in all affected stable tags (6.16.y through
  6.19.y)

AGAINST backporting:
- Not relevant to stable trees older than v6.16 (driver does not exist
  there)
- Narrow audience (Qualcomm USB audio offload users)

UNRESOLVED:
- Lore discussion not accessible (Anubis anti-bot)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — driver uses auxiliary bus
   API, must depend on it
2. Fixes a real bug? **YES** — modpost build failure
3. Important issue? **YES** — prevents compilation of a supported driver
4. Small and contained? **YES** — 1 line, 1 file
5. No new features or APIs? **YES** — only adds missing build dependency
6. Can apply to stable? **YES** — clean apply on v6.16+ branches

**Step 9.3: Exception Categories**
Record: **Build fix** — explicitly listed as an exception category that
is automatically YES for stable.

**Step 9.4: Decision**
This is a textbook build fix: a single-line Kconfig `select` addition
that fixes a real modpost link failure for a supported in-tree driver.
It should be backported to stable trees that contain `SND_USB_AUDIO_QMI`
(v6.16.y and newer). It is not applicable to older LTS branches
(v6.12.y, v6.6.y, v6.1.y) where the driver does not exist.

---

## Verification

- [Phase 1] Parsed commit message and tags directly: `Link:` and two
  `Signed-off-by:` tags present; no `Fixes:`, `Reported-by:`, `Tested-
  by:`, or `Cc: stable`
- [Phase 2] Diff: confirmed single `+     select AUXILIARY_BUS` line
  added under `SND_USB_AUDIO_QMI` in `sound/usb/Kconfig`
- [Phase 3] `git blame -L 191,205 -- sound/usb/Kconfig`: confirmed
  `SND_USB_AUDIO_QMI` introduced by `326bbc348298a` (Wesley Cheng,
  2025-04-09); deps line touched by `882826f58b2c4` (Arnd Bergmann,
  2025-05-21)
- [Phase 3] `git show 882826f58b2c4`: confirmed this was a prior Kconfig
  build fix for the same driver (missing `USB_XHCI_HCD` dependency),
  also with `Fixes: 326bbc348298` tag
- [Phase 3] `git log --oneline -20 -- sound/usb/Kconfig`: confirmed
  recent history, no existing `AUXILIARY_BUS` fix
- [Phase 4] WebFetch to lore/patch.msgid.link: blocked by Anubis anti-
  bot — UNVERIFIED: mailing list discussion details
- [Phase 5] Grep `sound/usb/qcom/`: confirmed `#include
  <linux/auxiliary_bus.h>` at line 6 and
  `module_auxiliary_driver(qc_usb_audio_offload_drv)` at line 1990 of
  `qc_audio_offload.c`
- [Phase 5] Read `drivers/base/Kconfig` lines 4-5: confirmed
  `AUXILIARY_BUS` is a promptless `bool` — must be selected by consumers
- [Phase 5] Grep `select AUXILIARY_BUS` across Kconfig files: confirmed
  50+ other consumers use this pattern
- [Phase 6] `git show v6.6:sound/usb/Kconfig | grep SND_USB_AUDIO_QMI`:
  0 matches — driver does not exist in v6.6
- [Phase 6] `git show v6.12:sound/usb/Kconfig | grep SND_USB_AUDIO_QMI`:
  0 matches — driver does not exist in v6.12
- [Phase 6] `git show v6.16:sound/usb/Kconfig`: confirmed
  `SND_USB_AUDIO_QMI` exists, `select AUXILIARY_BUS` missing
- [Phase 6] `git show v6.19:sound/usb/Kconfig`: confirmed
  `SND_USB_AUDIO_QMI` exists, `select AUXILIARY_BUS` missing
- [Phase 6] `git tag --contains 326bbc348298a`: confirmed first
  appearance at v6.16; present through v6.19.x
- [Phase 8] Failure mode: modpost undefined symbol error — build
  failure, severity HIGH for affected configs
- UNVERIFIED: lore.kernel.org discussion details (anti-bot protection
  blocked access)

**YES**

 sound/usb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/usb/Kconfig b/sound/usb/Kconfig
index 9b890abd96d34..b4588915efa11 100644
--- a/sound/usb/Kconfig
+++ b/sound/usb/Kconfig
@@ -192,6 +192,7 @@ config SND_USB_AUDIO_QMI
 	tristate "Qualcomm Audio Offload driver"
 	depends on QCOM_QMI_HELPERS && SND_USB_AUDIO && SND_SOC_USB
 	depends on USB_XHCI_HCD && USB_XHCI_SIDEBAND
+	select AUXILIARY_BUS
 	help
 	  Say Y here to enable the Qualcomm USB audio offloading feature.
 
-- 
2.53.0

