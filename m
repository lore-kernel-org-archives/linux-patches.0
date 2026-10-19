Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0481F5087FD;
	Mon, 19 Oct 2026 13:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418167; cv=none; b=uHKdgxIg/476koU+aPVYrfex4LGZNuy2y9PtXMHotNHKFuI9LltsvHLmekg28Zx6oZ09FVN0fBvs0vHH+edKgu+jPuaPwstS4vPjAxER6imOZBZ9Ji2zaocW80FiNcktT8ESHN6BYsbLTJshuIfTt17VVFv5R68n5n9usAdxXck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418167; c=relaxed/simple;
	bh=CVm7uD/Hf/UEIITKGTXusvvMtbFTFyxCZbvY7JC18js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1+4gT0g9rqaN3hOTLiJt+VgPlHgGmEzYco+X2zqb94GJSwkLucrIysgGXIVNpr8ZImCGHsjwjo67dM7xGKwPOBbEofe020lJsfAEDQsmTXex3IwI7svD9x4U+dSK49rbl7gKiaegvjWERweW4RVbE0xlYXkfWpFpq4Q6tYturQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XDM3fgyy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XDM3fgyy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AD31F000C4;
	Mon, 19 Oct 2026 13:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418162;
	bh=tkjY0osqp2/Vm2Opt0bHibUbVAjdzGYrtqr88weKT2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XDM3fgyywyz9ySxAC7Zf0iN6yomJ0JXNM7LRHE8LGhjL4J40ER8DsiucBOAJC/Rn9
	 7ZCccVRS0aL+gJxKB7y5V29Gj9wcTul+zF6+yYrIPl2jAoQju+HAO8FMJTO7SY3aYq
	 HRCctoKhsMjgOXxMQORupEtsFlGZa7VZjhhAHddgFqRfjaaVnZI7gjOHD5GsncwrI9
	 6vXNpfAhqiP6TPjbCy17rqNeisVse5yBZ5K0g7qZWFJGyqFCF4RPxmpGplKH6sFFFU
	 cBsoVH3JzHyCd0CBjSlMLnmA2LknOIM8LoQOKammlbDB4Uj5qD+R2jKuZABHVr/cyk
	 K1z/u8lNXr73Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: support TTL platform device ID
Date: Mon, 19 Oct 2026 09:45:47 -0400
Message-ID: <20261019135441.1420968-56-sashal@kernel.org>
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

From: Miri Korenblit <miriam.rachel.korenblit@intel.com>

[ Upstream commit 3bff0d12c36247073fca976498b58a940fca72dc ]

Add support for a new device ID that we will have on TTL (sc2).

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20260714165826.46183446954f.Icc260831e530c1c92c9be615a7077768b1b9ae30@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The change
is a one-line PCI ID add for existing iwlwifi Sc/sc2 support. That is
the stable device-ID exception, so the rest of this write-up is the
forensic checklist behind a **YES**.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iwlwifi / wifi] [support] [add PCI device ID for TTL (sc2)
platform]**

- Subsystem: `wifi: iwlwifi`
- Verb: **support** (hardware enablement, not a crash fix)
- Intent: bind iwlwifi to a new Intel platform PCI ID

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Reviewed-by:** Johannes Berg `<johannes.berg@intel.com>` (iwlwifi
  maintainer)
- **Link:** `https://patch.msgid.link/20260714165826.46183446954f.Icc260
  831e530c1c92c9be615a7077768b1b9ae30@changeid`
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (author)
- No **Fixes:** tag (expected; this is not a regression fix)
- No **Cc: stable** (expected for this review path)
- No **Reported-by**, **Tested-by**, **Acked-by**, syzbot, or bugzilla
  tags
- Ignore pipeline **Signed-off-by: Sasha Levin** / **[Upstream commit
  ...]** (none present on the real commit `3bff0d12c36247`)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug/problem:** Driver does not claim PCI device `0x9327`, so TTL
  (sc2) Wi-Fi does not bind.
- **Symptom:** iwlwifi never probes; no wireless interface on that SKU.
- **Version info:** none in the message. Author date 2026-07-14; landed
  as `v7.2-rc1-199-g3bff0d12c3624`.
- **Root cause (author):** missing PCI ID in `iwl_hw_card_ids` for
  hardware “we will have on TTL (sc2).” Same wording as the earlier RZL
  ID commit (`6a1b633fdcd904`).

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a hidden leak/race/UAF.** It is an explicit new-PCI-ID
addition. That is an allowed stable exception, not a disguised memory-
safety fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/net/wireless/intel/iwlwifi/pcie/drv.c` (**+1 / -0**)
- Function/data: `iwl_hw_card_ids[]` (PCI ID table)
- Scope: **single-file surgical**, one table entry

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** Sc block lists `0xE440`, `0xE340`, `0xD340`, `0x6E70`,
  `0xD240` with `iwl_sc_mac_cfg`. `0x9327` does not match;
  `iwl_pci_driver.id_table` does not bind.
- **After:** `{IWL_PCI_DEVICE(0x9327, PCI_ANY_ID, iwl_sc_mac_cfg)}` is
  added. Probe is `iwl_pci_probe()` → `iwl_pci_gen1_2_probe()` with
  existing Sc MAC config.
- Path affected: **PCI enumeration / driver bind** for that device ID
  only.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / device ID addition]**
- Macro expands to Intel vendor, device `0x9327`, any
  subvendor/subdevice, `driver_data = iwl_sc_mac_cfg`.
- Newer iwlwifi devices are identified from HW RF/MAC registers via
  `iwl_pci_find_dev_info()`; Sc IDs are not duplicated as `DEVICE(0x…)`
  in `iwl_dev_info_table`. FM/WH/PE RF entries already exist. Same
  pattern as `0xD240`.
- `MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids)` updates userspace modalias
  matching.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** Obviously correct; identical to neighboring Sc IDs.
- **Regression risk:** Very low. Only PCI `8086:9327` is affected. Wrong
  ID would only mis-bind another Intel function using that ID (Intel
  assigns these IDs).
- No API, locking, or data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Line adding `0x9327`: commit **`3bff0d12c36247`** (Miri Korenblit,
  2026-07-14).
- Surrounding Sc IDs: `c96a36491003d7` (2025-05-08) and `6a1b633fdcd904`
  (RZL `0xD240`, 2025-06-12).
- `iwl_sc_mac_cfg` and Sc support are long-lived in this 7.3 tree, not
  last-month code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Not introduced by a buggy prior commit; the
ID was simply absent.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Related: `6a1b633fdcd904` “support RZL platform device ID” (same one-
  line pattern).
- `5f88b045d959f` “pcie: add two LNL PCI IDs”.
- No later `-S 0x9327` follow-up; the ID was not corrected or reverted.
- Nearby series mates (compile-time hcmd check, FCS d3 fix, etc.) do
  **not** touch this table entry.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Miri Korenblit is a regular iwlwifi author (often applying Intel
wireless patches). Johannes Berg reviewed this ID add. Same author wrote
the RZL ID add.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `iwl_sc_mac_cfg` and the Sc PCI block — **present** in this tree
  (`cfg/sc.c`, `iwl-config.h`, `drv.c`).
- sc2 firmware prefixes `IWL_SC2_A_FM_C_FW_PRE` /
  `IWL_SC2_A_WH_A_FW_PRE` and `IWL_CFG_MAC_TYPE_SC2` are already here;
  MAC type is read from CSR at runtime, not from this PCI ID.
- **Standalone:** one line; does not need the other 14 patches from the
  07-14-2026 series.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 3bff0d12c36247`: **[PATCH v2 iwlwifi-next 04/15] wifi:
  iwlwifi: support TTL platform device ID**
- URL: `https://patch.msgid.link/20260714165826.46183446954f.Icc260831e5
  30c1c92c9be615a7077768b1b9ae30@changeid`
- `b4 dig -a`: v2 of “wifi: iwlwifi: updates - 07-14-2026”. Cover
  letter: v2 was a resend so -next contained an unrelated compile fix
  for a sibling patch. **This ID hunk did not change between versions.**
- Thread mbox: **16 messages, all series patches**; no NAKs, no public
  review replies, no `Cc: stable` discussion on this patch.
- Cover letter: “Usual fixed, cleanups and **features** from our
  internal tree.” This ID add is listed under Miri’s patches, not as a
  CVE/crash fix.
- WebFetch to lore.kernel.org returned **403**; discussion recovered via
  `b4 dig -m`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc **Johannes Berg**, **linux-
wireless@vger.kernel.org**. **Reviewed-by: Johannes Berg** already on
the sent patch (internal review). Right maintainer and list.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by / bugzilla / syzbot. This is vendor hardware
enablement, not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 15-patch **iwlwifi-next** “updates” mix (validations, recovery,
LARI v14, UHR DBE). **04/15 is independent.** Other patches are not
required for this ID to apply or work.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch **403**. `b4` thread has **no**
stable-list discussion. **UNVERIFIED** whether anyone later nominated it
on stable@.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function body edited. Data: **`iwl_hw_card_ids[]`**.
Consumers: `MODULE_DEVICE_TABLE`, `iwl_pci_driver.id_table`, probe
`iwl_pci_probe()`.

**Step 5.2: TRACE CALLERS**
Record:
- `iwl_pci_register_driver()` registers `iwl_pci_driver` with `.id_table
  = iwl_hw_card_ids`.
- PCI core calls `iwl_pci_probe()` on match.
- Context: process/probe, not IRQ. Common path **only if** device
  `8086:9327` is present.

**Step 5.3: TRACE CALLEES**
Record: Probe enables PCI, maps BAR0, reads `CSR_HW_REV`, calls
`iwl_pci_gen1_2_probe(..., iwl_sc_mac_cfg, ...)`. Device family
`IWL_DEVICE_FAMILY_SC` is already used by other Sc IDs.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: PCI enumerates → id_table match → `iwl_pci_probe` → gen1/2
trans/op-mode → firmware via existing sc/sc2 names. **Reachable from
userspace** only by having the hardware (or VFIO/passthrough of that
ID). Not a syscall fuzz path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same one-line Sc ID adds (`0xD240` RZL). No extra
`IWL_DEV_INFO(DEVICE(0x9327))` for other Sc IDs either.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `drivers/net/wireless/intel/iwlwifi/pcie/drv.c` Sc
block and `iwl_sc_mac_cfg` exist. Without this ID, `0x9327` is
unmatched. sc2 (`IWL_CFG_MAC_TYPE_SC2` / `iwlwifi-sc2-a0-*`) already
exists. Bug/gap is “missing ID,” not missing subsystem.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Neighboring lines match the candidate diff. No
refactor needed on 7.3-rc4.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No alternate TTL ID fix. `0x9327` appears only from this commit.
Prerequisite Sc/sc2 stack is already in 7.3.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/net/wireless/intel/iwlwifi** — **IMPORTANT** (very
common laptop/desktop Wi-Fi), not mm/core. Only TTL/sc2 SKUs with this
ID.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: **Active** (regular Intel iwlwifi-next dumps). ID tables are
still the supported way to enable new SKUs; this is not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / hardware-specific.** Users with Intel Wi-Fi
PCI `0x9327` (TTL/sc2). Everyone else: no behavior change.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot or hotplug of that device. Common **on that platform**,
never otherwise. Unprivileged users cannot trigger it without the
hardware. **UNVERIFIED** whether TTL has shipped at evaluation time;
Intel’s “we will have” language matches prior RZL ID adds.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **No oops/UAF/corruption.** Failure is **Wi-Fi never binds** on
that SKU. Severity for those users is **HIGH** (device unusable); global
severity **LOW**. Stable still takes these ID adds.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Enables existing iwlwifi/Sc/sc2 on TTL platforms that
  this tree already knows how to drive.
- **Risk:** **Very low** (1 line, existing cfg pointer, isolated PCI
  match).
- **Ratio:** Benefit/risk favors taking it.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Canonical **new PCI ID on an existing driver**
- 1 line, same as other Sc IDs and RZL
- `iwl_sc_mac_cfg`, sc2 firmware names, RF matching already in this tree
- Maintainer Reviewed-by (Johannes Berg)
- `MODULE_DEVICE_TABLE` so autoload works
- Standalone; no series dependency
- Zero impact on other devices

AGAINST:
- Not a crash/security/corruption fix; iwlwifi-next “features” series
- Future-tense “we will have”; shipping status unverified
- No stable@ nomination in the thread
- Mixed 15-patch series (this patch itself is still self-contained)

UNRESOLVED:
- lore.kernel.org HTTP 403 (mailbox recovered via b4)
- No stable@ thread found
- Whether TTL silicon is in users’ machines yet

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one table row, maintainer
   Reviewed-by.
2. Fixes a real bug that affects users? **PASS** — missing ID means the
   driver never attaches (real for that SKU).
3. Important issue (crash, security, corruption, deadlock)? **FAIL** as
   crash/security; **PASS** under the documented **device-ID
   exception**.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — no new API; only an ID on
   existing probe/config.
6. Can apply to the local tree? **PASS** — Sc/sc2 and `iwl_sc_mac_cfg`
   are here; hunk applies cleanly.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **NEW DEVICE ID (PCI) to an existing driver.** Driver already
exists; only `0x9327` is new. Same class as “drm/i915: Add new device ID
for Raptor Lake.”

**Step 9.4: MAKE YOUR DECISION**
This tree already has iwlwifi Sc/sc2. Adding PCI ID `0x9327` is the
standard, low-risk way to make TTL hardware work. It should be taken for
this tree.

### What it solves and why it matters here
Without the ID, PCI `8086:9327` never matches `iwl_pci_driver`, so Wi-Fi
stays down on TTL (sc2) even though this kernel already has
`iwl_sc_mac_cfg` and sc2 firmware naming. That is exactly the hardware-
enablement stable trees routinely accept.

### Stable rules
Small, correct, no new APIs, applies here. Importance is “device works,”
via the PCI-ID exception, not a KASAN-class bug.

### Risk vs benefit
Risk is a single ID match. Benefit is working wireless on that Intel
SKU. Other machines are unchanged.

### Concerns
None that block a backport here: no missing prerequisites, no extra
`IWL_DEV_INFO` needed (other Sc IDs have none), no follow-up fix to
`0x9327`. Firmware blobs remain a linux-firmware concern, not a reason
to omit the ID.

Verification:
- [Phase 1] Subject/tags: support new ID; Reviewed-by Johannes Berg;
  Link msgid; no Fixes/stable/syzbot
- [Phase 1] Body: “new device ID that we will have on TTL (sc2)”
- [Phase 2] Diff: +1 line in `iwl_hw_card_ids[]` under Sc devices:
  `0x9327` → `iwl_sc_mac_cfg`
- [Phase 2] `IWL_PCI_DEVICE` → Intel vendor + `MODULE_DEVICE_TABLE` +
  `iwl_pci_driver.id_table`
- [Phase 2] Other Sc IDs also lack `DEVICE(0x…)` in
  `iwl_dev_info_table`; FM/WH matching already present
- [Phase 3] `git describe HEAD` / Makefile: **7.3.0-rc4**
  (`v7.3-rc4-27-gf0100363d8c37`)
- [Phase 3] `git blame`: `0x9327` is `3bff0d12c36247`; neighbors
  `c96a36491003d7` / `6a1b633fdcd904`
- [Phase 3] `git merge-base --is-ancestor 3bff0d12c36247 HEAD` → yes;
  `git describe 3bff0d12c36247` → `v7.2-rc1-199-g3bff0d12c3624`
- [Phase 3] `git log -S 0x9327 -- drv.c` → only this commit (no later
  correction)
- [Phase 3] RZL analog `6a1b633fdcd904` is the same one-line pattern
- [Phase 4] `b4 dig -c/-a/-w/-m`: v2 iwlwifi-next 04/15; Johannes +
  linux-wireless; no NAK; v2 resend unrelated to this hunk
- [Phase 4] Cover letter: mixed fixes/cleanups/features; this ID listed
  under Miri
- [Phase 4] UNVERIFIED: lore HTTP 403; no stable@ thread retrieved
- [Phase 5] Callers: PCI probe via `iwl_pci_probe` →
  `iwl_pci_gen1_2_probe`; sc2 MAC type from CSR (`iwl-drv.c`)
- [Phase 6] `iwl_sc_mac_cfg` in `cfg/sc.c`; sc2 FW prefixes present;
  hunk context matches
- [Phase 6] Apply difficulty: clean
- [Phase 7] iwlwifi: important, actively maintained
- [Phase 8] Failure: no driver bind on `0x9327`; risk very low
- UNVERIFIED: whether TTL hardware is already shipping

**YES**

 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 0e8481219839b..4314d95dd12af 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -548,6 +548,7 @@ VISIBLE_IF_IWLWIFI_KUNIT const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0xD340, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0x6E70, PCI_ANY_ID, iwl_sc_mac_cfg)},
 	{IWL_PCI_DEVICE(0xD240, PCI_ANY_ID, iwl_sc_mac_cfg)},
+	{IWL_PCI_DEVICE(0x9327, PCI_ANY_ID, iwl_sc_mac_cfg)},
 #endif /* CONFIG_IWLMVM || CONFIG_IWLMLD */
 
 	{0}
-- 
2.53.0

