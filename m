Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B9B545281;
	Mon, 31 Aug 2026 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183972; cv=none; b=heC5mVRohm0gRDY9lUlco6NS0O7aNoKQkyTcbKr7tzuH3vvPECGIK6TDKUwuO88Ee117KaGnTYiwKgKX8Sf9ESczkWWVivDWZgHaeLhsCFLtx6KuWpA+09U+wUYcykxKPUSl62qcy4KKN4aNYiFYaHP/Qq2GZ8ebVb3TNcsdhdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183972; c=relaxed/simple;
	bh=b4DTqo5FvFIy5AqMW3T2xxF8pGsbNqZjFdxVccvjIIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nDQsrT0cg2db5bcwqk0qtJ7rLe44NddT3eH2yxfHb7HKK/XUeXlatrwdDSLzcLoPOUz5kcTX2FctNpvfN+BFoFwmhRIDqwv47zJfwlfgcTx01Ee5iCtZILM0PxKf566V5z9t6V0NMeBTZcRV+z7D6kOzc3SnSM7NH/sus0UstoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayGhAm54; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayGhAm54"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040C1F00A3F;
	Mon, 31 Aug 2026 13:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183968;
	bh=jLWiOl+oEcyUeRXWZBezCLaWKqLNiKK1v07cQaOuK4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayGhAm542qSIdGGZIZBjVsJjazOu/D7wm6PC8WxehgP009j7p4/uZzU/mxGFLvKze
	 SCqmiokk3IYubX5yOP/ZWVJ9Tc93HVdmDwcJERCCXJ5W6Vv8dsZLJvv79+8JQ/auIR
	 LB2V8puxdpdVmsqdn/0uNXzb3PlAsX73MEr3jA2V76jBHxArpoNfwk4cetc3XfJaXy
	 IjcnykB0mBNXNgjfzIt0RkuWfx2hU9eTShdGR8abig3sLgsQ3PUlQzu+FXmnyx6pmM
	 /63jwIIk4uyn2bERU/eLhudl8Q62nwU8bxzCdx0uNqmqPlpwZzNxltFZgenFmOeprK
	 pFeziE41qeYmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chih-Kang Chang <gary.chang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: rtw89: suspend DIG when remain-on-channel
Date: Mon, 31 Aug 2026 09:27:19 -0400
Message-ID: <20260831133314.4125787-411-sashal@kernel.org>
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

From: Chih-Kang Chang <gary.chang@realtek.com>

[ Upstream commit 602b58bb45b2f2bf848215560406ff87dc9a0ab6 ]

The PD (Packet Detection) lower bound is set after the STA interface
connects. When the P2P interface attempts to find peers, it enters
the remain-on-channel flow to listen for probe requests. However, if
the RSSI of the connected AP is too high, the P2P interface fails to
receive it. To resolve this, suspend the DIG during the
remain-on-channel period.

Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260420034051.17666-15-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: rtw89: suspend DIG when remain-on-
channel`

**Local tree:** `v6.18.43` (Makefile: 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: rtw89]` — no explicit "fix" verb, but describes
corrective behavior — `[suspend DIG when remain-on-channel]` — suspend
Dynamic Integrity Gain (DIG) during P2P remain-on-channel (ROC)
operation.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Chih-Kang Chang `<gary.chang@realtek.com>` (author)
- **Signed-off-by:** Ping-Ke Shih `<pkshih@realtek.com>` (Realtek rtw89
  maintainer)
- **Link:**
  `https://patch.msgid.link/20260420034051.17666-15-pkshih@realtek.com`
  (patch 15 in a series, per message-id)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags (absence of Cc: stable is expected per review pipeline
  rules)

**Notable patterns:** Maintainer sign-off from Ping-Ke Shih; message-id
suffix `-15` suggests a multi-patch series, but the change itself is
self-contained.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** After STA association, Packet Detection (PD) lower bound is
  set by DIG based on connected AP RSSI. When P2P uses remain-on-channel
  to listen for probe requests during peer discovery, a strong AP RSSI
  drives the PD lower bound too high.
- **Symptom:** P2P interface fails to receive probe requests from peers
  (peer discovery broken).
- **Root cause (author):** DIG PD lower bound not suspended during ROC,
  unlike scan/MCC paths.
- **Fix approach:** Call `rtw89_phy_dig_suspend()` at ROC start and
  `rtw89_phy_dig_resume(rtwdev, true)` at ROC end.
- **Version info:** None stated in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Despite no "fix" in the subject, this is a functional bug
fix disguised as a behavioral adjustment. It corrects missing DIG
suspend/resume pairing in the ROC path — the same pattern already used
for hardware scan and MCC in this driver.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/net/wireless/realtek/rtw89/core.c` (+2 lines)
- **Functions modified:** `rtw89_roc_start()`, `rtw89_roc_end()`
- **Scope:** Single-file, surgical, 2-line functional fix

### Step 2.2: Code flow change per hunk

**Hunk 1 — `rtw89_roc_start()`:**
- **Before:** After RX filter setup, immediately calls
  `ieee80211_ready_on_channel()` and schedules ROC timeout work.
- **After:** Suspends DIG (`rtw89_phy_dig_suspend`) before notifying
  mac80211 that the device is on-channel.
- **Path affected:** P2P/WiFi-Direct remain-on-channel entry (normal and
  mgmt-tx ROC types).

**Hunk 2 — `rtw89_roc_end()`:**
- **Before:** After pending TX handling, checks idle state and may
  schedule IPS work.
- **After:** Resumes DIG with `restore=true` before the idle check.
- **Path affected:** ROC expiry or cancellation
  (`cancel_remain_on_channel`).

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness — missing state management
in ROC path.

**Mechanism:** `rtw89_phy_dig_dyn_pd_th()` sets `dig->bak_dig` and
writes the PD lower bound based on connected STA RSSI. With a
nearby/strong AP, the PD threshold is raised, filtering out weaker
incoming frames. During ROC peer discovery, probe requests from distant
peers fall below that threshold and are not received.
`rtw89_phy_dig_suspend()` sets PD lower bound to 0 and disables DIG
tracking; `rtw89_phy_dig_resume(rtwdev, true)` restores the backed-up
value — matching scan (`fw.c`) and MCC (`chan.c`) behavior.

### Step 2.4: Fix quality assessment
**Record:**
- **Obviously correct:** Yes — mirrors existing suspend/resume usage in
  scan, MCC, and STA-association paths.
- **Minimal:** Two function calls at symmetric entry/exit points.
- **Idempotent:** `rtw89_phy_dig_ctrl()` early-returns if already in the
  requested pause state.
- **Regression risk:** Very low. DIG suspend/resume is already exercised
  on hot paths; ROC is relatively infrequent.
- **Minor concern:** `rtw89_roc_end()` has an early return if the link
  is not found (line 4068–4071); if ROC start succeeded but end hits
  that path, DIG could remain suspended. This path is unlikely in normal
  operation and is a pre-existing structural issue, not introduced by
  this patch's logic.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Current `rtw89_roc_start()`/`rtw89_roc_end()` body (lines
3989–4095) and `rtw89_phy_dig_suspend()`/`rtw89_phy_dig_resume()`
(phy.c:6923–6937) are present in this tree. Git blame attributes them to
`19eef1d98eeda` (squashed/import history in this stable checkout). The
ROC path and DIG APIs both exist in v6.18.43.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent rtw89 commits in this tree include `98a774e2c58df`
("fix unable to receive probe responses under MLO connection") — same
symptom class (probe reception failure), already backported here. Other
recent rtw89 stable commits are unrelated PCI/PHY fixes. No commit in
this tree already adds DIG suspend to ROC.

### Step 3.4: Author's other commits
**Record:** Chih-Kang Chang and Ping-Ke Shih are active Realtek rtw89
contributors. Ping-Ke Shih is the rtw89 maintainer. Recent commits from
these authors in this tree include MCC, MAC, and PCI fixes — established
subsystem contributors.

### Step 3.5: Prerequisites / dependencies
**Record:** No dependencies identified. `rtw89_phy_dig_suspend()` and
`rtw89_phy_dig_resume()` are declared in `phy.h` and implemented in
`phy.c`. Patch applies cleanly to this tree (verified with `git apply
--check`). Standalone despite being patch 15/N in a series.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** Lore.kernel.org and patch.msgid.link are blocked by Anubis
bot protection from this environment. `b4 dig -c <commit>` could not be
run because the commit is not in this checkout. **UNVERIFIED:** Full
mailing list review thread, series context, and any stable nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** via b4 dig -w. Ping-Ke Shih (maintainer) has
Signed-off-by on the commit.

### Step 4.3: Bug report
**Record:** No Reported-by: or bugzilla/syzbot links. Bug described by
author based on known DIG/ROC interaction. No external user report
verified.

### Step 4.4: Related patches / series
**Record:** Message-id `17666-15` indicates patch 15 of a series. The
diff uses only existing APIs and is self-contained. No other series
patches required for this fix to function.

### Step 4.5: Stable mailing list history
**Record:** **UNVERIFIED** — could not search lore stable list due to
bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `rtw89_roc_start()`, `rtw89_roc_end()`, plus callees
`rtw89_phy_dig_suspend()`, `rtw89_phy_dig_resume()`,
`rtw89_phy_dig_ctrl()`.

### Step 5.2: Callers of affected code
**Record:**
- `rtw89_roc_start()` called from `rtw89_ops_remain_on_channel()` in
  `mac80211.c:1466`
- `rtw89_roc_end()` called from `rtw89_ops_cancel_remain_on_channel()`
  (`mac80211.c:1484`) and `rtw89_roc_work()` on timeout (`core.c:4112`)
- ROC is triggered by mac80211/cfg80211 for P2P peer discovery, P2P GO
  negotiation, and off-channel management frame TX

### Step 5.3: Callees
**Record:** `rtw89_phy_dig_suspend()` → `rtw89_phy_dig_ctrl(rtwdev, bb,
true, false)` — sets PD lower bound to 0, disables DIG.
`rtw89_phy_dig_resume(rtwdev, true)` → `rtw89_phy_dig_ctrl(rtwdev, bb,
false, true)` — restores `dig->bak_dig`.

### Step 5.4: Call chain / reachability
**Record:** Userspace (wpa_supplicant, NetworkManager, Android WiFi
Direct) → nl80211/cfg80211 → `remain_on_channel` →
`rtw89_ops_remain_on_channel()` → `rtw89_roc_start()`. Reachable from
userspace during P2P operations. Trigger: P2P peer discovery while STA
is associated to an AP (common WiFi Direct scenario).

### Step 5.5: Similar patterns
**Record:** DIG suspend/resume already used in:
- `fw.c:8099/8134` — hardware scan start/complete
- `chan.c:2347/2447` — MCC start/stop
- `chan.c:2903` — MCC prepare
- `core.c:4626/4818` — STA association start/end (P2P STA)

ROC was the missing path — consistent oversight.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.43)

### Step 6.1: Does the buggy code exist?
**Record:** **Yes.** `rtw89_roc_start()` at lines 4041–4047 does not
call `rtw89_phy_dig_suspend()`. `rtw89_roc_end()` at lines 4089–4094
does not call `rtw89_phy_dig_resume()`. DIG suspend/resume APIs exist
and are used elsewhere. Bug is present in this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` succeeded with no
conflicts. Minor contextual differences from mainline (e.g., RX filter
setup style) do not affect placement of the two new calls.

### Step 6.3: Related fixes already present?
**Record:** `98a774e2c58df` fixes probe-response reception under MLO
(different root cause — MAC address matching). No existing fix for DIG-
during-ROC issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem and criticality
**Record:** **Subsystem:** `drivers/net/wireless/realtek/rtw89` —
Realtek 802.11ax WiFi driver. **Criticality:** IMPORTANT (peripheral
driver, but WiFi connectivity affects many laptop/desktop users with
RTL8852/8922 chips).

### Step 7.2: Subsystem activity
**Record:** Actively maintained — multiple rtw89 fixes backported to
this 6.18.y tree in recent history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of Realtek rtw89 hardware (RTL8852AE/BE, RTL8922AE,
etc.) running P2P/WiFi Direct while simultaneously associated as STA to
an AP. Config-dependent: `CONFIG_RTW89` and specific hardware.

### Step 8.2: Trigger conditions
**Record:**
- STA connected to AP with strong RSSI
- P2P interface initiates remain-on-channel for peer discovery
- **Likelihood:** Common in WiFi Direct use (screen mirroring, file
  sharing, P2P GO negotiation)
- **Unprivileged trigger:** Yes — userspace WiFi management triggers ROC
  via standard nl80211 APIs

### Step 8.3: Failure mode severity
**Record:** **Failure mode:** P2P peer discovery fails — probe requests
from peers not received. **Severity:** MEDIUM — functional/connectivity
breakage, not kernel crash, data corruption, or security vulnerability.
Degrades WiFi Direct usability in a realistic scenario.

### Step 8.4: Risk-benefit ratio
**Record:**
- **Benefit:** Restores P2P peer discovery for rtw89 users; aligns ROC
  with established DIG handling; precedent exists in this tree for
  similar probe-reception fixes
- **Risk:** Very low — 2 lines, proven API, symmetric pairing,
  idempotent implementation
- **Ratio:** Favorable — low risk, real user-visible benefit for
  affected hardware

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real functional bug with clear mechanism (PD lower bound too high
  during ROC)
- Small, surgical, obviously correct fix following existing driver
  patterns
- Applies cleanly to v6.18.43
- Maintainer sign-off (Ping-Ke Shih)
- Precedent: `98a774e2c58df` (probe response reception) already
  backported to this tree
- Userspace-reachable via standard P2P/ROC nl80211 operations
- Stable rules allow "real bug that bothers people" and "interactivity
  issue"

**AGAINST backport:**
- Not a crash, security issue, or data corruption
- Hardware-specific (rtw89 only)
- No user bug report or syzbot evidence verified
- Mailing list review unverified
- Strict "important issue" bar (oops/hang/corruption) not met literally

**Unresolved:** Lore discussion content, explicit stable nomination,
user bug reports.

### Step 9.2: Stable rules checklist
1. **Obviously correct and tested?** PASS — mirrors scan/MCC pattern;
   maintainer SOB; logic verifiable in code (testing not independently
   verified)
2. **Fixes a real bug affecting users?** PASS — P2P peer discovery
   failure on rtw89 with strong AP signal
3. **Important issue?** PASS (borderline) — connectivity/interactivity
   issue per stable-kernel-rules.rst allowance for "real bug that
   bothers people" and notable interactivity issues; not CRITICAL
   severity
4. **Small and contained?** PASS — 2 lines, 1 file
5. **No new features or APIs?** PASS — uses existing internal APIs only
6. **Can apply to local tree?** PASS — clean apply verified; all
   prerequisites present

### Step 9.3: Exception categories
**Record:** None directly (not device ID, quirk, DT, build fix, or
docs). Qualifies as a hardware driver functional bug fix.

### Step 9.4: Decision rationale

For **v6.18.43**, the bug exists: ROC does not suspend DIG while scan
and MCC already do. The fix is minimal, follows established driver
conventions, applies cleanly, and addresses a real WiFi Direct peer-
discovery failure on rtw89 hardware. This tree already backported a
closely related rtw89 probe-reception fix (`98a774e2c58df`),
establishing precedent for this class of connectivity bug. The risk is
negligible; the benefit to P2P users on affected hardware is concrete.

---

## Verification

- **[Phase 1]** Parsed commit message: subject, body, SOBs from Realtek
  authors, Link tag; no Fixes/Reported-by/Cc: stable
- **[Phase 2]** Read diff and `core.c` ROC functions (lines 3989–4117);
  read `rtw89_phy_dig_ctrl/suspend/resume` in `phy.c` (6880–6937)
- **[Phase 2]** Confirmed suspend sets PD lower bound to 0; resume with
  `restore=true` restores `bak_dig`
- **[Phase 3]** `git describe HEAD`: v6.18.43
- **[Phase 3]** `git blame` on ROC and DIG functions: present in tree
- **[Phase 3]** `git log --grep="probe response"`: found `98a774e2c58df`
  already in tree
- **[Phase 3]** `git apply --check`: patch applies cleanly
- **[Phase 4]** WebFetch/curl to lore.kernel.org: BLOCKED by Anubis
- **[Phase 4]** `b4 dig -c HEAD`: N/A (commit not in tree)
- **[Phase 5]** Grep callers: `mac80211.c:1466,1484`, `core.c:4112`
- **[Phase 5]** Grep all `rtw89_phy_dig_suspend/resume` sites: fw.c,
  chan.c, core.c (assoc) — ROC missing
- **[Phase 6]** Confirmed buggy code present at `core.c:4041–4094`
  without DIG calls
- **[Phase 6]** Confirmed `rtw89_phy_dig_suspend/resume` declared in
  `phy.h`, implemented in `phy.c`
- **[Phase 7]** Confirmed rtw89 driver directory exists; recent stable
  rtw89 activity in git log
- **[Phase 8]** Traced ROC path from `rtw89_ops_remain_on_channel()` —
  userspace-reachable
- **UNVERIFIED:** Mailing list review, stable nominations, user bug
  reports, series prerequisite patches

**YES**

 drivers/net/wireless/realtek/rtw89/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 018857d3569a8..d10483210ccca 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -4041,6 +4041,7 @@ void rtw89_roc_start(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 	reg = rtw89_mac_reg_by_idx(rtwdev, mac->rx_fltr, rtwvif_link->mac_idx);
 	rtw89_write32_clr(rtwdev, reg, B_AX_A_UC_CAM_MATCH | B_AX_A_BC_CAM_MATCH);
 
+	rtw89_phy_dig_suspend(rtwdev);
 	ieee80211_ready_on_channel(hw);
 	wiphy_delayed_work_cancel(hw->wiphy, &rtwvif->roc.roc_work);
 	wiphy_delayed_work_queue(hw->wiphy, &rtwvif->roc.roc_work,
@@ -4088,6 +4089,7 @@ void rtw89_roc_end(struct rtw89_dev *rtwdev, struct rtw89_vif *rtwvif)
 
 	rtw89_core_handle_sta_pending_tx(rtwdev, rtwvif_link);
 	queue_work(rtwdev->txq_wq, &rtwdev->txq_work);
+	rtw89_phy_dig_resume(rtwdev, true);
 
 	if (hw->conf.flags & IEEE80211_CONF_IDLE)
 		wiphy_delayed_work_queue(hw->wiphy, &roc->roc_work,
-- 
2.53.0

