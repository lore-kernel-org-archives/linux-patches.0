Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5609A5A874C;
	Mon, 19 Oct 2026 13:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418396; cv=none; b=cKmFoIIYi6b/xlzTVN9ImbYSZR+Ol3UKwffnka1kcL/jKG5kTBVhOSC5GETkDGogWcN3sxaPTcXzPbtMflKXcOBM9NeVCrcoRuZXv2colutKKJlLpbzMWkyT98G64vkeQz50qRe3l21OKI2Wk+FX2uGUWegwKdp3XeS+HhmWMi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418396; c=relaxed/simple;
	bh=IUHvC2eVWuoAKR3ZpmygdGMK18/wVIpi8H0NEynEIg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RskB6tV1zCU43ap5nA+b+wWnV9ppwD0nlP6aMwxie+30TP06p8cAjwWws0w1NxiacAJDb8lW9X6bSTG/duvYkoUHg3nSFcexeGrIUnJUKWToeemucTJnVbuHzWIDBe9ZA/ITBMJyVjd1f7PqkHGsUL4wmy/yNK1loV+P7eItxG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Igd5f8lE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Igd5f8lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F24A1F000C7;
	Mon, 19 Oct 2026 13:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418394;
	bh=63KAFSVioMvmPAu9MJRGj2FZ+H5J2Cg2KBDtQ3FryQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Igd5f8lEIQX7bw8KBMQCBhdf4/QuqUNrX2HEDADmWvp1zd19obyNMdqhvtkq5Zak2
	 Vtc3qJCkSUp/zZRaDqlq0wWNSApwTpnD/LzKO7P51hOfk10QQflL7AffK4CfomP7jc
	 ElQmBsz8rB0hce2InUOSFmCjGV3LJHf+nNJERRpugaEg9dw0VvOw1LW6bdlJJ6M6UR
	 zDDDcvPBHCUVl2BuitDlg/mhJOTMVbLu5T1dv/TiG9RdrkFXAIDgHHRxUcGiy+dJVz
	 vKm71WuugP2XD4MR1BMQQ60le4GULM+S5VgMglMdw5cXa7wI/xP5NsySRANTlR34gW
	 w80Pesm8nyAxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] Bluetooth: hci_bcsp: validate received packet lengths
Date: Mon, 19 Oct 2026 09:48:29 -0400
Message-ID: <20261019135441.1420968-218-sashal@kernel.org>
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit ceea75ad8925425ee6520ead964b55888fe871ec ]

The BCSP transmit path reads an HCI command header when an extension
packet has only been tested for a nonzero length. Its LE configuration
packet handler also indexes bytes through offset seven without a length
check.

Validate the complete command and LE configuration packet headers
before accessing their fields.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.12.111** (`p-6.12-3-g710455e2077bb`). The buggy
BCSP length handling is in this checkout; the candidate is not. The
verdict is for this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[Bluetooth / hci_bcsp] [validate] [check command and LE-config
packet lengths before field access]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Li Qiang <liqiang01@kylinos.cn>` (author)
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>`
  (Bluetooth maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org`
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  markers
- Absence of `Fixes:`/`Cc: stable` is expected for this review and is
  **not** a negative signal

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** BCSP TX reads an HCI command header without a full-header
  length check; LE config RX indexes through offset 7 without a length
  check.
- **Symptom:** Out-of-bounds read of skb/payload bytes on truncated
  packets (cover letter: “out-of-bounds accesses … when data is
  truncated”).
- **Version info:** none in the commit; code dates to git origin (2005).
- **Root cause (author):** fields are used before the complete header is
  known to be present.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is a bounds-check / OOB fix, even
though the series is titled “harden packet and transport parsing.”

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/bluetooth/hci_bcsp.c` only (`+4 / -1`)
- Functions: `bcsp_prepare_pkt()`, `bcsp_handle_le_pkt()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Hunk 1 (`bcsp_prepare_pkt`):** before: if `hciextn && chan == 5`,
  always read `hci_command_hdr.opcode` and `data[HCI_COMMAND_HDR_SIZE]`.
  after: only if `len > HCI_COMMAND_HDR_SIZE` (3). Short commands skip
  vendor-extension rewrite and are slipped as-is.
- **Hunk 2 (`bcsp_handle_le_pkt`):** before: `data[1]`, `data[2]`,
  `memcmp(&data[4], …, 4)` with no `skb->len` check. after: return if
  `rx_skb->len < 8`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Memory safety / out-of-bounds read (category d).**
- TX: `HCI_COMMAND_HDR_SIZE` is 3. Userspace HCI sockets accept `len >=
  4` (1 type byte + 3-byte command). After `skb_pull(1)`, `skb->len` can
  be **exactly 3**. For vendor OGF `0x3f`, the driver then does `*(data
  + 3)` — one byte past `skb->len`.
- If that byte has high nibble `0xc0`, `len -= 4` makes `len == -1`, and
  the BCSP header is built with a bogus length (`hdr[1]/hdr[2]` from a
  signed `-1`).
- RX: `memcmp` of bytes 4–7 with no `len` check. The receive state
  machine normally makes that path in-bounds when the header length
  field is 4; the extra check is defensive.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. Skipping extension parsing on
short packets is the safe default. Early-return on short LE frames does
not drop valid conf/sync packets (those are 4-byte hdr + 4-byte payload
= 8). Regression risk is very low. No API/data-structure change.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy TX/RX logic is from `1da177e4c3f41` (Linux-2.6.12-rc2,
2005), with later style/API churn only (`c5ec514016d1a6`,
`8083ad1cf910dc`, `59ae1d127ac0ae`). Present for the entire life of this
driver, including 6.12.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Recent 6.12 BCSP work includes `b420a4c7f915f` (syzbot NULL
deref in `bcsp_recv`), timer/kfree fixes. No prior length check. This
commit is **standalone** (series 3/5; other patches touch `bfusb.c`,
`btmrvl_main.c`, `hci_ldisc.c`, `hci_qca.c`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Li Qiang has no other `drivers/bluetooth/` commits in this 6.12
tree. Luiz von Dentz is a listed Bluetooth driver maintainer and applied
the series to bluetooth-next (`a4c72c8c7cef`).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `HCI_COMMAND_HDR_SIZE` and `rx_skb->len`. A
surgical patch against this file applied cleanly (`git apply --check`
exit 0).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a4c72c8c7cef` → https://patch.msgid.link/6fb9de3e499424f798
  0a158798ea02b040b73b8f.1784191283.git.liqiang01@kylinos.cn
- Cover: `[PATCH 0/5] Bluetooth: harden packet and transport parsing`
  (2026-07-16)
- `b4 dig -a`: **v1 only** (no v2/v3)
- Applied 2026-07-20 by Luiz to bluetooth-next as `a4c72c8c7cef`
- No NAK on patch 3/5. BlueZ CI failed **patch 5/5** (`hci_qca.c`
  context), not this file.
- Patch 2/5 (`btmrvl`) later caused a Chromebook regression (Marek
  Szyprowski). That is a **different** patch; not this one.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc `linux-bluetooth@vger.kernel.org`, Marcel
Holtmann, Luiz von Dentz, LKML. Maintainer applied it. No extra
Reviewed-by on 3/5.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla report for this specific OOB. Cover letter
describes truncated-header OOB as the failure mode. Trigger
reconstructed from this tree’s `hci_sock_sendmsg` + `bcsp_prepare_pkt`.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series of five independent driver/transport bounds checks. 3/5
does not depend on 1/2/4/5. Do not pull the others as prerequisites.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org WebFetch returned 403. No stable-thread hit via
`b4`/openwall for this subject. UNVERIFIED whether anyone already asked
stable@ for this SHA.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `bcsp_prepare_pkt`, `bcsp_handle_le_pkt`

**Step 5.2: TRACE CALLERS**
Record:
- `bcsp_prepare_pkt`: `bcsp_dequeue()` (unrel, rel, and ACK). Dequeue is
  `hci_uart_proto.dequeue` → `hci_uart_tx_wakeup` / TTY write worker.
- `bcsp_handle_le_pkt`: `bcsp_complete_rx_pkt()` when BCSP channel 1,
  unreliable → `bcsp_recv()` → `hci_uart_tty_receive`. Syzbot has
  already reached `bcsp_recv` via TTY (`TIOCSTI`) in this tree.

**Step 5.3: TRACE CALLEES**
Record: TX reads `hci_opcode_ogf` / raw `data[]`, then `alloc_skb` +
SLIP. RX uses `memcmp`, `alloc_skb`, `skb_queue_head`,
`hci_uart_tx_wakeup`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: TX is reachable from userspace `sendmsg` on an HCI RAW/USER
socket bound to a BCSP UART device. RAW vendor OGF 0x3f needs
`CAP_NET_RAW` (`ogf > HCI_SFLT_MAX_OGF`); USER channel bind needs
`CAP_NET_ADMIN`. Not unprivileged, but a real kernel OOB on a live HCI
UART. RX is reachable from the UART/TTY receive path (including
fuzzing).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same series adds analogous header-length checks in
bfusb/btmrvl/qca. H5 (`hci_h5.c`) does not implement this vendor-
extension rewrite. No duplicate BCSP fix in this tree.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes.
- `drivers/bluetooth/hci_bcsp.c:197` `if (hciextn && chan == 5)` with no
  length check
- `drivers/bluetooth/hci_bcsp.c:405-406` LE handler indexes `data[4]`
  without `len < 8`
- Bug introduced in 2.6.12-era origin; not post-6.12

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** for the actual edits (`git apply --check`
succeeded). Nearby mainline context uses `timer_delete`; 6.12 still has
`del_timer` in `bcsp_pkt_cull`. That is unused context for a tight hunk.
No semantic rework needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `git log --grep='validate received'` on this file: empty. No
earlier equivalent check.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: Bluetooth HCI UART BCSP (`CONFIG_BT_HCIUART_BCSP`) — CSR
BlueCore UART. **IMPORTANT** for those devices, not core mm/VFS. Still a
production protocol path, and this file is actively fuzzed.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Bluetooth in this tree is active (many btusb/btintel/hci_bcsp
stable fixes). BCSP itself is mature; this is an old bug, not a new-
feature fallout.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Config-specific (`BT_HCIUART_BCSP`) + HCI UART BCSP hardware. TX
trigger also needs an HCI socket send of a short vendor command.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- TX: HCI command packet, `hciextn` (default true), `len == 3` after
  type byte, OGF 0x3f. Constructible from userspace with
  `CAP_NET_RAW`/`CAP_NET_ADMIN`.
- RX: truncated LE frame; `memcmp` path is likely already in-bounds if
  the state machine honors the header length field.
- Not a hot every-packet path for well-formed kernel-generated commands
  (`hci_cmd_sync_alloc` always includes the 3-byte header).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: One-byte (or more, if `data` is short) read past `skb->len` on
TX; possible wrong BCSP channel/length if the spilled byte looks like an
HCI extension. May stay inside skb tailroom (not always a KASAN crash).
**Severity: HIGH** (memory safety / OOB), not a guaranteed panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit medium-high (closes a long-standing OOB in a fuzzed UART
protocol). Risk very low (4 lines, skip-on-short-packet). Ratio favors
backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real OOB read in `bcsp_prepare_pkt` when a 3-byte vendor HCI command
  is sent on BCSP
- RX handler indexes through byte 7 with no length guard
- 4 insertions / 1 deletion, obviously correct
- Code present in this 6.12 tree since origin
- No prerequisites; applies here
- Bluetooth maintainer applied it to bluetooth-next
- Same class as other packet-length checks already landing in this tree

AGAINST:
- No syzbot/user crash report for this exact bug
- TX trigger is privileged
- RX `len < 8` check is likely redundant given the BCSP RX state machine
- Sister patch 2/5 in the same series had a regression (different
  driver)
- Framed as “hardening”

UNRESOLVED:
- lore.kernel.org WebFetch 403; no confirmed stable@ discussion
- Whether skb tailroom would make the 1-byte TX OOB a KASAN hit on this
  kernel’s allocator

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — maintainer-applied; logic is
   local and readable
2. Fixes a real bug that affects users? **PASS** — OOB on truncated
   vendor commands over BCSP UART
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   OOB / memory-safety (HIGH, not proven panic)
4. Small and contained? **PASS** — one file, five lines
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — buggy code present; surgical
   apply succeeded

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/docs exception. Ordinary small memory-
safety fix.

**Step 9.4: MAKE YOUR DECISION**
This belongs on 6.12. The TX length check closes a real out-of-bounds
field access on a path that HCI sockets can hit; the RX check is cheap
and harmless. Scope, risk, and local applicability all fit stable rules.

===============================================================
Verification
===============================================================
- [Phase 1] Parsed subject/body/tags: author Li Qiang, SOB Luiz von
  Dentz; no Fixes/syzbot/Cc-stable
- [Phase 2] Diff: `hci_bcsp.c` +4/-1 in `bcsp_prepare_pkt` and
  `bcsp_handle_le_pkt`
- [Phase 2] `HCI_COMMAND_HDR_SIZE` is 3 in `include/net/bluetooth/hci.h`
- [Phase 2] `hciextn` defaults to true (`module_param`)
- [Phase 3] `git blame`: lines from `1da177e4c3f41` (2.6.12-rc2)
- [Phase 3] `git merge-base --is-ancestor a4c72c8c7cef HEAD` → not in
  this tree (exit 1); object exists as a commit
- [Phase 3] `git log --grep='validate received' --
  drivers/bluetooth/hci_bcsp.c` → empty
- [Phase 4] `b4 dig -c a4c72c8c7cef`: lore msgid 6fb9de3e…; v1-only
  series; applied to bluetooth-next
- [Phase 4] `b4 dig -w`: linux-bluetooth, Holtmann, von Dentz
- [Phase 4] mbox: no NAK on 3/5; CI fail was qca 5/5; btmrvl 2/5 later
  regressed Chromebooks
- [Phase 4] UNVERIFIED: stable@ mailing list (lore WebFetch 403)
- [Phase 5] Callers: `bcsp_dequeue` → UART TX; `bcsp_complete_rx_pkt` →
  `bcsp_recv`
- [Phase 5] `hci_sock_sendmsg`: `len < 4` rejected; after type pull,
  `skb->len` can be 3; OGF 0x3f on RAW needs `CAP_NET_RAW`
- [Phase 6] `git describe HEAD` / Makefile: 6.12.111; buggy `if (hciextn
  && chan == 5)` still present
- [Phase 6] `git apply --check` of the two hunks: success
- [Phase 8] Failure mode: OOB read past `skb->len` on TX vendor-
  extension parse; severity HIGH
- UNVERIFIED: whether this 1-byte read is always inside skb tailroom vs
  KASAN-poisoned

The TX path can read past a 3-byte HCI command; the fix is four lines
and applies to this 6.12 tree without extra commits.

**YES**

 drivers/bluetooth/hci_bcsp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 591abe6d63ddb..6461492cf653b 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -194,7 +194,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 		return NULL;
 	}
 
-	if (hciextn && chan == 5) {
+	if (hciextn && chan == 5 && len > HCI_COMMAND_HDR_SIZE) {
 		__le16 opcode = ((struct hci_command_hdr *)data)->opcode;
 
 		/* Vendor specific commands */
@@ -402,6 +402,9 @@ static void bcsp_handle_le_pkt(struct hci_uart *hu)
 	u8 sync_pkt[4]     = { 0xda, 0xdc, 0xed, 0xed };
 
 	/* spot "conf" pkts and reply with a "conf rsp" pkt */
+	if (bcsp->rx_skb->len < 8)
+		return;
+
 	if (bcsp->rx_skb->data[1] >> 4 == 4 && bcsp->rx_skb->data[2] == 0 &&
 	    !memcmp(&bcsp->rx_skb->data[4], conf_pkt, 4)) {
 		struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
-- 
2.53.0

