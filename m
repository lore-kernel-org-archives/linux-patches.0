Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CAE495524;
	Mon, 31 Aug 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183526; cv=none; b=sKtB5U+Hlj55c9YKE5+HS2vfVOFSoQ0iCjBSX1bqJk2yJKNql33P2dLY8rk5BpJ0WOfR6zgRBhXHGU7ANF2pcVO4f0FwaLGOzIYqWI4rR2BIYhXc1tWn1A79ef4bSkyLUQXl9nOUgeu57TIneDIFL93jBt7/s03JfBPuwJSdc/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183526; c=relaxed/simple;
	bh=dBXs6w7hGyZEqttw4sEHkeLV1QYUCGiepMwOSDmWVo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dIpGhIBlT5E2puEfvA/ElgPTkT0Ok7JCbdXMrF7UULW07xQAHQgYlhcPJT0unp96web1G7mAwuVzcEMMbGc3zk2yVlX/qElHE4fgQbUr7Qw7gdRmFb4xbgbxzgn+pd9C6ooYV7m65p6euRc2nHcqYEwm2nkXBYi8gDlXKOZHC10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzbxnH3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzbxnH3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D8391F00ADB;
	Mon, 31 Aug 2026 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183523;
	bh=O89F2h78o6S2k7xVQN65UrJ0QrNQ1cM4J6SForwVlKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EzbxnH3wlq3Bp9+CBdkOr704DK/H2ZTst8VcU4C/xV5gswvNToiwzeI1rjDzc7S+A
	 b3O3HgqjF5XIRbNVeDWa+8W1tFOUFX+ibCQsPh6x+9auL9GWKJYx2SRNEWOB7MSAnf
	 KbOwO5alVQTHUhSv8dMD2M7PXVHM+6Vr2cNRyvhy4IEeT1mh84d5QY03fdK7Bok3Z3
	 DoDgzmJnQ+669i8wgiY2AYerSle6b2SlnpW4vQ0gJBlWGbf9SXZzSnrQ3q/RvoSmme
	 mNeSybl3WZBnpu0LAagUX9aHwI3ySdT9JS3JPweIWLs85keASUzEgEDROihkgvkCBa
	 p92/NDpLg64zw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] wifi: nl80211: reject beacons with bad HE operation
Date: Mon, 31 Aug 2026 09:22:55 -0400
Message-ID: <20260831133314.4125787-147-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8b9a100e1a76c52988b31099b349fd95a58c8768 ]

The HE operation element not only needs to be longer than
the fixed part, but also have an appropriate size for the
variable part inside of it. Check this.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415144514.6217f5974fb5.Iff7ff6bcb159584e756d0f825c65860cdd53c6ea@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: nl80211: reject beacons with bad HE
operation`

**Local tree:** `v6.18.43` (Linux 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: nl80211]` `[reject]` — Reject AP beacon templates
whose HE Operation IE has an invalid variable-length portion.

### Step 1.2: Tags
**Record:**
- **Reviewed-by:** Miriam Rachel Korenblit
  \<miriam.rachel.korenblit@intel.com\> — subsystem reviewer
- **Link:** https://patch.msgid.link/20260415144514.6217f5974fb5.Iff7ff6
  bcb159584e756d0f825c65860cdd53c6ea@changeid
- **Signed-off-by:** Johannes Berg \<johannes.berg@intel.com\> —
  wireless maintainer
- No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags

### Step 1.3: Body analysis
**Record:**
- **Bug:** HE Operation element validation only checked the fixed header
  size, not the variable optional fields (VHT Operation Info, Co-Hosted
  BSS indicator, 6 GHz Operation Info) indicated by `he_oper_params`
  flags.
- **Symptom:** Malformed beacon accepted; downstream code may read past
  the IE boundary.
- **Root cause:** `nl80211_calculate_ap_params()` lacked the
  `ieee80211_he_oper_size()` check already used in scan/mac80211 paths
  and mirrored for EHT in the same function.

### Step 1.4: Hidden bug fix?
**Record:** Yes — explicit input-validation bug fix, not cleanup. Fills
a bounds-check gap on a userspace-supplied netlink beacon path.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `net/wireless/nl80211.c` (+4 lines net)
- **Function:** `nl80211_calculate_ap_params()`
- **Scope:** Single-file, surgical validation fix

### Step 2.2: Code flow change
**Record:**
- **Before:** If HE Operation IE `datalen >= sizeof(fixed part) + 1`,
  set `params->he_oper` and continue.
- **After:** Same minimum check, then reject if `cap->datalen <
  ieee80211_he_oper_size(params->he_oper)`.
- **Path:** `NL80211_CMD_START_AP` → `nl80211_start_ap()` →
  `nl80211_calculate_ap_params()` error path.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Buffer / out-of-bounds read (missing bounds validation
  on variable-length IE)
- **Mechanism:** `he_oper_params` flags can require up to 9 additional
  bytes beyond the 6-byte fixed header. Without size validation,
  `params->he_oper` may point at an IE that claims optional fields that
  are not present. Helpers like `ieee80211_he_6ghz_oper()` index into
  `he_oper->optional[]` based on those flags and can read past the IE
  into adjacent memory.

### Step 2.4: Fix quality
**Record:**
- Uses existing `ieee80211_he_oper_size()` inline helper (same pattern
  as `scan.c`, `mac80211/rx.c`, `mac80211/parse.c`).
- Matches EHT validation already in the same function
  (`ieee80211_eht_oper_size_ok()`).
- Minimal risk; only rejects previously accepted malformed input.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** HE Operation parsing at `nl80211.c:6419-6421` is present in
this tree without the size check. History is squashed (blame points to
bulk import `19eef1d98eeda` / `ac3fd01e4c1ef Linux 6.18-rc7`); exact
introduction commit not recoverable from this checkout.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related file history
**Record:** Recent nl80211 validation fixes already in this 6.18.y tree:
- `f8c547e543e12` — validate nested MBSSID IE blobs
- `265c07c09c837` — reject oversized EMA RNR lists
Same subsystem pattern of hardening nl80211 IE parsing.

### Step 3.4: Author context
**Record:** Johannes Berg is the wireless/cfg80211 maintainer. No other
commits from this author found in truncated `nl80211.c` history of this
checkout.

### Step 3.5: Dependencies
**Record:** Standalone. Requires only `ieee80211_he_oper_size()` from
`include/linux/ieee80211-he.h`, which exists in this tree. No series
dependency.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Commit not in local tree; `b4 dig -c <hash>` unavailable.
Link: tag points to patch.msgid.link but fetch blocked (Anubis bot
protection). Lore.kernel.org also returned 403. **UNVERIFIED:** full
thread content and any stable nomination in review.

### Step 4.2: Reviewers
**Record:** Reviewed-by from Intel wireless developer; Signed-off-by
from subsystem maintainer Johannes Berg.

### Step 4.3: Bug report
**Record:** No Reported-by or syzbot link. Bug identified by code
inspection / consistency with EHT validation.

### Step 4.4: Series context
**Record:** Standalone one-commit fix; not part of a multi-patch series.

### Step 4.5: Stable list history
**Record:** **UNVERIFIED** — could not search lore stable list (403).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nl80211_calculate_ap_params()`, `ieee80211_he_oper_size()`,
`ieee80211_he_6ghz_oper()`

### Step 5.2: Callers
**Record:** `nl80211_calculate_ap_params()` called only from
`nl80211_start_ap()` (line 6858). `nl80211_start_ap()` is the
`NL80211_CMD_START_AP` genl handler (requires `CAP_NET_ADMIN`).

### Step 5.3: Callees
**Record:** `cfg80211_find_ext_elem()`, `ieee80211_he_oper_size()` —
reads `he_oper_params` from fixed header, computes total required IE
data length including optional fields.

### Step 5.4: Reachability
**Record:** Triggered when a privileged userspace process (hostapd,
wpa_supplicant, etc.) starts an AP with a beacon containing a malformed
HE Operation IE. Not reachable from unprivileged userspace directly, but
is a kernel input-validation defect on a netlink path.

### Step 5.5: Similar patterns
**Record:** Correct validation already present elsewhere:

```2231:2234:net/wireless/scan.c
        tmp = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION,
                                     elems, elems_len);
        if (!tmp || tmp->datalen < sizeof(*he_oper) + 1 ||
            tmp->datalen < ieee80211_he_oper_size(tmp->data + 1))
```

```3389:3390:net/mac80211/rx.c
        if (ie && ie->datalen >= sizeof(struct ieee80211_he_operation)
&&
            ie->datalen >= ieee80211_he_oper_size(ie->data + 1)) {
```

EHT Operation in the same function already uses
`ieee80211_eht_oper_size_ok()`. HE Operation was the inconsistent
outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **Yes.** Current code at `nl80211.c:6419-6421`:

```6419:6421:net/wireless/nl80211.c
        cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ies,
ies_len);
        if (cap && cap->datalen >= sizeof(*params->he_oper) + 1)
                params->he_oper = (void *)(cap->data + 1);
```

No variable-length validation. `ieee80211_he_oper_size()` exists in
`include/linux/ieee80211-he.h:712-734`.

### Step 6.2: Backport complications
**Record:** Clean apply expected — 4-line hunk in one function, no
structural conflicts observed.

### Step 6.3: Related fixes already present?
**Record:** No equivalent HE Operation size validation in
`nl80211_calculate_ap_params()`. EHT validation in same function
confirms the intended pattern.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `net/wireless` (cfg80211/nl80211) — **IMPORTANT** subsystem;
widely used by all WiFi drivers.

### Step 7.2: Activity
**Record:** Active — recent validation hardening commits in this 6.18.y
tree (`f8c547e543e12`, `265c07c09c837`, etc.).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Systems using HE (802.11ax) AP mode via nl80211 — hostapd,
wpa_supplicant, NetworkManager on WiFi AP/GO interfaces. Config-specific
(HE AP), not universal.

### Step 8.2: Trigger conditions
**Record:** `NL80211_CMD_START_AP` with beacon tail containing HE
Operation IE where `he_oper_params` flags claim optional fields but
`datalen` is too short. Requires `CAP_NET_ADMIN`. Not a
remote/unauthenticated attack vector, but a local privileged input that
can reach driver code with an under-validated pointer.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read when optional fields are accessed (e.g.,
via `ieee80211_he_6ghz_oper()`). Severity: **MEDIUM-HIGH** for memory
safety; **MEDIUM** for exploitability (privilege required, no
demonstrated crash in commit message). Could cause info leak or driver
misbehavior if firmware rebuilds IEs from the bad pointer.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Closes a real validation gap; aligns nl80211 with rest of
  wireless stack; prevents passing malformed IE pointers to drivers.
- **Risk:** Very low — only rejects invalid input that should never have
  been accepted.
- **Ratio:** Favorable for backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real missing bounds check on variable-length HE Operation IE
- Buggy code confirmed present in v6.18.43
- Helper function and precedent validation exist in this tree
- EHT Operation already validated in same function — clear oversight
- Small (4 lines), maintainer-authored and reviewed
- Same class of fix as other nl80211 validation commits already in
  6.18.y
- Prevents OOB reads in kernel when optional HE fields are accessed

**AGAINST backport:**
- No crash report, syzbot, or CVE cited
- Trigger requires `CAP_NET_ADMIN` (reduced security urgency)
- mac80211 `start_ap` path reads only fixed `he_oper_params` fields at
  cfg.c:1524-1531 (immediate mac80211 impact limited)

**UNRESOLVED:**
- Full mailing list discussion (lore/patch.msgid.link inaccessible)
- Exact upstream commit hash and introduction date of buggy code

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — uses established helper;
   reviewed by maintainer (no Tested-by)
2. Fixes a real bug? **PASS** — missing IE size validation
3. Important issue? **PASS** — memory safety / OOB read prevention
   (MEDIUM-HIGH severity, MEDIUM exploitability)
4. Small and contained? **PASS** — 4 lines, one function
5. No new features or APIs? **PASS** — validation only
6. Can apply to local tree? **PASS** — all prerequisites present in
   v6.18.43

### Step 9.3: Exception categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Standard input-validation bug fix.

### Step 9.4: Decision rationale

This commit closes a genuine validation hole in
`nl80211_calculate_ap_params()` where HE Operation IEs are accepted
based only on fixed-header size. The rest of the wireless stack
(`scan.c`, `mac80211/rx.c`, `mac80211/parse.c`) and EHT handling in the
same function already perform full size validation. The fix is minimal,
obviously correct, low-risk, and consistent with other nl80211 hardening
already backported to this 6.18.y tree. While exploitation requires
privileged access and no crash was reported, preventing kernel OOB reads
from netlink-supplied data meets stable criteria for important bug
fixes.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Reviewed-by, Link, Signed-off-by);
  no Fixes/Reported-by/syzbot
- **[Phase 2]** Diff: +4 lines in `nl80211_calculate_ap_params()`, adds
  `ieee80211_he_oper_size()` check
- **[Phase 3]** `git describe HEAD`: v6.18.43
- **[Phase 3]** `git blame -L 6419,6421 net/wireless/nl80211.c`: buggy
  lines present, no size check
- **[Phase 3]** `git log --oneline -10 --grep=validate --
  net/wireless/nl80211.c`: related validation commits in tree
- **[Phase 3]** `git log -S ieee80211_he_oper_size --
  net/wireless/nl80211.c`: no prior use in nl80211.c
- **[Phase 4]** `b4 dig -c`: N/A — commit hash not in tree
- **[Phase 4]** WebFetch patch.msgid.link: blocked (Anubis)
- **[Phase 4]** curl lore.kernel.org: 403 Forbidden — **UNVERIFIED**
  mailing list discussion
- **[Phase 5]** `grep nl80211_calculate_ap_params`: single caller at
  line 6858 (`nl80211_start_ap`)
- **[Phase 5]** `grep ieee80211_he_oper_size`: used in scan.c, rx.c,
  parse.c, mesh.c — not nl80211.c
- **[Phase 5]** Read `ieee80211_he_6ghz_oper()` at
  ieee80211-he.h:744-764: indexes into optional fields based on flags
- **[Phase 5]** Read `nl80211.c:6422-6439`: EHT oper uses
  `ieee80211_eht_oper_size_ok()` — precedent confirmed
- **[Phase 6]** Read `nl80211.c:6419-6421`: buggy code confirmed in
  v6.18.43
- **[Phase 6]** Read `include/linux/ieee80211-he.h:712-734`:
  `ieee80211_he_oper_size()` present
- **[Phase 8]** Read `nl80211_start_ap()` at 6602+: requires beacon
  attrs, calls `nl80211_calculate_ap_params` before `rdev_start_ap`
- **[Phase 8]** Read `mac80211/cfg.c:1524-1531`: start_ap reads only
  fixed HE oper fields — limits immediate mac80211 impact

**YES**The background history searches finished successfully and matched
what the earlier analysis already used.

The EHT validation search (`git log -S "ieee80211_eht_oper_size_ok"`)
found that helper introduced with the EHT definitions split
(`dd827cff429d5`), with `ieee80211_eht_oper_size_ok()` already used for
EHT Operation validation in the same `nl80211_calculate_ap_params()`
function — while HE Operation still lacked the parallel
`ieee80211_he_oper_size()` check.

The broader HE oper history search confirmed `params->he_oper` parsing
is present in this v6.18.43 tree, but git history here is heavily
squashed (most changes trace to the 6.18-rc7 bulk import), so the exact
commit that introduced the buggy nl80211 path couldn’t be isolated
further.

That supports the **YES** verdict: this is a small, obvious validation
gap in a tree that already has the helper and the EHT precedent.

 net/wireless/nl80211.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 776dcf8835d71..9adf6f948d3dc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6417,8 +6417,12 @@ static int nl80211_calculate_ap_params(struct cfg80211_ap_settings *params)
 	if (cap && cap->datalen >= sizeof(*params->he_cap) + 1)
 		params->he_cap = (void *)(cap->data + 1);
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_HE_OPERATION, ies, ies_len);
-	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1)
+	if (cap && cap->datalen >= sizeof(*params->he_oper) + 1) {
 		params->he_oper = (void *)(cap->data + 1);
+		/* takes extension ID into account */
+		if (cap->datalen < ieee80211_he_oper_size((void *)params->he_oper))
+			return -EINVAL;
+	}
 	cap = cfg80211_find_ext_elem(WLAN_EID_EXT_EHT_CAPABILITY, ies, ies_len);
 	if (cap) {
 		if (!cap->datalen)
-- 
2.53.0

