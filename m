Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04EE4F55CC;
	Mon, 19 Oct 2026 13:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418329; cv=none; b=tNo/4ysoQ32AQKc7xVLk09pD5r+rDYx5P9AsRgo/dR/IQsH4bL0A7LvILjLjWhTprXsj2Al914v9QiwfGXH5vrqcSSQiViM0QTl05OG8rovFWp4QSOmB1H6s3g/wBNjOHhat4PznlEJIdYsbOwIec1p36XEAzJ1MrMFCgHiSIZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418329; c=relaxed/simple;
	bh=v3TnQfomq5DOdToBm9KN+2GrcuQ3kCaCqNyH1RiERMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmqmolH9F3Y1uAOAtvxUqwgI2axVnxJmwjNYZ+xUHwJ0cv+e5t+fb37pCrL39okkatgthxWbHq5FPnVxpKNB884RNfCHt1oHjUeW4E884w/PCpWgHqscQBzj+t2aThK8ZZ1/PNoySP+gYYXC9tXD2qwKkgnOHzCp2+cPAGwg7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oal7QZTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oal7QZTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75121F000C6;
	Mon, 19 Oct 2026 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418324;
	bh=IDcXYreBZNrwbKXGDCum4ggHLKTGxosx/kv63bkThqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oal7QZTntC/BIDONB6VR4K94tW9qIkzfoFRIAKPpIojcfb0UVuv/GjWRC41ec+jIJ
	 G+ljx4RS/drAoirtfiI74oWfmIXyq18xZWXulaM97mMUVFaPUL5g0EZQIRBxmaCfky
	 joS/6M4D3Fkg6mK4J9pJvkB+9K8RxONyVA39O3b2iYfuAVUKjXSsdGKmbePxi6oHY1
	 0b9U2SU/GCn7vJyYCaeZeeVbCL5as/5tVrhWuWVS1/bne1mpsCsPNVPzn03i8ILvGs
	 1LIhdBfeslmgZStu+DJZ6l0unlYzL2IZ+p2U4kt7+NEAkntWYEh6zFJxSCevuyxioI
	 Mtl3cN0bGQwbA==
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
Subject: [PATCH AUTOSEL 6.18] Bluetooth: bfusb: validate received block boundaries
Date: Mon, 19 Oct 2026 09:47:38 -0400
Message-ID: <20261019135441.1420968-167-sashal@kernel.org>
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

[ Upstream commit 6afadcff79b157a4770c4e987a6005bff40a670b ]

The USB receive path trusts the block header to contain the required
number of bytes and passes it to the reassembly routine. The routine
also trusts a malformed HCI packet type and can append more data than
the skb allocated from the advertised packet length. A malformed USB
transfer can therefore cause out-of-bounds reads or an skb tail
overwrite.

Validate block header availability, declared block size, packet type,
and reassembly tailroom. Drop the partial frame on an invalid block.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`pending-6.18`). The buggy `bfusb`
receive path is present here; the fix is not. This is a real USB OOB /
`skb_over_panic` bug, and the patch applies cleanly.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[Bluetooth/bfusb] [validate] [check USB block headers and
reassembly bounds before trusting them]**

- Subsystem prefix: `Bluetooth: bfusb:`
- Action verb: **validate** (safety check / missing bounds handling)
- Claimed intent: stop treating untrusted USB block headers as valid
  lengths

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record (from the candidate message and from `git show b94bab6f1dd9`):

- `Signed-off-by: Li Qiang <liqiang01@kylinos.cn>` — author
- `Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>` —
  Bluetooth maintainer; applied to bluetooth-next
- No `Fixes:` tag (expected)
- No `Cc: stable@vger.kernel.org` (expected)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:` /
  `Link:`
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  ...]` markers

Notable pattern: maintainer SOB only; no syzbot/user report. The same
driver already had a `Cc: stable` USB-descriptor panic fix
(`b5e6fa7a12572`, division by zero on malicious `wMaxPacketSize`).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:

- **Bug:** USB RX trusts the 2/3-byte block header and HCI packet type.
  Reassembly then copies `len` bytes into an skb sized from the
  advertised HCI length, with no tailroom check.
- **Symptom:** out-of-bounds URB reads and skb tail overwrite
  (`skb_put()` → `skb_over_panic()` → `BUG()`).
- **Version info:** none in the message. Blame shows the logic dates to
  `1da177e4c3f41` (Linux-2.6.12-rc2).
- **Root cause (author):** malformed USB transfer; missing validation of
  header availability, declared size, packet type, and reassembly
  tailroom. Invalid blocks should drop the partial frame.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a hidden/cleanup-only change.** The subject is “validate”,
but the body names OOB reads and skb overwrite. The diff adds bounds
checks, a `default:` reject, and `break` on short/oversize blocks. This
is an explicit memory-safety fix.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:

- File: `drivers/bluetooth/bfusb.c` only
- Scope: **+34 / −3**, single-file surgical fix
- Functions: `bfusb_recv_block()`, `bfusb_rx_complete()`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (before → after), verified against current `bfusb.c` in this
tree:

1. **Unknown HCI packet type (start block):** `switch` has EVENT/ACL/SCO
   only, no `default`. `pkt_len` stays **0**. Code allocates
   `bt_skb_alloc(0)`, then `skb_put_data(..., len)` with the remaining
   block. → **`default:` returns `-EILSEQ`** before alloc.
2. **Reassembly copy:** any continuation (or start payload) is copied
   with `skb_put_data` with no tailroom check. → **if `len >
   skb_tailroom(reassembly)`, free skb, return `-EILSEQ`**.
3. **Block header parse loop:** `while (count)` always does `hdr =
   buf[0] | (buf[1] << 8)` and, unless bit `0x4000`, `buf[2]`. No `count
   >= 2` / `count >= 3` checks. → **short-header checks; drop reassembly
   and `break`**.
4. **`count < len`:** only logs `"block extends over URB buffer
   ranges"`, then still calls `bfusb_recv_block` and does `count -=
   len`. → **free reassembly and `break`**.
5. **Error accounting:** `bfusb_recv_block` return was ignored. → **on
   `< 0`, `data->hdev->stat.err_rx++`**.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **[Memory safety: OOB read + skb overflow panic] [plus infinite
loop in URB complete]**

Verified mechanism in this tree:

```355:376:drivers/bluetooth/bfusb.c
        while (count) {
                hdr = buf[0] | (buf[1] << 8);
                ...
                        len = (buf[2] == 0) ? 256 : buf[2];
                ...
                if (count < len)
                        bt_dev_err(data->hdev, "block extends over URB
buffer ranges");

                if ((hdr & 0xe1) == 0xc1)
                        bfusb_recv_block(data, hdr, buf, len);

                count -= len;
                buf   += len;
        }
```

- `count` is `int urb->actual_length`. If `count < len`, `count -= len`
  goes **negative**. `while (count)` is then true forever → **hard
  lockup in USB completion**.
- `skb_put_data()` calls `skb_put()`, which panics if `skb->tail >
  skb->end`:

```2574:2592:net/core/skbuff.c
 - This function extends the used data area of the buffer. If this would
 - exceed the total buffer size the kernel will panic.
...
        if (unlikely(skb->tail > skb->end))
                skb_over_panic(skb, len, __builtin_return_address(0));
```

`skb_over_panic()` → `skb_panic()` → `BUG()`.

Unknown packet type: `pkt_len` initialized to 0, no `default`, then
`bt_skb_alloc(0)` and `skb_put_data` of the rest of the block → same
panic.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:

- **Quality:** obviously correct. Same pattern as existing
  `skb_tailroom` checks in `btusb.c` / `hci_h4.c`.
- **Minimal:** only RX validation and error accounting; no API/structure
  changes.
- **Regression risk: low.** `default:` cannot reject ISO
  (`HCI_ISODATA_PKT` 0x05) on this 2003-era AVM dongle (VID `0x057c`,
  PID `0x2200`); previously unknown types already panicked. Short-header
  `break` only stops already-corrupt URBs. `kfree_skb(NULL)` is safe if
  `reassembly` is already NULL.
- **Red flags:** labeled `[PATCH 1/5]`, but the other four patches touch
  **different files** (`btmrvl`, `hci_bcsp`, `hci_ldisc`, `hci_qca`).
  This one is standalone.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:

- Core RX loop / `bfusb_recv_block`: `1da177e4c3f41` (Linus, 2005-04-16,
  Linux-2.6.12-rc2)
- Function split/cleanup: `9c724357f432df` (Marcel Holtmann, 2006)
- `skb_put_data`: `59ae1d127ac0ae` (2017) — same overflow semantics as
  old `skb_put`+`memcpy`
- `bt_dev_err` conversion: `2a4f3909d0fbda` (2020)
- Brace removal on the `count < len` log: `461159ece0586` (2025) — style
  only; did **not** add a `break`

Buggy pattern has been in the tree for ~20 years.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No `Fixes:` tag.** Introducer is `1da177e4c3f41`, which **is**
an ancestor of this tree (`git merge-base --is-ancestor 1da177e4c3f41
HEAD` succeeded).

Related unmerged attempt: Seungjin Bae, Oct 2025, “Fix buffer over-read
in rx processing loop” — only the `count < 3` / `buf[2]` case. Not in
this tree. This commit is a superset.

**Step 3.3: CHECK FILE HISTORY**

Record (recent `git log --oneline -20 -- drivers/bluetooth/bfusb.c`):

- `b5e6fa7a12572` — `bfusb: fix division by zero in send path` (`Cc:
  stable`, malicious USB descriptors)
- `461159ece0586` — brace style on the exact `count < len` line
- No existing bounds-check fix for this RX loop

Standalone: yes. Series mates are other drivers.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Li Qiang has **no** other `drivers/bluetooth/` commits on this
branch. Luiz von Dentz is a Bluetooth maintainer (`MAINTAINERS`:
BLUETOOTH DRIVERS / SUBSYSTEM) and applied the patch to bluetooth-next
(commit date Mon Jul 20 2026).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: **None required.** Uses existing `skb_tailroom`, `bt_skb_alloc`,
`bt_dev_err`, `kfree_skb`. `git show b94bab6f1dd9 --
drivers/bluetooth/bfusb.c | git apply --check` → **clean apply**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:

- `b4 dig -c b94bab6f1dd9`: https://patch.msgid.link/1f79f2f12306c15d6f6
  86348bb79d8e6839968d2.1784191283.git.liqiang01@kylinos.cn
- Cover: `[PATCH 0/5] Bluetooth: harden packet and transport parsing`
  (2026-07-16)
- `b4 dig -a`: **v1 only**; applied as submitted
- Applied to bluetooth-next as `b94bab6f1dd9` by Luiz (patchwork-bot,
  2026-07-20)
- Networking pull for **7.3** (Jakub Kicinski, 2026-08-18) — **not** in
  6.18
- No NAK on this patch. Samsung review (`0eec0c0d-636b-...`) is about
  **patch 2/5 `btmrvl`**, not bfusb.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): `linux-bluetooth@vger.kernel.org`, Marcel
Holtmann, Luiz von Dentz, LKML. Maintainer applied it. No extra
Reviewed-by on this hunk.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: no syzbot/bugzilla/`Reported-by`. Independent earlier report:
Seungjin Bae described the `buf[2]` over-read / panic (Oct 2025).
Trigger is a malformed USB bulk IN, not a syscall fuzzer.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 5 independent driver hardenings. Patch 1/5 is self-contained.
Patch 5/5 (`hci_qca`) was **not** applied. No bfusb follow-up found.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org/stable search for this subject did not turn up a
prior stable discussion or a reason to skip it. UNVERIFIED in the sense
that lore.kernel.org itself returned 403; used mirrors + web search
instead.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `bfusb_recv_block()`, `bfusb_rx_complete()`.

**Step 5.2: TRACE CALLERS**

Record:

- `bfusb_recv_block` — only from `bfusb_rx_complete`
- `bfusb_rx_complete` — URB complete from `bfusb_rx_submit()`
  (`usb_fill_bulk_urb(..., bfusb_rx_complete, skb)`)
- `bfusb_rx_submit` — `bfusb_open()` (HCI start) and resubmit in
  `bfusb_rx_complete`

Context: USB completion (atomic/BH). An infinite `while (count)` here is
a **hard lockup**, not a sleepable hang.

**Step 5.3: TRACE CALLEES**

Record: `bt_skb_alloc`, `skb_put_data`/`skb_put`, `hci_recv_frame`,
`kfree_skb`, `usb_submit_urb`. No new callees in the fix (`skb_tailroom`
is an existing inline).

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:

USB plug of `0x057c:0x2200` → `bfusb_probe` → BlueZ opens HCI →
`bfusb_open` → bulk IN URBs → `bfusb_rx_complete`.

Reachable from: a matching (or spoofed) USB device plus HCI running. Not
a random syscall; **local USB attack surface**, same class as the prior
`Cc: stable` bfusb descriptor fix.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: `btusb.c`, `hci_h4.c`, `btmtk.c` already check `skb_tailroom`
before appending. `err_rx++` on parse failure is standard (`btusb`,
`btsdio`, `bpa10x`, …). bfusb was missing both.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `drivers/bluetooth/bfusb.c` still has the unvalidated
loop and no `default:` / tailroom check (lines 245–376). `git describe
HEAD` = `p-6.18-1-g03b85e06ca9bf`; `make kernelversion` = **6.18.53**.
`git merge-base --is-ancestor b94bab6f1dd9 HEAD` → **not in this tree**.
Introduced in 2.6.12-rc2; present for the entire 6.18 lifetime.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** `git apply --check` on the exact commit diff
succeeded. Surrounding code matches the hunks (including
post-`461159ece0586` braceless `if (count < len)`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Seungjin Bae over-read patch is **not** here. No other RX-bounds
fix in this file. The send-path div-by-zero fix **is** here; it does not
cover this RX bug.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: **Bluetooth USB driver (`drivers/bluetooth/bfusb.c`)**.
Criticality: **PERIPHERAL** hardware (AVM BlueFRITZ! USB only), but the
failure is a **kernel panic / lockup** on untrusted USB data. Kconfig:
`BT_HCIBFUSB`, depends on USB. Enabled as `=m` in several defconfigs
(e.g. `omap2plus`, `exynos`, `loongson3`, `pmac32`).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Bluetooth core is active; **bfusb itself is mature/mostly
idle**. Recent file commits are isolated fixes/style. Long-lived bug,
not churn from a new feature.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **driver-specific** — AVM BlueFRITZ! USB (`USB_DEVICE(0x057c,
0x2200)`), plus any system with the module that binds a spoofed VID/PID.
Not universal.

**Step 8.2: TRIGGER CONDITIONS**

Record:

- Requires this driver bound and HCI running (`HCI_RUNNING`).
- Trigger: truncated/malformed bulk IN (device bug, USB fuzzing,
  malicious dongle).
- Not a normal healthy-traffic path.
- Unprivileged userspace cannot hit it without the device; a **USB
  attacker** can.

**Step 8.3: FAILURE MODE SEVERITY**

Record:

- `skb_put` overflow → `skb_over_panic` → **`BUG()` / panic** —
  **CRITICAL**
- `while (count)` with negative `count` → **infinite loop in URB
  complete** — **CRITICAL**
- Short-header `buf[0]/buf[1]/buf[2]` — **OOB read** — **HIGH**

**Step 8.4: RISK-BENEFIT RATIO**

Record:

- **Benefit: high for affected systems** (panic/lockup prevention).
  Population is small, but the same driver already got stable treatment
  for malicious USB descriptors.
- **Risk: very low** — 37-line, single-file, validated by maintainer,
  applies cleanly, error-path only.
- **Ratio: favor backport.**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**

- Real OOB read + `skb` overflow `BUG()` + possible hard lockup,
  verified in this tree’s code
- Bug present since 2.6.12; definitely in 6.18.53
- Small, obviously correct, no new APIs
- Applies cleanly; no prerequisites
- Bluetooth maintainer applied it
- Same driver already had a stable USB-malice panic fix
- Independent of the rest of the 5-patch series

**AGAINST:**

- Niche 2000s dongle; few users
- No syzbot / production `Reported-by`
- Series framed as “harden”
- Patch 2/5 (`btmrvl`) later needed a fix — **does not apply to this
  file**

**UNRESOLVED:**

- Could not fetch lore.kernel.org directly (403); used `b4 dig` +
  mirrors
- No scan of every post-`b94bab6f1dd9` bluetooth-next follow-up (object
  is not on HEAD); no evidence of a bfusb revert/fixup

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — maintainer-applied; logic
   matches existing Bluetooth RX checks
2. Fixes a real bug that affects users? **PASS** — malformed USB RX
   panics/lockups this driver
3. Important issue? **PASS** — kernel `BUG()` / hard lockup / OOB
   (CRITICAL), even though the driver is niche
4. Small and contained? **PASS** — +34/−3, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — `git apply --check`
   succeeded; buggy code present; fix not present

**Step 9.3: EXCEPTION CATEGORIES**

Record: none (not a device ID / quirk / DT / build / doc exception).
Qualifies as a **normal memory-safety bug fix**.

**Step 9.4: DECISION**

Backport to **this** 6.18.53 tree. The receive path here still trusts
USB block lengths; that can panic or lock up the USB completion path.
The fix is surgical and already matches this file.

### What the commit solves for stable users

On AVM BlueFRITZ! USB (or a spoofed `057c:2200`), a short or lying block
header can over-read the URB buffer, `skb_put()` past the reassembled
HCI skb (`BUG()`), or drive `count` negative and spin forever in
`bfusb_rx_complete`. This tree still has that code. The patch only adds
header/size/type/tailroom checks and drops the partial frame.

### Risk vs benefit

Benefit is preventing panic/lockup on untrusted USB RX. Risk is low:
error-path validation, no locking/API change, clean apply. Niche
hardware lowers breadth of impact but does not make a USB-triggered
`BUG()` unsuitable for stable.

---

## Verification

- **[Phase 1]** Parsed subject/body/tags from the candidate text and
  `git show b94bab6f1dd9`; no Fixes/Cc:stable/Reported-by; Luiz SOB
  confirmed
- **[Phase 2]** Read `bfusb_recv_block` / `bfusb_rx_complete` in this
  tree; confirmed missing `default`, no tailroom check, log-only `count
  < len`, signed `count` loop
- **[Phase 2]** Read `skb_put` / `skb_put_data` / `skb_panic`: overflow
  → `BUG()`
- **[Phase 3]** `git blame` on both functions: core logic
  `1da177e4c3f41` (2.6.12-rc2)
- **[Phase 3]** `git merge-base --is-ancestor 1da177e4c3f41 HEAD` —
  introducer in this tree
- **[Phase 3]** `git merge-base --is-ancestor b94bab6f1dd9 HEAD` — fix
  **not** in this tree (exit 1)
- **[Phase 3]** `git log --oneline -20 -- drivers/bluetooth/bfusb.c` —
  no prior RX-bounds fix; `b5e6fa7a12572` is a different (send-path) USB
  panic
- **[Phase 4]** `b4 dig -c b94bab6f1dd9` — lore msgid
  `1f79f2f12306c15d6f686348bb79d8e6839968d2.1784191283`
- **[Phase 4]** `b4 dig -a` — v1 only
- **[Phase 4]** `b4 dig -w` — linux-bluetooth, Holtmann, von Dentz
- **[Phase 4]** Cover letter / patchwork-bot: applied to bluetooth-next
  2026-07-20; networking pull for 7.3
- **[Phase 4]** Samsung mail is about `btmrvl` 2/5, not this patch
- **[Phase 5]** Callers: only URB complete ← `bfusb_rx_submit` ←
  `bfusb_open` / resubmit
- **[Phase 5]** `git grep skb_tailroom` in `drivers/bluetooth` — sibling
  drivers already check
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: 6.18.53;
  `grep` found no “block exceeds packet length” in this tree
- **[Phase 6]** `git apply --check` of `b94bab6f1dd9` — success
- **[Phase 7]** Kconfig `BT_HCIBFUSB`; MAINTAINERS lists Luiz;
  defconfigs enable it as a module
- **[Phase 8]** Failure mode verified: panic (`BUG`) and infinite URB-
  complete loop
- **UNVERIFIED:** direct lore.kernel.org HTTP (403); exhaustive post-
  merge bfusb follow-ups on branches not in HEAD

**YES**

 drivers/bluetooth/bfusb.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
index 8df310983bf6b..d31d797639b51 100644
--- a/drivers/bluetooth/bfusb.c
+++ b/drivers/bluetooth/bfusb.c
@@ -301,6 +301,11 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 				return -EILSEQ;
 			}
 			break;
+
+		default:
+			bt_dev_err(data->hdev, "unknown packet type 0x%02x",
+				   pkt_type);
+			return -EILSEQ;
 		}
 
 		skb = bt_skb_alloc(pkt_len, GFP_ATOMIC);
@@ -319,6 +324,13 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
 		}
 	}
 
+	if (len > skb_tailroom(data->reassembly)) {
+		bt_dev_err(data->hdev, "block exceeds packet length");
+		kfree_skb(data->reassembly);
+		data->reassembly = NULL;
+		return -EILSEQ;
+	}
+
 	if (len > 0)
 		skb_put_data(data->reassembly, buf, len);
 
@@ -353,6 +365,13 @@ static void bfusb_rx_complete(struct urb *urb)
 	skb_put(skb, count);
 
 	while (count) {
+		if (count < 2) {
+			bt_dev_err(data->hdev, "short block header");
+			kfree_skb(data->reassembly);
+			data->reassembly = NULL;
+			break;
+		}
+
 		hdr = buf[0] | (buf[1] << 8);
 
 		if (hdr & 0x4000) {
@@ -360,16 +379,28 @@ static void bfusb_rx_complete(struct urb *urb)
 			count -= 2;
 			buf   += 2;
 		} else {
+			if (count < 3) {
+				bt_dev_err(data->hdev, "short block header");
+				kfree_skb(data->reassembly);
+				data->reassembly = NULL;
+				break;
+			}
+
 			len = (buf[2] == 0) ? 256 : buf[2];
 			count -= 3;
 			buf   += 3;
 		}
 
-		if (count < len)
+		if (count < len) {
 			bt_dev_err(data->hdev, "block extends over URB buffer ranges");
+			kfree_skb(data->reassembly);
+			data->reassembly = NULL;
+			break;
+		}
 
-		if ((hdr & 0xe1) == 0xc1)
-			bfusb_recv_block(data, hdr, buf, len);
+		if ((hdr & 0xe1) == 0xc1 &&
+		    bfusb_recv_block(data, hdr, buf, len) < 0)
+			data->hdev->stat.err_rx++;
 
 		count -= len;
 		buf   += len;
-- 
2.53.0

