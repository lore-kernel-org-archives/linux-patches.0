Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E15583ABE;
	Mon, 31 Aug 2026 13:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184202; cv=none; b=PBMg44jauc81gToKJ9mOHAuKQRqkFmj4upfEB0jvomnhK82mKpmeD4AfY73WYsYEJ3hgBg++3T75E8O03ptAI3KWRZKdYxaClpcmAHlPLbTI84P9XiDpKJrynEm0cdgf9wFXRM8yFP5AKcmBXQ0TEt4IVsBFn71XqTRYqqZsJws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184202; c=relaxed/simple;
	bh=Ld5DTrfuFXfMpSMFmOa7l75ddsVwPeJuPnI+IpAYUfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6hJxOwl1iX9Py2ntJMD7JekcQj+8aUdjmfICRYOEyuPpSapaNysWnyM0u4K4Tust4aUN1Vf98hSiWQxUHbr9gHqKt5GzzeMj9jQ0+YXY8EzdRrrjh6eazkuJxgASU6EVc6E1ftCp6T4t+zxaFQfP8bJMMM75rDon8oWQI3X7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mBiI3mZY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mBiI3mZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BC11F00A3E;
	Mon, 31 Aug 2026 13:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184200;
	bh=rmJ2Vxw4hIwMtV0G744QVx0xaxVszn9EXsAGVyvy+DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mBiI3mZYEPx6/QHPNxwrmbJ9mNzsmk01QmOT+uKEEu/KPQWUyodpBwymLHL2d3UuQ
	 on7DNN5HJ9A+9r5QL+pgv6p7yJpZsgo8sKCBZ8U9x57Ax+ZIjh+uOeNzZ9eSKZh4So
	 yRYO3o/zYpTf19TYXVVCEnCO/rwM7+Ob0DTj710mPrUP6YW0ndYMbeL2uWPk6gSbXv
	 PMam3xXEqyMC2E6/FjN71dJMI3Tu+JX2+ylfhYVz67y0F9395VELF76LRKn+mWOMED
	 Uhs122BpLs72VdiEQ8UiFj1aXfL7oz/6T8xBhvO2qEwswwkihTkBRJ5cCrfLjdsvY8
	 +TpMIazU3N99A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: host: add ARCH_AIROHA in XHCI MTK dependency
Date: Mon, 31 Aug 2026 09:29:39 -0400
Message-ID: <20260831133314.4125787-551-sashal@kernel.org>
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ffeaf31f05d664581aa436d9cb92b4d1d8d301ce ]

Airoha SoC use the same register map and logic of the Mediatek xHCI
driver, hence add it to the dependency list to permit compilation also
on this ARCH.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Link: https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `usb: host: add ARCH_AIROHA in XHCI MTK
dependency`

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the Subject Line
**Record:** `[usb: host]` `[add]` — Add `ARCH_AIROHA` to the Kconfig
dependency list for `USB_XHCI_MTK` so the MediaTek xHCI driver can be
selected when building for Airoha SoCs.

### Step 1.2: Parse All Commit Message Tags
**Record:**
- **Signed-off-by:** Christian Marangi `<ansuelsmth@gmail.com>` (author)
- **Link:**
  https://patch.msgid.link/20260519164903.31258-1-ansuelsmth@gmail.com
- **Signed-off-by:** Greg Kroah-Hartman `<gregkh@linuxfoundation.org>`
  (USB maintainer acceptance)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: USB maintainer sign-off; no bug report or syzbot involvement

### Step 1.3: Analyze Commit Body
**Record:**
- **Bug described:** Airoha SoCs reuse the MediaTek xHCI register map
  and logic, but `USB_XHCI_MTK` Kconfig does not list `ARCH_AIROHA` in
  its `depends on`, so the driver cannot be enabled on Airoha platform
  builds.
- **Symptom:** Kconfig hides/unselectable `CONFIG_USB_XHCI_MTK` when
  `CONFIG_ARCH_AIROHA=y`; kernel builds for Airoha cannot compile in the
  xhci-mtk driver without `COMPILE_TEST` workarounds.
- **Version info:** None stated.
- **Root cause:** Kconfig dependency oversight — platform added without
  updating all reused Mediatek IP driver dependencies.

### Step 1.4: Detect Hidden Bug Fixes
**Record:** Not disguised as cleanup. This is an explicit
**Kconfig/build dependency fix**. It falls under the stable “build fix”
exception category rather than a runtime crash fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the Changes
**Record:**
- **Files:** `drivers/usb/host/Kconfig` — 1 line changed (+1 token in
  `depends on`)
- **Functions modified:** None (Kconfig only)
- **Scope:** Single-file, surgical Kconfig change

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (USB_XHCI_MTK depends):**
  - **Before:** `depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK ||
    COMPILE_TEST`
  - **After:** `depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK ||
    ARCH_AIROHA || COMPILE_TEST`
  - **Path affected:** Kernel configuration time only; no runtime code
    path changes.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Build/configuration fix (Kconfig dependency)
- **Mechanism:** `ARCH_AIROHA` builds satisfy none of the original
  dependencies (unless `COMPILE_TEST`), so `USB_XHCI_MTK` is
  unavailable. Adding `ARCH_AIROHA` aligns this driver with other
  Mediatek-derived drivers already enabled for Airoha (PCIe, pinctrl,
  clk, gpio, ethernet, etc.).

### Step 2.4: Fix Quality Assessment
**Record:**
- **Quality:** Obviously correct; mirrors the established pattern used
  for `PCIE_MEDIATEK` (`b3b76fc86f0fb`, 2022).
- **Regression risk:** Very low — only makes an existing tristate option
  visible/selectable on `ARCH_AIROHA`; does not auto-enable anything.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame the Changed Lines
**Record:**
- `USB_XHCI_MTK` `depends on` line introduced by John Crispin,
  2016-12-20 (`808cf33d4817c7`), as `(MIPS && SOC_MT7621) ||
  ARCH_MEDIATEK || COMPILE_TEST`.
- `ARCH_AIROHA` added to this tree in `428ae88ef519f` (merged May 2024):
  “arm64: add Airoha EN7581 platform”.
- **Bug introduced:** When `ARCH_AIROHA` was added (~6.9 timeframe);
  xhci-mtk dependency was never updated.

### Step 3.2: Follow Fixes Tag
**Record:** No `Fixes:` tag present. N/A.

### Step 3.3: Related File History
**Record:**
- `git log -S'ARCH_AIROHA' -- drivers/usb/host/Kconfig` returns empty —
  `ARCH_AIROHA` was never added to this file.
- Precedent: `b3b76fc86f0fb` “PCI: mediatek: Allow building for
  ARCH_AIROHA” — identical rationale and pattern.
- Standalone one-commit fix; not part of a series.

### Step 3.4: Author's Other Commits
**Record:** Christian Marangi is an active Airoha/Mediatek platform
contributor (net/airoha fixes visible in tree). This patch is consistent
with ongoing Airoha platform enablement work.

### Step 3.5: Prerequisites
**Record:**
- **Requires:** `ARCH_AIROHA` Kconfig symbol — **present** in this tree
  (`arch/arm64/Kconfig.platforms`, `arch/arm/Kconfig.platforms`).
- **Requires:** `USB_XHCI_MTK` driver — **present**
  (`drivers/usb/host/xhci-mtk.c`).
- **Standalone:** Yes; no other commits required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Patch Discussion
**Record:** `b4 dig -c <commit>` could not be run (commit not in local
tree). Lore fetch blocked (403/Anubis bot protection). Link tag points
to linux-usb list submission from 2026-05-19. **UNVERIFIED:** Full
review thread content.

### Step 4.2: Reviewers
**Record:** Greg Kroah-Hartman Signed-off-by confirms USB maintainer
acceptance. **UNVERIFIED:** Full recipient list via `b4 dig -w`.

### Step 4.3: Bug Report
**Record:** No external bug report referenced. Issue inferred from
platform/Kconfig mismatch.

### Step 4.4: Related Patches/Series
**Record:** Part of broader Airoha platform enablement; similar Kconfig
updates already landed for PCIe, pinctrl, clk, gpio, ethernet, etc. No
multi-patch series dependency.

### Step 4.5: Stable Mailing List
**Record:** **UNVERIFIED** — could not search lore stable list due to
access restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions Modified
**Record:** None — Kconfig symbol `USB_XHCI_MTK` dependency only.

### Step 5.2: Callers
**Record:** Kconfig evaluated at build configuration time. `xhci-mtk`
driver probe is triggered by device tree `compatible = "mediatek,mtk-
xhci"` (and variants) via `xhci-mtk.c` platform driver table. No Airoha
USB DT nodes in mainline DTS yet, but en7581 reset/clock bindings
include USB host reset lines (`EN7581_USB_HOST_P0_RST`, etc.).

### Step 5.3: Callees
**Record:** N/A for Kconfig change.

### Step 5.4: Call Chain / Reachability
**Record:** Affects developers/distro builders configuring kernels with
`CONFIG_ARCH_AIROHA=y`. Not a userspace-triggerable runtime bug, but
blocks building USB host support for Airoha hardware using the existing
xhci-mtk driver.

### Step 5.5: Similar Patterns
**Record:** Multiple drivers in this tree already use `ARCH_AIROHA` in
Kconfig:
- `drivers/pci/controller/Kconfig` — `PCIE_MEDIATEK`,
  `PCIE_MEDIATEK_GEN3`
- `drivers/pinctrl/mediatek/Kconfig`
- `drivers/clk/Kconfig`
- `drivers/gpio/Kconfig`
- `drivers/net/ethernet/mediatek/Kconfig`
- `drivers/net/ethernet/airoha/Kconfig`
USB xhci-mtk is the outlier missing this dependency.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does the Buggy Code Exist?
**Record:** **YES.** Local tree is **v6.18.44** (`VERSION=6`,
`PATCHLEVEL=18`, `SUBLEVEL=44`). Current `drivers/usb/host/Kconfig` line
74:

```74:74:drivers/usb/host/Kconfig
        depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
```

`ARCH_AIROHA` is enabled in `arch/arm64/configs/defconfig` (line 37).
The commit under review is **not yet applied** to this tree.

### Step 6.2: Backport Complications
**Record:** `git apply --check` confirms the patch applies **cleanly**
to the local tree. No conflicts expected.

### Step 6.3: Related Fixes Already Present?
**Record:** `PCIE_MEDIATEK` ARCH_AIROHA dependency fix (`b3b76fc86f0fb`)
is already in tree. No duplicate xhci-mtk ARCH_AIROHA fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **drivers/usb/host** — IMPORTANT (USB host support), but fix
is config-only for a platform-specific (Airoha) subset.

### Step 7.2: Subsystem Activity
**Record:** xhci-mtk actively maintained (recent fixes in 2024–2025 for
isoc/split scheduling). Airoha platform actively developed since 2024.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Platform-specific** — kernel builders and users of Airoha
EN7581/EN7523 SoCs (routers/embedded). `CONFIG_ARCH_AIROHA=y` is in
arm64 defconfig.

### Step 8.2: Trigger Conditions
**Record:** Building a kernel with `CONFIG_ARCH_AIROHA=y` and attempting
to enable `CONFIG_USB_XHCI_MTK`. Common for platform bring-up; not
triggered by unprivileged users at runtime.

### Step 8.3: Failure Mode Severity
**Record:** **Build/configuration failure** — cannot select/build xhci-
mtk for Airoha. Severity: **LOW** for general users, **MEDIUM** for
Airoha platform developers. Not a crash, security issue, or data
corruption.

### Step 8.4: Risk-Benefit Ratio
**Record:**
- **Benefit:** Unblocks USB host driver compilation for Airoha;
  completes Kconfig parity with other Mediatek-IP drivers; zero-cost for
  non-Airoha users.
- **Risk:** Minimal — one Kconfig token, no code change, no behavior
  change unless user explicitly enables the option.
- **Ratio:** Favorable for Airoha platform support in a tree that
  already ships `ARCH_AIROHA`.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real Kconfig bug in v6.18.44 — `ARCH_AIROHA` present but xhci-mtk
  dependency missing
- Build-fix exception explicitly covers Kconfig dependency fixes
- 1-line, obviously correct, applies cleanly
- Identical precedent already in tree (`PCIE_MEDIATEK` + `ARCH_AIROHA`)
- USB maintainer (Greg K-H) sign-off
- Airoha hardware has USB-related reset/clock infrastructure in tree
- Many sibling Mediatek drivers already include `ARCH_AIROHA`

**AGAINST backport:**
- No runtime crash or security impact
- No USB device-tree nodes for Airoha in mainline yet — limited
  immediate user impact
- Niche embedded platform
- No explicit bug report or stable nomination found

**UNRESOLVED:**
- Full mailing list review thread (lore access blocked)
- Whether stable maintainers already discussed this

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — trivial Kconfig alignment;
   Greg K-H SOB
2. Fixes a real bug affecting users? **PASS** — real Kconfig/build
   blocker for Airoha builders
3. Important issue? **PASS (borderline)** — build fix for platform
   already in tree; not crash-level but blocks hardware enablement
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — exposes existing driver to
   existing arch; no new code
6. Can apply to local tree? **PASS** — applies cleanly; all
   prerequisites present

### Step 9.3: Exception Category
**Record:** **BUILD FIX** — Kconfig dependency correction to permit
compilation on `ARCH_AIROHA`.

### Step 9.4: Decision Rationale
This tree (v6.18.44) already supports `ARCH_AIROHA` in defconfig and has
extensive Airoha platform infrastructure, including Mediatek-derived
PCIe, clock, pinctrl, and ethernet drivers with `ARCH_AIROHA`
dependencies. The xhci-mtk Kconfig omission is a clear oversight that
prevents building USB host support on this platform using the existing
driver — the same class of fix that was backported for `PCIE_MEDIATEK`
years ago. The change is minimal, zero-risk at runtime, and directly
relevant to this tree.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 1]** Confirmed no `Fixes:`, `Reported-by:`, syzbot, or stable
  tags
- **[Phase 2]** Verified diff is 1-line Kconfig change in `USB_XHCI_MTK
  depends on`
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion`
  equivalent via Makefile → 6.18.44
- **[Phase 3]** `git blame -L 71,78 drivers/usb/host/Kconfig` → depends
  line from 2016; never updated for Airoha
- **[Phase 3]** `git log --oneline -1 428ae88ef519f` → ARCH_AIROHA added
  March 2024, merged May 2024
- **[Phase 3]** `git show b3b76fc86f0fb` → PCI mediatek ARCH_AIROHA
  precedent confirmed
- **[Phase 3]** `git log -S'ARCH_AIROHA' -- drivers/usb/host/Kconfig` →
  empty (fix not present)
- **[Phase 4]** `b4 dig` requires commit in tree — not usable;
  **UNVERIFIED** lore thread
- **[Phase 4]** WebFetch/curl to lore → blocked (403/Anubis)
- **[Phase 5]** `grep ARCH_AIROHA drivers/*/Kconfig` → 15+ drivers
  already include ARCH_AIROHA; USB_XHCI_MTK does not
- **[Phase 5]** Read `drivers/usb/host/xhci-mtk.c` compatible table —
  uses `mediatek,mtk-xhci` variants
- **[Phase 5]** Read `en7581.dtsi` — no USB nodes yet; reset headers
  include USB host resets
- **[Phase 6]** Read current `drivers/usb/host/Kconfig` line 74 —
  missing ARCH_AIROHA
- **[Phase 6]** `grep ARCH_AIROHA arch/arm64/configs/defconfig` →
  CONFIG_ARCH_AIROHA=y
- **[Phase 6]** `git apply --check` with provided diff → applies cleanly
  (exit 0)
- **[Phase 6]** `grep PCIE_MEDIATEK arch/arm64/configs/defconfig` →
  CONFIG_PCIE_MEDIATEK_GEN3=m (Airoha PCIe already enabled)
- **[Phase 8]** Failure mode: Kconfig unselectable driver on ARCH_AIROHA
  builds; severity LOW-MEDIUM

**YES**The background git search finished: the commit isn’t in this tree
yet — no matches for the subject, “XHCI MTK dependency,” or Christian
Marangi changes under `drivers/usb/host/Kconfig`.

That matches what we already saw: `drivers/usb/host/Kconfig` still lacks
`ARCH_AIROHA` in the `USB_XHCI_MTK` dependency, and the patch applies
cleanly to v6.18.44.

**Verdict for this tree: YES** — one-line Kconfig build fix so Airoha
builds can enable the existing xhci-mtk driver, same pattern as the PCI
Mediatek `ARCH_AIROHA` dependency fix already in tree.

 drivers/usb/host/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index c4f17ce5c77b1..87103b868032d 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -71,7 +71,7 @@ config USB_XHCI_HISTB
 config USB_XHCI_MTK
 	tristate "xHCI support for MediaTek SoCs"
 	select MFD_SYSCON
-	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || COMPILE_TEST
+	depends on (MIPS && SOC_MT7621) || ARCH_MEDIATEK || ARCH_AIROHA || COMPILE_TEST
 	help
 	  Say 'Y' to enable the support for the xHCI host controller
 	  found in MediaTek SoCs.
-- 
2.53.0

