Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE94C451993;
	Mon, 31 Aug 2026 13:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183268; cv=none; b=BToxb6JP7Zw8eErbPStv4e3eg+TVRxsypkc8Qt0n1uLIVXFaeIMMsWb0dlQyc4HqmZ6ITMdZI9l8St+iDWYLxQTlMP43pf+rmheX8yHJNR+nu/gqkKhZz69J7LsL0lo4oii3lnasSFL6/5eegBOnUNrUTEhh3jtsBkbMkibEPxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183268; c=relaxed/simple;
	bh=eLMW5j9aTyTLvuG8WbgxYZYTT1zIbuYiFepTJTS6kRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Al3KybtS54WpuTd+604wDHaYuIt5/8Y5ib+6Sb8EbMqRKOQ3tiBxhgEYIcG0L01qx6RyJLxkwNgO/9Lz86eZ8Vtfok82DizuWXEvC7WG2YWdUHVaMDLNvBoZd5CYbNQyoE7i9xN2YYzMQ+BU9NOsr7S17rsc3E8vry7X6+ZgG9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MNcXpSF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MNcXpSF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6C71F00A3E;
	Mon, 31 Aug 2026 13:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183266;
	bh=9nU3oMm0/Xv6zfIW5k50D8aQh35DFY+8M3UlM8WJHGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNcXpSF3nzD6PlOsq7iSOlEJd2KKkglkGA5UoZzag1gn+PBqA7Qzx+3/m20OffJJA
	 OuSDAwHUWGT9zGcFf3DBH/Cv7wPjdWGtGM17/V8Q7PEn7bsnFKSW697K0qngUfNraf
	 4GvFPgo+NA4s1BIzyfPrwFVAl7IBZNbkJhGPCZlDtkxum2AUNBgcXcOPr0jmcovIwB
	 ygsVKURb4gYFiLU7Kb2060l6FZXbxvX/eZjkL2e3f1jpzruK32nuwOtAyLiKv2mZ79
	 EATYQP0xt9wMVLVTGz5BRBSWKXivohs05poK3nEWWfcjfKy6nHybI2dQRMCAXnRDel
	 AU/YqUXpZTTBw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: nl80211: Increase ie_len size to prevent truncated IEs in new peer notifications
Date: Mon, 31 Aug 2026 09:21:13 -0400
Message-ID: <20260831133314.4125787-45-sashal@kernel.org>
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

From: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>

[ Upstream commit dfb67ae569bf0726187725b1ef8d89377778861e ]

Currently, ie_len in cfg80211_notify_new_peer_candidate is defined as
1-byte field, capping the maximum IE list size at 255 bytes. When a
large beacon is received, the IE list is truncated, passing incomplete
data to wpa_supplicant. This causes supplicant to fail parsing the IEs.

Increasing the size of ie_len to allow the full length of the IE list to
be forwarded properly.

Signed-off-by: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>
Link: https://patch.msgid.link/20260605054307.427874-1-thiyagarajan@aerlync.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1: Subject line**
- Record: `[wifi: nl80211]` `[Increase]` — widen `ie_len` in new mesh
  peer candidate notifications to stop IE truncation.

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Thiyagarajan Pandiyan <thiyagarajan@aerlync.com>`
    (author)
  - `Link: https://patch.msgid.link/20260605054307.427874-1-
    thiyagarajan@aerlync.com`
  - `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (wireless
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
    stable@vger.kernel.org`

**Step 1.3: Body analysis**
- Record:
  - **Bug:** `ie_len` in `cfg80211_notify_new_peer_candidate()` is a
    1-byte field, capping IE list size at 255 bytes.
  - **Symptom:** Large beacon IE lists are truncated; incomplete data
    reaches wpa_supplicant, which fails IE parsing.
  - **Root cause:** Type too narrow for actual IE length.
  - **Fix:** Change `ie_len` from `u8` to `size_t`.

**Step 1.4: Hidden bug fix?**
- Record: No — this is an explicit correctness fix, not disguised
  cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1: Inventory**
- Record:
  - `include/net/cfg80211.h`: prototype `u8 ie_len` → `size_t ie_len`
    (+0/-0, type change)
  - `net/wireless/nl80211.c`: implementation signature same change
  - Functions: `cfg80211_notify_new_peer_candidate()`
  - Scope: single-function, 2-file surgical type fix

**Step 2.2: Code flow**
- Record:
  - **Before:** `ie_len` is `u8`; values >255 truncate/wrap when passed
    from `size_t` callers; `nla_put()` and `nlmsg_new(100 + ie_len)` use
    the truncated length.
  - **After:** Full `size_t` length preserved; complete IE blob
    forwarded to userspace.
  - **Path:** Mesh beacon/probe RX → `mesh_sta_info_alloc()` →
    `cfg80211_notify_new_peer_candidate()` → nl80211 multicast to
    userspace.

**Step 2.3: Bug mechanism**
- Record:
  - **Category:** Type/size mismatch (logic/correctness).
  - **Mechanism:** Caller passes `elems->total_len` (`size_t`); callee
    takes `u8`. For `total_len > 255`, C converts with modulo-256:
    - `256` → `0` (no IEs sent)
    - `300` → `44` (wrong partial IE)
    - `511` → `255` (max representable, still truncated if real length
      is larger)

**Step 2.4: Fix quality**
- Record:
  - Obviously correct; matches other cfg80211 APIs
    (`cfg80211_disconnected()` uses `size_t ie_len`).
  - Minimal, no unrelated changes.
  - Low regression risk; only widens a parameter type on an
    internal/exported helper.

---

## Phase 3: Git History Investigation

**Step 3.1: Blame**
- Record:
  - `u8 ie_len` since `c93b5e717ec47` (2011, Javier Cardona) — original
    mesh peer candidate notification.
  - `sig_dbm` added in `ecbc12ad6b6826` (2018, Bob Copeland); `u8
    ie_len` unchanged.
  - Bug present since 2011 in this tree.

**Step 3.2: Fixes: tag**
- Record: N/A — no `Fixes:` tag.

**Step 3.3: Related file history**
- Record:
  - `11197d006bcfa` (2016): suppress `NEW_PEER_CANDIDATE` when peer has
    no room — related mesh behavior, not this bug.
  - Recent wireless work (MBSSID/RNR validation) shows larger IE
    handling is active in this tree.
  - Standalone fix; not part of a series.

**Step 3.4: Author**
- Record: Thiyagarajan Pandiyan is not a frequent wireless contributor
  in this tree. Johannes Berg (maintainer) committed with his SOB.

**Step 3.5: Dependencies**
- Record: No prerequisites. Self-contained type change. Fix commit not
  yet in this tree (`git log --grep` found nothing).

---

## Phase 4: Mailing List and External Research

**Step 4.1–4.5**
- Record:
  - `b4 dig -c <commit>`: N/A — commit not in local tree.
  - Lore/patch.msgid.link: blocked by bot protection; could not read
    thread.
  - **UNVERIFIED:** Reviewer stable nominations, NAKs, or test reports
    from the mailing list.

---

## Phase 5: Code Semantic Analysis

**Step 5.1: Key functions**
- Record: `cfg80211_notify_new_peer_candidate()`, caller
  `mesh_sta_info_alloc()`.

**Step 5.2: Callers**
- Record:
  - In-tree caller: `mesh_sta_info_alloc()` in
    `net/mac80211/mesh_plink.c` (line 565), called from line 601 on
    beacon/probe RX.
  - Triggered when `user_mpm` or `IEEE80211_MESH_SEC_AUTHED` is set.

**Step 5.3: Callees**
- Record: `nlmsg_new()`, `nla_put()` for `NL80211_ATTR_IE`,
  `genlmsg_multicast_netns()` to `NL80211_MCGRP_MLME`.

**Step 5.4: Reachability**
- Record:
  - Reachable on mesh RX of beacons/probe responses.
  - Userspace (wpa_supplicant/hostapd with userspace MPM) receives
    `NL80211_CMD_NEW_PEER_CANDIDATE`.
  - Not a direct syscall path, but triggered by normal wireless RX in
    mesh configs.

**Step 5.5: Similar patterns**
- Record: Other cfg80211 APIs use `size_t ie_len` (e.g.
  `cfg80211_disconnected()` at line 8788). This function is
  inconsistent.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1: Buggy code present?**
- Record:
  - Tree: **Linux 6.18.44** (`git describe HEAD` → `v6.18.44`).
  - Buggy `u8 ie_len` confirmed at `include/net/cfg80211.h:8145` and
    `net/wireless/nl80211.c:19990`.
  - Caller passes `elems->total_len` (`size_t`, `ieee80211_i.h:1763`).

**Step 6.2: Backport complications**
- Record: Clean apply expected — two signature lines only. No
  conflicting recent changes to this function.

**Step 6.3: Related fixes already present?**
- Record: No equivalent fix in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1: Subsystem**
- Record: `net/wireless` (cfg80211/nl80211) + `net/mac80211` mesh.
  Criticality: **IMPORTANT** (common WiFi stack; mesh is a subset).

**Step 7.2: Activity**
- Record: `net/wireless/` actively maintained; recent MBSSID/RNR IE
  validation work increases relevance of large-IE handling.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1: Who is affected**
- Record: Mesh users with userspace MPM or authenticated mesh
  (`IEEE80211_MESH_SEC_AUTHED`). Config-specific, not universal.

**Step 8.2: Trigger conditions**
- Record:
  - Mesh beacon/probe IE list > 255 bytes.
  - More likely with MBSSID, RNR, EHT/MLO elements.
  - Unprivileged users cannot directly trigger; depends on peer beacon
    content.
  - Not timing-dependent.

**Step 8.3: Failure mode**
- Record:
  - Truncated/wrong IE data to userspace.
  - wpa_supplicant IE parse failure → mesh peer discovery/peering fails.
  - Severity: **MEDIUM** (functional failure, not kernel
    crash/corruption/security).

**Step 8.4: Risk-benefit**
- Record:
  - **Benefit:** Restores correct mesh peer candidate notifications for
    large beacons.
  - **Risk:** Very low — two-line type widening; in-tree caller already
    passes `size_t`.
  - **Ratio:** Good — small fix, real bug, low risk.

---

## Phase 9: Final Synthesis

**Step 9.1: Evidence**

*For:*
- Verified type mismatch: `size_t` caller → `u8` callee.
- Concrete failure: wrong/zero/truncated IE length → userspace parse
  failure.
- Long-standing bug (since 2011).
- Minimal, obviously correct fix aligned with other cfg80211 APIs.
- Maintainer (Johannes Berg) signed off.
- Increasingly relevant as beacon IEs grow.

*Against:*
- Mesh + userspace MPM is a narrower audience.
- Not crash, deadlock, or security.
- Mailing list review details unverified.

**Step 9.2: Stable rules checklist**
1. Obviously correct and tested? **PASS** (code review; no runtime test
   evidence)
2. Fixes a real user-affecting bug? **PASS**
3. Important issue? **PASS** (functional failure of mesh peer discovery;
   medium severity)
4. Small and contained? **PASS**
5. No new features/APIs? **PASS** (type correction only; nl80211
   attribute format unchanged)
6. Can apply to local tree? **PASS**

**Step 9.3: Exception categories**
- Record: None (not device ID, quirk, DT, build, or docs).

**Step 9.4: Decision rationale**

For Linux **6.18.44**, the buggy code is present and the fix is a
minimal type correction with clear user impact: mesh deployments using
userspace peering management receive corrupted peer-candidate IE data
when beacon IEs exceed 255 bytes, breaking wpa_supplicant parsing. The
patch is low risk, maintainer-reviewed, and aligns with established
cfg80211 conventions.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message.
- [Phase 2] Diff analysis: `u8` → `size_t` in prototype and
  implementation.
- [Phase 3] `git describe HEAD`: v6.18.44 / 6.18.44.
- [Phase 3] `git blame`: `u8 ie_len` from `c93b5e717ec47` (2011).
- [Phase 3] `git show c93b5e717ec47`, `ecbc12ad6b6826`: history of
  function.
- [Phase 3] `git log --grep="Increase ie_len"`: no fix in tree yet.
- [Phase 4] WebFetch/curl lore: blocked by bot protection —
  **UNVERIFIED** mailing list discussion.
- [Phase 4] `b4 dig`: commit not in tree — could not dig.
- [Phase 5] `grep cfg80211_notify_new_peer_candidate`: one in-tree
  caller (`mesh_plink.c:565`).
- [Phase 5] Read `mesh_sta_info_alloc()`: passes `elems->total_len`
  (`size_t`).
- [Phase 5] Read `ieee802_11_elems`: `total_len` is `size_t`.
- [Phase 5] Compared with `cfg80211_disconnected()` using `size_t
  ie_len`.
- [Phase 6] Confirmed buggy signatures at `cfg80211.h:8145`,
  `nl80211.c:19990`.
- [Phase 6] Verified truncation semantics for values >255.
- [Phase 7] `git log --oneline -20 -- net/wireless/`: active subsystem.
- [Phase 8] Assessed mesh-only, config-specific impact; medium severity.

**YES**The history search finished. It didn’t find an existing fix for
the `ie_len` truncation issue in this tree.

The only directly related hit was `11197d006bcfa` (“mac80211: Suppress
NEW_PEER_CANDIDATE event if no room”), which only filters peer-candidate
events when a peer can’t accept links — it doesn’t address the
`u8`/`size_t` length mismatch.

That supports the earlier conclusion: the bug is still present in Linux
6.18.44, and this small type fix is worth backporting.

**YES**

 include/net/cfg80211.h | 2 +-
 net/wireless/nl80211.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1509be85139ec..5ec9023e969d4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8142,7 +8142,7 @@ void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid,
  * cfg80211 then sends a notification to userspace.
  */
 void cfg80211_notify_new_peer_candidate(struct net_device *dev,
-		const u8 *macaddr, const u8 *ie, u8 ie_len,
+		const u8 *macaddr, const u8 *ie, size_t ie_len,
 		int sig_dbm, gfp_t gfp);
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 41695fb53ddff..e0b7e7172a596 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19994,7 +19994,7 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 }
 
 void cfg80211_notify_new_peer_candidate(struct net_device *dev, const u8 *addr,
-					const u8 *ie, u8 ie_len,
+					const u8 *ie, size_t ie_len,
 					int sig_dbm, gfp_t gfp)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-- 
2.53.0

