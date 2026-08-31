Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1713F441638;
	Mon, 31 Aug 2026 13:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183514; cv=none; b=E7ri5/t6xMVfiVsplWkZ2FXGv5NLaWoixLoRJrjuPayiZQ6ZreqfuHGJHmtiXo6UvgPnuqKnvF7cJbpao/rVVIAcafLHn3ILVnosmQmCC0//gO2O1fBM3z637kKf/6hHhDWVg4JCxOIj9MLRK8USFRAlsjtH4/ywfUW2WHlr/hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183514; c=relaxed/simple;
	bh=vkzjvcfVOuU9CfoH9pSbPF3ZMRBrTjtnmjiEgS+KVoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G/d8B1rgVveaxuuqjFUHyykEbQmbgEh5NHPHk3J7g9B/21r3qcs+LLKW8VPIN2zlykb9HBnQww0TwWTb4N4xP4Bb4BjbovheCaWzSBI38ao7tDg/2JGEFvXIPETO5QJa74dBdVXtj9uHh3KK+KOave0mfCAh9LQGlAkqtrdtXKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RENWGPik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RENWGPik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21EF1F00ACF;
	Mon, 31 Aug 2026 13:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183511;
	bh=VG40jkJfT/mfWU5YClkiIfIvVi7DZ27PT6hNxwmHfaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RENWGPikzrameTPXDJ3W08SduHEMqQrOTVvnjsxKuE3dSpI9c/z1pdJlyVzwzwruD
	 /ulb9S45TQWJrJk8eQvO3wB1HWLTqv269kVANwzEbNv3nKtmXcCCdVj6GKSpwzRkxp
	 X82TZzuuhnZ5OTXd5Jx01RnfjzgjKAAFS02h/k/hvpuTB6bK7GZNxOjIYyN77XK/7R
	 Ws1yq+UiVTAPKU26i+RejT5jSo2OvCznJa2RROkpEFVoXzi8h7LDV/Hb2Y60C88kQu
	 YnyVyfueBOp/W2zUsKHRuU/aDneNQ1XNyIOBkQhY1lZAT/o/Sn+mWm+ncuaoBYNH7e
	 Yu4oNzdSoQthQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] wifi: iwlwifi: mvm: validate mac_link_id in session protect notif
Date: Mon, 31 Aug 2026 09:22:48 -0400
Message-ID: <20260831133314.4125787-140-sashal@kernel.org>
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

[ Upstream commit 71245daf7d58a3c407c7e1422facce13ff6a584b ]

Check the mac_id before accessing the vif_id_to_mac array.

Assisted-by: GitHubCopilot:gpt-5.3-codex
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://patch.msgid.link/20260714141909.547ea470e686.I931445ae6f37bf0e1ef6f112c811712fc48af9c9@changeid
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: validate mac_link_id in
session protect notif`

**Local tree:** Linux **6.18.44** (`v6.18.44-1-g2736c32da98b9`,
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=44`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mvm]` `[validate]` — Add bounds validation
for `mac_link_id` in the session protection firmware notification
handler before indexing `vif_id_to_mac`.

### Step 1.2: Tags
**Record:**
- **Assisted-by:** GitHubCopilot:gpt-5.3-codex
- **Signed-off-by:** Emmanuel Grumbach \<emmanuel.grumbach@intel.com\>
  (iwlwifi maintainer)
- **Link:** https://patch.msgid.link/20260714141909.547ea470e686.I931445
  ae6f37bf0e1ef6f112c811712fc48af9c9@changeid
- **Signed-off-by:** Miri Korenblit
  \<miriam.rachel.korenblit@intel.com\>
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags
- **Notable:** Maintainer-authored; no fuzzer or user bug report cited

### Step 1.3: Body
**Record:**
- **Bug:** `mac_link_id` from firmware is used to index `vif_id_to_mac`
  without validating it first.
- **Symptom:** Not explicitly stated (no crash trace); implied mis-
  handling of invalid firmware notification.
- **Root cause (from code):** `mac_link_id` is read as a 32-bit value
  into an `int`, then passed to `iwl_mvm_rcu_dereference_vif_id()` which
  takes `u8`. Values ≥ 256 truncate modulo 256 and can map to valid
  indices 0–3, bypassing the helper’s `WARN_ON` bounds check.

### Step 1.4: Hidden bug fix?
**Record:** Yes. Despite the terse message, this is a real logic/safety
bug fix, not cosmetic cleanup. It mirrors an existing pattern in
`rxmq.c` for the same array.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/time-event.c` (+5
  lines)
- **Function:** `iwl_mvm_rx_session_protect_notif()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** `id = le32_to_cpu(notif->mac_link_id)` → immediate
  `iwl_mvm_rcu_dereference_vif_id(mvm, id, true)` (implicit `int` → `u8`
  truncation).
- **After:** `IWL_FW_CHECK` on full `int id` against
  `ARRAY_SIZE(mvm->vif_id_to_mac)` (4); early return if invalid; then
  existing lookup proceeds.
- **Path:** Firmware RX notification handler
  (`SESSION_PROTECTION_NOTIF`), normal runtime path during
  association/session protection.

### Step 2.3: Bug mechanism
**Record:** **Logic / bounds-check bypass via type truncation.**

`NUM_MAC_INDEX_DRIVER` = 4, so valid indices are 0–3:

```15:16:drivers/net/wireless/intel/iwlwifi/fw/api/mac.h
#define NUM_MAC_INDEX_DRIVER    MAC_INDEX_AUX
#define NUM_MAC_INDEX           (NUM_MAC_INDEX_DRIVER + 1)
```

`iwl_mvm_rcu_dereference_vif_id()` only checks the truncated `u8`:

```1384:1391:drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
static inline struct ieee80211_vif *
iwl_mvm_rcu_dereference_vif_id(struct iwl_mvm *mvm, u8 vif_id, bool rcu)
{
        if (WARN_ON(vif_id >= ARRAY_SIZE(mvm->vif_id_to_mac)))
                return NULL;
```

Example: `mac_link_id = 256` → `u8` = 0 → passes check → wrong VIF at
index 0. Values 4–255 are caught; values ≥ 256 congruent to 0–3 mod 256
are not.

Downstream effects in `iwl_mvm_rx_session_protect_notif()` include
modifying the wrong interface’s `time_event_data`, calling
`iwl_mvm_te_check_disconnect()` on the wrong VIF, and corrupting P2P ROC
state.

### Step 2.4: Fix quality
**Record:** Obviously correct; matches existing driver pattern in
`rxmq.c`:

```2618:2623:drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
        /* >= means AUX MAC/link ID, no energy correction needed then */
        if (IWL_FW_CHECK(mvm, id >= ARRAY_SIZE(mvm->vif_id_to_mac),
                         "invalid link ID %d\n", id))
                return;

        vif = iwl_mvm_rcu_dereference_vif_id(mvm, id, false);
```

**Regression risk:** Very low — early return only on invalid firmware
input; no API or locking changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `iwl_mvm_rx_session_protect_notif()` exists at lines
953–1025 in this tree. Blame attributes lines to merge commit
`5d324e5159d9e` (shallow history for this file). Function and handler
registration in `ops.c` are present in 6.18.44.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** `git log --oneline -20 -- time-event.c` returns only the usb
merge commit (limited per-file history in this checkout). The beacon-
filter validation in `rxmq.c` at line 2619 establishes precedent for
this exact check pattern.

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is iwlwifi maintainer. Miri Korenblit is
an active iwlwifi contributor. High credibility for driver correctness.

### Step 3.5: Dependencies
**Record:** Standalone; no series or prerequisite commits. Uses existing
`IWL_FW_CHECK` macro from `fw/dbg.h`. No new structures or APIs.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig` on HEAD did not match this patch. Link URL and
lore.kernel.org blocked by Anubis bot protection — could not read
thread. **UNVERIFIED:** reviewer feedback and stable nominations.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not run (no commit hash
available in this evaluation context).

### Step 4.3: Bug report
**Record:** No Reported-by or syzbot link. Bug inferred from code
analysis and driver consistency with `rxmq.c`.

### Step 4.4: Related patches
**Record:** Same validation pattern exists for beacon filter
notifications in `rxmq.c`. This commit closes a gap in `time-event.c`
where `IWL_FW_CHECK` is currently absent.

### Step 4.5: Stable list
**Record:** **UNVERIFIED** — lore stable search blocked.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_rx_session_protect_notif()` (modified); uses
`iwl_mvm_rcu_dereference_vif_id()`, `iwl_mvm_te_check_disconnect()`,
`iwl_mvm_te_clear_data()`, `ieee80211_ready_on_channel()` /
`ieee80211_remain_on_channel_expired()`.

### Step 5.2: Callers
**Record:** Registered in `ops.c` as RX handler for
`SESSION_PROTECTION_NOTIF` under `MAC_CONF_GROUP` — invoked on every
session-protection firmware notification for Intel MVM devices.

### Step 5.3: Callees
**Record:** RCU lookup, spinlocks on `time_event_lock`, mac80211
callbacks. Invalid ID can corrupt another interface’s session-protection
/ ROC state.

### Step 5.4: Reachability
**Record:** Triggered by iwlwifi firmware notifications during WiFi
association, session protection, and P2P ROC. Reachable during normal
WiFi use on Intel hardware (`CONFIG_IWLMVM`).

### Step 5.5: Similar patterns
**Record:** `rxmq.c` lines 272–273 and 2619–2621 already validate before
`vif_id_to_mac` access. `time-event.c` is the outlier lacking this
check.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current `time-event.c` at lines 958–965 has no
`IWL_FW_CHECK`; passes raw `int id` directly to
`iwl_mvm_rcu_dereference_vif_id()`. Fix is **not** yet applied in
6.18.44.

### Step 6.2: Backport complications
**Record:** Clean apply expected — 5-line insertion before
`rcu_read_lock()`. No conflicting changes observed. `IWL_FW_CHECK` and
`vif_id_to_mac` already exist in this tree.

### Step 6.3: Related fixes already present?
**Record:** Beacon-filter path in `rxmq.c` already has this validation.
No duplicate fix for session-protect in this tree (`grep` found no
"Invalid mac_link_id" string).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT**
(Intel WiFi, widely deployed on laptops/desktops).

### Step 7.2: Activity
**Record:** iwlwifi actively maintained; MLD path added alongside legacy
MVM. This fix targets the MVM notification path still used by many
devices in 6.18.y.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users of Intel WiFi with MVM driver (`CONFIG_IWLMVM=y/m`),
during session protection / association / P2P ROC.

### Step 8.2: Trigger conditions
**Record:** Firmware sends `SESSION_PROTECTION_NOTIF` with `mac_link_id`
≥ 4, or ≥ 256 with value mod 256 in 0–3. Requires firmware misbehavior
or edge-case firmware state — not everyday, but plausible and not user-
privilege-dependent.

### Step 8.3: Failure mode severity
**Record:** Wrong-interface session-protection state corruption;
possible spurious disconnect (`iwl_mvm_te_check_disconnect`) or ROC
misbehavior on an unrelated VIF. **Severity: MEDIUM–HIGH** (functional
WiFi breakage, not kernel oops, but user-visible connectivity impact).

### Step 8.4: Risk–benefit
**Record:**
- **Benefit:** Prevents cross-interface state corruption from invalid
  firmware notifications; aligns with existing driver defensive pattern.
- **Risk:** Very low — 5 lines, early return on invalid input only.
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real bug: `int`→`u8` truncation bypasses bounds checking for
  `vif_id_to_mac`
- Wrong VIF can be operated on (disconnect, time-event corruption)
- Small, surgical, maintainer-authored fix
- Matches established pattern in same driver (`rxmq.c`)
- Buggy code confirmed present in Linux 6.18.44; fix not yet applied
- No new APIs or features

**AGAINST backport:**
- No explicit crash report, syzbot, or user Reported-by
- Commit message is minimal
- Trigger requires invalid firmware `mac_link_id` (not proven in the
  wild from available sources)

**UNRESOLVED:**
- Mailing list review discussion (lore blocked)
- Whether a specific production firmware bug motivated this fix

### Step 9.2: Stable rules checklist
| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — matches existing
`rxmq.c` pattern; maintainer SOB |
| 2. Fixes a real bug? | **PASS** — truncation bypass is verifiable in
code |
| 3. Important issue? | **PASS** — wrong-interface WiFi state corruption
/ disconnect |
| 4. Small and contained? | **PASS** — 5 lines, one function |
| 5. No new features/APIs? | **PASS** |
| 6. Can apply to local tree? | **PASS** — code exists; clean apply
expected |

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard
driver bug fix).

### Step 9.4: Decision rationale
For **this** tree (6.18.44), the vulnerable code is present and the fix
is a minimal, obviously-correct defensive validation that prevents
wrong-interface state corruption when firmware sends an out-of-range
`mac_link_id`. It follows an established iwlwifi pattern and carries
negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit
  message
- **[Phase 2]** Read `time-event.c` lines 953–1025: fix absent,
  vulnerable code confirmed
- **[Phase 2]** Read `mvm.h` lines 1384–1394: `u8` parameter + `WARN_ON`
  only on truncated value
- **[Phase 2]** Read `mac.h` line 15: `NUM_MAC_INDEX_DRIVER = 4`
- **[Phase 2]** Read `rxmq.c` lines 2618–2623: identical validation
  pattern exists
- **[Phase 2]** Read `fw/dbg.h` lines 334–342: `IWL_FW_CHECK` logs and
  returns condition
- **[Phase 3]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- **[Phase 3]** `git blame -L 953,970 time-event.c`: function present in
  tree
- **[Phase 3]** `grep IWL_FW_CHECK time-event.c`: no matches (fix not
  present)
- **[Phase 4]** `b4 dig -c HEAD`: no match for this patch
- **[Phase 4]** WebFetch patch.msgid.link and lore.kernel.org: blocked
  by Anubis — **UNVERIFIED**
- **[Phase 5]** `grep iwl_mvm_rx_session_protect_notif`: handler in
  `ops.c` line 355
- **[Phase 5]** `grep iwl_mvm_rcu_dereference_vif_id mvm/`: multiple
  call sites; `time-event.c` lacks pre-check
- **[Phase 6]** Confirmed buggy code at lines 958–965 without
  `IWL_FW_CHECK`
- **[Phase 6]** `grep "Invalid mac_link_id"`: no results (fix not
  applied)
- **[Phase 8]** Traced downstream effects:
  `iwl_mvm_te_check_disconnect`, ROC callbacks on wrong VIF

---

**YES**Two background git history lookups (`git log -S` for when
`iwl_mvm_rx_session_protect_notif` was introduced, and a repo-depth
check) timed out and were killed — likely due to the large tree and the
accidental `--all` on one of them.

That didn’t change the backport verdict: the vulnerable code is present
in this 6.18.44 tree, the fix is a 5-line bounds check matching an
existing `rxmq.c` pattern, and the analysis already concluded **YES**.

 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 1a3a8a3f0fb49..356f68f5e6ac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -960,6 +960,11 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 	struct ieee80211_vif *vif;
 	struct iwl_mvm_vif *mvmvif;
 
+	if (IWL_FW_CHECK(mvm, id >= ARRAY_SIZE(mvm->vif_id_to_mac),
+			 "Invalid mac_link_id (%d) in session protect notif\n",
+			 id))
+		return;
+
 	rcu_read_lock();
 
 	/* note we use link ID == MAC ID */
-- 
2.53.0

