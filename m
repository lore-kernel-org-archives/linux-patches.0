Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164845E39D5;
	Mon, 19 Oct 2026 14:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418551; cv=none; b=ROJR2dvZNZL/7W8HifbbqSwag9zzt/U3x6WiRc8tTXdsNPrObY9cM8CWG0KSnIv/AJPVGm2YvFfXWaBhagEp7zSQKTRTO/GpCykbkyWTmsThWbz15geiPawCnB5zbRQ16e2ms9R0Ba+NfN86W6jyb8zPlYuADqGDerkCkP+sGJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418551; c=relaxed/simple;
	bh=V2I3htPfIUdQElg+MdDWCd8praOMiiWbbl8dZAXFOL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=huOUOJVihsuGcAlMrBvQSkxrepMlT3AkfFyuigMZWpFDBOQgt1cMAJSziBYd5vRt2n+vniV+f01ZQZ35RG/gE2qzj9evM67UXl8zcmfUp5h1K9ECaBRwAEd4TW6ozw2TtpWzd6Ngsadw822k/6+pCG78sCIaFiqLOEWswWos0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i5NZw02G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i5NZw02G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261231F000C8;
	Mon, 19 Oct 2026 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418549;
	bh=s2KO/xXiICc0z1MsMXV0wNhHuNF/cXkqdi+CLIaYDq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i5NZw02GejVaAGCyahf4VnVaP5VLsr6w6O+bTkIDxjDXgxMUh1a/kAjcLwIHiYx3b
	 UfSsgADrwdYn3eIUSYwe12XKw/rM+lyh+Sk6iNmNyyO/4ts7pfJsdah7K366hskSIZ
	 Z0h8u0LZnfn+lrjX9FliubzjkVwt6d/b7vcDsUjRTKrzs+vOgCpMuQDCZvXQZU/MXM
	 AFyiLy6rwOio+pX25ng6wY3bdYediUCw1u+slaBZPHMHQiXwQ5LHR42+Nl0kQh0uJj
	 O6kaJ1asm3sFlLQFK9zWOY8tO+j09v5/J7ymIYG1zxaPKzM/Z5ryBOZ1vAIJKgu1U9
	 ZVw+A8SXJec0Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: cfg80211: include cf1 offset when sending chandef
Date: Mon, 19 Oct 2026 09:50:18 -0400
Message-ID: <20261019135441.1420968-327-sashal@kernel.org>
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

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 5a69b8dffd2a1b06e4cc4c9003c639eb78bac4cd ]

The cf1 offset is not included when sending the chandef leading
to incorrect channel resolution in usermode. Include it.

Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260721053958.227853-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[wifi: cfg80211] [include] include cf1 offset when sending
  chandef`
- Subsystem: cfg80211 / nl80211 (`net/wireless/nl80211.c`)
- Verb is “include”, not “fix”, but the body states a concrete userspace
  correctness bug.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>`
    (author)
  - `Link: https://patch.msgid.link/20260721053958.227853-1-
    lachlan.hodges@morsemicro.com`
  - `Signed-off-by: Johannes Berg <johannes.berg@intel.com>` (wireless
    maintainer apply)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence is expected and is not treated as a
    negative)
- Pattern: vendor S1G/HaLow developer (Morse Micro), applied same day by
  the subsystem maintainer. No syzbot/KASAN report.

**Step 1.3 — Body**
- Record:
  - Bug: `freq1_offset` is omitted when nl80211 sends a chandef.
  - Symptom: “incorrect channel resolution in usermode.”
  - Failure mode: userspace reconstructs the operating-channel center
    from `NL80211_ATTR_CENTER_FREQ1` (MHz) only, dropping the kHz
    remainder.
  - Version info: none in the message.
  - Root cause as stated: send path does not emit
    `NL80211_ATTR_CENTER_FREQ1_OFFSET`.

**Step 1.4 — Hidden bug fix?**
- Record: Yes. “Include it” is a dump-path omission fix, not a cleanup.
  It restores the send side of an attribute the kernel has parsed since
  2020.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record:
  - File: `net/wireless/nl80211.c` (`+4 / -0`)
  - Function: `nl80211_send_chandef()`
  - Scope: single-file surgical fix

**Step 2.2 — Code flow**
- Record: After putting `NL80211_ATTR_CENTER_FREQ1`, the function now
  also puts `NL80211_ATTR_CENTER_FREQ1_OFFSET` when
  `chandef->freq1_offset` is non-zero. Same `-ENOBUFS` pattern as
  `center_freq2` / `punctured`. Normal dump/event path, not an error-
  only path.

**Step 2.3 — Bug mechanism**
- Record: **Logic / ABI completeness.** Parse path already does:
  `chandef->freq1_offset =
  nla_get_u32_default(attrs[NL80211_ATTR_CENTER_FREQ1_OFFSET], 0)`
  Send path already emits `NL80211_ATTR_WIPHY_FREQ_OFFSET` for the
  *control* channel, but never emitted the matching center-segment
  offset. Kernel identity comparison (`cfg80211_chandef_identical`)
  includes `freq1_offset`, so the kernel treats that field as part of
  the channel.

**Step 2.4 — Fix quality**
- Record: Obviously correct; 4 lines; mirrors existing nla_put style.
  Regression risk is very low: the attribute is already in uapi (since
  2020), is optional, and is only sent when the offset is non-zero. Old
  userspace ignores unknown/unused attributes. No API or struct change.

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: `nl80211_send_chandef()` dates to 2012 (`683b6d3b31a519`).
  Control-channel kHz offset send was added in `942ba88ba9c87`
  (2020-05-27, “nl80211: add KHz frequency offset for most wifi
  commands”). That commit added parse of
  `NL80211_ATTR_CENTER_FREQ1_OFFSET` into `chandef->freq1_offset` and
  send of `WIPHY_FREQ_OFFSET`, but not send of `CENTER_FREQ1_OFFSET`.
  The struct field itself was added in `934f4c7dd3a54` (2020-04-24,
  “cfg80211: express channels with a KHz component”). The omission has
  been present since the KHz ABI was introduced.

**Step 3.2 — Fixes: tag**
- Record: None. Closest introducer is `942ba88ba9c87` (verified present
  in this tree). No later conflicting rewrite of this hunk besides the
  candidate itself (`5a69b8dffd2a1`).

**Step 3.3 — File history**
- Record: Related completeness patch by the same author: `3fc830cd8c9d0`
  (“include s1g_primary_2mhz when sending chandef”). Standalone; not
  patch X/Y. No prerequisite refactor required for these four lines.

**Step 3.4 — Author**
- Record: Lachlan Hodges is a regular S1G/cfg80211 contributor (Morse
  Micro). Nearby work is S1G chandef validation and the in-tree `mm81x`
  HaLow driver (`b1906cea00b02`, 2026-07-08). Johannes Berg applied the
  patch.

**Step 3.5 — Dependencies**
- Record: Needs `chandef->freq1_offset` and
  `NL80211_ATTR_CENTER_FREQ1_OFFSET`. Both exist in this tree (2020).
  Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c 5a69b8dffd2a1` → https://patch.msgid.link/202607210
  53958.227853-1-lachlan.hodges@morsemicro.com
- Series: v1 only (`b4 dig -a`). Subject: `[PATCH wireless-next]`.
- Saved mbox (`b4 dig -m`): only the original submission; no replies, no
  NAK, no reviewer `Cc: stable`.
- UNVERIFIED: lore.kernel.org HTML/WebFetch returned 403 (Anubis).
  Discussion content is taken from the b4 mbox, not the HTML thread
  view.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Johannes Berg, linux-wireless, Arien Judge (Morse Micro).
  Maintainer was To: and applied the patch the same day.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla link. Evidence of user impact is the Morse
  Micro author plus in-tree S1G hardware that uses 500 kHz offsets.

**Step 4.4 — Series**
- Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5 — Stable list**
- Record: UNVERIFIED for lore.kernel.org/stable HTML (403). No stable
  discussion in the b4-matched wireless thread.

## Phase 5: Semantic / call-chain

**Step 5.1 — Functions**
- Record: `nl80211_send_chandef()` only.

**Step 5.2 — Callers (verified)**
- Record:
  - `nl80211_send_iface()` — GET/NEW interface dump, including MLO links
    (`iw` / netlink dump)
  - channel-switch notify (`cfg80211_ch_switch_notify` / started)
  - `cfg80211_incumbent_signal_notify`
  - DFS/radar notify
  - `cfg80211_nan_channel_evac`
  - `mac80211_hwsim` (exported symbol)
- Calling context: netlink dump and MLME multicast events. Userspace-
  reachable.

**Step 5.3 — Callees**
- Record: `nla_put_u32()` only for this hunk.

**Step 5.4 — Reachability**
- Record: Yes. Unprivileged dumps depend on nl80211 permissions, but any
  process that can GET_INTERFACE / receive MLME events sees the
  truncated center. S1G AP/STA userspace that round-trips a dumped
  chandef into SET_CHANNEL would restore `freq1_offset = 0`.

**Step 5.5 — Similar patterns**
- Record: Same send-path omission pattern as `s1g_primary_2mhz`. S1G
  frequencies are `902000 + chan * 500` kHz
  (`ieee80211_channel_to_freq_khz`). Morse `mm81x` channels are all
  `freq_offset = 500` (902.5, 903.5, …). Non-zero `freq1_offset` is the
  common case for that hardware, not an edge case.

## Phase 6: This checkout

**Step 6.1 — Buggy code in this tree?**
- Record: Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`,
  Makefile `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`).
- `nl80211_send_chandef`, `freq1_offset`, and
  `NL80211_ATTR_CENTER_FREQ1_OFFSET` all exist here.
- Bug introduced with the 2020 KHz ABI (`942ba88ba9c87` /
  `934f4c7dd3a54`), long before this branch.
- Candidate `5a69b8dffd2a1` is an ancestor of HEAD (landed in 7.3-rc1).
  That is not used as a “already selected for stable” reason; it only
  confirms the code under review is this tree’s current
  `nl80211_send_chandef`.

**Step 6.2 — Backport difficulty**
- Record: Clean on this tree (the four-line hunk matches current code).
  Surrounding later fields (`npca_*`) are already present here; no
  rework needed *on this tree*.

**Step 6.3 — Other fixes already here?**
- Record: No alternate fix. This is the only send of
  `CENTER_FREQ1_OFFSET` in the tree (`nla_put` grep).

## Phase 7: Subsystem context

**Step 7.1**
- Record: `net/wireless` cfg80211/nl80211. Criticality: **IMPORTANT**
  (Wi-Fi uAPI; not mm/core, but the dump path is the userspace contract
  for every wireless interface).

**Step 7.2**
- Record: Actively developed (S1G, NPCA, MLO). The omission itself is
  old; S1G use of kHz offsets is what made it user-visible.

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Config/driver-specific: S1G/HaLow and any chandef with non-
  zero `freq1_offset`. In this tree that includes `mm81x` and hwsim S1G.
  2.4/5/6 GHz integer-MHz channels have `freq1_offset == 0`, so the new
  `nla_put` is skipped.

**Step 8.2 — Trigger**
- Record: Common for S1G: interface dump, channel switch, radar, NAN
  evac. Not a race. Userspace that reads nl80211 can trigger it; no
  exploit primitive verified.

**Step 8.3 — Failure mode**
- Record: Wrong operating-channel center in userspace (typically **500
  kHz** on S1G, which is half of a 1 MHz channel). Kernel does not oops.
  Severity: **MEDIUM** (connectivity / wrong-channel round-trip, not
  crash/corruption/UAF). Fits stable’s “oh, that’s not good” / real bug
  that bothers users of that hardware.

**Step 8.4 — Risk-benefit**
- Record: Benefit medium for S1G users (correct channel identity). Risk
  very low (4 lines, optional existing attribute, offset==0 is a no-op).
  Ratio favors taking it.

## Phase 9: Synthesis

**Step 9.1 — Evidence**

FOR:
- Real dump/event omission: parse has accepted `CENTER_FREQ1_OFFSET`
  since 2020; send never included it.
- S1G channel grid is 500 kHz; Morse `mm81x` channels all have
  `freq_offset = 500`.
- Kernel chandef identity includes `freq1_offset`; userspace cannot
  reconstruct it from `CENTER_FREQ1` alone.
- Dump-then-set round-trip zeros the offset.
- 4-line, obviously correct, no new API.
- Maintainer (Johannes Berg) applied it; callers are standard nl80211
  dump/event paths.

AGAINST:
- Not a crash, deadlock, UAF, or security issue.
- Submitted as `wireless-next`, not `wireless` fixes; no list review
  replies in the b4 mbox.
- Affects a narrower band (S1G/HaLow), not all Wi-Fi users.

UNRESOLVED:
- Full lore HTML (403). Stable-list search (403). Exact userspace
  (iw/hostapd) behavior not inspected in this repo.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — 4 lines, same pattern as
   adjacent attributes; maintainer applied.
2. Real bug that affects users? **PASS** — S1G userspace gets the wrong
   operating center.
3. Important issue? **PASS** (medium) — wrong RF channel center on
   dump/events and on chandef round-trip; not a crash, but a user-
   visible correctness bug on in-tree HaLow hardware.
4. Small and contained? **PASS** — 4 lines, one function.
5. No new features/APIs? **PASS** — emits an existing uapi attribute.
6. Can apply to this tree? **PASS** — fields and function exist here.

**Step 9.3 — Exception category**
- Record: None of device-ID / quirk / DT / build / docs. Ordinary small
  correctness fix.

**Step 9.4 — Decision**
This tree is 7.3-rc4. The affected send path and `freq1_offset` exist
here. The patch is a small, obviously correct fix for a real userspace
channel-identity bug on S1G, with negligible regression risk. It meets
the stable rules for this checkout.

### What the commit solves
`nl80211_send_chandef()` already reported the control frequency plus
`WIPHY_FREQ_OFFSET`, but dropped `chandef->freq1_offset` for the
operating center. Userspace then resolves center as an integer MHz
value. On S1G that is systematically wrong by 500 kHz.

### Stable fit
Small, contained, no new API, real user-visible bug, low risk.

### Risk vs benefit
Benefit: correct channel dumps/events for S1G/HaLow. Risk: very low
optional netlink attribute.

### Concerns
No crash report; vendor-driven; lore HTML unverified. None of those
outweigh the verified omission and the 500 kHz S1G grid.

Verification:
- [Phase 1] Parsed tags: author Lachlan Hodges, Link msgid, SOB Johannes
  Berg; no Fixes/Reported-by/Cc-stable
- [Phase 2] Diff: +4 lines in `nl80211_send_chandef()` adding
  `NL80211_ATTR_CENTER_FREQ1_OFFSET`
- [Phase 3] `git blame`: send of `WIPHY_FREQ_OFFSET` from
  `942ba88ba9c87` (2020); this hunk from `5a69b8dffd2a1`
- [Phase 3] `git log -S 'u16 freq1_offset' -- include/net/cfg80211.h`:
  field added in `934f4c7dd3a54` (2020)
- [Phase 3] Parse path already reads `CENTER_FREQ1_OFFSET` at
  nl80211.c:4006–4007
- [Phase 3] `git merge-base --is-ancestor 5a69b8dffd2a1 HEAD` → yes
  (inspection only)
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 wireless-next, no replies in mbox;
  To: Johannes
- [Phase 4] WebFetch/curl lore: 403 Anubis — UNVERIFIED HTML thread
- [Phase 5] Callers: iface dump, CSA, radar, NAN, hwsim
- [Phase 5] S1G freq: `902000 + chan * 500`; mm81x channels all offset
  500
- [Phase 5] `cfg80211_chandef_identical` compares `freq1_offset`
- [Phase 6] `git describe HEAD` / `make kernelversion`: 7.3.0-rc4; buggy
  pattern exists; attr/field present
- [Phase 8] Failure mode: wrong userspace channel center (typically 500
  kHz), severity MEDIUM
- UNVERIFIED: stable@ lore discussion; iw/hostapd source handling of the
  attribute

**YES**

 net/wireless/nl80211.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b851e398b1b36..6ebbb16accfe8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4260,6 +4260,10 @@ int nl80211_send_chandef(struct sk_buff *msg, const struct cfg80211_chan_def *ch
 		return -ENOBUFS;
 	if (nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1, chandef->center_freq1))
 		return -ENOBUFS;
+	if (chandef->freq1_offset &&
+	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ1_OFFSET,
+			chandef->freq1_offset))
+		return -ENOBUFS;
 	if (chandef->center_freq2 &&
 	    nla_put_u32(msg, NL80211_ATTR_CENTER_FREQ2, chandef->center_freq2))
 		return -ENOBUFS;
-- 
2.53.0

