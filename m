Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B6D4DA54F;
	Mon, 31 Aug 2026 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183562; cv=none; b=U6zqCvwuUauaBbYU0nXhLk+VbEbY7UhoItAixUiJbj0REW5AmDhgFxAnX5sxMw0Q1Z9JkaKOxPMf7TJnYqmcmXZ5gzOXAwCEC+l0W++H5sLDZKI5s/ovbnkNmIOiE7C0Bq01FTqnrXfBjIeCNsNBAgJY793P6n7ZKDaRT6i5gb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183562; c=relaxed/simple;
	bh=qyik9/YPq1xRd16c/YobgumwaLZoOdmz9mqc3T1hzJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Se8rCClVLI6BWoDj5m+HxTNwQKjHOp+yC3QuO+b4rNiSRrPC9mi81dsuMyUpVeRZdGOwELBPkvLUgjYrPUFD02yks3AptT/7tVNGLB0+7JbzxnOoUElwzOgno9djR3fUKjefbnVEtLmVeYoqx4AvJYDyASLbr5vRN+ramtjpXm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RWkBVsA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RWkBVsA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDCE1F00ACF;
	Mon, 31 Aug 2026 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183559;
	bh=fZ6jawYrwDGLAitQRdmuUejOqTKiX3dP89aA/dPYasc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RWkBVsA0JG6w8Ya/SO2gI4px02VrNa5GR0nkuSZKxVKKAx2q1xm8Bqd1MQI1g5ahk
	 4+sW+7qguQyDw2OkeldtQ3wIXYkZDVD6/wQ3ho76uYDlghJoiZ0vdLLNZmTFKYwTf0
	 ByRrDJ2NjcgRSbq7n1iGc44UJMUJ2ZGE8f3D3M8nzYInycVLPp4OE8t952eB3t5Qyk
	 ATbMmZ/VdQIMi4KmKPNsocoIrp9rXCJ2JKGJy3hOiOTF93/WgKk1SZcKmwDhmlZcxK
	 7X6lv0YEd5XSGZigrQhR4N01XwsrTQnvUgcwA5R59VbmfW2Jyir3GY8ped6ylUpQIO
	 WX6bT6goPa07g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: rtw89: pci: enable LTR based on pcie control register
Date: Mon, 31 Aug 2026 09:23:17 -0400
Message-ID: <20260831133314.4125787-169-sashal@kernel.org>
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

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit 779bbe1902f29d0ef131249ddd42a8dfbe21d0fb ]

Originally, driver always transmits LTR (Latency Tolerance Reporting) to
pcie host, but it may cause pcie link down on some platforms because
LTR is not supported. As a result, driver will check the control
register of LTR setting to decide whether to enable LTR feature.

This applies to Wi-Fi 6 chips only. For Wi-Fi 7 chips, although the
driver still issues LTR, the hardware has its own internal logic
to determine whether to actually transmit it to pcie host.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260515014433.16168-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: rtw89: pci: enable LTR based on pcie
control register`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, `make kernelversion`
= 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: rtw89: pci]` `[enable]` — Gate device-side LTR
(Latency Tolerance Reporting) on whether the PCIe host has LTR enabled
in `PCI_EXP_DEVCTL2`.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Dian-Syuan Yang `<dian_syuan0116@realtek.com>`,
  Ping-Ke Shih `<pkshih@realtek.com>`
- **Link:**
  `https://patch.msgid.link/20260515014433.16168-5-pkshih@realtek.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Part of `[PATCH rtw-next 04/13]` series ("update SER, PCI, WoW and
  quota settings", May 2026)

### Step 1.3: Body analysis
**Record:**
- **Bug:** Driver always transmits LTR to the PCIe host even when LTR is
  unsupported.
- **Symptom:** PCIe link down on some platforms.
- **Scope:** Wi-Fi 6 chips only (`rtw89_pci_ltr_set`,
  `rtw89_pci_ltr_set_v1`). Wi-Fi 7 (`rtw89_pci_ltr_set_v2`) has internal
  hardware gating and is intentionally unchanged.
- **Root cause:** Driver enables device-side LTR without checking
  host/platform LTR support.

### Step 1.4: Hidden bug fix?
**Record:** Yes — despite "enable" wording, this is a hardware/platform
compatibility fix preventing link failure, not a new feature.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/realtek/rtw89/pci.c` (+15 / -1)
- **Functions:** new `rtw89_pci_dev_ltr_enabled()`, modified
  `rtw89_pci_ltr_set()`, `rtw89_pci_ltr_set_v1()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow changes
**Record:**
- **Hunk 1 (new helper):** Reads `PCI_EXP_DEVCTL2` via
  `pcie_capability_read_word()`; returns true only if
  `PCI_EXP_DEVCTL2_LTR_EN` is set.
- **Hunk 2 (`rtw89_pci_ltr_set`):** `if (!en)` → `if (!en ||
  !rtw89_pci_dev_ltr_enabled(rtwdev))` — skip LTR register programming
  when host LTR is disabled.
- **Hunk 3 (`rtw89_pci_ltr_set_v1`):** Early return when host LTR is
  disabled, before any register access.

### Step 2.3: Bug mechanism
**Record:** **Hardware workaround / logic correctness.** The PCI core
(`pci_configure_ltr()` in `drivers/pci/pcie/aspm.c`) only sets
`PCI_EXP_DEVCTL2_LTR_EN` when the LTR path is valid. rtw89 was
programming device-side LTR regardless, sending LTR messages on
unsupported paths and causing link down. The fix mirrors iwlwifi's
established pattern.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, low regression risk. Uses
standard PCI APIs already used elsewhere in `pci.c`. Early return on
disable when LTR was never enabled is safe (nothing to tear down).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `rtw89_pci_ltr_set()` / `rtw89_pci_ltr_set_v1()` without the
check are present in this tree (lines 3125–3204). Buggy `if (!en) return
0;` pattern confirmed in `v6.18` and `v6.17.12`.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent stable `pci.c` changes: AER handler fix, LDO resume
restore, release-report validation. No related LTR fix already present.
Fix is on `origin/master` but not in `HEAD` (v6.18.44).

### Step 3.4: Author context
**Record:** Realtek rtw89 maintainers (Dian-Syuan Yang, Ping-Ke Shih).
Recent stable rtw89 PCI fixes from same authors (e.g. `0e12a252ec4b8`
LDO resume).

### Step 3.5: Dependencies
**Record:** Standalone. No prerequisites. Uses
`pcie_capability_read_word`, `PCI_EXP_DEVCTL2`, `PCI_EXP_DEVCTL2_LTR_EN`
— all present in this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Patch is `[PATCH rtw-next 04/13]` from Ping-Ke Shih, May 15,
2026 (ratatoskr: https://ratatoskr.run/linux-wireless/2026/05/15794835).
`b4 dig -c <commit>` failed — no isolated non-merge commit found (fix
landed via large merge `0fd8b67e27ff7` on mainline). lore.kernel.org
blocked by bot protection.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` not run (no commit hash). Series CC'd linux-
wireless; Realtek maintainers authored and signed off.

### Step 4.3: Bug reports
**Record:** No syzbot or user `Reported-by:`. Author documents platform-
specific PCIe link-down failure. Severity: loss of Wi-Fi connectivity /
PCIe link failure.

### Step 4.4: Series context
**Record:** Patch 4/13 in a 13-patch series. This patch is self-
contained; other series patches (SER debug, completion timeout, WoW) are
unrelated.

### Step 4.5: Stable list history
**Record:** Not searched (lore blocked). No evidence this was rejected
for stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rtw89_pci_dev_ltr_enabled()`, `rtw89_pci_ltr_set()`,
`rtw89_pci_ltr_set_v1()`

### Step 5.2: Callers
**Record:**
- `rtw89_pci_ops_mac_post_init_ax()` → `info->ltr_set(rtwdev, true)` at
  probe/init (line 3213)
- `rtw89_pci_ops_deinit()` → `info->ltr_set(rtwdev, false)` at teardown
  (line 3035)
- Chip bindings: `rtw8852ae`, `rtw8852be`, `rtw8851be` →
  `rtw89_pci_ltr_set`; `rtw8852ce`, `rtw8852bte` →
  `rtw89_pci_ltr_set_v1`; `rtw8922ae` → `rtw89_pci_ltr_set_v2`
  (unchanged)

### Step 5.3: Callees
**Record:** `pcie_capability_read_word()`, `rtw89_read32()` /
`rtw89_write32_*()` for LTR control registers.

### Step 5.4: Call chain / reachability
**Record:** `rtw89_core_init()` → `mac.c`
`rtwdev->hci.ops->mac_post_init()` → `ltr_set(true)` during every PCI
Wi-Fi 6 device bring-up. Triggered at driver probe, not a rare path.

### Step 5.5: Similar patterns
**Record:** iwlwifi uses identical check in
`drivers/net/wireless/intel/iwlwifi/pcie/gen1_2/trans.c` (lines
219–220). PCI core `pci_configure_ltr()` in `aspm.c` gates
`PCI_EXP_DEVCTL2_LTR_EN` on platform LTR path validity.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current `pci.c` at lines 3129–3130 has `if (!en)
return 0;` with no host LTR check. `rtw89_pci_dev_ltr_enabled` does not
exist. Bug present since at least v6.17.12 and v6.18.0.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion context around
`rtw89_pci_mode_op()` return and `rtw89_pci_ops_deinit()` matches
mainline exactly. Full `pci.c` diff between `HEAD` and `origin/master`
passes `git apply --check`.

### Step 6.3: Related fixes already present?
**Record:** **No.** `git log stable/linux-6.18.y -S
'rtw89_pci_dev_ltr_enabled'` returned empty. Fix exists on
`origin/master` but not in v6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/realtek/rtw89` — **IMPORTANT** (common
laptop PCIe Wi-Fi: RTL8852AE/BE/CE, RTL8851BE). Config:
`CONFIG_RTW89_PCI`.

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y (multiple recent PCI fixes
backported).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Realtek rtw89 Wi-Fi 6 PCIe adapters on platforms
where the PCIe root complex or intermediate switches do not support LTR.

### Step 8.2: Trigger conditions
**Record:** Device probe / MAC post-init on every boot with affected
hardware + non-LTR PCIe platform. Not userspace-triggerable, but
universal for matching hardware.

### Step 8.3: Failure mode severity
**Record:** PCIe link down → Wi-Fi non-functional, possible system
instability. **Severity: HIGH** (connectivity loss; potential broader
PCIe issues).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents link failure on real hardware
- **Risk:** VERY LOW — 15 lines, read-only PCI config check, skip-no-op
  when LTR unsupported
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real platform bug (PCIe link down)
- High user impact on common Wi-Fi 6 hardware
- Small, surgical, obviously correct
- Follows established iwlwifi / PCI-core pattern
- Standalone, no dependencies
- Buggy code confirmed in v6.18.44
- Hardware quirk/workaround category

**AGAINST backport:**
- No syzbot/fuzzer report or multiple user reports
- Part of a larger series (but this patch is independent)
- Driver-specific (not core kernel), but affects widely deployed
  hardware

**Unresolved:**
- Full lore review thread unavailable (bot protection)
- Exact mainline non-merge commit hash not isolated

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard PCI capability
   check; on mainline; Realtek-signed
2. Fixes a real bug affecting users? **PASS** — PCIe link down on
   unsupported platforms
3. Important issue? **PASS** — connectivity loss / link failure (HIGH)
4. Small and contained? **PASS** — 1 file, ~15 lines
5. No new features or APIs? **PASS** — internal helper only
6. Can apply to local tree? **PASS** — context verified, applies cleanly

### Step 9.3: Exception category
**Record:** Hardware quirk/workaround — gate feature on platform
capability, same class as USB/PCI quirks routinely backported to stable.

### Step 9.4: Decision rationale
This commit fixes a real hardware compatibility bug where rtw89
unconditionally enables PCIe LTR on Wi-Fi 6 chips, causing link down on
platforms without LTR support. The fix is minimal, follows an
established pattern (iwlwifi, PCI ASPM), affects a common driver at
probe time, and the buggy code is present in v6.18.44 without this fix.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 1]** Confirmed patch is rtw-next 04/13 via ratatoskr
- **[Phase 2]** Read `pci.c` lines 3015–3220 in stable tree; confirmed
  pre-fix code
- **[Phase 2]** Compared with provided diff; 3 hunks, 15 insertions, 1
  deletion
- **[Phase 3]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 3]** `git blame` on LTR functions → present since driver
  import
- **[Phase 3]** `git show v6.18` / `v6.17.12` → buggy `if (!en)` without
  LTR check
- **[Phase 3]** `git show origin/master:pci.c` → fix present on mainline
- **[Phase 3]** `git diff HEAD origin/master -- pci.c` → LTR hunks at
  lines 3022, 3126, 3162
- **[Phase 3]** `git log stable/linux-6.18.y -S
  'rtw89_pci_dev_ltr_enabled'` → empty (fix not in stable)
- **[Phase 4]** ratatoskr fetch → patch series and full diff confirmed
- **[Phase 4]** lore.kernel.org fetch → blocked (bot protection)
- **[Phase 4]** `b4 dig -c` → no isolated commit hash found
- **[Phase 5]** `grep ltr_set` → callers and chip bindings mapped
- **[Phase 5]** Read `mac.c:4110-4113` → `mac_post_init` call chain
- **[Phase 5]** Read iwlwifi `trans.c:219-220` → identical LTR check
  pattern
- **[Phase 5]** Read `aspm.c:1203-1256` → PCI core LTR gating logic
- **[Phase 6]** `grep rtw89_pci_dev_ltr_enabled` in workspace → not
  found (fix absent)
- **[Phase 6]** `git apply --check` full pci.c diff HEAD..origin/master
  → succeeds
- **[Phase 6]** Manual context comparison at insertion point → matches
- **[Phase 8]** Affected chips: RTL8852A/B/C, RTL8851B (Wi-Fi 6 PCI
  variants in tree)

**YES****Verdict: YES** — backport to this tree (v6.18.44).

The rtw89 driver was enabling PCIe LTR on Wi-Fi 6 chips even when the
host doesn’t support it (`PCI_EXP_DEVCTL2_LTR_EN` unset), which can drop
the PCIe link on some platforms. The fix is small (~15 lines in
`pci.c`), checks the standard PCIe control register before enabling LTR
(same pattern as iwlwifi), and the buggy code is present in 6.18.44 but
not yet fixed there.

 drivers/net/wireless/realtek/rtw89/pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 17a199ee1d4a4..b912f40fba524 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -3022,6 +3022,17 @@ static int rtw89_pci_mode_op(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
+static bool rtw89_pci_dev_ltr_enabled(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	u16 cap;
+
+	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap);
+
+	return !!(cap & PCI_EXP_DEVCTL2_LTR_EN);
+}
+
 static int rtw89_pci_ops_deinit(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
@@ -3126,7 +3137,7 @@ int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
 
-	if (!en)
+	if (!en || !rtw89_pci_dev_ltr_enabled(rtwdev))
 		return 0;
 
 	val = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
@@ -3162,6 +3173,9 @@ int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en)
 	u32 dec_ctrl;
 	u32 val32;
 
+	if (!rtw89_pci_dev_ltr_enabled(rtwdev))
+		return 0;
+
 	val32 = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
 	if (rtw89_pci_ltr_is_err_reg_val(val32))
 		return -EINVAL;
-- 
2.53.0

