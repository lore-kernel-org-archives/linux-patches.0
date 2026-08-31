Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311274EE870;
	Mon, 31 Aug 2026 13:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183644; cv=none; b=G3RECKGwXMa06tc3QaxQ/4oHsEswcxqu3nJWPX5lXAQHRCgMp8YxaD0nlzli91YAOekt5NafXqh6csIROQ5pXzLwTPMO0qyOOn6xmwlaa6R6E3vMVaTxrJRHUh3oZJiBfZutImyLl34ZCepMBkT9zHWV/FMsbv9ZADLUyknbhCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183644; c=relaxed/simple;
	bh=fQb2NZwz1PsDV8tYROM5SczFzkCqvIep+IPA92orETA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rYBkF39PYIp+aHtn3Uov6laqDSqU+Odl/J5IwnS+lXkPUqMdpkRUnQr9FMeTxVsIiThHnaUdkNf3Ix223AZ0bmE+ip6v8z+nzULIaJwItvd4mCUOQsjqa199bwf4VWs0lOO6+hMtTTkiAyzmXz44zKv3ackLD7X7ilu7PeoSHjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8r2aJSY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8r2aJSY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1006E1F00ACF;
	Mon, 31 Aug 2026 13:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183641;
	bh=l2DLiaCPgwLm5QHijOrXvkcz1SdOAgshW8SkglcvLeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8r2aJSYs5a8ah5B8BdwgTBGyfMCV6DkuRNM1fZLo1b6KWp+OZlJz0Ne+k/yavjvC
	 t2pmsjAm//iGMhiZApGnC0SeoQCfDcRL7B0nsum+MfmdFFdcCTzp7QgO9GMiz4vBZO
	 SBBbhAcyqj2kxckmo33p9SMUe1BCxnrNlVIrCgZUWlu4Y3wICpVff4JugSh/UDVtne
	 wdCZ1KEqCMKJPoiBo3yQzEzXB1ZiDLa0FI2aSSrmUPDz5vAW1bRUqS3CmVcPPBmFjS
	 95M+DQK9iyCnctVg0lJxwtuE3KB9KKQ6msx3ppNhIVEG4w/M19VvH/hieJ/pb94XNz
	 sWsL2Uk6WuHGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: iwlwifi: mvm: validate sta_id in BA window status notif
Date: Mon, 31 Aug 2026 09:24:03 -0400
Message-ID: <20260831133314.4125787-215-sashal@kernel.org>
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

[ Upstream commit 6aa77efaea9efea92e3090c35ad348fd759a3cf3 ]

BA_WINDOW_STATUS_NOTIFICATION_ID extracts a 5-bit sta_id from the
firmware notification and uses it to index fw_id_to_mac_id[] without
bounds checking. Validate sta_id before array access to prevent
out-of-bounds indexing.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.2e97f337f3cb.Ic3f0f404082ccdea13809a3c0b70e0f5417e1037@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: validate sta_id in BA
window status notif`

**Local tree:** `v6.18.44-1-g2736c32da98b9` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: iwlwifi: mvm]` `[validate]` — Add bounds validation
for `sta_id` extracted from a BA window status firmware notification
before indexing `fw_id_to_mac_id[]`.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260714141909.2e97f337f3cb...`
  (patch submission link)
- **Cc: stable@vger.kernel.org** — not present (expected)
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
  (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (iwlwifi maintainer)
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex

Notable: maintainer sign-off from Miri Korenblit; no syzbot/user crash
report in the message.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** `BA_WINDOW_STATUS_NOTIFICATION_ID` carries a 5-bit `sta_id`
  in `ra_tid`; the handler indexes `fw_id_to_mac_id[sta_id]` without
  validating it.
- **Symptom/failure mode:** Out-of-bounds array indexing when firmware
  sends an invalid `sta_id`.
- **Version info:** none in message.
- **Root cause:** Missing bounds check against
  `mvm->fw->ucode_capa.num_stations` before array access.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — this is an explicit defensive validation
fix. It closes a memory-safety hole in a firmware-notification handler,
consistent with other iwlwifi validation patches already in this tree.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **Files:** `drivers/net/wireless/intel/iwlwifi/mvm/rx.c` (+5 lines)
- **Function:** `iwl_mvm_window_status_notif()`
- **Scope:** Single-file, surgical fix in one loop iteration

### Step 2.2: Code flow change
**Record:**
- **Hunk (lines ~1225–1227):** Before: extract `sta_id` from `ratid`,
  immediately `rcu_dereference(mvm->fw_id_to_mac_id[sta_id])`. After: if
  `sta_id >= num_stations`, log via `IWL_FW_CHECK` and `continue`.
- **Path affected:** Firmware RX notification handler for block-ack
  window status (powersave/reordering path).
- **Context:** Normal RX handler loop, not init/teardown.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds access (memory safety).
- **Mechanism:**
  - `BA_WINDOW_STATUS_STA_ID_MSK` is 5 bits → `sta_id` range 0–31
    (`fw/api/rx.h`).
  - `fw_id_to_mac_id[]` size is `IWL_STATION_COUNT_MAX` = **16**
    (`fw/api/mac.h`).
  - `num_stations` is capped at 16 by firmware TLV parsing (`iwl-
    drv.c`).
  - Without validation, `sta_id` values ≥ `num_stations` (and especially
    16–31) can index past the 16-element array.
  - A garbage pointer from OOB memory may pass `IS_ERR_OR_NULL()` and
    reach `ieee80211_mark_rx_ba_filtered_frames()`.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — matches existing driver patterns
  (`iwl_mvm_sta_from_staid_rcu()`, `iwl_mvm_sta_pm_notif()`, MLD RX
  handlers using `IWL_FW_CHECK`).
- **Regression risk:** Very low — only skips invalid entries; no
  API/locking changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** Shallow repository (`git rev-parse --is-shallow-repository`
→ `true`). `git blame` attributes `iwl_mvm_window_status_notif()` to
merge commit `5d324e5159d9e`; exact introduction commit not available in
this checkout. Function and buggy pattern are present in tag
`1efe5d048a391` (Linux 6.18.44).

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in the commit message.

### Step 3.3: File history for related changes
**Record:** Recent iwlwifi stable commits in this tree include similar
validation fixes:
- `2d5dec517b539` — wake packet notification bounds fix
- `dd90880eb5ec5` — OOB read in `iwl_mvm_nd_match_info_handler()`
- `1de92789ce31e` — BA session handler `sta_mask` validation (MLD)

Standalone fix; not part of a multi-patch series in this tree.

### Step 3.4: Author's other commits
**Record:** Emmanuel Grumbach is a long-time iwlwifi developer. Miri
Korenblit is iwlwifi maintainer (signed off). Shallow history limits
author-specific log on `rx.c`.

### Step 3.5: Prerequisites
**Record:** No dependencies found. `IWL_FW_CHECK` exists in `fw/dbg.h`.
`iwl_mvm_window_status_notif` and `BA_WINDOW_STATUS_NOTIFICATION_ID`
handler are present. `git apply --check` confirms the patch applies
cleanly to HEAD.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c HEAD` did not match this patch (matched unrelated
OF overlay patch). `b4 dig` by subject failed (wrong usage).
Lore.kernel.org and patch.msgid.link blocked by Anubis bot protection —
**could not read thread discussion**.

### Step 4.2: Reviewers from b4 dig -w
**Record:** Not retrieved — patch-specific `b4 dig` match not found.

### Step 4.3: Bug report
**Record:** No `Reported-by:` or syzbot link. Bug identified by
static/code review (Copilot-assisted per message). Severity is
theoretical until bad firmware data arrives, but consequences are real
(OOB access).

### Step 4.4: Related patches/series
**Record:** Part of iwlwifi's ongoing firmware-input validation theme;
similar fixes already backported to 6.18.y (see Phase 3.3). Appears
standalone.

### Step 4.5: Stable mailing list history
**Record:** Could not search lore (blocked). Similar iwlwifi OOB fixes
in this tree were explicitly nominated with `Cc: stable@vger.kernel.org`
(e.g. `dd90880eb5ec5`).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_window_status_notif()` — only function modified.

### Step 5.2: Callers
**Record:** Registered in
`drivers/net/wireless/intel/iwlwifi/mvm/ops.c`:
```348:350:drivers/net/wireless/intel/iwlwifi/mvm/ops.c
        RX_HANDLER(BA_WINDOW_STATUS_NOTIFICATION_ID,
                   iwl_mvm_window_status_notif, RX_HANDLER_SYNC,
                   struct iwl_ba_window_status_notif),
```
Called from iwlwifi firmware RX dispatch when firmware sends
`BA_WINDOW_STATUS_NOTIFICATION_ID` (0x13). Reachable during normal WiFi
operation with block-ack sessions (e.g. after D0i3 per notification
semantics).

### Step 5.3: Callees
**Record:** `IWL_FW_CHECK()`, `rcu_dereference()`, `IS_ERR_OR_NULL()`,
`ieee80211_mark_rx_ba_filtered_frames()`, `le16_to_cpu()`,
`le64_to_cpu()`, `le32_to_cpu()`.

### Step 5.4: Call chain / reachability
**Record:** Firmware → iwl trans RX → MVM RX handler table →
`iwl_mvm_window_status_notif()`. Triggered by firmware notifications
during WiFi RX/reordering. Not directly userspace-triggered, but
firmware bugs/corruption are realistic (similar fixes already accepted
for iwlwifi in stable).

### Step 5.5: Similar patterns
**Record:** Same `sta_id >= num_stations` check exists in:
- `iwl_mvm_sta_from_staid_rcu()` (`mvm.h:1354`)
- `iwl_mvm_sta_pm_notif()` (`mac80211.c:3366`)
- RX MPDU path (`rx.c:369`)
- MLD RX path (`mld/rx.c:1551-1554`)

This handler was the outlier missing the check.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** In `rx.c` at lines 1225–1227, `sta_id` is used to
index `fw_id_to_mac_id[sta_id]` without validation. Confirmed in tag
`1efe5d048a391` (Linux 6.18.44). Fix is **not** yet applied in this
checkout.

### Step 6.2: Backport complications
**Record:** **Clean apply** — `git apply --check` succeeded with no
conflicts.

### Step 6.3: Related fixes already present?
**Record:** No duplicate fix for this specific path. Related iwlwifi
firmware-validation fixes are already in 6.18.y (see Phase 3.3).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **IMPORTANT** — `drivers/net/wireless/intel/iwlwifi` (Intel
WiFi, widely deployed on laptops/desktops). `CONFIG_IWLWIFI` /
`CONFIG_IWLMVM`.

### Step 7.2: Subsystem activity
**Record:** Active — multiple iwlwifi fixes backported to 6.18.y in
recent history (validation, race fixes, OOB fixes).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel WiFi (`iwlmvm`) hardware using block-ack
reordering. Config-specific (`CONFIG_IWLWIFI` + `CONFIG_IWLMVM`), but
that is very common on Intel platforms.

### Step 8.2: Trigger conditions
**Record:** Firmware sends `BA_WINDOW_STATUS_NOTIFICATION` with `sta_id
>= num_stations` (or ≥16 with 5-bit encoding). Uncommon in normal
operation, but plausible with firmware bugs or corrupted notifications.
Not directly userspace-triggered.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read of `fw_id_to_mac_id[]` → possible invalid
`sta` pointer → kernel oops/corruption in
`ieee80211_mark_rx_ba_filtered_frames()`. **Severity: HIGH** (memory
safety / potential crash).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — closes a real OOB indexing bug in a live RX path.
- **Risk:** VERY LOW — 5-line validation, established pattern.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds indexing bug (5-bit `sta_id` vs 16-element array)
- Memory-safety issue with crash/corruption potential
- Small, obviously correct, matches existing driver conventions
- Applies cleanly to 6.18.44
- Buggy code confirmed present; fix not yet applied
- Similar iwlwifi firmware-validation fixes already backported to this
  tree
- iwlwifi maintainer sign-off

**AGAINST backport:**
- No user crash report or syzbot reproduction in commit message
- Trigger requires bad firmware notification data (uncommon)
- Shallow git history prevents dating when the handler was introduced

**Unresolved:**
- Lore review thread inaccessible (Anubis)
- Exact upstream commit hash not in this shallow tree

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — pattern used throughout
   iwlwifi; maintainer SOB; no logic concerns.
2. Fixes a real bug? **PASS** — missing bounds check on firmware-derived
   index.
3. Important issue? **PASS** — OOB access / potential kernel crash
   (HIGH).
4. Small and contained? **PASS** — 5 lines, one function.
5. No new features/APIs? **PASS** — defensive validation only.
6. Can apply to local tree? **PASS** — clean apply verified; code
   exists.

### Step 9.3: Exception categories
**Record:** Not a device-ID/quirk/DT/docs/build fix. Standard memory-
safety bug fix.

### Step 9.4: Decision rationale
For **Linux 6.18.44**, `iwl_mvm_window_status_notif()` indexes a
16-element array using a 5-bit firmware-provided `sta_id` without
validation. This is a clear out-of-bounds access bug. The fix is
minimal, follows established iwlwifi patterns, applies cleanly, and
aligns with other firmware-input validation fixes already accepted into
6.18.y.

---

## Verification

- [Phase 1] Parsed subject, tags, body from user-provided commit message
- [Phase 1] Confirmed no Reported-by/syzbot; maintainer SOB present
- [Phase 2] Read `rx.c:1193-1238` — buggy code without `IWL_FW_CHECK`
  confirmed
- [Phase 2] Read `fw/api/rx.h:972-976` — 5-bit `sta_id` mask confirmed
- [Phase 2] Read `fw/api/mac.h:19` — `IWL_STATION_COUNT_MAX` = 16
- [Phase 2] Read `mvm.h:1008` — `fw_id_to_mac_id[IWL_STATION_COUNT_MAX]`
- [Phase 2] Read `fw/dbg.h:334-342` — `IWL_FW_CHECK` macro behavior
- [Phase 3] `git rev-parse --is-shallow-repository` → `true`
- [Phase 3] `git blame -L 1193,1238 rx.c` — shallow history only
- [Phase 3] `git show 1efe5d048a391:rx.c` — buggy code in 6.18.44 tag
- [Phase 3] `git log --oneline -20 --
  drivers/net/wireless/intel/iwlwifi/` — related fixes found
- [Phase 3] `git show 2d5dec517b539`, `dd90880eb5ec5` — similar stable
  backports
- [Phase 3] `git apply --check` — patch applies cleanly
- [Phase 4] `b4 dig -c HEAD` — no match for this patch
- [Phase 4] WebFetch lore.kernel.org — blocked by Anubis (UNVERIFIED:
  review discussion)
- [Phase 4] WebFetch patch.msgid.link — blocked by Anubis (UNVERIFIED:
  thread content)
- [Phase 5] `grep iwl_mvm_window_status_notif` — caller in
  `ops.c:348-350`
- [Phase 5] Compared with `mvm.h:1354`, `mac80211.c:3366`,
  `mld/rx.c:1551`
- [Phase 6] `git describe HEAD` → `v6.18.44-1-g2736c32da98b9`
- [Phase 6] Makefile → 6.18.44
- [Phase 6] Buggy code present; fix absent in HEAD
- [Phase 8] OOB mechanism verified: 5-bit index (0–31) vs 16-element
  array

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 8c1bb3a7ffcaa..1e6d06bb674c1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -1224,6 +1224,11 @@ void iwl_mvm_window_status_notif(struct iwl_mvm *mvm,
 		/* get the station */
 		sta_id = (ratid & BA_WINDOW_STATUS_STA_ID_MSK)
 			 >> BA_WINDOW_STATUS_STA_ID_POS;
+		if (IWL_FW_CHECK(mvm,
+				 sta_id >= mvm->fw->ucode_capa.num_stations,
+				 "Invalid sta id (%d) in BA window status notification\n",
+				 sta_id))
+			continue;
 		sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
 		if (IS_ERR_OR_NULL(sta))
 			continue;
-- 
2.53.0

