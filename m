Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B779F4FDA60;
	Mon, 19 Oct 2026 13:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418357; cv=none; b=L1uPRlTrbbSQIxwAmFNcd5JgKDvggj4ETh+PiHWgNTfBewCIx40VIf/KhcvM4B8gzh5Ua7aTF6S9EDNcnAIuI++tGkVWLiwt4cqyVuBOl2MS/e7FeJagsa86ouO9MLevUXakneKTQ28XKjINYTfEWAlUj1hDuGNzU6Wc2qlZfGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418357; c=relaxed/simple;
	bh=XL+i2kXPboZpyJglz5lKPnUnV1uUdkteTksLLLT07SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qfrZsbwOK77cNpIXpUVxvrWG2Q1WlEQXDl+7XfVVRBF9G0vsO823m4Mi62wFYsjBkFdqpnQDQL1873ofTgX8gaN2eN6YAvybnNebZfoG5pk7+qbGJJr3+wdRORb2gulAm1lv+IWkiqBM05S+mW2Qxh7CAkljDYipv8WqfAyoX+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/Vjolir; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/Vjolir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562321F000CA;
	Mon, 19 Oct 2026 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418354;
	bh=i2Q7aAjTJ/e0eAWK93juXRdlPT8LvAMuRr0Mso6+cQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g/VjolirWdupi0rrC1teXUWGKnr7gs/hhyxbLvNmbCPI9Unw/g/I2qrmmwM94vKE6
	 TblB6qIcjRYjUgnH+DeI1SJHHJlV3coEMtpghG3qlUaO2DQHG9AXz+ZizQX0/jnKRl
	 h4TalmmfnfvcyBpWDpWAzJ0tNQGQQIcNc/gI93/ZZn9SZyQzsF6jdTFamUOwhoWL2j
	 aMpoeB0dXC9wXmF5giLD8PesFbzwqWdPExPZuU6vdvuzkdgTBx5tfSPIlL3Nq95N0v
	 YOk+YXKIIo/5vyHTDZxVOkJ1krJ/5PDA+cryV123SlRgLxcrUeWQAPEy68XmSymujE
	 6tLCfpW6gk80g==
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
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: mt76: mt7915: configure noise floor reporting on reset
Date: Mon, 19 Oct 2026 09:47:59 -0400
Message-ID: <20261019135441.1420968-188-sashal@kernel.org>
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

[ Upstream commit a92cd5dd792a63a5d8a72142835382d4edbe9933 ]

When performing a full system recovery of the MCU on a dual-phy
platform, band 0 (usually 2.4GHz) stops reading correct noise floor
data.

This is due to noise floor reporting only being configured correctly
for the second device PHY.

Configure the respective registers correctly after restarting the MCU
firmware to fix reported noise-floor values.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260516144944.2574053-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.6.157** (`pending-6.6`). The buggy dual-PHY
restart path is present here, and this commit should be backported.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[wifi: mt76: mt7915]** **[configure]** configure noise floor
reporting after MCU reset on dual-PHY platforms. “Configure” here is
restoring register state that recovery currently skips, not a new
feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: David Bauer &lt;mail@david-bauer.net&gt; (author)
- Link: https://patch.msgid.link/20260516144944.2574053-1-mail@david-
  bauer.net
- Signed-off-by: Felix Fietkau &lt;nbd@nbd.name&gt; (mt76 maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable (absence is expected)
- Ignored: any pipeline “Upstream commit” / Sasha Levin SOB markers

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** After full MCU recovery on a dual-PHY (DBDC) device, band 0
  (usually 2.4 GHz) stops reporting correct noise floor.
- **Symptom:** Wrong NF / survey noise on the primary PHY; the second
  PHY is configured correctly.
- **Root cause (author):** NF enable is only applied for the second PHY
  after firmware restart.
- **Version info:** none in the message. The restart path has been in
  this tree since before v6.6.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised cleanup. It is an explicit hardware-init fix. The
mechanism (clear `MT76_STATE_RUNNING` before `mt7915_run()`) also re-
runs the primary PHY’s PM/MAC init that the same `if (!running)` guard
skips, not only NF.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/mediatek/mt76/mt7915/mac.c` only
- Scope: ~+6/−2 in `mt7915_mac_restart()` (surgical, single function)
- Adds `bool run_main, run_ext`
- Replaces `test_bit(MT76_STATE_RUNNING)` with `test_and_clear_bit`,
  then uses those saved flags to decide whether to call `mt7915_run()`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** After firmware reload, `mt7915_run()` is called while both
  PHYs still have `MT76_STATE_RUNNING`. `mt7915_dev_running()` is
  therefore true.
- In this tree, `mt7915_run()` only programs primary-PHY PM/MAC/NF when
  `!running`:

```32:58:drivers/net/wireless/mediatek/mt76/mt7915/main.c
        if (!running) {
                ret = mt76_connac_mcu_set_pm(&dev->mt76,
                                             dev->phy.mt76->band_idx,
0);
                ...
                mt7915_mac_enable_nf(dev, dev->phy.mt76->band_idx);
        }

        if (phy != &dev->phy) {
                ...
                mt7915_mac_enable_nf(dev, phy->mt76->band_idx);
        }
```

- Primary `mt7915_run()` therefore skips band-0 NF. Ext `mt7915_run()`
  still hits `phy != &dev->phy` and enables band-1 NF. That matches the
  commit message.
- `ieee80211_restart_hw()` after full reset does not repair this:
  starting the main PHY while the ext PHY still has `MT76_STATE_RUNNING`
  keeps `running == true`, so band 0 is skipped again; starting the ext
  PHY then enables only the ext PHY’s NF.
- **After:** bits are cleared first, so the first `mt7915_run()` sees
  `running == false` and programs band 0. Saved flags still prevent
  starting a PHY that was never up.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / hardware-init.** After MCU reload, IPI/NF registers
(`mt7915_mac_enable_nf`: `MT_WF_PHY_RXTD12_*` and
`MT_WF_PHY_RX_CTRL1_IPI_EN`) are not programmed for band 0.
`mt7915_mac_init_band()` does not enable NF; only `mt7915_run()` does.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct. Same approach the mt76 maintainer asked for
on-list. Minimal. Mutex is already held in `mt7915_mac_full_reset()`;
`MT76_RESET` is already set. Risk is low: if `mt7915_run()` fails, the
RUNNING bits stay clear, but full reset retries and then calls
`ieee80211_restart_hw()`, which stop/start and restores them.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The `test_bit` + `mt7915_run()` sequence was introduced in
`8a55712d124fd8` (“wifi: mt76: mt7915: enable full system reset
support”, Bo Jiao / Ryder Lee, 2022). `git describe --contains` →
`v6.2-rc1~...`. Present in this 6.6 tree (`git merge-base --is-ancestor
8a55712d124fd8 HEAD` succeeded).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. The introducing commit is in this
tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related reset work already in this tree:
- `c71d2db21f153` improve hardware restart reliability
- `1e474cbe5db60` fix omac index assignment after hardware reset
- `72eabd4c1986b` firmware restart on devices with a second PCIe link
This patch is standalone; it does not depend on those.
`test_and_clear_bit(MT76_STATE_RUNNING)` is **not** in this tree (`git
grep` found no matches).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: David Bauer is an OpenWrt/wireless contributor; in this tree he
already has `b6c39aaa85c4e` (mt7915 MCU re-init). Felix Fietkau (mt76
maintainer) signed off and designed the committed approach.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: No functional prerequisites. Surrounding `mt7915_init_txpower()`
signature and `napi_enable` placement differ from later mainline; those
are context only. The `run_main`/`run_ext` change applies with a small
context tweak.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record: `b4 dig -c` was not usable (commit SHA not in this checkout’s
master). `b4 mbox` on msgid `20260516144944.2574053-1-mail@david-
bauer.net` saved a 4-message thread.
- v1 (16 May 2026): 4-line change in `mt7915_run()`: `if (!running ||
  (reset && phy == &dev->phy))`
- Felix (27 May): asked to clear `MT76_STATE_RUNNING` in
  `mt7915_mac_restart` instead
- David: explained the per-PHY RUNNING guard (don’t start a PHY that was
  never up)
- Felix (1 Jun): proposed exactly the committed `test_and_clear_bit`
  pattern
No NAK. No reviewer `Cc: stable`. Committed diff is the maintainer
rewrite, still linked to the v1 msgid.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients included Felix Fietkau, Lorenzo Bianconi, Ryder Lee,
Shayne Chen, Sean Wang, linux-wireless, linux-mediatek. Felix both
reviewed and applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla. Author describes a real dual-PHY MCU
recovery failure. That is a field observation, not a theoretical report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Single patch, not N/M. v1 vs committed is a maintainer rewrite
of the same fix, not a multi-patch series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list hit for this subject. No recorded reason
to keep it out of stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: Modified: `mt7915_mac_restart()`. Behavior depends on
`mt7915_run()`, `mt7915_dev_running()`, `mt7915_mac_enable_nf()`.

**Step 5.2: TRACE CALLERS**
Record:
- `mt7915_mac_restart()` ← `mt7915_mac_full_reset()` (only caller in
  this tree)
- `mt7915_mac_full_reset()` ← `mt7915_mac_reset_work()` when
  `dev->recovery.restart`
- `recovery.restart` set in `mt7915_reset()` on WA/WM watchdog
  (`MT_MCU_CMD_WDT_MASK`), which logs “firmware crash, attempting
  recovery”
- `mt7915_run()` also from `mt7915_start()` (normal iface start); this
  patch does not change that path

**Step 5.3: TRACE CALLEES**
Record: After firmware load: `mt7915_mcu_init_firmware`,
`mt7915_mcu_set_eeprom`, `mt7915_mac_init`, txpower/txbf, then
`mt7915_run()` (PM, `mt7915_mcu_set_mac`, `mt7915_mac_enable_nf`,
thermal, RTS, SKU, RX path).

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Triggered by firmware watchdog recovery on `CONFIG_MT7915E`
dual-PHY (mt7915/mt7916/mt798x DBDC), common on APs/routers. Not a
generic syscall crash path. Userspace sees bad survey noise
(`mt76_get_survey` → `SURVEY_INFO_NOISE_DBM`) and ACS can use it.
Debugfs can also force full reset (`b662b71`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: No `test_and_clear_bit(MT76_STATE_RUNNING)` in this tree’s mt76.
Sibling chips (mt7615/mt7996) have similar NF helpers; this fix is
mt7915-restart-specific.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `mt7915_mac_restart()` at
`drivers/net/wireless/mediatek/mt76/mt7915/mac.c:1397-1407` still uses
`test_bit` without clearing. Introduced v6.2-era (`8a55712d124fd8`),
present since this 6.6 branch.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor context.** Mainline hunk context uses
`mt7915_init_txpower(&dev->phy)` / `mt7915_init_txpower(phy2)`; this
tree still has `mt7915_init_txpower(dev, &dev->mphy.sband_* )`.
`napi_enable` vs `local_bh_disable` order in the `out:` path also
differs. The RUNNING-bit change itself matches this tree. Easy manual
backport; not a rewrite.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Reset reliability/omac-after-reset fixes are here. This NF re-
init after MCU recovery is not.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **wifi / mt76 mt7915**
(`drivers/net/wireless/mediatek/mt76/mt7915/`). **IMPORTANT** for users
of these radios (filogic/mt7915 DBDC APs), not core mm/net. Not staging.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver, still getting reset-path fixes in this 6.6 tree.
Not a newly added subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific, dual-PHY `CONFIG_MT7915E` after full MCU
recovery. Widely used on embedded/AP hardware.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Firmware WA/WM watchdog → full recovery. Unprivileged users
cannot trigger it directly. Timing is the recovery path, not a race.
Debugfs reset can also hit it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Wrong band-0 noise floor / survey after recovery; ACS can pick a
worse channel. Not an oops, deadlock, or corruption. Connectivity was
not reported broken; `mac_init` still runs, so MAC datapath likely
survives. **Severity: MEDIUM.**

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Medium. Restores intended PHY register state on a
  recovery path this tree already treats as backport-worthy.
- **Risk:** Low. ~8 lines, one function, maintainer-specified, under
  existing reset mutex.
- **Ratio:** Favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real dual-PHY bug after MCU full recovery; primary PHY NF registers
  never reprogrammed
- Code and introducing commit are in 6.6.157
- Small, obviously correct, maintainer-directed
- Same `!running` skip also omits band-0 `set_pm`/`set_mac` on that path
- This tree already backported other mt7915 reset corrections
- Dual-PHY mt7915/mt798x is common production AP hardware

AGAINST:
- Not a crash, UAF, deadlock, or security issue
- Trigger is firmware watchdog recovery, not a hot path
- User-visible effect is mainly survey/ACS noise, not a reported outage
- Apply needs a trivial context adjustment

UNRESOLVED:
- Upstream SHA is not on this checkout’s `master`, so `b4 dig -c <sha>`
  was not run (thread retrieved via msgid instead)
- No independent confirmation that band-0 MAC/PM skip causes traffic
  loss (author only reported NF)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — logic matches
   `mt7915_run()`; maintainer specified this form
2. Fixes a real bug that affects users? **PASS** — wrong NF after
   recovery on dual-PHY
3. Important issue? **PASS** (medium) — recovery leaves hardware
   misconfigured; not a panic, but it is a real functional failure of
   SER
4. Small and contained? **PASS** — one function, few lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; minor
   context only

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a new device ID/API. Closest class is hardware re-init after
reset (quirk-like). Qualifies on technical merit, not only via an
exception.

**Step 9.4: MAKE YOUR DECISION**
Backport. The 6.6 tree has the bug, the fix is surgical, and leaving MCU
recovery with band 0 NF unprogrammed is a real driver bug on hardware
this series already ships.

Verification:
- [Phase 1] Parsed tags: author David Bauer, Link to msgid, SOB Felix
  Fietkau; no Fixes/Cc stable/Reported-by
- [Phase 1] Body: dual-PHY MCU recovery → band 0 NF wrong because only
  PHY1 is configured
- [Phase 2] Diff: `mt7915_mac_restart()` saves/clears RUNNING then calls
  `mt7915_run()`
- [Phase 2] Local `mt7915_run()`: primary NF only if
  `!mt7915_dev_running()`; ext NF if `phy != &dev->phy`
- [Phase 2] `mt7915_mac_init_band()` does not set IPI/NF; only
  `mt7915_mac_enable_nf()` does
- [Phase 3] `git blame` `mac.c:1397-1407` → `8a55712d124fd8` (v6.2-rc1);
  ancestor of HEAD
- [Phase 3] `git grep test_and_clear_bit(MT76_STATE_RUNNING)` → no hits
  in this tree
- [Phase 3] Related reset fixes already here (`c71d2db21f153`,
  `1e474cbe5db60`); this NF fix is not
- [Phase 4] `b4 mbox` msgid → 4-message thread; Felix requested the
  committed approach; no NAK
- [Phase 4] lore.kernel.org WebFetch returned 403; used b4 mbox +
  openwall/ratatoskr instead
- [Phase 4] No meaningful stable-list discussion found
- [Phase 5] Call chain: WDT → `mt7915_reset()` → dump_work →
  `mt7915_mac_reset_work()` → `mt7915_mac_full_reset()` →
  `mt7915_mac_restart()`
- [Phase 5] Survey path: `mt7915_update_channel()` → `state->noise` →
  `mt76_get_survey()`
- [Phase 6] `git describe HEAD` / `make kernelversion` → p-6.6-3 /
  **6.6.157**
- [Phase 6] Local `mt7915_init_txpower()` signature differs from patch
  context; RUNNING change still maps 1:1
- [Phase 8] Failure mode: incorrect band-0 noise after firmware crash
  recovery; severity MEDIUM
- UNVERIFIED: exact upstream SHA (not on this `master`); whether band-0
  `set_mac` skip also breaks traffic (not claimed by author)

The patch is a small, maintainer-reviewed correction of MCU recovery on
dual-PHY mt7915, and the buggy code is in this 6.6 tree.

**YES**

 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index dda4e7d179536..55d2553addb13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1292,6 +1292,7 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	struct mt7915_phy *phy2;
 	struct mt76_phy *ext_phy;
 	struct mt76_dev *mdev = &dev->mt76;
+	bool run_main, run_ext;
 	int i, ret;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
@@ -1387,13 +1388,17 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	mt7915_init_txpower(phy2);
 	ret = mt7915_txbf_init(dev);
 
-	if (test_bit(MT76_STATE_RUNNING, &dev->mphy.state)) {
+	run_main = test_and_clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
+	run_ext = ext_phy &&
+		  test_and_clear_bit(MT76_STATE_RUNNING, &ext_phy->state);
+
+	if (run_main) {
 		ret = mt7915_run(dev->mphy.hw);
 		if (ret)
 			goto out;
 	}
 
-	if (ext_phy && test_bit(MT76_STATE_RUNNING, &ext_phy->state)) {
+	if (run_ext) {
 		ret = mt7915_run(ext_phy->hw);
 		if (ret)
 			goto out;
-- 
2.53.0

