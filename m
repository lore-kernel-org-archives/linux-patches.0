Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECB9426693;
	Mon, 31 Aug 2026 13:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184227; cv=none; b=bPyG0vQnv0swhHseBXpBRdQr9+RZyo96pQqoXZfL/ixjyfVmt85Bi/UxhvWdY72WwXmF36zWsQQc4bVMLALI8Svm3NgZUn+EOmj25TWNDxc6jaSaKn3ycr3K+0Nxldnx/ZVHXXrFun1iOl0FlWa1AUV3j+kFIGbnhYY5HZuK9e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184227; c=relaxed/simple;
	bh=HpOW4D1NhzdjSi9njnQDB5aZsHgW4Y9NQbqE64WdezQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gyc3n1uXuUFJ30Y4q7UATvN2EPC3TwjQ7ySxjhiYLMRwcKbs715BzTE0FsVRSSsdV6Uc8CHc4fMv0hBvM500PoMIGRyLLAggaiK5qUvF/QfjC3hmUQVDPNeQRaFIkjbE2OhAzGH6VW6/KTVjMJbVlu+5xcnPy2w4l1nSbn4+QV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nc7o40X9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nc7o40X9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74721F000E9;
	Mon, 31 Aug 2026 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184225;
	bh=FCQ6Zqkgf2lc4p1LJ+QCEmE6hQEL3YfgGqOuRs2wn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nc7o40X9USoJBQaNgXD/OuBKm3h/L3nv8JinakG0kl0X1rofBmYVnNlSeu7I3y8NH
	 tWS5omweTUavhUS51XI7Fc73q3OCP85Jm4zXc9UCLOAUY1GTjxqpUeSLv1P+PYNtQI
	 BC9LYSj2/QJjr4Xzyj96vpeIhnhV3zAxF3um/dDBW89jXyrYUOvtIeR5LeVFJM+Fj2
	 2EzvAWP5KozbWnhGfXOKMxcKkCA/Tw92Ai/uuChiMs/kYKFn54KOztRXjXX+lfJX93
	 ynwX86ToimzLSX8LHSMM2OH4jrNeUmYAlSjPxvmWdywqRYFzCX0hcyoA5UIM7s3Bsk
	 dmieE0hPevTlw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: libertas: reject short monitor TX frames
Date: Mon, 31 Aug 2026 09:29:54 -0400
Message-ID: <20260831133314.4125787-566-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 13ff543e0b2c713aedeaadadde686686e949dc78 ]

In monitor mode, lbs_hard_start_xmit() casts skb->data to a
radiotap TX header, skips that header, and then copies the 802.11
destination address from offset 4 in the remaining frame.  The
generic length check only rejects zero-length and oversized skbs, so
a short monitor frame can be read past the end of the skb data.

Require enough bytes for the radiotap TX header and the destination
address field before using the monitor-mode header layout.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704011140.37639-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `wifi: libertas: reject short monitor TX
frames`

**Local tree:** Linux 6.18.44 (`git describe HEAD` →
`v6.18.44-1-g2736c32da98b9`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[wifi: libertas]` `[reject]` — Reject undersized monitor-
mode TX frames in the Marvell Libertas wireless driver.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Signed-off-by:** Johannes Berg `<johannes.berg@intel.com>` (wireless
  maintainer acceptance)
- **Link:**
  `https://patch.msgid.link/20260704011140.37639-1-pengpeng@iscas.ac.cn`
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer SOB from Johannes Berg; no syzbot/fuzzer report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** In monitor mode, `lbs_hard_start_xmit()` treats `skb->data`
  as a radiotap TX header, skips it, then copies the 802.11 destination
  address from offset 4. The existing length check only rejects zero-
  length and oversized SKBs.
- **Symptom:** Short monitor-mode frames cause reads past the end of skb
  data (out-of-bounds access).
- **Root cause:** Missing minimum-length validation for the monitor-mode
  header layout before dereferencing/copying.
- **Version info:** None stated in the commit message.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — this is an explicit bounds-check bug fix,
though described without words like "overflow" or "OOB."

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wireless/marvell/libertas/tx.c` (+7 lines)
- **Function:** `lbs_hard_start_xmit()`
- **Scope:** Single-file, surgical fix inside the
  `NL80211_IFTYPE_MONITOR` branch

### Step 2.2: Code Flow Change
**Record:**
- **Before:** After generic `skb->len` check (reject 0 or > max),
  monitor path immediately reads `rtap_hdr->rate`, advances past
  `sizeof(*rtap_hdr)`, and `memcpy()`'s 6 bytes from `p802x_hdr + 4`.
- **After:** Same path, but first verifies `skb->len >=
  sizeof(*rtap_hdr) + 4 + ETH_ALEN` (22 bytes with `tx_radiotap_hdr` =
  12 bytes). On failure: log, increment drop/error stats, `goto free`.
- **Path affected:** Monitor-mode TX only; normal (802.3) TX unchanged.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Buffer overflow / out-of-bounds read
- **Mechanism:**
  1. `rtap_hdr->rate` read with `skb->len < 12` → OOB read
  2. `memcpy(..., p802x_hdr + 4, ETH_ALEN)` with insufficient data → OOB
     read
  3. `pkt_len -= sizeof(*rtap_hdr)` when `skb->len < sizeof(*rtap_hdr)`
     → `uint16_t` underflow → `memcpy(&txpd[1], p802x_hdr, pkt_len)` at
     line 143 can attempt a very large copy → severe OOB read/write

### Step 2.4: Fix Quality
**Record:**
- Length-check logic is correct: `sizeof(*rtap_hdr) + 4 + ETH_ALEN`
  covers radiotap header + 802.11 FC field (4 bytes) + destination
  address (6 bytes).
- Minimal, matches existing error-handling style (stats + `goto free`).
- **Concern:** The new check runs *after* `spin_unlock_irqrestore()` at
  line 106 and after `priv->tx_pending_len = -1` at line 105. A `goto
  free` from there reaches the `free:` label without re-acquiring
  `driver_lock`, yet `unlock:` always calls `spin_unlock_irqrestore()`.
  This is inconsistent with early `goto free` paths (lines 78–88) that
  hold the lock. On the error path, `tx_pending_len` would also remain
  `-1` and queues remain stopped. The length check would be safer before
  line 92 (while lock is held, before queue stop). The core bounds-check
  logic is sound; error-path cleanup placement is suboptimal.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Shallow clone (`git rev-parse --is-shallow-repository` →
`true`) limits blame depth. Blame on lines 117–128 points to merge
commit `5d324e5159d9e` only. Monitor-mode TX code with `tx_radiotap_hdr`
is present in this 6.18.44 tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: File History
**Record:** `git log --oneline --
drivers/net/wireless/marvell/libertas/tx.c` returns only one shallow
merge entry. Recent libertas stable-style fixes visible in shallow
history include UAF, memory leak, and URB fixes (`ed7d30f90b77f`,
`6cda91bbb8dc3`, etc.), indicating this driver does receive stable
backports.

### Step 3.4: Author History
**Record:** Pengpeng Hou has other bounds-check fixes in this repo
(e.g., CAN drivers). Johannes Berg is the wireless subsystem maintainer
(Signed-off-by).

### Step 3.5: Dependencies
**Record:** Standalone single-patch fix. Uses `struct tx_radiotap_hdr`
from `radiotap.h` and `ETH_ALEN` — both present in this tree. No series
dependencies.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Fetched via curl from `https://lore.kernel.org/linux-
wireless/20260704011140.37639-1-pengpeng@iscas.ac.cn/t.mbox.gz`.
Original submission only; no reply thread visible in mbox. URL:
https://lore.kernel.org/linux-
wireless/20260704011140.37639-1-pengpeng@iscas.ac.cn/

### Step 4.2: Reviewers
**Record:** CC'd: `linux-wireless@vger.kernel.org`, `libertas-
dev@lists.infradead.org`, `linux-kernel@vger.kernel.org`. Johannes Berg
Signed-off-by indicates maintainer acceptance. `b4 dig` could not be run
(no commit hash in this shallow tree).

### Step 4.3: Bug Report
**Record:** No external bug report, syzbot link, or user Reported-by.
Bug identified through code analysis by the author.

### Step 4.4: Related Patches
**Record:** Standalone; not part of a series.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found for this specific patch
(lore search returned empty).

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `lbs_hard_start_xmit()` modified.

### Step 5.2: Callers
**Record:** Registered as `.ndo_start_xmit` in:
- `drivers/net/wireless/marvell/libertas/main.c` (line 809)
- `drivers/net/wireless/marvell/libertas/mesh.c` (line 968)

Standard netdev TX hot path — invoked when userspace/kernel transmits on
the Libertas interface.

### Step 5.3: Callees
**Record:** On monitor path: `convert_radiotap_rate_to_mv()`,
`memcpy()`, `lbs_mesh_set_txpd()`, further `memcpy(&txpd[1], ...)`.
Error path: `dev_kfree_skb_any()`, `spin_unlock_irqrestore()`,
`wake_up()`.

### Step 5.4: Reachability
**Record:**
- Monitor mode enabled when `lbs_rtap_supported(priv)` is true (`cfg.c`
  line 2168–2169).
- Requires `CONFIG_LIBERTAS` + USB/SDIO/SPI transport.
- Userspace with `CAP_NET_ADMIN` can set monitor mode and inject TX
  frames (e.g., via `packet_socket` / monitor interfaces).
- Bug reachable from userspace on affected hardware, though hardware
  population is small (Marvell Libertas 8385/8388/8686 — OLPC-era and
  legacy USB/SDIO devices).

### Step 5.5: Similar Patterns
**Record:** Non-monitor path at line 131 also copies `ETH_ALEN` bytes
without a minimum-length check (pre-existing, separate issue). Monitor
path is uniquely vulnerable due to the additional radiotap header and
offset-4 802.11 address extraction.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `tx.c` in 6.18.44 lacks the length check.
Monitor-mode TX path at lines 117–128 matches the pre-fix code exactly.
Monitor mode support is present (`cfg.c`, `cmd.c`, `rx.c`,
`radiotap.h`).

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** No recent refactoring of this
function visible in shallow history. Single hunk, 7 lines.

### Step 6.3: Related Fixes Already Present?
**Record:** No existing fix for short monitor TX frames found. Other
libertas stability fixes (UAF, leaks) are in history but unrelated.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/net/wireless/marvell/libertas` — **PERIPHERAL**
driver (legacy Marvell WLAN hardware). Config-dependent
(`CONFIG_LIBERTAS`).

### Step 7.2: Subsystem Activity
**Record:** Low activity but receives occasional stability fixes.
Monitor mode is mature (firmware command `CMD_802_11_MONITOR_MODE` in
`host.h`, OLPC-era comment).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Marvell Libertas hardware (USB/SDIO/SPI) running
monitor mode with packet injection. Small but real user population (OLPC
XO, legacy dongles).

### Step 8.2: Trigger Conditions
**Record:** TX of a monitor-mode frame shorter than 22 bytes. Unlikely
in normal operation but trivially triggerable by crafted userspace
packets. Requires monitor mode (typically `CAP_NET_ADMIN`).

### Step 8.3: Failure Mode Severity
**Record:** Out-of-bounds read; potential `uint16_t` underflow leading
to large `memcpy` OOB. **Severity: HIGH** when triggered (kernel memory
safety violation, possible crash under KASAN, potential info leak).
Without fix, every short injected frame hits this path.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents OOB access on netdev TX path for monitor-mode
  injection — standard stable-worthy bug class.
- **Risk:** Very low for normal traffic (only rejects invalid short
  frames). The `goto free` placement after `spin_unlock` is a minor
  concern on the error-only path; stable maintainers may want to move
  the check earlier during backport.
- **Ratio:** Benefit outweighs risk for this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable OOB read bug in TX path
- Small (7-line), contained, single-file fix
- Buggy code confirmed present in Linux 6.18.44
- Wireless maintainer (Johannes Berg) Signed-off-by
- Similar libertas stability fixes have been backported before
- No new APIs or features
- Triggerable from userspace on affected hardware

**AGAINST backport:**
- Niche hardware (limited user base)
- No syzbot/fuzzer report or user bug report
- Error-path `goto free` after `spin_unlock` is suboptimal (lock state /
  `tx_pending_len` cleanup concern)
- Shallow clone prevented full history of when monitor TX was introduced

**Unresolved:**
- Exact kernel version that introduced monitor TX path (shallow clone)
- Whether mainline adjusted error-path placement post-merge

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — bounds check is
   mathematically correct; maintainer SOB; error-path placement is a
   minor concern but fix logic is sound
2. Fixes a real bug affecting users? **PASS** — OOB read on monitor TX
3. Important issue? **PASS** — memory safety / potential crash (HIGH
   severity when triggered)
4. Small and contained? **PASS** — 7 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to local tree? **PASS** — code exists, clean apply expected

### Step 9.3: Exception Categories
**Record:** None (not a device ID, quirk, DT, build, or docs fix).
Standard memory-safety bug fix.

### Step 9.4: Decision Rationale

This commit fixes a genuine out-of-bounds read in the Libertas driver's
monitor-mode transmit path. The buggy code is present in the local
6.18.44 tree. The fix is minimal, adds only a bounds check with existing
error-handling conventions, and addresses a memory-safety issue
reachable from userspace packet injection on affected hardware. While
the hardware is niche, OOB reads in netdev TX handlers are exactly the
kind of fix stable trees accept. The error-path `goto free` placement
after `spin_unlock` is worth noting for backporters but does not negate
the value of the bounds check itself.

---

## Verification

- [Phase 1] Parsed subject, tags (Hou SOB, Berg SOB, Link); no
  Fixes/Reported-by/syzbot
- [Phase 1] Read commit body: OOB read on short monitor TX frames
- [Phase 2] Diff: +7 lines in `lbs_hard_start_xmit()` monitor branch
- [Phase 2] Read full `tx.c`: confirmed pre-fix code at lines 117–128,
  `goto free`/`unlock` flow at lines 161–166
- [Phase 2] Calculated `sizeof(tx_radiotap_hdr)` = 12 bytes; minimum
  check = 22 bytes
- [Phase 2] Identified `pkt_len` uint16_t underflow risk at line 125/143
  without fix
- [Phase 3] `git rev-parse --is-shallow-repository` → true (limited
  history)
- [Phase 3] `git blame -L 117,128 tx.c` → merge commit only
- [Phase 3] `git log --grep=libertas` → prior stable-style libertas
  fixes found
- [Phase 4] curl lore mbox.gz → original patch fetched, no replies in
  thread
- [Phase 4] WebFetch patch.msgid.link and lore → blocked by bot
  protection; curl succeeded
- [Phase 5] `grep lbs_hard_start_xmit` → callers in `main.c`, `mesh.c`
- [Phase 5] Read `cfg.c` lines 2165–2169 → monitor mode gated on
  `lbs_rtap_supported()`
- [Phase 5] Read `radiotap.h` → `struct tx_radiotap_hdr` layout
  confirmed
- [Phase 6] `git describe HEAD` → v6.18.44; `Makefile` → 6.18.44
- [Phase 6] Read current `tx.c` → buggy code present, fix NOT yet
  applied
- [Phase 6] Read `Kconfig` → `CONFIG_LIBERTAS` dependencies confirmed
- [Phase 8] Assessed trigger: monitor mode + short TX frame from
  userspace
- [Phase 8] Assessed severity: OOB read / potential large memcpy → HIGH
- UNVERIFIED: Exact commit that introduced monitor TX path (shallow
  clone)
- UNVERIFIED: Whether mainline adjusted `goto free` placement after
  initial submission

**YES**

 drivers/net/wireless/marvell/libertas/tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/marvell/libertas/tx.c b/drivers/net/wireless/marvell/libertas/tx.c
index 27304a98787d6..13d08022e4141 100644
--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -117,6 +117,13 @@ netdev_tx_t lbs_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
+		if (skb->len < sizeof(*rtap_hdr) + 4 + ETH_ALEN) {
+			lbs_deb_tx("tx err: short monitor frame %u\n", skb->len);
+			dev->stats.tx_dropped++;
+			dev->stats.tx_errors++;
+			goto free;
+		}
+
 		/* set txpd fields from the radiotap header */
 		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
 
-- 
2.53.0

