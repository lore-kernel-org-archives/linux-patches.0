Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236F853874F;
	Mon, 19 Oct 2026 14:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418690; cv=none; b=sEP2YP/FhXKpANIUVZRne3hDgZkhTTE7xozTLItfJB5JNMrt54aXnemKYk/JQqZlj/TojS2fpP/t6Vygs0LMDPSS4oKrrvk9kP6hiOkOTsmYyzethAUMd6eew5RORADBZ2Qm6SBbDaxuxvHnf4BNrQ/Kc+XmRsqpz3jJoDUa+EE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418690; c=relaxed/simple;
	bh=kHz4WGzoZ5eeHgEnb7PRsRa62zSAm4hBXMq0r4JeRgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TT063wjXSspAi4jUWJDFs8VBnEOJ+6TyBeQE2T6FGZr1eELz5ftotgceeHK3E4vj7EUy2Sv5zfbEWUMz1T3mdw69kxY8OmNJBQAt9gpIjrj65O/aNhNGOPgUUyDgDOp8T5l3YlZWYdQgnSB38tGkF3p/0xpWwiDokhbOMsThOfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTBMGlc2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTBMGlc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D915F1F000C4;
	Mon, 19 Oct 2026 14:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418687;
	bh=uCfePp48gs+Yo9pDp6Jdc+kFYuJ/dr7XoQcy1HfsQKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTBMGlc2XN2PRgB4D5RWsLbSoCdZdVZPRwe2DEB3WCjL3cWNJ7wgajIik9boyUISX
	 Sj+k65zepZxJ7jfi5mGMnr1xXXpg/UR4aTkmvZbLXnhiMiEPB5LtgBNOvhkP/Exs87
	 CSrCS05MNv8aZaDci0EJbjDb2TxreNVkhHr02i4tBpskGpX7lNExemvm0S/6hZ+oXM
	 Dq6s7wVzFrJfO73ZIwdWGI0CLyCjhOyW96OHa9JjWixl9KYaCtcL1tsgCrM3Y8aCyR
	 l+WtDJvLLohve7PfFd+/1IeiDtMUpd7vkXUPDS5U2fROmF5kko3ASVcDF9YObOBG7j
	 lYULuJbetbr4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: Do not cleanup FW state when the device is dead
Date: Mon, 19 Oct 2026 09:51:56 -0400
Message-ID: <20261019135441.1420968-425-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 1c031ac5a39ebcc3269eace8b606043adc398bfa ]

When a channel context is unassigned, there is a path to cleanup the FW
state in case of NON MLO connection: remove the link and add it again.
However, when the transport is dead, e.g., during device removal etc.,
this flow will fail and as a result the mld_vif->link[0] would be set to
NULL. Later, when the interface is removed, iwl_mld_remove_link() would
warn as the link is NULL.

Fix this by not doing the cleanup when the device is dead.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715220243.89a0c44a72a3.I45cca8b84a25943d5771199af6b0155dbac77b58@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **Linux 7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
candidate is `1c031ac5a39eb` and landed in `v7.3-rc1`. The iwlwifi MLD
path it fixes is present here (MLD since `v6.15-rc1`).

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[wifi: iwlwifi: mld:] [Do not / Fix] [skip non-MLO FW link
remove/re-add when the transport is dead]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: Ilan Peer <ilan.peer@intel.com>` (author)
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (iwlwifi MLD maintainer)
- `Link: https://patch.msgid.link/20260715220243.89a0c44a72a3.I45cca8b84
  a25943d5771199af6b0155dbac77b58@changeid`
- No `Fixes:`, no `Reported-by:`, no `Tested-by:`, no `Reviewed-by:`, no
  `Acked-by:`, no `Cc: stable` (absence expected)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** On non-MLO chanctx unassign, the driver remove/re-adds the
  link to reset FW state. If the transport is dead (device removal,
  etc.), that sequence fails and `mld_vif->link[0]` is left NULL.
- **Symptom:** Later `iwl_mld_remove_link()` during interface teardown
  hits `WARN_ON(!link)`.
- **Root cause:** FW cleanup is attempted after the device can no longer
  accept commands; the software link pointer is cleared on the failed
  re-add.
- **Version info:** none in the message. MLD itself dates to v6.15.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Explicitly a teardown bug: failed FW cleanup → NULL
link → `WARN_ON`.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c` (+4 / −2)
- Function: `iwl_mld_unassign_vif_chanctx()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** For non-MLO, non-AP, not associated, not in HW restart:
  always `iwl_mld_remove_link()` then `iwl_mld_add_link()`.
- **After:** Same, but also skip when `iwl_trans_is_dead(mld->trans)`.
- Path affected: chanctx unassign during device death / removal, not the
  normal associated-STA path (`WARN_ON_ONCE(vif->cfg.assoc)` already
  excludes that).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Logic / correctness** on a teardown path (NULL pointer →
`WARN_ON`).

Verified in `iwl_mld_remove_link()` / `iwl_mld_add_link()` in
`mld/link.c`:
1. `iwl_mld_remove_link()` always does
   `RCU_INIT_POINTER(mld_vif->link[link_id], NULL)` after the FW remove
   attempt.
2. `iwl_mld_add_link()` then talks to FW via `iwl_mld_add_link_to_fw()`.
   On failure it NULLs `mld_vif->link[]` again.
3. `iwl_mld_mac80211_remove_interface()` later calls
   `iwl_mld_remove_link(mld, &vif->bss_conf)`.
4. That function does `if (WARN_ON(!link || link->active)) return;`.

`iwl_trans_send_cmd()` also `WARN_ONCE`s if `trans->state !=
IWL_TRANS_FW_ALIVE`, so the skip can avoid extra warnings while sending
`LINK_CONFIG_CMD` on a dead device.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: same pattern as the existing
  `!mld->fw_status.in_hw_restart` skip.
- Minimal: one extra predicate using `iwl_trans_is_dead()` (present
  since v6.17).
- Regression risk is low: if the transport is dead, FW cleanup cannot
  succeed anyway.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Remove/re-add block introduced in `d1e879ec600f9` (“wifi: iwlwifi: add
  iwlmld sub-driver”, 2025-03-05) → first in **v6.15-rc1**.
- Dead-device check added by this candidate (`1c031ac5a39eb`,
  2026-07-16) → first in **v7.3-rc1**.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy code is the original MLD unassign path,
not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Nearby commits in the same iwlwifi-next pull are unrelated (FTM
abort, WoWLAN validation, mei overflow, etc.). No follow-up on this
exact condition after `1c031ac5a39eb`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ilan Peer is a regular Intel iwlwifi/MLD contributor. The patch
was committed by Miri Korenblit (MLD maintainer).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `iwl_trans_is_dead()` from `11c5cc9ec6d9e` (v6.17-rc1).
  **Present in this 7.3-rc4 tree.**
- Series membership (`14/15`) is packaging only; this hunk does not
  depend on the other 14 patches.
- Standalone: yes.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 1c031ac5a39eb`: https://patch.msgid.link/20260715220243.89a
  0c44a72a3.I45cca8b84a25943d5771199af6b0155dbac77b58@changeid
- Cover: `[PATCH iwlwifi-next 00/15] wifi: iwlwifi: updates -
  07-15-2026` — “Cleanups, features, and fixes from our internal tree.”
- `b4 dig -a`: single v1 series; committed version matches v1. No later
  revision.
- Mbox has 16 messages (cover + 15 patches). **No replies, NAKs, or
  review comments** on this patch.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were Miri Korenblit, Johannes Berg
(`johannes@sipsolutions.net`), `linux-wireless@vger.kernel.org`, Ilan
Peer. Maintainer-acked via Miri’s SOB; no public Reviewed-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by` / bugzilla / syzbot. Looks like an internal
Intel find. Trigger is still concrete (dead transport during unassign).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Mixed 15-patch `iwlwifi-next` dump. This patch is self-contained
(only the unassign condition). Other series items are unrelated
mei/mvm/FTM/debug fixes.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org `/stable/` search blocked by Anubis (403).
**UNVERIFIED:** no confirmed prior stable-list discussion. b4/mbox
showed no `Cc: stable` and no reviewer nomination.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `iwl_mld_unassign_vif_chanctx` (modified). Callees of the
skipped block: `iwl_mld_remove_link`, `iwl_mld_add_link`. Later WARN
site: `iwl_mld_remove_link` from `iwl_mld_mac80211_remove_interface`.

**Step 5.2: TRACE CALLERS**
Record:
- mac80211 op `.unassign_vif_chanctx` (mac80211 core on vif/chanctx
  unbind — ifdown, disconnect, unbind, restart).
- `iwl_mld_switch_vif_chanctx_swap` /
  `iwl_mld_switch_vif_chanctx_reassign` (CSA/channel switch).

**Step 5.3: TRACE CALLEES**
Record: deactivate link, optional monitor sta removal, TLC phy update,
then optional remove/re-add. Remove/re-add issue `LINK_CONFIG_CMD` via
`iwl_mld_send_cmd` → `iwl_trans_send_cmd`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace-reachable: bring down `wlan0`, `rmmod iwlwifi`, PCI
unbind/reset. `STATUS_TRANS_DEAD` is set in `iwl_trans_pcie_reset()`
during PCI removal. Config: `CONFIG_IWLMLD` (BE200+ / Wi-Fi 7).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same function already skips this cleanup on `in_hw_restart`.
`iwl_trans_is_dead()` is already used in `mld/mld.c`
(`iwl_mld_nic_error`). This is the same “don’t talk to a dead transport”
pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c`
`iwl_mld_unassign_vif_chanctx()` contains the remove/re-add path. Bug
present since v6.15; this checkout is 7.3-rc4.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding condition matches the parent of
`1c031ac5a39eb`. Helper `iwl_trans_is_dead()` exists in `iwl-trans.h`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the only “cleanup FW state when the device is dead”
change on this path. `git merge-base --is-ancestor 1c031ac5a39eb HEAD`
is true because this is post-7.3-rc1 mainline; that is source presence,
not a reason to reject on merit.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/net/wireless/intel/iwlwifi/mld/` — Intel Wi-Fi 7
(BE200+) opmode. **IMPORTANT** (not core mm/net, but a widely shipped
wireless driver).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed (frequent MLD commits through 2026). The
buggy unassign cleanup has been there since the MLD introduction.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of Intel MLD devices (`CONFIG_IWLMLD`) with a non-MLO
interface, when the transport dies or the device is removed while a
chanctx is still assigned.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Device removal / PCI reset / unbind / `rmmod` with an active
non-MLO vif. Not every packet path; teardown is still a common
admin/user action. Unprivileged users typically cannot unbind PCI, but
can trigger iface down; the commit’s example is device removal.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: `WARN_ON(!link)` in `iwl_mld_remove_link()` (stack dump,
`TAINT_WARN`; panic if `panic_on_warn`). Possible extra `WARN_ONCE` from
`iwl_trans_send_cmd()` for non-ALIVE state. Not a UAF or data-corruption
bug. **Severity: MEDIUM–HIGH** (WARN_ON on a real teardown path).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Stops a reproducible WARN_ON (and likely extra host-
  command WARNs) on Intel MLD device teardown.
- **Risk:** Very low — one boolean on an already-gated cleanup.
- **Ratio:** Favorable.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real teardown bug with a traced mechanism (failed remove/re-add → NULL
  `link[0]` → `WARN_ON`).
- WARN_ON is an explicit strong-yes class of fix.
- Four-line, obviously correct, same idea as the existing restart skip.
- MLD + `iwl_trans_is_dead()` exist in this 7.3-rc4 tree; patch applies
  cleanly.
- Intel Wi-Fi 7 hardware is in production laptops.

**AGAINST:**
- No public reporter/syzbot/`Fixes:` tag.
- Failure is WARN_ON, not oops/UAF/corruption by default.
- Sent in a mixed `iwlwifi-next` dump, not a dedicated -fixes mail.
- No mailing-list review comments (only maintainer SOB).

**UNRESOLVED:**
- Stable-list history (lore blocked).
- No independent user report found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one predicate; in mainline
   since 7.3-rc1; maintainer SOB.
2. Fixes a real bug that affects users? **PASS** — WARN_ON on
   device/interface teardown for MLD hardware.
3. Important issue? **PASS** — WARN_ON on a reachable removal path (“oh,
   that’s not good” / WARN_ON class).
4. Small and contained? **PASS** — ~4 lines, one function.
5. No new features or APIs? **PASS** — uses existing
   `iwl_trans_is_dead()`.
6. Can apply to the local tree? **PASS** — code and helper are here;
   context matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device-ID/quirk/DT/build/doc exception). It is a
normal small driver bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the MLD unassign path. Skipping FW link recycle when the
transport is already dead prevents a real `WARN_ON` during removal, with
negligible regression risk.

---

## What the commit solves and why it matters here

On non-MLO Intel MLD interfaces, chanctx unassign recycles the FW link
(`remove` + `add`). If the transport is dead, `add` fails and
`mld_vif->link[0]` stays NULL. Interface removal then hits
`WARN_ON(!link)` in `iwl_mld_remove_link()`. Users see a kernel warning
(and a panic if `panic_on_warn` is set) when unbinding or resetting the
Wi-Fi device. This 7.3-rc4 tree includes that MLD code, so the fix
belongs here.

## Stable rules / risk vs benefit

The change is a one-condition skip, already used for HW restart, with no
API or behavior change for live devices. Benefit is avoiding teardown
WARNs on Intel Wi-Fi 7; risk is very low.

## Concerns

No `Fixes:`/`Reported-by`, and it rode in a mixed next-tree series.
Neither undercuts the code-level bug. Prerequisite `iwl_trans_is_dead()`
is already in this tree. No backport rework needed.

---

## Verification
- **[Phase 1]** Parsed tags: author Ilan Peer, SOB Miri Korenblit,
  msgid.link; no Fixes/Reported-by/Cc-stable.
- **[Phase 2]** Diff: +4/−2 in `iwl_mld_unassign_vif_chanctx`; adds
  `!iwl_trans_is_dead(mld->trans)`.
- **[Phase 2]** `iwl_mld_remove_link` always NULLs `mld_vif->link[]`;
  `iwl_mld_add_link` NULLs it again if `iwl_mld_add_link_to_fw` fails;
  `iwl_mld_remove_link` WARNs on NULL.
- **[Phase 2]** `iwl_trans_send_cmd` WARNs if `trans->state !=
  IWL_TRANS_FW_ALIVE`.
- **[Phase 3]** `git blame`: remove/re-add from `d1e879ec600f9`
  (v6.15-rc1); fix is `1c031ac5a39eb` (v7.3-rc1).
- **[Phase 3]** `git describe --contains --match 'v*'`: MLD
  `v6.15-rc1~...`; helper `11c5cc9ec6d9e` in `v6.17-rc1`; this commit
  `v7.3-rc1~...`.
- **[Phase 3]** `git merge-base --is-ancestor 1c031ac5a39eb HEAD` →
  ancestor (expected on 7.3-rc4).
- **[Phase 4]** `b4 dig -c`: lore/msgid thread; `-a`: v1 only; `-w`:
  Johannes Berg + linux-wireless; `-m`: 16 msgs, no replies/NAKs.
- **[Phase 4]** Cover letter: mixed “updates” series 14/15; this patch
  listed under Ilan Peer.
- **[Phase 4]** lore `/stable/` search: UNVERIFIED (Anubis 403).
  WebFetch lore: 403.
- **[Phase 5]** Callers: mac80211 `.unassign_vif_chanctx`, plus two
  `switch_vif_chanctx_*` helpers. Teardown via
  `iwl_mld_mac80211_remove_interface`.
- **[Phase 5]** `STATUS_TRANS_DEAD` set in `iwl_trans_pcie_reset()`
  (`pcie/gen1_2/trans.c`).
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: **v7.3-rc4 /
  7.3.0-rc4**. Buggy MLD file present. `iwl_trans_is_dead()` present at
  `iwl-trans.h:1127`.
- **[Phase 8]** Failure mode: `WARN_ON(!link)` on iface removal after
  dead-transport unassign; severity MEDIUM–HIGH.
- **UNVERIFIED:** Prior discussion on the stable mailing list.

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 5234229a070a7..4ea2d45d71e4e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -1113,11 +1113,13 @@ void iwl_mld_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	RCU_INIT_POINTER(mld_link->chan_ctx, NULL);
 
 	/* in the non-MLO case, remove/re-add the link to clean up FW state.
-	 * In MLO, it'll be done in drv_change_vif_link
+	 * In MLO, it'll be done in drv_change_vif_link.
+	 * Do not do so during restart or in case the device is dead.
 	 */
 	if (!ieee80211_vif_is_mld(vif) && !mld_vif->ap_sta &&
 	    !WARN_ON_ONCE(vif->cfg.assoc) &&
-	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart) {
+	    vif->type != NL80211_IFTYPE_AP && !mld->fw_status.in_hw_restart &&
+	    !iwl_trans_is_dead(mld->trans)) {
 		iwl_mld_remove_link(mld, link);
 		iwl_mld_add_link(mld, link);
 	}
-- 
2.53.0

