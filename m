Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D8E45FFD7;
	Mon, 31 Aug 2026 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183923; cv=none; b=qqZTNCtatKZOc4Flw+8qI2MO8r5zLqCLQGa/fffvtuP0vK+T74VUCMcw5JUqI+hsgAP3TPRMrCD9H3IO2/DURc7VfDOJ4dsCdga5TX3rIK/ouEkYXVB9Oem/nBnKliJnv5xqA2keuabfc5SY0cCx7V/VhF4Ainw3Rg317uoWZtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183923; c=relaxed/simple;
	bh=TKye5Y1Tq2gYwL4yewdRNn7iGycSaH6+CPcr9s5KoIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qnB/HKIAk2mM0ntNCAl/N32Jb1vwWg99CGT1zmHLIeElPizZ2Y537GFV10W2IKMcZJfiYAifAH2htNpXFW5ElwoRWPijD7HIy1q7XIxRBhqS7pvwme+kRMn7xWLCMWC0A4i7SnZnB7y1OT5RxdUHw4edpoDe0V8lRunxH1fwr1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIMNfo/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIMNfo/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCA51F00A3F;
	Mon, 31 Aug 2026 13:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183921;
	bh=v9oV+HxG+RPS0gIZNWRQn+jawnowrPPUS14ypSx/HeQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jIMNfo/6bRdR70XUqezIhePQPRi1M39L1LgRlCdJdXjRo6ehr6HAp+QkhZPXLkWUa
	 hlAvSATh5znurvpoMrYJXZzBWn/WpmoJT5vZMO+LJfXR2+oOzjdHUXQ7jFFUkaRZUp
	 SGHlhHtPP1TimXH47VoMhPWbFKiLT8GiRL5waxkfJ1SCvq7YY0iRmftTub/3jaef4/
	 TYdvXH47lSIS+qC2chASDaqomDpbSpMZDfGmHEXETVBjkMr6V4pnnZliaqnI5aNftI
	 b6WdJoFHco0PZmMo97L7ktQyOC81dvzxG7TrK9WA/fJrAqSB//r9BFPOTDv6ZzVdr8
	 0OQjBtO1Egvew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: iwlwifi: mld: validate reorder BAID
Date: Mon, 31 Aug 2026 09:26:50 -0400
Message-ID: <20260831133314.4125787-382-sashal@kernel.org>
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

[ Upstream commit 219292e73e40d131925a1caf413203671092dd7a ]

Reject BAIDs >= IWL_MAX_BAID before indexing fw_id_to_ba.

This prevents out-of-bounds access on malformed notifications.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.07ea823b8eea.Ica915fa0cce0427bf5e3420ae933f57118fedf86@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi: mld]` `[validate]` — Add bounds validation for
Block Ack ID (BAID) in the MLD reorder RX path.

**Step 1.2 — Tags**
Record:
- `Assisted-by: GitHubCopilot:gpt-5.3-codex`
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
  (author)
- `Link:` https://patch.msgid.link/20260714141909.07ea823b8eea.Ica915fa0
  cce0427bf5e3420ae933f57118fedf86@changeid
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (committer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`, or syzbot tags
- Mailing-list thread includes `Reviewed-by: Ilan Peer
  <ilan.peer@intel.com>`

**Step 1.3 — Body analysis**
Record:
- **Bug:** BAID from firmware `reorder_data` can be out of range for
  `fw_id_to_ba[]`.
- **Symptom:** Out-of-bounds access when indexing
  `mld->fw_id_to_ba[baid]`.
- **Root cause:** `iwl_mld_reorder()` only rejects the invalid sentinel
  (`0x7f`) but not BAIDs `>= IWL_MAX_BAID` (32).
- **No version info** in the commit message.

**Step 1.4 — Hidden bug fix?**
Record: **Yes.** Although the subject says “validate,” this is a real
memory-safety bug fix, not cosmetic cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/mld/agg.c` (+6 / -1
  including copyright year)
- **Function:** `iwl_mld_reorder()`
- **Scope:** Single-file, surgical fix (~5 lines of functional code)

**Step 2.2 — Code flow change**
Record:
- **Before:** After rejecting `IWL_RX_REORDER_DATA_INVALID_BAID` (0x7f),
  code could still use BAIDs 32–126 to index `fw_id_to_ba[32]`.
- **After:** `IWL_FW_CHECK()` rejects `baid >=
  ARRAY_SIZE(mld->fw_id_to_ba)` and returns `IWL_MLD_PASS_SKB`, passing
  the skb up without reordering.
- **Path:** RX reorder hot path in NAPI context.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Buffer overflow / out-of-bounds access (memory safety)
- **Mechanism:** `IWL_RX_MPDU_REORDER_BAID_MASK` is 7 bits (values
  0–127); `fw_id_to_ba` is `IWL_MAX_BAID` (32) entries. Only 0x7f is
  treated as invalid; BAIDs 32–126 index past the array.

**Step 2.4 — Fix quality**
Record:
- **Obviously correct:** Matches existing checks in the same file
  (`iwl_mld_release_frames_from_notif()`,
  `iwl_mld_handle_bar_frame_release_notif()`, `iwl_mld_del_ba()`).
- **Minimal:** Uses existing `IWL_FW_CHECK` macro.
- **Regression risk:** Very low; invalid BAIDs are dropped to the pass-
  through path, same as other validation failures.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `iwl_mld_reorder()` BAID handling introduced in `5d324e5159d9e`
(present since at least v6.17/v6.18 in this tree). Buggy missing-bounds-
check code is in current HEAD.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record:
- Related fix already in this tree: `1de92789ce31e` — “validate sta_mask
  before ffs() in BA session handlers” (another OOB on `fw_id_to_*`
  arrays, with `Cc: stable@vger.kernel.org`).
- Upstream commit: `219292e73e40d`; not yet in HEAD.
- Part of `[PATCH iwlwifi-fixes 06/15]` series, but this hunk is self-
  contained.

**Step 3.4 — Author context**
Record: Emmanuel Grumbach is a long-standing iwlwifi maintainer; Miri
Korenblit is iwlwifi maintainer/committer. Multiple recent mld fixes in
this tree.

**Step 3.5 — Dependencies**
Record: **None.** Uses `IWL_FW_CHECK`, `ARRAY_SIZE`, and
`mld->fw_id_to_ba` — all present. `git apply --check` succeeds cleanly
on current HEAD.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- `b4 dig -c 219292e73e40d`: https://patch.msgid.link/20260714141909.07e
  a823b8eea.Ica915fa0cce0427bf5e3420ae933f57118fedf86@changeid
- Series: `[PATCH iwlwifi-fixes 06/15]`
- `Reviewed-by: Ilan Peer`
- No stable nomination found in thread
- No NAKs found

**Step 4.2 — Reviewers**
Record: CC’d `linux-wireless@vger.kernel.org`,
`johannes@sipsolutions.net`, Emmanuel Grumbach; reviewed by Ilan Peer
(Intel).

**Step 4.3 — Bug report**
Record: N/A — no external bug report or syzbot link. Author describes
“malformed notifications” from firmware.

**Step 4.4 — Series context**
Record: 15-patch iwlwifi-fixes series; this patch only touches
`iwl_mld_reorder()` and does not depend on other series patches.

**Step 4.5 — Stable list**
Record: No stable-list discussion found for this specific patch.
(WebFetch to lore blocked by bot protection; used `b4 dig` mbox
instead.)

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `iwl_mld_reorder()` (modified).

**Step 5.2 — Callers**
Record: Called from `drivers/net/wireless/intel/iwlwifi/mld/rx.c` (~line
1915) during RX packet processing in NAPI context — common WiFi data
path for `CONFIG_IWLMLD` devices.

**Step 5.3 — Callees**
Record: `u32_get_bits()`, `IWL_FW_CHECK()`, `rcu_dereference()`,
`ieee80211_*` helpers, reorder buffer management.

**Step 5.4 — Reachability**
Record: Triggered on every received MPDU that reaches reorder processing
for MLD firmware. Malformed `reorder_data` from firmware
(bug/corruption) can hit the OOB path. Not directly userspace-syscall
triggered, but reachable during normal WiFi RX on affected hardware.

**Step 5.5 — Similar patterns**
Record: Same file already validates BAID in notification handlers (lines
54–55, 124–125, 162–163). `iwl_mld_reorder()` was the missing case. MVM
`iwl_mvm_del_ba()` has similar check; MVM reorder path has the same gap
but is out of scope for this commit.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.44` (`VERSION=6`, `PATCHLEVEL=18`,
`SUBLEVEL=44`). `agg.c` exists from v6.15 onward. Current
`iwl_mld_reorder()` at lines 222–238 lacks the bounds check; fix commit
`219292e73e40d` is **not** in HEAD.

**Step 6.2 — Backport complications**
Record: **Clean apply** verified with `git apply --check`. No structural
conflicts expected.

**Step 6.3 — Related fixes already present?**
Record: `1de92789ce31e` (sta_mask OOB fix in same file) is already in
this tree. The BAID reorder fix is **not** present.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/net/wireless/intel/iwlwifi/mld/` — **IMPORTANT** (Intel
WiFi driver, RX datapath for MLD-capable hardware, `CONFIG_IWLMLD`).

**Step 7.2 — Activity**
Record: Actively maintained; multiple mld fixes already backported into
this 6.18.y tree.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users with `CONFIG_IWLMLD` and MLD-capable Intel WiFi hardware
(newer WiFi 7 / MLO devices).

**Step 8.2 — Trigger conditions**
Record: Firmware delivers `reorder_data` with BAID in range 32–126 (not
0x7f). Uncommon but possible with firmware bugs or corrupted
notifications. Timing-independent.

**Step 8.3 — Failure mode**
Record: Out-of-bounds read of `fw_id_to_ba[baid]` → potential kernel
oops, memory corruption, or unpredictable behavior. **Severity: HIGH**
(memory safety in RX path).

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH — closes a demonstrable OOB hole in a live RX path.
- **Risk:** VERY LOW — 5-line defensive check matching existing in-file
  patterns.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

**FOR:**
- Real out-of-bounds array access bug
- Bug exists in this 6.18.44 tree
- Small, surgical, obviously correct fix
- Consistent with sibling functions in the same file
- Related OOB fix in same file already backported here
- Applies cleanly
- Reviewed-by on mailing list
- Prevents crash/corruption on WiFi RX path

**AGAINST:**
- No user report or syzbot reproduction
- Trigger requires malformed firmware notification (may be rare)
- Part of a 15-patch series (but this patch is standalone)
- Only affects `CONFIG_IWLMLD` hardware (not all iwlwifi users)

**Unresolved:** No confirmed real-world crash report; impact depends on
firmware misbehavior frequency.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — pattern proven elsewhere in
   same file; reviewed on list.
2. Fixes a real bug? **PASS** — demonstrable OOB by code inspection.
3. Important issue? **PASS** — memory safety / potential crash in RX
   path.
4. Small and contained? **PASS** — ~5 functional lines, one function.
5. No new features/APIs? **PASS** — defensive validation only.
6. Can apply to local tree? **PASS** — clean apply verified; code
   exists.

**Step 9.3 — Exception categories**
Record: N/A (standard bug fix, not device ID/quirk/docs).

**Step 9.4 — Decision rationale**
For this **6.18.44** tree, `iwl_mld_reorder()` has a clear bounds-check
omission that can cause out-of-bounds access on `fw_id_to_ba[]`. The fix
mirrors existing validation in the same file, applies cleanly, and
addresses a memory-safety issue in the WiFi RX path. This is the same
class of fix as the already-backported sta_mask OOB fix in `agg.c`.
Conservative stable policy still favors this fix.

---

## Verification

- [Phase 1] `git show 219292e73e40d`: parsed subject, body, tags
- [Phase 2] Read `agg.c` lines 42–170, 194–260; confirmed missing check
  in `iwl_mld_reorder()`
- [Phase 2] `fw/api/rx.h`: `IWL_RX_MPDU_REORDER_BAID_MASK=0x7f000000`,
  `IWL_RX_REORDER_DATA_INVALID_BAID=0x7f`
- [Phase 2] `fw/api/datapath.h`: `IWL_MAX_BAID=32`
- [Phase 2] `mld/mld.h` line 268: `fw_id_to_ba[IWL_MAX_BAID]`
- [Phase 3] `git blame -L 214,238 agg.c`: code from `5d324e5159d9e`
- [Phase 3] `git merge-base --is-ancestor`: upstream fix `219292e73e40d`
  NOT in HEAD
- [Phase 3] `git show 1de92789ce31e`: related sta_mask OOB fix already
  in tree
- [Phase 3] `git apply --check` on `219292e73e40d`: **clean**
- [Phase 4] `b4 dig -c 219292e73e40d -w`: lore URL, CC list, patch 06/15
- [Phase 4] `b4 dig -m /tmp/baid_thread.mbox`: thread saved; `Reviewed-
  by: Ilan Peer`; no stable CC
- [Phase 4] WebFetch lore URL: blocked (bot protection) — used b4 mbox
  instead
- [Phase 5] `grep iwl_mld_reorder`: caller in `mld/rx.c:1915`
- [Phase 6] `git describe HEAD`: `v6.18.44`
- [Phase 6] `git cat-file -e v6.17:v6.18:agg.c`: file exists at both
  tags
- [Phase 6] `git show v6.17:agg.c` lines 210–245: buggy code confirmed
  at v6.17
- [Phase 6] `git log v6.18..HEAD -- agg.c`: only sta_mask fix since
  v6.18
- [Phase 7] `git log -20 -- drivers/net/wireless/intel/iwlwifi/mld/`:
  active mld maintenance
- [Phase 8] `fw/dbg.h`: `IWL_FW_CHECK` logs and returns condition
  (defensive drop)

**YES**The background `git branch -a --contains` check stalled (likely
due to the large branch set) and was stopped. The important part had
already completed: the BAID validation commit exists locally as upstream
`219292e73e40d` and stable-prep `34a2083bcb667`, but neither is in the
current `v6.18.44` HEAD.

**Summary:** This is a small, worthwhile backport for this tree.
`iwl_mld_reorder()` can index past `fw_id_to_ba[32]` when firmware sends
a BAID in the 32–126 range; the fix adds the same bounds check other
paths in `agg.c` already use. It applies cleanly and matches the kind of
OOB fix already backported here (`sta_mask` validation in
`1de92789ce31e`).

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/agg.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/agg.c b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
index e3627ad0321c8..a464ebdec57f1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/agg.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/agg.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2024-2025 Intel Corporation
+ * Copyright (C) 2024-2026 Intel Corporation
  */
 #include "agg.h"
 #include "sta.h"
@@ -222,6 +222,11 @@ iwl_mld_reorder(struct iwl_mld *mld, struct napi_struct *napi,
 	if (baid == IWL_RX_REORDER_DATA_INVALID_BAID)
 		return IWL_MLD_PASS_SKB;
 
+	if (IWL_FW_CHECK(mld, baid >= ARRAY_SIZE(mld->fw_id_to_ba),
+			 "Got out-of-range BAID %u in reorder_data=0x%x\n",
+			 baid, reorder))
+		return IWL_MLD_PASS_SKB;
+
 	/* no sta yet */
 	if (WARN_ONCE(!sta,
 		      "Got valid BAID without a valid station assigned\n"))
-- 
2.53.0

