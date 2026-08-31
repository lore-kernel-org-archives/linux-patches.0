Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AC4510452;
	Mon, 31 Aug 2026 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183783; cv=none; b=hEVClr4Kl8OzxXxNPeRHwiYeLwbpWBf/tBh4h1bJ7P/dLafK9R+72h8LSmjvfgfzo2U/VVQwe1gE9VIxGB8zD8vPzKHRIpHzzApk7Xxy8nsc7aLvNhHQdCBkmZegrBIsQV3UnZZrVCluv3VPhTI9ydcIkeX8GhDdJSkGkv6tm5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183783; c=relaxed/simple;
	bh=1cP5rBgxxLWpKqkFzZ8P53HPnPcg/IunrnTMaYZwWfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k0VO3RIF6TX7KjcrMIP5bLDVzPG4R7ZOnOsKliTN0LXGUjDem8+fDwPw5GacoozaqrwS5j1HPi3LIkzG0Zu9DozDiFHZuduewH07Q/UEjXN+blwJC2QNsy4Y2VPY6akK+eqhPTJUPgB+bLn/QikeOJY9YHIyOYLETvvvEG26BQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FlaLGiii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FlaLGiii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4121F000E9;
	Mon, 31 Aug 2026 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183780;
	bh=k0KTPZiwC329MUEJR9yhp7CIuCchxZYNZ4GrrKiS+8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FlaLGiii4wN/1G2un+xexnEmCKMPz8YuOCLii6HxH4nMOuqN7Vj855hdVeY2juanH
	 Wf4NPYkw8Ak18dj/R8PCE5uGcAoBxX/KKBhVDQBe+M/oBp0xInmqWel8XlClQGw2e9
	 PG/uDgVReFdiVfIYCzpLwaNFB1t/5vx5uxawuaG2PRY66hwZsI0kyF0DlWWvoYsM/p
	 VYR6jrGxMv7TDc9ZhLYwhUucbX+wIQhHSOwm1o+zxceohXl5qFkSiIbc3tfCAgSnsC
	 kokopH2G3PvL+p/CVkH3bw7QizpY/S9esYc5HUbjDVa8VMc1pyyTewUdmQlbGOzBdH
	 9Cp3ii7aL+bwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: iwlwifi: mvm: fix a possible underflow
Date: Mon, 31 Aug 2026 09:25:28 -0400
Message-ID: <20260831133314.4125787-300-sashal@kernel.org>
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

[ Upstream commit 0cb5260a1027a43f8cdb961e128f2ddd42e46832 ]

We shouldn't trust the firmware about the length of the wowlan packet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715215523.fbd989cc85e2.If68de403bfa4943732c025961154c20b01b09e83@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: iwlwifi: mvm: fix a possible
underflow`

**Local tree:** Linux **6.18.44** (`v6.18.44-2-g1b9e1abadee04`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: iwlwifi: mvm]` `[fix]` — validate WoWLAN wake-packet
size from firmware before arithmetic/copy to prevent integer underflow.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Emmanuel Grumbach `<emmanuel.grumbach@intel.com>`
  (author)
- **Signed-off-by:** Miri Korenblit
  `<miriam.rachel.korenblit@intel.com>` (iwlwifi maintainer)
- **Link:** `https://patch.msgid.link/20260715215523.fbd989cc85e2...`
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc: stable, or
  syzbot tags
- Part of series `[PATCH 14/15]` in
  `20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`

### Step 1.3: Body
**Record:**
- **Bug:** Driver trusts firmware-reported WoWLAN wake-packet length
  (`wake_packet_bufsize`) without validating it is large enough for
  header/crypto overhead.
- **Symptom:** Integer underflow on `pktsize -= hdrlen` / `pktsize -=
  ivlen + icvlen`, then `skb_put_data()` with a huge effective size →
  kernel crash on WoWLAN resume.
- **Root cause:** Missing bounds checks before subtracting lengths from
  `pktsize`.
- **Version info:** None in message; wake-packet path dates to 2022.

### Step 1.4: Hidden bug fix?
**Record:** No — explicitly labeled “fix a possible underflow”; clearly
a firmware-validation / memory-safety fix, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/net/wireless/intel/iwlwifi/mvm/d3.c` (+15 / −4)
- **Function:** `iwl_mvm_report_wakeup_reasons()`
- **Scope:** Single-file, surgical fix in WoWLAN wake-packet handling

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Early guard | Dereference `hdr->frame_control` immediately |
`WARN_ON_ONCE(pktsize < sizeof(*hdr)); return;` before further header
use |
| Data-frame path | Copy header (`skb_put_data`) before validating total
size | Validate `pktsize > hdrlen + ivlen + icvlen` via `IWL_FW_CHECK`,
then copy |
| Underflow site | `pktsize -= ivlen + icvlen` without prior size check
| Same subtraction only after validation |

### Step 2.3: Bug mechanism
**Record:** **Integer underflow / out-of-bounds access (memory
safety).**
- `pktsize` is `int`; subtracting `hdrlen`, `ivlen`, `icvlen` when
  firmware reports a too-small value makes `pktsize` negative.
- `skb_put_data(pkt, pktdata, pktsize)` treats size as unsigned → ~4 GB
  copy attempt.
- Header fields are read before validating minimum buffer size.
- Complements `2d5dec517b539` (validates notification at store time);
  this validates again at report time.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches existing `IWL_FW_CHECK`
patterns in iwlwifi. Low regression risk.
- **Minor concern:** Early `return` skips
  `ieee80211_report_wowlan_wakeup()` (unlike `goto report` on alloc
  failure). Acceptable trade-off to avoid processing corrupt firmware
  data.
- **Note:** Current tree has `icvlen = 0; truncated -= icvlen;` ordering
  at lines 1548–1550 (subtracts after zeroing). This commit does not fix
  that; separate issue.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Wake-packet handling in `iwl_mvm_report_wakeup_reasons()`
traces to merge `5d324e5159d9e` (v6.18 base). Original wake-packet
support in commit `219ed58feda9` (Sep 2022) already had unchecked
`pktsize` arithmetic. Bug present since feature introduction.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- `2d5dec517b539` — related wake-packet notification validation;
  **already in this tree**
- `dd90880eb5ec5` — OOB read fix in `iwl_mvm_nd_match_info_handler()`
- Patch 15/15 (ND match struct sizing) is **independent**; patch 14/15
  is standalone

### Step 3.4: Author context
**Record:** Emmanuel Grumbach is a core iwlwifi developer; July 2026
series is a batch of firmware-validation hardening fixes. Miri Korenblit
is iwlwifi maintainer.

### Step 3.5: Dependencies
**Record:** No prerequisites. `IWL_FW_CHECK` exists in `fw/dbg.h`. Self-
contained; does not need patch 15/15.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Local mbox
`20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`,
patch 14/15. Cover letter lists it under “bugfixes.” `b4 dig -c
2d5dec517b539` worked for the related patch; direct `b4 dig` on this
commit hash unavailable (not yet committed upstream in this checkout).
Lore URL blocked by bot protection.

### Step 4.2: Reviewers
**Record:** Series cover shows Intel iwlwifi maintainers as authors; no
explicit review thread found in local mbox for patch 14.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Intel-internal
firmware-trust hardening, consistent with related fixes in the same
series.

### Step 4.4: Series context
**Record:** Patch 14/15 of 15; independent of patch 15/15 (struct layout
change).

### Step 4.5: Stable list history
**Record:** No stable-list discussion found. Not a negative signal.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `iwl_mvm_report_wakeup_reasons()` (modified)

### Step 5.2: Callers
**Record:**
- `iwl_mvm_query_wakeup_reasons()` → called from D3 resume path (~line
  2770)
- Triggered on **system resume from suspend** when WoWLAN wakes the host
- Requires `CONFIG_PM`, `CONFIG_IWLMVM`, WoWLAN enabled

### Step 5.3: Callees
**Record:** `WARN_ON_ONCE`, `IWL_FW_CHECK`, `alloc_skb`, `skb_put_data`,
`ieee80211_data_to_8023`, `kfree_skb`, `ieee80211_report_wowlan_wakeup`

### Step 5.4: Reachability
**Record:** Reachable on every WoWLAN wakeup with a wake packet on Intel
MVM hardware — common laptop suspend/resume path. Not userspace-
triggerable directly, but affects all WoWLAN users on resume.

### Step 5.5: Similar patterns
**Record:** Same series and tree already have multiple `IWL_FW_CHECK`
validations (`mvm/tx.c`, `mvm/rxmq.c`, `mld/tx.c`). This follows
established iwlwifi defensive pattern.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE (6.18.44)

### Step 6.1: Buggy code present?
**Record:** **YES.** Lines 1508–1559 in `d3.c` lack the proposed checks.
Underflow path is live.

### Step 6.2: Backport complications
**Record:** **Clean apply.** Patch 14 hunks applied to `d3.c` with +7
line offset. No structural conflicts.

### Step 6.3: Related fixes already present?
**Record:** `2d5dec517b539` (notification-time validation) is in tree.
This underflow fix is **not** present (`grep "pktsize is too small"`
only in mbox).

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem / criticality
**Record:** `drivers/net/wireless/intel/iwlwifi/mvm` — **IMPORTANT**
(Intel WiFi on a large share of laptops/desktops).

### Step 7.2: Activity
**Record:** Actively maintained; several iwlwifi validation fixes
already backported to this 6.18.y tree in 2026.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Intel WiFi users with WoWLAN (`CONFIG_IWLMVM` + PM). Large
population on laptops.

### Step 8.2: Trigger conditions
**Record:** Firmware reports `wake_packet_bufsize` smaller than actual
802.11 header + IV/ICV overhead during WoWLAN wakeup. Requires firmware
bug or corruption; rare but plausible. Not unprivileged-userspace-
triggerable.

### Step 8.3: Failure severity
**Record:** Integer underflow → massive `skb_put_data()` → **kernel
oops/panic on resume** — **CRITICAL** for affected path.

### Step 8.4: Risk/benefit
**Record:**
- **Benefit:** HIGH — prevents crash on WoWLAN resume
- **Risk:** LOW — ~15 lines, defensive checks only, established macro
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR:**
- Real integer underflow → crash on resume
- Buggy code confirmed in 6.18.44 tree
- Small, surgical, obviously correct
- Complements existing backport `2d5dec517b539`
- Applies cleanly
- iwlwifi maintainer authorship
- Matches stable firmware-validation pattern

**AGAINST:**
- Requires firmware misreporting (not syzbot-proven)
- Early `return` drops wakeup report on corrupt packet (minor, vs.
  crash)
- `icvlen`/`truncated` ordering bug in current tree is separate (not
  introduced by this patch)

**UNRESOLVED:** No public review thread or syzbot reproducer (not needed
for decision).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — logic verified; maintainer-
   signed
2. Fixes a real bug? **PASS** — demonstrated underflow path
3. Important issue? **PASS** — resume-time kernel crash
4. Small and contained? **PASS** — one function, ~19 lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** N/A (not device ID, quirk, DT, docs, or build fix — standard
bug fix).

### Step 9.4: Decision rationale
For Linux **6.18.44**, the vulnerable WoWLAN wake-packet code is present
and unpatched. Malicious or buggy firmware length fields can underflow
`pktsize` and crash the kernel during suspend resume — a high-severity,
low-risk fix that belongs in stable.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user query and mbox
  patch 14/15
- **[Phase 1]** Confirmed patch 14/15 in
  `20260715_miriam_rachel_korenblit_wifi_iwlwifi_fixes_07_15_2026.mbx`
- **[Phase 2]** Read `d3.c` lines 1454–1588; confirmed missing
  validation
- **[Phase 2]** Simulated underflow: `pktsize=10, hdrlen=24` →
  `pktsize=-34` → `4294967262` unsigned
- **[Phase 3]** `git describe HEAD` → `v6.18.44-2-g1b9e1abadee04`;
  Makefile `6.18.44`
- **[Phase 3]** `git blame` lines 1508–1560 → merge `5d324e5159d9e`
- **[Phase 3]** `git show 219ed58feda9` → wake packet support from Sep
  2022 with same unchecked arithmetic
- **[Phase 3]** `git show 2d5dec517b539` → related fix already in tree
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/wireless/intel/iwlwifi/mvm/d3.c` → fix not present
- **[Phase 4]** Read cover letter: listed as “bugfixes”, patch 14/15
  standalone
- **[Phase 4]** `b4 dig -c 2d5dec517b539` → lore URL for related patch
- **[Phase 4]** WebFetch lore URL → blocked (bot protection); relied on
  local mbox
- **[Phase 5]** Traced call chain: resume →
  `iwl_mvm_query_wakeup_reasons` → `iwl_mvm_report_wakeup_reasons`
- **[Phase 5]** `grep IWL_FW_CHECK` → macro present in `fw/dbg.h`
- **[Phase 6]** `grep "pktsize is too small"` → only in mbox, not in
  tree
- **[Phase 6]** `git apply --check` on patch 14 d3.c hunks → succeeded
  (offset +7)
- **[Phase 6]** Confirmed `iwl_mvm_wowlan_store_wake_pkt` and wake-
  packet path exist
- **[Phase 8]** Assessed severity: resume crash on WoWLAN path

**YES**

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
index dd1c21065bc33..82dca6ba56c7f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/d3.c
@@ -1516,6 +1516,10 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 		if (WARN_ON_ONCE(truncated < 0))
 			truncated = 0;
 
+		/* this would be a firmware bug */
+		if (WARN_ON_ONCE(pktsize < sizeof(*hdr)))
+			return;
+
 		if (ieee80211_is_data(hdr->frame_control)) {
 			int hdrlen = ieee80211_hdrlen(hdr->frame_control);
 			int ivlen = 0, icvlen = 4; /* also FCS */
@@ -1524,10 +1528,6 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 			if (!pkt)
 				goto report;
 
-			skb_put_data(pkt, pktdata, hdrlen);
-			pktdata += hdrlen;
-			pktsize -= hdrlen;
-
 			if (ieee80211_has_protected(hdr->frame_control)) {
 				/*
 				 * This is unlocked and using gtk_i(c)vlen,
@@ -1553,6 +1553,17 @@ static void iwl_mvm_report_wakeup_reasons(struct iwl_mvm *mvm,
 				truncated = 0;
 			}
 
+			if (IWL_FW_CHECK(mvm,
+					 pktsize <= hdrlen + ivlen + icvlen,
+					 "pktsize is too small %d\n",
+					 pktsize)) {
+				kfree_skb(pkt);
+				return;
+			}
+
+			skb_put_data(pkt, pktdata, hdrlen);
+			pktdata += hdrlen;
+			pktsize -= hdrlen;
 			pktsize -= ivlen + icvlen;
 			pktdata += ivlen;
 
-- 
2.53.0

