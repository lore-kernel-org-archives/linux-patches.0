Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 635C6438037;
	Mon, 31 Aug 2026 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183215; cv=none; b=oHLgal7RICHH3W0ghUEgJ73DLwhKAWz5V6EqIs4K3LZ0/09RXoKlhie6q/mGBxOP8nfg+EFO/EpHdOJ4qZuA9w47TUzln6yivpDCJBToM9srSHvKERUVwOx9Ik3/Bk7T8K/PGAbvvDVlL85A0Ju0WB/TYVz1IgLxRmJqK8jngnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183215; c=relaxed/simple;
	bh=dOULyuJuHCpIb6JIT/K4mhv4WoWfnlEAUTJs2Fjl22M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEw+uic65RjT8p+kRWAZm6d9ZcTlrWEaAbEzgVl+010Cg5ScbJARhZzl7uq2FIe7PJSEzk9X7UG1cEC2Oy8lsYf2BKN//n0NTCn64i4RDlJzVUfbBCQGiXNfimMZlLXrC/FrneShGR0iS09PGkHhlnrxn77UjV2WqG1hMJn2UL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dnl08ySa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dnl08ySa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396AB1F000E9;
	Mon, 31 Aug 2026 13:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183213;
	bh=eH6YN2ybjH+OMbJ5psW34LIPNDoEREetcOKN/tvEAK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dnl08ySaaI/Qjqb/2NWgAGgJA21lWvLFbjauoa9EXKQcidhR84ElU39lBRGLolcSh
	 PFRYwd/rkU6OUSGxQYfKnAu/+qFhiD9/NxE7nsk69el8Evu3j4hMRfyZteQXgEbBcx
	 F1tSYCgQ44Pcd0bOZ2pU0K5jBP0pLhg90Wqu19AL8IYHNoivcb9oztu8L7GAchobqC
	 X0xxwsILtM34K8+xsVu4Fhi1sZMhrqi3oon229HlLtkzyB1S0lD8bGea3mtlhygWo+
	 hlTgLAOuG+vB0/EHQ4TSrdYdIUmWWUSuPR7WoV6GvcBS1SJ1R0ce9myZuyEeK63bSg
	 yl6FNx9ioTQIg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: iwlwifi: mvm: parse beacon notif per layout
Date: Mon, 31 Aug 2026 09:20:40 -0400
Message-ID: <20260831133314.4125787-12-sashal@kernel.org>
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

[ Upstream commit b77c6f50b1f80414cb3f542ae72e532ed90fc7f7 ]

The beacon TX notification can arrive in different layouts, and fields
must be read only after selecting the expected format.

Parse gp2 and TSF from the matching notification structure in each
branch, and keep using the parsed gp2 for CSA countdown and debug output.
Drop the obsolete cached gp2 field.

Assisted-by: GitHub Copilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.cc8aa937f8e5.I921f8dadcb20cb73e8283e1b8546e1778205411f@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: parse beacon notif per
layout`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`, detached
from `stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: iwlwifi: mvm]` `[parse]` — Parse beacon TX
notification fields according to the correct firmware layout before use.

### Step 1.2: Parse all commit message tags
**Record:**
- **Link:** https://patch.msgid.link/20260714141909.cc8aa937f8e5.I921f8d
  adcb20cb73e8283e1b8546e1778205411f@changeid
- **Assisted-by:** GitHub Copilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\>
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, or Cc:
  stable@vger.kernel.org
- **Notable:** Part of `[PATCH iwlwifi-fixes 07/15]` series; Reviewed-
  by: Ilan Peer (from lore thread, verified via b4)

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `gp2` (and implicitly `tsf`) are read from the v6
  (`iwl_extended_beacon_notif`) layout before the code selects which
  notification layout the firmware actually sent.
- **Symptom:** Wrong `gp2` timestamp used for CSA countdown scheduling
  and debug output on firmware using the v5 layout.
- **Root cause:** Early unconditional `beacon->gp2` read assumes v6
  offsets regardless of `iwl_mvm_is_short_beacon_notif_supported()`
  result.
- **Version info:** None in commit message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit correctness fix for
struct layout mis-parsing, though the subject uses "parse" rather than
"fix".

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- `mac-ctxt.c`: +15/-14 — `iwl_mvm_rx_beacon_notif()`
- `mac80211.c`: -1 — remove `mvm->ap_last_beacon_gp2 = 0` in
  `iwl_mvm_stop_ap_ibss_common()`
- `mvm.h`: -3 — remove `ap_last_beacon_gp2` field from `struct iwl_mvm`
- **Scope:** Single-subsystem, surgical fix (3 files, ~30 lines net)

### Step 2.2: Code flow change per hunk
**Record:**
1. **Before:** `mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2)` runs
   unconditionally at function entry using v6 struct pointer, then
   branches on layout.
2. **After:** Each branch declares the correct struct type, validates
   packet length, then reads `beacon_gp2` from the matching structure.
   CSA countdown and debug use local `beacon_gp2`.
3. **Cleanup:** Removes cached `ap_last_beacon_gp2` from `struct
   iwl_mvm` and its reset on AP stop.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Logic / correctness fix (struct layout mis-parse)
- **Mechanism:** On v5-layout firmware
  (`!iwl_mvm_is_short_beacon_notif_supported()`), `beacon->gp2` reads at
  byte offset 16 (v6 layout: after 4-byte status + 8-byte tsf + 4-byte
  ibss_mgr_status). In v5 layout, `gp2` is at `sizeof(struct
  iwl_tx_resp) + 16` ≈ offset 54+. The read pulls data from inside
  `beacon_notify_hdr` instead of the real `gp2` field. Similarly,
  `beacon->tsf` in the v5 debug path used v6 offset instead of
  `beacon_v5->tsf`.

### Step 2.4: Fix quality assessment
**Record:** Fix is obviously correct — parse layout first, then read
fields. Minimal, no API changes. Very low regression risk; only affects
field extraction order and removes an unnecessary cached field.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Current buggy lines in `mac-ctxt.c:1516-1549` blame to
`5d324e5159d9e` (v6.18 merge). Dual-layout handling with the early `gp2`
read was introduced in `15e28c78c3864` (Nov 2018, "support new format
for the beacon notification"). The `ap_last_beacon_gp2` field dates to
extended beacon notification support (2014 era).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related file history
**Record:** Recent iwlwifi mvm commits in this tree include CSA-related
`ece13ddb9791e` (noa_len validity) and other iwlwifi fixes. Fix commit
`b77c6f50b1f80` is on `master`/linux-next but **not** on
`stable/linux-6.18.y`.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is a long-standing iwlwifi maintainer.
Miri Korenblit committed the fix. Ilan Peer (Intel) reviewed on lore.

### Step 3.5: Dependencies
**Record:** Standalone fix within the iwlwifi-fixes 07/15 series slot,
but does not depend on patches 01–06 for correctness. Applies cleanly to
this tree (`git show b77c6f50b1f80 | git apply --check` succeeded).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** b4 dig found thread at https://patch.msgid.link/202607141419
09.cc8aa937f8e5.I921f8dadcb20cb73e8283e1b8546e1778205411f@changeid. Part
of v1 iwlwifi-fixes 15-patch series (2026-07-14). No stable nomination
found in thread. No NAKs found.

### Step 4.2: Reviewers
**Record:** CC'd to linux-wireless@vger.kernel.org,
johannes@sipsolutions.net, Miri Korenblit, Emmanuel Grumbach.
**Reviewed-by: Ilan Peer \<ilan.peer@intel.com\>**.

### Step 4.3: Bug reports
**Record:** No Reported-by, syzbot, or bugzilla links. Bug identified by
code inspection / development, not a crash report.

### Step 4.4: Series context
**Record:** Patch 07/15 of iwlwifi-fixes series. This specific change is
self-contained.

### Step 4.5: Stable mailing list
**Record:** Not searched exhaustively on lore stable@; no stable
nomination in patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions modified
**Record:** `iwl_mvm_rx_beacon_notif()`, `iwl_mvm_stop_ap_ibss_common()`
(cleanup only)

### Step 5.2: Callers
**Record:** `iwl_mvm_rx_beacon_notif` registered in `ops.c` as
`RX_HANDLER_NO_SIZE(BEACON_NOTIFICATION, ...)`. Called from iwlwifi RX
path on every beacon TX notification from firmware — hot path for
AP/IBSS/P2P GO modes.

### Step 5.3: Callees
**Record:** `iwl_mvm_csa_count_down()` (uses `gp2` for P2P GO CSA period
scheduling), `iwl_mvm_get_agg_status()`, debug macros, RCU accessors for
CSA state.

### Step 5.4: Call chain / reachability
**Record:** Firmware → RX handler → `iwl_mvm_rx_beacon_notif` →
`iwl_mvm_csa_count_down` when CSA is active. Reachable during normal
AP/P2P GO operation with channel switch. Not a syscall path directly,
but triggered by normal WiFi operation.

### Step 5.5: Similar patterns
**Record:** MLD driver (`mld/notif.c`) uses only v6
`iwl_extended_beacon_notif` via CMD_VERSIONS — not affected. The dual-
layout bug is mvm-specific.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current tree at `mac-ctxt.c:1516` has the
unconditional `mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2)`
before layout selection. `ap_last_beacon_gp2` exists in `mvm.h:1181`.
Bug present since dual-layout support (2018); code exists in 6.18.44.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` passes without
modification.

### Step 6.3: Related fixes already present?
**Record:** Fix commit `b77c6f50b1f80` is **not** in this tree (only
`master` contains it per `git branch --contains`). No alternate fix
found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT**
(Intel WiFi, widely deployed on laptops/desktops).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple iwlwifi fixes already landed
in 6.18.y (wake packet read fix, noa_len, PTP race, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel iwlwifi hardware whose firmware does
**not** advertise `IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF` (v5 beacon
notification layout) and who use AP/P2P GO mode with CSA (channel
switch). Config: `CONFIG_IWLWIFI`, `CONFIG_IWLMVM`.

### Step 8.2: Trigger conditions
**Record:** Every beacon TX notification on v5-layout firmware; CSA
impact only when `csa_vif` is active and CSA countdown runs. Common
during beacon TX on AP/GO; CSA is less frequent but normal for
regulatory/P2P channel changes.

### Step 8.3: Failure mode severity
**Record:** Wrong `gp2` → incorrect `apply_time` in
`iwl_mvm_csa_count_down()` for P2P GO (`apply_time = gp2 + rel_time *
1024`). Can cause mistimed channel switch, CSA failure, or client
disconnection. **Severity: MEDIUM-HIGH** (functional connectivity bug,
not kernel crash/corruption).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Correct CSA timing and debug data for a large installed
  base of older Intel WiFi firmware; fixes long-standing bug (since
  2018).
- **Risk:** Very low — 3 files, layout-guarded field reads, reviewed by
  Intel developer.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Verified struct layout bug: reads v6 offsets on v5-format
  notifications
- Affects CSA countdown timing on P2P GO — real user-visible WiFi
  failure mode
- Bug present in 6.18.44 since 2018 dual-layout introduction
- Small, surgical, reviewed (Ilan Peer), authored by iwlwifi maintainer
- Applies cleanly to this tree
- Similar CSA-related iwlwifi fixes already in 6.18.y (e.g., noa_len)

**AGAINST backport:**
- No user crash reports or syzbot findings
- Only affects v5-layout firmware (not newest devices)
- CSA is not the most common WiFi operation
- No explicit stable nomination

**Unresolved:** Exact count of devices still on v5 layout in production
(qualitatively: many pre-recent firmware generations).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic is clear; Reviewed-by
   present; no Tested-by
2. Fixes a real bug affecting users? **PASS** — wrong firmware field
   parsing on v5 layout
3. Important issue? **PASS** — CSA timing failure causes connectivity
   loss (MEDIUM-HIGH)
4. Small and contained? **PASS** — 3 files, ~30 lines
5. No new features or APIs? **PASS** — correctness fix only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception categories
**Record:** None applicable (not device ID, quirk, DT, build, or docs).

### Step 9.4: Problem summary for stable users

On Intel iwlwifi hardware using the older v5 beacon notification layout,
the driver reads the `gp2` timestamp from the wrong byte offset in every
beacon TX notification. When a P2P GO (or AP) performs a channel switch
announcement (CSA), the driver uses this garbage timestamp to schedule
the switch, potentially causing mistimed or failed channel switches and
client disconnections. The fix reads `gp2` (and `tsf`) only after
selecting the correct notification structure for the firmware layout.
This is a long-standing bug (since 2018) affecting real hardware still
supported in 6.18.y.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show b77c6f50b1f80`
- [Phase 2] Diff analysis: 3 files, `iwl_mvm_rx_beacon_notif()`
  restructured; `ap_last_beacon_gp2` removed
- [Phase 3] `git describe HEAD`: v6.18.44; tree is 6.18.y stable
- [Phase 3] `git blame -L 1514,1520 mac-ctxt.c`: buggy lines at
  5d324e5159d9e
- [Phase 3] `git show 15e28c78c3864`: dual-layout code introduced early
  unconditional `beacon->gp2` read in 2018
- [Phase 3] `git show b77c6f50b1f80 | git apply --check`: applies
  cleanly
- [Phase 3] `git branch --contains b77c6f50b1f80`: only `master`, not
  stable branch
- [Phase 4] `b4 dig -c b77c6f50b1f80`: found lore thread, patch 07/15
- [Phase 4] `b4 dig -w`: CC linux-wireless, johannes, Intel authors
- [Phase 4] `b4 dig -a`: v1 series, 15 patches
- [Phase 4] `b4 dig -m /tmp/iwlwifi_beacon_thread.mbox`: Reviewed-by
  Ilan Peer confirmed; no stable CC
- [Phase 5] `grep iwl_mvm_rx_beacon_notif`: registered in `ops.c` RX
  handler table
- [Phase 5] Read `iwl_mvm_csa_count_down()`: `gp2` used for P2P GO
  `apply_time` calculation
- [Phase 5] Read struct definitions in `fw/api/tx.h`: v5 has
  `iwl_tx_resp` prefix, v6 has 4-byte status prefix
- [Phase 6] `grep ap_last_beacon_gp2`: field present in current tree
  (mvm.h, mac-ctxt.c, mac80211.c)
- [Phase 6] Read `mac-ctxt.c:1502-1550`: confirmed buggy unconditional
  read before layout branch
- [Phase 6] `iwl_mvm_is_short_beacon_notif_supported()` in mvm.h: checks
  `IWL_UCODE_TLV_API_SHORT_BEACON_NOTIF`
- [Phase 8] Offset analysis: v6 gp2 at offset 16; v5 gp2 at ~offset 54+
  (after `iwl_tx_resp`); reading v6 offset on v5 data is verified wrong
  by struct layout inspection
- [Phase 8] Fix not yet in stable/linux-6.18.y per `git branch
  --contains`

**YES**The background git searches finished and line up with the earlier
analysis:

- **Beacon gp2 history:** The early unconditional `beacon->gp2` read
  traces to the 2018 dual-layout change; `ap_last_beacon_gp2` has been
  in the driver since extended beacon notifications were added.
- **Fix location:** The fix is commit `b77c6f50b1f80` (`wifi: iwlwifi:
  mvm: parse beacon notif per layout`) on mainline/linux-next.
- **Stable status:** That commit is only on `master` — it is **not** in
  `stable/linux-6.18.y` yet, and it applies cleanly to the current
  6.18.44 tree.

That supports the **YES** backport recommendation: real layout-parsing
bug on v5-format firmware, CSA timing impact, small reviewed fix, not
yet in stable.

 .../net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 25 +++++++++++--------
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |  3 ---
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 44380ebfe09d0..cee6bde6ec822 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1504,49 +1504,54 @@ void iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	unsigned int pkt_len = iwl_rx_packet_payload_len(pkt);
-	struct iwl_extended_beacon_notif *beacon = (void *)pkt->data;
-	struct iwl_extended_beacon_notif_v5 *beacon_v5 = (void *)pkt->data;
 	struct ieee80211_vif *csa_vif;
 	struct ieee80211_vif *tx_blocked_vif;
 	struct agg_tx_status *agg_status;
+	u32 beacon_gp2;
 	u16 status;
 
 	lockdep_assert_held(&mvm->mutex);
 
-	mvm->ap_last_beacon_gp2 = le32_to_cpu(beacon->gp2);
-
 	if (!iwl_mvm_is_short_beacon_notif_supported(mvm)) {
+		struct iwl_extended_beacon_notif_v5 *beacon = (void *)pkt->data;
 		struct iwl_tx_resp *beacon_notify_hdr =
-			&beacon_v5->beacon_notify_hdr;
+			&beacon->beacon_notify_hdr;
 
-		if (unlikely(pkt_len < sizeof(*beacon_v5)))
+		if (unlikely(pkt_len < sizeof(*beacon)))
 			return;
 
-		mvm->ibss_manager = beacon_v5->ibss_mgr_status != 0;
+		beacon_gp2 = le32_to_cpu(beacon->gp2);
+
+		mvm->ibss_manager = beacon->ibss_mgr_status != 0;
 		agg_status = iwl_mvm_get_agg_status(mvm, beacon_notify_hdr);
 		status = le16_to_cpu(agg_status->status) & TX_STATUS_MSK;
 		IWL_DEBUG_RX(mvm,
 			     "beacon status %#x retries:%d tsf:0x%016llX gp2:0x%X rate:%d\n",
 			     status, beacon_notify_hdr->failure_frame,
 			     le64_to_cpu(beacon->tsf),
-			     mvm->ap_last_beacon_gp2,
+			     beacon_gp2,
 			     le32_to_cpu(beacon_notify_hdr->initial_rate));
 	} else {
+		const struct iwl_extended_beacon_notif *beacon =
+			(void *)pkt->data;
+
 		if (unlikely(pkt_len < sizeof(*beacon)))
 			return;
 
+		beacon_gp2 = le32_to_cpu(beacon->gp2);
+
 		mvm->ibss_manager = beacon->ibss_mgr_status != 0;
 		status = le32_to_cpu(beacon->status) & TX_STATUS_MSK;
 		IWL_DEBUG_RX(mvm,
 			     "beacon status %#x tsf:0x%016llX gp2:0x%X\n",
 			     status, le64_to_cpu(beacon->tsf),
-			     mvm->ap_last_beacon_gp2);
+			     beacon_gp2);
 	}
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
 	if (unlikely(csa_vif && csa_vif->bss_conf.csa_active))
-		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2,
+		iwl_mvm_csa_count_down(mvm, csa_vif, beacon_gp2,
 				       (status == TX_STATUS_SUCCESS));
 
 	tx_blocked_vif = rcu_dereference_protected(mvm->csa_tx_blocked_vif,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 92471bc7b505b..83fb3f9af4745 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3100,7 +3100,6 @@ void iwl_mvm_stop_ap_ibss_common(struct iwl_mvm *mvm,
 	}
 
 	mvmvif->ap_ibss_active = false;
-	mvm->ap_last_beacon_gp2 = 0;
 
 	if (vif->type == NL80211_IFTYPE_AP && !vif->p2p) {
 		iwl_mvm_vif_set_low_latency(mvmvif, false,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 2628361332895..319301504b7eb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1180,9 +1180,6 @@ struct iwl_mvm {
 	struct ieee80211_vif __rcu *csa_tx_blocked_vif;
 	u8 csa_tx_block_bcn_timeout;
 
-	/* system time of last beacon (for AP/GO interface) */
-	u32 ap_last_beacon_gp2;
-
 	/* indicates that we transmitted the last beacon */
 	bool ibss_manager;
 
-- 
2.53.0

