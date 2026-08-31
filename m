Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974EC51D52D;
	Mon, 31 Aug 2026 13:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183827; cv=none; b=AMpFbF5i5X/GpNlj5u6VrIN3Im2oR0dWLexGTudbnf8E+CiPfKgTqrWC1D/34QQW1eGZ5+SfEm9hD+Tzh1rFqHCOws2ozcLzpYN5kVOgAiE9lAQ67ULm2O3DQZf9xhcKRoHU2/tYUkNOWcZr3jNdWSrkgcRhUbYQ20sZH4AEsrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183827; c=relaxed/simple;
	bh=rNh85opK1u1UB4cYNHF/5EeZWLNg2GbgM+uyJAYtPg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BglG6I6er5wX7ibPLaz9u/CR9OEHJExSqNS/kTozPOKib2FGagdCzyssx+72b6Ycmrjp7nOD6+0Es5Jx7tUGLHzrBHq/mqZTVI+ZUfHZvZK6em4rPVKqywZ9gxDUszK+oiSXtIVwA/vSdHxdztQ45d9lQkW+dhMCmxr4ULbZGgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MtXwqMAI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MtXwqMAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D821F000E9;
	Mon, 31 Aug 2026 13:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183825;
	bh=+GOek/mR3tpbZkQ0sPI54SFnHa6n0i9e/TGaZ0ZODAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtXwqMAI1kwVyZgpdqYZlHyZmUzZPQsPNBmcSM9GGbWgXG1fIU4Okrzv1doqX6hyG
	 KUm2ZqjfLrklHbzb+JchhZAYryCf4R1msVi5GWRaAJiU+Nks3DFetpIZMczVc0YSi7
	 PRf0ubl2cobNTKqGGvpcbS136BK/5n3qzUkTjkNukSd5uhO7HbvWo/H2dZmqyu4SZd
	 uYH+NqBJajh6TIGOitLYZUAiRYT1/GYn+e1+jll6D64si4xgHqXI9QhKdl8SNjIno5
	 M+mfeJu4o186oycR9qucYnGaaypxURDgqW6WX43lLv2PiwkDmO6VEgYaTsjNG+wPWz
	 2QWEXS5/mKfaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mvm: validate sta_id in TLC notif
Date: Mon, 31 Aug 2026 09:25:55 -0400
Message-ID: <20260831133314.4125787-327-sashal@kernel.org>
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

[ Upstream commit 3ed8d1705d3aa5fbec918b8e241b41c483706cc2 ]

TLC_MNG_UPDATE_NOTIF uses firmware-provided sta_id to index
fw_id_to_link_sta[] and fw_id_to_mac_id[]. Validate sta_id
before array access to avoid out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.1ce54794c1f8.I275fd4c1165bf42fb17516c550dd8813a2b8286e@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: validate sta_id in TLC
notif`

**Local tree:** Linux **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mvm]` `[validate]` — Add bounds checking
for firmware-provided `sta_id` in the TLC management update notification
handler before indexing driver station lookup tables.

### Step 1.2: Tags
**Record:**
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
  (author)
- **Link:** https://patch.msgid.link/20260714141909.1ce54794c1f8.I275fd4
  c1165bf42fb17516c550dd8813a2b8286e@changeid
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\> (maintainer)
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags (expected for manual review)
- **Notable:** Intel iwlwifi maintainer sign-off; no syzbot or user bug
  report cited

### Step 1.3: Body analysis
**Record:**
- **Bug:** `TLC_MNG_UPDATE_NOTIF` carries a firmware `sta_id` used to
  index `fw_id_to_link_sta[]` and `fw_id_to_mac_id[]` without prior
  validation.
- **Symptom:** Out-of-bounds array indexing when firmware sends an
  invalid `sta_id`.
- **Root cause:** Missing bounds check against
  `mvm->fw->ucode_capa.num_stations` before array access.
- **Version info:** None stated in commit message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit defensive bounds-check bug fix, not
disguised cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c` (+5 lines
  effective, copyright year bump)
- **Function:** `iwl_mvm_tlc_update_notif()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow per hunk
**Record:**
- **Before:** Parse notification inside `rcu_read_lock()`, immediately
  index `fw_id_to_link_sta[notif->sta_id]` and
  `fw_id_to_mac_id[notif->sta_id]`.
- **After:** Parse notification first; if `notif->sta_id >=
  num_stations`, log via `IWL_FW_CHECK` and return early; only then take
  `rcu_read_lock()` and index arrays.
- **Path affected:** Firmware RX notification handler
  (`TLC_MNG_UPDATE_NOTIF`), normal runtime WiFi path.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds array access (memory
  safety)
- **Mechanism:** `sta_id` is `u8` (0–255) in `struct
  iwl_tlc_update_notif`, but `fw_id_to_mac_id[]` and
  `fw_id_to_link_sta[]` are sized `IWL_STATION_COUNT_MAX` (16). A
  `sta_id >= 16` causes an out-of-bounds read before the existing
  `IS_ERR_OR_NULL` guard can help. The existing NULL check only covers
  valid indices where the station was removed — not invalid indices.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches the identical check already present in the
  MLD TLC handler (`mld/tlc.c`) and the pattern used across MVM
  (`mac80211.c`, `rxmq.c`, `mvm.h` inline helpers).
- **Regression risk:** Very low — early return on invalid input only; no
  behavior change for valid `sta_id` values.
- **Minor improvement:** Moving `notif` assignment before
  `rcu_read_lock()` avoids holding RCU on the error path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `git blame` on `rs-fw.c:414–435` attributes all lines to
merge commit `5d324e5159d9e` (6.18-rc8 era). Per-file history in this
stable tree does not expose the original introduction commit. The
vulnerable indexing pattern is present in the current 6.18.44 tree.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -50 --
drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c` returns only the merge
commit due to tree history structure. Related precedent in this tree:
commit `1de92789ce31e` ("wifi: iwlwifi: mld: validate sta_mask before
ffs() in BA session handlers") — a similar iwlwifi sta_id OOB fix
already backported to 6.18.y by Greg Kroah-Hartman.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is a long-standing iwlwifi developer; Miri
Korenblit is the iwlwifi maintainer who signed off. This is subsystem-
expert work.

### Step 3.5: Dependencies
**Record:** No dependencies. Self-contained; uses existing
`IWL_FW_CHECK` macro (available via `mvm.h` → `fw/dbg.h`). Standalone,
not part of a series.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig` could not locate the commit (not yet in tree).
Lore.kernel.org and patch.msgid.link are blocked by Anubis bot
protection — **UNVERIFIED** whether reviewers explicitly nominated for
stable.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — could not fetch thread via b4 or lore.

### Step 4.3: Bug report
**Record:** No Reported-by or bugzilla/syzbot link. Bug identified by
code inspection / internal review (Assisted-by: Copilot). Severity
inferred from code analysis, not a filed crash report.

### Step 4.4: Related patches
**Record:** MLD path already has the identical validation in
`iwl_mld_handle_tlc_notif()` — this MVM patch closes a parity gap. No
multi-patch series dependency.

### Step 4.5: Stable list discussion
**Record:** **UNVERIFIED** — lore blocked. However, `1de92789ce31e`
(similar iwlwifi OOB fix) was explicitly backported to this 6.18.y tree
with `Cc: stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_tlc_update_notif()` modified.

### Step 5.2: Callers
**Record:**
- Registered in `iwl_mvm_rx_handlers[]` as
  `RX_HANDLER_GRP(DATA_PATH_GROUP, TLC_MNG_UPDATE_NOTIF,
  iwl_mvm_tlc_update_notif, RX_HANDLER_SYNC, ...)`
- Invoked from `iwl_mvm_rx_common()` → `iwl_mvm_rx()` on firmware
  notifications
- **Context:** Synchronous RX handler during active WiFi operation (not
  init-only)

### Step 5.3: Callees
**Record:** `rcu_dereference()` on station tables, `IS_ERR_OR_NULL()`,
rate/AMSDU processing downstream. Fix adds `IWL_FW_CHECK()` before any
RCU access.

### Step 5.4: Reachability
**Record:** Triggered whenever Intel WiFi firmware sends
`TLC_MNG_UPDATE_NOTIF` — common during rate adaptation and AMSDU
configuration on connected stations. Reachable during normal WiFi use
with `CONFIG_IWLWIFI` + MVM opmode (majority of Intel laptop/desktop
WiFi hardware).

### Step 5.5: Similar patterns
**Record:** **This handler is the outlier.** Other MVM paths validate
`sta_id` before indexing the same arrays:

```3366:3370:drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
        if (WARN_ON(notif->sta_id >= mvm->fw->ucode_capa.num_stations))
                return;

        rcu_read_lock();
        sta = rcu_dereference(mvm->fw_id_to_mac_id[notif->sta_id]);
```

```678:684:drivers/net/wireless/intel/iwlwifi/mld/tlc.c
        if (IWL_FW_CHECK(mld, notif->sta_id >=
mld->fw->ucode_capa.num_stations,
                         "Invalid sta id (%d) in TLC notification\n",
                         notif->sta_id))
                return;

        link_sta = wiphy_dereference(mld->wiphy,
mld->fw_id_to_link_sta[notif->sta_id]);
```

The MVM TLC handler at lines 428–430 lacks this guard — confirmed
oversight.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **YES.** In 6.18.44, `iwl_mvm_tlc_update_notif()` at `rs-
fw.c:428–430` indexes arrays without bounds check. Arrays are
`IWL_STATION_COUNT_MAX` (16) elements; `num_stations` is capped at 16 by
firmware TLV parsing in `iwl-drv.c`.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** The fix is 5 lines in one
function; no structural conflicts visible. `IWL_FW_CHECK` and
`num_stations` already exist in this tree.

### Step 6.3: Related fixes already present?
**Record:** MLD TLC handler already has this check. MVM
`iwl_mvm_sta_pm_notif` and RX paths have similar checks. This specific
gap in `iwl_mvm_tlc_update_notif()` is **not** yet fixed in 6.18.44.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm/` — **IMPORTANT**
(Intel WiFi, widely deployed on laptops/servers/desktops).

### Step 7.2: Subsystem activity
**Record:** iwlwifi is actively maintained; MLO/link_sta work has
increased `fw_id_to_link_sta[]` usage. Recent stable backports in this
tree confirm ongoing iwlwifi OOB fixes are expected stable material.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel WiFi (`CONFIG_IWLWIFI`, MVM opmode) — large
population on consumer and enterprise hardware.

### Step 8.2: Trigger conditions
**Record:** Firmware sends `TLC_MNG_UPDATE_NOTIF` with `sta_id >=
num_stations` (or `>= 16`). Can arise from firmware bugs, race during
station teardown, or corrupted notification. Not directly userspace-
triggered, but occurs during normal WiFi operation. Likelihood: low per-
event, but the RX path is hot.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read on kernel heap/stack-adjacent RCU pointer
arrays → **HIGH** severity (kernel oops/warning, potential info leak or
crash). With KASAN: definite OOB report.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents kernel crash on a common driver RX path
- **Risk:** VERY LOW — 5-line defensive check, established pattern, no
  API change
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds array indexing bug (u8 sta_id vs 16-element arrays)
- Can cause kernel oops on WiFi RX path
- Small, obviously correct, maintainer-reviewed fix
- Identical check already exists in MLD TLC handler and peer MVM
  notification handlers
- Precedent: similar iwlwifi sta_id OOB fix (`1de92789ce31e`) already in
  6.18.y
- Buggy code confirmed present in 6.18.44
- No dependencies or new APIs

**AGAINST backport:**
- No user crash report or syzbot report cited (weaker evidence of real-
  world trigger, but code path is clearly reachable)
- No mailing list stable nomination verified (lore inaccessible)

**UNRESOLVED:**
- Original patch thread review comments (lore blocked)
- Exact commit that introduced the missing check (file history opaque in
  this tree)

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors existing in-tree
   MLD/MVM patterns; maintainer SOB
2. Fixes a real bug? **PASS** — demonstrable OOB indexing
3. Important issue? **PASS** — kernel crash/OOB on WiFi RX path (HIGH)
4. Small and contained? **PASS** — ~5 lines, one function
5. No new features/APIs? **PASS** — defensive validation only
6. Can apply to local tree? **PASS** — code and macros present; clean
   apply

### Step 9.3: Exception categories
**Record:** N/A — standard memory-safety bug fix, not a device-
ID/quirk/DT/build/doc exception.

### Step 9.4: Decision rationale

For **Linux 6.18.y**, this commit closes a clear defensive gap in
`iwl_mvm_tlc_update_notif()` where firmware-provided `sta_id` can exceed
the station table bounds, causing out-of-bounds indexing of
`fw_id_to_link_sta[]` and `fw_id_to_mac_id[]`. The fix is minimal,
follows established iwlwifi conventions already used in the same tree
(including the MLD TLC handler), and prevents a potentially serious
kernel fault on a routine firmware notification path used by a large
installed base of Intel WiFi hardware. The absence of a filed crash
report does not diminish the correctness or importance of the fix — the
vulnerable code path is live and the bug mechanism is verifiable.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
- **[Phase 2]** Read current `rs-fw.c:414–452` — confirmed missing
  bounds check at lines 428–430
- **[Phase 2]** Verified `struct iwl_tlc_update_notif` has `u8 sta_id`
  (`fw/api/rs.h:258–259`)
- **[Phase 2]** Verified arrays sized `IWL_STATION_COUNT_MAX` (16) in
  `mvm.h:1008–1010`
- **[Phase 2]** Verified `IWL_FW_CHECK` macro in `fw/dbg.h:334–342`
- **[Phase 3]** `git describe HEAD` → v6.18.44; `Makefile` → 6.18.44
- **[Phase 3]** `git blame rs-fw.c:414–435` → all lines at current HEAD
- **[Phase 3]** `git show 1de92789ce31e` → similar iwlwifi OOB fix
  already backported to this tree
- **[Phase 4]** `b4 dig` — failed (commit not in tree); **UNVERIFIED**
- **[Phase 4]** Lore/patch.msgid.link — blocked by Anubis;
  **UNVERIFIED**
- **[Phase 5]** `grep iwl_mvm_tlc_update_notif` → registered in
  `ops.c:323–325` as `RX_HANDLER_SYNC`
- **[Phase 5]** `grep sta_id >= num_stations` in mvm/ → 8 other sites
  validate; `rs-fw.c` does not
- **[Phase 5]** Read `mld/tlc.c:678–684` → identical `IWL_FW_CHECK`
  already present for MLD path
- **[Phase 5]** Read `mac80211.c:3366–3370` → peer MVM notification
  handler validates first
- **[Phase 6]** Confirmed buggy code present in 6.18.44 checkout
- **[Phase 6]** Confirmed fix not yet applied in local tree
- **[Phase 6]** `iwl-drv.c:1303–1311` → `num_stations` capped at
  `IWL_STATION_COUNT_MAX`
- **[Phase 8]** Failure mode: OOB array index → kernel fault; severity
  HIGH

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index 89ac4c6b3e543..e2382be8edd78 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
  * Copyright (C) 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2025 Intel Corporation
+ * Copyright (C) 2018-2026 Intel Corporation
  */
 #include "rs.h"
 #include "fw-api.h"
@@ -423,9 +423,14 @@ void iwl_mvm_tlc_update_notif(struct iwl_mvm *mvm,
 	struct iwl_lq_sta_rs_fw *lq_sta;
 	u32 flags;
 
+	notif = (void *)pkt->data;
+	if (IWL_FW_CHECK(mvm, notif->sta_id >= mvm->fw->ucode_capa.num_stations,
+			 "Invalid sta id (%d) in TLC notification\n",
+			 notif->sta_id))
+		return;
+
 	rcu_read_lock();
 
-	notif = (void *)pkt->data;
 	link_sta = rcu_dereference(mvm->fw_id_to_link_sta[notif->sta_id]);
 	sta = rcu_dereference(mvm->fw_id_to_mac_id[notif->sta_id]);
 	if (IS_ERR_OR_NULL(sta) || !link_sta) {
-- 
2.53.0

