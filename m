Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5572A540224;
	Mon, 19 Oct 2026 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418726; cv=none; b=Z0hgUN654cvrDRpjVwycaaZb276y+ufVIj5hRLnX/sz3eo87acPUXRIuNwFNVIivEhpA9CiuP94+JXtFWnjlKJvEnARVLYWqLnq61z5+LGZF++r9y0Acz5sGlDrC3HSgUYCB2ayvbN7Wq5vJnFawaPyEaLfGkFU4eG0J0iOyb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418726; c=relaxed/simple;
	bh=acu1ft6C+y+p2XQIH0Z2WOsvf43amH/iugOjbXpoeQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrBRVRFHs318u2AEE1puAYpA1i1VpAzNg/Fj0PfhYJ3E8dRCxV+EQDaS6WETkxKx0ICuPm6PEg+laTsVMe1Os0vmM1Te6W8ljy5GyGzG7xOED+INRv6vraQaprIDI0Jw1TgXzvuzg43aohKhDR2BX5yq4wADdw3iT2L5jU74Dqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MrV43HjX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MrV43HjX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB121F000C6;
	Mon, 19 Oct 2026 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418723;
	bh=vVGFAxEjjO6wHBnFeFSFTIb+vP4QJ3gVq9BqxLaF28w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrV43HjXIhyrd1V03iskbam7SaPz1gBOZcrt6TJ3rEEbn+IZcsEI7Fb5UgDBh8CgG
	 XL3Be8fHqUtT1D10r0CL3boLUgQNh6wZ5fj2PYSS/BjmlzgIeSIF5sF6I44ZmwD/1Q
	 bQDivo8iitPwKqCbVYH9I3pjOm3dLJi8/3XvcExaPebT7gi4+wNYptiLZFUsCVtQ2s
	 req7YmycLCOnd+ICOadV+bNOXfWEEE6b0WWtUMEUtj3QTMfaUBc111sKwsCz5SGyrs
	 Im0uIBXUbDUTQ21F8z43zLdCFslp+XVbQ59SbHmmRSKrcQe+EONhJIAA6EIfV4F0OT
	 Aw/jhhQqdKyFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: pcm818: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:52:21 -0400
Message-ID: <20261019135441.1420968-450-sashal@kernel.org>
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

[ Upstream commit 956e8478261a575d1e87490f2e5db1788b8c209d ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real NULL-pointer dereference in an IRQ handler. The local
tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The driver and the
buggy pattern are present here; the 3-line reorder is a valid, self-
contained fix.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `comedi` (COMEDI data-acquisition; driver file is
  `pcl818.c`, Advantech PCL-818/PCL-718)
- Action verb: **Fix**
- Subject typo: `pcm818` vs actual `pcl818`
- Record: **[comedi] [fix] [reorder attached-flag check so interrupt
  handler does not deref a NULL subdevice]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- No `Fixes:` tag (expected for this review)
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:` / `Cc:
  stable` on this individual commit
- `Link:
  https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk`
  (patch 8/11 of a series)
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (COMEDI maintainer)
- `Signed-off-by: Greg Kroah-Hartman` (char-misc maintainer)
- Ignore pipeline `Signed-off-by: Sasha Levin` (none on this commit)
- Cover letter / sibling patches *do* carry `Reported-by: Jaeyoung
  Chung`, `Sangyun Kim`, `Kyungwook Boo` and a lore bug report
- Record: **maintainer-authored NULL-deref series; this patch omitted
  Reported-by but belongs to that report**

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Bug: IRQ is requested in attach before the device is fully set up
  (`dev->attached` still false; `dev->read_subdev` still NULL).
- The handler already tests `dev->attached`, but only after
  `s->async->cmd` (message says `dev->read_dev`; the code is
  `dev->read_subdev`).
- Failure mode: NULL pointer dereference / GPF in interrupt context.
- Record: **[premature IRQ during attach] [kernel oops/GPF] [no version
  pin] [root cause: check after dereference]**

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: **Not hidden. Explicit NULL-deref fix.**

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/comedi/drivers/pcl818.c` (+2 / −1)
- Function: `pcl818_interrupt()`
- Record: **single-file surgical fix, 3 lines**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Before:
  ```c
  struct comedi_subdevice *s = dev->read_subdev;
  struct comedi_cmd *cmd = &s->async->cmd;  /* deref if s NULL */
  if (!dev->attached || !devpriv->ai_cmd_running) {
  pcl818_ai_clear_eoc(dev);
  return IRQ_HANDLED;
  }
  ```
- After: declare `cmd`, run the attached/`ai_cmd_running` check, then
  `cmd = &s->async->cmd`.
- Path: IRQ during attach (and any other time `attached` is false).
- Record: **eager `s->async->cmd` init moved after the existing safety
  check**

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Category: **NULL pointer dereference (memory safety)**
- Mechanism: `request_irq()` in `pcl818_attach()` (~line 1020) runs
  before `dev->read_subdev = s` (~1073) and before the core sets
  `dev->attached = true` in `comedi_device_postconfig()`
  (`drivers/comedi/drivers.c:833`).
- `s = dev->read_subdev` can be NULL; `&s->async->cmd` then GPFs.
- `if (!dev->attached || !devpriv->ai_cmd_running)` short-circuits, so
  `devpriv` is not dereferenced when unattached; the `cmd` line was the
  actual hole.
- Record: **NULL deref of `read_subdev`/`async` in IRQ; fix is check-
  before-use**

**Step 2.4: ASSESS THE FIX QUALITY**
- Obviously correct: `cmd` is only used in the `ai_cmd_canceled` path
  after the check.
- Minimal; no API/locking/struct changes.
- Residual risk: if `attached` were true with `read_subdev` still NULL,
  the later deref could still fault. Attach sets `read_subdev` whenever
  `dev->irq` is set, and `attached` is set only after attach+postconfig
  succeed, so that is not a regression from this patch.
- Record: **high quality, very low regression risk**

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Driver added: `4da6a1d8f56f0` (2009, staging)
- `s = dev->read_subdev`: `6c42119d3d9d0f` (2014)
- Buggy `cmd = &s->async->cmd`: `c76844e1ffd750` (2014-11-05, “use
  comedi_async scans_done”)
- Attached check: `799f89cee3525c` (2014-03)
- `request_irq` before full setup: original attach flow
- Record: **buggy init since ~v3.19 (`c76844e1ffd750`); driver long-
  lived; bug is old, not post-7.3**

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: **N/A — no Fixes: tag**

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Related: `a51f025b5038a` (2025) fixed a different NULL deref in
  `pcl818_ai_cancel()` on detach (already in this tree).
- Same author series: pcl711/pcl816/dt2811/ni_at_a2150/etc. —
  independent per-driver patches.
- Record: **standalone; sibling series patches not required**

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Ian Abbott is listed in MAINTAINERS for COMEDI DRIVERS (`M: Ian Abbott
  <abbotti@mev.co.uk>`).
- Record: **subsystem maintainer; authored the whole 11-patch IRQ sanity
  series**

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Uses existing `dev->attached`, `read_subdev`, `pcl818_interrupt`.
- Record: **no prerequisites; applies standalone**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- `b4 dig -c 956e8478261a575d1e87490f2e5db1788b8c209d` →
  https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk
- `b4 dig -a`: **v1 only** (no v2/v3)
- Cover letter: `comedi: Add/fix sanity check in ISA drivers to avoid
  null-ptr-deref`
- Bug report: https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/ (Jaeyoung Chung, 2026-06-10) — KASAN NULL deref
  when ISA handlers run after `request_irq` and before `read_subdev` is
  set
- pcl818 was not named in the original report; maintainer included it as
  the same pattern
- No NAKs found in the saved thread (mbox was patches only, no review
  replies)
- Record: **v1 merged by gregkh; no NAKs observed; motivated by a real
  KASAN report**

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- `b4 dig -w`: Ian Abbott, Greg Kroah-Hartman, H Hartley Sweeten (other
  COMEDI maintainer), linux-kernel, plus the reporters
- Merged via `char-misc-7.3-rc1`
- Record: **maintainers were on CC; gregkh applied it**

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Academic/KASAN report of this class of bugs (June 2026)
- Syzbot: https://syzkaller.appspot.com/bug?extid=6a96a97dde2916ce0c75 —
  **GPF in `pcl818_interrupt`**, KASAN null-ptr-deref, RIP
  `pcl818.c:537` (`cmd = &s->async->cmd`), call chain `request_irq` →
  `pcl818_attach` → `comedi_device_attach` → `COMEDI_DEVCONFIG` ioctl
- Crash kernel `f5098b6bae76` does **not** contain this fix (`git merge-
  base --is-ancestor` failed)
- Syzbot labels: DoS yes, unprivileged no (matches `CAP_SYS_ADMIN` on
  `do_devconfig_ioctl`)
- Record: **syzbot reproduced this exact GPF on unfixed upstream;
  privileged ioctl trigger**

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- 11 independent driver patches; this one only touches `pcl818.c`
- Record: **self-contained; other series patches not needed for this
  driver**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Web search of lore.kernel.org/stable for this subject did not return a
  relevant thread
- Record: **UNVERIFIED: no stable-list discussion found (lore.kernel.org
  fetch returned 403)**

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: **`pcl818_interrupt` (modified); callers `request_irq` from
  `pcl818_attach`**

**Step 5.2: TRACE CALLERS**
- Registered at `pcl818_attach()` when `it->options[1]` is IRQ 2–7
- Invoked from hardirq (`handle_irq_event` in the syzbot trace)
- Attach itself is reached from `comedi_device_attach()` ←
  `do_devconfig_ioctl()` (`CAP_SYS_ADMIN`)
- Record: **IRQ context; attach is a privileged ioctl, reachable from
  syzbot/root**

**Step 5.3: TRACE CALLEES**
- After the check: `pcl818_handle_dma/fifo/eoc`, `pcl818_ai_clear_eoc`
  (`outb` to status), `comedi_handle_events`
- Early path still calls `pcl818_ai_clear_eoc` (pre-existing; iobase is
  claimed before `request_irq`)
- Record: **I/O + async command handling after the device is attached**

**Step 5.4: FOLLOW THE CALL CHAIN**
- Userspace ioctl (root) → attach → `request_irq` → spurious/shared IRQ
  → handler with `read_subdev == NULL`
- Record: **reachable from userspace with CAP_SYS_ADMIN; syzbot hit it**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Same-series fixes in pcl711, pcl816, dt2811, ni_at_a2150, das6402,
  aio_iiro_16, pcmmio, pcmuio, quatech_daqp_cs
- Record: **systematic ISA-driver bug class; this is one instance**

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Local tree: **7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`)
- `drivers/comedi/drivers/pcl818.c` exists; current handler already has
  the post-check assignment (commit is ancestor of HEAD)
- Pre-fix code is the parent of `956e8478261a5`; same
  file/function/pattern
- Bug introduced ~2014, still present until this 2026 commit
- Record: **yes — driver and bug belong in this tree; fix is already
  applied here**

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- 3-line change against a stable function layout (handler structure
  dates to 2014)
- Record: **clean apply (already applied in this checkout)**

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- `a51f025b5038a` is a different cancel/detach NULL deref, already
  present; does not replace this IRQ-handler fix
- No later revert of this commit (`git log 956e8478261a5..HEAD --
  drivers/comedi/drivers/pcl818.c` empty)
- Record: **no substitute fix; this is the IRQ-path fix**

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: **[comedi / Advantech PCL-818 ISA DAQ] [PERIPHERAL]** —
  optional `CONFIG_COMEDI_PCL818`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Status in MAINTAINERS: **Odd Fixes**
- Burst of IRQ sanity patches in June 2026; otherwise mature
- Record: **mature/low-churn driver; long-standing bug**

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: **config/driver-specific** — users of `CONFIG_COMEDI` +
  `CONFIG_COMEDI_PCL818` (legacy ISA DAQ). Syzbot/configs that enable
  comedi also hit it.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Window: after `request_irq` in attach, before `attached` is set
- Trigger: IRQ during that window (wrong I/O/IRQ, shared IRQ, or fuzzer-
  driven attach as syzbot did)
- Not unprivileged (`CAP_SYS_ADMIN` for `COMEDI_DEVCONFIG`)
- Record: **narrow window but proven; privileged userspace can oops the
  kernel**

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- KASAN NULL deref / GPF / Oops in hardirq
- Syzbot: DenialOfService
- Record: **[kernel oops in IRQ] [HIGH]** — crash, not silent
  corruption; not a core-mm path so not universal CRITICAL

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Benefit: prevents a real GPF on a driver that exists in this tree;
  syzbot + code inspection agree
- Risk: 3-line reorder, no locking/API change
- Record: **benefit HIGH for affected configs; risk VERY LOW; ratio
  strongly favors the fix**

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real NULL deref in interrupt context
- Syzbot GPF in `pcl818_interrupt` on a kernel without this commit
- Same class reported by Chung/Kim/Boo with KASAN
- 3-line, obviously correct reorder
- Maintainer-authored; merged by gregkh
- Code exists in this 7.3-rc4 tree; bug is old
- Standalone; no new API/feature

AGAINST:
- Peripheral ISA DAQ driver, “Odd Fixes”
- Attach requires `CAP_SYS_ADMIN`
- Race window is attach-time only
- This patch’s own message omitted Reported-by/Fixes/Cc: stable (not a
  negative per the rules)

UNRESOLVED:
- No stable-list thread found (lore 403)
- No review replies in the b4-saved mbox (gregkh still applied it)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — check-before-use; syzbot
   crash matches the old line
2. Fixes a real bug that affects users? **PASS** — oops on attach/IRQ
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   IRQ-context oops/GPF (HIGH)
4. Small and contained? **PASS** — 3 lines, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — file/function present;
   already applied cleanly

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: **not an ID/quirk/DT/build/docs exception; it is a normal
  crash fix**

**Step 9.4: MAKE YOUR DECISION**
This tree contains `pcl818` and the long-standing IRQ-handler hole. The
patch is a minimal, correct NULL-deref fix with a concrete oops (syzbot
+ static analysis). That meets stable criteria for **this** checkout.

---

### What the commit solves and why it matters here
`pcl818_attach()` calls `request_irq()` before `read_subdev` is set and
before the comedi core sets `dev->attached`. A handler that still does
`cmd = &s->async->cmd` first will GPF if an IRQ arrives in that window.
This tree has that driver; syzbot oopsed the unfixed code via
`COMEDI_DEVCONFIG`. Moving the dereference after the existing
`dev->attached` check closes the hole without changing behavior on the
normal path.

### Risk vs benefit
Benefit is avoiding an IRQ-context oops. Risk is negligible: `cmd` is
unused until after the check.

### Concerns
None that block backport: no series dependency, no structural
prerequisites, subject/body typos only (`pcm818`/`read_dev`). Trigger
needs comedi + this ISA driver + `CAP_SYS_ADMIN`, but the failure is
still a kernel oops.

### Verification
- [Phase 1] Parsed commit `956e8478261a575d1e87490f2e5db1788b8c209d`;
  tags: Link msgid `-9`, SOB Ian Abbott + gregkh; no
  Fixes/Cc:stable/Reported-by on this patch
- [Phase 2] Diff: `pcl818_interrupt` in
  `drivers/comedi/drivers/pcl818.c`, +2/−1; `cmd = &s->async->cmd` moved
  after `dev->attached` check
- [Phase 2] Confirmed `request_irq` at ~1020 and `dev->read_subdev = s`
  at ~1073; `dev->attached = true` only in `comedi_device_postconfig()`
  (`drivers.c:833`) after `driv->attach()`
- [Phase 3] Blame: buggy `cmd` init `c76844e1ffd750` (2014-11); attached
  check `799f89cee3525c` (2014-03)
- [Phase 3] No Fixes: tag; later `a51f025b5038a` is a different
  cancel/detach NULL deref
- [Phase 4] `b4 dig -c`: thread
  https://patch.msgid.link/20260618102949.26607-9-abbotti@mev.co.uk ;
  `-a`: v1 only; `-w`: Abbott, Sweeten, gregkh, reporters
- [Phase 4] Cover letter + Jaeyoung Chung report (KASAN early-IRQ NULL
  deref class)
- [Phase 4] Syzbot GPF in `pcl818_interrupt` extid=6a96a97dde2916ce0c75;
  kernel `f5098b6bae76` does not contain this fix (ancestor check exit
  1)
- [Phase 4] lore.kernel.org WebFetch 403; used b4 mbox +
  lkml.iu.edu/openwall mirrors
- [Phase 5] Caller: `pcl818_attach` via `comedi_device_attach` /
  `do_devconfig_ioctl`; `CAP_SYS_ADMIN` at `comedi_fops.c:892`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = 7.3.0-rc4; commit is ancestor of HEAD; current file
  has the fixed handler
- [Phase 7] MAINTAINERS: COMEDI, Ian Abbott; Kconfig
  `CONFIG_COMEDI_PCL818`
- [Phase 8] Failure: KASAN null-ptr-deref / GPF in hardirq; severity
  HIGH
- UNVERIFIED: stable@ mailing-list discussion (no relevant hit; lore
  403)

The fix is small, surgical, and meets the stable rules for this tree.

**YES**

 drivers/comedi/drivers/pcl818.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl818.c b/drivers/comedi/drivers/pcl818.c
index 06fe06396f23a..e8ce34840050a 100644
--- a/drivers/comedi/drivers/pcl818.c
+++ b/drivers/comedi/drivers/pcl818.c
@@ -534,13 +534,14 @@ static irqreturn_t pcl818_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct pcl818_private *devpriv = dev->private;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 
 	if (!dev->attached || !devpriv->ai_cmd_running) {
 		pcl818_ai_clear_eoc(dev);
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	if (devpriv->ai_cmd_canceled) {
 		/*
 		 * The cleanup from ai_cancel() has been delayed
-- 
2.53.0

