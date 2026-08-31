Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF321569F2C;
	Mon, 31 Aug 2026 13:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184098; cv=none; b=Clh4XcE0KYolSr/8KBtr8eYsETzzLOGTpHVv1yBHnIfe3eQB3Tg9pRRdB2E/1zvXGfrU/ff3n33dgoDkpd8lvI0MQKb1gfNfaeRm9I6IGzlv8NJmVDy8e0x0/4opKgML/go1gNXi1zom5ltMT6laZ8uwBGgwnaBL7blQTlyXRNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184098; c=relaxed/simple;
	bh=pWlITHxsdaR6tNy9qB/AzeymDyMTpAtdKdFnL3D5sUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WwqYFt/bUXKn3oBiMFhmlsz02X66TL0E3UX5nLPxdKTav+l0AIBdmNFYClbwOCV6VUOGWsC8NoBicnB1jg09NL9Wf6RLbhjWqtMX0ApfN0EtogEl9Uj0wKu33IS7P2hfz9MjE0LfGlAaBzGeDlNT8ZgkSeKUfyEKYExwEllcxRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=krVpy1ko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="krVpy1ko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614E11F00ADB;
	Mon, 31 Aug 2026 13:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184095;
	bh=dpzFcOsUzknn7jzsTuxyFFmfi2Q3KDvIdInsUb0qOtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krVpy1kouME1As/HCW+TEFNMYYC97E0mkxfDT48gBWYHcxzbWreigNtn6Fbmehhvz
	 fCLwjvfE3NCETRyTTR1js4EnPqBTKkSjkg0V6NxeI0nDIpdeyfKdmBU+AmOakLzWOy
	 q6M67txowtLF4PW2m7VKBt/r+Jz5g2G3aAOiIyCfZrccdgzMoVfv20Qub0/VeV628a
	 iraqjbMJrU0TljrbgbPvye+E2LzqPVntzinfY9bY0Uvg1UQio92PDe8mxP9Yx5Ypfr
	 R2j9ph+tblVQJZfhTzjLgUzf8ggXIA8ypc2v/5fWXWPlvhCB3x0oElepVYcdes730s
	 iLMzOW/xzBRnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] wifi: rtw89: phy: check length before parsing PHY status IE
Date: Mon, 31 Aug 2026 09:28:36 -0400
Message-ID: <20260831133314.4125787-488-sashal@kernel.org>
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

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 884495c39de1a02f42bd40051b921e2311d6ac91 ]

Hardware might report PHY status IE with unexpected length, and parser
might access out of range. Check the length ahead.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260506131000.1706298-12-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: rtw89: phy: check length before
parsing PHY status IE`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[wifi: rtw89: phy]` `[check]` — validate PHY status IE
length before parsing; prevents out-of-range access when hardware
reports unexpected IE lengths.

### Step 1.2: Parse all commit message tags
**Record:**
- **Signed-off-by:** Ping-Ke Shih `<pkshih@realtek.com>` (author)
- **Link:**
  https://patch.msgid.link/20260506131000.1706298-12-pkshih@realtek.com
- **No** Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or
  Cc: stable tags
- Message ID suffix `-12-` indicates patch 12 of a series (series
  context noted; core reorder fix is still standalone)

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Hardware may deliver PHY status IEs with unexpected length;
  parser can read past the skb buffer.
- **Symptom:** Out-of-range memory access during PHY status parsing
  (potential oops / info leak).
- **Root cause:** `rtw89_core_process_phy_status_ie()` runs before
  confirming `pos + ie_len <= end`.
- **No** explicit kernel version range in the message.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — message explicitly describes an OOB-access
bug. The fix is reordering validation before parsing, a standard bounds-
check pattern.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/net/wireless/realtek/rtw89/core.c` (~5 lines
  changed, reorder + minor error-path additions)
- **Function:** `rtw89_core_rx_parse_phy_sts()`
- **Scope:** Single-file, surgical fix in one loop body

### Step 2.2: Code flow change
**Record (per hunk):**

**Before:**
```c
ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, iehdr);
rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);  // parses
first
pos += ie_len;
if (pos > end || ie_len == 0)
    return -EINVAL;
```

**After:**
```c
ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, iehdr);
pos += ie_len;
if (pos > end || ie_len == 0) {
    /* clear ie09/ie10 on newer trees */
    return -EINVAL;
}
rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);  // parse
only if in-bounds
```

**Affected path:** RX PPDU status processing loop (normal + error
paths).

### Step 2.3: Bug mechanism
**Record:** **Buffer over-read / out-of-bounds access.**
`rtw89_core_process_phy_status_ie()` casts `iehdr` to structures like
`rtw89_phy_sts_ie01` (24 bytes) and `rtw89_phy_sts_ie01_v2` (40 bytes,
accesses `w8`/`w9`). If `ie_len` is wrong or the remaining buffer is
shorter than the structure, the parser reads past `end` before the
existing bounds check runs.

### Step 2.4: Fix quality
**Record:** Obviously correct — validate-then-use is the right pattern.
Minimal regression risk (only skips parsing of IEs already known to be
invalid). No API or behavioral changes for valid packets.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:** `rtw89_core_rx_parse_phy_sts()` and the process-before-check
ordering are present at the v6.18 merge point (`6bda50f4333fa`,
2025-11-29). The buggy ordering has been in this tree since at least
**6.18.0**.

### Step 3.2: Follow Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: File history for related changes
**Record:** Recent rtw89 fixes in this tree follow the same pattern:
- `ebeaa3b24ba56` — validate release report before use (same author)
- `ef7fa19809b2d` — validate TX release report sequence
- `ad445de67359f` — bounds check on firmware `mac_id`

Standalone fix; no prerequisite commits required for the reorder.

### Step 3.4: Author context
**Record:** Ping-Ke Shih is the primary Realtek rtw89 maintainer.
Multiple rtw89 stable backports from this author are already in 6.18.y.

### Step 3.5: Dependencies
**Record:** The upstream diff also touches `ie09`/`ie10` fields and
monitor-mode accept logic that **do not exist** in 6.18.43. The core
reorder fix applies independently; backport would drop those hunks.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:** `b4 dig -c` could not match (commit not in local tree).
lore.kernel.org and patch.msgid.link blocked by bot protection
(Anubis/403). **UNVERIFIED:** full review thread content.

### Step 4.2: Reviewers
**Record:** **UNVERIFIED** — `b4 dig -w` not possible without commit
hash.

### Step 4.3: Bug report
**Record:** No syzbot/bugzilla link. Bug is described as hardware-
reported malformed PHY status data — plausible real-world trigger
(firmware edge cases), not purely theoretical.

### Step 4.4: Related patches / series
**Record:** Message ID indicates patch 12 of a series. The bounds-check
reorder does not depend on earlier series patches for correctness in
6.18.43.

### Step 4.5: Stable mailing list
**Record:** **UNVERIFIED** — could not search lore stable archive due to
access restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `rtw89_core_rx_parse_phy_sts()`,
`rtw89_core_process_phy_status_ie()`,
`rtw89_core_get_phy_status_ie_len()`,
`rtw89_core_parse_phy_status_ie01()`,
`rtw89_core_parse_phy_status_ie01_v2()`.

### Step 5.2: Callers
**Record:**
- `rtw89_core_rx_process_phy_sts()` → `rtw89_core_rx_parse_phy_sts()`
- `rtw89_core_rx_process_ppdu_sts()` → `rtw89_core_rx_process_phy_sts()`
- `rtw89_core_rx_process_report()` handles
  `RTW89_CORE_RX_TYPE_PPDU_STAT`

Called on every PPDU status report from firmware during normal WiFi RX.

### Step 5.3: Callees
**Record:** IE parsers read multi-word hardware structures via
`le32_get_bits()` at fixed offsets (e.g., `ie->w8`, `ie->w9` up to 40
bytes into `rtw89_phy_sts_ie01_v2`).

### Step 5.4: Reachability
**Record:** Triggered by firmware RX reports on active WiFi interfaces —
common runtime path, not init-only or debug-only.

### Step 5.5: Similar patterns
**Record:** Same driver already had multiple “validate before use”
stable backports (`ebeaa3b`, `ef7fa198`, `ad445de`), confirming
maintainer awareness of malformed-firmware crash class.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE (6.18.43)

### Step 6.1: Does buggy code exist?
**Record:** **YES.** Current code at lines 2024–2026 still calls
`rtw89_core_process_phy_status_ie()` before the bounds check:

```2021:2031:drivers/net/wireless/realtek/rtw89/core.c
        while (pos < end) {
                const struct rtw89_phy_sts_iehdr *iehdr = pos;

                ie_len = rtw89_core_get_phy_status_ie_len(rtwdev,
iehdr);
                rtw89_core_process_phy_status_ie(rtwdev, iehdr,
phy_ppdu);
                pos += ie_len;
                if (pos > end || ie_len == 0) {
                        rtw89_debug(rtwdev, RTW89_DBG_TXRX,
                                    "phy status parse failed\n");
                        return -EINVAL;
                }
        }
```

### Step 6.2: Backport complications
**Record:** **Clean apply** for the reorder hunk. Upstream `ie09`/`ie10`
clearing and monitor-mode `accept` logic are not in 6.18.43 and should
be omitted during backport.

### Step 6.3: Related fixes already present?
**Record:** **No** — grep found no “check length before parsing” commit;
fix not yet applied.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wireless/realtek/rtw89` — **IMPORTANT**
(Realtek WiFi devices on PCI/USB; widely deployed on laptops and
desktops with `CONFIG_RTW89`).

### Step 7.2: Subsystem activity
**Record:** High — 27+ rtw89 commits in this tree’s recent history;
active maintenance and stable backports.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who is affected
**Record:** Users with rtw89-supported hardware (RTL8852AE/BE,
RTL8922AE/DE, etc.) running normal WiFi traffic.

### Step 8.2: Trigger conditions
**Record:** Malformed or unexpectedly-sized PHY status IE from
hardware/firmware. Not every packet, but reachable during normal RX
without special privileges. Unprivileged users can generate WiFi traffic
that produces PPDU status reports.

### Step 8.3: Failure mode severity
**Record:** Out-of-bounds read from skb data → **HIGH** severity (kernel
oops possible; potential info leak past buffer). Existing error return
path does not prevent damage because parsing happens first.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — prevents crash/info-leak on malformed firmware
  data in a hot RX path
- **Risk:** VERY LOW — ~3-line reorder, no logic change for valid IEs
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Real OOB-read bug in production RX path
- Bug confirmed present in 6.18.43
- Small, obviously correct fix
- Same author/maintainer pattern already accepted in this tree
- Prevents kernel crash on malformed hardware reports

**AGAINST backport:**
- No syzbot/user crash report attached (weaker evidence, but mechanism
  is clear from code)
- Upstream patch is part of a series and includes hunks not applicable
  to 6.18.43 (minor backport adaptation needed)
- Mailing list review not verified

**Unresolved:** Full lore review thread; whether a user-visible crash
report exists.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reorder is self-evident;
   author is driver maintainer
2. Fixes a real bug? **PASS** — OOB read before bounds check
3. Important issue? **PASS** — crash / memory safety in RX hot path
   (**HIGH**)
4. Small and contained? **PASS** — single function, few lines
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — reorder applies cleanly; omit
   `ie09`/`ie10` hunks

### Step 9.3: Exception categories
**Record:** N/A (not device ID, quirk, DT, build, or docs — standard bug
fix).

### Step 9.4: Decision rationale
This commit fixes a clear ordering bug: the driver parses PHY status
information elements before verifying they fit within the received skb
buffer. When hardware reports an unexpected IE length, parsers access
fixed offsets (up to 40 bytes) that can extend past the buffer end,
causing a kernel oops or information leak. The bug exists in 6.18.43,
the fix is minimal and follows established rtw89 stable-backport
patterns from the same maintainer, and it addresses a serious failure
mode on a common RX path.

---

## Verification

- **[Phase 1]** Parsed subject, tags (Signed-off-by, Link); no
  Fixes:/Reported-by
- **[Phase 2]** Read diff and current `core.c` lines 2007–2038;
  confirmed process-before-check ordering
- **[Phase 2]** Verified IE structure sizes in `txrx.h`
  (`rtw89_phy_sts_ie01` 24B, `rtw89_phy_sts_ie01_v2` 40B with `w8`/`w9`)
- **[Phase 3]** `git blame -L 2007,2040`: function present since
  `6bda50f4333fa` (v6.18 merge)
- **[Phase 3]** `git show 6bda50f4333fa:core.c`: function existed at
  v6.18.0 with same bug pattern
- **[Phase 3]** `git log --oneline -20 --
  drivers/net/wireless/realtek/rtw89/`: related validation fixes present
- **[Phase 3]** `git show ebeaa3b24ba56`, `ad445de67359f`: same
  “validate before use” pattern already backported
- **[Phase 4]** `b4 dig -c HEAD`: no match (commit not in tree)
- **[Phase 4]** lore.kernel.org / patch.msgid.link: **BLOCKED** (bot
  protection) — review thread UNVERIFIED
- **[Phase 5]** `grep rtw89_core_rx_process_phy_sts`: call chain through
  `rtw89_core_rx_process_ppdu_sts` → PPDU_STAT RX path
- **[Phase 5]** Read `rtw89_core_rx_process_phy_ppdu_iter`: only uses
  parsed data after `phy_ppdu->valid` set on success
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: tree is
  6.18.43
- **[Phase 6]** `grep ie09|ie10 drivers/net/wireless/realtek/rtw89/`: no
  matches — upstream-only hunks not in this tree
- **[Phase 6]** `grep "check length before parsing"`: not present — fix
  not yet applied
- **[Phase 8]** Confirmed failure mode is OOB read with HIGH severity on
  active WiFi RX path

---

**YES**

 drivers/net/wireless/realtek/rtw89/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index c2bf839fd82a9..2eb992c1c2d08 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -2026,13 +2026,15 @@ static int rtw89_core_rx_parse_phy_sts(struct rtw89_dev *rtwdev,
 		const struct rtw89_phy_sts_iehdr *iehdr = pos;
 
 		ie_len = rtw89_core_get_phy_status_ie_len(rtwdev, iehdr);
-		rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);
 		pos += ie_len;
 		if (pos > end || ie_len == 0) {
 			rtw89_debug(rtwdev, RTW89_DBG_TXRX,
 				    "phy status parse failed\n");
+
 			return -EINVAL;
 		}
+
+		rtw89_core_process_phy_status_ie(rtwdev, iehdr, phy_ppdu);
 	}
 
 	rtw89_chip_convert_rpl_to_rssi(rtwdev, phy_ppdu);
-- 
2.53.0

