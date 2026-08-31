Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8654AE8D8;
	Mon, 31 Aug 2026 13:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184134; cv=none; b=pxcgxNIsnzfx+i1ael782obAt2TDc33XZVd2Q5FwSy3I7bTUaCNsouR0N0pjxp1SvbF2lihPpTqL1G9N3KADgkccpEmV6IeQ2EhdkPNr9hH6HmjXFWQjiFVtomSdorGZFsxcAwn6WVkPitgTdueujumONoJ37L91poyvVN2I/AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184134; c=relaxed/simple;
	bh=usQ+555wlzWzlWitzMtRYdHRxVS64XGgOIbEylHWs00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PVkNVYUGCHLb76CcGO2VnkMzlOU1oNoQIhBrxWQS4tXxmER2PSa/b88ObSi3pMDfeUQBKHXdVsSSHQcZGfF0KXlSu9ZHM8k2zhF4QcT7GlMSvfva4uGYvpBMAG7D4fwIuOvJbngRzfpcKmvZJAQZ3o+zShhrXatru2kNRUd/f2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PunhU1+v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PunhU1+v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F7D1F000E9;
	Mon, 31 Aug 2026 13:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184131;
	bh=xnW+UXwVu7hXANiGJYr0xt2sOtYWpffiHMNx1fjqmOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PunhU1+vZWbuTVxJssgTrWEbalGOjG3efk/+/jlrvhKPweClgIZnjbk0cgnI/QKPe
	 0MeZxjUpc3nZPq3uTc6aMXMIZMcQX/Xr/16vqJjCwQls3tlP4SG8Phh7Y5eT2gK6HZ
	 ptKqDnpnGv4i2gB5Uyz7Z5pnGBWcftviO5IYuGPEg7ShwBXejP2ucwpVDBtTkUzCPz
	 vA4GVitYst6VPNRxOXHyk6M/ibMxdVEjIg8QLozdPuae9Dxqt4DpyHRXOtr/IM9RN1
	 8BbuDprO7ZnlOJg3d7f7K8Rx+yDixLUZq2UrdgjdiX1jQUlc/BWCk+5JAjfAxh1TBO
	 2fmcO0yGQDuxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Avinash Bhatt <avinash.bhatt@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: Transition to basic uAPSD with MAC_PM_POWER_TABLE API VER_3
Date: Mon, 31 Aug 2026 09:28:58 -0400
Message-ID: <20260831133314.4125787-510-sashal@kernel.org>
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

From: Avinash Bhatt <avinash.bhatt@intel.com>

[ Upstream commit fc58bb9ecef04aa46f201fc421a16e670b5dc01f ]

uAPSD is transitioning to a certification-only feature. The new
firmware API version 3 removes advanced uAPSD fields, keeping only
basic parameters needed for certification testing.

Support the new VER_3 API in the MLD driver while maintaining
backward compatibility with VER_1/2. The MVM driver continues
using VER_2 only. Remove the obsolete PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION
notification from the MLD driver

Signed-off-by: Avinash Bhatt <avinash.bhatt@intel.com>
Link: https://patch.msgid.link/20260512222731.96b6f53c8708.I4f01b97b25d91ebb1561845d7925103e274574fa@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi]` `[Transition]` — MLD driver support for
`MAC_PM_POWER_TABLE` firmware API version 3, keeping backward
compatibility with VER_1/2.

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Avinash Bhatt <avinash.bhatt@intel.com>`
- `Link: https://patch.msgid.link/20260512222731...`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable@vger.kernel.org`
- Notable: Intel iwlwifi maintainers; no user/fuzzer reports

**Step 1.3 — Body analysis**
Record:
- **Bug described:** Firmware API v3 removes advanced uAPSD fields;
  driver must use a smaller command layout and stop using obsolete
  notification/flags.
- **Symptom:** Driver/firmware ABI mismatch on MLD devices when firmware
  advertises API v3.
- **Root cause:** MLD driver always builds/sends the VER_1/2-sized
  `iwl_mac_power_cmd` and handles
  `PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION`, which v3 firmware no longer
  supports.
- **Version info:** MVM stays on VER_2; only MLD needs v3 handling.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Despite “transition” wording, this is firmware API
compatibility: wrong command size and unsupported flags when firmware
reports `MAC_PM_POWER_TABLE` v3.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 8 files changed (~+200/−60 lines)
- Files: `fw/api/power.h`, `mld/power.c`, `mld/notif.c`, `mld/iface.c`,
  `mld/iface.h`, `mld/mld.c`, `mvm/mvm.h`, `mvm/power.c`
- Functions: `iwl_mld_update_mac_power()`, `iwl_mld_power_build_cmd*()`,
  `iwl_mld_power_configure_uapsd*()`, notification handlers; MVM rename-
  only to `iwl_mac_power_cmd_v2`
- Scope: multi-file, localized to iwlwifi power management

**Step 2.2 — Code flow changes**
Record:
- **Before:** MLD always fills/sends full VER_2 struct via
  `iwl_mld_send_cmd_pdu()` (uses `sizeof(*data)`).
- **After:** `iwl_fw_lookup_cmd_ver(..., MAC_PM_POWER_TABLE, 0)` selects
  v3 (20-byte) or v2 (40-byte) struct; explicit `sizeof` passed to
  `iwl_mld_send_cmd_with_flags_pdu()`.
- **Before:** MLD registers/handles
  `PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION`.
- **After:** Handler/registration removed (obsolete in v3).
- **MVM:** Type rename only; still sends VER_2 struct.

**Step 2.3 — Bug mechanism**
Record: **Logic/correctness + firmware ABI mismatch.** Driver sends
oversized command and sets unsupported flags
(`POWER_FLAGS_SNOOZE_ENA_MSK`, `POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK`)
when firmware expects v3 layout.

**Step 2.4 — Fix quality**
Record: Follows existing iwlwifi version-selection pattern (e.g.
`iwl_phy_cfg_cmd` in `mvm/fw.c`). Minimal risk for v1/v2 firmware.
Moderate duplication (v2/v3 paths). Low regression risk on MVM (rename
only).

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Local repo history is shallow; blame on
`iwl_mld_update_mac_power()` not useful for introduction date. MLD
`power.c` copyright is 2024–2025; MLD driver is recent WiFi 7 code
present in this tree.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: `git log --oneline -15 --
drivers/net/wireless/intel/iwlwifi/mld/power.c` returned only unrelated
commits (shallow history). MLD driver and `iwl_mld_update_mac_power()`
are present in v6.18.44.

**Step 3.4 — Author context**
Record: Intel iwlwifi team (Avinash Bhatt, Miri Korenblit). Subsystem-
appropriate authors.

**Step 3.5 — Dependencies**
Record: Standalone. No “patch X/Y” references. Uses existing
`iwl_fw_lookup_cmd_ver()` and `iwl_mld_send_cmd_with_flags_pdu()`
already in tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 dig -c <commit>` unavailable (commit not in checkout).
`patch.msgid.link` and `lore.kernel.org` blocked by bot protection.
**UNVERIFIED:** review thread content, stable nominations, NAKs.

**Step 4.2 — Reviewers**
Record: **UNVERIFIED** — could not fetch thread recipients.

**Step 4.3 — Bug reports**
Record: None in commit message. No syzbot/bugzilla links.

**Step 4.4 — Related patches/series**
Record: Likely part of Intel iwlwifi May 2026 update series;
**UNVERIFIED** whether other series commits are required.

**Step 4.5 — Stable list history**
Record: **UNVERIFIED** — lore blocked.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `iwl_mld_update_mac_power()`, `iwl_mld_power_build_cmd()`,
`iwl_mld_power_build_cmd_v2()`, `iwl_mld_power_configure_uapsd()`,
`iwl_mld_handle_uapsd_misbehaving_ap_notif()` (removed).

**Step 5.2 — Callers**
Record: `iwl_mld_update_mac_power()` called from:
- `mld/mac80211.c` — association, BSS/PM changes (6 call sites)
- `mld/d3.c` — suspend/WoWLAN
- `mld/low_latency.c`, `mld/debugfs.c`

Common runtime paths on WiFi 7 MLD hardware.

**Step 5.3 — Callees**
Record: `iwl_fw_lookup_cmd_ver()`, `iwl_mld_send_cmd_with_flags_pdu()` →
`iwl_trans_send_cmd()`.

**Step 5.4 — Reachability**
Record: Triggered on normal STA association and power-management updates
for `CONFIG_IWLMLD` devices (WiFi 7, firmware major ≥ 97 per
`IWL_MLD_SUPPORTED_FW_VERSION`).

**Step 5.5 — Similar patterns**
Record: `mvm/fw.c` already uses `iwl_fw_lookup_cmd_ver()` + version-
specific `sizeof()` for `iwl_phy_cfg_cmd` — same established pattern.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Current tree at
`drivers/net/wireless/intel/iwlwifi/mld/power.c`:

```295:302:drivers/net/wireless/intel/iwlwifi/mld/power.c
int iwl_mld_update_mac_power(struct iwl_mld *mld, struct ieee80211_vif
*vif,
                             bool d3)
{
        struct iwl_mac_power_cmd cmd = {};

        iwl_mld_power_build_cmd(mld, vif, &cmd, d3);

        return iwl_mld_send_cmd_pdu(mld, MAC_PM_POWER_TABLE, &cmd);
}
```

Always sends full VER_2 struct; no v3 handling. MLD driver,
`CONFIG_IWLMLD`, and WiFi 7 opmode selection
(`IWL_MLD_SUPPORTED_FW_VERSION 97`) all exist in this tree.

**Step 6.2 — Backport complications**
Record: Expected **clean apply** — target code exists and matches patch
context. MVM changes are type renames only.

**Step 6.3 — Related fixes already present?**
Record: No existing v3 handling found (`grep` for `cmd_ver >= 3` under
`mld/` returned nothing). Fix not already applied.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem/criticality**
Record: `drivers/net/wireless/intel/iwlwifi` — **IMPORTANT** (WiFi
driver, affects connectivity and power management on Intel WiFi 7
hardware).

**Step 7.2 — Activity**
Record: MLD is actively developed recent subsystem in 6.18; WiFi 7
support is current focus.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with `CONFIG_IWLMLD` on Intel WiFi 7 hardware (BZ/SC/DR
families, FM+ RF) running firmware that advertises `MAC_PM_POWER_TABLE`
API v3.

**Step 8.2 — Trigger conditions**
Record: Firmware reports command API v3 at init; driver then sends power
table on association/PM changes. Likely with newer Intel firmware
releases coordinated with this change. Not userspace-triggerable as a
security primitive.

**Step 8.3 — Failure mode severity**
Record: **MEDIUM–HIGH** — firmware command rejection/misparsing → broken
power management, connectivity instability, battery impact. Not a kernel
oops/panic, but real user-visible hardware malfunction.

**Step 8.4 — Risk/benefit**
Record:
- **Benefit:** Prevents PM breakage on supported WiFi 7 hardware with v3
  firmware; backward compatible.
- **Risk:** Low–medium (duplicated code paths, but pattern is proven in
  iwlwifi).
- **Ratio:** Favorable for backport once v3 firmware is deployed to
  stable users.

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Real firmware/driver ABI bug when API v3 is advertised
- Buggy code confirmed in v6.18.44 MLD driver
- Affects common association/PM code paths
- Small, reviewable change following existing iwlwifi conventions
- Backward compatible with VER_1/2
- MLD/WiFi 7 hardware supported in this tree

**Evidence AGAINST:**
- No crash, security, or corruption report
- Commit framed as uAPSD certification API transition
- Moderate size (~200 lines, duplicated v2/v3 paths)
- MVM portion is rename-only (no MVM bug fix)
- Mailing-list review/stable nomination unverified
- Impact depends on v3 firmware actually shipping to 6.18 users

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** (clear version branching; no
   Tested-by in message)
2. Fixes real bug affecting users? **PASS** (ABI mismatch on MLD + v3
   firmware)
3. Important issue? **PASS** (PM/connectivity malfunction, MEDIUM–HIGH)
4. Small and contained? **PASS** (localized iwlwifi PM; moderate line
   count)
5. No new features/APIs? **PASS** (firmware compatibility, not new
   userspace API)
6. Can apply to local tree? **PASS** (MLD code present, clean apply
   expected)

**Exception category:** Firmware API compatibility for existing hardware
— qualifies similarly to other iwlwifi command-version fixes.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 2] Analyzed full diff: 8 files, version-based struct selection,
  notification removal
- [Phase 3] `git describe HEAD` → `v6.18.44`; Makefile → 6.18.44
- [Phase 3] `git log --oneline -15 -- mld/power.c` → shallow/unhelpful
  history
- [Phase 3] `git blame` on `iwl_mld_update_mac_power()` → shallow repo
  artifact
- [Phase 4] `b4 dig` without commit hash → not usable;
  lore/patch.msgid.link → bot-blocked (**UNVERIFIED** review discussion)
- [Phase 5] `grep iwl_mld_update_mac_power` → 10 call sites in
  mac80211/d3/debugfs/low_latency
- [Phase 5] Read `iwl-drv.c`: `IWL_MLD_SUPPORTED_FW_VERSION 97`, MLD
  opmode selection for WiFi 7
- [Phase 5] Read `mvm/fw.c:577-586` → confirmed version-based sizeof
  pattern
- [Phase 6] Read current `mld/power.c:295-302` → always sends VER_2
  struct (bug confirmed)
- [Phase 6] Read `fw/api/power.h` → single `iwl_mac_power_cmd` (VER_1/2
  layout, no v3 split)
- [Phase 6] `grep cmd_ver >= 3` in mld/ → no matches (fix absent)
- [Phase 6] `grep iwl_mld_handle_uapsd_misbehaving` → handler present
  (to be removed)
- [Phase 7] `Kconfig`: `CONFIG_IWLMLD` tristate MLD firmware support
  exists
- [Phase 8] Struct size: v3 ≈ 20 bytes vs v2 ≈ 40 bytes (verified by
  field layout)
- **UNVERIFIED:** Whether v3 firmware is already distributed to 6.18.y
  users
- **UNVERIFIED:** Mailing-list reviewer feedback or explicit stable
  nomination

## Conclusion

For **this tree (v6.18.44)**, the MLD driver unconditionally sends the
wrong `MAC_PM_POWER_TABLE` command layout when firmware advertises API
v3. That is a real compatibility bug on supported Intel WiFi 7 hardware,
on common runtime paths, with a contained fix that preserves v1/v2
behavior. It meets stable criteria as a firmware ABI compatibility fix
for existing hardware.

**YES**

 .../net/wireless/intel/iwlwifi/fw/api/power.h |  48 ++++-
 .../net/wireless/intel/iwlwifi/mld/iface.c    |  18 --
 .../net/wireless/intel/iwlwifi/mld/iface.h    |   3 -
 drivers/net/wireless/intel/iwlwifi/mld/mld.c  |   1 -
 .../net/wireless/intel/iwlwifi/mld/notif.c    |   6 -
 .../net/wireless/intel/iwlwifi/mld/power.c    | 177 ++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  |   4 +-
 .../net/wireless/intel/iwlwifi/mvm/power.c    |  14 +-
 8 files changed, 214 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 535864e226260..9eeb3600ed1f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -85,12 +85,13 @@ struct iwl_ltr_config_cmd {
  *		'1' PM could sleep over DTIM till listen Interval.
  * @POWER_FLAGS_SNOOZE_ENA_MSK: Enable snoozing only if uAPSD is enabled and all
  *		access categories are both delivery and trigger enabled.
+ *		(Not supported since version 3)
  * @POWER_FLAGS_BT_SCO_ENA: Enable BT SCO coex only if uAPSD and
  *		PBW Snoozing enabled
  * @POWER_FLAGS_ADVANCE_PM_ENA_MSK: Advanced PM (uAPSD) enable mask
  * @POWER_FLAGS_LPRX_ENA_MSK: Low Power RX enable.
  * @POWER_FLAGS_UAPSD_MISBEHAVING_ENA_MSK: AP/GO's uAPSD misbehaving
- *		detection enablement
+ *		detection enablement (Not supported since version 3)
  * @POWER_FLAGS_ENABLE_SMPS_MSK: SMPS is allowed for this vif
 */
 enum iwl_power_flags {
@@ -175,9 +176,9 @@ struct iwl_device_power_cmd {
 } __packed;
 
 /**
- * struct iwl_mac_power_cmd - New power command containing uAPSD support
+ * struct iwl_mac_power_cmd_v2 - power command V2 containing uAPSD support
  * MAC_PM_POWER_TABLE = 0xA9 (command, has simple generic response)
- * @id_and_color:	MAC contex identifier, &enum iwl_ctxt_id_and_color
+ * @id_and_color:	MAC context identifier, &enum iwl_ctxt_id_and_color
  * @flags:		Power table command flags from POWER_FLAGS_*
  * @keep_alive_seconds:	Keep alive period in seconds. Default - 25 sec.
  *			Minimum allowed:- 3 * DTIM. Keep alive period must be
@@ -216,7 +217,7 @@ struct iwl_device_power_cmd {
  * @limited_ps_threshold: (unused)
  * @reserved: reserved (padding)
  */
-struct iwl_mac_power_cmd {
+struct iwl_mac_power_cmd_v2 {
 	/* CONTEXT_DESC_API_T_VER_1 */
 	__le32 id_and_color;
 
@@ -242,6 +243,43 @@ struct iwl_mac_power_cmd {
 	u8 reserved;
 } __packed; /* CLIENT_PM_POWER_TABLE_S_VER_1, VER_2 */
 
+/**
+ * struct iwl_mac_power_cmd - power command
+ * MAC_PM_POWER_TABLE = 0xA9 (command, has simple generic response)
+ * @id_and_color:	MAC context identifier, &enum iwl_ctxt_id_and_color
+ * @flags:		Power table command flags from POWER_FLAGS_*
+ * @keep_alive_seconds:	Keep alive period in seconds. Default - 25 sec.
+ *			Minimum allowed:- 3 * DTIM. Keep alive period must be
+ *			set regardless of power scheme or current power state.
+ *			FW use this value also when PM is disabled.
+ * @rx_data_timeout:    Minimum time (usec) from last Rx packet for AM to
+ *			PSM transition - legacy PM
+ * @tx_data_timeout:    Minimum time (usec) from last Tx packet for AM to
+ *			PSM transition - legacy PM
+ * @lprx_rssi_threshold: Signal strength up to which LP RX can be enabled.
+ *			Default: 80dbm
+ * @skip_dtim_periods:	Number of DTIM periods to skip if Skip over DTIM flag
+ *			is set. For example, if it is required to skip over
+ *			one DTIM, this value need to be set to 2 (DTIM periods).
+ * @qndp_tid:		TID client shall use for uAPSD QNDP triggers
+ * @uapsd_ac_flags:	Set trigger-enabled and delivery-enabled indication for
+ *			each corresponding AC.
+ *			Use IEEE80211_WMM_IE_STA_QOSINFO_AC* for correct values.
+ */
+struct iwl_mac_power_cmd {
+	/* CONTEXT_DESC_API_T_VER_1 */
+	__le32 id_and_color;
+
+	__le16 flags;
+	__le16 keep_alive_seconds;
+	__le32 rx_data_timeout;
+	__le32 tx_data_timeout;
+	u8 lprx_rssi_threshold;
+	u8 skip_dtim_periods;
+	u8 qndp_tid;
+	u8 uapsd_ac_flags;
+} __packed; /* CLIENT_PM_POWER_TABLE_S_VER_3 */
+
 /*
  * struct iwl_uapsd_misbehaving_ap_notif - FW sends this notification when
  * associated AP is identified as improperly implementing uAPSD protocol.
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.c b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
index 80bcd18930c57..b07e9e34a711a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.c
@@ -588,24 +588,6 @@ void iwl_mld_handle_probe_resp_data_notif(struct iwl_mld *mld,
 		kfree_rcu(old_data, rcu_head);
 }
 
-void iwl_mld_handle_uapsd_misbehaving_ap_notif(struct iwl_mld *mld,
-					       struct iwl_rx_packet *pkt)
-{
-	struct iwl_uapsd_misbehaving_ap_notif *notif = (void *)pkt->data;
-	struct ieee80211_vif *vif;
-
-	if (IWL_FW_CHECK(mld, notif->mac_id >= ARRAY_SIZE(mld->fw_id_to_vif),
-			 "mac id is invalid: %d\n", notif->mac_id))
-		return;
-
-	vif = wiphy_dereference(mld->wiphy, mld->fw_id_to_vif[notif->mac_id]);
-
-	if (WARN_ON(!vif) || ieee80211_vif_is_mld(vif))
-		return;
-
-	IWL_WARN(mld, "uapsd misbehaving AP: %pM\n", vif->bss_conf.bssid);
-}
-
 void iwl_mld_handle_datapath_monitor_notif(struct iwl_mld *mld,
 					   struct iwl_rx_packet *pkt)
 {
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/iface.h b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
index a3573d20f214a..b5e4852cb0374 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/iface.h
+++ b/drivers/net/wireless/intel/iwlwifi/mld/iface.h
@@ -234,9 +234,6 @@ void iwl_mld_handle_probe_resp_data_notif(struct iwl_mld *mld,
 void iwl_mld_handle_datapath_monitor_notif(struct iwl_mld *mld,
 					   struct iwl_rx_packet *pkt);
 
-void iwl_mld_handle_uapsd_misbehaving_ap_notif(struct iwl_mld *mld,
-					       struct iwl_rx_packet *pkt);
-
 void iwl_mld_reset_cca_40mhz_workaround(struct iwl_mld *mld,
 					struct ieee80211_vif *vif);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/mld.c b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
index 3cfe1bcb7d4e5..48b8ec6a5a12d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/mld.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/mld.c
@@ -162,7 +162,6 @@ static const struct iwl_hcmd_names iwl_mld_legacy_names[] = {
 	HCMD_NAME(PHY_CONFIGURATION_CMD),
 	HCMD_NAME(SCAN_OFFLOAD_UPDATE_PROFILES_CMD),
 	HCMD_NAME(POWER_TABLE_CMD),
-	HCMD_NAME(PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION),
 	HCMD_NAME(BEACON_NOTIFICATION),
 	HCMD_NAME(BEACON_TEMPLATE_CMD),
 	HCMD_NAME(TX_ANT_CONFIGURATION_CMD),
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/notif.c b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
index a3fd0b7387d69..5f2216f8c58f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/notif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/notif.c
@@ -338,8 +338,6 @@ CMD_VERSIONS(emlsr_mode_notif,
 	     CMD_VER_ENTRY(2, iwl_esr_mode_notif))
 CMD_VERSIONS(emlsr_trans_fail_notif,
 	     CMD_VER_ENTRY(1, iwl_esr_trans_fail_notif))
-CMD_VERSIONS(uapsd_misbehaving_ap_notif,
-	     CMD_VER_ENTRY(1, iwl_uapsd_misbehaving_ap_notif))
 CMD_VERSIONS(time_msmt_notif,
 	     CMD_VER_ENTRY(1, iwl_time_msmt_notify))
 CMD_VERSIONS(time_sync_confirm_notif,
@@ -360,8 +358,6 @@ DEFINE_SIMPLE_CANCELLATION(scan_complete, iwl_umac_scan_complete, uid)
 DEFINE_SIMPLE_CANCELLATION(scan_start, iwl_umac_scan_start, uid)
 DEFINE_SIMPLE_CANCELLATION(probe_resp_data, iwl_probe_resp_data_notif,
 			   mac_id)
-DEFINE_SIMPLE_CANCELLATION(uapsd_misbehaving_ap, iwl_uapsd_misbehaving_ap_notif,
-			   mac_id)
 DEFINE_SIMPLE_CANCELLATION(ftm_resp, iwl_tof_range_rsp_ntfy, request_id)
 DEFINE_SIMPLE_CANCELLATION(beacon_filter, iwl_beacon_filter_notif, link_id)
 
@@ -452,8 +448,6 @@ const struct iwl_rx_handler iwl_mld_rx_handlers[] = {
 			     emlsr_mode_notif, RX_HANDLER_ASYNC)
 	RX_HANDLER_NO_OBJECT(MAC_CONF_GROUP, EMLSR_TRANS_FAIL_NOTIF,
 			     emlsr_trans_fail_notif, RX_HANDLER_ASYNC)
-	RX_HANDLER_OF_VIF(LEGACY_GROUP, PSM_UAPSD_AP_MISBEHAVING_NOTIFICATION,
-			  uapsd_misbehaving_ap_notif)
 	RX_HANDLER_NO_OBJECT(LEGACY_GROUP,
 			     WNM_80211V_TIMING_MEASUREMENT_NOTIFICATION,
 			     time_msmt_notif, RX_HANDLER_SYNC)
diff --git a/drivers/net/wireless/intel/iwlwifi/mld/power.c b/drivers/net/wireless/intel/iwlwifi/mld/power.c
index f664b277adf7d..38c77a33871d1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/power.c
@@ -113,10 +113,10 @@ static bool iwl_mld_power_is_radar(struct iwl_mld *mld,
 	return chanctx_conf->def.chan->flags & IEEE80211_CHAN_RADAR;
 }
 
-static void iwl_mld_power_configure_uapsd(struct iwl_mld *mld,
-					  struct iwl_mld_link *link,
-					  struct iwl_mac_power_cmd *cmd,
-					  bool ps_poll)
+static void iwl_mld_power_configure_uapsd_v2(struct iwl_mld *mld,
+					     struct iwl_mld_link *link,
+					     struct iwl_mac_power_cmd_v2 *cmd,
+					     bool ps_poll)
 {
 	bool tid_found = false;
 
@@ -175,10 +175,54 @@ static void iwl_mld_power_configure_uapsd(struct iwl_mld *mld,
 	cmd->uapsd_max_sp = mld->hw->uapsd_max_sp_len;
 }
 
+static void iwl_mld_power_configure_uapsd(struct iwl_mld *mld,
+					  struct iwl_mld_link *link,
+					  struct iwl_mac_power_cmd *cmd,
+					  bool ps_poll)
+{
+	bool tid_found = false;
+
+	/* set advanced pm flag with no uapsd ACs to enable ps-poll */
+	if (ps_poll) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
+		return;
+	}
+
+	for (enum ieee80211_ac_numbers ac = IEEE80211_AC_VO;
+	     ac <= IEEE80211_AC_BK;
+	     ac++) {
+		if (!link->queue_params[ac].uapsd)
+			continue;
+
+		cmd->flags |=
+			cpu_to_le16(POWER_FLAGS_ADVANCE_PM_ENA_MSK);
+		cmd->uapsd_ac_flags |= BIT(ac);
+
+		/* QNDP TID - the highest TID with no admission control */
+		if (!tid_found && !link->queue_params[ac].acm) {
+			tid_found = true;
+			switch (ac) {
+			case IEEE80211_AC_VO:
+				cmd->qndp_tid = 6;
+				break;
+			case IEEE80211_AC_VI:
+				cmd->qndp_tid = 5;
+				break;
+			case IEEE80211_AC_BE:
+				cmd->qndp_tid = 0;
+				break;
+			case IEEE80211_AC_BK:
+				cmd->qndp_tid = 1;
+				break;
+			}
+		}
+	}
+}
+
 static void
 iwl_mld_power_config_skip_dtim(struct iwl_mld *mld,
 			       const struct ieee80211_bss_conf *link_conf,
-			       struct iwl_mac_power_cmd *cmd)
+			       u8 *skip_dtim_periods, __le16 *flags)
 {
 	unsigned int dtimper_tu;
 	unsigned int dtimper;
@@ -196,15 +240,15 @@ iwl_mld_power_config_skip_dtim(struct iwl_mld *mld,
 	/* configure skip over dtim up to 900 TU DTIM interval */
 	skip = max_t(int, 1, 900 / dtimper_tu);
 
-	cmd->skip_dtim_periods = skip;
-	cmd->flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
+	*skip_dtim_periods = skip;
+	*flags |= cpu_to_le16(POWER_FLAGS_SKIP_OVER_DTIM_MSK);
 }
 
 #define POWER_KEEP_ALIVE_PERIOD_SEC    25
-static void iwl_mld_power_build_cmd(struct iwl_mld *mld,
-				    struct ieee80211_vif *vif,
-				    struct iwl_mac_power_cmd *cmd,
-				    bool d3)
+static void iwl_mld_power_build_cmd_v2(struct iwl_mld *mld,
+				       struct ieee80211_vif *vif,
+				       struct iwl_mac_power_cmd_v2 *cmd,
+				       bool d3)
 {
 	int dtimper, bi;
 	int keep_alive;
@@ -265,7 +309,9 @@ static void iwl_mld_power_build_cmd(struct iwl_mld *mld,
 	}
 
 	if (d3) {
-		iwl_mld_power_config_skip_dtim(mld, link_conf, cmd);
+		iwl_mld_power_config_skip_dtim(mld, link_conf,
+					       &cmd->skip_dtim_periods,
+					       &cmd->flags);
 		cmd->rx_data_timeout =
 			cpu_to_le32(IWL_MLD_WOWLAN_PS_RX_DATA_TIMEOUT);
 		cmd->tx_data_timeout =
@@ -286,6 +332,95 @@ static void iwl_mld_power_build_cmd(struct iwl_mld *mld,
 	 * mac80211 will allow uAPSD. Always call iwl_mld_power_configure_uapsd
 	 * which will look at what mac80211 is saying.
 	 */
+#ifdef CONFIG_IWLWIFI_DEBUGFS
+	ps_poll = mld_vif->use_ps_poll;
+#endif
+	iwl_mld_power_configure_uapsd_v2(mld, link, cmd, ps_poll);
+}
+
+static void iwl_mld_power_build_cmd(struct iwl_mld *mld,
+				    struct ieee80211_vif *vif,
+				    struct iwl_mac_power_cmd *cmd,
+				    bool d3)
+{
+	int dtimper, bi;
+	int keep_alive;
+	struct iwl_mld_vif *mld_vif = iwl_mld_vif_from_mac80211(vif);
+	struct ieee80211_bss_conf *link_conf = &vif->bss_conf;
+	struct iwl_mld_link *link = &mld_vif->deflink;
+	bool ps_poll = false;
+	__le32 fw_id = cpu_to_le32(mld_vif->fw_id);
+
+	if (ieee80211_vif_is_mld(vif)) {
+		int link_id;
+
+		if (WARN_ON(!vif->active_links))
+			return;
+
+		/* The firmware consumes one single configuration for the vif
+		 * and can't differentiate between links, just pick the lowest
+		 * link_id's configuration and use that.
+		 */
+		link_id = __ffs(vif->active_links);
+		link_conf = link_conf_dereference_check(vif, link_id);
+		link = iwl_mld_link_dereference_check(mld_vif, link_id);
+
+		if (WARN_ON(!link_conf || !link))
+			return;
+	}
+	dtimper = link_conf->dtim_period;
+	bi = link_conf->beacon_int;
+
+	/* Regardless of power management state the driver must set
+	 * keep alive period. FW will use it for sending keep alive NDPs
+	 * immediately after association. Check that keep alive period
+	 * is at least 3 * DTIM
+	 */
+	keep_alive = DIV_ROUND_UP(ieee80211_tu_to_usec(3 * dtimper * bi),
+				  USEC_PER_SEC);
+	keep_alive = max(keep_alive, POWER_KEEP_ALIVE_PERIOD_SEC);
+
+	cmd->id_and_color = fw_id;
+	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
+
+	if (iwlmld_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
+
+	if (vif->cfg.ps && iwl_mld_tdls_sta_count(mld) == 0) {
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
+		cmd->flags |= cpu_to_le16(POWER_FLAGS_ENABLE_SMPS_MSK);
+
+		/* firmware supports LPRX for beacons at rate 1 Mbps or
+		 * 6 Mbps only
+		 */
+		if (link_conf->beacon_rate &&
+		    (link_conf->beacon_rate->bitrate == 10 ||
+		     link_conf->beacon_rate->bitrate == 60)) {
+			cmd->flags |= cpu_to_le16(POWER_FLAGS_LPRX_ENA_MSK);
+			cmd->lprx_rssi_threshold = POWER_LPRX_RSSI_THRESHOLD;
+		}
+	}
+
+	if (d3) {
+		iwl_mld_power_config_skip_dtim(mld, link_conf,
+					       &cmd->skip_dtim_periods,
+					       &cmd->flags);
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MLD_WOWLAN_PS_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MLD_WOWLAN_PS_TX_DATA_TIMEOUT);
+	} else if (iwl_mld_vif_low_latency(mld_vif) && vif->p2p) {
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MLD_SHORT_PS_TX_DATA_TIMEOUT);
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MLD_SHORT_PS_RX_DATA_TIMEOUT);
+	} else {
+		cmd->rx_data_timeout =
+			cpu_to_le32(IWL_MLD_DEFAULT_PS_RX_DATA_TIMEOUT);
+		cmd->tx_data_timeout =
+			cpu_to_le32(IWL_MLD_DEFAULT_PS_TX_DATA_TIMEOUT);
+	}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	ps_poll = mld_vif->use_ps_poll;
 #endif
@@ -295,11 +430,23 @@ static void iwl_mld_power_build_cmd(struct iwl_mld *mld,
 int iwl_mld_update_mac_power(struct iwl_mld *mld, struct ieee80211_vif *vif,
 			     bool d3)
 {
-	struct iwl_mac_power_cmd cmd = {};
+	int cmd_ver = iwl_fw_lookup_cmd_ver(mld->fw, MAC_PM_POWER_TABLE, 0);
 
-	iwl_mld_power_build_cmd(mld, vif, &cmd, d3);
+	if (cmd_ver >= 3) {
+		struct iwl_mac_power_cmd cmd = {};
 
-	return iwl_mld_send_cmd_pdu(mld, MAC_PM_POWER_TABLE, &cmd);
+		iwl_mld_power_build_cmd(mld, vif, &cmd, d3);
+		return iwl_mld_send_cmd_with_flags_pdu(mld,
+						       MAC_PM_POWER_TABLE, 0,
+						       &cmd, sizeof(cmd));
+	} else {
+		struct iwl_mac_power_cmd_v2 cmd = {};
+
+		iwl_mld_power_build_cmd_v2(mld, vif, &cmd, d3);
+		return iwl_mld_send_cmd_with_flags_pdu(mld,
+						       MAC_PM_POWER_TABLE, 0,
+						       &cmd, sizeof(cmd));
+	}
 }
 
 static void
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index b515028adc8f5..e05efcecaaf3f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
 /*
- * Copyright (C) 2012-2014, 2018-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -477,7 +477,7 @@ struct iwl_mvm_vif {
 	struct dentry *dbgfs_slink;
 	struct iwl_dbgfs_pm dbgfs_pm;
 	struct iwl_dbgfs_bf dbgfs_bf;
-	struct iwl_mac_power_cmd mac_pwr_cmd;
+	struct iwl_mac_power_cmd_v2 mac_pwr_cmd;
 	int dbgfs_quota_min;
 	bool ftm_unprotected;
 #endif
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 610de29b7be0d..46792c5087532 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2019, 2021-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2019, 2021-2026 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2015-2017 Intel Deutschland GmbH
  */
@@ -83,7 +83,7 @@ void iwl_mvm_beacon_filter_set_cqm_params(struct iwl_mvm *mvm,
 }
 
 static void iwl_mvm_power_log(struct iwl_mvm *mvm,
-			      struct iwl_mac_power_cmd *cmd)
+			      struct iwl_mac_power_cmd_v2 *cmd)
 {
 	IWL_DEBUG_POWER(mvm,
 			"Sending power table command on mac id 0x%X for power level %d, flags = 0x%X\n",
@@ -121,7 +121,7 @@ static void iwl_mvm_power_log(struct iwl_mvm *mvm,
 
 static void iwl_mvm_power_configure_uapsd(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
-					  struct iwl_mac_power_cmd *cmd)
+					  struct iwl_mac_power_cmd_v2 *cmd)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	enum ieee80211_ac_numbers ac;
@@ -296,7 +296,7 @@ static bool iwl_mvm_power_is_radar(struct ieee80211_bss_conf *link_conf)
 
 static void iwl_mvm_power_config_skip_dtim(struct iwl_mvm *mvm,
 					   struct ieee80211_vif *vif,
-					   struct iwl_mac_power_cmd *cmd)
+					   struct iwl_mac_power_cmd_v2 *cmd)
 {
 	struct ieee80211_bss_conf *link_conf;
 	unsigned int min_link_skip = ~0;
@@ -344,7 +344,7 @@ static void iwl_mvm_power_config_skip_dtim(struct iwl_mvm *mvm,
 
 static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_vif *vif,
-				    struct iwl_mac_power_cmd *cmd)
+				    struct iwl_mac_power_cmd_v2 *cmd)
 {
 	int dtimper, bi;
 	int keep_alive;
@@ -466,7 +466,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 					 struct ieee80211_vif *vif)
 {
-	struct iwl_mac_power_cmd cmd = {};
+	struct iwl_mac_power_cmd_v2 cmd = {};
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
@@ -717,7 +717,7 @@ int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 				 int bufsz)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_mac_power_cmd cmd = {};
+	struct iwl_mac_power_cmd_v2 cmd = {};
 	int pos = 0;
 
 	mutex_lock(&mvm->mutex);
-- 
2.53.0

