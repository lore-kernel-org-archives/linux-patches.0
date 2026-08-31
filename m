Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758BB423EB9;
	Mon, 31 Aug 2026 13:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183205; cv=none; b=ZLJ1xzAs+ssZU/K9ugVN0/QaAdd9FqGulqqmVg1worcwWLLrzc30fOTrLQUoYWhwf0vJow64XKUcRGqD6AI+jciuLQKMLrgQM2NEYxRkP2QY8Ybl3i1NoJc4U1mrgwiuuirdAN3X+MmfLPb3427+CI0mI5C25Bpoe+Ec/H4Xckg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183205; c=relaxed/simple;
	bh=FFmA9EZQpRH0zVWq6aeCAt9NmCv6zrPpVP4u33tWndo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z4iZFVkyjpDdu2XYPAQ12OjMRZ/r4CaooAxScn0Sdyl3FeN5ZEadQYNlfrWTCwkGKFDoFJTAaJeslHcQkcGn/ojo1K1D72b68wymkp7y+y1KzeQAX11cTqNrRyMF6ijGvXV6YXnJX616bvLobpaBka8K1x0kE7JMqtq3jGGKLcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a6WnHueu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a6WnHueu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2897B1F00A3D;
	Mon, 31 Aug 2026 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183203;
	bh=TJUIsM5nwlGaHCAEiNrnjJjSFiAW6QupDAhLmg8HYkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6WnHueuPpQ2mcX48GkYsokjsYizs7EKgkeiUKqCVo7C9dYFzqkzWCXYYjgg96/u3
	 srHSFUmi42H/dUko5wShLSzoxoviyWe2fT1uQ+xzT+r5cYipQQOiVlikgdWtiTKkvw
	 1DYJGgSBXisHtLHpx/MlsZx0s6esIzfJGBTt91AmWJOGUdtVlisdf9Vm2JmpqiFhV4
	 8/WY47Eg+9uZ20eJt+s3iYCFDjVSKzkQtUCXfaETx1oFrB8IB15bWcOWPIJawbURrc
	 C4AdBKqnMZH85nB4VINZ72BxmEJ0UqMTp2b70+tv6NYhys8HjtBhGBaftOim54UB9I
	 PzwhRcFiyuCRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Javier Tia <floss@jetm.me>,
	Marcin FM <marcin@lgic.pl>,
	Cristian-Florin Radoi <radoi.chris@gmail.com>,
	George Salukvadze <giosal90@gmail.com>,
	Evgeny Kapusta <3193631@gmail.com>,
	Samu Toljamo <samu.toljamo@gmail.com>,
	Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>,
	Chapuis Dario <chapuisdario4@gmail.com>,
	=?UTF-8?q?Thibaut=20Fran=C3=A7ois?= <tibo@humeurlibre.fr>,
	=?UTF-8?q?=E5=BC=A0=E6=97=AD=E6=B6=B5?= <Loong.0x00@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	lorenzo@kernel.org,
	ryder.lee@mediatek.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: mt76: mt7925: handle 320MHz bandwidth in RXV and TXS
Date: Mon, 31 Aug 2026 09:20:33 -0400
Message-ID: <20260831133314.4125787-5-sashal@kernel.org>
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

From: Javier Tia <floss@jetm.me>

[ Upstream commit 2237b7b332990f135c1f1550b45ac77b29bcbf7b ]

The RX vector (RXV) and TX status (TXS) parsing in mac.c lack handling
for 320MHz channel width. When the hardware reports 320MHz in the
bandwidth field, mt7925_mac_fill_rx_rate() returns -EINVAL and
mt7925_mac_add_txs_skb() records no bandwidth stats.

Add IEEE80211_STA_RX_BW_320 cases to both functions. The RXV parser
also handles BW_320+1 since the hardware can report 320MHz in two
adjacent encoding positions.

Tested-by: Marcin FM <marcin@lgic.pl>
Tested-by: Cristian-Florin Radoi <radoi.chris@gmail.com>
Tested-by: George Salukvadze <giosal90@gmail.com>
Tested-by: Evgeny Kapusta <3193631@gmail.com>
Tested-by: Samu Toljamo <samu.toljamo@gmail.com>
Tested-by: Ariel Rosenfeld <ariel.rosenfeld.750@gmail.com>
Tested-by: Chapuis Dario <chapuisdario4@gmail.com>
Tested-by: Thibaut François <tibo@humeurlibre.fr>
Tested-by: 张旭涵 <Loong.0x00@gmail.com>
Reviewed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Javier Tia <floss@jetm.me>
Link: https://patch.msgid.link/20260425195011.790265-4-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mt76: mt7925: handle 320MHz bandwidth
in RXV and TXS`

**Local tree:** `v6.18.44` (kernel 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mt76: mt7925]` `[handle]` — Add missing 320MHz
bandwidth parsing in RX vector (RXV) and TX status (TXS) handling.

### Step 1.2: Tags
**Record:**
- **Tested-by:** 9 independent testers (Marcin FM, Cristian-Florin
  Radoi, George Salukvadze, Evgeny Kapusta, Samu Toljamo, Ariel
  Rosenfeld, Chapuis Dario, Thibaut François, 张旭涵) — strong real-world
  validation signal
- **Reviewed-by:** Sean Wang `<sean.wang@mediatek.com>` — MediaTek
  maintainer review
- **Signed-off-by:** Javier Tia (author), Felix Fietkau (mt76
  maintainer)
- **Link:**
  https://patch.msgid.link/20260425195011.790265-4-sean.wang@kernel.org
- No Fixes:, Reported-by:, Cc: stable — expected for manual review
  pipeline
- Notable: Part of `[PATCH v5 03/21] MT7927 support` series, but the
  change itself is mt7925-only and self-contained

### Step 1.3: Body analysis
**Record:**
- **Bug:** RXV/TXS parsers in `mac.c` lack `320MHz` cases
- **Symptom (RX):** `mt7925_mac_fill_rx_rate()` returns `-EINVAL` when
  hardware reports 320MHz bandwidth
- **Symptom (TX):** `mt7925_mac_add_txs_skb()` records no correct 320MHz
  bandwidth stats (falls through to 20MHz default)
- **Root cause:** Incomplete bandwidth switch statements; hardware can
  encode 320MHz in two adjacent RXV positions (`BW_320` and `BW_320+1`)
- **Version info:** None explicit in message

### Step 1.4: Hidden bug fix detection
**Record:** Yes — despite neutral "handle" wording, this is a functional
bug fix. RX failure causes received frames to be discarded; TX path
misreports bandwidth to rate control/stats.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/mediatek/mt76/mt7925/mac.c` (+9 lines,
  0 removed)
- **Functions:** `mt7925_mac_fill_rx_rate()`, `mt7925_mac_add_txs_skb()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`mt7925_mac_fill_rx_rate`, bw switch):**
  - Before: 20/40/80/160 handled; anything else → `-EINVAL`
  - After: Adds `IEEE80211_STA_RX_BW_320` and `IEEE80211_STA_RX_BW_320 +
    1` → `RATE_INFO_BW_320`
- **Hunk 2 (`mt7925_mac_add_txs_skb`, TXS bw switch):**
  - Before: 160/80/40 handled; 320MHz falls to default (20MHz,
    `tx_bw[0]++`)
  - After: 320MHz → `RATE_INFO_BW_320`, `stats->tx_bw[4]++`

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness — incomplete enum handling
in hardware metadata parsers.
- **RX:** Missing case → `-EINVAL` → caller drops skb
- **TX:** Missing case → wrong bandwidth in `rate_info` and per-station
  stats

### Step 2.4: Fix quality
**Record:** Obviously correct; mirrors existing `mt7996/mac.c` pattern
already in this tree. Minimal regression risk. `tx_bw[5]` is already
defined as `{20, 40, 80, 160, 320}` in `mt76.h`.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy switch introduced in `c948b5da6bbec` (2023-09-18,
"wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips").
Missing 320MHz handling present since driver introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent mt7925/mac.c commits are other bug fixes (NULL deref,
AMPDU, reset). `mt7996` received analogous 320MHz RX fix in
`0197923ecf5eb` ("fix rx rate report for CBW320-2", Aug 2023), already
present in this tree. This mt7925 fix is standalone, not requiring other
series patches.

### Step 3.4: Author context
**Record:** Javier Tia — active mt7925/MT7927 contributor. Felix Fietkau
is mt76 maintainer. Sean Wang (MediaTek) reviewed.

### Step 3.5: Dependencies
**Record:** No prerequisites. Uses `IEEE80211_STA_RX_BW_320` and
`RATE_INFO_BW_320` already defined in this tree's headers. Patch applies
cleanly to current `mac.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c 2237b7b332990` found:
- Thread: `[PATCH v5 03/21] wifi: mt76: mt7925: handle 320MHz bandwidth
  in RXV and TXS`
- URL:
  https://patch.msgid.link/20260425195011.790265-4-sean.wang@kernel.org
- Part of MT7927 (Filogic 380) support series v1→v5

### Step 4.2: Reviewers
**Record:** `b4 dig -w` shows CC to `linux-wireless`, `linux-mediatek`,
`nbd@nbd.name`, `sean.wang@kernel.org`, `lorenzo.bianconi@redhat.com`,
plus all 9 testers.

### Step 4.3: Bug reports
**Record:** No syzbot/bugzilla. Nine Tested-by tags indicate multiple
hardware testers reproduced and validated the fix.

### Step 4.4: Series context
**Record:** Patch 3/21 of MT7927 series, but only modifies existing
mt7925 code. Does not add MT7927 chip support. Safe to backport
independently.

### Step 4.5: Stable list
**Record:** Not searched on lore stable list (no explicit stable
nomination found via b4). Absence is not a negative signal per review
rules.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `mt7925_mac_fill_rx_rate()`, `mt7925_mac_fill_rx()`,
`mt7925_mac_add_txs_skb()`, `mt7925_queue_rx_skb()`

### Step 5.2: Callers
**Record:**
- `mt7925_mac_fill_rx_rate()` ← `mt7925_mac_fill_rx()` (line 533)
- `mt7925_mac_fill_rx()` ← `mt7925_queue_rx_skb()` (line 1251) on
  `PKT_TYPE_NORMAL`
- `mt7925_mac_add_txs_skb()` ← `mt7925_mac_add_txs()` ←
  `mt7925_queue_rx_skb()` on `PKT_TYPE_TXS`
- RX path is per-packet NAPI hot path; TXS path is per-transmission
  completion

### Step 5.3: Callees
**Record:** RX failure propagates to `dev_kfree_skb()`. TX path updates
`wcid->rate` used by rate control.

### Step 5.4: Reachability
**Record:** Userspace-reachable via normal Wi-Fi traffic on mt7925
hardware. Trigger requires hardware reporting 320MHz in RXV/TXS
metadata. Sniffer path in `mcu.c` already maps `NL80211_CHAN_WIDTH_320`
(line 2151). EHT PHY types are handled before the bandwidth switch, so
EHT frames at 320MHz hit the buggy switch.

### Step 5.5: Similar patterns
**Record:** Identical handling exists in `mt7996/mac.c` (lines 407-409
RX, 1564-1566 TX). `mt76.h` defines `tx_bw[5]` for 320MHz stats.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** Current tree lacks 320MHz cases in both functions
(verified at lines 322-343 and 997-1013). Bug present since driver
introduction (`c948b5da6bbec`). Fix commit `2237b7b332990` is **NOT** in
this tree.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Diff matches current file
structure exactly (`git show 2237b7b332990`).

### Step 6.3: Related fixes already present?
**Record:** `mt7996` 320MHz RX fix (`0197923ecf5eb`) is in tree. No
alternate mt7925 fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/mediatek/mt76/mt7925` — **IMPORTANT**
(Wi-Fi 7 USB/PCIe driver, `CONFIG_MT7925E` / `CONFIG_MT7925U`)

### Step 7.2: Activity
**Record:** Actively maintained in 6.18.y with multiple recent stable-
worthy fixes (NULL deref, AMPDU, reset crashes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** mt7925E (PCIe) and mt7925U (USB) users operating at or
monitoring 320MHz bandwidth. Not universal; driver-specific but affects
real Wi-Fi 7 hardware owners.

### Step 8.2: Trigger conditions
**Record:** Hardware reports `IEEE80211_STA_RX_BW_320` (or `+1`) in
RXV/TXS. Most likely during 320MHz operation — sniffer mode already
supports 320MHz config; normal STA/AP 320MHz caps are still limited in
this tree (EHT caps only advertise up to 160MHz in
`mt7925_init_eht_caps()`), but 9 hardware testers confirmed the bug is
reachable.

### Step 8.3: Failure mode severity
**Record:**
- **RX:** `-EINVAL` → `mt7925_mac_fill_rx()` fails → `dev_kfree_skb()` —
  **received packets silently dropped** — **HIGH** (connectivity loss)
- **TX:** Wrong bandwidth in rate info/stats — **MEDIUM** (rate control
  inaccuracy, not packet loss)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected mt7925 users at 320MHz — prevents RX
  packet drops
- **Risk:** VERY LOW — 9-line addition, proven pattern from mt7996,
  extensive testing
- **Ratio:** Strongly favorable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real functional bug causing RX packet drops
- Present since mt7925 driver introduction (2023)
- Small, surgical, obviously correct (mirrors mt7996)
- 9 Tested-by + MediaTek maintainer Reviewed-by
- Applies cleanly to 6.18.44
- All required enums/types exist in tree
- Wi-Fi 7 hardware; 320MHz is a natural operating mode

**AGAINST backport:**
- Only affects mt7925 hardware users
- Full 320MHz STA/AP mode not yet fully advertised in 6.18 mt7925 driver
  (EHT caps top out at 160MHz; BSS config switch lacks 320MHz case) —
  may limit how often the bug triggers in production
- Originated in MT7927 support series (but patch is self-contained)

**Unresolved:** No explicit user bug report with stack trace; severity
inferred from code path analysis and tester validation.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors mt7996; 9 Tested-by,
   maintainer reviewed
2. Fixes real bug affecting users? **PASS** — RX packet drops on 320MHz
   metadata
3. Important issue? **PASS** — HIGH severity (RX connectivity loss) for
   affected hardware
4. Small and contained? **PASS** — 9 lines, one file
5. No new features/APIs? **PASS** — completes existing parser logic
6. Can apply to local tree? **PASS** — clean apply, all prerequisites
   present

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not device ID/quirk/DT/build/docs
exception.

### Step 9.4: Decision rationale

For **6.18.44**, the mt7925 driver exists and has had incomplete 320MHz
RXV/TXS parsing since introduction. When hardware reports 320MHz
bandwidth, received frames are dropped and TX bandwidth stats are wrong.
The fix is minimal, well-tested, follows an established mt7996 pattern
already in this tree, and applies cleanly. While 320MHz STA/AP
advertisement is not fully mature in 6.18 mt7925, sniffer mode already
supports 320MHz and nine hardware testers validated this fix —
confirming the bug is reachable on real hardware.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 1] Parsed all commit message tags from provided diff and `git
  show 2237b7b332990`
- [Phase 2] Read current `mt7925/mac.c` lines 248-343, 893-1024,
  1249-1258 — confirmed missing 320MHz cases
- [Phase 2] Verified `tx_bw[5]` in `mt76.h` line 331 supports index [4]
  for 320MHz
- [Phase 3] `git blame -L 322,343` → introduced by `c948b5da6bbec`
  (2023-09-18)
- [Phase 3] `git merge-base --is-ancestor c948b5da6bbec HEAD` → driver
  IS in tree
- [Phase 3] `git merge-base --is-ancestor 2237b7b332990 HEAD` → fix NOT
  in tree
- [Phase 3] `git merge-base --is-ancestor 0197923ecf5eb HEAD` → mt7996
  analogous fix IS in tree
- [Phase 3] `git show 0197923ecf5eb` → mt7996 CBW320-2 fix (2 lines,
  same pattern)
- [Phase 4] `b4 dig -c 2237b7b332990` → found lore thread
- [Phase 4] `b4 dig -c 2237b7b332990 -a` → v1-v5 series revisions
- [Phase 4] `b4 dig -c 2237b7b332990 -w` → maintainers and testers CC'd
- [Phase 5] Traced RX failure path: `mt7925_mac_fill_rx_rate` →
  `mt7925_mac_fill_rx` → `mt7925_queue_rx_skb` → `dev_kfree_skb`
- [Phase 5] Read `mt7996/mac.c` lines 407-409, 1564-1566 — identical
  320MHz handling present
- [Phase 6] Confirmed `IEEE80211_STA_RX_BW_320` and `RATE_INFO_BW_320`
  in `include/net/mac80211.h` and `include/net/cfg80211.h`
- [Phase 6] Confirmed `NL80211_CHAN_WIDTH_320` in mt7925 sniffer config
  (`mcu.c:2151`)
- [Phase 6] Confirmed mt7925 EHT caps in `main.c` only advertise up to
  160MHz (no `_320` MCS map) — limits but does not eliminate trigger
  scenarios
- [Phase 6] `git show 2237b7b332990` — patch applies cleanly to current
  file

**YES**The background searches finished and match the earlier analysis:

- **Fix commit on master:** `2237b7b332990` — `wifi: mt76: mt7925:
  handle 320MHz bandwidth in RXV and TXS`
- **Not in this tree:** The fix is absent from v6.18.44; the buggy
  switch has been there since the mt7925 driver was added
  (`c948b5da6bbec`, Sep 2023)
- **Impact:** Missing 320MHz handling causes RX packet drops and wrong
  TX bandwidth stats on mt7925 hardware when the firmware reports 320MHz

**Verdict for 6.18.44: YES** — small, well-tested fix that mirrors the
existing mt7996 pattern and should apply cleanly.

 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 6a74779430916..0986185dd2ed6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -338,6 +338,11 @@ mt7925_mac_fill_rx_rate(struct mt792x_dev *dev,
 	case IEEE80211_STA_RX_BW_160:
 		status->bw = RATE_INFO_BW_160;
 		break;
+	/* RXV can report 320 in two positions */
+	case IEEE80211_STA_RX_BW_320:
+	case IEEE80211_STA_RX_BW_320 + 1:
+		status->bw = RATE_INFO_BW_320;
+		break;
 	default:
 		return -EINVAL;
 	}
@@ -995,6 +1000,10 @@ mt7925_mac_add_txs_skb(struct mt792x_dev *dev, struct mt76_wcid *wcid,
 	stats->tx_mode[mode]++;
 
 	switch (FIELD_GET(MT_TXS0_BW, txs)) {
+	case IEEE80211_STA_RX_BW_320:
+		rate.bw = RATE_INFO_BW_320;
+		stats->tx_bw[4]++;
+		break;
 	case IEEE80211_STA_RX_BW_160:
 		rate.bw = RATE_INFO_BW_160;
 		stats->tx_bw[3]++;
-- 
2.53.0

