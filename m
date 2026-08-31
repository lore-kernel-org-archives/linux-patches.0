Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6EB53FD49;
	Mon, 31 Aug 2026 13:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183960; cv=none; b=nn2N1EuoHtHX6ma/Uu+2tXx5TQhWEjiL0kNjAzJUl8bqkJA63LnvhPISToifiRv1XlvFKaoWIXtxM1XMgU8aVj6sT9VuAR62s7xZq+YQr9+hQCzloEu9Obg10wqyVrYG1hMhBAla5hzA9EuIPJm1ecFiouLMKLn1T/xYzpqtVDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183960; c=relaxed/simple;
	bh=laKgF3T+72TkSASFUL3U0Cf2oE3nNpCWepCuO5U0FpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N7wEE6n0emD56CJH7775oGDZa8NWoCvCKVrfOobBM4raVOqQraknPUrsoM+cnwGk6Ts3lrzh+jaWF4EJe1FTODswe//kKZs6S83gawEDpbxdGGVP77qvp/0WKEShimE210QdQC4bgjjxssKun9v8LwvZPACEVhq5k/LqW70QqDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzQAX7+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzQAX7+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198E81F00ACF;
	Mon, 31 Aug 2026 13:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183958;
	bh=003shy3L+UXbpB2hQD5Ja9a+UsUsVuBDrZ9w6FGc2aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzQAX7+8/g2UzpvGAftUth5m2V1YEPoUGgWmYiUBJApbCc3GyO9oNGBFnmSTuZXc9
	 2+umK+WRXKEatGblNssGAUqaeFrUIQctRSIY5/sB3mBG3CLJLEPdFioCRbcocKacVS
	 O68G5/ynSs6Jf6uschZfR60wt6ETzwS1v6VAW1OfGF+9mZPkRR8V/SA2gYVuDbzSVg
	 283v7BMffx6cFil87jXxTU1KAF1KkvPtOgCvquXOm6QwkBz+KgOYfITzdKVIJTDd53
	 zsMP/9NFFYW2/0N9eKe+9BzHfw4RA6KDwLD7RFRzWN2GJ1jbDR6I3KLSgat41SrO5s
	 wWqInNzgnDRvg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: rtw89: disable HTC field in AP mode
Date: Mon, 31 Aug 2026 09:27:12 -0400
Message-ID: <20260831133314.4125787-404-sashal@kernel.org>
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

[ Upstream commit 1e53b826d5f8a3ca6d88fa6ed263acf54503214b ]

Disable HE QoS HTC field when operating in AP mode to resolve
interoperability issues with some stations.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260424072552.59220-3-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `wifi: rtw89: disable HTC field in AP mode`

**Local tree:** `v6.18.43` (Linux 6.18.y stable)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: rtw89]` `[disable]` — Disable HE QoS HTC field when
the driver operates in AP mode.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Dian-Syuan Yang `<dian_syuan0116@realtek.com>`
  (author)
- **Signed-off-by:** Ping-Ke Shih `<pkshih@realtek.com>` (Realtek
  maintainer)
- **Link:**
  `https://patch.msgid.link/20260424072552.59220-3-pkshih@realtek.com`
  (patch 3/N of a series, from Message-ID)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags

Notable: vendor-authored fix with maintainer sign-off; no external bug
report or syzbot reference.

### Step 1.3: Body analysis
**Record:**
- **Bug:** HE QoS HTC (High Throughput Control) field is inserted into
  transmitted QoS data frames; in AP mode this breaks interoperability
  with some client stations.
- **Symptom:** Connectivity failures or degraded behavior for certain
  clients associated to an rtw89 soft-AP/hotspot (not kernel
  crash/oops).
- **Root cause (author):** AP-mode frames should not carry the HE QoS
  HTC field; some stations mishandle it.
- **Version info:** None stated in the message.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says “disable,” this is an
interoperability/connectivity bug fix, not a feature addition. The
existing code already has a related AP IOT workaround comment for
EAPoL/ARP/DHCP; this extends that logic to all AP-mode data traffic.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/realtek/rtw89/core.c` (+4 lines)
- **Function:** `__rtw89_core_tx_check_he_qos_htc()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** For HE-capable associated stations, QoS data frames could
  get an HE HTC field inserted on transmit (except EAPoL/ARP/DHCP/ICMP
  special packets via `pkt_type < PACKET_MAX`).
- **After:** Same logic, but returns `false` (skip HTC insertion) when
  `tx_req->vif->type == NL80211_IFTYPE_AP`.
- **Path affected:** Normal data TX path in AP mode
  (`RTW89_CORE_TX_TYPE_DATA`).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / interoperability (hardware quirk–style
  workaround)
- **Mechanism:** Driver inserts non-standard or unwanted HE HTC on AP
  TX; some client firmware rejects or mishandles those frames, breaking
  association or data connectivity. Fix gates HTC insertion off in AP
  mode entirely.

### Step 2.4: Fix quality
**Record:**
- Fix is minimal and consistent with the existing partial workaround at
  line 855 (“AP IOT issue with EAPoL, ARP and DHCP”).
- **Regression risk:** Low. Disabling HTC in AP mode may reduce HE
  signaling optimizations (e.g. A-CTRL/BSR-related paths) but restores
  client compatibility; STA mode unchanged.
- **Concern:** `tx_req->vif` is dereferenced without a NULL check; safe
  on the DATA TX path where `vif` is always set in
  `rtw89_core_tx_write_link()`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `__rtw89_core_tx_check_he_qos_htc()` and related HE QoS HTC
code are present in this tree (blame attributes to `19eef1d98eeda`, a
stable-tree history artifact — the function body including the “AP IOT
issue” comment is present in v6.18.43).

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in the commit message.

### Step 3.3: Related file history
**Record:** Recent rtw89 stable backports in this tree include
connectivity and hardware workarounds (`98a774e2c58df` MLO probe
responses, `4b4784394099d` disable EHT by chip cap, `ffbcca93034f1`
device ID). No prior fix for AP-mode HTC found.

### Step 3.4: Author context
**Record:** Ping-Ke Shih is an active rtw89 contributor; several of his
patches are already in this 6.18.y tree.

### Step 3.5: Dependencies
**Record:** Message-ID suffix `-3` indicates patch 3 of a series.
**UNVERIFIED:** patches 1 and 2 could not be retrieved (lore blocked).
The diff itself is self-contained — only adds an AP-mode guard in one
function, with no new symbols or structures. Standalone application
appears feasible.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** **UNVERIFIED** — `b4 dig` requires a commit hash (not
available in this candidate-only review), and
lore.kernel.org/patch.msgid.link are blocked by bot protection. Could
not read reviewer feedback or stable nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not run (no commit hash).

### Step 4.3: Bug reports
**Record:** None in commit message. No syzbot, bugzilla, or user
Reported-by.

### Step 4.4: Series context
**Record:** **UNVERIFIED** — patch 3/N; content of earlier patches
unknown. This hunk has no apparent dependency on other series members.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — lore stable search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__rtw89_core_tx_check_he_qos_htc()`, called from
`rtw89_core_tx_update_he_qos_htc()`, called from
`rtw89_core_tx_update_desc_info()` on `RTW89_CORE_TX_TYPE_DATA`.

### Step 5.2: Callers
**Record:**
- `rtw89_core_tx_update_desc_info()` ← `rtw89_core_tx_write_link()`
  (data frames, `vif` set at line 1237)
- `rtw89_core_tx_update_desc_info()` ← `rtw89_h2c_tx()` (FWCMD only;
  does not hit DATA case / HTC path)

### Step 5.3: Callees
**Record:** RCU read of `link_sta->he_cap`, frame-type checks,
`skb_headroom` check, RA fallback check; on success,
`__rtw89_core_tx_adjust_he_qos_htc()` inserts HTC and sets
`desc_info->a_ctrl_bsr`.

### Step 5.4: Reachability
**Record:** Triggered on every QoS data frame TX to an HE-capable
station. In AP mode (soft-AP, hostapd), this is a common, user-visible
path. Not a theoretical/obscure code path.

### Step 5.5: Similar patterns
**Record:** Existing `pkt_type < PACKET_MAX` guard (lines 855–857)
already disables HTC for EAPoL/ARP/DHCP in AP IOT scenarios. The new
check generalizes that pattern to all AP-mode frames. Elsewhere in
rtw89, `NL80211_IFTYPE_AP` is used extensively for AP-specific behavior.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** `__rtw89_core_tx_check_he_qos_htc()` exists at
lines 845–881 without the AP-mode guard. HE QoS HTC insertion is active
for AP-mode data frames today.

### Step 6.2: Backport complications
**Record:** Clean apply expected — `struct rtw89_core_tx_request`
already has `struct ieee80211_vif *vif` (core.h:1198), and the target
function matches the upstream diff context.

### Step 6.3: Related fixes already present?
**Record:** Partial workaround for EAPoL/ARP/DHCP exists; full AP-mode
disable is **not** present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/net/wireless/realtek/rtw89` — **IMPORTANT** (WiFi
driver; affects users of Realtek 8852/8922-series hardware).

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y — multiple rtw89 fixes already
backported to this tree.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users running rtw89 in **AP mode** (soft-AP, WiFi hotspot,
tethering) with **HE-capable client stations** that mishandle HTC.
Config: `CONFIG_RTW89` (+ PCI/USB variant). Driver-specific, not
universal.

### Step 8.2: Trigger conditions
**Record:** AP mode + HE client + QoS data frame TX (not EAPoL/ARP/DHCP,
which are already exempt). Common during normal hotspot use. Not a
security-relevant userspace trigger.

### Step 8.3: Failure mode severity
**Record:** Client connectivity/interoperability failure — clients may
fail to pass traffic, associate unreliably, or disconnect. **Severity:
MEDIUM** (functional, user-visible; not crash, corruption, or deadlock).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Restores AP-mode usability with affected client devices;
  complements existing partial IOT workaround.
- **Risk:** Very low — 4 lines, AP-mode only, disables a signaling
  optimization.
- **Ratio:** Favorable for stable; fits the hardware-
  quirk/interoperability exception category.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real interoperability bug with user-visible connectivity impact in AP
  mode
- Tiny, obviously correct, vendor-authored fix
- Buggy code and all prerequisites exist in v6.18.43
- Extends an existing in-tree AP IOT workaround
- Low regression risk; similar rtw89 connectivity/hardware fixes already
  in this stable tree
- Fits stable exception: hardware/driver interoperability workaround

**AGAINST backport:**
- Not crash/security/corruption/deadline
- No external bug reports or Tested-by in commit message
- Mailing-list review unverified
- Patch 3/N series — earlier patches unverified (but this hunk appears
  standalone)
- Does not cover `NL80211_IFTYPE_P2P_GO` (only `NL80211_IFTYPE_AP`)

**UNRESOLVED:**
- Mailing-list review and stable nomination discussion
- Whether patches 1–2 of the series are required
- Specific client models affected

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (logic is clear; no Tested-by
   verified)
2. Fixes a real bug affecting users? **PASS** (AP-mode client
   interoperability)
3. Important issue? **PASS** (MEDIUM — serious functional/connectivity
   impact for AP users, though not crash-level)
4. Small and contained? **PASS** (+4 lines, one function)
5. No new features or APIs? **PASS** (disables existing behavior in AP
   mode)
6. Can apply to local tree? **PASS** (code present, clean apply
   expected)

### Step 9.3: Exception category
**Record:** Hardware/driver interoperability workaround (quirk-style),
analogous to existing in-driver AP IOT handling.

### Step 9.4: Decision rationale
For v6.18.43, the HE QoS HTC insertion code is present and active in AP
mode. The fix is minimal, vendor-validated, directly addresses a real
connectivity problem for soft-AP users, and aligns with existing partial
workarounds already in this tree. Risk is very low. This is appropriate
stable material under the interoperability/quirk exception, consistent
with other rtw89 fixes already backported here.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Read current `core.c` lines 844–934, 1120–1130, 1223–1245;
  confirmed diff context matches
- [Phase 2] Confirmed `pkt_type < PACKET_MAX` maps to
  EAPoL/ARP/DHCP/ICMP via `rtw89_core_tx_btc_spec_pkt_notify()`
- [Phase 3] `git describe HEAD` → `v6.18.43`
- [Phase 3] `git blame -L 845,885` → HE QoS HTC function present in tree
- [Phase 3] `git log --oneline -30 --grep="wifi: rtw89"` → prior rtw89
  stable backports confirmed
- [Phase 3] No Fixes: tag to follow
- [Phase 4] `b4 dig` — requires commit hash; not run
- [Phase 4] lore.kernel.org / patch.msgid.link — blocked (bot
  protection); **UNVERIFIED**
- [Phase 4] patchwork.kernel.org search — no patch entries returned;
  **UNVERIFIED**
- [Phase 5] `grep rtw89_core_tx_update_he_qos_htc` → single DATA-path
  call site
- [Phase 5] `grep tx_req.vif` → set in `rtw89_core_tx_write_link()` line
  1237
- [Phase 5] Verified FWCMD path does not reach HTC code (switch on
  `tx_type`)
- [Phase 6] `grep NL80211_IFTYPE_AP` in
  `__rtw89_core_tx_check_he_qos_htc` → not present (fix not yet applied)
- [Phase 6] `struct rtw89_core_tx_request` has `vif` field in
  `core.h:1198`
- [Phase 7] `CONFIG_RTW89` present in Kconfig
- [Phase 8] Failure mode assessed as MEDIUM connectivity issue, not
  CRITICAL crash

**YES**

 drivers/net/wireless/realtek/rtw89/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index d10483210ccca..989c6b09b2706 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -847,6 +847,7 @@ __rtw89_core_tx_check_he_qos_htc(struct rtw89_dev *rtwdev,
 				 enum btc_pkt_type pkt_type)
 {
 	struct rtw89_sta_link *rtwsta_link = tx_req->rtwsta_link;
+	struct ieee80211_vif *vif = tx_req->vif;
 	struct sk_buff *skb = tx_req->skb;
 	struct ieee80211_hdr *hdr = (void *)skb->data;
 	struct ieee80211_link_sta *link_sta;
@@ -878,6 +879,9 @@ __rtw89_core_tx_check_he_qos_htc(struct rtw89_dev *rtwdev,
 	if (rtwsta_link && rtwsta_link->ra_report.might_fallback_legacy)
 		return false;
 
+	if (vif->type == NL80211_IFTYPE_AP)
+		return false;
+
 	return true;
 }
 
-- 
2.53.0

