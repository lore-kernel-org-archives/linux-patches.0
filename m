Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA5557086A;
	Mon, 19 Oct 2026 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418294; cv=none; b=GRg8VzC3NE0G6OKc1Uw+RcrOcYswYfijEbj6khBVwqcR4LW1Lj2HBQOt1q3YfCcDIDLPuIB7QpNEohlUzrDUF5SEZV11nErMw1anbUNW2Qc+vVhrXp7qjGU5rMq0y4UOhQR8WsNqrJCmK9UVDemi0Zzjnnho2LUYWroB08X118w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418294; c=relaxed/simple;
	bh=tWZ+SrgwjhSqdrM6eLFjjriXbRk6Tgp6qsG1MoCzuvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kLiJFoHn3XXkmbSVSydgMuYr+LvTXfgCs6aiINUUYCjCuppRiCIvNIlayr5Re/IZma249qWRBVQYfF3I4Syt1BdBQPpiT81if908W4RdEIi3Guj1CQAL143MgUmUo8PndiztwegNRDS96J7rOO2B2pCeSs07HTQOXPdzBgSiGeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=izhsPaI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="izhsPaI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 815E71F000C9;
	Mon, 19 Oct 2026 13:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418292;
	bh=F5nV6LG/nrnrWDtY2zxsAs5yjNJsJLwaEFJzaLqkRrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izhsPaI+a+VXI3+GHcTF500d/Lf4V+fROLC6UTeZyGVrPDTJTG31MeOyuqWDYXIKm
	 pATbNXydC2gBVax/XE6bjL9poVeKF4Ckm+m3RwNNhKJjJ1MSy9vNQRtxWBDfX2wkxI
	 rzu0MmzUNuiaiIJLyi6yrYxAjRe9pMJFT9OUyKNkkn5o2eAQHY6l3gTiB210+cCm/c
	 15RkAPFwdLezCHuHIAiSI1Mmtps1j/N3l+cFv/p0j0JATAhaMMG0VM3QQ4R7GFCL1N
	 8M9YYmbD/L5K4B1fkXJea6T0yFSL98Je3QN/eG4vZfd9SL6GwOSOUOXIWx8gB/DPay
	 RHgbJsET1ac9Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: pcmuio: Add sanity check to interrupt handler
Date: Mon, 19 Oct 2026 09:47:15 -0400
Message-ID: <20261019135441.1420968-144-sashal@kernel.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 6f6f6644e011fa910db744e9978127a443b94001 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler
pcmuio_interrupt() to ensure the device has been fully set up, avoiding
a possible null pointer dereference of dev->subdevices by
pcmuio_handle_asic_interrupt().

Also make use of the IRQ_HANDLED(x) macro for the normal return path of
the interrupt handler.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-11-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[comedi: pcmuio:]` `[Add]` sanity check to interrupt handler.
  Intent: guard `pcmuio_interrupt()` so it does not run against a device
  that is not fully attached.

**Step 1.2: Tags**
- Record:
  - `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (COMEDI maintainer)
  - `Link:
    https://patch.msgid.link/20260618102949.26607-11-abbotti@mev.co.uk`
  - `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
  - No `Fixes:`, no `Cc: stable`, no `Reported-by` on this specific
    commit (expected for this review pipeline)
  - Original submission CCs: Greg KH, H Hartley Sweeten, Jaeyoung Chung,
    Sangyun Kim, Kyungwook Boo
  - The series cover letter and patch 01/11 carry `Reported-by` for
    those SNU reporters; this pcmuio patch inherited them only as CCs,
    not as tags

**Step 1.3: Body**
- Record: `[Bug]` IRQ handler can run after `request_irq()` but before
  the device is fully set up. `[Symptom]` possible NULL deref of
  `dev->subdevices` in `pcmuio_handle_asic_interrupt()`. `[Trigger]`
  premature IRQ unless I/O base and/or IRQ are wrong or hardware is bad.
  `[Root cause]` handler registered before subdevices exist / before
  `dev->attached` is set. Also switches the return to `IRQ_RETVAL()`
  (commit text says `IRQ_HANDLED(x)`; that is a typo — the diff uses
  `IRQ_RETVAL`).

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. Cover letter is explicit: “avoid null-ptr-deref”.
  The `IRQ_RETVAL` swap is cosmetic and equivalent.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `drivers/comedi/drivers/pcmuio.c` only; +4/−1. Function:
  `pcmuio_interrupt()`. Single-file surgical fix.

**Step 2.2: Code flow**
- Record: Before: handler always calls `pcmuio_handle_asic_interrupt()`
  if the IRQ matches `dev->irq` / `devpriv->irq2`. After: if
  `!dev->attached`, return `IRQ_NONE` immediately. Then `return
  IRQ_RETVAL(handled)` instead of `handled ? IRQ_HANDLED : IRQ_NONE`
  (same meaning: `#define IRQ_RETVAL(x) ((x) ? IRQ_HANDLED :
  IRQ_NONE)`).

**Step 2.3: Bug mechanism**
- Record: `[NULL pointer dereference]` in IRQ context. `pcmuio_attach()`
  does `request_irq()` at lines 549–567, then
  `comedi_alloc_subdevices()` at line 570. `dev->attached` is set only
  later in `comedi_device_postconfig()`.
  `pcmuio_handle_asic_interrupt()` does `s = &dev->subdevices[asic * 2]`
  and `pcmuio_handle_intr_subdev()` then uses `s->index` and `s->async`.

**Step 2.4: Fix quality**
- Record: Obviously correct and matches the established comedi pattern
  (`if (!dev->attached) return IRQ_NONE`). Minimal. Regression risk is
  low: returning `IRQ_NONE` during attach/detach is the intended safe
  path, and this IRQ is requested with flags `0` (not shared).
  `IRQ_RETVAL` is behavior-preserving.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Handler/`request_irq` before `comedi_alloc_subdevices` dates
  to Hartley Sweeten, 2013 (`04426acfb86ad1`). Subdevice indexing in the
  handler: `741ba8cdf0e938` (2013-12-06). Driver added in 2009
  (`6baef150380d56`). Long-standing.

**Step 3.2: Fixes: tag**
- Record: None. Bug is structural in the attach vs IRQ order, not a
  recent regression.

**Step 3.3: File history**
- Record: Recent: `3d4ab5484aa24` (I/O-base sanity checks) then this
  commit. I/O-base patch is a different series and is not required for
  this hunk. Standalone.

**Step 3.4: Author**
- Record: Ian Abbott is listed as COMEDI maintainer in `MAINTAINERS`.
  This is one of an 11-patch “Add/fix sanity check in ISA drivers to
  avoid null-ptr-deref” series.

**Step 3.5: Dependencies**
- Record: None. Touches only `pcmuio_interrupt()`. `IRQ_RETVAL` has long
  existed in `include/linux/irqreturn.h`. Applies standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 6f6f6644e011f` →
  https://patch.msgid.link/20260618102949.26607-11-abbotti@mev.co.uk
  (`[PATCH 10/11]`). `b4 dig -a`: single v1 series, no later revisions.
  Mbox has the 11 patches + cover letter and **no replies/NAKs**. Cover
  letter: several ISA drivers register the IRQ handler before subdevices
  are initialized → null deref on a premature IRQ.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Ian Abbott, Greg KH, Hartley Sweeten, linux-kernel, plus the
  SNU reporters. Right maintainers were on the patch.

**Step 4.3: Bug report**
- Record: Original report https://lore.kernel.org/lkml/20260610115912.78
  0131-1-jjy600901@snu.ac.kr/ — subject “comedi: KASAN null-ptr-deref in
  ISA driver IRQ handlers on early IRQ”. Lists das6402, ni_atmio16d,
  aio_iiro_16, pcmmio, comedi_parport, pcl711. **pcmuio was not in that
  list**; Abbott added it as the same pattern. Related `comedi_parport`
  fix (`17221216ae8ce`) was syzbot + `Cc: stable`.

**Step 4.4: Series**
- Record: 11 independent per-driver patches. This one does not need the
  others.

**Step 4.5: Stable list**
- Record: lore.kernel.org/stable search returned HTTP 403. UNVERIFIED
  whether this hash was discussed on stable@. The parport sibling was
  explicitly nominated.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: `pcmuio_interrupt()`; callee `pcmuio_handle_asic_interrupt()`.

**Step 5.2: Callers**
- Record: Only `request_irq(..., pcmuio_interrupt, ...)` in
  `pcmuio_attach()` (IRQ 1 and optional IRQ 2). IRQ context after
  userspace `COMEDI_DEVCONFIG` attach.

**Step 5.3: Callees**
- Record: `pcmuio_handle_asic_interrupt()` → `inb()` of pending
  register, then `pcmuio_handle_intr_subdev()` which touches `s->async`
  / `s->index`.

**Step 5.4: Reachability**
- Record: Yes. `CONFIG_COMEDI_PCMUIO`, `comedi_config` options `[0]` I/O
  base, `[1]`/`[2]` IRQ. Attach ioctl is typically privileged, but a
  wrong I/O/IRQ (or syzkaller-style config) can fire the handler before
  `comedi_alloc_subdevices()`.

**Step 5.5: Similar patterns**
- Record: Dozens of comedi drivers already check `dev->attached` in IRQ
  handlers. Same series adds/fixes aio_iiro_16, das6402, pcmmio,
  ni_atmio16d, etc.

## Phase 6: This tree

**Step 6.1: Local tree / buggy code**
- Record: `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`. File and attach-vs-IRQ order are
  present. `git merge-base --is-ancestor 6f6f6644e011f HEAD` is true
  (commit is in 7.3-rc1, not in v7.2). Evaluating technical need: the
  driver and the race exist on this lineage.

**Step 6.2: Backport difficulty**
- Record: Clean apply on this tree (hunk is isolated). No refactor of
  `pcmuio_interrupt()` between the 2013 code and this patch.

**Step 6.3: Related fixes already here**
- Record: This exact check is already the current code (because 7.3
  already contains the commit). No alternate fix for pcmuio. That is not
  used as “already selected” circular reasoning; it only confirms the
  change matches the tree.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[comedi / pcmuio ISA-PC/104 DIO]` `[PERIPHERAL]` — Winsystems
  PCM-UIO48A/96A. Not core mm/net, but a real in-tree driver (out of
  staging).

**Step 7.2**
- Record: COMEDI status in MAINTAINERS: “Odd Fixes”. Recent burst is
  this ISA sanity-check series. Driver itself is mature (2009/2013).

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Users of `CONFIG_COMEDI_PCMUIO` who pass an IRQ into attach.
  Driver-specific, not universal.

**Step 8.2: Trigger**
- Record: Window after `request_irq()`, before
  `comedi_alloc_subdevices()` / `dev->attached = true`. Also
  misconfigured I/O base (garbage `inb` of pending bits) or bad
  hardware. Not every boot; attach-time. Usually requires CAP_SYS_ADMIN
  for comedi attach; still a kernel oops, and the same class was
  KASAN/syzbot-reachable on sibling drivers.

**Step 8.3: Failure mode**
- Record: KASAN/NULL deref in IRQ handler → oops/panic. `[Severity:
  HIGH/CRITICAL]` for that path. `pcmuio_reset()` clears
  `PCMUIO_PAGE_ENAB` first, so a well-configured board is less likely to
  fire; wrong I/O/IRQ still makes pending-bit checks unsafe.

**Step 8.4: Risk-benefit**
- Record: Benefit: prevents IRQ-time oops on a reachable attach path.
  Risk: four lines, established pattern, no API/locking change. Ratio is
  favorable.

## Phase 9: Synthesis

**Step 9.1: Evidence**
- FOR: Real NULL deref in IRQ context; KASAN-class bug reported for this
  ISA attach pattern; maintainer-authored; 4-line check used across
  comedi; sibling parport fix had syzbot + stable CC; driver and race
  exist in this tree; no series dependency.
- AGAINST: Peripheral PC/104 driver; IRQ support commented “untested”;
  pcmuio not named in the original SNU list (same bug, extra driver); no
  `Fixes:`/`Cc: stable` on this commit (not a negative per the rules);
  attach is typically privileged.
- UNRESOLVED: stable@ thread 403; no mailing-list replies in the saved
  mbox.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — standard `dev->attached`
   guard; `IRQ_RETVAL` equivalent.
2. Real user-visible bug? **PASS** — NULL deref / oops if IRQ runs
   before subdevices exist.
3. Important (crash/security/corruption/deadlock)? **PASS** — IRQ-
   context oops.
4. Small and contained? **PASS** — +4/−1, one function.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS** — code is here; hunk is independent.

**Step 9.3: Exception category**
- Record: None needed; it is a normal crash fix.

**Step 9.4: Decision**
This tree is Linux 7.3.0-rc4. The pcmuio attach path registers
`pcmuio_interrupt` before `comedi_alloc_subdevices()`, so a premature
IRQ can take `dev->subdevices` while it is still NULL and oops in
`pcmuio_handle_intr_subdev()`. The patch is a four-line `dev->attached`
guard plus an equivalent `IRQ_RETVAL` return — the same pattern already
used throughout comedi, written by the subsystem maintainer after a
KASAN null-deref report on this ISA class. It is small, obviously
correct, and worth having on this tree.

Verification:
- [Phase 1] Parsed tags: Ian Abbott SOB, Greg KH SOB, lore Link; no
  Fixes/Cc stable/Reported-by on this commit
- [Phase 1] Cover letter (mbox MSG 7): explicit null-ptr-deref series
  for ISA IRQ handlers
- [Phase 2] Diff: +4/−1 in `pcmuio_interrupt()`; `IRQ_RETVAL` confirmed
  in `include/linux/irqreturn.h`
- [Phase 2] `pcmuio_attach()`: `request_irq` at 551/563,
  `comedi_alloc_subdevices` at 570
- [Phase 2] `comedi_device_postconfig()` sets `dev->attached = true`
  only after attach returns
- [Phase 3] blame: request_irq-before-alloc from `04426acfb86ad1` (2013)
- [Phase 3] `git merge-base --is-ancestor 6f6f6644e011f HEAD` → yes; not
  ancestor of v7.2; is ancestor of v7.3-rc1
- [Phase 4] `b4 dig -c 6f6f6644e011f`: patch 10/11, msgid
  20260618102949.26607-11
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: Greg KH + Hartley Sweeten
  + SNU reporters
- [Phase 4] Original report fetched: KASAN null-ptr-deref in ISA IRQ
  handlers; pcmuio not listed, same attach order
- [Phase 4] lore.kernel.org/stable 403 — UNVERIFIED stable@ discussion
- [Phase 5] only caller is `request_irq` in `pcmuio_attach`
- [Phase 6] local tree `v7.3-rc4-27-gf0100363d8c37` / 7.3.0-rc4; driver
  present
- [Phase 8] failure mode: NULL deref in IRQ handler → oops
- UNVERIFIED: whether anyone requested this exact hash on stable@

**YES**

 drivers/comedi/drivers/pcmuio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcmuio.c b/drivers/comedi/drivers/pcmuio.c
index 33b24dbbb9199..1c5fe065a91f5 100644
--- a/drivers/comedi/drivers/pcmuio.c
+++ b/drivers/comedi/drivers/pcmuio.c
@@ -362,12 +362,15 @@ static irqreturn_t pcmuio_interrupt(int irq, void *d)
 	struct pcmuio_private *devpriv = dev->private;
 	int handled = 0;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	if (irq == dev->irq)
 		handled += pcmuio_handle_asic_interrupt(dev, 0);
 	if (irq == devpriv->irq2)
 		handled += pcmuio_handle_asic_interrupt(dev, 1);
 
-	return handled ? IRQ_HANDLED : IRQ_NONE;
+	return IRQ_RETVAL(handled);
 }
 
 /* chip->spinlock is already locked */
-- 
2.53.0

