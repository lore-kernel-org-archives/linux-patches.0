Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB27489884;
	Mon, 31 Aug 2026 13:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183496; cv=none; b=MRSvucRVB/+dLPWA3v+QRNOJDdwrM0JSa3ulQpCfz34e40lTy8hchc9oUG/2cNQbBACf/RslXH1tMryObM8RVNLBIKcWCsd3HfcFp98ulqPOqcRr+ZYtary9Kr7km8lXjLx9By/mwsAqYiClP+OeehGJqF8BHEXgxEkhmAMSC1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183496; c=relaxed/simple;
	bh=Cw8eDKmRdU4BwKlSJSxqyKbtRbH+AHgTJ4HGetoKkgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DCnOE/jvSeFIS6Sir+YupPbH1BMUE0mIClVcwioem00oET/qysdEHsFEawNuD81xif/T03QQgb1gTV46Pvz5QnpiE43IeqQV44Rx13I2FvsOj/S/yqQn+148cfPrMbLi48/2V1bYX1AkZnXD2xi6s+Bfls9CWElnF/5mJUDO64U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfHqHZ9v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfHqHZ9v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F5B1F00A3D;
	Mon, 31 Aug 2026 13:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183494;
	bh=hYgzEllo7HF+eHVPpFFsRiisOnsvxr8ifuz0RVW3pTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dfHqHZ9vArzFy/C6R++CeOuPCWjCmAAsRaJGPGZKTemE3KIGYX/c1xeFjyb/Pi5zY
	 R7S5pNeXw5cvo9tcR9GgHyPbVpc1Y56Mkiy/UJx3NLL1Davrj1cvgScGMr2ZuYfZHX
	 sWxhyyfzZ013nuCz0+3RhLcb7+AJUc1bYh1CBBjPhk//xjEk9EnVWO5qvCo/I6a6Wk
	 B0QLkIk5rHz82wqPnBybIArjbP8yzKN9L7kZa2NdpPqhI+QNEb17PFwG+/4pNo0Jgv
	 p81JnwFeZThS2dmgJH4sCHrOEMXqyyP1Uq+phoV5K5gTKcQSGaOKn0fPjMb8g36nMV
	 0ygqpUIx2e75Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: fix an off-by-1 boundary check
Date: Mon, 31 Aug 2026 09:22:38 -0400
Message-ID: <20260831133314.4125787-130-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 402620cdcf4d4ee311551906dfae832b33a0cc60 ]

Before looking at the 11th byte, check the length is big enough.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.336b527e3fc6.I6fe839f4e70d673632fd7ca757e81827af87b029@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: fix an off-by-1
boundary check`

**Local tree:** `v6.18.44` (`6.18.44`, detached from
`stable/linux-6.18.y`)
**Fix commit (mainline):** `402620cdcf4d4` — not present in this tree;
`git apply --check` succeeds.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi: mld]` `[fix]` — correct an off-by-1 boundary
check before reading the 11th byte of the Extended Capabilities IE.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (author)
- `Link: https://patch.msgid.link/20260714141909.336b527e3fc6...` (patch
  submission)
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (committer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, syzbot links

**Step 1.3 — Body**
Record:
- **Bug:** Code reads `elem->data[10]` (the 11th byte,
  `WLAN_EXT_CAPA10_*`) but only requires `elem->datalen >= 10`. When
  `datalen == 10`, valid indices are `0..9`; index `10` is one byte past
  the element.
- **Symptom:** Out-of-bounds read when parsing neighbor BSS Extended
  Capabilities during DFS-channel HE OBSS narrow-BW-RU tolerance checks.
- **Root cause:** Off-by-one in the length guard.

**Step 1.4 — Hidden bug fix?**
Record: No — this is an explicit, straightforward boundary-check fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c`: 1 insertion, 1
  deletion (~1 line net)
- Function modified: `iwl_mld_check_he_obss_narrow_bw_ru_iter()`
- Scope: single-file, surgical fix

**Step 2.2 — Code flow**
Record:
- **Before:** Proceed when `elem->datalen >= 10`, then read
  `elem->data[10]`.
- **After:** Proceed only when `elem->datalen >= 11`, then read
  `elem->data[10]`.
- **Path:** BSS iteration callback during station association on
  DFS/radar channels with HE.

**Step 2.3 — Bug mechanism**
Record: **Buffer out-of-bounds read (off-by-one).** `struct element` has
`data[]` of length `datalen`; accessing `data[10]` requires `datalen >=
11`.

**Step 2.4 — Fix quality**
Record: Obviously correct, minimal, no API changes. Regression risk is
very low (only tightens a bounds check). Worst case: a borderline
10-byte IE is treated as non-tolerant, which is the safe default
(`*tolerated = false`).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Buggy lines introduced in `5d324e5159d9e` (Linus Torvalds,
2025-11-28), the merge that brought the iwlwifi MLD driver into this
tree. Present since `v6.18.0`.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag. Bug introduced with the MLD OBSS narrow-
BW-RU check code itself.

**Step 3.3 — Related changes**
Record: Mainline has a sibling fix `d77aff138c9ec` (`wifi: iwlwifi: mvm:
fix an off-by-1 boundary check`) for the same pattern in
`mvm/mac80211.c`. This commit is patch 03/15 of the `iwlwifi-fixes`
series (2026-07-14) and is standalone for the MLD path.

**Step 3.4 — Author context**
Record: Emmanuel Grumbach is a long-standing iwlwifi developer. Miri
Korenblit is the iwlwifi maintainer/committer. Series includes other
iwlwifi fixes from the same authors.

**Step 3.5 — Dependencies**
Record: None. One-line change with no structural prerequisites. Applies
cleanly to this tree (`git apply --check` passed).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: `b4 dig -c 402620cdcf4d4` → [PATCH iwlwifi-fixes 03/15]](https:/
/patch.msgid.link/20260714141909.336b527e3fc6.I6fe839f4e70d673632fd7ca75
7e81827af87b029@changeid). Part of a 15-patch `iwlwifi-fixes` series
(v1, 2026-07-14). No explicit `Cc: stable` found in the thread.

**Step 4.2 — Reviewers**
Record: `b4 dig -w` shows CC to `johannes@sipsolutions.net`, `linux-
wireless@vger.kernel.org`, Emmanuel Grumbach. Series has `Reviewed-by:
Ilan Peer <ilan.peer@intel.com>`.

**Step 4.3 — Bug report**
Record: N/A — no external bug report or syzbot link. Bug identified by
code inspection (author).

**Step 4.4 — Series context**
Record: Patch 03/15 of 15; this specific hunk is independent. The mvm
counterpart is a separate commit in the same series.

**Step 4.5 — Stable list**
Record: No stable-list discussion found for this patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `iwl_mld_check_he_obss_narrow_bw_ru_iter()`, called from
`iwl_mld_check_he_obss_narrow_bw_ru()`.

**Step 5.2 — Callers**
Record:
- `iwl_mld_check_he_obss_narrow_bw_ru()` ←
  `iwl_mld_link_set_2mhz_block()`
- `iwl_mld_link_set_2mhz_block()` ← `iwl_mld_move_sta_state_up()` (AUTH
  → ASSOC, station mode)
- `iwl_mld_move_sta_state_up()` ← `iwl_mld_sta_state()` (mac80211
  station state machine)

**Step 5.3 — Callees**
Record: `cfg80211_find_elem()`, `rcu_dereference()`,
`cfg80211_bss_iter()` — parses untrusted beacon/probe-response IEs from
neighboring BSSes.

**Step 5.4 — Reachability**
Record: Triggered during WiFi client association on DFS/radar channels
when the STA has HE capabilities. Neighbor APs (including malicious
ones) can advertise an Extended Capabilities element of exactly 10
bytes. Reachable from normal WiFi operation, not an obscure init path.

**Step 5.5 — Similar patterns**
Record: Identical bug exists in `iwlwifi/mvm/mac80211.c` and
`rtw89/mac.c` in this tree (`datalen < 10` before `data[10]`). Those are
out of scope for this commit but confirm this is a known pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code present?**
Record: **Yes.** At line 1580 in
`drivers/net/wireless/intel/iwlwifi/mld/mac80211.c`:

```1580:1582:drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
        if (!elem || elem->datalen < 10 ||
            !(elem->data[10] &
              WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
```

Iwlwifi MLD driver (`CONFIG_IWLMLD`) has been in this tree since
v6.18.0.

**Step 6.2 — Backport complications**
Record: Clean apply — `git apply --check` on commit `402620cdcf4d4`
succeeded with no conflicts.

**Step 6.3 — Related fixes already present?**
Record: No — `git log HEAD --grep="off-by-1 boundary"` returns nothing.
Fix is not in `6.18.44`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `drivers/net/wireless/intel/iwlwifi/mld` — Intel WiFi driver
(MLD/MLO-capable devices). Criticality: **IMPORTANT** (network driver,
security-relevant parsing of untrusted frames), hardware-specific to
Intel MLD devices.

**Step 7.2 — Activity**
Record: iwlwifi MLD is actively developed in 6.18.y (multiple recent mld
fixes in tree history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users of Intel MLD-capable WiFi (`CONFIG_IWLMLD`) on 6.18.x,
connecting as a station on DFS channels with HE.

**Step 8.2 — Trigger conditions**
Record: Station association on a radar/DFS channel; neighbor BSS with
Extended Capabilities IE of length exactly 10 bytes. Unprivileged remote
attacker via a rogue AP beacon can trigger the OOB read. Timing-
independent.

**Step 8.3 — Failure mode**
Record: **Out-of-bounds kernel read** of one byte beyond the IE buffer.
Severity: **MEDIUM-HIGH** — potential information leak or KASAN splat;
in production without KASAN, silent read of adjacent memory. Not a
typical crash path, but a real memory-safety bug in kernel code parsing
attacker-controlled WiFi frames.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Closes a verified OOB read on a reachable WiFi code path;
  aligns MLD code with correct bounds checking.
- **Risk:** Very low — one-character change (`10` → `11`), no behavior
  change for correctly-sized IEs.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Verified off-by-one OOB read | No syzbot/user crash report |
| Reachable from WiFi association on DFS | Affects only IWLMLD hardware
|
| Untrusted beacon data (security-relevant) | mvm/rtw89 have same bug
but need separate commits |
| 1-line, obviously correct fix | Trigger requires DFS + 10-byte IE
(somewhat niche) |
| Applies cleanly to 6.18.44 | |
| Bug present since v6.18.0 in this tree | |
| Intel maintainer-authored, reviewed | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — mathematically correct
   bounds fix; reviewed on mailing list.
2. Fixes a real bug? **PASS** — confirmed OOB read when `datalen == 10`.
3. Important issue? **PASS** — kernel memory-safety bug parsing
   untrusted wireless frames (MEDIUM-HIGH).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — code exists, patch applies
   cleanly.

**Step 9.3 — Exception category**
Record: N/A (standard bug fix, not device-ID/quirk/docs).

**Step 9.4 — Decision rationale**
This tree (`6.18.44`) ships the iwlwifi MLD driver with a confirmed off-
by-one that reads `elem->data[10]` when only 10 bytes are valid. The fix
is minimal, correct, and closes a memory-safety hole on a path reachable
during normal WiFi client association. It meets all stable-kernel
criteria for this tree.

---

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`; `make
  kernelversion` → `6.18.44`
- [Phase 1] Parsed commit message tags from user-provided diff and `git
  show 402620cdcf4d4`
- [Phase 2] Diff: 1-line change `datalen < 10` → `datalen < 11` in
  `iwl_mld_check_he_obss_narrow_bw_ru_iter()`
- [Phase 2] Verified `struct element` layout in
  `include/linux/ieee80211.h` (`datalen` + `data[]`)
- [Phase 2] Verified
  `WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT` maps to bit 7 of
  byte index 10
- [Phase 3] `git blame -L 1580,1582` → introduced in `5d324e5159d9e`
  (2025-11-28)
- [Phase 3] `git tag --contains 5d324e5159d9e | grep v6.18` → present
  since `v6.18`
- [Phase 3] `git show 402620cdcf4d4` on `master` → fix commit identified
- [Phase 3] `git merge-base --is-ancestor 402620cdcf4d4 HEAD` → exit 1
  (not in current tree)
- [Phase 4] `b4 dig -c 402620cdcf4d4` → lore URL found; patch 03/15 of
  iwlwifi-fixes series
- [Phase 4] `b4 dig -c 402620cdcf4d4 -w` → CC'd to linux-wireless,
  johannes, Intel authors
- [Phase 4] `b4 dig -c 402620cdcf4d4 -m /tmp/iwlwifi_thread.mbox` →
  `Reviewed-by: Ilan Peer`; no stable Cc
- [Phase 5] Traced call chain: `iwl_mld_sta_state` →
  `iwl_mld_move_sta_state_up` → `iwl_mld_link_set_2mhz_block` →
  `iwl_mld_check_he_obss_narrow_bw_ru` → iter callback
- [Phase 5] Confirmed DFS-only path via `IEEE80211_CHAN_RADAR` check at
  line 1598
- [Phase 6] `grep 'datalen < 10'` in mld/mac80211.c → buggy code present
  at line 1580
- [Phase 6] `git show 402620cdcf4d4 --format= | git apply --check` →
  applies cleanly
- [Phase 6] `grep 'datalen < 11'` in iwlwifi/ → no fix present yet
- [Phase 8] Noted identical pattern in `mvm/mac80211.c:3531` and
  `rtw89/mac.c:4888` (separate fixes)

**YES**The background search for the fix on mainline finished with exit
code 128, but it did return the important result before failing: the MLD
fix is commit `402620cdcf4d4`, and there’s a matching MVM fix at
`d77aff138c9ec`. The error was likely from follow-up `git log` calls
against branches that don’t exist in this repo (`main`).

That doesn’t change the earlier analysis: for this `6.18.44` tree the
bug is present, the patch applies cleanly, and the backport
recommendation remains **YES**.

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 27ae06e208402..65700b09b27d9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1583,7 +1583,7 @@ static void iwl_mld_check_he_obss_narrow_bw_ru_iter(struct wiphy *wiphy,
 	elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY, ies->data,
 				  ies->len);
 
-	if (!elem || elem->datalen < 10 ||
+	if (!elem || elem->datalen < 11 ||
 	    !(elem->data[10] &
 	      WLAN_EXT_CAPA10_OBSS_NARROW_BW_RU_TOLERANCE_SUPPORT)) {
 		*tolerated = false;
-- 
2.53.0

