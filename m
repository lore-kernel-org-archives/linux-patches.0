Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A593644AB9D;
	Mon, 31 Aug 2026 13:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183683; cv=none; b=YYUM0U2ikwCEqJzjOhxuSuIbDikViOEvN9/IVvryQf2VDczJYY5KtkKUNSU7kQs3NVKm0x/C1EtENilpZDZBn/ZJq2bJq0r16GQSMHtZpbKAWWzd8aHr6ziisScVQUj1ylkVriiQ4nknAdtKBWze15RX/Zw5qkrmZTMzGbo3kEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183683; c=relaxed/simple;
	bh=+CqGTkV59KDF1qm4DXp/2YQxAAAQpQfQz+m5bfjASXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DHw3MBdwaISt14xg7FoxtE2zaz5yJKFlJaCxsp4uVgHFbYs+LW8iP64DfEoPJdROTCpAmPzOWK++h6gJHZDNJboNqgRJo+yJz+Bu3+AD+ZghiIuJBVmAuy77Msg2SpKamdN1MarOzvWa1CnjbG4zhFUYyZcRlGPO59Y+c6rn3TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQQpEa5F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQQpEa5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD661F000E9;
	Mon, 31 Aug 2026 13:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183680;
	bh=ugFYBDzvjXiiwr1QoCdRHCywzurahxBL1vOPwBRxn3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QQQpEa5F35Gg/3Pr1lz/g9cEc66xMK7pFdXQm+tsLF15VKRjYTRvDkcrMdx1QFkIe
	 XnHuPmlQ3J3nnauC4VoQM2wx/C3frbEWuj4RA1esmwNNitqfBUUE/FfgzZx7pH/024
	 MTi1qJ/6/upOZ5bpFJZV6T1tW2LH0YjrmJ7QH7FWwCVBN4O+XjxlH4lq1MzpC38HKg
	 kWy1Ni0GzvbGPOtoeiIfewseNwzaouKwFiAUoPkeHl07slnni8vQ7Ol3u4gCCwk1In
	 wdZ+P0DcqrEFEefnPrI7vaA5bwkOj4CP7IFVLBYGjWwzfChZGQZWKlJgkJYCb5+dq1
	 MHVXBWrA3J5fQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: fw: validate SMEM response size
Date: Mon, 31 Aug 2026 09:24:28 -0400
Message-ID: <20260831133314.4125787-240-sashal@kernel.org>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

[ Upstream commit a31b0e535fd11219556c7382ee9f63b2438c3769 ]

The SMEM parsers cast firmware response payloads directly to shared
memory configuration structures. A short response can leave fields
outside the received payload while the driver still dereferences them.

Check the response payload length before reading the base fields in
both parser variants. Require the full legacy extended layout before
reading internal TX FIFO data. Valid responses keep the same parsed
values.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.fbdb0016a91d.I5f6c6e04589a24a233559191170ccb43372dee63@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi: fw]` `[validate]` — validate SMEM (shared
memory) firmware response payload size before parsing.

**Step 1.2 — Tags**
Record:
- **Reviewed-by:** Johannes Berg `<johannes.berg@intel.com>` (iwlwifi
  maintainer)
- **Signed-off-by:** Shahar Tzarfati `<shahar.tzarfati@intel.com>`
  (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (maintainer)
- **Link:** `https://patch.msgid.link/20260715215523.fbdb0016a91d...`
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags
- Notable: maintainer review present; part of `[PATCH 5/15]` iwlwifi
  fixes series (2026-07-15)

**Step 1.3 — Body analysis**
Record:
- **Bug:** SMEM parsers cast `pkt->data` directly to
  `iwl_shared_mem_cfg` / `iwl_shared_mem_cfg_v2` and dereference fields
  without verifying payload length.
- **Symptom:** A short firmware response can cause reads past the
  received buffer.
- **Root cause:** Missing bounds checks before field access; extended-
  layout path also reads `internal_txfifo_*` without verifying full
  struct size.
- **Version info:** None in message.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although titled “validate,” this is a real out-of-
bounds read fix in firmware-response parsing, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/fw/smem.c` (+23 / −5
  lines)
- **Functions:** `iwl_parse_shared_mem_22000()`,
  `iwl_parse_shared_mem()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow per hunk**

| Hunk | Before | After |
|------|--------|-------|
| `iwl_parse_shared_mem_22000()` | Reads `lmac_num` immediately from
cast pointer; only checks full struct size for API v4 tail fields |
Requires `payload_len >= offsetofend(..., lmac_smem[1])` (180 bytes)
before any reads |
| `iwl_parse_shared_mem()` base path | Reads `txfifo_size[]`,
`rxfifo_size[]` with no length check | Requires `payload_len >=
offsetof(..., rxfifo_addr)` (68 bytes) first |
| `iwl_parse_shared_mem()` extended path | Reads `internal_txfifo_*`
when capability set, no size check | Requires `payload_len >=
sizeof(*mem_cfg)` (100 bytes) before extended fields |

**Step 2.3 — Bug mechanism**
Record: **Buffer overflow / out-of-bounds read** — firmware response
parsing reads beyond `pkt` payload on short/malformed responses.

**Step 2.4 — Fix quality**
Record: Obviously correct; follows existing `IWL_FW_CHECK` +
`iwl_rx_packet_payload_len()` pattern already used in `pnvm.c` in this
tree. Minimal risk; early return on bad payload matches existing error-
handling style in the same file.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Parser functions trace to `5d324e5159d9e` (6.18 merge base).
Related bounds work in `1d49a42717bdc` added `lmac_num` cap and v4 full-
size check but left early reads unguarded. Buggy pattern has been
present since SMEM parsing existed in this file layout.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag.

**Step 3.3 — Related commits**
Record: Part of 15-patch series `wifi: iwlwifi: fixes - 07-15-2026`.
**Other series patches already in this 6.18.44 tree:**
- `eae7fdf7d4469` — pnvm payload validation (patch 8/15)
- `70a6de303c9b3` — TAS block-list pointer arithmetic (patch 6/15)
- `2d5dec517b539` — wake-packet handler bounds (patch from same author)
- `a076b0c457c71` — SAR GEO payload validation (patch 4/15)

This SMEM patch is **not** yet in the tree.

**Step 3.4 — Author context**
Record: Shahar Tzarfati; one other commit in tree (`2d5dec517b539`, same
series). Johannes Berg reviewed and has prior SMEM fix (`1d49a42717bdc`)
in tree.

**Step 3.5 — Dependencies**
Record: **Standalone.** Only touches `smem.c`; uses `IWL_FW_CHECK`,
`iwl_rx_packet_payload_len()`, and structs already present. No
prerequisite commits required.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record: `b4 am` on message-id found thread at lore; patch is `[PATCH
5/15]` in
`20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`.
Cover letter describes series as “bugfixes.” No explicit stable
nomination found in mbox text.

**Step 4.2 — Reviewers**
Record: `b4 am` attestation passed; Reviewed-by Johannes Berg; series
signed DKIM/intel.com.

**Step 4.3 — Bug report**
Record: N/A — no external bug report or syzbot link.

**Step 4.4 — Series context**
Record: 15-patch iwlwifi hardening series. This patch is independent;
siblings already partially backported to this tree.

**Step 4.5 — Stable list**
Record: No stable-list discussion found (UNVERIFIED beyond mbox search).

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `iwl_parse_shared_mem_22000()`, `iwl_parse_shared_mem()`, called
from `iwl_get_shared_mem_conf()`.

**Step 5.2 — Callers**
Record:
- `iwl_get_shared_mem_conf()` ← `iwl_mvm_config_fw()` in `mvm/fw.c`
  (post-firmware-start)
- `iwl_get_shared_mem_conf()` ← `iwl_mld_config_fw()` in `mld/fw.c`

Every iwlwifi MVM/MLD device hits this during firmware configuration.

**Step 5.3 — Callees**
Record: `iwl_rx_packet_payload_len()`, `IWL_FW_CHECK`, `le32_to_cpu()`,
`fw_has_capa()`, `iwl_fw_lookup_notif_ver()`.

**Step 5.4 — Reachability**
Record: Triggered on every iwlwifi bring-up when firmware responds to
`SHARED_MEM_CFG`. Short/malformed firmware response (corrupt FW, FW bug,
or hostile FW) can hit the buggy path. Not a direct syscall, but affects
all iwlwifi users at probe/init.

**Step 5.5 — Similar patterns**
Record: Same validation pattern added in `pnvm.c` (`eae7fdf7d4469`,
already in this tree). `smem.c` already had a partial v4 size check but
not early/base-path checks.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Current `smem.c` reads `mem_cfg->lmac_num` and v2
fields without upfront length validation; extended path lacks size
check. Tree: `v6.18.44-1-g2736c32da98b9`.

**Step 6.2 — Backport complications**
Record: **Clean apply confirmed** — `git apply --check` on extracted
patch 5 succeeds against current tree.

**Step 6.3 — Related fixes already present?**
Record: `1d49a42717bdc` (22000 LMAC count + v4 tail check) present.
`eae7fdf7d4469` (pnvm validation) present. **This specific SMEM
validation is absent.**

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem / criticality**
Record: `drivers/net/wireless/intel/iwlwifi` — **IMPORTANT** (widely
deployed laptop/desktop WiFi; firmware init path).

**Step 7.2 — Activity**
Record: Actively maintained; multiple iwlwifi bounds-check fixes
backported to this tree in recent history.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: All users of Intel iwlwifi (MVM and MLD) with `CONFIG_IWLWIFI`.

**Step 8.2 — Trigger conditions**
Record: Firmware returns undersized `SHARED_MEM_CFG` response. Uncommon
in normal operation; plausible with buggy/corrupt firmware or during
error recovery. Not trivially userspace-triggerable, but firmware is an
attack surface.

**Step 8.3 — Failure mode**
Record: Out-of-bounds read past response buffer → kernel oops, info
leak, or undefined behavior during WiFi init. **Severity: HIGH.**

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH — prevents OOB read on common init path; aligns with
  already-backported series siblings.
- **Risk:** LOW — 28-line change, defensive early returns, no API
  change.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR:**
- Real OOB-read bug in firmware response parsing
- Small, single-file, maintainer-reviewed fix
- Buggy code confirmed in 6.18.44 tree
- Applies cleanly
- Standalone (no series dependencies)
- Same iwlwifi hardening series already partially backported here
- Consistent with `pnvm.c` validation already in tree
- Affects all iwlwifi devices at firmware init

**AGAINST:**
- No user report or syzbot reproduction
- Trigger requires abnormal firmware response (mitigated: consequences
  are severe)
- Slightly conservative minimum size for 22000 path (180 bytes vs
  possibly smaller valid 1-LMAC response) — safe for spec-compliant
  firmware

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — clear bounds checks;
   Reviewed-by maintainer; series tested by multiple Tested-by on
   sibling patches
2. Fixes real bug affecting users? **PASS** — OOB read on iwlwifi init
3. Important issue? **PASS** — crash / memory safety (HIGH)
4. Small and contained? **PASS** — 1 file, ~28 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception category**
Record: N/A (standard bug fix, not device-ID/quirk/docs).

**Step 9.4 — Decision rationale**
This is a textbook stable candidate: a small, obviously correct bounds-
check fix for firmware response parsing on a widely used driver, with
the buggy code present in Linux 6.18.44 and no dependencies. Sibling
patches from the same series are already in this tree; this one should
follow.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message and
  mbox patch 5/15
- [Phase 1] Confirmed Reviewed-by Johannes Berg; no Fixes:/Reported-
  by:/syzbot
- [Phase 2] Read current `smem.c`; confirmed missing upfront validation
  matches “before” side of diff
- [Phase 2] Computed struct offsets: `offsetofend(lmac_smem[1])=180`,
  `offsetof(rxfifo_addr)=68`, `sizeof(cfg_v2)=100`
- [Phase 3] `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`; Makefile
  confirms 6.18.44
- [Phase 3] `git blame smem.c`: parsers from `5d324e5159d9e`; partial
  fix `1d49a42717bdc` present
- [Phase 3] `git log -- drivers/net/wireless/intel/iwlwifi/`: confirmed
  sibling backports (`eae7fdf7d4469`, `70a6de303c9b3`, `2d5dec517b539`,
  `a076b0c457c71`); SMEM fix absent
- [Phase 4] `b4 am` on message-id: found 15-patch series; patch 5 is
  SMEM validation
- [Phase 4] Read cover letter: series described as bugfixes
- [Phase 4] No Cc: stable found in mbox (grep returned empty)
- [Phase 5] `grep iwl_get_shared_mem_conf`: callers in `mvm/fw.c:1391`,
  `mld/fw.c:459`
- [Phase 5] Confirmed `IWL_FW_CHECK` and `iwl_rx_packet_payload_len`
  exist in tree
- [Phase 6] `git apply --check` on extracted patch 5: **succeeds**
  (clean apply)
- [Phase 6] Confirmed buggy code present; fix not yet applied
- [Phase 8] Failure mode: OOB read at WiFi firmware init → HIGH severity

**YES**

 drivers/net/wireless/intel/iwlwifi/fw/smem.c | 28 ++++++++++++++++----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/smem.c b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
index 344ddde85b189..20ed26a1bb00e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/smem.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/smem.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2021, 2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2021, 2025-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -14,9 +14,17 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 {
 	struct iwl_shared_mem_cfg *mem_cfg = (void *)pkt->data;
 	int i, lmac;
-	int lmac_num = le32_to_cpu(mem_cfg->lmac_num);
-	u8 api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
-					     SHARED_MEM_CFG_CMD, 0);
+	int lmac_num;
+	u8 api_ver;
+
+	if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+			 offsetofend(struct iwl_shared_mem_cfg, lmac_smem[1]),
+			 "bad shared mem notification size\n"))
+		return;
+
+	lmac_num = le32_to_cpu(mem_cfg->lmac_num);
+	api_ver = iwl_fw_lookup_notif_ver(fwrt->fw, SYSTEM_GROUP,
+					  SHARED_MEM_CFG_CMD, 0);
 
 	/* Note: notification has 3 entries, but we only expect 2 */
 	if (IWL_FW_CHECK(fwrt, lmac_num > ARRAY_SIZE(fwrt->smem_cfg.lmac),
@@ -30,7 +38,7 @@ static void iwl_parse_shared_mem_22000(struct iwl_fw_runtime *fwrt,
 
 	if (api_ver >= 4 &&
 	    !IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) < sizeof(*mem_cfg),
-			  "bad shared mem notification size\n")) {
+			  "bad shared mem notification size (v4)\n")) {
 		fwrt->smem_cfg.rxfifo2_control_size =
 			le32_to_cpu(mem_cfg->rxfifo2_control_size);
 	}
@@ -53,6 +61,11 @@ static void iwl_parse_shared_mem(struct iwl_fw_runtime *fwrt,
 	struct iwl_shared_mem_cfg_v2 *mem_cfg = (void *)pkt->data;
 	int i;
 
+	if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+			 offsetof(struct iwl_shared_mem_cfg_v2, rxfifo_addr),
+			 "bad shared mem notification size\n"))
+		return;
+
 	fwrt->smem_cfg.num_lmacs = 1;
 
 	fwrt->smem_cfg.num_txfifo_entries = ARRAY_SIZE(mem_cfg->txfifo_size);
@@ -67,6 +80,11 @@ static void iwl_parse_shared_mem(struct iwl_fw_runtime *fwrt,
 	/* new API has more data, from rxfifo_addr field and on */
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_EXTEND_SHARED_MEM_CFG)) {
+		if (IWL_FW_CHECK(fwrt, iwl_rx_packet_payload_len(pkt) <
+				 sizeof(*mem_cfg),
+				 "bad shared mem notification size (extend)\n"))
+			return;
+
 		BUILD_BUG_ON(sizeof(fwrt->smem_cfg.internal_txfifo_size) !=
 			     sizeof(mem_cfg->internal_txfifo_size));
 
-- 
2.53.0

