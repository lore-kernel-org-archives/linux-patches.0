Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE08D5867CB;
	Mon, 31 Aug 2026 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184212; cv=none; b=RgwcumMIU9/j16Hry17Mje/CsiW65B9UcbJ7wIyee0X1pb5UgUrAJ89wDFQLC10BRmFS0I5TXDEySpviYS7Sg8TH7IzjEfxBrWSu6jZsSBuWO2TTCzFsW/m1EeSII6u/xYylfljkD4CmXRxK2TyOuyC0WPKYMV5CITTJvJU4LjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184212; c=relaxed/simple;
	bh=hTZuVltYnGs6nIldBwENmgDV+Ad8mGIEfICJloZZVpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ASJbJ01Auab6A12Dq4rBw4Ag0aDGx+MaksGRQnRS07rsBAMjR417tAehsjLUDVjHV+Y1vKAN9BMksTo4+RErxhoRvb2ozS+vbF4wnXnJE0HfifQTVcXjRbSCR3bzCV3T7AlyMrvUedjYnOlMw2yeb7qSO5BXEnqLVP4ShgHI+l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PQoZMOn4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQoZMOn4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0576A1F00ADE;
	Mon, 31 Aug 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184209;
	bh=HUWwZyEc9oRi3Lq+6Ai4YP+4omOm4VH3qZKeHvjVXwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PQoZMOn4sI1W8uAQnmmTLiVGpty+KfHkJN+ZFXkrjyCp1aPEoWTc5ilCK0o0fiuV2
	 yHZ8mDTLDu1fn6Xfmrdydn8219635G92iYYWLn4xbaaamCIWGC96ZG37tgStYOU3gA
	 oKkt0Ld3TGhNpv7XM0RGD6ecyYCtKzPwaBr8LUBVnbhUskr0OT0ujmFgVvFGJiEWRA
	 qbud52HoIfR2n94xxwJtw7KwWNOUe2x7Z0sMl+POynTbbAcrprGaH03Oh50UhI/jNM
	 QuV17gBsN29gYcfM4ArzIyP8+KaBVnW8ZxXlIF63F6oaGQ/kzb3eggnT7wPgkYlkUU
	 dXbHCS0w/5EWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: validate txq_id in TX response handler
Date: Mon, 31 Aug 2026 09:29:45 -0400
Message-ID: <20260831133314.4125787-557-sashal@kernel.org>
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

[ Upstream commit e66ddfd94b829b8ecaaac932d9487fb4de6d267c ]

Validate txq_id from TX response notification before passing to
iwl_trans_reclaim(). Other reclaim paths in this file perform this
check to prevent out-of-bounds access on malformed notifications.

Assisted-by: GitHubCopilot:claude-haiku-4.5
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.b938c2dcf08d.I8a88ec359e229f1c41ac9c49fd9ce28a2b62b274@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mld: validate txq_id in TX
response handler`

**Local tree:** `v6.18.44-2-g1b9e1abadee04` (Makefile: 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mld]` `[validate]` — Add bounds validation
for `txq_id` in the MLD TX response notification handler before calling
`iwl_trans_reclaim()`.

### Step 1.2: Tags
**Record:**
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none on patch 1 (Johannes Berg reviewed other
  patches in the series)
- **Acked-by:** — none
- **Link:** `https://patch.msgid.link/20260715215523.b938c2dcf08d...`
  (blocked by bot protection; content recovered from local mbox)
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Emmanuel Grumbach, Miri Korenblit (ignore pipeline
  SOBs)
- **Assisted-by:** GitHubCopilot:claude-haiku-4.5

Notable: no syzbot/user report, but the commit explicitly describes an
OOB access on malformed firmware notifications.

### Step 1.3: Body analysis
**Record:**
- **Bug:** `txq_id` from a TX response notification is passed to
  `iwl_trans_reclaim()` without validation.
- **Symptom:** Out-of-bounds access when firmware sends a malformed
  notification with an invalid queue ID.
- **Root cause:** Inconsistent validation — other reclaim paths in the
  same file already check `txq_id >= ARRAY_SIZE(mld->fw_id_to_txq)`.
- **Version info:** none stated.

### Step 1.4: Hidden bug fix?
**Record:** Not disguised — this is an explicit defensive bounds-check
bug fix, consistent with other `IWL_FW_CHECK` validations in iwlwifi MLD
code.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/tx.c` (+4 lines)
- **Function:** `iwl_mld_handle_tx_resp_notif()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** After parsing `ssn`, immediately calls
  `iwl_trans_reclaim(mld->trans, txq_id, ssn, &skbs, false)`.
- **After:** Validates `txq_id < ARRAY_SIZE(mld->fw_id_to_txq)` via
  `IWL_FW_CHECK()`; returns early on failure.
- **Path affected:** Firmware TX response notification handler (normal
  TX completion path).

### Step 2.3: Bug mechanism
**Record:** **Buffer overflow / out-of-bounds access.** `txq_id` comes
from `le16_to_cpu(tx_resp->tx_queue)` (range 0–65535).
`iwl_pcie_reclaim()` indexes `trans_pcie->txqs.txq[txq_id]` with no
bounds check — array size is `IWL_MAX_TVQM_QUEUES` (512). Values ≥ 512
cause OOB array access before `WARN_ON(!txq)` can help.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — identical pattern already used at lines 1283–1286
  and 1389–1392 in the same file.
- **Regression risk:** Very low — only rejects already-invalid queue
  IDs.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines around the missing check blame to `5d324e5159d9e`
(v6.18 merge point in this tree). The handler and missing validation
have been present since MLD `tx.c` landed in v6.18.

### Step 3.2: Fixes: tag
**Record:** N/A — no `Fixes:` tag.

### Step 3.3: Related file history
**Record:**
- `Invalid txq id` validation exists in flush and compressed-BA handlers
  since MLD `tx.c` was introduced.
- `iwl_mld_handle_tx_resp_notif()` was the inconsistent outlier.
- Part of `[PATCH 1/15]` iwlwifi fixes series (2026-07-15); patch 1 is
  standalone.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach (Intel iwlwifi maintainer). Miri Korenblit
(iwlwifi maintainer) signed off. Similar MLD validation fixes already
backported to this tree (e.g. `1de92789ce31e` sta_mask validation).

### Step 3.5: Dependencies
**Record:** None. Self-contained 4-line addition; applies cleanly to
current HEAD (verified with `git apply --check`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch discussion
**Record:**
- `b4 dig -c 2df6643a5aa80`: no match (commit not in local tree).
- Local mbox
  `20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`:
  patch 1/15, standalone.
- No stable nomination in patch 1; no NAKs found.
- Link URL blocked by Anubis anti-bot page.

### Step 4.2: Reviewers
**Record:** Patch 1 has no `Reviewed-by`. Johannes Berg reviewed other
patches in the series.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or user Reported-by. Bug
identified by code inspection (Copilot-assisted).

### Step 4.4: Series context
**Record:** Patch 1/15 is independent. Other patches in the series are
unrelated (NVM channels, mvm fixes, etc.).

### Step 4.5: Stable list history
**Record:** Not searched on lore (patch not yet merged). Similar iwlwifi
MLD validation fixes have been backported to this tree with `Cc:
stable@vger.kernel.org`.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mld_handle_tx_resp_notif()`, `iwl_trans_reclaim()`,
`iwl_pcie_reclaim()`.

### Step 5.2: Callers
**Record:** Registered in `iwl_mld_rx_handlers[]` as
`RX_HANDLER_NO_OBJECT(LEGACY_GROUP, TX_CMD, tx_resp_notif,
RX_HANDLER_SYNC)` in `mld/notif.c`. Invoked synchronously on every TX
completion notification from firmware.

### Step 5.3: Callees
**Record:** `iwl_trans_reclaim()` → `iwl_pcie_reclaim()` →
`trans_pcie->txqs.txq[txq_id]` (unchecked index).

### Step 5.4: Reachability
**Record:** Hot path — every transmitted frame gets a TX response
notification on MLD-capable Intel WiFi hardware. Malformed notifications
can occur during firmware errors/corruption (the scenario `IWL_FW_CHECK`
is designed for).

### Step 5.5: Similar patterns
**Record:** Same validation in:
- `iwl_mld_flush_link_sta_txqs()` (lines 1283–1286)
- `iwl_mld_handle_compressed_ba_notif()` (lines 1389–1392)

`iwl_pcie` TX path uses `WARN_ONCE(txq_id >= IWL_MAX_TVQM_QUEUES, ...)`
in `tx-gen2.c` line 727.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code exists?
**Record:** **Yes.** Current HEAD and `v6.18` tag both lack the
validation in `iwl_mld_handle_tx_resp_notif()` at line 1109. MLD `tx.c`
exists in v6.18 (`git ls-tree v6.18` confirmed).

### Step 6.2: Backport complications
**Record:** Clean apply — `git apply --check` succeeded with zero
conflicts.

### Step 6.3: Related fixes already present?
**Record:** The sibling-path validations (flush, compressed BA) are
present. This specific gap in the TX response handler is **not** fixed
yet.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mld/` — **IMPORTANT**
(Intel WiFi driver, common laptop hardware; MLD path for newer WiFi 7 /
MLO devices).

### Step 7.2: Subsystem activity
**Record:** Actively maintained; multiple MLD fixes already in this
6.18.y tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with Intel WiFi hardware using the MLD opmode
(`iwlmld`) on kernel 6.18+. Not universal, but affects a growing
hardware population.

### Step 8.2: Trigger conditions
**Record:** Firmware sends TX response with `txq_id >= 512`. Most likely
during firmware malfunction, corruption, or error recovery — the exact
scenario iwlwifi guards against with `IWL_FW_CHECK`. Not easily user-
triggerable, but reachable on every TX completion notification.

### Step 8.3: Failure mode severity
**Record:** OOB read of `txq[txq_id]` → possible NULL deref or use of
garbage pointer in `iwl_pcie_reclaim()` → **kernel oops**. Severity:
**HIGH**.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents potential crash on malformed firmware
  notification.
- **Risk:** VERY LOW — 4 lines, proven pattern, early return only for
  invalid IDs.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real OOB bug with crash potential
- Small, surgical, obviously correct fix
- Matches existing validation in the same file
- Bug present since v6.18 MLD code landed
- Applies cleanly to 6.18.44
- iwlwifi maintainers authored/signed
- Similar MLD validation fixes already backported to this tree

**AGAINST backport:**
- No user report or syzbot reproduction
- Requires malformed firmware notification (edge case)
- MLD-only (not all iwlwifi users)
- No explicit `Cc: stable` or `Reviewed-by` on this specific patch

**Unresolved:** None that affect the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — mirrors two existing checks
   in the same file; no Tested-by but pattern is proven.
2. Fixes a real bug? **PASS** — missing bounds check before unchecked
   array index.
3. Important issue? **PASS** — OOB access → potential kernel crash
   (HIGH).
4. Small and contained? **PASS** — 4 lines, one function.
5. No new features or APIs? **PASS** — defensive validation only.
6. Can apply to local tree? **PASS** — verified clean apply.

### Step 9.3: Exception categories
**Record:** N/A — standard bug fix, not a device-ID/quirk/build/doc
exception.

### Step 9.4: Decision rationale

This commit closes a validation gap in `iwl_mld_handle_tx_resp_notif()`
that sibling reclaim handlers in the same file already cover. Without
it, a malformed firmware TX response with `txq_id >= 512` can cause an
out-of-bounds access in `iwl_pcie_reclaim()` before any safety check
runs. The fix is minimal, follows an established iwlwifi pattern,
applies cleanly to the 6.18.44 tree where the bug exists, and prevents a
potential kernel crash on hardware using the MLD driver path.

---

## Verification

- [Phase 1] Parsed subject, tags, body from commit message and local
  mbox
- [Phase 1] Link URL fetch blocked; recovered patch from
  `20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`
- [Phase 2] Read `iwl_mld_handle_tx_resp_notif()` at lines 1073–1149 —
  missing validation confirmed
- [Phase 2] Read sibling validations at lines 1283–1286 and 1389–1392
- [Phase 2] Read `iwl_pcie_reclaim()` at `pcie/gen1_2/tx.c:2339` —
  unchecked `txq[txq_id]` access
- [Phase 2] Confirmed `IWL_MAX_TVQM_QUEUES = 512` in `iwl-trans.h:269`
- [Phase 2] Confirmed `fw_id_to_txq[IWL_MAX_TVQM_QUEUES]` in
  `mld/mld.h:200`
- [Phase 3] `git blame -L 1103,1110` — code from v6.18 merge
- [Phase 3] `git show v6.18:.../mld/tx.c` — bug present in v6.18 release
- [Phase 3] `git log -S 'Invalid txq id'` — validation in flush/BA paths
  since MLD introduction
- [Phase 4] `b4 dig -c 2df6643a5aa80` — no result (commit not in tree)
- [Phase 4] Read mbox patch 1/15 — standalone, 4 lines
- [Phase 5] `grep iwl_mld_handle_tx_resp_notif` — registered in
  `mld/notif.c:399` as TX_CMD handler
- [Phase 5] Read `IWL_FW_CHECK` macro in `fw/dbg.h:334`
- [Phase 6] `git describe HEAD` → v6.18.44; Makefile confirms 6.18.44
- [Phase 6] `git ls-tree v6.18 drivers/.../mld/tx.c` — MLD code in v6.18
- [Phase 6] `git apply --check` — patch applies cleanly
- [Phase 6] Compared with backported fix `1de92789ce31e` (similar MLD
  validation pattern)
- [Phase 8] Assessed failure mode: OOB → crash, severity HIGH

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index a60bfb1a2ab22..130f3a99de96f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -1103,6 +1103,10 @@ void iwl_mld_handle_tx_resp_notif(struct iwl_mld *mld,
 	ssn = le32_to_cpup((__le32 *)agg_status +
 			   tx_resp->frame_count) & 0xFFFF;
 
+	if (IWL_FW_CHECK(mld, txq_id >= ARRAY_SIZE(mld->fw_id_to_txq),
+			 "Invalid txq id %d\n", txq_id))
+		return;
+
 	__skb_queue_head_init(&skbs);
 
 	/* we can free until ssn % q.n_bd not inclusive */
-- 
2.53.0

