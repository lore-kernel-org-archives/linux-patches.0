Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595C44A0927;
	Mon, 31 Aug 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183688; cv=none; b=CTgNN/tFsNHdBMix7re6NWXWLH/3hMOBDyDThsie7CV1GVgUyyD8t+h29vfKJeG6z4QvA+TLiThwdpYgajKC2p5IKyAH6XBEQM6Gv/Z4ZraJV5UPRKGU/jYDzXETdNeENraG2IDnCLy8WrrrLNU6zBTbUQUNqNOL4LhKVMhiVcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183688; c=relaxed/simple;
	bh=98dAFk8oW6aPfWaMsLFH6NmvYeEs02fg8AF/i05tdio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2mPiaUserGYmbiXHGipo78QQ0B/9MWk5B/bcqlk9lzYxHutXw1+PD1bifeRB98+OlnzkpEgNDxuvcDTS+BaKdsHTAFgi0g30xZC83Ms95g/3yBe4Jm4Ed2MplWUt0pLPSoGsrZ1HSU35sYrrdNlVeScLrWXqohinlWue9OPXww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBnUVA3S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBnUVA3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0891F00A3D;
	Mon, 31 Aug 2026 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183686;
	bh=Hx2z5k1Uq4wfvI+d1q0h0X0hPB81KDLNqDGz4Wg5BYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBnUVA3SDxOvLt/+PgKcu9CrL9BV+kpZ3VtfnOR45ZA5qXauPjIKlEU7vjcldjSnd
	 /EC3AHfQ1gTNP8DjzAIz8dfqDkGosvUTmpRWQnHaciQ51Npo7bZRtezLXlv4XAE3VK
	 xxlQZeRYqwjUIUCaj/AfgrMj9YUhoCREWGtQAguKOq7YCDxT0LUaI/5WWtjTrq7Ekj
	 C4tFcdsQQQVLIqU08xRRrk6AAXF1I1wnzahvYvfn4cwhBfDdkuQG78qrELRQyDvOyF
	 7oSialsfqzbdcQEbVgqrtW1CgE+Pdp9HiRUAlTxIM3UeOUau+iLq6YavFmnz3l8ICC
	 n3xEHgS6s4M8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: mac80211: use chandef in ieee80211_get_sta_bw()
Date: Mon, 31 Aug 2026 09:24:32 -0400
Message-ID: <20260831133314.4125787-244-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e36b3322a41b7de0168ad6a37bdd1219cfe35077 ]

When getting the bandwidth the station uses in order to
calculate the channel context's min_def, pass the channel
for the link to _ieee80211_sta_cap_rx_bw() instead of using
ieee80211_sta_cap_rx_bw(), which looks it up.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.d2bdf106a39f.I6ae07289a272dd9e27118f9fa324a4865f994003@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: use chandef in
ieee80211_get_sta_bw()`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211]` `[use]` — When computing per-station
bandwidth for channel-context `min_def`, pass the link's channel
definition explicitly instead of looking it up indirectly.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Miriam Rachel Korenblit
  \<miriam.rachel.korenblit@intel.com\>
- **Link:** https://patch.msgid.link/20260415144514.d2bdf106a39f.I6ae072
  89a272dd9e27118f9fa324a4865f994003@changeid
- **Signed-off-by:** Johannes Berg \<johannes.berg@intel.com\>
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Part of **[PATCH 4/20]** in series "wifi: mac80211: clean up and fix
  per-STA BW handling"
- Notable pattern: subsystem maintainer-authored, Intel reviewer; no
  syzbot/fuzzer report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `ieee80211_get_sta_bw()` calls `ieee80211_sta_cap_rx_bw()`,
  which internally looks up the band from the STA's own
  `sdata->vif.link_conf[]` when no `chandef` is passed.
- **Symptom:** Wrong band used when computing STA RX bandwidth
  capability for channel-context `min_def` recalculation.
- **Root cause:** The function should use the channel of the **link
  being evaluated** (`link->conf->chanreq.oper`), not whatever channel
  the STA's `sdata` happens to reference.
- No explicit crash/stack trace in the commit message; failure mode is
  incorrect bandwidth derivation.

### Step 1.4: Hidden bug fix?
**Record:** **Yes.** Although the subject doesn't say "fix", this
corrects a real logic error. When `ieee80211_get_max_required_bw()`
includes stations from sibling interfaces in the same BSS (notably
**AP_VLAN** clients), `ieee80211_sta_cap_rx_bw()` with `chandef == NULL`
looks up band from the VLAN `sdata`'s `link_conf`, not the parent AP
link's channel. That parallels the already-backported AP_VLAN crash fix
(`5a86d4e920d97`) but in the `ieee80211_get_sta_bw()` →
`ieee80211_recalc_chanctx_min_def()` path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/mac80211/chan.c` only (+5 / -5 lines)
- **Functions modified:** `ieee80211_get_sta_bw()`,
  `ieee80211_get_max_required_bw()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (`ieee80211_get_sta_bw`):** Before: takes `link_id`, calls
  `ieee80211_sta_cap_rx_bw(link_sta)` (NULL chandef → internal RCU band
  lookup from `link_sta->sta->sdata`). After: takes `struct
  ieee80211_link_data *link`, calls `_ieee80211_sta_cap_rx_bw(link_sta,
  &link->conf->chanreq.oper)` — uses the evaluating link's operating
  channel.
- **Hunk 2 (`ieee80211_get_max_required_bw`):** Before: passes `link_id`
  to `ieee80211_get_sta_bw()`. After: passes full `link` pointer.
- **Path affected:** Normal AP/station channel-context `min_def`
  recalculation (hot path, not error-only).

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix; potential NULL pointer
  dereference on AP_VLAN path
- **Mechanism:** `ieee80211_get_max_required_bw()` iterates all STAs on
  the same BSS:

```298:303:net/mac80211/chan.c
        list_for_each_entry(sta, &sdata->local->sta_list, list) {
                if (sdata != sta->sdata &&
                    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
                        continue;

                max_bw = max(max_bw, ieee80211_get_sta_bw(sta,
link_id));
```

For AP_VLAN clients, `sta->sdata` is the VLAN interface.
`ieee80211_sta_cap_rx_bw()` with NULL chandef enters
`__ieee80211_sta_cap_rx_bw()` and does:

```368:376:net/mac80211/vht.c
                if (chandef) {
                        band = chandef->chan->band;
                } else {
                        struct ieee80211_bss_conf *link_conf;

                        rcu_read_lock();
                        link_conf =
rcu_dereference(sdata->vif.link_conf[link_id]);
                        band = link_conf->chanreq.oper.chan->band;
                        rcu_read_unlock();
```

Here `sdata` is the VLAN `sdata`, whose link never participates in
chanctx reservations (documented in `5a86d4e920d97`). The fix passes the
parent AP link's valid `chanreq.oper` instead.

### Step 2.4: Fix quality
**Record:** Obviously correct — the caller already has the correct link
context and other code in the same file (e.g.
`ieee80211_chan_bw_change()`) already passes explicit chandefs. Minimal
regression risk; no new locks or APIs.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Buggy lines in `ieee80211_get_sta_bw()` present in current
tree at lines 238–303. Git blame points to `19eef1d98eeda` (merge
artifact in this stable tree's truncated history). The function and
`_ieee80211_sta_cap_rx_bw()` API both exist in 6.18.43.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related file history
**Record:**
- `5a86d4e920d97` — "mac80211: fix crash in ieee80211_chan_bw_change for
  AP_VLAN stations" — already in this tree; fixes same class of
  AP_VLAN/wrong-sdata problem in a different function
- This commit is patch 4/20; patches 1–3 change NAN/HT handling in other
  files; patch 5 fixes TDLS similarly; patches 19–20 are larger
  refactors — **patch 4 is standalone** for the current code layout

### Step 3.4: Author context
**Record:** Johannes Berg is mac80211/cfg80211 maintainer. Reviewed by
Intel mac80211 developer Miriam Rachel Korenblit.

### Step 3.5: Dependencies
**Record:** No prerequisites. `_ieee80211_sta_cap_rx_bw(struct
link_sta_info *, struct cfg80211_chan_def *)` is declared in
`ieee80211_i.h` and implemented in `vht.c` in this tree. Patch applies
cleanly to current `chan.c`.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Local mbox `20260415_johannes_wifi_mac80211_clean_up_and_fix
_per_sta_bw_handling.mbx` contains patch 4/20. Cover letter references
earlier RFC at lore.kernel.org (blocked by bot protection). `b4 dig -c`
could not run without upstream commit hash. Link URL also blocked. No
stable nomination found in mbox (no "Cc: stable" anywhere in series).

### Step 4.2: Reviewers
**Record:** Reviewed-by from Miriam Rachel Korenblit (Intel). Series
author is subsystem maintainer.

### Step 4.3: Bug reports
**Record:** No external bug report, syzbot, or stack trace linked to
this specific patch. Related AP_VLAN NULL-deref was reported/fixed
separately in `5a86d4e920d97`.

### Step 4.4: Series context
**Record:** Patch 4/20 is independent of patches 1–3 (NAN/HT changes).
Patch 5 is a similar chandef fix for TDLS. Patches 19–20 rename/refactor
functions — not required for this fix in 6.18.43.

### Step 4.5: Stable list history
**Record:** Not searched successfully (lore blocked). No stable
discussion found in local mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee80211_get_sta_bw()`, `ieee80211_get_max_required_bw()`,
`_ieee80211_sta_cap_rx_bw()`, `__ieee80211_sta_cap_rx_bw()`

### Step 5.2: Callers
**Record:** `ieee80211_get_max_required_bw()` called from
`ieee80211_get_chanctx_max_required_bw()` for `NL80211_IFTYPE_AP`,
`NL80211_IFTYPE_AP_VLAN`, and associated `NL80211_IFTYPE_STATION`. That
feeds `_ieee80211_recalc_chanctx_min_def()` →
`ieee80211_recalc_chanctx_min_def()`, which is invoked from many paths
(client connect/disconnect, HE operations, channel changes in `chan.c`,
`he.c`, `util.c`).

### Step 5.3: Callees
**Record:** `_ieee80211_sta_cap_rx_bw()` uses HE/EHT/VHT capability
parsing band-specifically; wrong band → wrong bandwidth enum returned.

### Step 5.4: Reachability
**Record:** Triggered during normal AP operation with VLAN clients
(4-address/WDS) or any multi-interface BSS sharing. Common operational
path, not obscure init-only code. Reachable without special privileges
beyond having WiFi AP+VLAN configured.

### Step 5.5: Similar patterns
**Record:** Patch 5 in same series applies identical chandef-passing
pattern to TDLS. `ieee80211_chan_bw_change()` already uses explicit
chandef and `get_bss_sdata()` after the AP_VLAN crash fix — this patch
closes the analogous gap in `ieee80211_get_sta_bw()`.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.43)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current tree still has `width =
ieee80211_sta_cap_rx_bw(link_sta);` at line 257 of `chan.c`. Fix not yet
applied.

### Step 6.2: Backport complications
**Record:** **Clean apply expected** — 5-line change, no structural
conflicts. `_ieee80211_sta_cap_rx_bw()` API exists. No dependency on
later series refactors.

### Step 6.3: Related fixes already present?
**Record:** `5a86d4e920d97` (AP_VLAN crash in
`ieee80211_chan_bw_change`) is present but does **not** fix this code
path. This commit is complementary, not duplicate.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/mac80211` — **IMPORTANT** (WiFi stack; affects
connectivity for AP/station users)

### Step 7.2: Activity
**Record:** Actively maintained; recent stable backport of related
AP_VLAN fix confirms this area is live in 6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of mac80211 AP mode with **AP_VLAN** (multi-
BSSID/VLAN) or any setup where `ieee80211_get_max_required_bw()`
evaluates stations whose `sta->sdata` differs from the link's `sdata`.
Also affects associated station mode path that includes TDLS/BSS-shared
peers.

### Step 8.2: Trigger conditions
**Record:** Channel-context `min_def` recalculation while VLAN-
associated stations exist on the BSS. Common during client association,
bandwidth changes, and HE/EHT operations. Not timing-dependent race.

### Step 8.3: Failure mode severity
**Record:**
- **Wrong bandwidth for `min_def`:** incorrect channel-width degradation
  decisions → connectivity/performance issues (**MEDIUM**)
- **Potential NULL deref** on AP_VLAN `link_conf->chanreq.oper.chan`
  (same class as fixed `5a86d4e920d97`) → kernel oops (**HIGH** if
  triggered; analogous path already proven crash-worthy)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for AP+VLAN deployments; fixes correctness bug in
  common chanctx path
- **Risk:** VERY LOW — 5-line change passing already-available chandef;
  matches established pattern in same file
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: wrong band lookup when STA `sdata` ≠ link `sdata` (AP_VLAN
  case)
- Complements already-backported AP_VLAN crash fix in same subsystem
- Affects common `ieee80211_recalc_chanctx_min_def()` path
- Small, surgical, maintainer-reviewed
- API and buggy code both exist in 6.18.43
- Clean apply, no series dependencies

**AGAINST backport:**
- No explicit user crash report for this exact path
- Part of larger 20-patch series (but this patch is self-contained)
- No Cc: stable tag (expected for manual review)

**UNRESOLVED:**
- Could not fetch lore discussion (bot protection)
- Exact NULL-deref on this specific path not confirmed with a reported
  crash (inferred from parallel AP_VLAN fix and code analysis)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; Reviewed-by
   present; no Tested-by
2. Fixes real bug? **PASS** — wrong chandef/band for per-STA BW in
   chanctx min_def
3. Important issue? **PASS** — MEDIUM-HIGH (connectivity correctness;
   potential oops on AP_VLAN)
4. Small and contained? **PASS** — 5 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified present and applicable

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Problem summary for stable users

When mac80211 recalculates the minimum channel width for a channel
context, it sums per-station bandwidth requirements. For stations on
AP_VLAN interfaces (same BSS, different `sdata`), the old code looked up
the RF band from the VLAN interface's link configuration instead of the
parent AP link's operating channel. That yields incorrect HE/EHT/VHT
bandwidth capability parsing and wrong `min_def` values. This is the
same class of AP_VLAN sdata confusion that already caused a NULL-pointer
crash in `ieee80211_chan_bw_change()` (fixed in this tree as
`5a86d4e920d97`). This patch closes the gap in the
`ieee80211_get_sta_bw()` path with a minimal, obviously-correct change.

---

## Verification

- [Phase 1] Parsed subject, tags; identified as patch 4/20; Reviewed-by
  Miriam Rachel Korenblit; no Fixes:/Reported-by/Cc: stable
- [Phase 1] Read commit body from user query and local mbox
- [Phase 2] Diff analysis: 5 lines in `chan.c`;
  `ieee80211_sta_cap_rx_bw()` → `_ieee80211_sta_cap_rx_bw(...,
  &link->conf->chanreq.oper)`
- [Phase 3] `git describe HEAD`: v6.18.43 / 6.18.43
- [Phase 3] `git blame -L 238,303 net/mac80211/chan.c`: buggy code at
  lines 257, 303
- [Phase 3] `git show 5a86d4e920d97`: related AP_VLAN crash fix already
  in tree
- [Phase 3] Verified `_ieee80211_sta_cap_rx_bw()` exists in
  `ieee80211_i.h` and `vht.c`
- [Phase 4] Read local mbox `20260415_johannes_wifi_mac80211_clean_up_an
  d_fix_per_sta_bw_handling.mbx` patch 4/20 and cover letter
- [Phase 4] `b4 dig -c HEAD`: failed (no commit hash in detached stable
  tree)
- [Phase 4] lore.kernel.org / patch.msgid.link: blocked by bot
  protection — UNVERIFIED for thread content
- [Phase 4] No Cc: stable in mbox series — verified via grep
- [Phase 5] `grep ieee80211_get_max_required_bw`: called from
  `ieee80211_get_chanctx_max_required_bw()` line 352
- [Phase 5] `grep ieee80211_recalc_chanctx_min_def`: many callers in
  `chan.c`, `he.c`, `util.c`
- [Phase 5] Read `__ieee80211_sta_cap_rx_bw()` NULL-chandef path in
  `vht.c` lines 368–376
- [Phase 5] Read `get_bss_sdata()` AP_VLAN handling in `driver-ops.h`
  lines 25–29
- [Phase 6] Confirmed buggy `ieee80211_sta_cap_rx_bw(link_sta)` at
  `chan.c:257` in 6.18.43
- [Phase 6] Confirmed fix not yet applied; API available for clean
  backport
- [Phase 8] AP_VLAN NULL-deref on analogous path: documented in
  `5a86d4e920d97`; this path inferred — UNVERIFIED with separate crash
  report

**YES**

 net/mac80211/chan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index a6895b40d4322..8403b5248a953 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -235,11 +235,12 @@ ieee80211_find_reservation_chanctx(struct ieee80211_local *local,
 	return NULL;
 }
 
-static enum nl80211_chan_width ieee80211_get_sta_bw(struct sta_info *sta,
-						    unsigned int link_id)
+static enum nl80211_chan_width
+ieee80211_get_sta_bw(struct sta_info *sta, struct ieee80211_link_data *link)
 {
 	enum ieee80211_sta_rx_bandwidth width;
 	struct link_sta_info *link_sta;
+	int link_id = link->link_id;
 
 	link_sta = wiphy_dereference(sta->local->hw.wiphy, sta->link[link_id]);
 
@@ -254,7 +255,7 @@ static enum nl80211_chan_width ieee80211_get_sta_bw(struct sta_info *sta,
 	 * capabilities here. Calling it RX bandwidth capability is a bit
 	 * wrong though, since capabilities are in fact symmetric.
 	 */
-	width = ieee80211_sta_cap_rx_bw(link_sta);
+	width = _ieee80211_sta_cap_rx_bw(link_sta, &link->conf->chanreq.oper);
 
 	switch (width) {
 	case IEEE80211_STA_RX_BW_20:
@@ -289,7 +290,6 @@ static enum nl80211_chan_width
 ieee80211_get_max_required_bw(struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
-	unsigned int link_id = link->link_id;
 	enum nl80211_chan_width max_bw = NL80211_CHAN_WIDTH_20_NOHT;
 	struct sta_info *sta;
 
@@ -300,7 +300,7 @@ ieee80211_get_max_required_bw(struct ieee80211_link_data *link)
 		    !(sta->sdata->bss && sta->sdata->bss == sdata->bss))
 			continue;
 
-		max_bw = max(max_bw, ieee80211_get_sta_bw(sta, link_id));
+		max_bw = max(max_bw, ieee80211_get_sta_bw(sta, link));
 	}
 
 	return max_bw;
-- 
2.53.0

