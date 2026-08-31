Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9FA5448A9;
	Mon, 31 Aug 2026 13:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183971; cv=none; b=aK7NUXXmwl/FhQCUTpdJC6rexPpEErFNXugZyg9SdFthc/q/hmnuWVnPLBVSUhnXw0mcmvcpONhKf4FTlfanNKIO3EGbhr9yaLIwLlSz4UnxYhKvIhCatSVnl5J1aTIqrIvuUlCjFPzVjyiop+MXiT7vu3xW6kMHLWR/jT3hdPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183971; c=relaxed/simple;
	bh=kOCaNd5GKDpxFsKZiaI5cQCiIzu05tOI/l8XsP15mU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uEu2lBN9N0hw3vk+Nlx7cSz5uGW4LNRAPIsmidFHORs/9AQqloWfxSEN41GFRm7Nin8L0U4OmN53tFzROTXT4AMa5+ihPVUWRsP4kEaEVy9TxVnP9VDXYHQAnfIcOc/EPWS7lR2J92HesEQhb8LO0L/z0+S3ZNV7eXyWCpInJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mx8ssYoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mx8ssYoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7671F000E9;
	Mon, 31 Aug 2026 13:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183967;
	bh=kKdZtzSu0K1WOXba92VDkkedMzAsQTHSPtmtdiXhI7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mx8ssYoMlyUUAqN6LBSjpuDP3o+TgczvV50y/8rpWzqMKXMIK9XaVYaII0zhilaxy
	 JzwRYt/0EdahdIQaMEzjXdW32fT0E6DXPh9ktBsKw+0Q0z0yuLyye3TpkvVg7pnZtE
	 0xbegz67+w/Qzz01Y3x2nyZSkgU+FAwZg/ESojKm28Zt5EMXl6s+mSm1SrS5c5PeUI
	 uLHxnM4LZz1DWmqfZeonge00yDFrOAOrE1iHtbeCYVkxTEhAUmipWSdP5KxTo/1E/E
	 XtMdHVPF+XdSIxjKEIY+w39uGPscBrfAIcF/VCx/WUxIvVkitPKO4HY0rELlChsfBe
	 NQ/sYvd71uRCg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: iwlwifi: mvm: add a check on the tid coming from the firmware
Date: Mon, 31 Aug 2026 09:27:18 -0400
Message-ID: <20260831133314.4125787-410-sashal@kernel.org>
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

[ Upstream commit 0e4c0d83267261cf67ec9690856edf4a56bb7dfc ]

ba_notif->tid is a firmware-controlled u8 that is used directly
as an array index into tid_data[] without any validation. Add a
bounds check against IWL_MAX_TID_COUNT before dereferencing the
array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.d7c3e75d47af.If88948108cfc8b5fb3ce5531d927855d1b3b6b30@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: add a check on the tid
coming from the firmware`

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`, `make
kernelversion` → 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[wifi: iwlwifi: mvm]` `[add]` — add bounds validation on
firmware-supplied TID in legacy BA notification handler.

**Step 1.2 — Tags**
Record:
- `Assisted-by: GitHubCopilot:gpt-5.3-codex`
- `Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>`
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
- `Link:` patch.msgid.link (redirects to lore; blocked by bot
  protection)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` tags
- Part of Intel iwlwifi fix series `[PATCH 12/15]` (2026-07-15)

**Step 1.3 — Body analysis**
Record:
- **Bug:** `ba_notif->tid` is firmware-controlled `u8`, used directly as
  `tid_data[]` index without validation.
- **Symptom:** Out-of-bounds access into `mvmsta->tid_data[]` when
  firmware sends invalid TID.
- **Root cause:** Missing bounds check before `&mvmsta->tid_data[tid]`
  dereference in legacy (non-compressed) BA notification path.
- No explicit crash report or syzbot reference; defensive validation of
  untrusted firmware input.

**Step 1.4 — Hidden bug fix?**
Record: **Yes** — despite “add a check” wording, this is a real memory-
safety bug fix (out-of-bounds array index), not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/tx.c` (+3 lines)
- **Function:** `iwl_mvm_rx_ba_notif()`
- **Scope:** Single-file, surgical fix in one error-handling path

**Step 2.2 — Code flow change**
Record:
- **Before:** `tid = ba_notif->tid` → RCU lock → STA lookup → `tid_data
  = &mvmsta->tid_data[tid]` (unchecked).
- **After:** Same, but return early via `IWL_FW_CHECK()` if `tid >=
  ARRAY_SIZE(mvmsta->tid_data)`.
- Affects the **legacy** BA notification path
  (`!iwl_mvm_has_new_tx_api()`), not the compressed-BA path at the top
  of the function.

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Buffer overflow / out-of-bounds array access (memory
  safety).
- **Mechanism:** `tid_data` is `struct iwl_mvm_tid_data
  tid_data[IWL_MAX_TID_COUNT + 1]` (9 elements, indices 0–8).
  `ba_notif->tid` is `u8` (0–255). Values ≥ 9 cause OOB read at:

```2176:2180:drivers/net/wireless/intel/iwlwifi/mvm/tx.c
        tid_data = &mvmsta->tid_data[tid];

        ba_info.status.ampdu_ack_len = ba_notif->txed_2_done;
        ba_info.status.ampdu_len = ba_notif->txed;
        ba_info.status.tx_time = tid_data->tx_time;
```

- `iwl_mvm_tx_reclaim()` has `tid > IWL_MAX_TID_COUNT` guard, but that
  runs **after** the OOB access above.

**Step 2.4 — Fix quality**
Record:
- Fix is minimal and follows existing `IWL_FW_CHECK()` pattern in the
  same function (STA ID check at lines 2169–2173).
- `ARRAY_SIZE(mvmsta->tid_data)` is compile-time only (no runtime
  dereference of uninitialized `mvmsta`); equivalent to `tid >
  IWL_MAX_TID_COUNT`.
- Low regression risk; only rejects invalid firmware values.
- Note: related patch 11/15 in the same series fixes a **different** bug
  in the compressed-BA path (`tid_data[i]` vs `tid_data[tid]`); this
  commit is standalone for the legacy path.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Legacy BA-notif code at lines 2158–2200 traces to
`5d324e5159d9e` (6.18 merge base). Shallow history limits deeper blame;
function has been in iwlwifi MVM for many releases.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag present.

**Step 3.3 — Related file history**
Record: This tree has multiple recent iwlwifi validation fixes
backported (e.g. `dd90880` OOB read, `2d5dec5` wake-packet read,
`a076b0c` SAR GEO validation). This TID check is **not** yet present.
Patch 11/15 (compressed-BA `tid_data[i]` fix) is also **not** in this
tree.

**Step 3.4 — Author context**
Record: Emmanuel Grumbach and Miri Korenblit are Intel iwlwifi
maintainers. Part of a 15-patch Intel fix batch from 2026-07-15.

**Step 3.5 — Dependencies**
Record: **Standalone.** No prerequisite commits required. Applies to
existing legacy path only.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record: Patch found in local mbox
`20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx` as
`[PATCH 12/15]`. `b4 dig` and lore.kernel.org blocked by Anubis bot
protection; could not fetch live thread. No stable nomination found in
available sources.

**Step 4.2 — Reviewers**
Record: UNVERIFIED from live lore. Cover letter shows Intel iwlwifi
maintainers as authors; series is internal Intel bugfix batch.

**Step 4.3 — Bug report**
Record: No external bug report, syzbot, or user crash report referenced.
Bug identified via code review (GitHub Copilot assisted).

**Step 4.4 — Series context**
Record: Patch 11/15 fixes compressed-BA path (wrong index + bounds
check). Patch 12/15 fixes legacy path (missing bounds check).
Independent; either can be backported alone.

**Step 4.5 — Stable list history**
Record: UNVERIFIED — lore stable search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions**
Record: `iwl_mvm_rx_ba_notif()` modified.

**Step 5.2 — Callers**
Record: Registered as `RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, ...)`
in `ops.c` line 320. Invoked synchronously on firmware BA notification —
hot TX completion path.

**Step 5.3 — Callees**
Record: After TID handling, calls `iwl_mvm_tx_reclaim()` and accesses
`tid_data->tx_time`, `tid_data->rate_n_flags`.

**Step 5.4 — Reachability**
Record:
- Reachable whenever firmware sends `BA_NOTIF` on devices with **legacy
  TX API** (`!iwl_mvm_has_new_tx_api()` → `!mac_cfg->gen2`).
- Covers older Intel WiFi hardware still supported in 6.18.y.
- Trigger requires malformed/corrupt firmware notification (firmware
  bug, corruption, or hostile firmware).

**Step 5.5 — Similar patterns**
Record: Driver consistently validates TIDs elsewhere (`WARN_ON_ONCE(tid
>= IWL_MAX_TID_COUNT)` in `tx.c:964`, `sta.c:3089`, `rs.c:593`, etc.).
This path was an outlier missing validation.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code present?**
Record: **YES.** At lines 2160–2176 in this 6.18.44 tree, `tid =
ba_notif->tid` is used without bounds check before `tid_data =
&mvmsta->tid_data[tid]`. Fix is **not** present.

**Step 6.2 — Backport complications**
Record: **Clean apply expected.** 3-line insertion at a stable location;
no structural conflicts visible. `IWL_FW_CHECK` macro exists in
`fw/dbg.h`.

**Step 6.3 — Related fixes already present?**
Record: No. `git log --grep="check on the tid"` and `--grep="invalid
TID"` return nothing for this fix. Compressed-BA patch 11/15 also not
applied (`tid_data[i]` still at line 2141).

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT** (Intel
WiFi, widely deployed; not core kernel but affects many
laptops/desktops).

**Step 7.2 — Activity**
Record: Actively maintained; multiple iwlwifi validation fixes already
backported to this 6.18.44 tree in 2026.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Users of Intel WiFi devices using legacy MVM TX API (pre-gen2
MAC config). Driver-specific, but Intel WiFi is very common on x86
laptops.

**Step 8.2 — Trigger conditions**
Record: Firmware sends `BA_NOTIF` with `tid >= 9` on legacy path.
Unlikely in normal operation, but plausible with firmware bugs or
corruption. Not userspace-triggerable directly, but firmware is treated
as untrusted input in stable security practice.

**Step 8.3 — Failure mode severity**
Record: Out-of-bounds read (and potential write via subsequent
`iwl_mvm_tx_reclaim` using corrupted `tid_data`) → kernel oops, memory
corruption. **Severity: HIGH** (memory safety; possible
crash/corruption).

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Prevents OOB access on a firmware-driven hot path; aligns
  with other iwlwifi validation backports already in this tree.
- **Risk:** Very low — 3-line defensive check, rejects only invalid
  values.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

| FOR backport | AGAINST backport |
|---|---|
| Real OOB bug on firmware-controlled index | No user crash report or
syzbot reproducer |
| HIGH severity if triggered (crash/corruption) | Legacy TX API only
(not newest gen2 devices) |
| 3-line, obviously correct fix | Part of 15-patch series (but this
patch is standalone) |
| Matches pattern of iwlwifi fixes already in 6.18.44 | Live lore review
unverified |
| Intel maintainer-authored | |
| Buggy code confirmed present in this tree | |
| Fix not yet applied | |

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — logic is straightforward; no
   runtime test cited but pattern is established in-driver.
2. Fixes a real bug? **PASS** — confirmed OOB array index without
   validation.
3. Important issue? **PASS** — memory safety / potential crash (HIGH).
4. Small and contained? **PASS** — 3 lines, one function.
5. No new features/APIs? **PASS** — defensive validation only.
6. Can apply to local tree? **PASS** — buggy code exists; clean apply
   expected.

**Step 9.3 — Exception categories**
Record: None (not device ID, quirk, DT, build, or docs). Standard bug-
fix category.

**Step 9.4 — Decision rationale**
This commit closes a genuine out-of-bounds access hole where firmware-
controlled `tid` is used to index `tid_data[9]` without validation, on a
path that still exists in Linux 6.18.44. The fix is minimal, follows
existing conventions, and matches the class of iwlwifi validation fixes
already backported to this stable tree. Even without a public crash
report, validating firmware-controlled array indices is appropriate
stable material given the severity of the failure mode.

---

## Verification

- **[Phase 1]** Parsed commit message from user query and local mbox
  `20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`
- **[Phase 2]** Read `tx.c` lines 2073–2201; confirmed OOB access before
  `iwl_mvm_tx_reclaim()` guard
- **[Phase 2]** Verified `tid_data` size: `IWL_MAX_TID_COUNT + 1` = 9 in
  `sta.h:410`; `IWL_MAX_TID_COUNT` = 8 in `iwl-trans.h:271`
- **[Phase 2]** Verified `iwl_mvm_tx_reclaim()` has `tid >
  IWL_MAX_TID_COUNT` at `tx.c:1940-1942` but runs after OOB access
- **[Phase 3]** `git blame` on lines 2160–2189 → `5d324e5159d9e`
- **[Phase 3]** `git log --grep` — fix not present in tree
- **[Phase 4]** Read patch 12/15 from local mbox; cover letter shows
  series context
- **[Phase 4]** `b4 dig` and lore.kernel.org — blocked by Anubis
  (UNVERIFIED live review)
- **[Phase 4]** patch.msgid.link — blocked by Anubis (UNVERIFIED)
- **[Phase 5]** `grep iwl_mvm_rx_ba_notif` — handler in `ops.c:320`
- **[Phase 5]** `iwl_mvm_has_new_tx_api()` → `mac_cfg->gen2` in
  `mvm.h:1515-1518`
- **[Phase 6]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- **[Phase 6]** Confirmed fix absent at `tx.c:2160` (no bounds check)
- **[Phase 6]** Confirmed related patch 11/15 also absent (`tid_data[i]`
  at line 2141)
- **[Phase 7]** `git log --oneline -20 --grep=iwlwifi` — active iwlwifi
  stable backports
- **[Phase 8]** Assessed failure mode as OOB read/write →
  crash/corruption (HIGH)

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 30aee52bf9cb4..ebb201bd23d85 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -2192,6 +2192,9 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	ba_notif = (void *)pkt->data;
 	sta_id = ba_notif->sta_id;
 	tid = ba_notif->tid;
+	if (IWL_FW_CHECK(mvm, tid >= ARRAY_SIZE(mvmsta->tid_data),
+			 "invalid TID %d in BA notif\n", tid))
+		return;
 	/* "flow" corresponds to Tx queue */
 	txq = le16_to_cpu(ba_notif->scd_flow);
 	/* "ssn" is start of block-ack Tx window, corresponds to index
-- 
2.53.0

