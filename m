Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF325164B2;
	Mon, 31 Aug 2026 13:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183802; cv=none; b=fNgGC1ZajHV9jgKEK7P61Qr4KyauUk7Z0JTv+zx8IBV6Xclnp5u6jUJqjNNFk3IQbQuGigGjJB+rrNXAG5SGfVS44klF0RUe20ehNtKLrjtp/9Db5e0Cft06/9pPXE9JNoMdq/0RoQYT5sJxrIYBBn/c01rn3ns1CBuGh3wa+g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183802; c=relaxed/simple;
	bh=L7af8aqzC/Qc3YaevFfqt4+etccuV2iyPxQ9K6ZDRts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c0/Y3b1OqVCUpelcNkrJJ+3xO+4ydXi9LXLGmY7AKg03UUCuudwVm7fV3Tyg19s/deFNX+54rqDBpkWUmcxPJoqoMRR0iTNt/jySjCae8gP4fcBi1FrtURloA+hEJZfEVWbnTAz8uy/fG+90cX0dDXYeIGRmVxS1HEL1fUfbmNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ17gJmi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ17gJmi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350CA1F00A3F;
	Mon, 31 Aug 2026 13:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183799;
	bh=keYRZYQFeqO2/6ObmA6dJCrZpg8EsFQxd2wsSvAE2pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZ17gJmi7ZOXITOuaPnxhONWvCHamGX2y2KnrFyfbeEkQiTD0xEyNI8LROTgiVT0K
	 M+r7XNG85rnshM75TCaV6O2Dl77kvF0+L5OeCNEjfaVZI+DqXZkMjZ8tzgfKyBNLIF
	 P/bS+xCxtppy5VvZdl2A3PwS3ZZWJoEEVigUayF25/D0T8jmGqSjxuh+zjhqjZuNAN
	 3dqth3G5up8EQWuUTenyYru39Yzml0EYoPfKLxd2IqPlMghWEUPC6DL75n5wRjr16C
	 gq5cRzrpsnbKEGJtyW3k32J1/H7lMqvKxb8QYYwkG9XEs5ETcQ+bDBxjQX/kSZUfJ2
	 CBjcHPQeWgHwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mac80211: validate deauth frame length before reason access
Date: Mon, 31 Aug 2026 09:25:39 -0400
Message-ID: <20260831133314.4125787-311-sashal@kernel.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 4a360c6e18dfa9d70006c7247a6a8cc8dfe0d60f ]

ieee80211_rx_mgmt_deauth() reads the deauth reason code before checking
that the fixed field is actually present in the received frame.

Validate the deauth frame length first and only then read the reason
code.

Assisted-by: Codex:gpt-5.5
Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260612185042.66260-6-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[wifi: mac80211] [validate] validate deauth frame length before
reason access` — subsystem is mac80211; verb is “validate,” indicating a
safety/bug fix.

**Step 1.2 — Tags**
Record:
- `Assisted-by: Codex:gpt-5.5`
- `Assisted-by: Claude:claude-opus-4.8`
- `Signed-off-by: Zhao Li <enderaoelyther@gmail.com>` (author)
- `Link: https://patch.msgid.link/20260612185042.66260-6-
  enderaoelyther@gmail.com`
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (mac80211
  maintainer)
- No `Fixes:`, `Reported-by:`, `Cc: stable@vger.kernel.org`, `Tested-
  by:`, or `Reviewed-by:` tags

**Step 1.3 — Body analysis**
Record:
- **Bug:** `ieee80211_rx_mgmt_deauth()` reads
  `mgmt->u.deauth.reason_code` before confirming the frame is long
  enough.
- **Symptom:** Out-of-bounds read when a deauth frame is shorter than
  the fixed header + reason field (26 bytes).
- **Root cause:** Length check happens after the reason-code
  dereference.
- **Version info:** None in the commit message.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Although framed as validation, this is a real memory-safety
bug: reading fixed fields before bounds-checking.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- **File:** `net/mac80211/mlme.c` (+4 / -2 lines)
- **Function:** `ieee80211_rx_mgmt_deauth()`
- **Scope:** Single-file, surgical fix

**Step 2.2 — Code flow change**
Record:
- **Before:** `reason_code = le16_to_cpu(mgmt->u.deauth.reason_code)` at
  function entry; then `if (len < 24 + 2) return;`
- **After:** Declare `reason_code` uninitialized; length check first
  using `offsetofend(struct ieee80211_mgmt, u.deauth.reason_code)`; only
  then read `reason_code`
- **Path affected:** RX handling of DEAUTH management frames on station
  interfaces

**Step 2.3 — Bug mechanism**
Record:
- **Category:** Buffer out-of-bounds / memory safety
- **Mechanism:** With `len == 24` (valid 802.11 management header only),
  the old code reads 2 bytes at offset 24–25 before rejecting the frame.
  `rx.c` only requires `skb->len >= 24` for management frames, so
  24-byte deauth frames can reach this handler.

**Step 2.4 — Fix quality**
Record:
- Fix is obviously correct and mirrors `ieee80211_rx_mgmt_disassoc()` in
  the same file (which already reads `reason_code` after the length
  check).
- `offsetofend(...)` is equivalent to `24 + 2` for deauth but more
  maintainable.
- Regression risk is very low: only changes ordering for frames that
  would have been dropped anyway.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: Lines in `ieee80211_rx_mgmt_deauth()` trace to `5d324e5159d9e`
(6.18 merge baseline, Nov 2025). The read-before-check pattern is
present in this tree; the function predates the 6.18 `mlme.c` split.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag.

**Step 3.3 — Related file history**
Record: Part of v2 series “validate rx/tx MLME callback frame lengths”
(patches 1/3 cfg80211, 2/3 cfg80211 assoc, 3/3 mac80211 deauth). Patch
3/3 is standalone for mac80211’s direct RX path.

**Step 3.4 — Author context**
Record: Zhao Li has other mac80211 validation fixes in recent history
(`validate individual TWT params`, etc.). Johannes Berg (maintainer)
signed off.

**Step 3.5 — Dependencies**
Record: No dependencies. Patch 3/3 does not require patches 1/2; it
fixes mac80211’s internal path, not `cfg80211_rx_mlme_mgmt()`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Patch discussion**
Record: `b4 dig` did not return a match for this commit hash (not yet in
tree). Local mbox `v2_20260707_enderaoelyther_wifi_cfg80211_validate_rx_
tx_mlme_callback_frame_lengths_before_access.mbx` contains the full v2
series; patch 3/3 matches the analyzed commit. v2 notes per Johannes’
review for patch 1; patch 3/3 had no code changes in v2.

**Step 4.2 — Reviewers**
Record: Johannes Berg signed off. No explicit `Reviewed-by:` in the mbox
for patch 3/3.

**Step 4.3 — Bug report**
Record: No syzbot or user bug report. Patch 1 documents a concrete in-
tree trigger via mwifiex → cfg80211; patch 3/3 addresses the parallel
mac80211 RX path reachable from over-the-air frames.

**Step 4.4 — Series context**
Record: 3-patch series; this commit is independently valuable for
station-mode mac80211 RX.

**Step 4.5 — Stable list**
Record: No stable-list discussion found.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `ieee80211_rx_mgmt_deauth()` (modified)

**Step 5.2 — Callers**
Record:
- `ieee80211_sta_rx_queued_mgmt()` → case `IEEE80211_STYPE_DEAUTH`
- Called from `iface.c` for `NL80211_IFTYPE_STATION`
- Common WiFi station path for all mac80211 clients

**Step 5.3 — Callees**
Record: `ieee80211_tdls_handle_disconnect()`,
`ieee80211_set_disassoc()`, `ieee80211_report_disconnect()`,
`cfg80211_rx_mlme_mgmt()`, `ieee80211_destroy_assoc_data()`

**Step 5.4 — Reachability**
Record:
- `rx.c` accepts management frames with `skb->len >= 24` only
- Malicious AP or in-range attacker can send a 24-byte DEAUTH frame
- **Reachable from wireless attack surface** on every mac80211 station
  interface

**Step 5.5 — Similar patterns**
Record:
- `ieee80211_rx_mgmt_disassoc()` in same file: correct (check then read)
- `ieee80211_rx_mgmt_deauth_ibss()` in `ibss.c`: **same bug** (read
  before check) — not fixed by this commit

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is **Linux 6.18.44**
(`v6.18.44-1-g2736c32da98b9`). Buggy code at:

```5007:5016:net/mac80211/mlme.c
static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data
*sdata,
                                     struct ieee80211_mgmt *mgmt, size_t
len)
{
        struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
        u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);

        lockdep_assert_wiphy(sdata->local->hw.wiphy);

        if (len < 24 + 2)
                return;
```

**Step 6.2 — Backport complications**
Record: Clean apply expected — small, localized hunk; no structural
conflicts observed.

**Step 6.3 — Fix already present?**
Record: **No.** `git log --grep` found no matching commit; fix is not in
this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
Record: `net/mac80211` — **IMPORTANT/CORE** for WiFi; affects all
mac80211 station users.

**Step 7.2 — Activity**
Record: Active subsystem with recent bounds-check and memory-safety
fixes (`bounds-check link_id`, double-free fixes, etc.).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: All systems using mac80211 in station mode (`CONFIG_MAC80211`),
i.e. the vast majority of Linux WiFi clients.

**Step 8.2 — Trigger conditions**
Record: Receiving a DEAUTH management frame with `len == 24` (header
only). Triggerable by malicious/over-the-air sources. Not timing-
dependent.

**Step 8.3 — Failure mode severity**
Record: **Out-of-bounds read** of 2 bytes past frame end — **HIGH**
severity (KASAN-detectable, potential info leak, wireless attack
surface). Unlikely to panic on all builds, but is a real kernel memory-
safety issue.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** HIGH — closes OOB read on common WiFi RX path
- **Risk:** VERY LOW — 4-line reordering, matches existing disassoc
  pattern
- **Ratio:** Strongly favors backport

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real, verifiable OOB read bug
- Reachable from over-the-air WiFi frames (`rx.c` allows 24-byte mgmt
  frames)
- Small, surgical, maintainer-signed fix
- Matches correct pattern already used in `ieee80211_rx_mgmt_disassoc()`
- Bug present in local 6.18.44 tree
- Standalone — no series dependencies

**Evidence AGAINST backport:**
- No syzbot/user crash report (bug may be subtle on non-KASAN builds)
- Does not fix the same bug in `ibss.c` (separate, out-of-scope issue)
- Patch 1/3 (cfg80211) fixes a related but distinct path — not required
  for this fix

**Unresolved questions:**
- No runtime crash report verified
- Lore thread fetch blocked (Anubis); relied on local mbox instead

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — mirrors disassoc; maintainer
   SOB; no code objections in v2
2. Fixes a real bug? **PASS** — OOB read before length check
3. Important issue? **PASS** — memory safety on wireless attack surface
   (HIGH)
4. Small and contained? **PASS** — 6 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — buggy code confirmed present;
   clean apply expected

**Exception category:** N/A (not device ID, quirk, DT, build, or docs)

---

## What Problem This Solves

`ieee80211_rx_mgmt_deauth()` can process deauth frames as short as 24
bytes because mac80211’s RX path only enforces a 24-byte minimum for
management frames. The function reads the 2-byte reason code at offset
24 before checking frame length, causing an out-of-bounds read. A nearby
malicious AP or attacker can trigger this on any Linux WiFi client using
mac80211 station mode.

The fix validates length first (using `offsetofend`), then reads the
reason code — the same pattern already used in
`ieee80211_rx_mgmt_disassoc()` in the same file.

---

## Verification

- [Phase 1] Parsed commit message and tags from user query and local
  mbox
- [Phase 2] Read current `ieee80211_rx_mgmt_deauth()` and
  `ieee80211_rx_mgmt_disassoc()` in `net/mac80211/mlme.c`
- [Phase 2] Confirmed `IEEE80211_DEAUTH_FRAME_LEN` = 24 + 2 in
  `ieee80211_i.h`
- [Phase 3] `git blame -L 5007,5016 net/mac80211/mlme.c`: buggy pattern
  in 6.18 baseline
- [Phase 3] `git log --grep`: no existing fix in tree
- [Phase 4] Read local mbox v2 series; patch 3/3 matches analyzed commit
- [Phase 4] `b4 dig`: no match (commit not in tree); lore URL blocked by
  bot protection
- [Phase 5] Traced call chain: `iface.c` →
  `ieee80211_sta_rx_queued_mgmt()` → `ieee80211_rx_mgmt_deauth()`
- [Phase 5] Read `rx.c:3422`: mgmt frames only require `len >= 24`
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] Confirmed buggy code present; fix not applied
- [Phase 8] Verified failure mode: OOB read at offset 24 when `len ==
  24`
- [UNVERIFIED] Whether non-KASAN builds can be exploited beyond info
  leak

**YES**

 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5c855c95858e1..90d4027aca5ad 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5008,13 +5008,15 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt, size_t len)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
-	u16 reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason_code;
 
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
-	if (len < 24 + 2)
+	if (len < offsetofend(struct ieee80211_mgmt, u.deauth.reason_code))
 		return;
 
+	reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	if (!ether_addr_equal(mgmt->bssid, mgmt->sa)) {
 		ieee80211_tdls_handle_disconnect(sdata, mgmt->sa, reason_code);
 		return;
-- 
2.53.0

