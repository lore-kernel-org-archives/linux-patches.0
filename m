Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CB8583DCE;
	Mon, 19 Oct 2026 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418333; cv=none; b=OjGLdLB3snUOUro9bvXE25yE1aq+VQQpQzUHUgUPTnT4qQOSeYxxgJVmU+aVcvQImQK3CJ1JEXYmXxsjdQ8nnAb+wIubXRGHG8jxU8MYjD5BFfgBHYOG3/sdO20rEgA403MfhNbp5Rpgv4k3SDy9ivnSO8LgLBPGnXVlLQxsTvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418333; c=relaxed/simple;
	bh=ePPOgdJw/fJOkIAqMsREQHhCJe4ZPpMTFGn3ebgCOpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sh7gI9+Qoi+LN1AKg9IDedR5XGwVYzonBm9c5RrpWiNvAVjptUT7j1gLH/DTAuiX1AoHO9cRPQ3wBWfSHPFZI5uoE9M88DNIXoEWZut2YQ/FwFvq0X9ZO8+Dm7avcAVjj7n9InIzthMlxwmOtzp+nWddHvHbcyboo+G+yRaRRv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iSGd+4Pz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iSGd+4Pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CA861F000C8;
	Mon, 19 Oct 2026 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418330;
	bh=YGltY4czcESIxrXuSo7cdUD861jpHKvBgA1Yd+aKDIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iSGd+4PzEEeitJE6AnQ0YlBx6Mufa8bhQbUAT8UGVMt+jIVrNI59uIPtsZf3M/G+L
	 XyJ+xB4Ba91eQHU6r9hWrVM7fu4bpECd/acg1ecJutzgGUUO4Bl5a53cuYdTYgOGLY
	 ud7QZX7eBmvu0uOXhvyxV/dn9lHViIlozvzEmjlOW5hBDPI8TWMsy7Aq1dh4X+7gNL
	 S4Ozzr4PR2/oWdqu4WHhUhxRM6/wSyvPnedXL7QaMHzDoMNNQLB6Y8YjVWjDtpja5K
	 PcFgAsUzdRrnMuXm8Jd/iCm2aBXB3viBbYqV4RrrOQnvc7i9MNWnr5Kqfm6DwSkO7T
	 Zt1Qzop8jbcmA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: David Bauer <mail@david-bauer.net>,
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
Subject: [PATCH AUTOSEL 6.18-5.15] wifi: mt76: mt7603: free beacon SKB on error
Date: Mon, 19 Oct 2026 09:47:42 -0400
Message-ID: <20261019135441.1420968-171-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 965cbdbdfbd37a659a05ff88e49c216975bd9d2e ]

The SKB containing the generated beacon is not freed when the beacon
queue is deected stuck and scheduled for recovery.

Fixes potential memory leaks in case the beacon queue is detected stuck.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260611215658.259324-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.6.157** (`pending-6.6`). The two-line SKB leak is
present here, was introduced by a commit already in this tree, and
applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[wifi: mt76: mt7603]** **[free]** **[free the generated beacon
SKB when queue-stuck recovery bails out]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260611215658.259324-1-mail@david-
  bauer.net`
- **Cc: stable:** none (expected)
- **Signed-off-by:** David Bauer (author); Felix Fietkau (mt76
  maintainer). Ignore any Sasha Levin SOB if present in candidate
  wrapping.

Mainline SHA (from `origin/master`):
`965cbdbdfbd37a659a05ff88e49c216975bd9d2e`
AuthorDate: 2026-06-11; applied by Felix Fietkau 2026-07-31.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** After `ieee80211_beacon_get()`, if `mt76_poll()` times out on
  `MT_DMA_FQCR0` (beacon/BMC queue flush stuck), the function `goto out`
  without freeing the SKB.
- **Symptom:** SKB leak whenever the beacon queue is detected stuck and
  recovery is scheduled. Commit message typo: “deected”.
- **Version info:** none in the message.
- **Root cause (author):** beacon SKB not freed on the stuck-queue error
  path.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. Explicit leak fix: two
`dev_kfree_skb(skb)` calls on error paths.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/net/wireless/mediatek/mt76/mt7603/beacon.c` (**+2 /
  -0**)
- Function: `mt7603_update_beacon_iter()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (both hunks, same pattern):

Before: `ieee80211_beacon_get()` allocates `skb`. Flush BCN or BMC via
`MT_DMA_FQCR0`. If poll times out: set `dev->beacon_check =
MT7603_WATCHDOG_TIMEOUT` and `goto out`. Unlock. **SKB never queued and
never freed.**

After: same, but `dev_kfree_skb(skb)` before `goto out`.

Success path unchanged: `mt76_tx_queue_skb()` still takes ownership.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** error-path resource leak (SKB)
- **Mechanism:** mac80211 docs: *“The driver is responsible for freeing
  the returned skb.”* Error `goto` skipped both queueing and free. Fix
  adds the missing free.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct; only the two error returns; no API/lock/structure
  change.
- **Regression risk:** very low. Success path still hands the SKB to
  DMA. `dev_kfree_skb` is `consume_skb` (stats slightly less precise
  than `kfree_skb` on a drop); maintainer accepted it. No double-free:
  frees only happen before queueing.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Leak `goto out` introduced by **`8caa9dd3d1a7c9`** “wifi: mt76:
  mt7603: improve stuck beacon handling” (Greg KH, 2023-11-20), stable
  rewrite of upstream **`3176205933494`** (Felix Fietkau, 2023-07-28).
- `ieee80211_beacon_get(..., 0)` from `6e8912a503759` (MLO 3-arg API);
  already in this tree.
- Driver added in `c8846e1015022` (2018). Pre-2023 code queued the SKB
  even if poll failed; the 2023 change moved queueing after the polls
  and added the leaky `goto`.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No Fixes: tag. Buggy commit in **this** tree is `8caa9dd3d1a7c9`
(`git merge-base --is-ancestor` = yes). Upstream `3176205933494` is not
an ancestor (stable SHA rewrite). No later origin/master commits touch
this file after `965cbdbdfbd37`.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (this tree, path-limited): last functional change on this file is
the stuck-beacon commit itself. Standalone; not patch X/Y.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: David Bauer already has mt76 commits in this tree (including
mt7603 EEPROM ID). Felix Fietkau is listed maintainer and applied the
patch.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. Same function, same `ieee80211_beacon_get(hw, vif, 0)`,
same poll/`goto out`. `git apply --check` of `965cbdbdfbd37` succeeded.
Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 965cbdbdfbd37` →
  https://patch.msgid.link/20260611215658.259324-1-mail@david-bauer.net
- `b4 dig -a`: **v1 only**
- Thread mbox: patch only, **no replies**, no NAK, no reviewer Cc:
  stable
- lore.kernel.org WebFetch: **403** (used b4 + openwall/patchew mirrors)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc included Felix Fietkau, Lorenzo Bianconi,
MediaTek mt76 reviewers, linux-wireless. Applied by Felix with his SOB.
No Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No Reported-by, syzbot, or bugzilla. Author-found leak on code
inspection. Openwall/Ratatoskr confirm the same v1 text, no discussion.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone `[PATCH mt76]`. No series. No follow-up on
`origin/master` for this file.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable WebFetch **403**. No stable discussion in
the saved thread. UNVERIFIED whether anyone already asked stable@;
absence is not a negative signal.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP: **not available**. Used grep/read.

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `mt7603_update_beacon_iter()` only.

**Step 5.2: TRACE CALLERS**

Record:
- Called from `mt7603_pre_tbtt_tasklet()` via
  `ieee80211_iterate_active_interfaces_atomic()`.
- Tasklet scheduled from `mt7603_irq_handler()` on
  `MT_HW_INT3_PRE_TBTT0`.
- Reachable whenever the device is an AP with beacons enabled
  (`beacon_mask`).

**Step 5.3: TRACE CALLEES**

Record: `ieee80211_beacon_get` (driver owns SKB), `mt76_poll`/`mt76_wr`,
`mt76_tx_queue_skb` → `mt76_dma_tx_queue_skb` (takes SKB; error path
uses `ieee80211_tx_status_ext`).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: userspace/AP stack enables beaconing → hardware pre-TBTT IRQ →
tasklet → iterator. Unprivileged clients do not trigger it directly;
**any AP/router using this chip in AP mode can**. Stuck DMA/FQCR0 is the
error trigger. `mac_work` runs every `MT7603_WATCHDOG_TIME` (100 ms) and
treats `beacon_check >= 10` as `RESET_CAUSE_BEACON_STUCK`.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Other mt76 chips use `ieee80211_beacon_get_template` /
`mt76x02_mac_set_beacon` and do not share this FQCR0 poll/`goto out`
pattern. mt76x02 has no equivalent leak.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/net/wireless/mediatek/mt76/mt7603/beacon.c`
lines 57–66: poll timeout → set watchdog → `goto out` with no free.
Local: `git describe` → `p-6.6-3-g04810563abb71`, `make kernelversion` →
**6.6.157**. Bug since 8caa9dd3d1a7c9 (stuck-beacon handling). Candidate
`965cbdbdfbd37` is **not** an ancestor of HEAD.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** (`git show 965cbdbdfbd37 | git apply --check`).
Surrounding function matches mainline hunks.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other “free beacon SKB” commit. Other mt76 leak fixes
(`ec4a608bca405` probe leak, etc.) are unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **wifi / mt76 / mt7603** (`CONFIG_MT7603E`: MT7603E PCIe and
MT7628/MT7688 SoC WLAN). **IMPORTANT** for those devices (common OpenWrt
APs), not CORE for every 6.6 user.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature driver (2018); this file is quiet. Bug is old (2023
stuck-beacon change), not a new-feature side effect.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific:** `CONFIG_MT7603E`,
AP/beaconing. MT7628/MT7688 SoCs are widely deployed in consumer
routers.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: FQCR0 poll timeout (5 ms) while updating beacons — the same
  stuck-beacon condition this driver already recovers from.
- Frequency: pre-TBTT (~beacon interval, typically ~100 ms) per AP vif
  (up to 4). Watchdog work every 100 ms usually resets after one such
  event, so **~1 SKB per vif per stuck incident** if recovery works;
  **recurring** if the MAC stays stuck.
- Unprivileged trigger: no (AP beacon path).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: **SKB leak**, not oops/UAF/corruption. **MEDIUM** (HIGH only if
stuck-beacon storms on a low-RAM AP). Still a real leak on a path
already considered serious enough to backport.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** stops leaking beacon frames on a known hardware-stuck
  path.
- **Risk:** very low (2 lines, error path only, clean apply).
- **Ratio:** favor backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Confirmed leak vs mac80211 SKB ownership.
- Buggy code is in this 6.6.157 tree (`8caa9dd3d1a7c9`).
- +2 lines, obviously correct, clean apply, no deps.
- Maintainer-applied.
- Same recovery path that already justified a stable backport.
- MT7603/MT76x8 used on production APs.

AGAINST:
- Error-path leak; volume per incident is small if watchdog resets.
- No crash/CVE/syzbot/user report.
- No Reviewed-by; mailing list silent.
- Not a core-kernel path.

UNRESOLVED:
- lore.kernel.org HTTP 403; stable@ search not fetched (b4/mbox used
  instead).
- Exact leak rate if reset fails repeatedly: not measured on hardware.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — ownership is documented;
   maintainer applied. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — SKB leak on stuck-
   beacon recovery.
3. Important issue? **PASS** — resource leak on a periodic AP path (not
   a one-shot init leak). Severity medium, not a panic.
4. Small and contained? **PASS** — 2 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — verified with `git apply
   --check`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
leak fix.

**Step 9.4: MAKE YOUR DECISION**

This is a two-line error-path `kfree` for a leak that exists in 6.6.157,
introduced by a stuck-beacon change already on this branch. Risk is
negligible; benefit is stopping SKB leaks on MT7603/MT76x8 APs when the
beacon DMA path wedges. That meets stable rules for this tree.

------------------------------------------------
What the commit solves for this tree
------------------------------------------------

In `mt7603_update_beacon_iter()`, `ieee80211_beacon_get()` returns an
SKB the driver must free. On FQCR0 poll timeout the function sets the
beacon watchdog and returns without queueing or freeing. That path is
the stuck-beacon recovery added in `8caa9dd3d1a7c9`, which is already
here. Each timeout leaks one beacon SKB per AP interface. The patch only
adds `dev_kfree_skb(skb)` on those two returns.

Risk vs benefit: almost no regression surface; the leak is real whenever
that recovery runs.

------------------------------------------------
Verification
------------------------------------------------

- [Phase 1] Tags: Link msgid `20260611215658.259324-1-mail@david-
  bauer.net`; SOBs David Bauer + Felix Fietkau; no Fixes/Reported-
  by/Cc:stable.
- [Phase 1] Mainline commit `965cbdbdfbd37` on `origin/master`.
- [Phase 2] Diff: +2 `dev_kfree_skb(skb)` in `mt7603_update_beacon_iter`
  poll-fail paths; success path still `mt76_tx_queue_skb`.
- [Phase 2] `include/net/mac80211.h`: “The driver is responsible for
  freeing the returned skb.”
- [Phase 2] `dev_kfree_skb` → `consume_skb` in `include/linux/skbuff.h`.
- [Phase 3] `git blame`: leaky `goto out` from `8caa9dd3d1a7c9` (stable
  form of `3176205933494`).
- [Phase 3] `git merge-base --is-ancestor 8caa9dd3d1a7c9 HEAD` → yes;
  `965cbdbdfbd37` → no; `3176205933494` → no (rewritten).
- [Phase 3] `git show 8caa9dd3d1a7c9`: moved `mt76_tx_queue_skb` after
  polls and added `goto out` without free.
- [Phase 4] `b4 dig -c 965cbdbdfbd37`: v1 only; no replies in mbox.
- [Phase 4] `b4 dig -w`: mt76 maintainers + linux-wireless on To/Cc.
- [Phase 4] lore WebFetch 403; openwall/patchew/ratatoskr match v1, no
  review replies.
- [Phase 5] Caller: `mt7603_pre_tbtt_tasklet` ← `mt7603_irq_handler`
  PRE_TBTT0.
- [Phase 5] Watchdog: `MT7603_WATCHDOG_TIME` 100 ms, timeout 10;
  `mt7603_mac_work` uses `beacon_check` with `check == NULL`.
- [Phase 6] `git describe HEAD` → `p-6.6-3-g04810563abb71`; `make
  kernelversion` → 6.6.157.
- [Phase 6] Local `beacon.c` still missing the kfrees (lines 57–66).
- [Phase 6] `git apply --check` of `965cbdbdfbd37` succeeded.
- [Phase 7] `CONFIG_MT7603E`; MAINTAINERS: Felix Fietkau.
- [Phase 8] Failure mode: SKB leak on stuck-beacon recovery; severity
  MEDIUM.
- UNVERIFIED: stable@ mailing-list archive (HTTP 403); hardware leak
  rate if reset keeps failing.

**YES**

 drivers/net/wireless/mediatek/mt76/mt7603/beacon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index 6457ee06bb5a1..62e8de6949d1a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -56,6 +56,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BCN));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
@@ -63,6 +64,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID, MT_TX_HW_QUEUE_BMC));
 	if (!mt76_poll(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY, 0, 5000)) {
 		dev->beacon_check = MT7603_WATCHDOG_TIMEOUT;
+		dev_kfree_skb(skb);
 		goto out;
 	}
 
-- 
2.53.0

