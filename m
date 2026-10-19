Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E5A5D18DF;
	Mon, 19 Oct 2026 14:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418493; cv=none; b=H4GLApeTOK6Wth0htJ1JoxS2SQoMDyhak8tR0c8xi6xHodyL4UrVR4K61WtPBx1moQSstmi5QHPvesQdEN0JauPByRdgWWAoDUQ3fIJIdGt40SEE2dLtf4t9QGIpj5FwE+HSaJ+Pr4Jh//DIfLiBCsHl/EQmr0JXhvHif+FRZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418493; c=relaxed/simple;
	bh=tF2h+slp+mYt6nWU5GXtnDi27H6BUcMfXLpk4rOJukA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oMzoB4EqW40cyCwMGvcl1Mo4WHt9r1XJX7+BP2jP37+ZrIFavSVs9BZQmwqYi2yX6whWO5SXFDuyPuY1wFMA7t22zRn00zT5t57Nm/RoF9TNtZ/kRlKhuijBV4+yYyPedmT63P4qm+YT0YSV8uYLuMmNO+9STPeTpVYG9vt5uLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjcgDdZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjcgDdZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FBD1F000CB;
	Mon, 19 Oct 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418491;
	bh=9srQrdCZMoRLFkutGZ67T1/tsebmKZ6eRD+DmvGcDX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VjcgDdZcYCbcuFoB6WoYyeKOYfVxzr+096jOsVjhoh014LXS1sB0z14V378psKXU8
	 gKXEyU6AHstGpnkdoNBlwoq1KJ+7fE8UsCNefc4+nfScwcJ/iCOgpzaEIGo/DYVqkT
	 uXwJRdaW9ok5r223+vEI+Uk3l22QylDKxIF9tL9CpJ5QZ08VnruyxQq40aAFSe0F8i
	 gyENlMdrB2E3JlCUIATjW5Agy1GdHdkc+zi5oICDF5LS2w4MENNdy3MwkEID+pJkYB
	 LrSnH6EcGASiWBR60a/gjtkHiccbBknFpXh2L0mY/AMk5qWV11AtlHWDNaDW8Y8Soh
	 XfPR99ziFR19Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: quatech_daqp_cs: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:49:37 -0400
Message-ID: <20261019135441.1420968-286-sashal@kernel.org>
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

[ Upstream commit 1bc9538df6be8dac8727179d8bcc0d880648361b ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the attach/IRQ window, the original KASAN report, and the 4-line
reorder; compiling that against this 7.3-rc4 tree next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[comedi: quatech_daqp_cs] [Fix] [sanity check in interrupt
handler is performed after a possible NULL deref]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` — COMEDI maintainer
  (author)
- `Link:
  https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk` —
  lore/patch-id; msgid `-12` is cover+11 patches (this is 11/11)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>` —
  char-misc maintainer
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` on the commit itself (absence of Fixes/Cc-stable
  is expected)

Cover-letter CC (from b4, not the commit): Jaeyoung Chung, Sangyun Kim,
Kyungwook Boo (SNU) — original reporters of the sibling ISA-driver bugs.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** IRQ handler is registered before the device is fully set up.
  The `dev->attached` guard exists but runs *after* `dev->read_subdev`
  is used.
- **Symptom/failure mode:** NULL pointer dereference in interrupt
  context (kernel oops/panic). Message says `dev->read_dev`; actual
  field is `dev->read_subdev` (typo in the message, verified in source).
- **Version info:** none in the commit.
- **Root cause:** local initializer `cmd = &s->async->cmd` evaluates at
  function entry, before `if (!dev->attached)`.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not hidden. Explicit NULL-deref fix; “sanity check” here means
reorder of an existing guard.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/comedi/drivers/quatech_daqp_cs.c` — +3 / −1
- Function: `daqp_interrupt()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record (verified against `1bc9538df6be8^` and current file):

Before:
```c
struct comedi_subdevice *s = dev->read_subdev;
struct comedi_cmd *cmd = &s->async->cmd;  /* deref s immediately */
...
if (!dev->attached)
    return IRQ_NONE;
```

After:
```c
struct comedi_subdevice *s = dev->read_subdev;  /* pointer copy only */
struct comedi_cmd *cmd;
...
if (!dev->attached)
    return IRQ_NONE;
cmd = &s->async->cmd;  /* only after attached */
```

Path: interrupt handler, probe/early-IRQ window (and analogously
detach).

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **NULL pointer dereference** in IRQ context. `s` is NULL until
`dev->read_subdev` is assigned in `daqp_auto_attach()` (line 734), which
is *after* `pcmcia_request_irq()` (line 718). `dev->attached` is set
only later in `comedi_device_postconfig()`
(`drivers/comedi/drivers.c:833`). C evaluates the `cmd` initializer at
block entry, so the attached check never ran in time.

**Step 2.4: ASSESS THE FIX QUALITY**

Record: Obviously correct reorder; no API/locking/behavior change on the
normal path. Residual `s = dev->read_subdev` before the check is a
pointer copy, not a deref. Regression risk: very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- `s = dev->read_subdev` and `if (!dev->attached)`: `c12717423e1c61`
  (2013-02, contained in **v3.9-rc1**)
- Buggy `cmd = &s->async->cmd`: `2d7840c70dcf52` “use comedi_async
  'scans_done' to detect EOA” (2014-11, contained in **v3.19-rc1**)
- Driver itself: `62ed666238aba1` (2009)

Long-standing bug, not new-subsystem code.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. Buggy commit identified by blame:
`2d7840c70dcf52`. That history is in this tree.

**Step 3.3: CHECK FILE HISTORY**

Record: After this fix, only older moves (`df0e68c1e9945` headers,
`8ffdff6a8cfbd` out of staging). No conflicting refactors. Standalone vs
this file.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Ian Abbott is listed in MAINTAINERS for COMEDI (`S: Odd Fixes`).
Same-day series of 11 independent IRQ-guard fixes (aio_iiro_16, das6402,
dt2811, ni_at_a2150, ni_atmio16d, pcl711, pcl816, pcl818, pcmmio,
pcmuio, this one).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: No functional dependency on the other 10; each driver is self-
contained. `dev->attached` / `read_subdev` / `s->async->cmd` all exist
here. Can apply standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 1bc9538df6be8`:
  https://patch.msgid.link/20260618102949.26607-12-abbotti@mev.co.uk
- `b4 dig -a`: **v1 only**, `[PATCH 11/11]`
- Cover: “comedi: Add/fix sanity check in ISA drivers to avoid null-ptr-
  deref”
- Original report [1]: https://lore.kernel.org/lkml/20260610115912.78013
  1-1-jjy600901@snu.ac.kr/ — subject “KASAN null-ptr-deref in ISA driver
  IRQ handlers on early IRQ”
- No NAKs in the saved series mbox (12 messages: cover + 11 patches, no
  replies)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc linux-kernel, Greg KH, Ian Abbott, H Hartley
Sweeten, SNU reporters. No extra Reviewed-by. Applied by Greg KH.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record (from `/tmp/snu-report/...mbx`): Jaeyoung Chung / Sangyun Kim /
Kyungwook Boo. KASAN NULL deref if IRQ fires after `request_irq` and
before `dev->read_subdev` is set. Listed ISA drivers: das6402,
ni_atmio16d, aio_iiro_16, pcmmio, comedi_parport, pcl711.
**quatech_daqp_cs was not in that list**; Abbott added it as the same
pattern (PCMCIA `pcmcia_request_irq` before `read_subdev`). Suggested
fix: request IRQ later **or** guard the handler — this patch does the
latter.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: 11 independent per-driver patches. This one does not need the
others.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org/stable search returned HTTP
403. No stable discussion in the series mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `daqp_interrupt()` modified. Related: `daqp_auto_attach()`,
`comedi_device_postconfig()`.

**Step 5.2: TRACE CALLERS**

Record: `daqp_interrupt` is only passed to `pcmcia_request_irq()` in
`daqp_auto_attach()` (`quatech_daqp_cs.c:718`). Hardware IRQ context,
not a syscall. Probe-time and runtime IRQs.

**Step 5.3: TRACE CALLEES**

Record: After the guard: `inb`, `daqp_ai_get_sample`,
`comedi_buf_write_samples`, `comedi_handle_events`. Those run only once
`attached` is true.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
`pcmcia probe` → `comedi_auto_config()` → `daqp_auto_attach()` →
`pcmcia_request_irq(daqp_interrupt)` → later `read_subdev = s` → return
→ `comedi_device_postconfig()` sets `attached = true`.

Reachable when a DAQP-208/DAQP-308 PCMCIA card is inserted
(`CONFIG_COMEDI_QUATECH_DAQP_CS`). Unprivileged userspace is not
required; hardware IRQ during attach is enough. Same class as the KASAN-
reported ISA siblings.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same reorder in `pcl711.c` and others in this series.
`ni_660x.c` even comments “make sure dev->attached is checked before
doing anything else”. Systematic COMEDI IRQ pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- `git describe HEAD`: **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion`: **7.3.0-rc4**
- Driver present: `drivers/comedi/drivers/quatech_daqp_cs.c`
- `git merge-base --is-ancestor 1bc9538df6be8 HEAD`: yes (fix is already
  on this branch)
- Pre-fix form verified in `1bc9538df6be8^`; bug introduced v3.19,
  driver since ~2009
- Current `daqp_interrupt()` already has the reordered check (lines
  210–221)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply. Function has been stable since ~2015
(`f676376d692d8e` / `77e7c200f37536`). No rework needed.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: This exact fix is already on HEAD. Sibling series commits are
also here. No alternate/competing fix for this file.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/comedi/` — data-acquisition. **PERIPHERAL** (PCMCIA
DAQ: DAQP-208/308). Crash in IRQ handler is still a hard oops for those
users.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Mature, “Odd Fixes”. Recent work is this IRQ-guard series plus
small cleanups. Not a new/experimental driver (left staging in 2021,
`8ffdff6a8cfbd`).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific / config-specific:
`CONFIG_COMEDI_QUATECH_DAQP_CS`, Quatech DAQP PCMCIA cards.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: IRQ after `pcmcia_request_irq` and before
`attached`/`read_subdev`. Window during attach (and similar on
teardown). Not every boot; needs the card and a premature/spurious IRQ.
SNU reported KASAN for the same pattern on ISA siblings; Abbott
confirmed this driver has the same ordering.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: NULL deref in IRQ handler → oops/panic. **CRITICAL** for users
of this driver. (Cover letter: “null-ptr-deref”; original report:
“kernel panic” / KASAN.)

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- Benefit: HIGH for affected hardware (prevents IRQ oops); population is
  small
- Risk: VERY LOW (4-line reorder, no lock/API change)
- Ratio: favorable

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real NULL deref in interrupt context; C initializer ran before
  `dev->attached`
- Attach path verified: IRQ requested before `read_subdev` and before
  `attached = true`
- Same class as KASAN-reported COMEDI IRQ bugs (SNU); maintainer
  included this driver
- Author is the COMEDI maintainer; Greg KH applied it
- 4 lines, one function, no new APIs, no dependencies
- Bug present since ~v3.19; driver exists in this 7.3-rc4 tree

**AGAINST:**
- Niche PCMCIA DAQ hardware
- quatech_daqp_cs was not in the original SNU driver list (pattern match
  by maintainer)
- No `Fixes:` / `Cc: stable` (expected, not a negative)

**UNRESOLVED:**
- No stable@ thread found (lore 403)
- No on-list review replies in the b4 mbox
- Not proven on this exact Quatech card that IRQ fires in the window
  (sibling ISA drivers were KASAN-reported)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — reorder of existing guard;
   applied to char-misc by Greg KH
2. Fixes a real bug that affects users? **PASS** — premature IRQ NULL
   deref; reported class, same code here
3. Important issue? **PASS** — oops/panic in IRQ handler (CRITICAL for
   this driver)
4. Small and contained? **PASS** — +3/−1, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function, clean; tree is
   7.3-rc4 with this driver

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not an ID/quirk/DT/build/doc exception). Ordinary crash
fix.

**Step 9.4: DECISION**

This tree is **7.3.0-rc4**. The driver and the buggy ordering exist
here. The patch is a 4-line, obviously correct NULL-deref fix in an IRQ
handler. It meets stable criteria for this checkout.

## Why it matters

`daqp_auto_attach()` calls `pcmcia_request_irq()` before
`dev->read_subdev` is set and before the core sets `dev->attached`. The
handler used to do `cmd = &s->async->cmd` at declaration time, so a
premature IRQ oopses instead of returning `IRQ_NONE`. Stable users with
this card can panic on insert/probe.

Risk is negligible; benefit is avoiding a hard crash. No prerequisites.

## Verification

- [Phase 1] Tags: Ian Abbott SOB, Greg KH SOB, msgid
  `20260618102949.26607-12` (11/11). No Fixes/Reported-by/Cc-stable on
  the commit.
- [Phase 1] Message typo verified: text says `read_dev`; code uses
  `read_subdev`.
- [Phase 2] Diff: +3/−1 in `daqp_interrupt()`; `cmd` init moved after
  `if (!dev->attached)`.
- [Phase 2] Pre-fix source from `git show 1bc9538df6be8^:...` confirms
  initializer before the guard.
- [Phase 3] Blame: cmd init `2d7840c70dcf52` (v3.19-rc1); attached check
  `c12717423e1c61` (v3.9-rc1).
- [Phase 3] `git merge-base --is-ancestor 1bc9538df6be8 HEAD` → is
  ancestor.
- [Phase 3] Author is COMEDI maintainer (`MAINTAINERS`); 11-patch
  series, this file standalone.
- [Phase 4] `b4 dig -c 1bc9538df6be8` → lore URL; `-a` → v1 only; `-w` →
  Greg KH, Hartley, SNU CCs.
- [Phase 4] Cover letter: explicit null-ptr-deref; cites SNU report.
- [Phase 4] Original report mbox: KASAN NULL deref / panic on early IRQ;
  quatech not named; Abbott added it.
- [Phase 4] UNVERIFIED: stable@ discussion (HTTP 403); review replies
  (none in series mbox).
- [Phase 5] Only caller: `pcmcia_request_irq` in `daqp_auto_attach`.
- [Phase 5] `comedi_device_postconfig()` sets `dev->attached = true`
  only after `auto_attach` returns.
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37;
  `kernelversion` 7.3.0-rc4; file present.
- [Phase 6] Current `daqp_interrupt()` at lines 210–221 already contains
  the fix.
- [Phase 7] `CONFIG_COMEDI_QUATECH_DAQP_CS` — DAQP-208/308 PCMCIA.
- [Phase 8] Failure mode: NULL deref in IRQ → oops; severity CRITICAL
  for this driver; risk very low.
- UNVERIFIED: hardware demonstration that this specific PCMCIA card IRQs
  in the attach window.

**YES**

 drivers/comedi/drivers/quatech_daqp_cs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/quatech_daqp_cs.c b/drivers/comedi/drivers/quatech_daqp_cs.c
index 2a76c75c513b8..d5e3e213e233b 100644
--- a/drivers/comedi/drivers/quatech_daqp_cs.c
+++ b/drivers/comedi/drivers/quatech_daqp_cs.c
@@ -211,13 +211,15 @@ static irqreturn_t daqp_interrupt(int irq, void *dev_id)
 {
 	struct comedi_device *dev = dev_id;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	int loop_limit = 10000;
 	int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	cmd = &s->async->cmd;
+
 	status = inb(dev->iobase + DAQP_STATUS_REG);
 	if (!(status & DAQP_STATUS_EVENTS))
 		return IRQ_NONE;
-- 
2.53.0

