Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F84552EAB;
	Mon, 19 Oct 2026 13:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418219; cv=none; b=RZdkVnsHEotd6Bcc7RhVgEiQa5VNJXHTKMrqNnBlT3Adf10EtVjtRBzrkApjAMmGD+vyI4e9GfGOywj/nJFvq3SXRa2/9rNlyLlBBLvlVOPQTEqnecYl+Gkwn/g2uBfXl3iLwMHDUMbhS0WOeZYTRvaDfPJRR8Ci1UAF9ahi+NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418219; c=relaxed/simple;
	bh=HvIiQ/BCN3gOPvj3S7ZDAZp/yqiR9YOsfAicO5ErCQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cHeCZ0QTUeL5sKeGLuV5eY7nNcQSKbAovw8hkDoE174uRpRi1yt4S7DkmxDi92cjI9JO7FWCn9fHBMaPxusgjUb5stFWDYQGcB5oJhpKgEV9O1WXDUbnvck8Odc1nSdX4UpQdqTyaoqJvKMueMvy1ST4w+V7UVkAeH1thzh+zZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JmSrR8+/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JmSrR8+/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08AFE1F000C6;
	Mon, 19 Oct 2026 13:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418216;
	bh=UENfQOyJqvDAsP8QZG4nzSyJ+1MdDILYTS/0lAglk+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JmSrR8+/olP5KzoO/FFFOEt7pZLpBWyLkGFHT9kAEHgkD3ldOGxDHVDwH8ljANG6i
	 IkkUs/olRJXnIp9b3PrQcV19w517QUZ5jEMRj0rcNYyKcKQsTht4LVyoaX5RMbya15
	 PC+eh+YPhJWtg3Dle55tNYa4sE21T8XmKP5QchYE17j7plOItbSWAsv9HZ0KerYARq
	 qINIPD7TPXyPDHWiR1OzrpQypeP/cfAJwsJXyA+8YcxS/XGDHPNs0PuvZe1Ah9O4fn
	 +nkeD6yxgDuZgSajVPkbf/wQHzQpMoZEmYqVpkQ9RiSAob0z+aFUp7gJu9g9Dz1E5I
	 W2GTgc0YpVinA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-usb@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] usb: fsl_qe_udc: check qe_alloc_request() failure in ch9getstatus()
Date: Mon, 19 Oct 2026 09:46:26 -0400
Message-ID: <20261019135441.1420968-95-sashal@kernel.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 612551bf7cf7113b8bbd5e8c1eea86d9427c2f95 ]

qe_alloc_request() may return NULL on allocation failure. ch9getstatus()
passes the return value directly to container_of() and then immediately
dereferences the resulting qe_req pointer. Check the allocation result
before using it and stall the control request on failure.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Link: https://patch.msgid.link/20260620120631.2894977-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[usb / fsl_qe_udc] [check] check qe_alloc_request() failure in
ch9getstatus()` — USB gadget UDC driver; “check” here is a missing-NULL-
check fix, not a feature.

**Step 1.2: Tags**
Record:
- `Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>` (author)
- `Link: https://patch.msgid.link/20260620120631.2894977-1-
  haoxiang_li2024@163.com`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` (USB
  maintainer applied it)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected)

**Step 1.3: Body**
Record:
- **Bug:** `qe_alloc_request()` can return NULL; that pointer is passed
  to `container_of()` and immediately dereferenced.
- **Symptom:** kernel oops / NULL deref on `GET_STATUS` when allocation
  fails.
- **Version info:** none in the message.
- **Root cause:** unchecked allocation result in `ch9getstatus()`.
- **Fix:** test the pointer; stall EP0 on failure.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. This is an explicit NULL-deref fix. The “stall on
failure” path is the existing error path, not a new feature.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/usb/gadget/udc/fsl_qe_udc.c` (+6 / −2)
- Function: `ch9getstatus()`
- Scope: single-file surgical fix

**Step 2.2: Code flow**
Record: Before, `container_of(qe_alloc_request(...), struct qe_req,
req)` ran unconditionally, then `req->req.length = 2` and later
`__qe_ep_queue()`. After, the result is stored in `usb_req`, NULL goes
to the existing `stall:` label (`dev_err` + `qe_ep0_stall()`), and only
a live request is converted with `container_of`.

**Step 2.3: Bug mechanism**
Record: **NULL pointer dereference** (memory safety).
`qe_alloc_request()` does `kzalloc_obj()` and returns NULL on failure.
`struct qe_req` has `struct usb_request req` as the first member, so
`container_of(NULL, ...)` is still NULL, then `req->req.length = 2`
oopses.

**Step 2.4: Fix quality**
Record: Obviously correct; uses the existing `stall` path; no API/data-
structure change. Regression risk is very low. Pre-existing issue not
introduced here: if alloc succeeds and `__qe_ep_queue()` fails, the
request is still not freed (leak on that older path). This patch does
not make that worse.

## Phase 3: Git history

**Step 3.1: Blame**
Record: Unchecked `container_of(qe_alloc_request(...))` comes from
`3948f0e0c999a6` (“usb: add Freescale QE/CPM USB peripheral controller
driver”, 2008-09-02), first in `v2.6.28-rc1`. The bug is ancient, not
new 7.3 code.

**Step 3.2: Fixes: tag**
Record: No `Fixes:` tag. The introducing commit is `3948f0e0c999a6`
(above). That commit is an ancestor of this tree.

**Step 3.3: File history**
Record: Related work on the same function: `ce9daa2efc087` (2023) added
`pipe >= USB_MAX_ENDPOINTS` before indexing `udc->eps[]` — that patch
was AUTOSEL’d into stable 5.15. Recent file churn is
kmalloc→`kzalloc_obj` conversion, not a refactor of `ch9getstatus()`.
Standalone, not `patch X/Y`.

**Step 3.4: Author**
Record: Haoxiang Li has several USB NULL/leak-style fixes (`mtu3`,
`cdnsp`, `typec`, `renesas_usbhs`). Not the UDC maintainer. Greg Kroah-
Hartman applied this one. Similar sibling: `4ab2b48c98f2e`
(`fsl_udc_core` allocation check).

**Step 3.5: Dependencies**
Record: None. Uses existing `qe_alloc_request()`, `stall:` /
`qe_ep0_stall()`, and `container_of`. Applies standalone.
`qe_alloc_request()` still returns NULL on failure after the
`kzalloc_obj` conversion.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record: `b4 dig -c 612551bf7cf71` → https://patch.msgid.link/20260620120
631.2894977-1-haoxiang_li2024@163.com
`b4 dig -a`: **v1 only**, 2026-06-20, same subject. Mbox is the patch
with **no replies**. LKML/Openwall mirrors match; no NAK, no v2, no `Cc:
stable` in review (there was no public review thread).

**Step 4.2: Recipients (`b4 dig -w`)**
Record: To: `kees@kernel.org`, `gregkh@linuxfoundation.org`; Cc: `linux-
usb`, `linuxppc-dev`, `linux-kernel`. USB maintainer was in To and
committed it.

**Step 4.3: Bug report**
Record: No `Reported-by` / syzbot / bugzilla. Looks like static analysis
(NULL after alloc), not a user crash report.

**Step 4.4: Series**
Record: Standalone v1. Not part of a multi-patch series.

**Step 4.5: Stable list**
Record: Direct lore.kernel.org fetches returned 403. No stable-list
discussion found via `b4` or web search. Precedent: the earlier
`ch9getstatus` bounds check in this file **was** AUTOSEL’d to 5.15.

## Phase 5: Semantic / call-graph

**Step 5.1: Functions**
Record: `ch9getstatus()` only (uses `qe_alloc_request`, `container_of`,
`__qe_ep_queue`, `qe_ep0_stall`).

**Step 5.2: Callers**
Record: Only `setup_received_handle()` on `USB_REQ_GET_STATUS`.

**Step 5.3: Callees**
Record: `qe_alloc_request` → `kzalloc_obj`; `__qe_ep_queue`;
`qe_ep0_stall`; `ownercomplete` kfree’s the request on completion.

**Step 5.4: Call chain / reachability**
Record:
`qe_udc_irq` (hardirq, `spin_lock_irqsave(&udc->lock)`)
→ `rx_irq` → `qe_ep0_rx` → `ep0_setup_handle` → `setup_received_handle`
→ `ch9getstatus`

Reachable from USB host `GET_STATUS` during gadget enumeration.
Unprivileged **host** can send it; not a typical local-syscall path.
GFP_KERNEL under a spinlock in IRQ is a pre-existing atomic-sleep smell
and makes NULL more plausible under memory pressure.

**Step 5.5: Similar patterns**
Record: `qe_alloc_request()` is only used here plus the
`usb_ep_ops.alloc_request` hook. Sibling FSL UDC had the same class of
alloc-check fix.

## Phase 6: This checkout

**Step 6.1: Does the buggy code exist?**
Record: Local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`).
Driver and `ch9getstatus()` are present. The unchecked alloc was
introduced in v2.6.28 and lived until `612551bf7cf71` (`v7.2-rc1-40`,
2026-07-10). HEAD already has the fixed form (`usb_req =
qe_alloc_request...; if (!usb_req) goto stall`). That is the mainline
source of the candidate, not a reason to treat the bug as absent from
this driver.

**Step 6.2: Backport difficulty**
Record: Surrounding `ch9getstatus()` matches the patch; `git diff
612551bf7cf71 HEAD -- drivers/usb/gadget/udc/fsl_qe_udc.c` is empty.
Clean apply on this tree’s file; older stables still have the same
`container_of(qe_alloc_request(...))` shape from 2008.

**Step 6.3: Related fixes already here**
Record: Endpoint-index check `ce9daa2efc087` is already in this file. No
other fix covers the alloc NULL. This patch is the alloc-failure check,
not a duplicate of that bounds check.

## Phase 7: Subsystem context

**Step 7.1:** Record: USB gadget UDC (`drivers/usb/gadget/udc/`).
**PERIPHERAL** — Freescale QE/CPM USB device controller.
`CONFIG_USB_FSL_QE` depends on `FSL_SOC && (QUICC_ENGINE || CPM)` and
`!64BIT || BROKEN` (32-bit PowerPC QE/CPM, e.g. MPC8360/MPC8272).

**Step 7.2:** Record: Mature, low-churn driver (2008). Recent commits
are conversions/typos plus this NULL check. Long-lived bug, not a new-
subsystem issue.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver-specific / config-specific: USB gadget on 32-bit
Freescale QE/CPM SoCs.

**Step 8.2: Trigger**
Record: Host sends standard `GET_STATUS`; `qe_alloc_request(GFP_KERNEL)`
fails. Uncommon (memory pressure / atomic GFP_KERNEL), but the control
request is a normal enumeration path. Host-triggered.

**Step 8.3: Failure mode**
Record: NULL deref → oops in hardirq UDC path. **Severity: HIGH** (crash
of the gadget/UDC path; can take the machine down depending on
panic_on_oops). Not silent corruption.

**Step 8.4: Risk vs benefit**
Record: **Benefit:** medium for those boards (prevents oops), low
globally (niche HW). **Risk:** very low (6 net lines, existing stall
path). Ratio favors taking it: same class of fix already AUTOSEL’d in
this function.

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real NULL deref on a live USB control path
- `qe_alloc_request()` documented to return NULL
- Tiny, obviously correct check + existing stall
- Bug present since 2008 in this driver
- USB maintainer merged it
- Same function already had a stable AUTOSEL bounds fix
- Call path is IRQ + spinlock, so GFP_KERNEL failure is not purely
  theoretical

Against:
- Niche 32-bit PowerPC QE/CPM gadget (`BROKEN` on 64-bit)
- No user/syzbot report; static-analysis style v1 with no mailing-list
  review
- No `Tested-by`
- Alloc-failure is uncommon
- Pre-existing queue-failure leak left unfixed (not a regression)

Unresolved: lore.kernel.org HTTP 403; no public review comments beyond
the patch itself (confirmed via `b4` mbox).

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** on correctness (code is
   unambiguous). Testing is only “merged by Greg”; no hardware Tested-
   by, but the change does not need runtime proof beyond reading
   `qe_alloc_request()`.
2. Real bug affecting users? **PASS** — oops if this UDC handles
   `GET_STATUS` and alloc fails.
3. Important (crash/security/corruption/deadlock)? **PASS** — kernel
   oops. Not a new API.
4. Small and contained? **PASS** — 8-line hunk, one function.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — file and function exist; context
   matches.

**Step 9.3: Exception category**
Record: None (not an ID/quirk/DT/build/doc exception). It is a normal
crash fix.

**Step 9.4: Decision**
This is a textbook missing-NULL-check on a kmalloc-backed helper, in a
path a USB host hits with `GET_STATUS`. It is small, applies to the
driver in this tree, and prevents an oops. Niche hardware lowers
population, not severity for the people who have it. It meets stable-
kernel-rules.

### What it solves for stable users
Without the check, `ch9getstatus()` oopses when `qe_alloc_request()`
returns NULL. With it, EP0 stalls and the gadget stays up. That matters
on QE/CPM gadget devices under memory pressure, including in hardirq.

### Risk vs benefit
Very low risk, contained error-path change. Benefit is avoiding a real
oops on existing hardware. Worth taking.

---

Verification:
- [Phase 1] Parsed tags: author SOB, Greg KH SOB, msgid link; no
  Fixes/Reported-by/Cc stable
- [Phase 2] Diff: +6/−2 in `ch9getstatus()`; NULL check then existing
  `stall:`
- [Phase 2] `struct qe_req`: `req` is first member
  (`fsl_qe_udc.h:252-259`); `container_of(NULL)` is NULL
- [Phase 2] `qe_alloc_request()` returns NULL after `kzalloc_obj`
  failure (lines 1669–1681)
- [Phase 3] `git blame` / `git log -1 3948f0e0c999a6`: buggy pattern
  from 2008, `v2.6.28-rc1`
- [Phase 3] No Fixes tag; introducing commit is in this tree
- [Phase 3] Related: `ce9daa2efc087` bounds check in same function;
  AUTOSEL 5.15 (lkml archive)
- [Phase 3] Author USB fixes listed via `git log --author="Haoxiang Li"`
- [Phase 4] `b4 dig -c 612551bf7cf71`: lore msgid
  20260620120631.2894977-1
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: gregkh + kees + linux-usb
  + linuxppc-dev
- [Phase 4] mbox: patch only, no replies
- [Phase 4] lore WebFetch 403; LKML/Openwall mirrors used instead
- [Phase 5] Callers: only `setup_received_handle` for
  `USB_REQ_GET_STATUS`
- [Phase 5] Call chain: `qe_udc_irq` → `rx_irq` → `qe_ep0_rx` →
  `ep0_setup_handle` → `setup_received_handle` → `ch9getstatus`
  (spinlock held)
- [Phase 6] `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 612551bf7cf71 HEAD`: yes
  (mainline already contains the candidate)
- [Phase 6] File at HEAD matches the fixed version; reverse-apply of the
  commit succeeds
- [Phase 7] Kconfig `USB_FSL_QE`: FSL_SOC QE/CPM, `!64BIT || BROKEN`
- [Phase 8] Failure mode: NULL deref oops in UDC IRQ, severity HIGH
- UNVERIFIED: full lore thread beyond the mbox (HTTP 403); whether any
  reviewer privately asked for Cc: stable

**YES**

 drivers/usb/gadget/udc/fsl_qe_udc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/udc/fsl_qe_udc.c b/drivers/usb/gadget/udc/fsl_qe_udc.c
index aacfde06387c0..7911dca2135cf 100644
--- a/drivers/usb/gadget/udc/fsl_qe_udc.c
+++ b/drivers/usb/gadget/udc/fsl_qe_udc.c
@@ -1945,6 +1945,7 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 			u16 index, u16 length)
 {
 	u16 usb_status = 0;
+	struct usb_request *usb_req;
 	struct qe_req *req;
 	struct qe_ep *ep;
 	int status = 0;
@@ -1983,8 +1984,11 @@ static void ch9getstatus(struct qe_udc *udc, u8 request_type, u16 value,
 		}
 	}
 
-	req = container_of(qe_alloc_request(&ep->ep, GFP_KERNEL),
-					struct qe_req, req);
+	usb_req = qe_alloc_request(&ep->ep, GFP_KERNEL);
+	if (!usb_req)
+		goto stall;
+
+	req = container_of(usb_req, struct qe_req, req);
 	req->req.length = 2;
 	req->req.buf = udc->statusbuf;
 	*(u16 *)req->req.buf = cpu_to_le16(usb_status);
-- 
2.53.0

