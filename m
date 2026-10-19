Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621BC60DC75;
	Mon, 19 Oct 2026 14:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418619; cv=none; b=K/WSZm0DqqiJxRd1UA82KVOjR95Gpp9dfFDryfc2xBQ7JlkW8AnUzPaORJ0XWGR6xGvusDUWW1gDmTqQjRGNvrT0wdfrz/OutUNck0ENeNMhEUVuoGmkId2T94SRZG42KQu49kiOLDe95yE5CZGWjY2j1ErwP1QPcOVXNUWGpDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418619; c=relaxed/simple;
	bh=vk2hjEXDnur/2vaPN9bfPfxK1ab0eSIhrLVNs+sCEvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUgs2YP12HAd+0mHtG/QcoE64Xy78USdsAetAESSWC6+27EszVbp8HrgkMPr7OgkB2TuCN9EpnbaeSlk8LiOaHnK2q5eRIxKbZfvORSIdXzfasJ6fWhluUNE577dFpIjddfBiQyfpsc6XM8cw8C18Shbyf6bLPb6CpfDEOP6sA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RyLLX8d6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RyLLX8d6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC081F000C5;
	Mon, 19 Oct 2026 14:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418616;
	bh=DGz/pA8p8YxKO1h+kYZhjDaXY/1B0WDV1cQFe7P6AGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RyLLX8d6OvpxTPELl90Gyk48MMEJh9nQNSuFxFpv/nTy0j900+fJswmFUTmo0WxEz
	 Xrl8Xe1AkzGXOH6F+zPlK4Mo/HYCQ24ZFW9nSPqgwRe5FfT0Hf1TjPn4j9iwZ5nzRA
	 RitcIM1EwHZijaybUKeVfhXHZP2gygXCji3uIz5ZEtj56IXtwKWtZuJ2aMEO0Bt7bj
	 DKoLqnmnju8vu7kUy+MWk8XIGGCDfEbEYb9T4f74YYykXnhoqVmd5JnGMpN4bjM3hN
	 3msITKIQ3RyjcHb0L6hBMqFmNE7i0vakPG3ot3WMZmikappEKQZq+IML6+VwNxbm2i
	 Plae9ck/DCz+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: reset the driver state upon firmware recovery
Date: Mon, 19 Oct 2026 09:51:06 -0400
Message-ID: <20261019135441.1420968-375-sashal@kernel.org>
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

[ Upstream commit 71ac392d8b5c23c45c66f30eff1c319580ada4da ]

Just like we did in iwlmvm, we also need to clear the mld state when the
firmware was killed because of the device being powered off during
suspend.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714165826.ff1c9e05e0a9.I8df8d4a0384065fd2a32cf258339be77084c55bd@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough of the tree, the sibling mvm fix, and the lore series to
judge this on merit. Writing the full phase-by-phase analysis next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iwlwifi/mld] [reset] [clear MLD driver state when firmware is
killed because the device was powered off during suspend]**

- Subsystem: `wifi: iwlwifi: mld`
- Action verb: **reset** (correctness / recovery, not a feature)
- Intent: after firmware recovery from a power-off-during-suspend, wipe
  MLD software state the same way `iwlmvm` already does

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record (from `git show 71ac392d8b5c2`):
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** none on the commit itself
- **Acked-by:** none
- **Link:** `https://patch.msgid.link/20260714165826.ff1c9e05e0a9.I8df8d
  4a0384065fd2a32cf258339be77084c55bd@changeid`
- **Cc: stable:** none (not a negative signal)
- **Signed-off-by:** Emmanuel Grumbach (author); Miri Korenblit (iwlwifi
  maintainer)
- Ignore pipeline markers: none present on the original commit

Notable: Intel iwlwifi developers; maintainer SOB; no syzbot/user
reports.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** When firmware is killed because the NIC was powered off in
  suspend, MLD driver state is left as if the firmware were still
  configured.
- **Symptom:** After that resume path, software
  IDs/keys/scan/FTM/internal STAs no longer match a freshly started
  firmware image. Connection/recovery after suspend can fail; later FW
  commands can error or WARN.
- **Version info:** none in the message. Analog is explicit: “Just like
  we did in iwlmvm”.
- **Root cause (author):** `device_powered_off` stopped firmware
  (`iwl_mld_stop_fw`) and cleared `in_d3`, but never ran the existing
  restart cleanup that zeros restart-sensitive state and walks
  vifs/stations.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not disguised.** It is a real recovery-path correctness fix.
“Reset the driver state” is the missing counterpart of
`iwl_mld_restart_cleanup()` already used from `iwl_mld_mac80211_start()`
when `in_hw_restart` is set. The mvm sibling (`0a00c3ec2db76`) states
the same problem more clearly: after power-off, firmware must be
reloaded **and reconfigured**.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**

Record:
- `drivers/net/wireless/intel/iwlwifi/mld/mac80211.c`:
  `iwl_mld_restart_cleanup` un-static’d (`static void` → `void`) — **3
  +/− lines net**
- `drivers/net/wireless/intel/iwlwifi/mld/mac80211.h`: export prototype;
  copyright year — **+2**
- `drivers/net/wireless/intel/iwlwifi/mld/mld.c`: one call
  `iwl_mld_restart_cleanup(mld);` in `iwl_mld_device_powered_off` —
  **+1**
- Totals: **+4 / −2**, three files, one function body unchanged
- Scope: **single-subsystem, surgical**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Hunk 1 (`mac80211.c`): `iwl_mld_restart_cleanup` still does
`iwl_cleanup_mld` → iterate vifs (`iwl_mld_cleanup_vif`) → iterate
stations (`iwl_mld_cleanup_sta`) → `iwl_mld_ftm_restart_cleanup`. Only
linkage changes (now callable from `mld.c`).

Hunk 2 (`mac80211.h`): prototype so `mld.c` can call it. `mld.c` already
includes `mac80211.h`.

Hunk 3 (`mld.c` `iwl_mld_device_powered_off`, `CONFIG_PM_SLEEP`):

**Before:**
```
wiphy_lock
iwl_mld_stop_fw(mld)   // abort waits, stop device, fw_status.running =
false
in_d3 = false
wiphy_unlock
```

**After:** same, plus `iwl_mld_restart_cleanup(mld)` between stop_fw and
clearing `in_d3`.

Path: PCI resume when scratch/MAC grab shows the device was powered off
(`iwl_op_mode_device_powered_off` from `pcie/drv.c`). Not the happy
wowlan-keep-alive path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Logic / correctness — stale driver state after firmware
death]**

Without cleanup, `iwl_mld_mac80211_start` sees `in_d3 == false`, skips
D3 resume, and calls `iwl_mld_start_fw()` **without**
`iwl_mld_restart_cleanup()`. Firmware is empty; driver still holds:
- `zeroed_on_hw_restart` groups (phy, scan, iface, link, sta, txq)
- firmware station IDs / internal STAs
- keys
- FTM initiator request

`iwl_mld_cleanup_vif` frees internal STAs and keys; skipping it on this
path is a leak plus ID mismatch. Category is **incomplete error/recovery
handling**, not a new feature.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** reuses the function already used on HW restart;
  mvm does the same from `iwl_op_mode_mvm_device_powered_off`
  (`iwl_mvm_restart_cleanup`).
- **Minimal:** one call + un-static.
- **Regression risk low:** already runs under `wiphy_lock` from
  `iwl_mld_mac80211_start`; `device_powered_off` already takes
  `wiphy_lock`. Cleanup is largely idempotent (`CLEANUP_STRUCT` memset,
  `sta_id != IWL_INVALID_STA` guards). FTM abort on a dead NIC during
  resume is appropriate.
- **Redundant** `in_d3 = false` after `iwl_cleanup_mld` also clears it —
  harmless.
- No public API / data-structure change except making an existing helper
  non-static.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Buggy `iwl_mld_device_powered_off` introduced in **`d1e879ec600f9`**
  (`wifi: iwlwifi: add iwlmld sub-driver`, 2025-03-05; that commit’s
  Makefile is **6.14.0-rc4**).
- Merged to this lineage via `c73ebc0dbb6ed` (`iwlwifi-
  next-2025-06-25`).
- Intermediate: `7aeec8c8d63bf` removed `system_pm_mode` assignment;
  still no cleanup.
- `iwl_mld_restart_cleanup` existed as **static** since MLD
  introduction; this commit only exports it.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Bug is original MLD `device_powered_off`
(omit cleanup). Target `d1e879ec600f9` **is** an ancestor of this tree
(`git merge-base --is-ancestor`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- **`71ac392d8b5c2`** — this fix (in tree)
- **`0a00c3ec2db76`** — mvm analog, same day/author/series (14/15 vs
  15/15)
- **`1c031ac5a39eb`** — later “do not cleanup FW state when device is
  dead”; **different path** (chanctx unassign / NULL link), not a revert
  of this call
- **`c99bc4d4e0ba6`** — cancel wiphy work before free (same series,
  08/15); not a prerequisite for this hunk

Standalone: no other series patch is required for this one-line call.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Emmanuel Grumbach is a long-time Intel iwlwifi developer. Same-
day pair: mvm cleanup + this MLD mirror. Maintainer Miri Korenblit SOB’d
both. Weight: **high**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `iwl_mld_restart_cleanup`, `iwl_mld_device_powered_off`,
MLD op_mode — all present since MLD add. `mld.c` already `#include
"mac80211.h"`. **Applies standalone** on this tree.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 71ac392d8b5c2` → **https://patch.msgid.link/20260714165826.
  ff1c9e05e0a9.I8df8d4a0384065fd2a32cf258339be77084c55bd@changeid**
- **v2**, `[PATCH v2 iwlwifi-next 15/15]`; v2 cover: resend so next
  contains an unrelated compile fix (`too long hcmds`), **not** a
  redesign of this patch
- Cover: “Usual fixed, cleanups and features from our internal tree.”
  This commit listed under Emmanuel’s fixes.
- Saved mbox: **16 messages, all series posts, zero review replies /
  NAKs / Cc: stable**
- lore.kernel.org / patch.msgid.link HTTP fetch: **403** — discussion
  taken from `b4 dig -m` mbox instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc **Johannes Berg**, **linux-
wireless@vger.kernel.org**, Miri Korenblit, Emmanuel Grumbach. No
Reviewed-by on 15/15 (several other series patches have Johannes R-b).
Applied via iwlwifi-next (`905b418df8af2`, 2026-07-23). Maintainer-tree
merge is the review signal.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No user/syzbot/bugzilla report.** Bug is reasoned from the mvm
gap. Severity from code: stale FW IDs after D3cold/hibernate-style
power-off — WiFi may not come back cleanly.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 15-patch iwlwifi-next dump. **14/15 is the mvm twin**
(independent). This patch does **not** depend on 01–13. Mix of features
and fixes; this hunk is a self-contained fix.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: Web search found **other** iwlwifi MLD restart patches in stable
(e.g. “stop TX during firmware restart” for 6.18/7.0). **No hit** for
this subject on stable@. UNVERIFIED: whether anyone already nominated
this exact commit for older -stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `iwl_mld_restart_cleanup` (export), `iwl_mld_device_powered_off`
(call site). Unchanged callees: `iwl_cleanup_mld`,
`iwl_mld_cleanup_vif`, `iwl_mld_cleanup_sta`,
`iwl_mld_ftm_restart_cleanup`.

**Step 5.2: TRACE CALLERS**

Record:
- `iwl_mld_restart_cleanup`: `iwl_mld_mac80211_start` (if
  `in_hw_restart`); **now** `iwl_mld_device_powered_off`
- `iwl_mld_device_powered_off`: op_mode `.device_powered_off` →
  `iwl_op_mode_device_powered_off` → **`_iwl_pci_resume`** in
  `pcie/drv.c` when restore or scratch says powered off
- Context: **PM resume**, process context, already holds `wiphy_lock`
- Reachable on Intel WiFi 7 / MLD laptops that D3cold the NIC or
  hibernate

**Step 5.3: TRACE CALLEES**

Record: stop_fw (trans stop, abort waits); cleanup zeros restart groups;
frees internal STAs/keys; may call
`ieee80211_remain_on_channel_expired`; FTM reports failure to cfg80211.
Side effects are the intended reset.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: **Userspace-reachable** via suspend/resume (and hibernate), not
a syscall bug. Trigger is common on laptops that cut WiFi power.
Unprivileged users typically cannot force PCI D3cold, but they **do**
suspend.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: **Exact mvm analog** `0a00c3ec2db76` — same author, same series.
Pattern is systematic (mvm had the cleanup; mld was missed at
introduction).

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`**,
  `make kernelversion` = **7.3.0-rc4**
- MLD files present under `drivers/net/wireless/intel/iwlwifi/mld/`
- **`git merge-base --is-ancestor 71ac392d8b5c2 HEAD` succeeds** — this
  fix is **already in this checkout**
- Pre-fix body (parent of 71ac392d8b5c2) had `device_powered_off`
  without cleanup; current `mld.c:750` has the call
- Bug introduced with MLD (`d1e879ec600f9`, ~6.14 development / 2025);
  **not** after 7.3 branched

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply** on this tree (already applied). Context around
`iwl_mld_device_powered_off` matches the candidate diff. No conflicting
refactor.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This fix **is** here. mvm analog **is** here. No earlier
different MLD-powered-off cleanup. Follow-up `1c031ac5a39eb` is
unrelated chanctx/dead-device WARN, not a replacement.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **iwlwifi MLD** (`CONFIG_IWLMLD`) — Intel Wi-Fi 7 / MLO devices.
**IMPORTANT** (very common laptop NIC), not core mm/VFS. Affects all
IWLMLD users on PM sleep.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: **Active** (regular iwlwifi-next pulls). Bug is an original
omission in a still-young op_mode (~1.5 years), not bitrot in abandoned
code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific + config-specific:** `CONFIG_IWLWIFI` +
`CONFIG_IWLMLD` + `CONFIG_PM_SLEEP`. Intel BE200/BE201-class Wi-Fi 7.
Population is large for a driver fix.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: resume after the transport decides the device was powered off
  (scratch bits, 0xFFFFFFFF, or failed NIC grab) — **hibernate, D3cold,
  some s2idle**
- Not every suspend (wowlan-alive path skips this)
- Not a userspace exploit path
- Timing: deterministic once the platform cuts power

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure:** driver/firmware state desync after resume; commands with
  stale IDs; possible internal-STA/key leak; FTM requests left hanging;
  Wi-Fi may not recover without reload
- Not shown as oops/UAF/CVE in the message (UNVERIFIED as crash)
- **Severity: HIGH** for affected hardware (broken Wi-Fi after suspend),
  **not CRITICAL** (no verified panic/corruption)

Stable-rules fit: **“oh, that’s not good”** / hardware resume quirk, not
theoretical.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit: high** for IWLMLD + PM — resume actually reconfigures like
  mvm
- **Risk: very low** — +1 call to existing helper, same lock as start
  path
- **Ratio: strongly favorable**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting to this 7.3 tree:**
- Real resume bug: firmware stopped, MLD software state not reset
- Same fix already proven in mvm (`0a00c3ec2db76`)
- Tiny, obviously correct; helper already used on HW restart
- Intel Wi-Fi 7 is common; suspend/resume is a user-facing path
- MLD and the buggy function exist in this tree; no extra prereqs
- Maintainer-tree merge; Johannes on Cc
- Matches stable rule of a real bug that bothers people (Wi-Fi
  dead/wrong after power-off suspend)

**AGAINST:**
- No Reported-by / syzbot / stack trace
- Brief commit message
- 15/15 of a mixed “updates” series, not a dedicated stable submission
- No explicit crash/security
- Power-off-during-suspend is not every resume (wowlan-alive OK)

**UNRESOLVED:**
- Exact user-visible rate (no public bugzilla)
- lore HTTP 403; no on-list NAK found in mbox
- No stable@ discussion of this exact subject

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — mirrors mvm; merged to
   iwlwifi-next/mainline; logic is a single missing call.
2. Fixes a real bug that affects users? **PASS** — stale MLD state vs
   empty firmware after D3cold/hibernate resume.
3. Important issue? **PASS** — user-visible Wi-Fi recovery failure
   (HIGH, not panic). Fits “oh, that’s not good” / resume hardware path.
4. Small and contained? **PASS** — ~4 insertions, one subsystem.
5. No new features or APIs? **PASS** — export existing helper + call it.
6. Can apply to the local tree? **PASS** — code present; patch already
   applies (already in v7.3-rc4).

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: **None** (not a device ID / quirk table / DT / build / docs).
Qualifies as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**

This tree is **7.3.0-rc4**. The MLD `device_powered_off` path exists
here and omitted restart cleanup until `71ac392d8b5c2`. The commit is a
4-line, low-risk fix for a real suspend/resume correctness bug on Intel
MLD hardware. It should be in this tree’s stable stream.

### What the commit solves (for 7.3 users)

On PCI resume, if the NIC was powered off, MLD only stopped firmware and
cleared `in_d3`. `iwl_mld_mac80211_start` then did a cold
`iwl_mld_start_fw()` **without** `iwl_mld_restart_cleanup()`, so
firmware IDs, keys, scan, and internal STAs stayed live in software. Wi-
Fi 7 devices can fail to recover after that suspend. The fix is the same
cleanup mvm already does.

Risk is a single call under the lock already used for restart cleanup.
Benefit is working wireless after D3cold/hibernate on common Intel
hardware.

---

Verification:
- [Phase 1] `git show 71ac392d8b5c2`: subject/tags/body as above; SOB
  Grumbach + Korenblit; Link msgid; no Fixes/Reported-by/Cc stable
- [Phase 2] Diff: un-static `iwl_mld_restart_cleanup`, header prototype,
  +1 call in `iwl_mld_device_powered_off`; +4/−2
- [Phase 2] Parent of commit: `device_powered_off` was stop_fw +
  `in_d3=false` only
- [Phase 2] Current `mld.c:743-753`: call present under `wiphy_lock`
- [Phase 2] `iwl_cleanup_mld` / `iwl_mld_cleanup_vif` /
  `iwl_mld_cleanup_sta` / `iwl_mld_ftm_restart_cleanup` read in tree
- [Phase 3] `git log -L` on `iwl_mld_device_powered_off`: d1e879ec600f9
  → 7aeec8c8d63bf → 71ac392d8b5c2
- [Phase 3] `d1e879ec600f9` Makefile 6.14.0-rc4; ancestor of HEAD
- [Phase 3] `git show 0a00c3ec2db76`: mvm analog same day
- [Phase 3] `git log -S iwl_mld_restart_cleanup -- mld/`: only MLD add +
  this commit
- [Phase 3] `1c031ac5a39eb` is a different chanctx/dead-device WARN, not
  a revert
- [Phase 4] `b4 dig -c/-a/-w/-m`: v2 15/15 iwlwifi-next; recipients
  Johannes + linux-wireless; mbox 16 series mails, no NAK
- [Phase 4] WebFetch lore/msgid: 403; used mbox instead
- [Phase 4] WebSearch stable@: other MLD restart fixes, not this subject
- [Phase 5] `git grep iwl_op_mode_device_powered_off`: `pcie/drv.c:1281`
  from `_iwl_pci_resume` when powered off
- [Phase 5] `mld.c` includes `mac80211.h`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 71ac392d8b5c2 HEAD`: yes
- [Phase 8] Failure mode inferred from code + mvm message (reload
  **and** reconfigure); no crash dump in commit (stated)
- UNVERIFIED: public user reports; whether older LTS without this commit
  would be in scope (out of band — this verdict is 7.3-rc4 only)

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 3 +--
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.h | 2 ++
 drivers/net/wireless/intel/iwlwifi/mld/mld.c      | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
index 27ae06e208402..69a066904a808 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.c
@@ -483,8 +483,7 @@ iwl_mld_mac80211_tx(struct ieee80211_hw *hw,
 	iwl_mld_tx_skb(mld, skb, NULL);
 }
 
-static void
-iwl_mld_restart_cleanup(struct iwl_mld *mld)
+void iwl_mld_restart_cleanup(struct iwl_mld *mld)
 {
 	iwl_cleanup_mld(mld);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
index aad04d7b2617d..f3302997b28f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mac80211.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
  * Copyright (C) 2024 Intel Corporation
+ * Copyright (C) 2026 Intel Corporation
  */
 #ifndef __iwl_mld_mac80211_h__
 #define __iwl_mld_mac80211_h__
@@ -9,5 +10,6 @@
 
 int iwl_mld_register_hw(struct iwl_mld *mld);
 void iwl_mld_recalc_multicast_filter(struct iwl_mld *mld);
+void iwl_mld_restart_cleanup(struct iwl_mld *mld);
 
 #endif /* __iwl_mld_mac80211_h__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 49e46babf8221..cf003a4a37408 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -739,6 +739,7 @@ static void iwl_mld_device_powered_off(struct iwl_op_mode *op_mode)
 
 	wiphy_lock(mld->wiphy);
 	iwl_mld_stop_fw(mld);
+	iwl_mld_restart_cleanup(mld);
 	mld->fw_status.in_d3 = false;
 	wiphy_unlock(mld->wiphy);
 }
-- 
2.53.0

