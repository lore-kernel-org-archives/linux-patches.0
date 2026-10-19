Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D7D4D3BD8;
	Mon, 19 Oct 2026 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418147; cv=none; b=VTJ/GhlD/1lLbZxmLZIqvEZJiHE+8mRibSnbSsc7dLSiEEdH8GDogT5DRDQXjdvxJhtDJCjvpr8Mi4iduJaX3Pf5SXl0ZSvS3ym3nvT6V8oPVQuJFiVC6uMymWVBbdIrD8bb/SrJ/sC44z/GdB+aNofSxTFHjw8JCG/xq3u2s+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418147; c=relaxed/simple;
	bh=L7Wgvb8p+DBKFvmubZSZk4LGL89bDYaNc0WQUjDhoQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fRsu6VEjmqQV2cp6euZ7SoWBY7ifOx7bbMCsvyfEt8OOSjQCWfsOiFdqg+H5+JDq37cRiapmvdOVQxHCo5mn9d/SneRpTWPKBxnf5G+0MtBWmdqkPC0XLq/uvEHDNzui99DsrClPDB8++5ZDcgPzUa/eNujvZRIZcdby8h3V5T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B2wXbrVj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B2wXbrVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D70B1F000C9;
	Mon, 19 Oct 2026 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418145;
	bh=O+uBJdsXIVIitsIFbNqBtzDtVsZnQD06SvW2jouoyaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B2wXbrVjkEbX9J+GC20t2UnXrQYUcm7fMzBqLCzspBfHITHMI7wqWVIXZlLKjDTTJ
	 r4HHUNqSoQhrME2BYnLilvrMzvpverDmnL+YPD1raJ4lyFD/4rQn5xfZzEsmlbEpfP
	 5p4xoAbyJJRUT8u+wbc4FS5fE9zLMTfFeGArWgouy+ognVhdfbgeo6/Gurnw9JnzCI
	 S7Nyu2m0/nWn4fklgotv1nQLPiz4KAyA510LGRPBGcVNx9yzXfTBkeF2o6/6bR8vkF
	 ZsIwQ6B1hGwJYmoUU6EIUPlhgQqDVIzjancaGCA+ay4BUbx76iidjX/iqo7OSVCe09
	 TaT+sjPoZIxHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] tty: serial: pch_uart: add check for pci_get_slot()
Date: Mon, 19 Oct 2026 09:45:35 -0400
Message-ID: <20261019135441.1420968-44-sashal@kernel.org>
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

[ Upstream commit 970ede67de0e3f6a1e707ec99ae49d80bf3f2966 ]

Add check for pci_get_slot() to prevent a potetial
null pointer dereference in pch_request_dma().

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260623140539.2272473-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[tty: serial: pch_uart] [add] [NULL check on pci_get_slot() in
pch_request_dma()]`

**Step 1.2: Tags** (from the candidate message; original mail had extra
tags — see Phase 4)
- Reviewed-by: Andy Shevchenko `<andriy.shevchenko@linux.intel.com>`
  (serial/PCI reviewer; author of the `pci_get_slot()` call)
- Link: `https://patch.msgid.link/20260623140539.2272473-1-
  haoxiang_li2024@163.com`
- Signed-off-by: Haoxiang Li (author); Greg Kroah-Hartman (tty
  maintainer)
- No Reported-by, Tested-by, Acked-by in the committed message
- No Fixes:/Cc: stable in the committed message (expected for this
  review queue)

**Step 1.3: Body**
Record:
- Bug: `pci_get_slot()` can return NULL; the caller then does
  `param->dma_dev = &dma_dev->dev`.
- Symptom: potential NULL pointer dereference in `pch_request_dma()`.
- No stack trace, reproducer, or version range. Typo “potetial”.
- Root cause as stated: missing return-value check.

**Step 1.4: Hidden bug fix?**
Record: Not hidden. Explicit defensive NULL check. Same pattern as other
static-analysis “add check for X()” patches from this author.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/tty/serial/pch_uart.c` (+5 / −0)
- Function: `pch_request_dma()`
- Scope: single-file surgical fix

**Step 2.2: Flow**
Record: After `pci_get_slot(priv->pdev->bus,
PCI_DEVFN(PCI_SLOT(priv->pdev->devfn), 0))`, the code used `dma_dev`
unconditionally. After the patch, NULL returns with `dev_err` and no
`pci_dev_put` (correct: no reference was taken). Later failures still
use `goto err_pci_get` → `pci_dev_put(dma_dev)`.

**Step 2.3: Bug mechanism**
Record: **NULL pointer dereference.** `pci_get_slot()` is documented to
return NULL when the slot/function is absent (`drivers/pci/search.c`).
The next statement dereferences `dma_dev`.

**Step 2.4: Fix quality**
Record: Obviously correct, minimal, no API/lock/structure changes.
Regression risk is very low. Early return leaves DMA unset;
`pch_uart_verify_port()` only sets `use_dma` if `priv->chan_rx` is set,
so PIO fallback still works on that path.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Driver added in `3c6a483275f47` (2010, “Serial: EG20T: add PCH_UART
  driver”) using hardcoded `pci_get_bus_and_slot()`.
- Current lookup introduced in `8368d6a2b73900` (Andy Shevchenko,
  2014-07-30, v3.17-rc1).
- NULL check added by this commit `970ede67de0e3` (2026-06-23).
- Bug has been in tree for ~12 years.

**Step 3.2: Fixes: tag**
Committed message has none. Original mail (Phase 4) had
`Fixes: 8368d6a2b739 ("pch_uart: don't hardcode PCI slot to get DMA
device")`.
Record: `8368d6a2b739` **is** an ancestor of this checkout (`git merge-
base --is-ancestor` succeeded; contained in v3.17-rc1).

**Step 3.3: Related file history**
Record:
- `8be3a7bf77370` (2022): missing `pci_dev_put()` after `pci_get_slot()`
  — confirms the API contract (refcount on success, NULL on failure).
- `6fe472c1bbbe2` (2026): NULL check for `dma_alloc_coherent()` in the
  same function, with `Fixes:` + `Cc: stable`.
- `e41c0981213f3` (2013): real NULL deref in this driver when DMA setup
  failed.
Standalone 5-line patch, not part of a numbered series.

**Step 3.4: Author**
Record: Haoxiang Li is a regular static-analysis contributor, not the
tty maintainer. One pch_uart commit. Reviewed by Andy Shevchenko;
applied by Greg Kroah-Hartman.

**Step 3.5: Dependencies**
Record: None. Uses existing `pci_get_slot()`, `dev_err`, and
`pch_request_dma()`. Applies standalone.

---

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 970ede67de0e3` → https://patch.msgid.link/20260623140539.22
  72473-1-haoxiang_li2024@163.com
- `b4 dig -a`: v1 only; that version was applied.
- Original body **did** include `Fixes: 8368d6a2b739` and `Cc:
  stable@vger.kernel.org` (stripped in the git commit; that is why this
  is in the manual queue, not a reason to reject).
- Andy Shevchenko: *“Not that it's quite possible, but probably you
  found this due to AI review which might have considered some cases of
  manual binding a PCI device to any PCI driver. Given that is the case,
  I'm fine with the change.”*
- No NAK.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: gregkh, jirislaby, andriy.shevchenko, linux-serial, linux-
kernel, **stable@vger.kernel.org**, kees@kernel.org. Right maintainers
were on CC. Andy reviewed; Greg applied.

**Step 4.3: Bug report**
Record: No syzbot, bugzilla, or user report. Static/AI analysis of a
documented NULL return.

**Step 4.4: Series**
Record: Standalone v1. Related in-function fix `6fe472c1bbbe2` is
independent.

**Step 4.5: Stable list**
Record: lore stable search shows the original patch (because it was CCed
there) and Andy’s reply. No follow-up rejecting it for stable. WebFetch
to lore returned 403; thread recovered via `b4 dig -m` and curl.

---

## Phase 5: Semantic / call graph

**Step 5.1: Functions**
Record: `pch_request_dma()` only.

**Step 5.2: Callers**
Record (from this tree):
1. `pch_uart_startup()` — if `priv->use_dma`
2. `pch_uart_verify_port()` — TIOCSSERIAL / setserial path, which this
   driver historically runs during install (`af6d17cdc8c89`)

**Step 5.3: Callees**
Record: `pci_get_slot`, `dma_request_channel`, `dma_alloc_coherent`,
`pci_dev_put`.

**Step 5.4: Reachability**
Record: Yes, from userspace serial setup (TIOCSSERIAL) and from UART
startup when DMA was already enabled. Needs `CONFIG_SERIAL_PCH_UART` and
typically `CONFIG_PCH_DMA`. Not a syscall fuzz target for unprivileged
users; admin/boot path on EG20T/ML72xx hardware.

**Step 5.5: Similar patterns**
Record: Same function already checks `dma_request_channel` and
`dma_alloc_coherent`. DMA PCI ID 0x8810 is function-0 sibling of UART
IDs 0x8811–0x8814; lookup is “same slot, function 0”.

---

## Phase 6: This checkout

**Step 6.1: Buggy code in this tree?**
Record: Local tree is **v7.3-rc4-27** (`Makefile` 7.3.0-rc4). Driver and
`pci_get_slot()` lookup are present. Introducing commit `8368d6a2b739`
is an ancestor. Current `pch_request_dma()` already contains the NULL
check from `970ede67de0e3` (first appeared `v7.2-rc1-21`). The bug class
exists in this lineage; the file is not missing.

**Step 6.2: Backport difficulty**
Record: Clean apply. Hunk is independent of the later `goto` ladder.

**Step 6.3: Other fixes already here?**
Record: Refcount leak fix and `dma_alloc_coherent` check are present. No
alternate fix for this NULL case besides this commit.

---

## Phase 7: Subsystem context

**Step 7.1:**
Record: `drivers/tty/serial/pch_uart.c` — Intel EG20T PCH / LAPIS
ML7213/ML7223/ML7831 UART (Atom E6xx-era embedded/IVI). **PERIPHERAL**,
but a real in-tree production driver.

**Step 7.2:**
Record: Low churn; occasional correctness fixes. Mature, not staging.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver/config-specific: `CONFIG_SERIAL_PCH_UART` on 32-bit x86
or MIPS (or `COMPILE_TEST`). Not universal.

**Step 8.2: Trigger**
Record: `pch_request_dma()` when function 0 of the UART’s PCI slot is
not enumerated (firmware hid DMA, sparse multifunction device, or sysfs
bind of this driver to a non-fn0 device with no fn0 sibling). On stock
EG20T, fn0 DMA (0x8810) is normally present, so `pci_get_slot()`
succeeds. Unprivileged users cannot bind PCI drivers. `verify_port` is a
real install/setserial path.

**Step 8.3: Failure mode**
Record: Kernel oops (NULL deref) instead of PIO fallback. Severity:
**HIGH** if it fires, **low likelihood** on intended hardware. Andy
called the trigger unlikely but accepted the case.

**Step 8.4: Risk/benefit**
Record: Benefit: prevent oops, match existing error handling. Risk: very
low (5 lines, error path only). Ratio: favorable.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real, documented NULL return from `pci_get_slot()`, immediately
  dereferenced.
- 5-line, obviously correct check; UART continues without DMA.
- Reviewed by Andy Shevchenko; applied by Greg KH.
- Original submission asked for stable and cited `Fixes: 8368d6a2b739`
  (in tree since v3.17).
- Same function already treats DMA setup failure as a crash-worthy bug
  (`e41c0981213f3`, `6fe472c1bbbe2`).
- Applies cleanly; no new API; no prerequisites.

Against:
- Niche ~2010 embedded UART.
- No user/syzbot report; likely AI/static analysis.
- Reviewer: trigger is “not quite possible” except odd PCI bind.
- Committed message dropped `Cc: stable` / `Fixes:` (auto-select would
  have needed those tags).

Unresolved: none that change the technical call. Lore WebFetch 403 was
covered by `b4` + curl.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — reviewed; Greg merged; logic
   is local and clear.
2. Real bug affecting users? **PASS** — API can return NULL; oops if DMA
   setup runs without fn0. Rare, but not fictional.
3. Important (crash/security/corruption/deadlock)? **PASS** — NULL deref
   → oops; small blast radius.
4. Small and contained? **PASS** — +5 lines, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — driver and call site exist; hunk
   is clean.

**Step 9.3: Exception category**
Record: None (not an ID/quirk/DT/build/docs exception). Ordinary memory-
safety fix.

**Step 9.4: Decision**
This tree is 7.3-rc4 and already contains the driver. The bug is a NULL
deref on a documented failure path, the patch is a five-line guard with
PIO fallback, and it needs no other commits. Niche hardware and a rare
trigger do not outweigh an oops fix this small. It belongs in this tree.

---

### Problem and why it matters here

`pch_request_dma()` looks up the EG20T/ML72xx DMA function with
`pci_get_slot(..., function 0)` and then uses `dma_dev->dev`. If that
function is missing, the kernel oopses while opening or reconfiguring
the UART. The patch logs and returns so the port can keep running in PIO
mode.

### Stable rules / risk

Meets the rules: real crash, tiny, no features, clean apply on this
checkout. Benefit (avoid oops) dwarfs regression risk.

### Concerns

Trigger is uncommon on real EG20T boards; this is defensive. That is not
a reason to keep a NULL deref. No extra backport work.

---

Verification:
- [Phase 1] Parsed committed tags: Reviewed-by Andy Shevchenko, Link to
  msgid, SOBs Haoxiang Li + Greg KH; no Reported-by/syzbot.
- [Phase 2] `git show 970ede67de0e3`: +5 lines in `pch_request_dma()`
  after `pci_get_slot()`.
- [Phase 2] Read `pch_request_dma()` in this tree: check +
  `err_pci_get`/`pci_dev_put` paths confirmed.
- [Phase 3] `git blame` / `git log -L`: lookup from `8368d6a2b739`
  (v3.17-rc1); driver from `3c6a483275f47` (2010).
- [Phase 3] `git merge-base --is-ancestor 8368d6a2b739 HEAD` → yes.
- [Phase 3] Related: `8be3a7bf77370` refcount, `6fe472c1bbbe2` dma_alloc
  check, `e41c0981213f3` historical DMA NULL oops.
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 thread; original had
  Fixes:+Cc:stable; Andy Reviewed-by; no NAK.
- [Phase 4] WebFetch lore 403; curl on lore stable showed patch + Andy
  reply only.
- [Phase 5] Callers: `pch_uart_startup` (line 1267),
  `pch_uart_verify_port` (line 1427).
- [Phase 5] `pci_get_slot()` in `drivers/pci/search.c` returns NULL if
  not found.
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4.
- [Phase 6] `git merge-base --is-ancestor 970ede67de0e3 HEAD` → yes
  (first at v7.2-rc1-21).
- [Phase 7] Kconfig `SERIAL_PCH_UART`: EG20T/ML7213/ML7223/ML7831.
- [Phase 8] DMA ID 0x8810 vs UART 0x8811–0x8814 in `pch_dma.c` /
  `pch_uart.c`.
- UNVERIFIED: live crash on real EG20T hardware (no user report).

**YES**

 drivers/tty/serial/pch_uart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c3f32e0590b7f..9104361ccb14f 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -678,6 +678,11 @@ static void pch_request_dma(struct uart_port *port)
 	/* Get DMA's dev information */
 	dma_dev = pci_get_slot(priv->pdev->bus,
 			PCI_DEVFN(PCI_SLOT(priv->pdev->devfn), 0));
+	if (!dma_dev) {
+		dev_err(priv->port.dev, "%s: failed to get DMA device\n",
+			__func__);
+		return;
+	}
 
 	/* Set Tx DMA */
 	param = &priv->param_tx;
-- 
2.53.0

