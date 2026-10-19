Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202C2642370;
	Mon, 19 Oct 2026 14:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418788; cv=none; b=cjNdaK4bVExQTV0hTKlGOd32/7fTP9Gh/vGG0HaKgBFwCEpRUdrm9Bq+OKy+5WGa4cLqgYpJ8js+oqlUl3oFSZ3HKJNu40w7xN7lHeEcKKZBHn6AmdJFzMjAumlmexS3RysjWDiLYdrQ4pxzoGMx9RohMcsHostlRjeyn3/aywk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418788; c=relaxed/simple;
	bh=ULzBuNsp5/KA8f2xhXz2slDWPCzWt/1H3q+Yw2VtfRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gD/DYsI8ssxwwpgJ7+9xVepU7u+PuDgCLl4WIw5l+Oln5j98/Jsv6r6m+ZOIRIymep9jbnUrwTyq+lcsZrDG7qHmK9FzKJrJXHunIjWeZ3R3Cc6kGPcsGgSPliA72kt+lwXZOM50IwwRKARSDvM4yHoYy1I46PhBQNpGqqMR6io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n8SbzL3X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n8SbzL3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197801F000C6;
	Mon, 19 Oct 2026 14:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418786;
	bh=y/vPFOG9Gr5B2/yachfszVsHJr0+zaqYK/PdeN07960=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8SbzL3XxBv2TjzBq0hLhXLoXPkpGQUncPcGvJGA8yYkY3n7TmhMrubOhvoqk9a6e
	 NtLOMen2dT49iFtcRNCzIXXbsXtlkwpCLXlOmLuvOiZEyt1AUJebb7CNABI0QoWjTI
	 wYgmvvDaMD5lclDQhHMd5twmZ+CF7A0WIsNarJDXx4JoUfeAjwb0qTEtgyy//8Ands
	 w7vbhnufviQJc0z9xiiRqm1ZAzl1M67M/9LlU5lKtkyqGOSXI0XNuEtDWr90+HVwUd
	 9BRMzZR1LYf+khz6f0VR0TBCdbFmrOT9yUUEK99BhNfc8F1aqHmscbafvtoJtH9TWH
	 YNHw1MhZS4U0g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shahar Tzarfati <shahar.tzarfati@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: mac80211: ibss: read deauth reason_code after frame length check
Date: Mon, 19 Oct 2026 09:53:06 -0400
Message-ID: <20261019135441.1420968-495-sashal@kernel.org>
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

From: Shahar Tzarfati <shahar.tzarfati@intel.com>

[ Upstream commit aa4c0a649903567762edf2bbc7fff608953b3ca4 ]

The function was reading reason_code from the frame before validating
that the frame is at least IEEE80211_DEAUTH_FRAME_LEN bytes long.

Move the reason_code read to after the length check so the field is
guaranteed to be present before it is accessed.

Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260715212706.db26604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[mac80211/ibss] [read / reorder] Move IBSS deauth `reason_code`
access to after the existing frame-length check.`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected)
- `Reported-by:` — none
- `Tested-by:` — none
- `Reviewed-by:` — none on the commit
- `Acked-by:` — none
- `Link:` `https://patch.msgid.link/20260715212706.db26604650bd.I2caa73c
  396b8c9d357224b9334d5df3cafac498e@changeid`
- `Cc: stable@vger.kernel.org` — none (expected)
- `Signed-off-by: Shahar Tzarfati <shahar.tzarfati@intel.com>` (author)
- `Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>`
  (Intel wireless)
- `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (mac80211
  maintainer)

No syzbot, no CVE, no multi-user reports. Maintainer SOB is the main
trust signal.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `ieee80211_rx_mgmt_deauth_ibss()` read
  `mgmt->u.deauth.reason_code` before checking `len >=
  IEEE80211_DEAUTH_FRAME_LEN`.
- **Symptom/failure mode:** 2-byte read past the validated frame on a
  truncated deauth. Value is then discarded if the length check fails.
- **Version info:** none in the message.
- **Root cause (author):** field access before the length check; move
  the read after the check.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit bounds-check-before-
access fix. The length check already existed; only the premature read
was wrong.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `net/mac80211/ibss.c` (+3 / −1)
- Function: `ieee80211_rx_mgmt_deauth_ibss()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: initialize `reason` from `mgmt->u.deauth.reason_code`,
then return if `len < 26`. After: declare `reason`, length-check first,
then read the field. `ibss_dbg()` and `sta_info_destroy_addr()` are
unchanged and remain after the check.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / out-of-bounds read.**
`IEEE80211_DEAUTH_FRAME_LEN` is `(24 /* hdr */ + 2 /* reason */)`.
`reason_code` sits at offset 24 in `struct ieee80211_mgmt`. RX already
drops mgmt frames shorter than the 802.11 header (`skb->len <
ieee80211_hdrlen(fc)` in `ieee80211_rx()`), so 24- and 25-byte deauths
can still reach this handler. Those frames do not contain the reason
field; the old code always read it anyway. On the short-frame path the
value is unused (immediate `return`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct: same pattern as
`ieee80211_rx_mgmt_auth_ibss()` in the same file and as
`ieee80211_rx_mgmt_deauth()` in `mlme.c` (`4a360c6e18dfa`). Minimal, no
API/locking/structure changes. Regression risk is negligible (debug
print still sees a valid reason on well-formed frames).

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: Function introduced in `2cc59e784b54` (Antonio Quartulli,
2012-09-07, “mac80211: reply to AUTH with DEAUTH if sta allocation fails
in IBSS”). The premature `reason_code` read was in the original
function. Present for ~14 years, including this 7.3 tree’s lineage.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Buggy commit is `2cc59e784b54`, which `git
merge-base --is-ancestor` confirms is in this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent `ibss.c` work is unrelated (TX-on-disconnect, rx_nss).
Same-day series patch 2/2 was mlme deauth length checking; that path was
already fixed by `4a360c6e18dfa` (“wifi: mac80211: validate deauth frame
length before reason access”, Zhao Li, 2026-06-13). This IBSS patch is
standalone.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Shahar Tzarfati is an Intel wireless contributor (iwlwifi
bounds-check fixes plus this IBSS change). Not the mac80211 maintainer;
Johannes Berg applied it.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `IEEE80211_DEAUTH_FRAME_LEN` (defined 2012
in `net/mac80211/ieee80211_i.h`). Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c aa4c0a649903`: https://patch.msgid.link/20260715212706.db26
  604650bd.I2caa73c396b8c9d357224b9334d5df3cafac498e@changeid
- `b4 dig -a`: single revision, `[PATCH wireless-next 1/2]`
- Thread (mbox): no replies, no NAK, no `Cc: stable` request. Johannes
  applied v1.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Johannes Berg; Cc `linux-wireless@`, Shahar
Tzarfati, sent by Miri Korenblit. No extra reviewer tags; maintainer
merge is the review signal.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, syzbot, or bugzilla. Sibling `4a360c6e18dfa` on
the STA deauth path is the same class of bug (LLM-assisted). No user
crash report found.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 2/2 was `wifi: mac80211: mlme: read deauth reason_code after
frame length check`. It was not committed (mlme already had
`4a360c6e18dfa`). 1/2 does not depend on 2/2.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org search was blocked (Anubis 403). UNVERIFIED
whether linux-stable discussed this. No local `ibss.c` history indicates
a prior stable rejection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `ieee80211_rx_mgmt_deauth_ibss()`

**Step 5.2: TRACE CALLERS**
Record:
- `ieee80211_ibss_rx_queued_mgmt()` → `IEEE80211_STYPE_DEAUTH` case,
  `mgmt = skb->data`, `len = skb->len`
- `ieee80211_iface_work()` in `iface.c` for `NL80211_IFTYPE_ADHOC`
- Frames queued from `ieee80211_rx_h_mgmt()` in `rx.c` (IBSS deauth
  allowed)

Workqueue / wiphy context, not hardirq. Reachable from over-the-air RX.

**Step 5.3: TRACE CALLEES**
Record: `le16_to_cpu()`, `ibss_dbg()` (`MAC80211_IBSS_DEBUG` only),
`sta_info_destroy_addr()`. Functional work was already after the length
check.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Wireless NIC RX → `ieee80211_rx()` (drops `skb->len < hdrlen`) →
`ieee80211_rx_h_mgmt()` → iface work → `ieee80211_ibss_rx_queued_mgmt()`
→ deauth handler. A peer on the IBSS can send a 24-byte deauth.
Unprivileged local userspace cannot inject this without packet
injection; a radio neighbor can. `ibss_dbg` does not gate the old read:
`reason` was initialized before the debug macro.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same bug on STA deauth (`mlme.c`, fixed in `4a360c6e18dfa`).
IBSS auth already checks `len < 24 + 6` before reading auth fields.
Probe-req path checks `len < 24 + 2`. This was the remaining IBSS deauth
hole.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Local tree is **v7.3-rc4-27-gf0100363d8c37** (`VERSION=7
PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`).
`ieee80211_rx_mgmt_deauth_ibss()` exists in `net/mac80211/ibss.c`. Bug
introduced 2012 (`2cc59e784b54`), long before this branch. Current file
already has the fixed order (commit is an ancestor of HEAD). Evaluation
is of the pre-fix bug in this lineage, not “already selected.”

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding function matches the pre-image; no
conflicting refactor of this handler.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier IBSS-specific version of this fix. `4a360c6e18dfa`
only covers `mlme.c`. No duplicate IBSS patch.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `net/mac80211` IBSS/ad-hoc RX. **IMPORTANT** for IBSS users,
**PERIPHERAL** vs core mm/VFS. IBSS is built with mac80211 (only
`MAC80211_IBSS_DEBUG` is extra). Less common than infrastructure STA,
but real (ad-hoc, some embedded/industrial).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: mac80211 is actively developed; this IBSS handler has been
stable since 2012. Long-lived bug, not churn from new code.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific: mac80211 IBSS
(`NL80211_IFTYPE_ADHOC`). Not all wifi users; IBSS is a minority of
deployments.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Truncated deauth (len 24 or 25) on an IBSS interface. Not every
boot; needs IBSS up plus a short frame (malformed or hostile). Remote
on-air trigger. Local unprivileged trigger only with injection.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: 2-byte read past `skb->len` into a local that is discarded on
the short-frame path. No leak through `ibss_dbg` (return happens first).
Crash only if the skb has no tailroom past 24 bytes (often it does).
KASAN may or may not fire depending on allocator vs `skb->len`.
Severity: **MEDIUM** (CWE-125 / packet-parser OOB), not a demonstrated
oops or UAF.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Closes a real, remotely reachable OOB in frame parsing.
  Modest user-visible impact (IBSS, discarded 2 bytes).
- **Risk:** Very low (3 lines, no locking/API, same pattern as mlme).
- **Ratio:** Favorable. Cheap to take; cost of skipping is leaving a
  parser OOB in long-lived code.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB: `reason_code` at offset 24 read when `len` can be 24–25
- Read is not debug-gated; it always ran
- Over-the-air reachable on IBSS
- 4-line, obviously correct, tested by landing in wireless-next via
  Johannes Berg
- Same class already fixed in STA mlme (`4a360c6e18dfa`)
- No new features/APIs; no prerequisites
- Applies cleanly; bug present since 2012 in this tree’s code
- Buffer OOB is a documented stable category

AGAINST:
- No crash/syzbot/CVE/user report
- `reason` unused on the short path; `sta_info_destroy_addr()` was
  already guarded
- IBSS is uncommon vs infrastructure
- Practical crash likely rare (skb tailroom)
- No explicit stable nomination

UNRESOLVED:
- lore.kernel.org HTML search blocked; no independent stable-list
  confirmation
- Exact KASAN behavior on `skb->len` vs kmalloc size not demonstrated

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reorder after an existing
   check; maintainer merged v1
2. Fixes a real bug that affects users? **PASS** — OOB on truncated IBSS
   deauth
3. Important issue (crash, security, corruption, deadlock)? **PASS**
   (low–medium) — remote 2-byte overread in a parser; not a known oops,
   but memory-safety
4. Small and contained? **PASS** — +3/−1, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — matching pre-image in
   `ibss.c`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or docs patch).
Qualifies as a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This is a surgical bounds-check fix for a long-standing, remotely
reachable out-of-bounds read in mac80211 IBSS deauth parsing. The
functional destroy path was already safe; the bug is the unconditional
2-byte overread. That is still a real memory-safety defect, the same one
already corrected on the STA deauth path. Risk of the change is
essentially zero. For this 7.3 tree, the code exists and the patch
applies cleanly, so it should be taken.

**What it solves for stable users:** A truncated IBSS deauth no longer
reads past the frame before the length check. That avoids undefined/OOB
behavior on a path a radio neighbor can hit.

**Risk vs benefit:** Benefit is modest but real; risk is negligible.
Take it.

---

### Verification
- [Phase 1] Parsed commit `aa4c0a649903`; tags: Link + three SOBs
  (Tzarfati, Korenblit, Berg); no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: `ieee80211_rx_mgmt_deauth_ibss()` +3/−1; read moved
  after `IEEE80211_DEAUTH_FRAME_LEN` (26 = 24+2)
- [Phase 2] Confirmed `reason` only used in `ibss_dbg`;
  `sta_info_destroy_addr()` already after the check
- [Phase 3] `git blame`: function from `2cc59e784b54` (2012); `git
  merge-base --is-ancestor 2cc59e784b54 HEAD` succeeded
- [Phase 3] Pre-image shown via `git show
  aa4c0a649903^:net/mac80211/ibss.c`
- [Phase 3] Author log: Intel wifi bounds-check work; series 2/2 did not
  land
- [Phase 4] `b4 dig -c/-a/-w/-m`: wireless-next 1/2, v1 only, no review
  replies; 2/2 was mlme duplicate of `4a360c6e18dfa`
- [Phase 4] `git show 4a360c6e18dfa`: same bug on STA deauth, already in
  this tree
- [Phase 4] lore HTML/WebFetch: 403/Anubis — UNVERIFIED for linux-stable
  archive
- [Phase 5] Callers: `ieee80211_ibss_rx_queued_mgmt` ← `iface.c` ADHOC ←
  `ieee80211_rx_h_mgmt`
- [Phase 5] `ieee80211_rx()` drops mgmt if `skb->len <
  ieee80211_hdrlen(fc)` (~24), so 24–25 byte frames still reach the
  handler
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4; buggy function present; apply would be
  clean
- [Phase 8] Failure mode: discarded 2-byte overread; severity MEDIUM;
  IBSS-specific
- UNVERIFIED: whether KASAN fires on this skb overread; whether linux-
  stable already discussed it

The patch is small, correct, and fixes a real parser OOB in code this
tree has had since 2012.

**YES**

 net/mac80211/ibss.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 6ca2ff354e768..4dc748a667a72 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -910,11 +910,13 @@ static void ieee80211_rx_mgmt_deauth_ibss(struct ieee80211_sub_if_data *sdata,
 					  struct ieee80211_mgmt *mgmt,
 					  size_t len)
 {
-	u16 reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+	u16 reason;
 
 	if (len < IEEE80211_DEAUTH_FRAME_LEN)
 		return;
 
+	reason = le16_to_cpu(mgmt->u.deauth.reason_code);
+
 	ibss_dbg(sdata, "RX DeAuth SA=%pM DA=%pM\n", mgmt->sa, mgmt->da);
 	ibss_dbg(sdata, "\tBSSID=%pM (reason: %d)\n", mgmt->bssid, reason);
 	sta_info_destroy_addr(sdata, mgmt->sa);
-- 
2.53.0

