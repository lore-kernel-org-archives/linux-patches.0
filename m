Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BA2645085;
	Mon, 19 Oct 2026 14:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418798; cv=none; b=qtpJrGPXTBIwJ702b2Gj9/O2T9tn/A4NLtZf6gDD/KocNwzB8zKa04zQiu37SSAjc9oIRPRczcoFzhh/z71zww/l7bOA4XZNjwoR3AjWG4ojZnpzV1ZUZIiSP29NotxxWJG2rAPrnnkt1vqk/pT4U+yqBzrRqgfrQzpNBSAsWzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418798; c=relaxed/simple;
	bh=iQVJa5cpqjNqS+F9c6wC92Lh+Q1jXpYKZlZOVm9tXrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HJOzTHjfZ0mEmHXku44A0i5o80r9+KqBwYIlfnl3XOW1Df7j3BoyIaQlaXHLUX3QNppIsu5NvdEmI2U/PheubclzMAOm/51FT1OyolbCF74ayUe4HMjatPz5ARaLMpvxV0du6o1EFnzIdYQOXT1r3TABndAWSnVoPOc2B75uzQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mR5A9Sic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mR5A9Sic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A081F000C4;
	Mon, 19 Oct 2026 14:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418795;
	bh=ScaDSuke4tuvphNZSd0GKlSCBp0xpRUmHyEoy+AUDWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mR5A9SicnnhzVX1gMXOmuJrExEUiga7i3Fn6hMwX6RaqDKUqrzorqBwPDk30eDf38
	 b+iyLUBM2WW3m7D9CUdmk9a5lmwHkv6/gHk/OMLufczRMftXESBgwOoMyV11EJtpov
	 9KONuTccIAoejYwmssoTK/I7RuN91tEvMqccHNdsfxECAe91PCUDM5nXWo7jfOWAI9
	 dNLaN3gUocG1kh7YLbmZre5GyCgGiDbzhipqyzu7qj97MCrP5fuK+g24KTbcqkcGBS
	 vHyERuENhHqgUgQAYNJnyO6Sk/Aa+OqOiLeEOAJvA2NrHYgws3fFT3LPDWsQCwl1T+
	 8V7gxJyDV+1JA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: pcm816: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:53:13 -0400
Message-ID: <20261019135441.1420968-502-sashal@kernel.org>
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

[ Upstream commit 4fdac5090ce3616283216d9a1d2b9664e8e20747 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the devpriv->dma pointer which may be NULL if
dev->attached is false.  Move the dereference of the devpriv->dma
pointer after dev->attached has been checked to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline 7.3.0-rc4). The change is a
3-line IRQ-handler NULL-deref fix in the existing `pcl816` driver; the
buggy pattern has been in-tree since v4.0.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[comedi / pcl816]** **[Fix]** sanity check in interrupt
handler (subject says “pcm816”; the file is `pcl816.c`). Intent: stop a
NULL dereference of `devpriv->dma` in `pcl816_interrupt()` when the IRQ
fires before attach completes.

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none on this patch itself
- **Tested-by:** none
- **Reviewed-by:** none
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Ian Abbott (author; COMEDI maintainer), Greg Kroah-
  Hartman (char-misc)
- Ignored pipeline SOBs: none of Sasha Levin’s appear on the real commit
  `4fdac5090ce36`

Cover-letter CC list (from `b4 dig -w`) also included H Hartley Sweeten
and the SNU reporters Jaeyoung Chung, Sangyun Kim, Kyungwook Boo. Those
reporters are on the series, not as `Reported-by:` on this specific
patch.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** IRQ handler is registered in `pcl816_alloc_irq_and_dma()`
  during `pcl816_attach()`, before `dev->attached` is set (that happens
  later in `comedi_device_postconfig()`).
- **Symptom/failure mode:** NULL pointer dereference of `devpriv->dma` →
  kernel oops in IRQ context.
- **Version information:** none in the message. History shows the DMA
  deref dates to 2015 (`bd7ea421e3f975`, in v4.0-rc1).
- **Root cause:** the existing `dev->attached` guard runs *after*
  `&dma->desc[dma->cur_dma]`. Between `request_irq()` and
  `comedi_isadma_alloc()`, `dma` is NULL.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. The subject and body explicitly describe a NULL-
deref fix. Not cleanup/refactor.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/comedi/drivers/pcl816.c` (+2/−1; 3 lines)
- **Function:** `pcl816_interrupt()`
- **Scope:** single-file surgical fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: **Before:** `desc = &dma->desc[dma->cur_dma]` at declaration
time, then `if (!dev->attached || !devpriv->ai_cmd_running) return;`.
**After:** `desc` is uninitialized until after that guard, then
assigned. Early-exit path (not attached, or command not running) no
longer touches `dma->desc`. Normal command-complete IRQ path is
unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Category (d) memory safety / NULL pointer dereference.** `dma`
is NULL in the window after `request_irq()` and before
`comedi_isadma_alloc()` (and again if alloc fails, until `free_irq()`).
Old code unconditionally indexed `dma->desc[]`. New code only does that
after `dev->attached` is true *and* `ai_cmd_running` is set, which only
happens from `pcl816_ai_cmd()` after DMA was successfully allocated.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct: reorder a dereference past an existing guard.
No API, locking, or control-flow change on the success path. `desc` is
not used on the early-return paths, so no uninitialized use. Regression
risk is very low.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: Unconditional `desc = &dma->desc[dma->cur_dma]` came from
**`bd7ea421e3f975`** (“staging: comedi: pcl816: remove depends on
ISA_DMA_API limitation”, 2015-01-17), first in **v4.0-rc1**. The
`dev->attached` check is older (`b619f5aabd1db6`, 2014). The 2015 ISA-
DMA conversion placed the new deref *above* that check. Bug has been
present for ~11 years.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Inferred buggy commit is `bd7ea421e3f975`. `git
merge-base --is-ancestor 4fdac5090ce36 HEAD` succeeds; the fix commit is
already an ancestor of this 7.3-rc4 checkout.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `pcl816.c` commits are this fix and `55e39df167cbe` (I/O
base sanity). Same-author series of independent IRQ-guard patches in
sibling drivers (`pcl711`, `pcl818`, `das6402`, …). This patch does not
depend on those other files.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Ian Abbott is the COMEDI maintainer. This is patch **07/11** of
his “Add/fix sanity check in ISA drivers to avoid null-ptr-deref”
series, merged via Greg KH’s char-misc tree.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Standalone. Only uses `dev->attached`, `devpriv->dma`, and
`pcl816_interrupt()`, all present here. No new helpers. Sibling series
patches are per-driver and not required for this hunk.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **Lore/msgid:**
  https://patch.msgid.link/20260618102949.26607-8-abbotti@mev.co.uk
- **Cover:** “comedi: Add/fix sanity check in ISA drivers to avoid null-
  ptr-deref” (`20260618102949.26607-1`)
- **`b4 dig -a`:** only **v1**; no later revisions. Mbox has the 11
  patches + cover, **no replies, no NAKs**.
- Direct lore.kernel.org fetch returned HTTP 403; content confirmed via
  `b4 dig` mbox, openwall, and lkml.iu.edu mirrors.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients were Ian Abbott, Greg KH, H Hartley Sweeten, linux-
kernel, and the SNU reporters. Greg signed it into char-misc. No on-list
NAK. No explicit `Cc: stable` in review (there was no review thread
beyond the submission).

Step 4.3: SEARCH FOR THE BUG REPORT
Record: Original report: Jaeyoung Chung, “comedi: KASAN null-ptr-deref
in ISA driver IRQ handlers on early IRQ”
(https://lists.openwall.net/linux-kernel/2026/06/10/1184), Reported-by
Sangyun Kim and Kyungwook Boo. They described KASAN NULL-deref if an IRQ
arrives after `request_irq()` and before `read_subdev`/subdevice setup.
They listed das6402, ni_atmio16d, aio_iiro_16, pcmmio, comedi_parport,
pcl711. **pcl816 was not in that list**; Abbott found the same class of
bug there (attached check exists but is too late because DMA is
dereferenced first).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 11 independent driver patches. This one only edits `pcl816.c`.
No functional dependency on 01–06 or 08–11.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No stable@ discussion found (lore.kernel.org/stable search not
usable here due to 403; no mention in the patch thread). UNVERIFIED
whether anyone already requested this on stable@.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `pcl816_interrupt()` only.

Step 5.2: TRACE CALLERS
Record: Registered only from `pcl816_alloc_irq_and_dma()` via
`request_irq(irq_num, pcl816_interrupt, ...)`. IRQ context. Called when
the Advantech PCL-814/816 (or a spurious/shared ISA IRQ) fires.

Step 5.3: TRACE CALLEES
Record: After the guard: `comedi_bytes_to_samples`,
`pcl816_ai_setup_dma`, `transfer_from_dma_buf`, `pcl816_ai_clear_eoc`,
`comedi_handle_events`. Early path only `pcl816_ai_clear_eoc`. No
alloc/lock added.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace `COMEDI_DEVCONFIG` / attach → `pcl816_attach()` →
`pcl816_alloc_irq_and_dma()` → `request_irq()`. `dev->attached` is set
only later in `comedi_device_postconfig()`
(`drivers/comedi/drivers.c:833`). A premature hardware IRQ in that
window is reachable. Not a syscall hot path; it is bind/attach plus IRQ.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same reorder/guard applied in `pcl711.c`, `pcl818.c`,
`ni_at_a2150.c`, `dt2811.c`, `quatech_daqp_cs.c`; other drivers in the
series add a missing `dev->attached` check. Systematic ISA-COMEDI issue,
not a one-off.

Semcode tools: not available; used grep/read instead.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes, the driver and IRQ/DMA attach sequence exist.** Current
`pcl816_interrupt()` already contains the post-fix form because
`4fdac5090ce36` is an ancestor of HEAD. Pre-fix form (verified with `git
show 4fdac5090ce36^:drivers/comedi/drivers/pcl816.c`) had the deref
before the guard. Bug introduced in v4.0-rc1; driver left staging in
v5.13 (`8ffdff6a8cfbd`).

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Hunk is three lines in a long-stable function. Expected apply:
**clean** on any tree that still has this `pcl816_interrupt()` shape
(i.e. trees with this driver since the 2015 DMA conversion).

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This exact fix is already on HEAD. No alternate/earlier fix of
the DMA-deref-before-attached bug. I/O-base check `55e39df167cbe` is
unrelated.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drivers/comedi** (data-acquisition). **PERIPHERAL** —
`CONFIG_COMEDI_PCL816` (“Advantech PCL-814 and PCL-816 ISA card
support”). Not mm/net/fs core, but a real in-tree (non-staging since
5.13) driver.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature. File history is sparse; recent work is this IRQ-guard
series plus I/O sanity checks. Bug is old, not a new-subsystem issue.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific:** users of
`CONFIG_COMEDI_PCL816` with Advantech PCL-814/816 ISA cards (or a
colliding ISA IRQ during attach).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Attach/config of the board: `request_irq()` then DMA alloc, then
subdevice setup, then `dev->attached = true`. Trigger is a premature IRQ
in that window. Not every boot; not unprivileged syscall spray without
the device. Shared/spurious ISA IRQs and leftover device IRQ state make
the window realistic. Researchers reported KASAN NPD for this class on
related drivers.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **NULL deref in IRQ handler → oops/panic. Severity: HIGH**
(crash). Not silent corruption. Limited to attach of this ISA DAQ card.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium for those users (prevents oops); low population.
- **Risk:** very low (3-line reorder, existing guard).
- **Ratio:** benefit outweighs risk. Matches the common stable pattern
  of small NPD fixes in drivers.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real NULL deref in an IRQ handler (oops).
- Same class as a KASAN-described premature-IRQ bug reported by
  Chung/Kim/Boo (2026-06-10); maintainer confirmed pcl816 has the late-
  guard variant.
- Tiny, obviously correct reorder; no new API/feature.
- Standalone; no series dependencies.
- Bug present since v4.0; driver exists in this tree.
- Author is the COMEDI maintainer; merged by Greg KH.

**AGAINST backporting:**
- Niche ISA DAQ hardware; small user base.
- Race is during attach, not a hot path.
- pcl816 was not named in the original report (maintainer-found
  sibling).
- No `Fixes:` / `Cc: stable` on the commit (not a negative per the
  review rules).

**UNRESOLVED:**
- Could not read lore.kernel.org or stable@ directly (HTTP 403). Content
  recovered from `b4` mbox and public mirrors.
- No on-list review comments exist to quote.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reorder past an existing
   guard; merged to mainline via char-misc.
2. Fixes a real bug that affects users? **PASS** — NPD if IRQ fires
   before DMA/`attached` setup.
3. Important issue? **PASS** — kernel oops in IRQ context (HIGH, not
   core-universal CRITICAL).
4. Small and contained? **PASS** — 3 lines, one function, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code is present; hunk matches
   this `pcl816_interrupt()`.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None of device-ID / quirk / DT / build / docs. It is a normal
crash-fix.

Step 9.4: MAKE YOUR DECISION

This tree is **7.3-rc4 mainline**. The driver and the attach/IRQ race
exist here; the fix is already on HEAD, which does not make it a
“prepared candidate” — it is the mainline source of a stable-worthy
crash fix.

The patch prevents a NULL deref in `pcl816_interrupt()` when a premature
IRQ hits after `request_irq()` and before `devpriv->dma` is allocated.
That is a real oops, the change is three lines and self-contained, and
it does not need the rest of the 11-patch series. Niche hardware lowers
breadth, not the fact of the bug.

Verification:
- [Phase 1] Parsed subject/tags: no Fixes/Cc-stable/Reported-by on this
  commit; Link msgid `20260618102949.26607-8`; author Ian Abbott,
  committer Greg KH
- [Phase 1] Cover letter: series is “avoid null-ptr-deref”; this is
  07/11
- [Phase 2] Diff: `pcl816_interrupt()` moves `desc =
  &dma->desc[dma->cur_dma]` below `if (!dev->attached ||
  !devpriv->ai_cmd_running)`
- [Phase 2] Confirmed `pcl816_alloc_irq_and_dma()` does `request_irq`
  then `comedi_isadma_alloc`; DMA can be NULL in that window
- [Phase 2] Confirmed `dev->attached = true` only in
  `comedi_device_postconfig()` after `attach()` returns
- [Phase 3] `git blame`: DMA deref from `bd7ea421e3f975` (v4.0-rc1,
  2015); attached check from `b619f5aabd1db6` (2014)
- [Phase 3] `git merge-base --is-ancestor 4fdac5090ce36 HEAD`: IS
  ancestor
- [Phase 3] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 3] No prerequisite commits; sibling patches are other files
- [Phase 4] `b4 dig -c 4fdac5090ce36`: matched msgid …-8; `b4 dig -a`:
  v1 only; `b4 dig -w`: Abbott, Greg KH, Sweeten, SNU reporters
- [Phase 4] mbox: 12 messages, all from Abbott, no replies/NAKs
- [Phase 4] Original report (openwall 2026/06/10/1184): KASAN NPD on
  early IRQ in related comedi ISA drivers; pcl816 not listed there
- [Phase 4] lore.kernel.org WebFetch: HTTP 403
- [Phase 5] Only caller of `pcl816_interrupt` is `request_irq` in this
  file; `ai_cmd_running` set only in `pcl816_ai_cmd` after DMA setup
- [Phase 5] semcode: unavailable
- [Phase 6] Pre-fix code verified via `git show 4fdac5090ce36^:...`;
  current file has the fix
- [Phase 6] `CONFIG_COMEDI_PCL816` present in `drivers/comedi/Kconfig`
- [Phase 7] Driver left staging in `8ffdff6a8cfbd` (v5.13 era)
- [Phase 8] Failure mode: IRQ-context NULL deref → oops; trigger:
  premature IRQ during attach
- UNVERIFIED: stable@ mailing list discussion (lore/stable unreachable)

**YES**

 drivers/comedi/drivers/pcl816.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl816.c b/drivers/comedi/drivers/pcl816.c
index 28d1a88c50f65..3c295647e2ed5 100644
--- a/drivers/comedi/drivers/pcl816.c
+++ b/drivers/comedi/drivers/pcl816.c
@@ -242,7 +242,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	struct pcl816_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[dma->cur_dma];
+	struct comedi_isadma_desc *desc;
 	unsigned int nsamples;
 	unsigned int bufptr;
 
@@ -257,6 +257,7 @@ static irqreturn_t pcl816_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	desc = &dma->desc[dma->cur_dma];
 	nsamples = comedi_bytes_to_samples(s, desc->size) -
 		   devpriv->ai_poll_ptr;
 	bufptr = devpriv->ai_poll_ptr;
-- 
2.53.0

