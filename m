Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF525AEC54;
	Mon, 19 Oct 2026 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418137; cv=none; b=TkadboAgBmdqRGh2uZJC59+Lh0HQP3K/no2K0b4djQxh4cNjmX8Bt1drWjTVGqz+HFAtkGNn++U/ya7lzieSLfwaMqx2+OMoRxGfFwafobFvI/BGkoiNyeH17zaZ5kKGc20nwve9PVBpvwgkVpR1fZPfUHi61NuYKGrt7YL+vQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418137; c=relaxed/simple;
	bh=H2t30I/mx7Zv4qvlm5Fx4gB6U2BvTzDUC7PqqzO2p6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GdBboHh875gcBy1wTCEYI5MFKiachcZCiwIjcwOWRy7UGI+Ye0dxOjcCI+h1l3/mcD1pqglTw2mGBTagn5oN5t42Qh8++SBZIbGa6W89QdbAfvxBUAe4L6E+1RxwJj/fa7hNEpEKLR1SOZy9lOzfmZrRedNzR92uK2Mz3jnibVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QH6oivnP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QH6oivnP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADAC01F000C7;
	Mon, 19 Oct 2026 13:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418135;
	bh=DpmkNSpqviVL49NoMfpMYle5+zG1j3tAk00GAKCwfCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH6oivnP7339iIWgj3sf+4WclM0qk+QIAAClw/pOX9LAhZck7f/pWHd/ypVraqkQf
	 QpQrc/I2kRb55TBsyowIkOg/LwIMFG9uWs3VopTOMZ7WSIOD1N6EgtheCiHSgvihoN
	 d6OMNMfJucD8BZ1gHPG+4wEl4Io6dcWP1hy5r7gB37MewLFBA91JkkX2IfnUd+Ux0g
	 lrPzdf86RW37wa2jKJbi2YiFmSbWG5QP19/u6rMzufwRXUuerbb2f4yHILgwfgrmeE
	 o0JcVRiT1zLiVmn5HsGrAtrikQi7676tMtNw90vBFOZjH7CsuDy9dcY+PCWyeINlKp
	 ymgm/HG6uZnWw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: iwlwifi: mvm: ignore sync frames when sync is disabled
Date: Mon, 19 Oct 2026 09:45:28 -0400
Message-ID: <20261019135441.1420968-37-sashal@kernel.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit a790f60cc4d7dc64a2d7cadb94a3d9f60392bed4 ]

Gate time-sync frame interception on the active flag so frames are not
queued after time-sync teardown.

Assisted-by: GitHubCopilot:GPT-5.3-Codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260717172958.ac73ee199a25.Ic1489244f9b02da93060f0a0e5b300a73527f265@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). This
analysis is only about that checkout: the iwlwifi MVM time-sync path
exists here, and the two-line guard is a real teardown leak/drop fix.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[iwlwifi/mvm] [ignore/gate] intercept time-sync frames only
while time-sync is active**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Assisted-by:** GitHubCopilot:GPT-5.3-Codex
- **Signed-off-by:** Emmanuel Grumbach (author)
- **Link:** https://patch.msgid.link/20260717172958.ac73ee199a25.Ic14892
  44f9b02da93060f0a0e5b300a73527f265@changeid
- **Signed-off-by:** Miri Korenblit (iwlwifi maintainer)
- **No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable** (absence is expected for this pipeline)
- Ignored: any pipeline “already selected” markers (none present beyond
  a normal maintainer SOB)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** After time-sync teardown, matching TM/FTM frames are still
  intercepted and queued.
- **Symptom:** Frames sit on `frame_list` instead of going through the
  normal RX/TX-status path; they are not consumed by firmware time-sync
  notifications once the feature is off.
- **Version info in message:** none.
- **Root cause (from message + code):** interception is keyed only on
  `peer_addr`, which is left set after disable.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: This is an explicit bug fix (not style). “Ignore … when
disabled” / “frames are not queued after teardown” is incomplete disable
handling, which produces an skb leak and dropped TM/FTM frames.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h` (+4 /
  ~0; copyright year + 2-line guard)
- **Function:** `iwl_mvm_time_sync_frame()`
- **Scope:** single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** If `peer_addr` matches and the skb is a TM or FTM action
  frame, queue it on `mvm->time_sync.frame_list` and return true (caller
  skips `ieee80211_tx_status_skb` / `iwl_mvm_pass_packet_to_mac80211`).
- **After:** If `!mvm->time_sync.active`, return false immediately so
  the frame takes the normal path.
- **Path:** RX NAPI and TX-status reclaim; not probe init.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic/correctness + resource leak on teardown.
- **Mechanism:** `iwl_mvm_time_sync_config()` sets `active = (protocols
  != 0)` and purges `frame_list` when inactive, but still copies
  `peer_addr`. The interceptor never consulted `active`, so after
  disable it kept stealing matching frames.
- Compared with MLD: `iwl_mld_time_sync_frame()` already no-ops when
  `mld->time_sync` is NULL after `iwl_mld_deinit_time_sync()`. MVM
  stores time-sync in an embedded struct, so it needs the `active` flag.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: gate on the same flag config already uses.
- Minimal; no API/data-structure change.
- Regression risk is low. A remaining TOCTOU vs
  `iwl_mvm_time_sync_config()` (mutex vs RX/TX softirq, no `READ_ONCE`)
  is pre-existing; this closes the post-teardown window, which is the
  user-visible bug.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Interceptor introduced in **c7eca79def44f** (`wifi: iwlwifi: mvm:
  report hardware timestamps in RX/TX status`, Avraham Stern,
  2023-03-20).
- First appeared in **v6.4-rc1** (`git describe --contains
  c7eca79def44f` → `v6.4-rc1~132^2~151^2~105`).
- `struct iwl_time_sync_data { frame_list, peer_addr, active }` is from
  that same commit. The bug is old, not last-month code.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. The incomplete disable path is
**cf85123a210fe** (`wifi: iwlwifi: mvm: support enabling and disabling
HW timestamping`, also v6.4-rc1): it stopped auto-enabling on station
add, added purge-on-disable, and removed `iwl_mvm_time_sync_sta_rm()`,
but did not gate `iwl_mvm_time_sync_frame()`.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (on this tree, path-limited):
- `a790f60cc4d7d` — this fix
- `08e6183ed2568` — wifi action-frame struct move
- `cf85123a210fe` — enable/disable HW timestamping
- `a2f49f7d52a9e` / `c7eca79def44f` — original time-sync
Standalone. Series tag is **3/8** of an iwlwifi-next bundle; patches 1–2
and 4–8 touch other files. This hunk does not depend on them.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Emmanuel Grumbach is a long-time iwlwifi developer. Nearby July
2026 commits are other iwlwifi correctness fixes. Maintainer **Miri
Korenblit** signed off and applied it.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `mvm->time_sync.active` and `iwl_mvm_time_sync_frame()`,
both present since v6.4 and in this 7.3 tree. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c a790f60cc4d7` → https://patch.msgid.link/20260717172958.ac7
  3ee199a25.Ic1489244f9b02da93060f0a0e5b300a73527f265@changeid
- `b4 dig -a`: single **v1** series `[PATCH iwlwifi-next 0/8] wifi:
  iwlwifi: updates - 07-17-2026`
- Cover letter: “A couple of fixes, features and cleanups.” This patch
  is listed under Emmanuel’s fixes.
- Saved mbox: 9 messages (cover + 8 patches), **no review replies, NAKs,
  or Cc: stable**.
- WebFetch of lore returned **403**; discussion recovered via `b4 dig
  -m`.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): Miri Korenblit, Johannes Berg
(`johannes@sipsolutions.net`), linux-wireless, Emmanuel Grumbach. Right
lists/maintainers; no extra Reviewed-by on this patch. Miri’s SOB is the
maintainer merge.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No Reported-by / bugzilla / syzbot. Bug is from code inspection
of teardown vs interceptor.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Mixed iwlwifi-next series. This patch only changes `mvm/time-
sync.h`. Other patches are MLD/ACPI/debug and are **not** prerequisites.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: WebSearch of lore.kernel.org/stable for this subject found
**no** discussion. UNVERIFIED beyond that search (lore HTML 403).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `iwl_mvm_time_sync_frame()` only.

Step 5.2: TRACE CALLERS
Record:
1. `drivers/net/wireless/intel/iwlwifi/mvm/tx.c` — TX-status reclaim: if
   interceptor returns true, skip `ieee80211_tx_status_skb()`.
2. `drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c` — RX: if true, skip
   pass-to-mac80211.

Both are hot NAPI/TX-complete paths, but the match is rare (TM/FTM
action frames to a configured peer).

Step 5.3: TRACE CALLEES
Record: `ether_addr_equal()`, `ieee80211_is_timing_measurement()`,
`ieee80211_is_ftm()`, `skb_queue_tail()`. No alloc/locks in the inline
itself. Disable path: `iwl_mvm_time_sync_config()` under `mvm->mutex`
(from `iwl_mvm_set_hw_timestamp()` via mac80211 `set_hw_timestamp`).

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Enable/disable: userspace nl80211 `SET_HW_TIMESTAMP` →
  `ieee80211_set_hw_timestamp()` → `iwl_mvm_set_hw_timestamp()` →
  `iwl_mvm_time_sync_config()`.
- After disable, any later TM/FTM RX/TX for that `peer_addr` hits the
  interceptor.
- Reachable from the air for RX (FTM/TM responses) once the feature was
  enabled then disabled. Not a general unprivileged syscall crash path.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: MLD already treats “no time_sync object” as inactive. No second
MVM copy of this bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: **7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`).
- `git merge-base --is-ancestor a790f60cc4d7 HEAD` succeeded (commit is
  in this lineage; expected for mainline, not used as “already
  selected”).
- Pre-fix interceptor and `time_sync.active` / `peer_addr` /
  `frame_list` all exist here. Bug introduced in v6.4, **not** after
  this tree.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Current `time-sync.h` matches the patched form. Against the pre-
fix function (unchanged since c7eca79 except this guard), apply is
**clean**.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: Only this commit implements the `active` gate. `ead65aa2d5155`
(“send time sync only if needed”) is unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **wifi / iwlwifi MVM** (Intel wireless). **IMPORTANT** (very
common hardware), not core mm/VFS. Time-sync/HW timestamping is a
narrower slice of that driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: iwlwifi is actively developed (many 2026 commits). This
particular file is mature (stable since 6.4 aside from the action-frame
helper move).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Intel iwlwifi **MVM** users who used nl80211 HW timestamping
(TM/FTM) and then disabled it, while TM/FTM frames for that peer
continue. Not universal.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- Trigger: enable HW timestamp for a peer, then disable (`protocols ==
  0`). `peer_addr` stays set; `active` is false; interceptor still
  matched.
- Not every boot; requires that userspace API.
- After that, RX of matching FTM/TM frames from the network can keep
  filling `frame_list`.
- Enable/disable typically needs netlink admin; subsequent RX leak can
  be driven by frames on the air.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Unbounded **skb leak** of intercepted frames (purge only runs on a
  later inactive config).
- **Dropped** TM/FTM frames that should have gone to mac80211.
- **Missing TX status** (`ieee80211_tx_status_skb` skipped) for
  intercepted TX frames.
- Not a panic, UAF, or filesystem corruption.
- **Severity: HIGH** for the leak/drop on a live packet path; feature is
  uncommon so blast radius is limited.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** stops post-disable frame theft, skb leak, and missing TX
  completion. Small but real.
- **Risk:** very low (2 functional lines, same flag already used in
  config).
- **Ratio:** favorable for any tree that has MVM time-sync (this 7.3
  tree does).

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting to this tree:**
- Real teardown bug: interceptor ignored `active` while `peer_addr`
  survived disable.
- Consequences: skb leak, silent TM/FTM drops, skipped TX status.
- Two-line, obviously correct guard; no new API.
- Bug in code present since v6.4; this 7.3 tree has that code.
- Author + iwlwifi maintainer SOB; sent to linux-wireless / Johannes
  Berg.
- Standalone; other 3/8 series patches not required.
- MLD already has the equivalent “don’t intercept after teardown”
  behavior.

**AGAINST:**
- No `Fixes:` / `Reported-by` / syzbot / stable discussion.
- Path is niche (HW timestamping), not a crash/CVE-class bug.
- Commit message is short and Copilot-assisted.
- Mixed “fixes + features” series with no extra review on this patch.

**UNRESOLVED:**
- lore HTML 403; used b4 mbox instead.
- No public user reports found.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — matches existing `active`
   flag; merged by iwlwifi maintainer (no separate Tested-by).
2. Fixes a real bug that affects users? **PASS** — post-disable
   intercept/leak/drop.
3. Important issue? **PASS** — unbounded skb leak and missing TX
   completion on a packet path (not a panic; still user-visible).
4. Small and contained? **PASS** — one inline, +2 functional lines.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `time_sync.active` and
   callers exist; hunk is trivial.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not a device ID / quirk / DT / build / docs exception).
Ordinary small driver correctness fix.

Step 9.4: MAKE YOUR DECISION
This tree’s iwlwifi MVM time-sync stack still has the disable path that
leaves `peer_addr` set. Without the `active` check, teardown is
incomplete: TM/FTM skbs are queued forever and never get TX status or
mac80211 RX. The patch is the same check MVM config already uses and
that MLD gets via a NULL time-sync object. That is in scope for this 7.3
tree and meets stable rules.

What it solves for users of this tree: after HW timestamping is turned
off, FTM/TM frames are delivered normally instead of leaking on
`frame_list`.

Risk vs benefit: two lines vs a real leak/drop; benefit wins.

No missing prerequisites in this checkout.

Verification:
- [Phase 1] Parsed tags: Assisted-by Copilot, SOB Grumbach + Korenblit,
  msgid.link; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +2-line `if (!mvm->time_sync.active) return false;` in
  `iwl_mvm_time_sync_frame()`
- [Phase 2] Confirmed disable leaves `peer_addr` set in
  `iwl_mvm_time_sync_config()` (`time-sync.c` around the `active =
  protocols != 0` assignment and `skb_queue_purge`)
- [Phase 3] `git blame` parent: interceptor from c7eca79def44f
  (v6.4-rc1); disable redesign cf85123a210fe (v6.4-rc1)
- [Phase 3] No Fixes: tag; related history limited to `mvm/time-sync.*`
- [Phase 3] `git merge-base --is-ancestor a790f60cc4d7 HEAD` — commit is
  in this 7.3 lineage
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 iwlwifi-next 3/8, no replies;
  recipients Korenblit, Johannes, linux-wireless
- [Phase 4] WebFetch lore 403; stable WebSearch found no thread
- [Phase 5] Callers: `mvm/tx.c` TX status, `mvm/rxmq.c` RX; userspace
  via `set_hw_timestamp`
- [Phase 5] MLD equivalent already NULL-checks `time_sync` after deinit
- [Phase 6] `git describe HEAD` = v7.3-rc4-27; `make kernelversion` =
  7.3.0-rc4; feature present
- [Phase 8] Failure mode: skb leak + dropped TM/FTM + skipped TX status;
  severity HIGH on that path
- UNVERIFIED: public user reports; full lore HTML thread rendering

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
index 2cfd0fb5e781a..7bdbacb640787 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-sync.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2022 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __TIME_SYNC_H__
 #define __TIME_SYNC_H__
@@ -19,6 +20,9 @@ int iwl_mvm_time_sync_config(struct iwl_mvm *mvm, const u8 *addr,
 static inline
 bool iwl_mvm_time_sync_frame(struct iwl_mvm *mvm, struct sk_buff *skb, u8 *addr)
 {
+	if (!mvm->time_sync.active)
+		return false;
+
 	if (ether_addr_equal(mvm->time_sync.peer_addr, addr) &&
 	    (ieee80211_is_timing_measurement(skb) || ieee80211_is_ftm(skb))) {
 		skb_queue_tail(&mvm->time_sync.frame_list, skb);
-- 
2.53.0

