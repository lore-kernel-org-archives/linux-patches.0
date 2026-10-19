Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9663A59E3AC;
	Mon, 19 Oct 2026 13:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418372; cv=none; b=lPOhMJQNK1diMnsSN34zenLFcM3hKn7GVq+tnFNsXXq+zUmMnv3Y/DNW5ncZ3opH1WAQfuFrKBIPqjezzhC1yIfzd47w5PxsRt5asoNUZa+Oz9/DMXVIwVIabr22PY5ZIJQTVslZc0do68DxWTm4tdEdAxFBir5RdXBLeLohTI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418372; c=relaxed/simple;
	bh=AloWX14YGncpharTvx/Xp6pjI4ARAUG6GhKaTKzVco0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fA9PpH0YLECVgVoGZfPQCxGdjDow73qymNCUAOnNcAaVD7pkou7Et6mWE17+PCB7KKkAEAquJ/2ohdLXhPy04HxYjppo2wiwbMZFbI43ltssaQ18Cp8f4LduqVrD2IcXYCJTYscI+O6iXu5EfvNpBuPdtqb+sBRDaiK+BzWe+to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DU0SWiKv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DU0SWiKv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5FB1F000C8;
	Mon, 19 Oct 2026 13:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418369;
	bh=jA+ch+icmUTRT0GWbDxaKDUDzY/umcBX7u0WoZiVIvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DU0SWiKvz8Qz+LICuLU/NTeRGpcfjljtivmLHU7qVy0gbtOudUWj2fv0DEo7TwNui
	 b8jb8+ORVX1N/inkEtOOPZ7BRnRvJnr3/p+WVpYd9aOI1ALuQu9jGqxQ6wi+NwwobB
	 Fq2RoPzqRqkR2QCmaQjwxLCbVYiF6Ob5B5Tlphmx5hqJrNv1F0dsK9C9QAn1Vphy4H
	 mwJx+BTk7cLSJyWgiVwhw4eeS7lZADpk19KYGLm/IuTl0dk48ByVnBb9gdSDO9D//e
	 qXyJUgjSd93g1azf2TN7ZI9lwFi7TaQNfMeIbky5uD2Mjf+gH8oNeXxn3LrqajtfQ6
	 rokLJubotTyOg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Randolph Sapp <rs@ti.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	airlied@gmail.com,
	simona@ffwll.ch,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/etnaviv: force flush on power register ops
Date: Mon, 19 Oct 2026 09:48:10 -0400
Message-ID: <20261019135441.1420968-199-sashal@kernel.org>
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

From: Randolph Sapp <rs@ti.com>

[ Upstream commit c182a2ae13886463f7ae36e034449477306d182b ]

Add gpu_write_power_sync to verify that power register modifications
have reached the endpoint device in sequence specific sections that do
not validate device state.

These sequence specific areas have been detected experimentally with an
am57xx-evm through numerous boot and module load+unload cycles.

Signed-off-by: Randolph Sapp <rs@ti.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patch.msgid.link/20251013170122.1145387-2-rs@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a hardware posted-write flush in the Vivante/etnaviv reset and
init path. The local tree is **7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). The driver, the unsynced
`gpu_write_power()` sites, and the helper this patch adds all exist
here, so the question is whether this tree should take the fix on
technical merit.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[drm/etnaviv] [force] [flush posted MMIO writes to GPU power
registers]**

Subsystem: `drm/etnaviv` (Vivante GPU DRM driver). Action verb “force
flush” is a hardware-workaround / correctness change, not a feature or
refactor.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Reported-by:** none
- **Tested-by:** none (author states experimental detection on am57xx-
  evm)
- **Reviewed-by:** Lucas Stach `<l.stach@pengutronix.de>` — **etnaviv
  maintainer** (MAINTAINERS: “DRM DRIVERS FOR VIVANTE GPU IP”)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20251013170122.1145387-2-rs@ti.com` (patch
  **2** of a series)
- **Cc: stable:** none (expected; not a negative)
- **Signed-off-by:** Randolph Sapp `<rs@ti.com>` (author, TI); Lucas
  Stach (maintainer, applied it)
- Ignore pipeline SOBs; none of Sasha Levin’s are in the real commit
  `c182a2ae13886`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Power-register `writel`s can remain posted on the
  interconnect, so later reset/init steps run before those writes reach
  the GPU.
- **Symptom:** Found on **am57xx-evm** across many **boot and module
  load+unload** cycles. The message does not include a stack trace or a
  named errno; the affected sequences are reset/init paths that “do not
  validate device state.”
- **Version info:** none in the message. AM57xx is a long-shipping TI
  Sitara platform (typically Vivante GC320).
- **Root cause (author):** Need a read-back so the write is visible at
  the endpoint before continuing.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a disguised cleanup.** It is an explicit hardware posted-
write barrier. Stable rules name **hardware quirk** as an accepted class
(`Documentation/process/stable-kernel-rules.rst`).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- `drivers/gpu/drm/etnaviv/etnaviv_gpu.h`: **+6** (new
  `gpu_write_power_sync()`)
- `drivers/gpu/drm/etnaviv/etnaviv_gpu.c`: **+5 / -5** (five call sites
  switched)
- Functions: `gpu_write_power_sync` (new), `etnaviv_hw_reset`,
  `etnaviv_gpu_enable_mlcg`, `etnaviv_gpu_setup_pulse_eater`
- Scope: **single-driver surgical fix** (~11 insertions, 5 deletions).
  Under the 100-line stable limit.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Helper:** `gpu_write_power()` was `writel` only.
  `gpu_write_power_sync()` does `writel` then `readl` of the same power
  register (classic posted-write flush).
- **`etnaviv_hw_reset`:** disable clock gating and the second pulse-
  eater write now flush. The first pulse-eater write stays unsynced; the
  following synced write to the same register is the barrier. Correct.
- **`etnaviv_gpu_enable_mlcg`:** POWER_CONTROLS and MODULE_CONTROLS
  writes flush before later init.
- **`etnaviv_gpu_setup_pulse_eater`:** final pulse-eater program
  flushes.
- **Unchanged:** perfmon pre/post still use plain `gpu_write_power()`
  (lines 1388, 1409). Intentional: those paths are not the unvalidated
  reset/init sequences.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Hardware workaround / posted MMIO write]**
Power/clock-gating register updates may not have reached the GPU before
isolate/soft-reset (`etnaviv_hw_reset`) or before FE start
(`etnaviv_gpu_hw_init`). That matches the existing comment on
`b0da08559c749` (“MLCG and the pulse eater might interfere with the GPU
reset”). Dummy `readl` after `writel` is the standard PCI/MMIO posting
barrier; `gpu_read()` in the same header already does an extra `readl`
for some FE registers.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct and minimal.** Extra `readl` only on
init/reset/resume, not on the submit hot path. Same registers are
already read via `gpu_read_power()` in these functions, so a stuck read
is not a new failure mode. No API, locking, or data-structure change.
Regression risk **low**.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `etnaviv_hw_reset` exists since `a8c21a5451d831` (initial etnaviv,
  2015).
- `gpu_write_power` introduced in `61a6920bb604d` (“fix power register
  offset on GC300”), contained in **v6.2-rc1**.
- Reset-time MLCG/pulse-eater writes added in `b0da08559c749` (“disable
  MLCG and pulse eater on GPU reset”), contained in **v6.9-rc1**.
- Bug is long-lived interconnect posting, not new 7.3 code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Not applicable. Introducers above are in this
tree (`git merge-base --is-ancestor` of those SHAs vs HEAD is implied by
blame on this checkout).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Immediate neighbors on this file:
- `1006d1f7c03d9` drm/etnaviv: check all modules for idle after reset
- `4720915ab4828` drm/etnaviv: check MMUv2 status after reset
Those are **independent** Lucas Stach reset-validation patches. This
commit only changes write helpers; it does not need those checks.
- msgid `-2` suggests a series; **only this Randolph Sapp etnaviv commit
  is in git**. drm-misc-next pull lists this as his sole etnaviv change.
  Treat as **standalone** (patch 1 is likely a cover letter or was not
  applied).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Randolph Sapp is a **TI** engineer, not the subsystem
maintainer. Only this etnaviv commit. Weight comes from **Lucas Stach
Reviewed-by + Signed-off-by** (maintainer).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Depends only on existing `gpu_write_power` / `gpu_read_power`
(since v6.2). **Can apply standalone** on this tree. Confirmed: `git
show c182a2ae13886^:drivers/gpu/drm/etnaviv/etnaviv_gpu.c` already has
every converted call site.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c c182a2ae13886` (and `-a`, `-w`): lore search errors; lookup
  of `20251013170122.1145387-2-rs@ti.com` → **404 / “not found”**.
- lore.kernel.org and patch.msgid.link: **403/503**.
- gnuweeb lore: msgid **not in the archive**.
- marc.info: **404**.
- **UNVERIFIED:** original dri-devel/etnaviv thread body, v1 vs v2,
  reviewer comments, Cc: stable in review.
- **Verified:** included in **[PULL] drm-misc-next**
  `20260724082204.GA18774@linux.fritz.box` (Thomas Zimmermann, 24 Jul
  2026) as “etnaviv: force flush on power register ops”; applied 23 Jul
  2026 by Lucas Stach.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Maintainer **Lucas Stach** Reviewed-by and applied. Recipients
of the original mail **UNVERIFIED** (`b4 dig -w` failed).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No bugzilla/syzbot link. Evidence is the author’s **am57xx-evm**
load/unload cycling. Severity from the report: **intermittent GPU bring-
up / rebind**, not a sanitizer crash.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: drm-misc-next lists **one** Randolph Sapp etnaviv patch. Reset-
check commits (`1006d1f7`, `4720915`) are a **different** Lucas series
(May 2026). **This patch is self-contained.**

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: `lore-kernel.gnuweeb.org/stable/?q=etnaviv+force+flush` did
**not** hit this commit (noise from unrelated “flush” in stable
reviews). **No stable NAK or prior request found.**

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `gpu_write_power_sync`, `etnaviv_hw_reset`,
`etnaviv_gpu_enable_mlcg`, `etnaviv_gpu_setup_pulse_eater`.

**Step 5.2: TRACE CALLERS**
Record (verified with `rg` on this tree):
- `etnaviv_hw_reset` ← `etnaviv_gpu_init` (probe, ~line 891) and
  `etnaviv_gpu_recover_hang` (~line 1530)
- `etnaviv_gpu_enable_mlcg` / `etnaviv_gpu_setup_pulse_eater` ←
  `etnaviv_gpu_hw_init`
- `etnaviv_gpu_hw_init` ← `etnaviv_gpu_init`,
  `etnaviv_gpu_recover_hang`, **`etnaviv_gpu_hw_resume`** (~line 1753)
- `etnaviv_gpu_recover_hang` ← `etnaviv_sched.c` hangcheck
  (`etnaviv_sched` timeout path)
- `etnaviv_gpu_init` ← `etnaviv_drv.c` bind/load

**Step 5.3: TRACE CALLEES**
Record: `writel`/`readl` via
`gpu_write_power`/`gpu_read_power`/`gpu_fix_power_address`. No
allocations, no locks added.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from **device probe**, **runtime resume**, **module
unload/reload** (matches the report), and **GPU hang recovery**.
Userspace GPU use can trigger hang recovery. Not a theoretical-only
path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `gpu_read()` already discards an extra `readl` for FE DMA
registers (GC7000 consistency). Same class of MMIO quirk, localized to
power registers here.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** This checkout is **7.3.0-rc4**. `git merge-base --is-
ancestor c182a2ae13886 HEAD` succeeds (the fix is already merged here as
mainline). The **parent** still has unsynced `gpu_write_power()` at the
five sites. Helpers `gpu_write_power`/`gpu_read_power` exist. Bug class
(posted power-register writes on reset/init) is present in this
codebase.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply on this tree.** Context in `etnaviv_hw_reset`
matches. No conflicting local edits.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent `gpu_write_power_sync`. Reset idle/MMU
checks are separate, not substitutes for the flush.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drm/etnaviv] [IMPORTANT for Vivante GPU users, PERIPHERAL vs
core kernel]**
Not mm/net/vfs. Real embedded/SoC users (i.MX, TI AM57xx, etc.).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively maintained (reset, PPU flop reset, scheduler). This
particular path (`etnaviv_hw_reset` / power regs) is **mature**
(2015/2022/2024), not brand-new 7.3 infrastructure.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific.** Vivante GPU, observed
on **TI am57xx-evm** (GC320-class). Other SoCs with posted interconnects
to the GPU can hit the same reset/init window.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Boot, **module load/unload**, runtime resume
(`etnaviv_gpu_hw_resume` → `etnaviv_gpu_hw_init`), GPU hang reset.
Timing-dependent (posted write). Unprivileged GPU clients can cause hang
recovery; probe/reload typically needs module/root. **Intermittent but
real.**

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Failed `etnaviv_hw_reset` returns **-EBUSY**, probe logs “GPU
reset failed” and **the GPU never comes up**. Hang recovery can leave
the GPU **wedged**. Not a documented oops/KASAN. **Severity: HIGH** for
that hardware (device unusable / hang not recovered), not a core panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** HIGH for AM57xx and similar — GPU init/reset/resume
  actually complete.
- **Risk:** VERY LOW — 6-line helper, 5 call-site swaps, extra MMIO read
  on cold paths.
- **Ratio:** strongly in favor of taking the fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Stable rules explicitly allow **hardware quirks**.
- Posted-write flush is the standard, obviously correct MMIO barrier.
- Reproduced on shipping TI hardware (boot + load/unload).
- Hits probe, resume, and hang recovery — GPU can fail to start or stay
  hung.
- Small (~11 insertions), driver-private helper, no UAPI.
- Reviewed and applied by the **etnaviv maintainer**.
- Code and call sites exist in **this** 7.3-rc4 tree; no missing
  prerequisites.

**AGAINST:**
- No Fixes/syzbot/stack trace; commit text is light on the exact user-
  visible failure.
- Original lore thread **not retrieved** (msgid absent from lore).
- Affects one DRM driver, not core kernel.
- msgid `-2` without a recovered patch 1 (mitigated: only this patch
  landed).

**UNRESOLVED:** Full mailing-list review text; exact errno/log on
am57xx; whether patch 1 was a cover letter.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — write+read barrier;
   maintainer review; experimental confirmation on am57xx-evm.
2. Fixes a real bug that affects users? **PASS** — GPU reset/init/resume
   can run before power-register writes complete.
3. Important issue? **PASS** — hardware quirk; failed reset → GPU
   unusable / hang unrecovered (HIGH, not a core oops).
4. Small and contained? **PASS** — two files, ~16 net lines in one
   driver.
5. No new features or APIs? **PASS** — private static inline only.
6. Can apply to the local tree? **PASS** — files, helpers, and call
   sites are here; parent matches the diff.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (posted MMIO flush). That class is
intended for stable.

**Step 9.4: MAKE YOUR DECISION**
This tree has the Vivante driver and the unsynced power-register writes.
The patch is a small, maintainer-reviewed posted-write flush that keeps
GPU reset, init, and resume ordered on hardware that actually showed the
problem. That meets the stable rules, including the hardware-quirk
clause. It should be taken.

---

**What the commit solves:** `writel` to Vivante power/clock-gating
registers can sit in the interconnect. Reset and init then proceed too
early, so `etnaviv_hw_reset` can time out (-EBUSY / “GPU reset failed”)
or hang recovery/resume can leave the GPU dead. Dummy `readl` after the
write forces completion. That showed up on am57xx-evm across boot and
module reload.

**Stable rules:** Obviously correct, real hardware bug, small, no new
API, applies here.

**Risk vs benefit:** Extra MMIO reads only on init/reset/resume vs GPU
never coming up. Benefit dominates.

**Concerns:** Lore thread missing; no crash dump in the message. Neither
outweighs the quirk + maintainer review + tiny diff.

Verification:
- [Phase 1] Tags: Reviewed-by Lucas Stach (maintainer); Link msgid
  `...1145387-2-rs@ti.com`; no Fixes/syzbot/stable Cc
- [Phase 1] MAINTAINERS: Lucas Stach maintains
  `drivers/gpu/drm/etnaviv/`
- [Phase 2] Diff: +6 helper, 5 `gpu_write_power` →
  `gpu_write_power_sync`; perfmon writes left unsynced
- [Phase 2] Helper is `gpu_write_power` + `gpu_read_power` (posted-write
  barrier)
- [Phase 3] `git log`/`git blame` on `etnaviv_gpu.c`: reset from
  a8c21a5451d831 (2015); `gpu_write_power` from 61a6920bb604d
  (v6.2-rc1); MLCG-on-reset from b0da08559c749 (v6.9-rc1)
- [Phase 3] `git show c182a2ae13886`: 11 insertions, 5 deletions, two
  files
- [Phase 3] Neighbor reset-check commits 1006d1f7/4720915 are
  independent
- [Phase 3] Only one Randolph Sapp etnaviv commit in this tree
- [Phase 4] `b4 dig -c/-a/-w c182a2ae13886`: lore errors, msgid not
  found — **UNVERIFIED original thread**
- [Phase 4] drm-misc-next pull 2026-07-24 lists this as the sole
  Randolph Sapp etnaviv change
- [Phase 4] stable lore search: no discussion of this patch
- [Phase 5] Callers: `etnaviv_gpu_init`, `etnaviv_gpu_recover_hang` ←
  sched hangcheck, `etnaviv_gpu_hw_resume`
- [Phase 6] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor c182a2ae13886 HEAD` → yes
- [Phase 6] Parent of c182 still has unsynced `gpu_write_power` at all
  five sites
- [Phase 7] Subsystem drm/etnaviv, driver-specific
- [Phase 8] Failure: reset timeout / GPU not usable / hang recovery
  fail; severity HIGH for that hardware
- [Phase 9] stable-kernel-rules.rst: hardware quirk is an accepted class
- UNVERIFIED: original mailing-list review comments; exact am57xx log
  line; identity of series patch 1

**YES**

 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 10 +++++-----
 drivers/gpu/drm/etnaviv/etnaviv_gpu.h |  6 ++++++
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index daba33052f524..e81383c5bb1b4 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -543,13 +543,13 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		u32 pulse_eater = 0x01590880;
 
 		/* disable clock gating */
-		gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, 0x0);
+		gpu_write_power_sync(gpu, VIVS_PM_POWER_CONTROLS, 0x0);
 
 		/* disable pulse eater */
 		pulse_eater |= BIT(17);
 		gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 		pulse_eater |= BIT(0);
-		gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+		gpu_write_power_sync(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 
 		/* enable clock */
 		control = VIVS_HI_CLOCK_CONTROL_FSCALE_VAL(fscale);
@@ -660,7 +660,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	    gpu->identity.revision == 0x4302)
 		ppc |= VIVS_PM_POWER_CONTROLS_DISABLE_STALL_MODULE_CLOCK_GATING;
 
-	gpu_write_power(gpu, VIVS_PM_POWER_CONTROLS, ppc);
+	gpu_write_power_sync(gpu, VIVS_PM_POWER_CONTROLS, ppc);
 
 	pmc = gpu_read_power(gpu, VIVS_PM_MODULE_CONTROLS);
 
@@ -704,7 +704,7 @@ static void etnaviv_gpu_enable_mlcg(struct etnaviv_gpu *gpu)
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_HZ;
 	pmc |= VIVS_PM_MODULE_CONTROLS_DISABLE_MODULE_CLOCK_GATING_RA_EZ;
 
-	gpu_write_power(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
+	gpu_write_power_sync(gpu, VIVS_PM_MODULE_CONTROLS, pmc);
 }
 
 void etnaviv_gpu_start_fe(struct etnaviv_gpu *gpu, u32 address, u16 prefetch)
@@ -770,7 +770,7 @@ static void etnaviv_gpu_setup_pulse_eater(struct etnaviv_gpu *gpu)
 		pulse_eater |= BIT(18);
 	}
 
-	gpu_write_power(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
+	gpu_write_power_sync(gpu, VIVS_PM_PULSE_EATER, pulse_eater);
 }
 
 static void etnaviv_gpu_hw_init(struct etnaviv_gpu *gpu)
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
index 5cb46c84e03ac..e89d591d7404c 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.h
@@ -204,6 +204,12 @@ static inline u32 gpu_read_power(struct etnaviv_gpu *gpu, u32 reg)
 	return readl(gpu->mmio + gpu_fix_power_address(gpu, reg));
 }
 
+static inline void gpu_write_power_sync(struct etnaviv_gpu *gpu, u32 reg, u32 data)
+{
+	gpu_write_power(gpu, reg, data);
+	gpu_read_power(gpu, reg);
+}
+
 int etnaviv_gpu_get_param(struct etnaviv_gpu *gpu, u32 param, u64 *value);
 
 int etnaviv_gpu_init(struct etnaviv_gpu *gpu);
-- 
2.53.0

