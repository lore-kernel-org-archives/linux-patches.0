Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F565463B85;
	Mon, 31 Aug 2026 13:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184068; cv=none; b=RJCZStvrxnc2jMl772I4YNP1dTnZ7zCJcsG8rpg5qY2RWigsKYOkS3CooJk7TxCXxfLMidc/065UZQ52L5Z7RCnjLONKbJ7aGpaGC2DvhJgxyc8tXYj9SQqanQfZ1nY+YWNwIyaO+ACVJaJe2zRInc9M0o/lpmE3ujX5alIRM3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184068; c=relaxed/simple;
	bh=T+KJEYiXhwV86mH4htXeP5xfNjt5uRzB8leGiTJm0ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JUnPbtIDZ37nXudJPvptChz7EDEkUwHG34B8dzWDg/q9OZ3sIFKhvaV9WlLEfHssFxVURMqIABmJ+w+IvqBMbTLVqI8rsjbxrrlxQOlfWFEmnG6oDKTzM0KKBcmNYjTgcXFY0M1yugptiEyqxvHRG1chc+ApZ/X7N1tCQpeuPqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GZPKFqs5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GZPKFqs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063011F00A3F;
	Mon, 31 Aug 2026 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184065;
	bh=2BaV6aSCBfWzbisaA6ISQZlpEcse2nanP+Vnl+b0oeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZPKFqs5Sw1P5ijK/Z+czEzKQLsaTJK+KWD8T5EtL24Y1vTjG5Eicfnpj6XQvCJFi
	 8p6qNklI2sbf6fdAsv57k6NmakUZ2WdNi3vGnG1+lW2SkTuX53QLZ5TAqNzIjxNE2A
	 NEf55csJbBFFzaPcpizSpKNGxZnYi9iodF07g42JQ/cH6yO4UHfsHxK8lNmdZnJYj9
	 tkmiG4XXEM4Qawz1t9vBYFnzUFCWBisjEqECY7RJ7YHfrk+YcF3pimGw2pDy6RYkWq
	 nUQWkL6qYQkFBrKbJEjszR+EywuxehiHQFDlAqqqABi/NYw40oPgyZH4P2n3ScmbYd
	 Jdf7ZpPbF8NIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: mac80211: clarify beacon parsing with MBSSID/EMA
Date: Mon, 31 Aug 2026 09:28:18 -0400
Message-ID: <20260831133314.4125787-470-sashal@kernel.org>
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

[ Upstream commit 32e223198539bd8be5a84764df869f88bc56f25b ]

When connected to a non-transmitting BSS of multiple BSSID
set with EMA, the correct profile for the connection isn't
always present in the beacon. Indicate this in the parser
and use the information to not check everything in beacon
processing, since the information might not be correct if
taken only from the transmitted BSS.

Link: https://patch.msgid.link/20260529102644.97527a7dfd7b.Iecd0ef578b85a5a0057538cfff5fdff41d19b7ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: mac80211: clarify beacon parsing with
MBSSID/EMA`

**Local tree:** `v6.18.44` (6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: mac80211]` `[clarify]` — When connected to a non-
transmitting BSS in an MBSSID set with EMA, beacon parsing may not find
the correct profile; the parser should record that and skip processing
that depends on profile-specific data.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** https://patch.msgid.link/20260529102644.97527a7dfd7b.Iecd0ef
  578b85a5a0057538cfff5fdff41d19b7ea@changeid
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Johannes Berg \<johannes.berg@intel.com\> (mac80211
  maintainer)

No syzbot, no user bug reports in the message.

### Step 1.3: Body analysis
**Record:**
- **Bug:** With EMA (Enhanced Multi-BSSID Advertisement), a non-
  transmitting BSS profile may be absent from a given beacon. The parser
  cannot return complete element data for the connected BSS.
- **Symptom:** Beacon processing still uses incomplete/incorrect data
  (from the transmitted BSS) for profile-specific updates.
- **Root cause:** No signal that the non-transmitted profile was
  missing; downstream code treats parsed elements as authoritative.
- **Version info:** None stated.

### Step 1.4: Hidden bug fix?
**Record:** Yes. "Clarify" understates it. This is a correctness fix
that prevents applying WMM, bandwidth, TWT, power constraint, and ML
reconfiguration from the wrong BSS's beacon data — behavior that can
cause spurious disconnects.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Change |
|------|--------|
| `net/mac80211/ieee80211_i.h` | +9 lines: new
`mbssid_nontx_profile_missing` bool in `struct ieee802_11_elems` |
| `net/mac80211/parse.c` | +4 lines: set flag when `transmitted_bss` set
and `nontx_len == 0` |
| `net/mac80211/mlme.c` | ~90 lines: reorder + gate beacon processing
behind flag |

**Functions modified:** `ieee802_11_parse_elems_full()`,
`ieee80211_rx_mgmt_beacon()`
**Scope:** Single-subsystem, 3 files, focused logic change with some
reordering.

### Step 2.2: Code flow changes
**Record:**

**parse.c hunk:** Before → after
- Before: `ieee802_11_find_bssid_profile()` returns 0 silently when
  profile absent; caller has no way to know parsing is incomplete.
- After: Sets `elems->mbssid_nontx_profile_missing = true` when
  connected to non-transmitted BSS and profile not found.

**mlme.c hunk:** Before → after
- Before: All beacon-derived updates run unconditionally (WMM, cross-
  link CSA, BW config, TWT, power constraint, ML reconfig).
- After: Essential processing still runs (beacon monitor, SSID check,
  TIM/PS, P2P NoA, timing, CRC, CSA from transmitted BSS, DTIM, ERP).
  Profile-dependent updates are skipped when flag is set; `goto apply`
  jumps to `ieee80211_link_info_change_notify()`.

### Step 2.3: Bug mechanism
**Record:** **Category:** Logic/correctness fix (incorrect data
application)
**Mechanism:** When `nontx_len == 0`, `sub.len == 0` so inner profile
parsing is skipped and `elems` contains outer/transmitted-BSS data.
Without the flag, `ieee80211_config_bw()` can see apparent
mode/bandwidth changes and return `-EINVAL`, triggering disconnect.
`ieee80211_sta_wmm_params()`, `ieee80211_recalc_twt_req()`,
`ieee80211_handle_pwr_constr()`, and `ieee80211_ml_reconfiguration()`
can apply wrong parameters.

### Step 2.4: Fix quality
**Record:** Fix is logically sound and minimal for the problem. The
maintainer explicitly documents what must still run vs. what must be
skipped. Reordering (CSA before gated block, RNR outside profile) is
intentional. Low regression risk: only affects the
`mbssid_nontx_profile_missing` path, which is currently unhandled.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `ieee802_11_find_bssid_profile()` introduced in
`9d0480a7c05b6` (Jan 2024, "move element parsing to a new file"). MBSSID
non-transmitted profile search fixed in `e1e6ebf490e55` (Jun 2025).
Buggy "process all beacon data even when profile missing" behavior
present since MBSSID STA parsing was added; EMA makes the missing-
profile case expected and recurring.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Related MBSSID commits in this tree: `e1e6ebf490e55`
(profile search fix), `182a2786d248e` (don't use old MBSSID elements),
`1afa18e9e7239` (EMA beacon switch count), `68b9bea267bfc` (RNR for EMA
AP). Standalone fix; not part of a numbered series. Commit not present
in this tree (candidate only).

### Step 3.4: Author context
**Record:** Johannes Berg is mac80211/cfg80211 maintainer. Recent
related work in tree includes MLE defragmentation fix, non-transmitted
BSSID profile search fix.

### Step 3.5: Dependencies
**Record:** Patch context references `empty_non_inheritance` and
`sub.type`, which are **not** in v6.18.44 (`sub.action` is used instead;
no `empty_non_inheritance`). Those are context from a newer mainline
base, not part of this commit's actual diff. Core changes (flag +
gating) are self-contained and apply to this tree with minor context
adaptation. No other commits required for the fix to function.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c` failed (commit not in local tree). `b4 dig` by
subject failed (wrong usage). Lore/patch.msgid.link blocked by bot
protection. Could not retrieve thread discussion.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not access lore thread.

### Step 4.3: Bug report
**Record:** No external bug report. No syzbot. Issue is protocol-
correctness driven, identified by maintainer.

### Step 4.4: Related patches
**Record:** Part of ongoing MBSSID/EMA beacon-parsing work. Complements
`e1e6ebf490e55` (profile search) already in tree. Standalone value.

### Step 4.5: Stable list history
**Record:** UNVERIFIED — lore blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `ieee802_11_parse_elems_full()`,
`ieee802_11_find_bssid_profile()`, `ieee80211_rx_mgmt_beacon()`,
`ieee80211_config_bw()`, `ieee80211_sta_wmm_params()`

### Step 5.2: Callers
**Record:** `ieee80211_rx_mgmt_beacon()` called from management RX path
(`ieee80211_rx_mgmt`, lines ~8156/8186) — normal connected-STA beacon
receive path. High-frequency, every beacon interval.

### Step 5.3: Callees
**Record:** Parser calls `ieee802_11_find_bssid_profile()`,
`cfg80211_find_ext_elem()`, `_ieee802_11_parse_elems_full()`. Beacon
handler calls disconnect path via `ieee80211_config_bw()` →
`ieee80211_set_disassoc()`.

### Step 5.4: Reachability
**Record:** Triggered when STA is associated to a non-transmitted BSS
(`bss->transmitted_bss` set) on an EMA-capable AP. EMA detection exists
in tree (`bss_conf->ema_ap`, `WLAN_EXT_CAPA11_EMA_SUPPORT`). Reachable
from normal WiFi association — no special privileges needed beyond
connecting to such an AP.

### Step 5.5: Similar patterns
**Record:** EMA beacon generation/parsing fixes already in tree
(`1afa18e9e7239`, `68b9bea267bfc`). This follows the same MBSSID/EMA
correctness theme.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (v6.18.44)

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `ieee80211_rx_mgmt_beacon()` at lines
7616–7703 processes WMM, BW, TWT, power constraint, and ML reconfig
without checking whether the non-transmitted profile was found.
`ieee802_11_find_bssid_profile()` can return 0 (line 825).
`mbssid_nontx_profile_missing` does not exist. MBSSID/EMA infrastructure
is present.

### Step 6.2: Backport complications
**Record:** Expected **minor conflicts** — patch base uses `sub.type`
vs. local `sub.action`; `empty_non_inheritance` is context-only and not
needed for this commit's actual changes. Core 3-file change should apply
cleanly with trivial adaptation.

### Step 6.3: Related fixes already present?
**Record:** `e1e6ebf490e55` (profile search return fix) is in tree. This
complementary fix is **not** present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `net/mac80211` — **IMPORTANT** (WiFi stack used broadly; STA
beacon path is core connectivity).

### Step 7.2: Activity
**Record:** Actively developed; recent MBSSID/MLE/EMA fixes indicate
this area is still maturing and bug-prone.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** WiFi clients connected to **non-transmitted BSSs** in **EMA-
enabled MBSSID** deployments (enterprise/campus WiFi 6/7 APs). Config-
specific, but user population is growing.

### Step 8.2: Trigger conditions
**Record:** Every beacon where EMA rotation omits the connected non-
transmitted profile — **periodic and expected** with EMA, not rare.
Unprivileged users trigger by normal WiFi association.

### Step 8.3: Failure mode severity
**Record:**
- **Spurious disconnect** via `ieee80211_config_bw()` returning
  `-EINVAL` (lines 7678–7687) — **CRITICAL**
- Wrong WMM/QoS parameters — **MEDIUM**
- Wrong TWT/power/ML reconfig — **MEDIUM**

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected deployments — prevents recurring
  disconnects and incorrect connection parameters during normal EMA
  operation
- **Risk:** LOW — small flag + early-exit; only affects the previously-
  unhandled missing-profile path
- **Ratio:** Strong benefit, low risk

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: incomplete beacon parse treated as complete
- Can cause spurious disconnects (`ieee80211_config_bw()`)
- EMA makes missing profiles expected, not exceptional
- Small, maintainer-authored, logically correct fix
- Buggy code confirmed in v6.18.44
- MBSSID/EMA support already in tree

**AGAINST backport:**
- No explicit user/syzbot report
- Niche scenario (non-transmitted BSS + EMA)
- Slight mainline divergence in patch context (`sub.type`,
  `empty_non_inheritance`)
- "Clarify" wording understates severity

**Unresolved:** Mailing list review feedback (lore inaccessible).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified in code;
   maintainer-authored; no Tested-by
2. Fixes a real bug? **PASS** — incorrect beacon data application when
   EMA profile absent
3. Important issue? **PASS** — spurious disconnects (CRITICAL), wrong
   connection params (MEDIUM)
4. Small and contained? **PASS** — 3 files, ~100 lines, no API changes
5. No new features/APIs? **PASS** — internal flag only
6. Can apply to local tree? **PASS** — buggy code present; minor context
   adaptation expected

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Standard
bug fix.

### Step 9.4: Decision rationale
When a STA is connected to a non-transmitted BSS on an EMA AP, beacon
profiles rotate and the connected profile is intentionally absent from
many beacons. The current v6.18.44 code parses outer/transmitted-BSS
elements and applies them as if they belong to the connected BSS —
including bandwidth tracking that can trigger disconnect. This commit
adds a clear signal (`mbssid_nontx_profile_missing`) and skips profile-
dependent updates while preserving essential beacon handling
(monitoring, CSA, DTIM, ERP). This is exactly the kind of connectivity-
stability fix stable trees should carry.

---

## Verification

- [Phase 1] Parsed subject, body, tags: only Link + SOB from Johannes
  Berg
- [Phase 2] Diff analysis: 3 files, flag in `ieee802_11_elems`, set in
  `parse.c`, gating in `mlme.c`
- [Phase 2] Verified `ieee80211_config_bw()` disconnect path at lines
  1288–1294, 1346–1350, 7678–7687
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame` on `ieee802_11_find_bssid_profile()`: introduced
  9d0480a7c05b6 (2024)
- [Phase 3] `e1e6ebf490e55` confirmed in tree (related profile search
  fix)
- [Phase 3] `git log --grep="clarify beacon parsing"`: no match — commit
  not in tree
- [Phase 4] `b4 dig -c`: failed (commit not in tree)
- [Phase 4] Lore/patch.msgid.link: blocked by bot protection —
  UNVERIFIED
- [Phase 5] `grep ieee80211_rx_mgmt_beacon`: called from mgmt RX at
  lines 8156, 8186
- [Phase 5] Traced `nontx_len == 0` path in `parse.c` lines 1023–1058:
  inner profile parsing skipped
- [Phase 6] `grep mbssid_nontx_profile_missing`: not in tree (fix
  absent, buggy code present)
- [Phase 6] `grep empty_non_inheritance`: not in tree (context-only
  divergence)
- [Phase 6] Verified `WLAN_EXT_CAPA11_EMA_SUPPORT` and
  `bss_conf->ema_ap` in mlme.c
- [Phase 6] Read current `ieee80211_rx_mgmt_beacon()` lines 7384–7708:
  matches pre-fix behavior
- [Phase 8] Disconnect path confirmed: `ieee80211_config_bw()` failure →
  `ieee80211_set_disassoc()`
- [UNVERIFIED] Mailing list reviewer feedback and stable nominations

**YES**The background search finished: none of the three greps (`clarify
beacon parsing`, `mbssid_nontx`, `empty_non_inheritance`) matched
anything in this tree, so the commit is not in v6.18.44 yet — it's only
a backport candidate.

That matches the earlier analysis: the buggy beacon-handling path is
present, and the fix should still apply with minor context tweaks
(`sub.action` vs `sub.type`).

**YES** — backport recommended for this tree.

 net/mac80211/ieee80211_i.h |  9 +++++
 net/mac80211/mlme.c        | 83 ++++++++++++++++++++++++++++----------
 net/mac80211/parse.c       |  4 ++
 3 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 5c0c833fcf7a9..b0e64cf346e2b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1864,6 +1864,15 @@ struct ieee802_11_elems {
 	struct ieee80211_mle_per_sta_profile *prof;
 	size_t sta_prof_len;
 
+	/*
+	 * When parsing the beacon with MBSSID (from a transmitted BSS), this
+	 * indicates that the profile the parser was instructed to look for
+	 * (via the bss value in &struct ieee80211_elems_parse_params) couldn't
+	 * be found (due to EMA, or perhaps broken AP) and the result cannot be
+	 * considered complete.
+	 */
+	bool mbssid_nontx_profile_missing;
+
 	/* whether/which parse error occurred while retrieving these elements */
 	u8 parse_error;
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9ec4125c06d19..3c33e56c12a80 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -7400,8 +7400,6 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	struct link_sta_info *link_sta;
 	struct sta_info *sta;
 	u64 changed = 0;
-	bool erp_valid;
-	u8 erp_value = 0;
 	u32 ncrc = 0;
 	u8 *bssid, *variable = mgmt->u.beacon.variable;
 	u8 deauth_buf[IEEE80211_DEAUTH_FRAME_LEN];
@@ -7521,6 +7519,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	if (!elems)
 		return;
 
+	/*
+	 * Note: with MBSSID and an EMA (or broken) AP, we could fail to find
+	 * the correct multi-BSSID profile for the non-transmitting AP we're
+	 * connected to. The result's elems->mbssid_nontx_profile_missing is
+	 * indicating that, but some things must happen regardless.
+	 */
+
 	if (rx_status->flag & RX_FLAG_DECRYPTED &&
 	    ieee80211_mgd_ssid_mismatch(sdata, elems)) {
 		sdata_info(sdata, "SSID mismatch for AP %pM, disconnect\n",
@@ -7556,6 +7561,11 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		}
 	}
 
+	/*
+	 * P2P will almost certainly not have MBSSID, but this just
+	 * assumes that it would at least always inherit NoA anyway
+	 * since it's absent from the channel.
+	 */
 	if (sdata->vif.p2p ||
 	    sdata->vif.driver_flags & IEEE80211_VIF_GET_NOA_UPDATE) {
 		struct ieee80211_p2p_noa_attr noa = {};
@@ -7613,23 +7623,17 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 
 	ieee80211_rx_bss_info(link, mgmt, len, rx_status);
 
+	/*
+	 * This assumes that all members of a multiple BSS set must be
+	 * switching together, so we can parse channel switch elements
+	 * from the transmitted BSS even if our non-transmitted one is
+	 * not present in this beacon (due to EMA.)
+	 */
 	ieee80211_sta_process_chanswitch(link, rx_status->mactime,
 					 rx_status->device_timestamp,
 					 elems, elems,
 					 IEEE80211_CSA_SOURCE_BEACON);
 
-	/* note that after this elems->ml_basic can no longer be used fully */
-	ieee80211_mgd_check_cross_link_csa(sdata, rx_status->link_id, elems);
-
-	ieee80211_mgd_update_bss_param_ch_cnt(sdata, bss_conf, elems);
-
-	if (!sdata->u.mgd.epcs.enabled &&
-	    !link->u.mgd.disable_wmm_tracking &&
-	    ieee80211_sta_wmm_params(local, link, elems->wmm_param,
-				     elems->wmm_param_len,
-				     elems->mu_edca_param_set))
-		changed |= BSS_CHANGED_QOS;
-
 	/*
 	 * If we haven't had a beacon before, tell the driver about the
 	 * DTIM period (and beacon timing if desired) now.
@@ -7646,17 +7650,53 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 		ieee80211_recalc_ps_vif(sdata);
 	}
 
-	if (elems->erp_info) {
-		erp_valid = true;
-		erp_value = elems->erp_info[0];
-	} else {
-		erp_valid = false;
-	}
+	/* RNR isn't inside an MBSSID profile */
+	ieee80211_mgd_update_bss_param_ch_cnt(sdata, bss_conf, elems);
+
+	/* assume ERP would be inherited anyway */
+	if (!ieee80211_is_s1g_beacon(hdr->frame_control)) {
+		u8 erp_value = 0;
+		bool erp_valid;
+
+		if (elems->erp_info) {
+			erp_valid = true;
+			erp_value = elems->erp_info[0];
+		} else {
+			erp_valid = false;
+		}
 
-	if (!ieee80211_is_s1g_beacon(hdr->frame_control))
 		changed |= ieee80211_handle_bss_capability(link,
 				le16_to_cpu(mgmt->u.beacon.capab_info),
 				erp_valid, erp_value);
+	}
+
+	/*
+	 * There are some other things that we can only do when the
+	 * real non-transmitted profile was actually parsed, so exit
+	 * here before doing those.
+	 */
+	if (elems->mbssid_nontx_profile_missing)
+		goto apply;
+
+	/*
+	 * This requires multi-link element, which is from the MBSSID profile.
+	 * Note that after this elems->ml_basic can no longer be used fully.
+	 *
+	 * Note also that currently the parsing is incorrect, so this will
+	 * never actually do anything.
+	 */
+	ieee80211_mgd_check_cross_link_csa(sdata, rx_status->link_id, elems);
+
+	/*
+	 * EDCA parameters should be the same, but perhaps ACM can differ
+	 * between BSSes in an MBSSID set.
+	 */
+	if (!sdata->u.mgd.epcs.enabled &&
+	    !link->u.mgd.disable_wmm_tracking &&
+	    ieee80211_sta_wmm_params(local, link, elems->wmm_param,
+				     elems->wmm_param_len,
+				     elems->mu_edca_param_set))
+		changed |= BSS_CHANGED_QOS;
 
 	sta = sta_info_get(sdata, sdata->vif.cfg.ap_addr);
 	if (WARN_ON(!sta)) {
@@ -7702,6 +7742,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_link_data *link,
 	ieee80211_process_adv_ttlm(sdata, elems,
 				      le64_to_cpu(mgmt->u.beacon.timestamp));
 
+apply:
 	ieee80211_link_info_change_notify(sdata, link, changed);
 free:
 	kfree(elems);
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index b9ec99f51851a..b117572f8cb17 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -1032,6 +1032,10 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 		sub.action = params->action;
 		sub.link_id = params->link_id;
 
+		/* indicate to consumer whether or not profile was found */
+		if (params->bss->transmitted_bss && !nontx_len)
+			elems->mbssid_nontx_profile_missing = true;
+
 		/* consume the space used for non-transmitted profile */
 		elems_parse->scratch_pos += nontx_len;
 
-- 
2.53.0

