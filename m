Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A5A522EC5;
	Mon, 31 Aug 2026 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183856; cv=none; b=twX2vAK8w9PtnzvGNfiFXEv5B+uu4SXwgEvgNDVCwph7YR0PnHGjqm8QPVAzMZ7gqwu9veAShQdgoWF2nmvC0pB5m1+2EIfVbKlfwx7Faqe1sT5Oshg8J3JMRCYKqvg5H5CCWgLo2/uIXkZqEf37RILvlWXEbJEsfH1hthRTJ4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183856; c=relaxed/simple;
	bh=YzomyiaSSYlSEVqtsSwnQ1VSK21Q6sA+HUUrTBdFNvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FmgKCBBgrKGE8S8abDY00x+OZY1zvuGfPi1JMCT9K+JdaWRwsp5razy7UugVJqfXfg2/ggjSwn3AUAJPhMCPvY7pWZ05+g//BqPriDPLd1PHo5sOW9iqDMz8zhaU1XylKtkodcrey64HsDjIGpicO5pJnmd9/0dnZ20pfOFqm6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GGrsBYIC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GGrsBYIC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC601F000E9;
	Mon, 31 Aug 2026 13:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183853;
	bh=gey/pA+MqLSign78ltl1Z+G5U1XGzfWV9TBfTmZofj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GGrsBYICdmnzHpkk8pJtbeu44an+jR8Ikh6BsEZxLJGuT/MDHDiBD+woyHCTrb7hA
	 slW6LSry5tFgl84XeZG9vbfMT1IUacGNyCUs7TxpLl6AqSdNWJdCeZK+b4QvJvt2wo
	 BUVTzANrACxhP4IvMx10MzeZ3918WMd9p900CeXPngHE56tpAg6oU+MBBiZLvI6/Oj
	 GM2JhSFL4SYLBIB0JbLu6LCrvmbi+t0ebfixcItvQpmDA8vsBzTQIFJwWUNSbXT3lx
	 zApQkqjM3rdL9BYlZbaROjYG0i5upuZIAOtivjAKH5zI31lpR2IKNzQHEAuF9LNm3x
	 IYwAGM0D+H3NQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Michal Pecio <michal.pecio@gmail.com>,
	Mathias Nyman <mathias.nyman@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	mathias.nyman@intel.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] usb: xhci: Improve Soft Retries after short transfers
Date: Mon, 31 Aug 2026 09:26:11 -0400
Message-ID: <20260831133314.4125787-343-sashal@kernel.org>
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

From: Michal Pecio <michal.pecio@gmail.com>

[ Upstream commit e765ab012f73717238c95ab9c34bfc3c767fa48c ]

A short transfer is a successful one, so reset the error count.
Otherwise, endpoints which always complete short are limited to
three retries per endpoint life rather than per URB.

Signed-off-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://patch.msgid.link/20260603091132.1110849-7-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 – Subject line**

Record: `[usb: xhci]` `[Improve]` – Improve soft-retry error counting
after short bulk/interrupt transfers.

**Step 1.2 – Tags**

Record:
- `Signed-off-by: Michal Pecio <michal.pecio@gmail.com>` (author)
- `Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>` (xHCI
  maintainer)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer)
- `Link: https://patch.msgid.link/20260603091132.1110849-7-
  mathias.nyman@linux.intel.com` (patch 7/7 in a series)
- No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or `Reviewed-
  by:` tags

**Step 1.3 – Body analysis**

Record:
- **Bug:** `ep->err_count` is not cleared on `COMP_SHORT_PACKET`, even
  though a short transfer is a successful completion.
- **Symptom:** Endpoints that routinely complete short are limited to
  three soft retries over the endpoint’s lifetime, not per URB/transfer.
- **Root cause:** `err_count` is reset on `COMP_SUCCESS` but not on
  `COMP_SHORT_PACKET`, so successful short transfers do not reset the
  counter.
- **Version info:** None in the message.

**Step 1.4 – Hidden bug fix?**

Record: **Yes.** Although the subject says “Improve,” this is a
correctness bug in xHCI soft-retry error accounting, not a cosmetic
cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 – Inventory**

Record:
- **Files:** `drivers/usb/host/xhci-ring.c` (+1 line)
- **Function:** `process_bulk_intr_td()`
- **Scope:** Single-file, one-line surgical fix

**Step 2.2 – Code flow change**

Record:
- **Before:** `COMP_SHORT_PACKET` sets `td->status = 0` only;
  `ep->err_count` is unchanged.
- **After:** `COMP_SHORT_PACKET` also sets `ep->err_count = 0`, matching
  `COMP_SUCCESS`.
- **Path:** Bulk/interrupt transfer completion in
  `process_bulk_intr_td()`, called from `handle_tx_event()` for non-
  control, non-isoc endpoints.

**Step 2.3 – Bug mechanism**

Record: **Logic / error-recovery bug.** `MAX_SOFT_RETRY` is 3. On
`COMP_USB_TRANSACTION_ERROR`, `ep->err_count` is incremented; if it
exceeds 3, soft retry is skipped and the error path proceeds without
`xhci_handle_halted_endpoint(..., EP_SOFT_RESET)`. Successful
completions should reset the counter, but short completions did not.

**Step 2.4 – Fix quality**

Record:
- **Obviously correct:** Short packet is a successful transfer
  (`td->status = 0`); resetting `err_count` matches `COMP_SUCCESS` and
  the design intent.
- **Minimal:** One line.
- **Regression risk:** Very low; only resets a counter on a success
  path.

---

## Phase 3: Git History Investigation

**Step 3.1 – Blame**

Record:
- Soft retry introduced in `f8f80be501aa2` (2018): `ep_ring->err_count =
  0` on `COMP_SUCCESS`.
- `err_count` moved to endpoint in `a1575120972ec` (Nov 2022, backported
  with `Cc: stable`).
- `COMP_SHORT_PACKET` handling dates to 2017; never reset `err_count`.
- Bug present since soft-retry accounting was added (~2018).

**Step 3.2 – Fixes: tag**

Record: N/A – no `Fixes:` tag.

**Step 3.3 – Related file history**

Record:
- Related short-packet work by Michal Pecio: `9e3a28793d2fd` (“Fix Short
  Packet handling rework ignoring errors”), affecting UAC, UVC, serial,
  UAS.
- This fix is standalone; no dependency on other series patches for
  correctness.

**Step 3.4 – Author context**

Record: Michal Pecio is an active xHCI contributor; Mathias Nyman is the
xHCI maintainer. Both signed off.

**Step 3.5 – Dependencies**

Record: **Standalone.** One-line addition; no new symbols or structures.
Patch 7/7 in submission, but this hunk is self-contained.

---

## Phase 4: Mailing List and External Research

**Step 4.1 – Original discussion**

Record: Link points to patch 7/7 in a Mathias Nyman series (2026-06-03).
`b4 dig` did not find the committed hash (commit not in this tree).
`patch.msgid.link` and `lore.kernel.org` were blocked (403/Anubis).
Discussion content could not be fetched.

**Step 4.2 – Reviewers**

Record: UNVERIFIED from lore. Commit has SOBs from author, xHCI
maintainer, and USB maintainer.

**Step 4.3 – Bug report**

Record: No external bug report or syzbot link. Bug inferred from code
analysis and commit message.

**Step 4.4 – Series context**

Record: Patch 7/7; this change does not appear to require earlier series
patches.

**Step 4.5 – Stable list**

Record: UNVERIFIED – could not search lore stable archives due to access
restrictions.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 – Key functions**

Record: `process_bulk_intr_td()`, caller `handle_tx_event()`.

**Step 5.2 – Callers**

Record: `handle_tx_event()` is the main xHCI transfer-event handler,
invoked from the xhci interrupt path for every bulk/interrupt transfer
completion. High-traffic, common path.

**Step 5.3 – Callees**

Record: On transaction error with `err_count <= MAX_SOFT_RETRY`, calls
`xhci_handle_halted_endpoint(..., EP_SOFT_RESET)`. When limit exceeded,
soft retry is skipped and `finish_td()` runs with `-EPROTO`.

**Step 5.4 – Reachability**

Record: **Highly reachable.** Any bulk/interrupt endpoint can hit this.
Critically, in `handle_tx_event()`:

```2707:2712:drivers/usb/host/xhci-ring.c
        case COMP_SUCCESS:
                if (EVENT_TRB_LEN(le32_to_cpu(event->transfer_len)) !=
0) {
                        trb_comp_code = COMP_SHORT_PACKET;
                        xhci_dbg(xhci, "Successful completion on short
TX for slot %u ep %u with last td comp code %d\n",
                                 slot_id, ep_index,
ep_ring->old_trb_comp_code);
                }
```

Short transfers reported as `COMP_SUCCESS` are converted to
`COMP_SHORT_PACKET` before `process_bulk_intr_td()` runs. So the
`COMP_SUCCESS` `err_count` reset does **not** apply to short transfers
on typical hosts; they go through `COMP_SHORT_PACKET` without resetting
the counter.

**Step 5.5 – Similar patterns**

Record: `ep->err_count = 0` exists only on `COMP_SUCCESS` in
`process_bulk_intr_td()`. `handle_transferless_tx_event()` increments
`err_count` on stream transaction errors but never resets it on success.
This fix addresses the bulk/intr path only.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 – Buggy code in this tree?**

Record: **Yes.** Local tree is **v6.18.44** (`git describe HEAD`, `make
kernelversion`). At lines 2572–2574, `COMP_SHORT_PACKET` does not reset
`ep->err_count`. The candidate commit is not yet applied.

**Step 6.2 – Backport complications**

Record: **Clean apply expected** – single line in a stable function with
no recent churn at that hunk.

**Step 6.3 – Related fixes already present?**

Record: `git log --grep='Soft Retries'` returned nothing. No equivalent
fix in this tree.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 – Subsystem**

Record: `drivers/usb/host/` – USB xHCI host controller driver.
**Criticality: IMPORTANT** (core USB path for most modern systems).

**Step 7.2 – Activity**

Record: Active subsystem; recent xhci fixes include HCE interrupt storm,
memory leaks, and short-packet handling.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 – Who is affected**

Record: Users of xHCI with bulk/interrupt endpoints that complete short
(serial, UVC, UAC, storage status pipes, interrupt IN with fixed
buffers). Essentially all xHCI users with typical USB devices.

**Step 8.2 – Trigger conditions**

Record:
- Endpoint sees successful short transfers (very common).
- Plus occasional `COMP_USB_TRANSACTION_ERROR` (transient bus errors).
- After 3 such errors, `err_count` stays elevated because short
  successes never reset it.
- **Likelihood:** Moderate for long-lived endpoints with occasional bus
  noise.

**Step 8.3 – Failure mode severity**

Record:
- Soft retry stops after 3 transaction errors over endpoint lifetime.
- Subsequent errors skip `EP_SOFT_RESET` and proceed to error completion
  / harder recovery.
- **Severity: MEDIUM-HIGH** – device malfunction, transfer failures,
  possible disconnect; not a kernel oops, but real user-visible USB
  breakage.

**Step 8.4 – Risk vs benefit**

Record:
- **Benefit:** HIGH for affected endpoints – restores intended per-
  transfer error accounting.
- **Risk:** VERY LOW – one line, mirrors existing `COMP_SUCCESS`
  behavior.
- **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

**Step 9.1 – Evidence**

**FOR:**
- Real, long-standing logic bug in soft-retry accounting
- Affects a very common path (short bulk/interrupt transfers)
- `handle_tx_event()` converts success-with-remaining to
  `COMP_SHORT_PACKET`, so most short transfers hit the buggy path
- After 3 transaction errors, error recovery degrades permanently for
  that endpoint
- One-line, obviously correct fix
- Signed off by xHCI and USB maintainers
- Bug present in v6.18.44; fix applies cleanly

**AGAINST:**
- No syzbot report or user bug report in commit message
- Failure mode is degraded recovery, not kernel crash
- Lore discussion could not be verified

**UNRESOLVED:**
- Full mailing-list review thread inaccessible
- No explicit stable nomination found

**Step 9.2 – Stable rules checklist**

1. Obviously correct and tested? **PASS** – logic is clear; maintainer
   SOBs present; no runtime test cited.
2. Fixes a real bug affecting users? **PASS** – short transfers are
   routine; error accounting is wrong.
3. Important issue? **PASS (MEDIUM-HIGH)** – USB communication failures
   on common device classes.
4. Small and contained? **PASS** – 1 line, 1 file.
5. No new features or APIs? **PASS**.
6. Can apply to local tree? **PASS** – buggy code confirmed in v6.18.44.

**Step 9.3 – Exception categories**

Record: None (not device ID, quirk, DT, build, or docs). Standard bug
fix.

**Step 9.4 – Decision rationale**

This is a clear correctness bug in xHCI error recovery. Because
`handle_tx_event()` rewrites success-with-short-data to
`COMP_SHORT_PACKET`, the existing `err_count` reset on `COMP_SUCCESS`
does not cover the common short-transfer case. Endpoints that routinely
short-packet can exhaust their three soft retries permanently after only
three transient transaction errors, causing degraded USB error recovery.
The fix is minimal, obviously correct, and low risk.

---

## Verification

- **[Phase 1]** Parsed subject, tags, and body from provided commit
  message.
- **[Phase 2]** Confirmed diff: +1 line `ep->err_count = 0` in
  `COMP_SHORT_PACKET` case.
- **[Phase 3]** `git blame -L 2560,2595 drivers/usb/host/xhci-ring.c`:
  soft retry from 2018, `err_count` on endpoint from 2022.
- **[Phase 3]** `git show f8f80be501aa2`: original soft retry added
  `err_count` reset on `COMP_SUCCESS` only.
- **[Phase 3]** `git show a1575120972ec`: moved `err_count` to endpoint;
  had `Cc: stable`.
- **[Phase 3]** `git log --oneline -20 -- drivers/usb/host/xhci-ring.c`:
  recent xhci activity confirmed.
- **[Phase 4]** `b4 dig`: no match (commit not in tree).
  Lore/patch.msgid.link: blocked (403/Anubis). **UNVERIFIED:** review
  thread content.
- **[Phase 5]** `grep process_bulk_intr_td`: called from
  `handle_tx_event()` line 2982.
- **[Phase 5]** Read `handle_tx_event()` lines 2707–2712: `COMP_SUCCESS`
  with remaining length converted to `COMP_SHORT_PACKET`.
- **[Phase 5]** `grep err_count drivers/usb/host/`: only reset on
  `COMP_SUCCESS` in xhci-ring.c.
- **[Phase 6]** `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44.
- **[Phase 6]** Read lines 2572–2574: bug present (no reset on
  `COMP_SHORT_PACKET`).
- **[Phase 6]** `git log --grep='Soft Retries'`: no existing fix in
  tree.
- **[Phase 8]** `MAX_SOFT_RETRY` = 3 in `drivers/usb/host/xhci.h` line
  1272.
- **[Phase 8]** Read `COMP_USB_TRANSACTION_ERROR` path: when `err_count
  > 3`, soft retry skipped.

**YES**

 drivers/usb/host/xhci-ring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2bb7569c95054..3f1a6089a01ce 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2570,6 +2570,7 @@ static void process_bulk_intr_td(struct xhci_hcd *xhci, struct xhci_virt_ep *ep,
 		td->status = 0;
 		break;
 	case COMP_SHORT_PACKET:
+		ep->err_count = 0;
 		td->status = 0;
 		break;
 	case COMP_STOPPED_SHORT_PACKET:
-- 
2.53.0

