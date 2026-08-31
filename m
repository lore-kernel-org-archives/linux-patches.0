Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA8D44C508;
	Mon, 31 Aug 2026 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183259; cv=none; b=qhlz5Q61dnhpuw8VviNq6hc+zJcAc+BdCYo0BSTR2rlTfAg1XVvGjfhNQM0/Ks7+qevkFf3P5Y6gHLJgeK5qR9Gd4fUVD94pkM92Q3LXUw4bF+eecsfyXIksHdLVSjsE9l6RYui9m92TIfW1kp6w8YlyCpeTEEOKav4Tu4zcO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183259; c=relaxed/simple;
	bh=flkCPkaR3RUwFV7iED67qPPJ6/uIor7wSBXtKPZRykk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EqUXvbmRtoB0Uz9kU/+jS3F0kp2JRRWzZfPvdWuG9v3khky7aZn6IdhGo5jY41QbnYj5AV06fPX+BrHjwdAV4iIV1QWbSqe2q0V68sfZQ9eCui0b1tUCIYiYwQktat/uszbTUw7hY0DuQln8OYHetwl3oRsiiJLarFS6BkEGa+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=URSWDM6T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="URSWDM6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FF01F000E9;
	Mon, 31 Aug 2026 13:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183256;
	bh=HD1E/sgoZex4ry4jV5krfYZp6gRMh0Yc7m3s82PBiAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URSWDM6TF52GjvmulHw6FiVPR2ZoIxUp0ZAkNAtgL5dRj0iNN2aoK22HqtqZtxR4n
	 wBLi12Li3AR72eQFlXphR5f3kGOMhmnLMZjSwNgstemrWeLncx+CVhNnolSuhBIMS9
	 CLwrid15FAeEMjjUjbhvTrtnaiHYa+QvgXDIPZvErFgIF8ZrNB/XO+SWEj8oMNURzj
	 XAfaKHaVZRoF85QcdSI0gmL4JbnvMXfEwkIdavpMerBAf3EGtfxqD439JwkFQ/fZ9u
	 lwJwHoNsxop1THKEh5LRETmtdYOcXvLhq+v6YvR7BcyX9deoxnNJ+eR9dSAdFNTEqc
	 zv19nAmnWsuKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] wifi: nl80211: check link is beaconing for color change
Date: Mon, 31 Aug 2026 09:21:08 -0400
Message-ID: <20260831133314.4125787-40-sashal@kernel.org>
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

[ Upstream commit 55308cee9c2196f39cd1ce8ee6c1fed9e12a00d4 ]

When trying to do a color change, validate that the link is
beaconing first, to avoid calling the driver with an invalid
link.

Reviewed-by: Miriam Rachel Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260415145348.beb59ea5fbf7.I128a956a3e610bb6a5c9cad941d7d5b59b735a5e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: nl80211: check link is beaconing for
color change`

**Local tree:** Linux **6.18.43** (`git describe HEAD` → `v6.18.43`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[wifi: nl80211]` `[check]` — validate that the target MLO
link is actively beaconing before initiating a BSS color change.

### Step 1.2: Tags
**Record:**
| Tag | Value |
|-----|-------|
| Reviewed-by | Miriam Rachel Korenblit
\<miriam.rachel.korenblit@intel.com\> |
| Link | https://patch.msgid.link/20260415145348.beb59ea5fbf7.I128a956a3
e610bb6a5c9cad941d7d5b59b735a5e@changeid |
| Signed-off-by | Johannes Berg \<johannes.berg@intel.com\> |

No Fixes:, Reported-by:, Tested-by:, Cc: stable, or syzbot tags.

**Notable patterns:** Reviewed by Intel wireless developer; author is
wireless subsystem maintainer. No user/fuzzer reports.

### Step 1.3: Body analysis
**Record:**
- **Bug:** Color change can be requested on an MLO link that has been
  added but is not actively beaconing (AP not started on that link).
- **Symptom:** `rdev_color_change()` / mac80211 driver path is invoked
  with an invalid/inactive link.
- **Root cause:** `nl80211_color_change()` lacked the `beacon_interval`
  guard that sibling AP operations already use.
- **Version info:** None in message.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit validation bug fix, not disguised
cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `net/wireless/nl80211.c` (+3 net lines in core logic, −1
  duplicate line)
- **Function:** `nl80211_color_change()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| Early in function | `params.link_id` unset during beacon parsing; no
beaconing check | `params.link_id = nl80211_link_id(...)` resolved
early; returns `-EINVAL` if
`!wdev->links[params.link_id].ap.beacon_interval` |
| Before `rdev_color_change()` | `params.link_id` assigned here |
Duplicate assignment removed |

**Note for this tree (6.18.43):** `nl80211_parse_beacon()` here takes no
channel argument; the channel-parameter changes in the upstream diff are
from a separate patch (`[PATCH 18/20] wifi: nl80211: always validate AP
operation/PHY regulatory`). The beacon_interval check backports
independently.

### Step 2.3: Bug mechanism
**Record:** **Logic / correctness fix** — missing input validation on a
netlink command path.

- `NL80211_CMD_COLOR_CHANGE_REQUEST` has
  `NL80211_FLAG_MLO_VALID_LINK_ID` (link exists) but does not verify the
  link is actively beaconing.
- `wdev->links[link_id].ap.beacon_interval` is set only in
  `nl80211_start_ap()` (line 6883); zero means AP not running on that
  link.
- Without the check, mac80211's `ieee80211_color_change()` can run on an
  inactive link (link struct may exist, but no beacon), setting
  `color_change_active` and modifying beacon state incorrectly.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — mirrors existing checks in the same file.
- **Regression risk:** Very low — only rejects previously-accepted
  invalid requests.
- **Red flags:** None. No API changes, no new features.

**Parallel checks already in this tree:**

```6925:6926:net/wireless/nl80211.c
        if (!wdev->links[link_id].ap.beacon_interval)
                return -EINVAL;
```
(`nl80211_change_beacon`)

```11365:11367:net/wireless/nl80211.c
                /* useless if AP is not running */
                if (!wdev->links[link_id].ap.beacon_interval)
                        return -ENOTCONN;
```
(`nl80211_channel_switch`)

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `nl80211_color_change()` blame points to `19eef1d98eeda`
(shallow/unified history artifact). The function is present at lines
17385–17496 in this tree. `change_beacon`'s `beacon_interval` check
shares the same blame entry — both introduced together; color change
simply missed the same guard.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `nl80211.c` changes in this tree are unrelated
validation fixes (MBSSID, PMSR, etc.). The beacon_interval validation
gap for color change is a standalone oversight, not part of an
incomplete series for *this* specific fix.

### Step 3.4: Author context
**Record:** Johannes Berg is the wireless/cfg80211 maintainer. Related
Apr 2026 series (`20260415_johannes_wifi_mac80211_clean_up_and_fix_per_s
ta_bw_handling.mbx`) includes patch 18/20 noting CSA and color change
"missed" regulatory validation — a separate but related hardening
effort.

### Step 3.5: Dependencies
**Record:** **Standalone for the beacon_interval check.** The channel-
argument changes to `nl80211_parse_beacon()` in the upstream diff are
from a different commit and are NOT required for this validation fix in
6.18.43.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 dig -c <commit>` could not be run (no commit hash in
tree). WebFetch of patch.msgid.link and lore.kernel.org blocked by
Anubis bot protection. **UNVERIFIED:** full mailing list thread content.

### Step 4.2: Reviewers
**Record:** Reviewed-by Miriam Rachel Korenblit (Intel wireless). Author
is subsystem maintainer.

### Step 4.3: Bug report
**Record:** No external bug report, syzbot, or user Reported-by. Bug
identified by maintainer during related nl80211 hardening.

### Step 4.4: Related patches
**Record:** Part of broader Apr 2026 nl80211 validation work; this
specific commit is self-contained.

### Step 4.5: Stable list
**Record:** **UNVERIFIED** — could not search lore stable list due to
bot protection.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `nl80211_color_change()`, `nl80211_link_id()`,
`rdev_color_change()` → `ieee80211_color_change()` →
`ieee80211_set_color_change_beacon()`

### Step 5.2: Callers
**Record:** `nl80211_color_change` is registered as `.doit` for
`NL80211_CMD_COLOR_CHANGE_REQUEST` (line 18971). Invoked from generic
netlink with `GENL_UNS_ADMIN_PERM` — root-only, not unprivileged
userspace.

### Step 5.3: Callees
**Record:** Parses beacon data, then calls `rdev_color_change()` which
invokes mac80211's `ieee80211_color_change()`. mac80211 checks link
existence and CSA/color-change-active state but does **not** check
whether AP is beaconing.

### Step 5.4: Reachability
**Record:** Reachable by root via nl80211 genetlink. Relevant in **MLO
AP** setups where multiple links exist but only some have `start_ap`
called. `NL80211_FLAG_MLO_VALID_LINK_ID` validates link ID existence,
not beaconing state.

### Step 5.5: Similar patterns
**Record:** Identical `beacon_interval` guard in
`nl80211_change_beacon`, `nl80211_channel_switch`,
`nl80211_get_ftm_responder_stats` (line 17100), and
`nl80211_set_mac_acl` (line 5300). Color change is the outlier.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy code present?
**Record:** **YES.** `nl80211_color_change()` at lines 17385–17496 lacks
the `beacon_interval` check. `params.link_id` is only set at line 17486,
immediately before `rdev_color_change()`.

### Step 6.2: Backport complications
**Record:** **Clean apply** for the core fix in 6.18.43:
```c
params.link_id = nl80211_link_id(info->attrs);
if (!wdev->links[params.link_id].ap.beacon_interval)
    return -EINVAL;
```
Place after attribute/count validation, before `nl80211_parse_beacon()`.
Remove duplicate `params.link_id` assignment at line 17486. No channel-
parameter changes needed in this tree.

### Step 6.3: Related fixes already present?
**Record:** **NO** — grep found no `beacon_interval` check in
`nl80211_color_change()`. Sibling operations already have the guard.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **wifi / cfg80211 / nl80211** — IMPORTANT. Affects AP mode
with BSS color and MLO; not universal but used in production WiFi stacks
(hostapd, wpa_supplicant).

### Step 7.2: Subsystem activity
**Record:** Actively developed; MLO multi-link support is relatively
recent, making this class of per-link validation gaps realistic.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of **MLO AP mode** with BSS color change
(`NL80211_EXT_FEATURE_BSS_COLOR`). Config-specific, not all kernel
users.

### Step 8.2: Trigger conditions
**Record:** Root/userspace sends `NL80211_CMD_COLOR_CHANGE_REQUEST`
targeting an MLO link ID that exists but has no active AP
(`beacon_interval == 0`). Plausible in multi-link setups where links are
added but not all are started. **Not triggerable by unprivileged
users.**

### Step 8.3: Failure mode severity
**Record:** Without fix: invalid color-change operation reaches
mac80211/driver — can set `color_change_active` on inactive link, modify
beacon state incorrectly, return confusing errors downstream.
**Severity: MEDIUM** — correctness/state-machine bug, not demonstrated
kernel oops/panic, but can cause operational failures in WiFi management
software.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** MEDIUM — closes validation gap consistent with sibling
  ops; prevents invalid driver invocations in MLO AP.
- **Risk:** VERY LOW — 3-line guard, fail-fast with `-EINVAL`.
- **Ratio:** Favorable for stable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Real bug: color change allowed on non-beaconing MLO link
- Identical validation pattern exists for `change_beacon`,
  `channel_switch`, FTM stats
- Small, surgical, maintainer-authored and reviewed
- Buggy code confirmed present in 6.18.43
- Clean backport without dependent commits
- Prevents incorrect mac80211 state (`color_change_active` on inactive
  link)

**AGAINST backport:**
- No user reports, syzbot, or crash traces
- Root-only API; requires misbehaving or buggy userspace
- Severity is operational correctness, not demonstrated crash/security
- Mailing list discussion unverified

**UNRESOLVED:**
- Full lore thread and any stable nomination comments

### Step 9.2: Stable rules checklist

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — mirrors existing in-file
pattern; reviewed by Intel developer |
| 2. Fixes real bug affecting users? | **PASS** — MLO AP + BSS color
users can hit invalid driver calls |
| 3. Important issue? | **PASS (borderline)** — prevents invalid
driver/state-machine operation; not crash-level but operationally
significant for WiFi AP |
| 4. Small and contained? | **PASS** — ~3 lines |
| 5. No new features/APIs? | **PASS** — validation only |
| 6. Applies to local tree? | **PASS** — buggy code present in 6.18.43 |

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build fix, or docs).

### Step 9.4: Decision rationale

This is a maintainer fix closing an obvious validation gap in
`nl80211_color_change()` that sibling AP operations already guard
against. In an MLO AP configuration, a valid link ID does not imply the
link is beaconing; without this check, mac80211 can be invoked to
perform a color change on an inactive link. The fix is minimal, follows
established conventions in the same file, applies cleanly to 6.18.43,
and carries negligible regression risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Reviewed-by, Link, Signed-off-by);
  no Reported-by/syzbot
- **[Phase 2]** Diff analysis: adds early `link_id` + `beacon_interval`
  check, removes duplicate `link_id` assignment
- **[Phase 2]** Read `nl80211_change_beacon` (6925–6926) and
  `nl80211_channel_switch` (11365–11367) — confirmed parallel guards
- **[Phase 3]** `git blame -L 17385,17496 net/wireless/nl80211.c`:
  function present in tree
- **[Phase 3]** `git blame -L 6925,6926`: change_beacon guard present
- **[Phase 3]** Read mbox `20260415_johannes_wifi_mac80211_clean_up_and_
  fix_per_sta_bw_handling.mbx` line 2426: CSA/color change noted as
  missing validation (separate regulatory patch)
- **[Phase 4]** WebFetch patch.msgid.link: blocked by Anubis —
  **UNVERIFIED** thread content
- **[Phase 4]** WebFetch lore.kernel.org: blocked — **UNVERIFIED**
- **[Phase 4]** `b4 dig`: requires commit hash not available in tree —
  **UNVERIFIED**
- **[Phase 5]** Grep `color_change` in `net/mac80211/cfg.c`:
  `ieee80211_color_change` does not check beaconing
- **[Phase 5]** Read `ieee80211_color_change()` (5274–5330): checks link
  exists, not beaconing
- **[Phase 5]** Read genl op registration (18971–18976):
  `NL80211_FLAG_MLO_VALID_LINK_ID` set
- **[Phase 5]** Read `nl80211_link_id()` (1387–1391): returns ID without
  beaconing validation
- **[Phase 6]** `git describe HEAD`: v6.18.43
- **[Phase 6]** Read `nl80211_color_change()` (17385–17496): missing
  beacon_interval check confirmed
- **[Phase 6]** `nl80211_parse_beacon` signature (6134–6137): no channel
  param in this tree — backport is simpler than upstream diff
- **[Phase 6]** Grep: no existing beacon_interval check in color_change
  path
- **[Phase 8]** `ieee80211_assign_beacon` (1313–1315): may return
  `-EINVAL` without old beacon, but color-change path can still set
  `color_change_active` before/beacon manipulation — invalid state
  remains possible

**YES**The backport analysis is done: **YES** for Linux **6.18.43**.

`nl80211_color_change()` is missing the `beacon_interval` check that
sibling AP paths like `change_beacon` and `channel_switch` already use.
On MLO AP setups, that lets a color change reach mac80211 on a link that
exists but isn’t actively beaconing. The fix is small (early `link_id`
resolution plus a `-EINVAL` guard) and should apply cleanly here without
the separate upstream `nl80211_parse_beacon()` channel changes.

The background `git log -S "NL80211_EXT_FEATURE_BSS_COLOR"` search
didn’t add much — shallow history mostly surfaced unrelated bulk commits
rather than a clear BSS_COLOR introduction point. That doesn’t change
the verdict; the buggy path is present in this tree.

 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9adf6f948d3dc..41695fb53ddff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -17414,6 +17414,10 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 	params.count = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COUNT]);
 	params.color = nla_get_u8(info->attrs[NL80211_ATTR_COLOR_CHANGE_COLOR]);
 
+	params.link_id = nl80211_link_id(info->attrs);
+	if (!wdev->links[params.link_id].ap.beacon_interval)
+		return -EINVAL;
+
 	err = nl80211_parse_beacon(rdev, info->attrs, &params.beacon_next,
 				   info->extack);
 	if (err)
@@ -17487,7 +17491,6 @@ static int nl80211_color_change(struct sk_buff *skb, struct genl_info *info)
 			goto out;
 	}
 
-	params.link_id = nl80211_link_id(info->attrs);
 	err = rdev_color_change(rdev, dev, &params);
 
 out:
-- 
2.53.0

