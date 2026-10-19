Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4E1638AD3;
	Mon, 19 Oct 2026 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418752; cv=none; b=oVnzl3q918b0lQkn6yE4b4ORiqDqq+b1JLHvtQxmPujl2oZV7l4b1q4oXScVIXZ/C5J3SEFb7qIT+989nipk/nSwSwh5czdFTPTCFxML+GmDnI0398pbARDedime5VAMLhN1RrjumnE0a9Djct8WbC7Uz5BZW9Rjq1sn6j5HS70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418752; c=relaxed/simple;
	bh=5SmHB84jlEgg50PdFSK4WSFzeAX4TcKDNCmIphn1TmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B6R9hJW8UOEHgYwF22CCoPYU85xm9eqIgoV359Ra6JyVW8ygTGZq55i5fmpoBURbCAACyW676R2tLXCYSJ7htWBZJkgs2KI7Kby9Yilc6ig0SJXiLVvmdDFHD05nqD3mEZNMxVfYUxowHuP0qC1Yi+iKCqRfDNrW5vyrcp0nhFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kHjMjcVS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kHjMjcVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201F31F000C8;
	Mon, 19 Oct 2026 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418748;
	bh=KXRsQjsxVyYpkqHcuYUET8xUNZPjjt/vD1RspRrxdhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHjMjcVSZNCMskkAFfYNyhe6EaiCS9P1HlIza/rCjL90in5/lYhwVcZJe27BEnQq2
	 VJ0ACAgPqv6D57l9SbFzxiGKsbWYqRCt8m5uSBArIyetCVxnF8mJVMSLZcd+d3ikhU
	 S2V/+AyXEEXqKowomfDEB3sHg9xQ9lRhr6EOOy75RMZ3rbMhVi1I4jHQrZJf95pxVh
	 oClYG0dxcfpuWnpWxDQ576nt9ZeYRXBINjUHImnxpxsDiDxw/wuPuuxvRsi4b+YHiE
	 KId9u53gyEuTg8DiYJHoqKFiuy1EcUqlNwJJN01MlR6iu5qsxo6GBjREZaf4yJZtOx
	 uyhXfA5mQUutA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iwlwifi: dvm: add missing cleaup for on error path
Date: Mon, 19 Oct 2026 09:52:39 -0400
Message-ID: <20261019135441.1420968-468-sashal@kernel.org>
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

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 94280e6e0c69a5327e377803732f494d8b5a74cd ]

In iwlagn_tx_agg_start(), call iwlagn_dealloc_agg_txq()
to clear bit on error path.

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Link: https://patch.msgid.link/20260401030555.541685-1-lihaoxiang@isrc.iscas.ac.cn
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4**. The DVM TX path still has this
aggregation-queue leak, and the fix is a three-line error-path dealloc.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[iwlwifi: dvm:] [add] [missing cleanup for error path in
`iwlagn_tx_agg_start()`]**
Subsystem: Intel iwlwifi DVM (legacy AGN firmware:
1000/2000/5000/6000-series).
Action: “add missing cleanup” — that is error-path recovery, not a
feature.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none
- **Cc: stable:** none (expected)
- **Link:** https://patch.msgid.link/20260401030555.541685-1-
  lihaoxiang@isrc.iscas.ac.cn
- **Signed-off-by:** Haoxiang Li (author); Miri Korenblit (iwlwifi
  maintainer, committer)
- Ignore pipeline SOBs if present; none here besides author/maintainer

Notable: no syzbot, no user crash report. Maintainer SOB is a quality
signal.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `iwlagn_tx_agg_start()` allocates an aggregation TX queue
  (`iwlagn_alloc_agg_txq()` sets a bit in `priv->agg_q_alloc`) then
  calls `iwl_sta_tx_modify_enable_tid()`. On failure it returned without
  clearing that bit.
- **Symptom:** leaked AMPDU hardware queue; later starts get `-ENOSPC`
  (“No free aggregation queue”).
- **Version info:** none in the message.
- **Root cause (author):** missing `iwlagn_dealloc_agg_txq()` on that
  error path.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Yes, a real bug fix phrased as cleanup.** It adds rollback
after a failed firmware command. Not style-only.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/net/wireless/intel/iwlwifi/dvm/tx.c`  **+3 / -1** (4
  lines touched)
- Function: `iwlagn_tx_agg_start()`
- Scope: **single-file surgical error-path fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `txq_id = iwlagn_alloc_agg_txq(...)` (sets bit in
  `agg_q_alloc`). If `iwl_sta_tx_modify_enable_tid()` fails, return
  `ret` immediately. Bit stays set. `tid_data->agg.txq_id` is never
  stored; `agg.state` stays `IWL_AGG_OFF`.
- **After:** same failure path calls `iwlagn_dealloc_agg_txq(priv,
  txq_id)` (clears bit, resets `queue_to_mac80211[q]`) then returns.
- Path: **error path only**. Success path unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** error-path **resource leak** (bitmap / HW TX queue), not
  a memory UAF.
- **Mechanism:** `iwlagn_alloc_agg_txq()` does `test_and_set_bit(q,
  priv->agg_q_alloc)`. DVM has **20** queues (`IWLAGN_NUM_QUEUES`),
  AMPDU starts at **11** (`IWLAGN_FIRST_AMPDU_QUEUE`) → **9**
  aggregation queues. `iwl_sta_tx_modify_enable_tid()` sends
  `REPLY_ADD_STA` via `iwl_send_add_sta()`; that can return send-cmd
  errors or `-EIO` if firmware status is not `ADD_STA_SUCCESS_MSK`.
- **Why stop cannot recover:** `iwlagn_tx_agg_stop()` only deallocates
  if `tid_data->agg.txq_id` is set and `test_bit(txq_id, agg_q_alloc)`.
  On this failure, `txq_id` was never written into `tid_data` and state
  is still `IWL_AGG_OFF` (stop’s default branch returns 0). Bitmap is
  cleared on nic restart (`memset(priv->agg_q_alloc, 0, ...)` in the
  restart path in `dvm/main.c`), so the leak lasts until firmware
  restart/reload.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Obviously correct:** dealloc is the inverse of alloc; same helper is
  already used in stop/flush/DELBA.
- **Minimal:** one call on the existing error return.
- **Regression risk: very low.** v1 also deallocated on
  `IWL_EMPTYING_HW_QUEUE_ADDBA` (delayed start, not an error).
  Maintainer Miriam Korenblit rejected that; v2 (this commit) only
  deallocs on the real error. Unlocking/locking unchanged. No API
  change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Alloc call: Johannes Berg, `1479177ba69023` / `9eae88fa9a02e3`
  (**2012**, contained in **v3.5-rc1**).
- Failed `iwl_sta_tx_modify_enable_tid()` return: Emmanuel Grumbach
  `288712a6ccf47b` (2011) / Wey-Yi Guy `74bcdb33e99f49` (2010).
- Bug has been in DVM for ~14 years. Code is mature, not brand-new.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Not applicable. Introducer is the 2012 queue-
mapping work, which is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record:
- Recent DVM `tx.c`: this fix, kernel-doc, rename churn. No prerequisite
  refactor of `iwlagn_alloc_agg_txq` / `iwlagn_dealloc_agg_txq`.
- Standalone; not “patch X/Y”.
- No later follow-up on `dvm/tx.c` after `94280e6e0c69a` in this
  checkout.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record:
- Haoxiang Li: this is the only iwlwifi commit in this tree (external
  contributor).
- Committer Miri Korenblit is an iwlwifi maintainer (many iwlwifi
  commits). Johannes Berg (wireless maintainer) was on To/Cc.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None.** Uses existing `iwlagn_dealloc_agg_txq()` (present
since the 2012 alloc/dealloc pair). Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- **b4 dig -c 94280e6e0c69a:** https://patch.msgid.link/20260401030555.5
  41685-1-lihaoxiang@isrc.iscas.ac.cn
- **b4 dig -a:**
  - v1: 2026-03-30 https://patch.msgid.link/20260330012620.2715796-1-
    lihaoxiang@isrc.iscas.ac.cn
  - v2 (applied): 2026-04-01
- **v1 extra hunk:** `iwlagn_dealloc_agg_txq()` also on
  `IWL_EMPTYING_HW_QUEUE_ADDBA`. Miriam: “I don't think that this is an
  error case?” — correct; that state holds the queue while draining
  before ADDBA.
- **v2:** only the firmware-command error path. Changelog: “remove an
  unnecessary error handling. Thanks, Miriam!”
- **Markus Elfring** on v2: asked for Fixes/stable tags and a subject
  typo fix; pointed at `stable-kernel-rules.rst`.
- **Johannes Berg** replied to Markus (typo/process nit), did not NAK
  the patch.
- **No NAKs** on the remaining hunk. Applied by Miri Korenblit
  2026-07-14.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (**b4 dig -w**): Haoxiang Li; Miri Korenblit; Johannes Berg;
linux-wireless; linux-kernel. Right maintainers and list.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: **No syzbot/bugzilla report.** Found by code review of the error
path. Trigger is real: `iwl_send_add_sta()` can fail.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone 1-patch series (v1→v2). Not part of a larger DVM
rework.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org HTTP fetch returned **403**; `b4` on stable
search did not yield a thread. **UNVERIFIED** whether stable@ discussed
this. Markus pointed at stable rules on linux-wireless; that is not a
maintainer Cc:stable.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**

Record: `iwlagn_tx_agg_start()`; helpers involved:
`iwlagn_alloc_agg_txq()`, `iwlagn_dealloc_agg_txq()`,
`iwl_sta_tx_modify_enable_tid()`.

**Step 5.2: TRACE CALLERS**

Record:
- `iwlagn_tx_agg_start()` ← `iwlagn_mac_ampdu_action()` on
  `IEEE80211_AMPDU_TX_START` (`dvm/mac80211.c`).
- That is the mac80211 `.ampdu_action` op — **userspace-reachable** via
  HT AMPDU session setup (normal AP association), under `priv->mutex`,
  if `sku_cap_11n_enable` and TX AMPDU enabled.

**Step 5.3: TRACE CALLEES**

Record:
- `iwl_sta_tx_modify_enable_tid()` → `iwl_send_add_sta()` →
  `iwl_dvm_send_cmd()`; firmware may fail.
- `iwlagn_dealloc_agg_txq()`: `clear_bit` + `queue_to_mac80211[q] =
  IWL_INVALID_MAC80211_QUEUE`. No lock inside; alloc uses
  `test_and_set_bit`. Same as stop/flush.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: cfg80211/mac80211 AMPDU TX start → iwlwifi DVM. Reachable on DVM
hardware during HT association. Not a debug-only path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Dealloc already on stop, flush, and DELBA-empty. This start-
error path was the missing one. No sibling DVM function with the same
hole found.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Tree: **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`), `VERSION=7
  PATCHLEVEL=3`.
- File and functions exist:
  `drivers/net/wireless/intel/iwlwifi/dvm/tx.c`, `CONFIG_IWLDVM`.
- Pre-fix parent of `94280e6e0c69a` still has `if (ret) return ret;`
  with no dealloc (verified via `git show 94280e6e0c69a^:...`).
- Bug introduced **v3.5**; present in this tree’s DVM.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** Surrounding `iwlagn_tx_agg_start()` matches the
hunk. No conflicting DVM TX rewrite in this checkout.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: No other commit on this leak. `67105abd6195a` is a different DVM
leak (`iwl_op_mode_dvm_start()`).

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **iwlwifi DVM** (`drivers/net/wireless/intel/iwlwifi/dvm/`).
**IMPORTANT** for users of those Intel AGN adapters; not mm/net core.
DVM is legacy vs MVM/MLD but still built (`config IWLDVM`).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: DVM is maintenance-mode (few commits); iwlwifi overall is
active. Long-lived bug in old code, not a brand-new feature.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: **Driver-specific / config-specific:** `CONFIG_IWLDVM` and
1000/2000/5000/6000-class Intel WiFi. Still present on older
laptops/embedded boards that LTS kernels serve.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record:
- Trigger: AMPDU TX start + failed `REPLY_ADD_STA` (firmware error,
  timeout, device going down).
- Not every packet; **error path**. Unprivileged users can cause AMPDU
  setup by using WiFi, but failure needs firmware/cmd error.
- After **9** leaks, all agg queues are gone until nic restart.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record:
- **Failure:** AMPDU TX queues exhausted → aggregation start fails
  (`-ENOSPC`); throughput drop, not oops/UAF/corruption.
- Restart path zeros `agg_q_alloc`, so a firmware restart recovers.
- **Severity: MEDIUM–HIGH** (resource leak of a tiny pool; user-visible
  WiFi degradation; not a panic).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** restores AMPDU after firmware command failures on DVM
  hardware; small pool makes leaks matter.
- **Risk:** very low (3 lines, existing helper, v2 reviewed by iwlwifi
  maintainer).
- **Ratio:** favorable.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real leak: alloc bit never cleared if `iwl_sta_tx_modify_enable_tid()`
  fails.
- Stop/flush cannot free it because `tid_data->agg.txq_id` was never
  set.
- Only 9 AMPDU queues; leak is quickly fatal for aggregation.
- 3-line, obviously correct; uses existing dealloc.
- Maintainer (Miri) reviewed v1, dropped the wrong extra dealloc,
  applied v2.
- Johannes Berg was CC’d; no NAK of the remaining change.
- Code present in this 7.3-rc4 tree since v3.5; applies cleanly.
- Matches the stable “error-path resource leak” pattern.

**AGAINST:**
- Not a crash, UAF, or security bug.
- DVM is legacy; fewer users than MVM/MLD.
- Trigger is an error path, not every AMPDU start.
- No Fixes/Cc:stable/syzbot (absence is expected and not a negative).
- Elfring asked for tags; they were never added.

**UNRESOLVED:**
- lore.kernel.org WebFetch 403; stable@ discussion not independently
  confirmed.
- How often ADD_STA fails in the field: not quantified (only that the
  fail path exists in `iwl_send_add_sta()`).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — inverse of alloc;
   maintainer-corrected v2; in mainline since Jul 2026.
2. Fixes a real bug that affects users? **PASS** — leaked HW agg queues;
   AMPDU start then fails.
3. Important issue? **PASS** at resource-leak / WiFi-breakage level (not
   panic). Queue pool of 9 makes it operationally important for DVM.
4. Small and contained? **PASS** — +3/-1, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — DVM `iwlagn_tx_agg_start()`
   is here and matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/doc exception. Ordinary error-
path leak fix.

**Step 9.4: MAKE YOUR DECISION**

This belongs in this tree: DVM is present, the leak is real, and the fix
is a tiny, reviewed rollback. AMPDU queue exhaustion is a serious
functional failure for remaining DVM hardware, and regression risk is
negligible.

What it solves for users of this tree: failed `REPLY_ADD_STA` during TX
aggregation start no longer permanently consumes one of nine AMPDU
queues until firmware restart.

Verification:
- [Phase 1] Tags: Link msgid 20260401030555.541685-1; SOB Haoxiang Li +
  Miri Korenblit; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: +3/-1 in `iwlagn_tx_agg_start()`; adds
  `iwlagn_dealloc_agg_txq()` when `iwl_sta_tx_modify_enable_tid()` fails
- [Phase 2] Confirmed alloc sets `agg_q_alloc` bit; dealloc clears it
  (`tx.c` 463–482)
- [Phase 2] `iwl_send_add_sta()` can return cmd error or `-EIO` (`sta.c`
  82–123)
- [Phase 2] 9 AMPDU queues: `IWLAGN_FIRST_AMPDU_QUEUE=11`,
  `IWLAGN_NUM_QUEUES=20`
- [Phase 2] Stop cannot recover: `txq_id` not stored, state stays
  `IWL_AGG_OFF`
- [Phase 3] Blame: alloc path from 2012 (`9eae88fa9a02e3` /
  `1479177ba69023`), contained in v3.5-rc1
- [Phase 3] No Fixes: tag; no later follow-up on `dvm/tx.c` after this
  commit
- [Phase 3] Author has no other iwlwifi commits; Miri is iwlwifi
  maintainer
- [Phase 4] `b4 dig -c 94280e6e0c69a`: lore patch-id match for v2
- [Phase 4] `b4 dig -a`: v1 2026-03-30, v2 2026-04-01 (applied)
- [Phase 4] v1 mbox: extra dealloc on `IWL_EMPTYING_HW_QUEUE_ADDBA`;
  Miriam rejected it
- [Phase 4] `b4 dig -w`: Miri + Johannes + linux-wireless
- [Phase 4] Markus pointed at stable-kernel-rules; Johannes replied to
  that nit only
- [Phase 4] UNVERIFIED: stable@ archive (HTTP 403)
- [Phase 5] Caller: `iwlagn_mac_ampdu_action()`
  `IEEE80211_AMPDU_TX_START`
- [Phase 6] `make kernelversion` / Makefile: 7.3.0-rc4; `git describe
  HEAD`: v7.3-rc4-27-gf0100363d8c37
- [Phase 6] Pre-fix source from `94280e6e0c69a^` lacks dealloc
- [Phase 6] `CONFIG_IWLDVM` still in Kconfig; restart path zeros
  `agg_q_alloc` (`main.c` ~1021)
- [Phase 8] Failure: AMPDU queue exhaustion / `-ENOSPC`, not oops;
  severity MEDIUM–HIGH

**YES**

 drivers/net/wireless/intel/iwlwifi/dvm/tx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
index a7806776a51eb..1a0167f67c7bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
@@ -604,8 +604,10 @@ int iwlagn_tx_agg_start(struct iwl_priv *priv, struct ieee80211_vif *vif,
 	}
 
 	ret = iwl_sta_tx_modify_enable_tid(priv, sta_id, tid);
-	if (ret)
+	if (ret) {
+		iwlagn_dealloc_agg_txq(priv, txq_id);
 		return ret;
+	}
 
 	spin_lock_bh(&priv->sta_lock);
 	tid_data = &priv->tid_data[sta_id][tid];
-- 
2.53.0

