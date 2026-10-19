Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECD4508818;
	Mon, 19 Oct 2026 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418166; cv=none; b=XFTwXD+IMGnZMflNJq5ge/svmajBzxKF5lLf1oT0TxyYCb382HYlCbBK+OiatI4ZRfmDp58j3LxGAhQ68HeHcgm0ZXOFAq+P9eXsk7NJxMaWnTOu4KusJWQIcbPShDwd6Hs3iDBHLLMSP3ai2rujJEtIPN7nWCzdf5GfPw4x1LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418166; c=relaxed/simple;
	bh=DEOX1JM4PMaj4Hkdqru6zsIucAAEHc+fB3xAWBKvW28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=amJtJwZ2VIUA7hxQbWx9dNxqc/k/esuxwwo+uV8JnCkYr0mmsR0S7PpEOcj9ntQRr0hF+KpEiaumFXtQ3pDU3h7CK3GqfhXjjFeqTjw4AJ2Z5R3BmfzLiJtZ5U7XflXDqY+XZGU5WeAIVU/mxxU31lJnL9eUJgrTboLENOnjBu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I8D917HT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I8D917HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49CE51F000C7;
	Mon, 19 Oct 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418164;
	bh=NbG8KeK/8Obh+OVNCohBG662A62vEgDIt/OjzMVvTJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8D917HTxc+QaL2hEcPjyHgp+rBYjX2HoiHwg7rNpvRZhVny9ZJiJyRlQBGNaymKi
	 xlR1N6OVd680McvzTTaBZOWX5FWG221bx+zGP/hn4LyjK0HHqnEV1Oiqo1SpAOvTT/
	 17qlBJFCs4HJYBnDRPz77/UZMszqbbLWDBlDhZNYmGcKo2tpOnDdRp4khGCUru2LIy
	 laAYifWMggd9VTY6GdKETh9cL2qhIOmFOmnRFtIt7k5NKgInlip8m2vi/ptD8xL0Pl
	 7LztRbIEODhm7Jnz2OtOtColE6WZxtwUvcZuIEgq93TCYAKE7j1X0fBtMNmhtydgwD
	 XdMeC/CgaFnBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: ni_at_a2150: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:45:48 -0400
Message-ID: <20261019135441.1420968-57-sashal@kernel.org>
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

[ Upstream commit e7356cdc7077a4f30fc5232a18e9fc6a4d404581 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing various pointers which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereferences.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-5-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1:** Record: `[comedi: ni_at_a2150:] [Fix] [Move the
`dev->attached` check in `a2150_interrupt()` so it runs before pointer
dereferences that can be NULL while the device is still attaching.]`

**Step 1.2:** Tags in `e7356cdc7077a`:
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (author; comedi
  maintainer)
- `Link:
  https://patch.msgid.link/20260618102949.26607-5-abbotti@mev.co.uk`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` on the committed message (absence is expected
  here)

Mailbox recipients of the original mail also included H Hartley Sweeten,
Jaeyoung Chung, and a malformed Cc that was meant to be `Reported-by:
Sangyun Kim` plus Kyungwook Boo. Those trailers were not copied onto the
git commit.

**Step 1.3:** Record:
- Bug: the ISR is registered in `a2150_alloc_irq_and_dma()` during
  `a2150_attach()`, before postconfig sets `dev->attached`.
- Symptom: NULL pointer dereference in interrupt context if the handler
  runs while `dev->attached` is still false.
- Version info: none in the commit body.
- Root cause: the existing `if (!dev->attached)` guard sits *after*
  `dma->desc[0]`, `s->async`, `async->cmd`, and `desc->virt_addr`.

Cover letter for the 11-patch series: “Add/fix sanity check in ISA
drivers to avoid null-ptr-deref”.

**Step 1.4:** Record: Not a hidden fix. Subject and body are explicit
NULL-deref prevention.

## Phase 2: Diff analysis

**Step 2.1:** Record:
- File: `drivers/comedi/drivers/ni_at_a2150.c` (+9 / −4; 13 lines
  changed)
- Function: `a2150_interrupt()`
- Scope: single-file surgical ISR change

**Step 2.2:** Record: Before, locals were initialized with dereferences,
then `dev->attached` was checked. After, `desc`/`async`/`cmd`/`buf` are
declared uninitialized, the attached check runs, then those pointers are
filled. Normal attached-and-running IRQ path is unchanged.

**Step 2.3:** Record: `[NULL pointer dereference] [ISR used `dma`,
`read_subdev`, and `async` before the attached guard; those can still be
NULL between `request_irq()` and `dev->attached = true`, and `dma` can
already have been freed on detach before `free_irq()`.]`

Verified attach/detach order in this tree:
1. `comedi_alloc_devpriv()` then `a2150_alloc_irq_and_dma()` →
   `request_irq(a2150_interrupt, …)` then DMA alloc, then later
   `comedi_alloc_subdevices()` / `dev->read_subdev = s`.
2. `comedi_device_attach()` only then calls
   `comedi_device_postconfig()`, which sets `dev->attached = true`.
3. Detach sets `dev->attached = false` first, then `a2150_detach()`
   frees DMA, then `comedi_legacy_detach()` calls `free_irq()`.

So a premature IRQ during attach hits NULL `dma` or NULL `s`/`s->async`.
An IRQ between DMA free and `free_irq()` hits a freed `dma` (UAF) in the
old code.

Loads that remain before the check (`dev->private`, `devpriv->dma`,
`dev->read_subdev`) are pointer loads, not the crashing derefs.
`private` is allocated before `request_irq()`, and it is still valid
until after `free_irq()`.

**Step 2.4:** Record: Obviously correct and minimal. Regression risk is
very low: early return already existed; only the check moved. No
API/locking/data-structure change. Residual theoretical issue: if
`attached` were true with `dma` or `read_subdev` still NULL, later
derefs would still fault — that is not the attach/detach window this
patch targets, and `dev->irq` is only kept when DMA alloc succeeded.

## Phase 3: Git history

**Step 3.1:** Record: `if (!dev->attached)` is old (Frank Mori Hess,
2009). The dangerous pre-check initializers come from `1a97f144e3d3e9`
(“staging: comedi: ni_at_a2150: remove depends on ISA_DMA_API
limitation”, H Hartley Sweeten, 2015-01-14), first contained in
`v4.0-rc1`. Present in this tree (`git merge-base --is-ancestor
1a97f144e3d3e9 HEAD`).

**Step 3.2:** Record: No `Fixes:` tag. Introduced by `1a97f144e3d3e9`
(v4.0), which is in this checkout.

**Step 3.3:** Record: This is patch 4/11 of Ian Abbott’s June 2026
series. Neighbor commits are the same class of per-driver ISR guards
(`dt2811`, `aio_iiro_16`, `das6402`, `pcl711`, etc.). Independent; no
shared helper or prerequisite refactor. No later follow-up on
`ni_at_a2150.c`.

**Step 3.4:** Record: Ian Abbott is the long-time comedi maintainer.
Greg Kroah-Hartman applied the series. Related work: `17221216ae8ce`
(“comedi: comedi_parport: deal with premature interrupt”) for the same
premature-IRQ class, with syzbot + `Cc: stable`.

**Step 3.5:** Record: No extra commits required. The ISR,
`dev->attached`, `request_irq`, and `comedi_legacy_detach()` already
exist here. Standalone.

## Phase 4: Mailing list / external research

**Step 4.1:** Record:
- `b4 dig -c e7356cdc7077a` →
  https://patch.msgid.link/20260618102949.26607-5-abbotti@mev.co.uk
- `b4 dig -a`: v1 only (no v2/v3)
- Cover letter: “comedi: Add/fix sanity check in ISA drivers to avoid
  null-ptr-deref”
- No NAKs in the saved thread (12 series mails, no review replies)

**Step 4.2:** Record (`b4 dig -w`): linux-kernel, Greg KH, Hartley
Sweeten, Jaeyoung Chung, Sangyun Kim, Kyungwook Boo. Maintainer-
authored, applied by Greg.

**Step 4.3:** Record: Original report retrieved with `b4 mbox` msgid
`20260610115912.780131-1-jjy600901@snu.ac.kr`:
- Subject: “comedi: KASAN null-ptr-deref in ISA driver IRQ handlers on
  early IRQ”
- From Jaeyoung Chung; Reported-by Sangyun Kim and Kyungwook Boo
- Failure: handler runs before `read_subdev` is set → KASAN NULL deref /
  panic
- Named drivers: das6402, ni_atmio16d, aio_iiro_16, pcmmio,
  comedi_parport, pcl711
- ni_at_a2150 was not in that list; Ian added it after finding the same
  `request_irq` / `read_subdev` / attached-check ordering

Related: `comedi_parport` premature IRQ was a syzbot GPF in
`comedi_get_is_subdevice_running()`.

**Step 4.4:** Record: 11 independent per-driver patches. This one does
not need the others.

**Step 4.5:** Record: UNVERIFIED — lore.kernel.org returned HTTP 403 for
`/stable/` search. No stable-list discussion confirmed.

## Phase 5: Code semantic analysis

**Step 5.1:** Record: `a2150_interrupt()` only.

**Step 5.2:** Record: Sole registration is `request_irq()` in
`a2150_alloc_irq_and_dma()`, called from `a2150_attach()`. Hardirq
context. Userspace can trigger attach/detach via comedi config
(`COMEDI_NI_AT_A2150`).

**Step 5.3:** Record: After the guard: `inw(STATUS_REG)`,
`comedi_handle_events()`, `comedi_isadma_disable()`, sample copy into
the async buffer.

**Step 5.4:** Record: Reachable from the comedi attach ioctl / config
path on ISA AT-A2150 (or a crafted I/O base/IRQ). Same class as the
KASAN/syzbot premature-IRQ bugs. Not a hot syscall path for typical
machines.

**Step 5.5:** Record: Same `if (!dev->attached)` pattern across many
`drivers/comedi/drivers/*.c` files; this series fixes the ones that
checked too late or not at all.

## Phase 6: Local tree (this checkout)

**Step 6.1:** Record:
- `make kernelversion` / Makefile: **7.3.0-rc4**
- `git describe HEAD`: `v7.3-rc4-27-gf0100363d8c37`
- File and ISR exist. Pre-fix ISR confirmed at `e7356cdc7077a^`. Bug
  dates to v4.0 (`1a97f144e3d3e9`). This is mainline, not a 6.x.y stable
  branch; the driver code the patch targets is present.

**Step 6.2:** Record: Clean apply on the pre-image in this history. No
extra backport rework needed for a tree that still has the old ISR.

**Step 6.3:** Record: No earlier ni_at_a2150-specific substitute.
`comedi_parport` got a related premature-IRQ fix; it does not cover this
driver.

## Phase 7: Subsystem / maintainer

**Step 7.1:** Record: `[drivers/comedi — ISA DAQ] [PERIPHERAL]`. Out of
staging (`8ffdff6a8cfbd`). Hardware is old NI AT-A2150 ISA cards
(`CONFIG_COMEDI_NI_AT_A2150`).

**Step 7.2:** Record: Mature, low churn. Ian Abbott still actively
fixing ISR attach races in 2026.

## Phase 8: Impact and risk

**Step 8.1:** Record: Driver-specific, `CONFIG_COMEDI_NI_AT_A2150`.
Small user set (legacy ISA DAQ).

**Step 8.2:** Record: Trigger is attach (IRQ registered before
`attached`/`read_subdev`) or detach (DMA freed before `free_irq()`).
Needs the device (or a spurious/pending IRQ on that line). Not a general
unprivileged remote exploit; privileged/local comedi attach is enough if
the IRQ fires. Likelihood is low, but the window is real and matches a
KASAN report for the same pattern.

**Step 8.3:** Record: `[NULL deref / possible UAF in hardirq →
oops/panic] [HIGH]` (CRITICAL for that machine; not data corruption).

**Step 8.4:** Record: Benefit HIGH for anyone using this driver (avoids
IRQ oops on attach/detach). Risk very low (13-line ISR reorder). Ratio
favors backport.

## Phase 9: Synthesis

**Evidence FOR:**
- Real NULL deref (and detach UAF) in an interrupt handler
- Same class as a KASAN report and a syzbot GPF on sibling comedi
  drivers
- Author is the comedi maintainer; Greg applied v1 unchanged
- Small, obviously correct, no new API
- Bug present since v4.0; code exists in this tree
- Independent of the rest of the series

**Evidence AGAINST:**
- Niche obsolete ISA hardware
- Not in the original SNU driver list (Ian’s extra finding)
- Committed message has no `Fixes:` / `Cc: stable` (expected for this
  review)
- No Tested-by on hardware in the thread

**UNRESOLVED:**
- Could not read lore.kernel.org in the browser (403); used `b4` mboxes
  instead
- No confirmed stable@ discussion
- No hardware Tested-by

**Stable rules:**
1. Obviously correct and tested? **PASS** — logic is local and matches
   core `attached` semantics; applied by Greg. No extra hardware Tested-
   by, but the defect is visible in code.
2. Real user-visible bug? **PASS** — KASAN NULL deref / panic for this
   ISR pattern.
3. Important (crash/security/corruption/deadlock)? **PASS** — hardirq
   oops/panic.
4. Small and contained? **PASS** — one function, +9/−4.
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — pre-fix ISR is the historical form
   of this file; no missing helpers.

**Exception category:** none (ordinary crash fix).

This is a 13-line IRQ-handler NULL-deref (and detach UAF) fix in
existing comedi code. It meets the stable rules. The local 7.3.0-rc4
tree has the driver and had the bug since v4.0.

### What it fixes for stable users
If the AT-A2150 ISR runs after `request_irq()` but before
`dev->attached` (or after DMA is freed on detach), the old handler
oopses on NULL/dangling `dma`/`read_subdev`/`async`. Moving the existing
guard first prevents that crash.

### Risk vs benefit
Benefit is avoiding a kernel oops; risk is negligible. Other patches in
the 11-patch series are not required.

---

Verification:
- [Phase 1] Parsed `e7356cdc7077a`: Ian Abbott + Greg KH; msgid
  `20260618102949.26607-5`; no Fixes/Cc stable
- [Phase 1] Cover letter from mbox: series is explicitly “avoid null-
  ptr-deref”
- [Phase 2] Diff: +9/−4 in `a2150_interrupt()`; moved
  `desc`/`async`/`cmd`/`buf` after `if (!dev->attached)`
- [Phase 2] `a2150_attach` / `a2150_alloc_irq_and_dma` /
  `comedi_device_postconfig`: `request_irq` before `attached = true`
- [Phase 2] `comedi_device_detach_locked`: `attached = false` before
  `a2150_free_dma` then `free_irq`
- [Phase 3] `git blame` on pre-image: check from 2009; early derefs from
  `1a97f144e3d3e9` (v4.0-rc1)
- [Phase 3] `git merge-base --is-ancestor 1a97f144e3d3e9 HEAD` and
  `e7356cdc7077a HEAD`: both true
- [Phase 3] Series is 11 independent driver patches; no ni_at_a2150
  follow-up
- [Phase 4] `b4 dig -c/-a/-w`: v1 only; recipients include Greg, Hartley
  Sweeten, SNU reporters
- [Phase 4] `b4 mbox` of `20260610115912.780131-1-jjy600901@snu.ac.kr`:
  KASAN null-ptr-deref report
- [Phase 4] Related `17221216ae8ce` comedi_parport fix: syzbot GPF + Cc
  stable
- [Phase 4] lore HTTP 403; UNVERIFIED stable@ archive search
- [Phase 5] `a2150_interrupt` only used from `request_irq` in this file
- [Phase 6] Local tree 7.3.0-rc4 (`v7.3-rc4-27-gf0100363d8c37`); pre-fix
  ISR confirmed at parent
- [Phase 7] `CONFIG_COMEDI_NI_AT_A2150`; peripheral ISA DAQ
- [Phase 8] Failure mode: hardirq NULL deref/UAF oops, severity HIGH;
  backport risk very low
- UNVERIFIED: hardware reproduction on a real AT-A2150; stable mailing-
  list mentions

**YES**

 drivers/comedi/drivers/ni_at_a2150.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/comedi/drivers/ni_at_a2150.c b/drivers/comedi/drivers/ni_at_a2150.c
index e4e5a0ebd195a..93e9591f5dd4c 100644
--- a/drivers/comedi/drivers/ni_at_a2150.c
+++ b/drivers/comedi/drivers/ni_at_a2150.c
@@ -132,11 +132,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	struct comedi_device *dev = d;
 	struct a2150_private *devpriv = dev->private;
 	struct comedi_isadma *dma = devpriv->dma;
-	struct comedi_isadma_desc *desc = &dma->desc[0];
+	struct comedi_isadma_desc *desc;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
-	unsigned short *buf = desc->virt_addr;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
+	unsigned short *buf;
 	unsigned int max_points, num_points, residue, leftover;
 	unsigned short dpnt;
 	int status;
@@ -145,6 +145,11 @@ static irqreturn_t a2150_interrupt(int irq, void *d)
 	if (!dev->attached)
 		return IRQ_HANDLED;
 
+	desc = &dma->desc[0];
+	async = s->async;
+	cmd = &async->cmd;
+	buf = desc->virt_addr;
+
 	status = inw(dev->iobase + STATUS_REG);
 	if ((status & INTR_BIT) == 0)
 		return IRQ_NONE;
-- 
2.53.0

