Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4FE4AA3FE;
	Mon, 31 Aug 2026 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184007; cv=none; b=TY5wd8gNFDP24lzGnTzjbRywqSfSdyQfQ+qd4bLurFrpGjUM17BNY7QvbCcyQ+6lyAehhbPcJsPr/dc45ohC9t1JMi+zgPzHEzDggMHUjNh3PuBw0hLXlsriP03TCBeMjkvtHR0nUuyDViGyRzpB8I+KPTaro2ai5jKN4WIsbQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184007; c=relaxed/simple;
	bh=WB+f9TzNRoGgZwon+SI33FdAdwqrZKA9RN+IbyqZCtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YB99EY5IT8bx2DeGFLuQfRP67GffNpJjkgp4HntCHan/B/JfN8Ax3tsg7pDSMKSEWfzAEWAhfaseF2JiKTsJ5mYGwlblB9Ctf+wVJsDdAvju+IgHUlaWl6hP3IfC4nvMWnzEGIpN18rX3LQcol1ISfQMW0/hGfZ+xfHghtMYA6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fJiBie8+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fJiBie8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F1C1F00A3E;
	Mon, 31 Aug 2026 13:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184002;
	bh=FpXrqiS4I00ayqbEOnR9AiBOSu5k6dNYuuvgpi5JfdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fJiBie8+vuSA1Vmt5+svmtzvD7gg7CqEdj1p6QnJmXvu4xizHREvAGwz6LFCe3SNh
	 HD4gORi8BcwcwzWnvhqmg2w2eUlu3iNhiMgK0ZbSJHBcHfIup/RRE3+T/jrN1a5ZK1
	 sy1hOzfRl6A5lMjaaCkiYxtDxXodMZlSQKYERg9PMsX2MJ9w+VNOEVDECOthJDv/x9
	 ibZxQ7XP4HpXpnA637O4ZEydEvra5jDYCi/UdwLgndRci117n//rse8UxMvYi8UQZa
	 pWmJVcHbvCltZyBjTwfsusAhBWDXzVJf+fzLRCKxoFKWzuz/kLkYtIasLMio7D1WHB
	 iFeypU6MZkppw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mvm: validate MCC header before n_channels
Date: Mon, 31 Aug 2026 09:27:39 -0400
Message-ID: <20260831133314.4125787-431-sashal@kernel.org>
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

[ Upstream commit 77f33bed0cb49a11f03427f2fa368830c1cae3c2 ]

MCC response parsing read n_channels from v8/v4/v3 response variants
before ensuring the payload contained the fixed response header.

Add a minimum payload-length check for each response version before
reading n_channels, and keep the existing exact-size validation for the
channels array payload.

Assisted-by: GitHub Copilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.cb2cef3d3e7e.Iee7b48614289da576de842157ad3730b7589a4b1@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Parse the subject line
**Record:** `[wifi: iwlwifi: mvm]` `[validate]` — validate MCC response
header before reading `n_channels` from firmware MCC update responses.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260714141909.cb2cef3d3e7e.Iee7b4
  8614289da576de842157ad3730b7589a4b1@changeid`
- **Cc: stable@vger.kernel.org:** — none (expected for manual review)
- **Assisted-by:** GitHub Copilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>`

Notable: Intel iwlwifi maintainers authored/reviewed; no syzbot or user
bug report.

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** MCC response parsing reads `n_channels` from v8/v4/v3
  response layouts before confirming the payload contains the fixed
  header.
- **Symptom:** Out-of-bounds read from `pkt->data` on
  truncated/malformed firmware responses; subsequent `struct_size()` /
  `kzalloc()` / `memcpy()` use an unvalidated `n_channels`.
- **Root cause:** Validation order — field access precedes minimum-
  length check.
- **Version info:** Affects all three MCC response variants (v8, v4,
  v3).

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised as cleanup — explicit defensive validation
fix. Same class of bug as iwlwifi “read field before payload size check”
fixes already in this tree.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory changes
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/nvm.c` (~29 lines
  added, minor refactor)
- **Function:** `iwl_mvm_update_mcc()`
- **Scope:** Single-file surgical fix in one function

### Step 2.2: Code flow change
**Record:**
- **Before:** Cast `pkt->data`, read `n_channels`, then compare full
  payload length to `struct_size(..., channels, n_channels)`.
- **After:** Cache `pkt_len = iwl_rx_packet_payload_len(pkt)`; for each
  variant, `IWL_FW_CHECK(pkt_len < sizeof(*mcc_resp_vN))` before reading
  `n_channels`; keep exact-size check, now via `IWL_FW_CHECK` with
  better diagnostics.
- **Paths:** All three MCC response version branches; error path returns
  `ERR_PTR(-EINVAL)` and jumps to `exit`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Memory safety / out-of-bounds read (buffer bounds)
- **Mechanism:** `n_channels` sits at offset 12 (v3), 16 (v4), or 20
  (v8). Header sizes are 16/20/24 bytes respectively. A payload shorter
  than `sizeof(*mcc_resp_vN)` causes OOB read when dereferencing
  `mcc_resp_vN->n_channels`. Garbage `n_channels` can then drive
  `struct_size()` and `memcpy()` logic on a still-untrusted buffer.

### Step 2.4: Fix quality
**Record:**
- Matches established iwlwifi pattern (`IWL_FW_CHECK` + `pkt_len`
  caching) used in `mvm/fw.c`, `mvm/rxmq.c`, `mvm/mac-ctxt.c`, etc.
- Minimal, obviously correct ordering fix.
- **Regression risk:** Low — only rejects responses that were already
  invalid; successful paths unchanged.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame changed lines
**Record:** Current buggy code in `iwl_mvm_update_mcc()` is present at
HEAD (`v6.18.44`). Blame points to base import `5d324e5159d9e` (shallow
history in this checkout). All three version branches share the same
pattern.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no `Fixes:` tag in commit message.

### Step 3.3: Related file history
**Record:** Recent iwlwifi mvm commits in this tree include closely
related backports:
- `2d5dec517b539` — move field read after size check in WoWLAN wake
  packet handler
- `a076b0c457c71` — validate SAR GEO response payload before access
- `dd90880eb5ec5` — OOB read fix in `iwl_mvm_nd_match_info_handler()`

This MCC fix is the same bug class and same Intel batch (July 2026). The
MCC fix itself is **not** yet in this tree (`git log --grep` found
nothing; no `MCC v8 response too short` string in tree).

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is iwlwifi maintainer; Miri Korenblit is
Intel iwlwifi lead. Same review chain as other July 2026 iwlwifi stable
backports already merged here.

### Step 3.5: Dependencies
**Record:** Standalone — uses existing `IWL_FW_CHECK`,
`iwl_rx_packet_payload_len()`, and MCC structs already in tree. No
series dependencies.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original patch discussion
**Record:** `b4 dig` could not match this commit (not in local git
history). Link URL blocked by bot protection (403). No local `.mbx` for
this patch found.

### Step 4.2: Reviewers
**Record:** UNVERIFIED from lore; commit SOBs show Intel iwlwifi
maintainers.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or sanitizer report
referenced.

### Step 4.4: Related patches
**Record:** Part of Intel iwlwifi July 2026 validation batch; sibling
fixes (`2d5dec517b539`, `a076b0c457c71`) already backported to this
6.18.y tree.

### Step 4.5: Stable list history
**Record:** UNVERIFIED on lore stable list; analogous iwlwifi fixes
already accepted into this stable tree.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `iwl_mvm_update_mcc()` (modified)

### Step 5.2: Callers
**Record:**
- `iwl_mvm_get_regdomain()` in `mac80211.c` (primary caller)
- Indirect callers: `iwl_mvm_init_mcc()`,
  `iwl_mvm_rx_chub_update_mcc()`, `iwl_mvm_apply_last_mcc()` in `nvm.c`
  / `mac80211.c`
- Gated by `iwl_mvm_is_lar_supported(mvm)` (LAR-capable Intel devices
  with NVM+FW support)

### Step 5.3: Callees
**Record:** `iwl_mvm_send_cmd()`, `iwl_fw_lookup_notif_ver()`,
`iwl_rx_packet_payload_len()`, `IWL_FW_CHECK()`, `kzalloc()`,
`memcpy()`, `iwl_free_resp()`

### Step 5.4: Reachability
**Record:** Triggered during driver init (regulatory setup), BIOS MCC
application, and runtime Chub MCC notifications. Userspace can
indirectly trigger regulatory/MCC paths via cfg80211 country updates on
LAR-enabled hardware. Requires `CONFIG_IWLMVM`.

### Step 5.5: Similar patterns
**Record:** Same “validate before read” pattern fixed in
`iwl_mvm_wowlan_store_wake_pkt()` (`2d5dec517b539`) in this tree.
`mld/mcc.c` `iwl_mld_copy_mcc_resp()` has a similar ordering issue but
is **outside** this commit’s scope.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Local tree is **6.18.44** (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`). `nvm.c` lines 442–493 read `n_channels`
before any minimum header-length check. Fix not present.

### Step 6.2: Backport complications
**Record:** Clean apply expected — same file structure, `IWL_FW_CHECK`
exists, no conflicting recent changes to `iwl_mvm_update_mcc()`.

### Step 6.3: Related fixes already present?
**Record:** Same-category iwlwifi firmware-response validation fixes are
already in tree; this specific MCC fix is not.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT**
(Intel WiFi, widely deployed on laptops; regulatory/MCC path affects
channel legality).

### Step 7.2: Subsystem activity
**Record:** Active — multiple iwlwifi mvm fixes landed recently in this
6.18.y tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Intel iwlwifi MVM devices with LAR support
(`CONFIG_IWLMVM`). Not universal, but a large laptop population.

### Step 8.2: Trigger conditions
**Record:** Truncated or malformed `MCC_UPDATE_CMD` firmware response.
Uncommon in normal operation (requires FW bug, communication error, or
corrupted response), but the code path runs at init and on MCC updates.
Not directly userspace-injectable, but reachable from normal driver
operation.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read from SKB payload; possible kernel
oops/KASAN report; potential follow-on issues from garbage `n_channels`.
**Severity: HIGH** (memory safety in kernel), though trigger likelihood
is **MEDIUM-LOW**.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Prevents OOB read on a real driver path; aligns with
  fixes already accepted for this tree.
- **Risk:** Very low — adds early rejection of invalid packets only.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR backport:**
- Real out-of-bounds read before bounds checking
- Small, surgical, maintainer-authored fix
- Matches iwlwifi conventions (`IWL_FW_CHECK`)
- Buggy code confirmed present in 6.18.44
- Same bug pattern as `2d5dec517b539` already backported here
- Intel iwlwifi maintainers signed off
- Standalone, no dependencies

**AGAINST backport:**
- No syzbot/user report (defensive hardening)
- Trigger requires malformed FW response (rare)
- Only LAR-enabled iwlwifi hardware

**Unresolved:**
- Full lore review thread (blocked/unavailable)
- Exact upstream commit SHA not in local git

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — ordering fix is standard;
   tested implicitly by maintainer merge; no Tested-by.
2. Fixes a real bug? **PASS** — OOB read on short payload verified by
   struct layout.
3. Important issue? **PASS** — memory safety / potential crash (HIGH
   severity, medium-low likelihood).
4. Small and contained? **PASS** — ~30 lines, one function, one file.
5. No new features/APIs? **PASS** — validation only.
6. Can apply to local tree? **PASS** — code exists, fix not present,
   clean apply expected.

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs). Qualifies
as a standard bug fix.

### Step 9.4: Problem and decision

This commit fixes an ordering bug in `iwl_mvm_update_mcc()` where
`n_channels` is read from the firmware response before verifying the
packet is large enough to contain the fixed MCC header (16/20/24 bytes
for v3/v4/v8). On a truncated response, that is an out-of-bounds read.
The existing exact-size check does not prevent the initial invalid read.

For **6.18.44**, the vulnerable code is present and the fix is absent.
The change is small, follows patterns already backported in this tree
(`2d5dec517b539`, `a076b0c457c71`), and addresses a real memory-safety
defect on a regulatory/MCC path used by LAR-enabled Intel WiFi hardware.
Risk of regression is negligible.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Analyzed provided diff; verified `IWL_FW_CHECK` in
  `fw/dbg.h`
- **[Phase 2]** Computed struct sizes: v3=16, v4=20, v8=24 bytes;
  `n_channels` offsets 12/16/20
- **[Phase 3]** `git blame` on `nvm.c:439-495`: buggy pattern at HEAD
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/wireless/intel/iwlwifi/mvm/`: found related backports
- **[Phase 3]** `git show 2d5dec517b539`, `a076b0c457c71`,
  `dd90880eb5ec5`: confirmed same fix class already in tree
- **[Phase 3]** `git log --grep="validate MCC"` / `--grep="MCC header"`:
  no matches (fix not applied)
- **[Phase 4]** `b4 dig` with message-id: failed (wrong usage / no
  match)
- **[Phase 4]** WebFetch/curl lore + patch.msgid.link: blocked (403 /
  bot protection)
- **[Phase 4]** Grep `*.mbx` for patch subject: no local mbox found
- **[Phase 5]** `grep iwl_mvm_update_mcc`: callers in `mac80211.c`,
  `nvm.c`
- **[Phase 5]** Read `iwl_mvm_is_lar_supported()` in `mvm.h`
- **[Phase 5]** Grep `pkt_len < sizeof` in iwlwifi: established
  validation pattern
- **[Phase 6]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`;
  Makefile 6.18.44
- **[Phase 6]** Read `nvm.c:439-514`: confirmed buggy code at HEAD
- **[Phase 6]** Grep `MCC v8 response too short`: not in tree
- **[Phase 8]** Read MCC struct definitions in `fw/api/nvm-reg.h`

**YES**The analysis is done. For the **6.18.44** tree checked out here,
the iwlwifi MCC validation commit should be backported.

**Verdict: YES**

The bug is real: `iwl_mvm_update_mcc()` reads `n_channels` from firmware
MCC responses before checking that the payload is large enough for the
fixed header (16/20/24 bytes for v3/v4/v8), which can cause an out-of-
bounds read on truncated responses. The vulnerable code is present in
this tree; the fix is not.

The patch is small, uses the existing `IWL_FW_CHECK` pattern, and
matches similar iwlwifi validation fixes already backported here (e.g.
wake-packet and SAR GEO payload checks). Risk is low; benefit is
preventing a memory-safety defect on the LAR/MCC regulatory path for
Intel WiFi hardware.

 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 43 ++++++++++++++++----
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 953218f1e025a..f76e57399c1f3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2019, 2021-2025 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2019, 2021-2026 Intel Corporation
  * Copyright (C) 2013-2015 Intel Mobile Communications GmbH
  * Copyright (C) 2016-2017 Intel Deutschland GmbH
  */
@@ -416,6 +416,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	int ret, resp_ver;
 	u32 status;
 	int resp_len, n_channels;
+	unsigned int pkt_len;
 	u16 mcc;
 
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
@@ -431,6 +432,7 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 		return ERR_PTR(ret);
 
 	pkt = cmd.resp_pkt;
+	pkt_len = iwl_rx_packet_payload_len(pkt);
 
 	resp_ver = iwl_fw_lookup_notif_ver(mvm->fw, IWL_ALWAYS_LONG_GROUP,
 					   MCC_UPDATE_CMD, 0);
@@ -439,9 +441,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	if (resp_ver >= 8) {
 		struct iwl_mcc_update_resp_v8 *mcc_resp_v8 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v8),
+				 "MCC v8 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v8->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v8, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v8, channels, n_channels),
+				 "invalid MCC v8 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
@@ -464,9 +475,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 			       IWL_UCODE_TLV_CAPA_MCC_UPDATE_11AX_SUPPORT)) {
 		struct iwl_mcc_update_resp_v4 *mcc_resp_v4 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v4),
+				 "MCC v4 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v4->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v4, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v4, channels, n_channels),
+				 "invalid MCC v4 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
@@ -489,9 +509,18 @@ iwl_mvm_update_mcc(struct iwl_mvm *mvm, const char *alpha2,
 	} else {
 		struct iwl_mcc_update_resp_v3 *mcc_resp_v3 = (void *)pkt->data;
 
+		if (IWL_FW_CHECK(mvm, pkt_len < sizeof(*mcc_resp_v3),
+				 "MCC v3 response too short: %u\n", pkt_len)) {
+			resp_cp = ERR_PTR(-EINVAL);
+			goto exit;
+		}
+
 		n_channels =  __le32_to_cpu(mcc_resp_v3->n_channels);
-		if (iwl_rx_packet_payload_len(pkt) !=
-		    struct_size(mcc_resp_v3, channels, n_channels)) {
+		if (IWL_FW_CHECK(mvm,
+				 pkt_len !=
+				 struct_size(mcc_resp_v3, channels, n_channels),
+				 "invalid MCC v3 response size: %u (n_channels=%d)\n",
+				 pkt_len, n_channels)) {
 			resp_cp = ERR_PTR(-EINVAL);
 			goto exit;
 		}
-- 
2.53.0

