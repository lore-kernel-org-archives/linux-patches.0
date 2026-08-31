Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE874252AB;
	Mon, 31 Aug 2026 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184108; cv=none; b=beu/xrNUJJScLdc63rKt4SPOL3UECM0YnH4vYmQltJ7dWJN1UiRE31a79vJN9SqApNFNFN3O19Oen42aLCrHcbHzl2RrIZOwngq308lAubqGVaOTYx8Nr6LybFN4flRMTQw8tMJ9btU2StHsj093AjqWP4g/7jGym0DFfdynKRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184108; c=relaxed/simple;
	bh=HJ5f5hvqDl6EwVDXwY0FTveBmih9YmtAT4PC4dOx/Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhWTeD2avpkj/DleEXSB+xMkq0hplU2vvNAxqRDga2um2IUF+Eb2+OChhdPjl6fyGkRsW1jUAQ/B4LDX19YGs4no9kxojIprLVPgmYJWT+msb5q8+VUWsPO+npN8x/OsQvXDNrviloIRrs3QHOIUwPt5G0A7CFBOf/64Jbw7qHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXZvhnpB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXZvhnpB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589711F00A3F;
	Mon, 31 Aug 2026 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184106;
	bh=PakesP/6ouAxBo8uYPsTCDb+PxbcxZLnYhsPuDH6hoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXZvhnpBQy/abusCnQRQTRcX4JpNf42d7mZor9YYz8HVojF0X+SFCMYu1ZfkZzBUn
	 9AOpbjSdg3wLRG+/WNWVSehGLtWLJpVMLqkX/5UBAo8+ykWYZgteTnjSeylxRIowJX
	 pabQFXiKl5esAuWMOvxVhhfimcXLmt/AYmHR0HnZwgX7SswFeUUW8z/9Sd0SUtO94Y
	 C3nNzLV2Z5uKSOTuGT6IlIbumNlRxSavh5EF9kuXQUf/3hELedGCiOVV+LHt+XZPcX
	 iqil1nYrqbfLEwmMKkmbFnb0+tvWjurHqYeVh0rhBGNCX1g/ET/HqtqCsfa7vDVJIs
	 UAZZi4x1hWHOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] wifi: rsi: validate beacon length before fixed buffer copy
Date: Mon, 31 Aug 2026 09:28:42 -0400
Message-ID: <20260831133314.4125787-494-sashal@kernel.org>
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

[ Upstream commit 8ecdeb8b8a33b22c597299043c0dcfce50beb9ea ]

rsi_prepare_beacon() copies the mac80211 beacon frame after
FRAME_DESC_SZ into a management skb whose usable tailroom may be smaller
than MAX_MGMT_PKT_SIZE after alignment.

Validate the beacon length against the actual tailroom before the copy
and skb_put(). Leave ownership of the management skb with the caller on
error, matching the existing rsi_send_beacon() cleanup path.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260705084824.68105-1-pengpeng@iscas.ac.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[wifi: rsi]` `[validate]` — validate beacon length before
copying into a fixed-size management skb buffer.

### Step 1.2: Tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by:** — absent
- **Acked-by:** — absent
- **Link:**
  `https://patch.msgid.link/20260705084824.68105-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** — absent
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author);
  Johannes Berg `<johannes.berg@intel.com>` (wireless maintainer merge
  sign-off)

Notable: CC to Kees Cook on the mailing list submission (security
maintainer). No syzbot Reported-by tag.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** `rsi_prepare_beacon()` copies the mac80211 beacon after
  `FRAME_DESC_SZ` (16 bytes) into an skb allocated for
  `MAX_MGMT_PKT_SIZE` (512), but usable tailroom can be smaller after
  dword alignment `skb_pull()` in the caller.
- **Symptom:** Unchecked `memcpy()` + `skb_put()` can write past skb
  buffer end → heap buffer overflow.
- **Version info:** None in commit message.
- **Root cause:** Caller reduces effective buffer space for alignment;
  callee assumes full `MAX_MGMT_PKT_SIZE` is available.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly a bounds-validation fix before
`memcpy()`. Classic buffer-overflow prevention.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wireless/rsi/rsi_91x_hal.c` (+8 / -0)
- **Functions:** `rsi_prepare_beacon()`
- **Scope:** Single-file, surgical fix in one function

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (variable):** Adds `unsigned int tailroom`.
- **Hunk 2 (validation):** Before `memcpy()`:
  - **Before:** Unconditionally copies `mac_bcn->len` bytes and extends
    skb.
  - **After:** Checks `skb_tailroom(skb) >= FRAME_DESC_SZ` and
    `mac_bcn->len <= tailroom - FRAME_DESC_SZ`; on failure frees
    `mac_bcn`, returns `-EMSGSIZE`, leaves caller-owned `skb` untouched.
- **Path affected:** AP/P2P-GO beacon preparation error path (new) and
  success path (unchanged).

### Step 2.3: Bug Mechanism
**Record:** **Category:** Buffer overflow / out-of-bounds write (memory
safety).

**Mechanism:**
1. `rsi_send_beacon()` allocates `dev_alloc_skb(MAX_MGMT_PKT_SIZE)` (512
   bytes).
2. For 64-byte alignment, it may `skb_pull(skb, 64 - dword_align_bytes)`
   — up to 63 bytes, reducing tailroom to as little as ~449 bytes.
3. `rsi_prepare_beacon()` then does `memcpy(&skb->data[FRAME_DESC_SZ],
   mac_bcn->data, mac_bcn->len)` without checking fit.
4. Worst case: safe beacon payload without fix ≈ **433 bytes** (`512 -
   63 - 16`). Beacons with many IEs (HT/VHT/HE, WPS, vendor IEs) can
   exceed this.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — uses `skb_tailroom()` against actual
  post-alignment space, not the nominal `MAX_MGMT_PKT_SIZE`.
- **Minimal:** 8 lines, no unrelated changes.
- **Error handling:** Correctly frees `mac_bcn` only; caller
  `rsi_send_beacon()` already frees `skb` on any `rsi_prepare_beacon()`
  failure.
- **Regression risk:** Very low. On oversize beacon, AP beacon TX fails
  gracefully instead of corrupting memory.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Lines 483–484 (`memcpy`/`skb_put`) blamed to `5d324e5159d9e`
(Merge tag 'usb-6.18-rc8', 2025-11-28). Local history for this file is
shallow (only 1 commit in `git log --
drivers/net/wireless/rsi/rsi_91x_hal.c`). Exact commit that introduced
the alignment+memcpy pattern is **UNVERIFIED** beyond presence in this
6.18.y tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Shallow history in this checkout. Related mainline commit
`d06a3e60c8fea` ("wifi: rsi: bound background scan probe request copy")
exists in repo but is **not** an ancestor of HEAD — separate bounds-
check fix, not a prerequisite for this patch.

### Step 3.4: Author Context
**Record:** Pengpeng Hou submitted security-oriented bounds checks for
the RSI driver. Johannes Berg (wireless maintainer) merged. Author
relationship to subsystem: contributor doing targeted hardening.

### Step 3.5: Dependencies
**Record:** Standalone. No patch series markers. No new structures/APIs.
Applies cleanly to current `rsi_91x_hal.c` in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- `b4 dig` failed in this environment.
- Openwall archive: https://lists.openwall.net/linux-
  kernel/2026/07/05/209
- Patchew:
  https://patchew.org/linux/20260705084824.68105-1-pengpeng@iscas.ac.cn/
- lore.kernel.org blocked by bot protection.
- **Series revisions:** v1 only (Syzbot CI confirms Version 1).
- **Reviewer feedback:** No replies/NAKs found in accessible archives.
- **Stable nomination:** None found.

### Step 4.2: Reviewers
**Record:** CC'd to `kees@kernel.org`, `linux-wireless@vger.kernel.org`,
`linux-kernel@vger.kernel.org`. Merged with Signed-off-by from Johannes
Berg.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot crash report. Syzbot CI
tested the patch series and reported "All tests passed" — validation
testing, not a fuzzer-found crash report.

### Step 4.4: Related Patches
**Record:** Same author has a related RSI bounds-check patch for
background scan probe requests on mainline; independent of this fix.

### Step 4.5: Stable List History
**Record:** No stable-list discussion found (UNVERIFIED beyond search
results).

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `rsi_prepare_beacon()` (modified); callers:
`rsi_send_beacon()` only.

### Step 5.2: Callers
**Record:**
- `rsi_send_beacon()` → `rsi_prepare_beacon()` (`rsi_91x_mgmt.c:1777`)
- `rsi_send_beacon()` called from `BEACON_EVENT_IND` case
  (`rsi_91x_mgmt.c:2225`) when AP beaconing is enabled and FSM is in
  `FSM_MAC_INIT_DONE`

### Step 5.3: Callees
**Record:** `ieee80211_beacon_get_tim()`, `dev_kfree_skb()`, `memcpy()`,
`skb_put()`, `skb_tailroom()` (added).

### Step 5.4: Reachability
**Record:**
- Triggered by firmware beacon events on RSI hardware in AP/P2P-GO mode.
- Beacon content comes from mac80211 (host configuration — SSID, IEs,
  security, etc.).
- Not directly a syscall path, but reachable from normal AP operation
  with legitimately large beacon frames.
- Unprivileged users on the AP host can influence beacon size via
  network configuration.

### Step 5.5: Similar Patterns
**Record:** Same driver already bounds-checks management frames
elsewhere (`rsi_91x_hal.c:71` drops pkts `> MAX_MGMT_PKT_SIZE`; `:82-86`
checks headroom). The beacon path was missing the equivalent tailroom
check after alignment — inconsistent and buggy.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree is **v6.18.44** (`VERSION=6,
PATCHLEVEL=18, SUBLEVEL=44`). `rsi_prepare_beacon()` at lines 483–484
performs unchecked `memcpy()`/`skb_put()`. Mainline fix commit
`8ecdeb8b8a33b` exists in object DB but is **NOT** an ancestor of HEAD —
fix not yet in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Target code matches the patch
base. No conflicting changes in this function. Single hunk insertion.

### Step 6.3: Related Fixes Already Present?
**Record:** No `skb_tailroom` or `-EMSGSIZE` usage in RSI driver. No
duplicate fix found.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/net/wireless/rsi/` — Redpine Signals 91x WLAN
driver (`CONFIG_RSI_91X`). **Criticality: PERIPHERAL** (hardware-
specific), but memory-safety bug class is kernel-wide in severity.

### Step 7.2: Activity
**Record:** Driver present and functional in 6.18.y. Recent mainline
hardening activity from same author suggests active security review of
this driver.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with RSI 91x hardware (USB/SDIO modules) running AP or
P2P-GO mode. Config-dependent on `CONFIG_RSI_91X` and bus variants.

### Step 8.2: Trigger Conditions
**Record:**
- AP mode with beacon enabled.
- Firmware sends `BEACON_EVENT_IND`.
- Beacon frame + 16-byte descriptor exceeds post-alignment tailroom.
- Alignment pull is address-dependent (up to 63 bytes); not every
  allocation hits worst case, but it will occur in practice.
- **Unprivileged trigger:** Indirectly yes — AP operator can configure
  beacon IEs that push frame size over the safe threshold.

### Step 8.3: Failure Mode Severity
**Record:** **Heap buffer overflow** past skb allocation → memory
corruption, kernel oops/panic, potential security impact. **Severity:
HIGH** (could be CRITICAL depending on exploitability; at minimum causes
crashes/data corruption).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Prevents real memory corruption on AP beacon TX path for
  RSI hardware users.
- **Risk:** Very low — 8-line bounds check on error path only.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verifiable buffer overflow in kernel code
- Small, obviously correct fix (+8 lines, 1 file)
- Bug exists in v6.18.44 tree; fix not yet merged
- Merged by wireless maintainer; CC'd to security maintainer
- Consistent with existing bounds-check patterns in same driver
- Graceful failure path already exists in caller

**AGAINST backport:**
- Affects niche hardware (RSI 91x) only
- Requires AP mode with sufficiently large beacons
- No user crash reports or syzbot-found reproducer
- On failure, AP beacon TX stops (functional degradation vs. crash) —
  still far better than overflow

**UNRESOLVED:**
- Exact commit that introduced the alignment-without-bounds-check
  pattern (shallow history)
- Whether reviewers explicitly nominated for stable (no discussion
  found)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — logic is straightforward;
   Syzbot CI passed on patch.
2. Fixes a real bug affecting users? **PASS** — buffer overflow on AP
   beacon path.
3. Important issue? **PASS** — memory corruption / potential crash or
   security issue.
4. Small and contained? **PASS** — 8 lines, 1 file, 1 function.
5. No new features or APIs? **PASS** — defensive bounds check only.
6. Can apply to local tree? **PASS** — buggy code present, fix absent,
   clean apply.

### Step 9.3: Exception Categories
**Record:** None of the automatic exception categories (device ID,
quirk, DT, build fix, docs). This is a straight memory-safety bug fix.

### Step 9.4: Decision Rationale

For **v6.18.44**, the buggy code is present: `rsi_send_beacon()` reduces
skb tailroom via alignment `skb_pull()`, then `rsi_prepare_beacon()`
blindly copies the full mac80211 beacon. With beacons larger than ~433
bytes (common for feature-rich APs), this overflows the 512-byte skb.
The fix validates against actual `skb_tailroom()` before `memcpy()`,
matching the driver's existing defensive patterns. The patch is minimal,
self-contained, and prevents kernel memory corruption — exactly the kind
of fix stable trees should carry.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user-provided diff
  and `git show 8ecdeb8b8a33b`
- **[Phase 1]** Openwall list: CC to Kees Cook confirmed at
  https://lists.openwall.net/linux-kernel/2026/07/05/209
- **[Phase 2]** Read `rsi_prepare_beacon()` and `rsi_send_beacon()` in
  local tree
- **[Phase 2]** Confirmed `FRAME_DESC_SZ=16`, `MAX_MGMT_PKT_SIZE=512` in
  `rsi_main.h` / `rsi_mgmt.h`
- **[Phase 2]** Calculated worst-case safe beacon size: 433 bytes (512 -
  63 - 16)
- **[Phase 3]** `git blame -L 483,484`: lines from 5d324e5159d9e
- **[Phase 3]** `git log -- drivers/net/wireless/rsi/rsi_91x_hal.c`:
  only 1 commit (shallow)
- **[Phase 3]** `git merge-base --is-ancestor 8ecdeb8b8a33b HEAD`: fix
  NOT in current branch
- **[Phase 4]** `b4 dig`: failed
- **[Phase 4]** Openwall/Patchew/Syzbot CI: patch found, v1 only, CI
  passed
- **[Phase 4]** lore.kernel.org: blocked by bot protection
- **[Phase 5]** `grep rsi_prepare_beacon`: single caller
  `rsi_send_beacon()`
- **[Phase 5]** Traced `BEACON_EVENT_IND` → `rsi_send_beacon()` call
  chain
- **[Phase 6]** `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- **[Phase 6]** Confirmed unchecked `memcpy` at lines 483–484 without
  tailroom validation
- **[Phase 6]** `grep skb_tailroom/EMSGSIZE` in rsi/: no matches (fix
  absent)
- **[Phase 7]** Read `drivers/net/wireless/rsi/Kconfig`: RSI 91x driver
  config exists
- **[Phase 8]** Assessed failure mode as heap buffer overflow, severity
  HIGH
- **UNVERIFIED:** Exact introduction commit of buggy alignment logic
  (shallow file history)
- **UNVERIFIED:** Reviewer stable nominations (no accessible thread
  replies)

**YES**The background checks finished and match the earlier analysis:

- **Fix commit `8ecdeb8b8a33b`** is in the repo but is **not** on the
  current branch (`v6.18.44`) — the buggy `memcpy()` path is still
  present.
- The patch should apply cleanly; no further investigation is needed.

**Verdict for this tree: YES** — backport the beacon tailroom validation
fix.

 drivers/net/wireless/rsi/rsi_91x_hal.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 7d26314a3e76a..50f77f3eee92c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -431,6 +431,7 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	struct ieee80211_vif *vif;
 	struct sk_buff *mac_bcn;
 	u8 vap_id = 0, i;
+	unsigned int tailroom;
 	u16 tim_offset = 0;
 
 	for (i = 0; i < RSI_MAX_VIFS; i++) {
@@ -480,6 +481,13 @@ int rsi_prepare_beacon(struct rsi_common *common, struct sk_buff *skb)
 	if (mac_bcn->data[tim_offset + 2] == 0)
 		bcn_frm->frame_info |= cpu_to_le16(RSI_DATA_DESC_DTIM_BEACON);
 
+	tailroom = skb_tailroom(skb);
+	if (tailroom < FRAME_DESC_SZ ||
+	    mac_bcn->len > tailroom - FRAME_DESC_SZ) {
+		dev_kfree_skb(mac_bcn);
+		return -EMSGSIZE;
+	}
+
 	memcpy(&skb->data[FRAME_DESC_SZ], mac_bcn->data, mac_bcn->len);
 	skb_put(skb, mac_bcn->len + FRAME_DESC_SZ);
 
-- 
2.53.0

