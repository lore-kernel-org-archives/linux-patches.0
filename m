Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C5D54079F;
	Mon, 19 Oct 2026 14:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418736; cv=none; b=BCE2vczQKui/SUdZg6FiEERlYoGmgHvj1AvVQVTZUpWLt6aiw8szhHXAa4H+cCgoNSyVdNrnOikmYhwePPiRHRQOclwxMgNCzSbsZ8fd89VnjonNd7/8soxGVbaDwQwle9kAAFtcCIBmX1WWiSSAGvmrh9QhvZf3h28qPRWQMYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418736; c=relaxed/simple;
	bh=eHb84UA0PUho8tRWxIs/nLkY+kqzYbVhfC90duWTyNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZZAaB5mlwroOxS+07ufI2QsOqaVAGVg6i3pwnQ+F4V3z8JjOji+N305fWKWdwX/ITIbaTjmcF81bVBzyQckDemRTamWi5UeXATuv4GPsNnBV4zodVnN+F3LWdyY2Whky30Io1a1Kxvdm3wwMWh6FrnLGmWVgniF0J7Tjllr+yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PMZMZqmZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PMZMZqmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B142A1F000C4;
	Mon, 19 Oct 2026 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418733;
	bh=oYI5T8O+AAnnizZIZ7eRm4bWkb3nui5PR4a81p/JJF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMZMZqmZedOF8b9GGtHKTDijHwxZw08NTe+x0xvgt6x9P4na1RSVPwX2SmaFDRiOk
	 FAHJZFOeRbuD4Sv0YxoQUkzEXZTPgQCf9SGBDVRls13Xj/kxG9I1xH0ss6nvG9EHeT
	 oflJkew7NlAkzMkyyIgp+XFhg+SMkJmf6HdU7q1abpg0z0Ez9u0aRVgePebN+FkKdA
	 p+0d7TwgG9hccWheUaSzIHbSfh2PPci+zIApOSgvuO+361t/tGPx0DTsrQI5MpM0x8
	 ZHt0Jbo7f6GP8W7Xqkk/ooEK1fZPxS0nZhdk5WlTl2N6xTLaRV7aD1scmjGyyolvCA
	 wF9jSzKC+zlxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	william.zhang@broadcom.com,
	kursad.oney@broadcom.com,
	jonas.gorski@gmail.com,
	anand.gore@broadcom.com,
	florian.fainelli@broadcom.com,
	rafal@milecki.pl,
	linux-spi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: bcmbca-hsspi: return error from failed controller suspend
Date: Mon, 19 Oct 2026 09:52:28 -0400
Message-ID: <20261019135441.1420968-457-sashal@kernel.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit faa878d4805ca375738294bc52eae310eb287b16 ]

spi_controller_suspend() can fail if pending transfers cannot stop.
bcmbca_hsspi_suspend() ignored the error and still disabled the
PLL and core clocks.

Return the error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_54F5634545908FBA724E758054BF03953808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`, branch
`autosel`). The verdict is only about this checkout: the buggy suspend
path is in `v6.18.53`, and the patch applies cleanly to it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**

Record: **[spi / bcmbca-hsspi] [return] [propagate
`spi_controller_suspend()` failure instead of disabling clocks and
reporting success]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by / Tested-by / Reviewed-by / Acked-by:** none on this
  specific patch (sibling Broadcom patches in the same author’s work had
  Acked-by/Reviewed-by from Broadcom)
- **Link:** https://patch.msgid.link/tencent_54F5634545908FBA724E758054B
  F03953808@qq.com
- **Cc: stable:** absent (not a negative signal)
- **Signed-off-by:** Jiawen Liu (author); Mark Brown (SPI maintainer).
  Ignore Sasha Levin SOB (pipeline).
- **[Upstream commit faa878d4805c…]** / pipeline markers: ignored per
  instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `spi_controller_suspend()` can fail when pending transfers
  cannot be stopped; `bcmbca_hsspi_suspend()` ignored that and still
  disabled PLL and core clocks, then returned 0.
- **Symptom:** system suspend is reported successful while SPI clocks
  are gated with the queue possibly still active → MMIO to unclocked
  hardware, incomplete SPI transactions.
- **Version info:** none in the message. Driver added in v6.3; bug
  present from introduction.
- **Root cause:** missing return-value check before clock teardown.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not disguised. It is an explicit PM error-path fix: “Handle X
properly” / missing error check. Real bug, not style.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/spi/spi-bcmbca-hsspi.c` — **+5 / −1**
- Function: `bcmbca_hsspi_suspend()`
- Scope: **single-file surgical fix**

Upstream/context in the provided snippet also shows `remove()`/`#ifdef
CONFIG_PM_SLEEP` around it; the change that actually lands on this tree
is only the suspend return check (parent of `072b287a97bf3` matches
`v6.18.53` for this file, 0-line diff).

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `spi_controller_suspend(host)` return ignored →
  `clk_disable_unprepare(pll)` + `clk_disable_unprepare(clk)` → `return
  0`.
- **After:** if `spi_controller_suspend()` fails, return that error
  immediately; clocks stay enabled.
- Path: **system-sleep suspend error path**, not probe/init.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** logic / PM error-path correctness (resource teardown
  while transfers may still be running).
- **Mechanism:** this driver sets `host->transfer_one_message`, so
  registration calls `spi_controller_initialize_queue()` and
  `ctlr->queued = true`. `spi_controller_suspend()` then calls
  `spi_stop_queue()`, which polls up to 500 × ~10 ms (~5 s) and returns
  **`-EBUSY`** if the queue/busy bit never clears. The driver used to
  power down clocks anyway.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct and matches the usual SPI driver pattern (e.g.
  `rockchip_spi_suspend()` in this tree).
- Minimal; no API/data-structure changes.
- Regression risk is low. An automated review (sashiko-bot) noted that
  `spi_controller_suspend()` still sets `SPI_CONTROLLER_SUSPENDED` on
  failure, and a failed device suspend does not get `resume()`. That is
  a **pre-existing SPI core quirk** shared by most drivers that already
  check this return. The old path is worse: same flag is set **and**
  clocks are gated. Mark Brown applied the series without requesting an
  unwind.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Ignored `spi_controller_suspend()` + clock disable introduced in
  **`a38a2233f23b5`** (“spi: bcmbca-hsspi: Add driver for newer HSSPI
  controller”, William Zhang, 2023-02-09).
- First appeared: **`v6.3-rc1`**. Present for the entire life of this
  driver, including 6.18.y.

**Step 3.2: FOLLOW THE FIXES TAG**

Record: No Fixes tag. Buggy code is the original driver, not a later
regression.

**Step 3.3: CHECK FILE HISTORY**

Record (this file, newest first):
- `2b580ac54f40f` — modern PM macros (later autosel candidate; **not** a
  prerequisite)
- `072b287a97bf3` — **this** commit
- `148a3f03aec89` — resume-side clock cleanup (**already in v6.18.53**,
  had Fixes + Cc: stable)
- Driver-original suspend path otherwise unchanged since v6.3

Standalone. Cover letter: *“The patches are independent and only touch
the local error paths in each driver.”*

**Step 3.4: CHECK THE AUTHOR’S OTHER COMMITS**

Record: Jiawen Liu submitted a 4-patch SPI PM error-handling series
(atcspi200, **bcmbca-hsspi**, fsl-dspi, nxp-fspi). Additional similar
Broadcom fixes exist for bcm63xx / bcm63xx-hsspi / bcm-qspi. Author is a
regular contributor, not the SPI maintainer. Maintainer **Mark Brown**
applied all 4.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: None. Uses existing `spi_controller_suspend()`. Applies
standalone. Series 2/4 is independent.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c faa878d4805c`: **[PATCH 2/4] spi: bcmbca-hsspi: return
  error from failed controller suspend**
- Thread: https://patch.msgid.link/tencent_54F5634545908FBA724E758054BF0
  3953808@qq.com
- Cover: **[PATCH 0/4] spi: fix PM error handling in several drivers**
  (2026-06-20)
- `b4 dig -a`: **v1 only**; committed version is that v1.
- Human review: no NAK. Mark Brown applied to `spi/for-7.3`
  (git.kernel.org/broonie/spi/c/faa878d4805c).
- sashiko-bot: “permanently wedged in a suspended state” if error is
  propagated (SPI core marks suspended even on `-EBUSY`). No maintainer
  follow-up; patch still applied.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To Mark Brown; Cc William Zhang, Kursad Oney,
Jonas Gorski, bcm-kernel-feedback-list, Florian Fainelli, linux-spi,
linux-arm-kernel, etc. Right maintainers/lists. No Acked-by on this hunk
(unlike some sibling Broadcom patches).

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No syzbot, bugzilla, or user crash report. Bug is from code
inspection of the ignored return. The same driver’s **resume**
counterpart (`148a3f03aec89`) was user/author-driven with
Fixes+Cc:stable and is already in this tree.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Independent 2/4. Sibling Broadcom suspend-return patches are the
same class, not build/runtime dependencies. Resume clock-disable-on-
failure is already in 6.18.53; this is the suspend-side counterpart.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: lore.kernel.org returned 403; WebSearch of
`lore.kernel.org/stable` for this subject found **no** stable-specific
discussion. UNVERIFIED that anyone requested or rejected it on stable@;
no evidence of a known reason to skip it.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**

Record: `bcmbca_hsspi_suspend()` (modified). Callees of interest:
`spi_controller_suspend()`, `spi_stop_queue()`,
`clk_disable_unprepare()`.

**Step 5.2: TRACE CALLERS**

Record: Wired via `DEFINE_SIMPLE_DEV_PM_OPS(bcmbca_hsspi_pm_ops, …)` /
`.pm` on the platform driver. Called from the PM core on **system
sleep**, not from syscalls directly. Reachable on BCMBCA boards that
suspend with `CONFIG_SPI_BCMBCA_HSSPI` and `CONFIG_PM_SLEEP`.

**Step 5.3: TRACE CALLEES**

Record:
- `spi_controller_suspend()` → `spi_stop_queue()` if queued; always
  `__spi_mark_suspended()`.
- Then (success only, after this patch) clock disable.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record:
`pm_suspend` → `dpm_suspend` → `bcmbca_hsspi_suspend` →
`spi_controller_suspend` → `spi_stop_queue`.

In-flight work is `bcmbca_hsspi_transfer_one` → `bcmbca_hsspi_do_txrx`
doing `__raw_readl`/`__raw_writel` on `bs->regs`. Yanking clocks while
that runs is a hang/abort/corruption path. Userspace can keep the queue
busy (SPI flash, sensors) across a suspend request.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Most SPI drivers in this tree already check
`spi_controller_suspend()` (dw, tegra, rockchip, qup, pxa2xx, atmel, …).
This driver was an outlier. Same author’s bcm63xx/bcm-qspi patches fix
the same pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record: **Yes.** `v6.18.53:drivers/spi/spi-bcmbca-hsspi.c` still has:

```c
spi_controller_suspend(host);
clk_disable_unprepare(bs->pll_clk);
clk_disable_unprepare(bs->clk);
return 0;
```

`git merge-base --is-ancestor 072b287a97bf3 v6.18.53` → **not an
ancestor**. Bug introduced in v6.3, still in 6.18.53.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **Clean apply.** `git diff v6.18.53 072b287a97bf3^ --
drivers/spi/spi-bcmbca-hsspi.c` is empty. No rework needed. Later
“modern PM macros” commit is unrelated and not required.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Resume-side `148a3f03aec89` **is** in v6.18.53. No other
suspend-error check for this function. This is the missing counterpart,
not a duplicate.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: **drivers/spi** — Broadcom BCMBCA HSSPI
(`CONFIG_SPI_BCMBCA_HSSPI`, `depends on ARCH_BCMBCA || COMPILE_TEST`).
**PERIPHERAL / platform-specific**, but SPI NOR on those SoCs is often
boot/config flash, so a bad suspend is not cosmetic.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: SPI core is mature; this driver is small and not heavily
churned. Bug is long-standing (since v6.3), not a brand-new feature.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**

Record: **Platform-specific** — Broadcom BCMBCA (ARM/ARM64 broadband
SoCs: gateways/routers). Only if the HSSPI driver and system sleep are
enabled.

**Step 8.2: TRIGGER CONDITIONS**

Record: System suspend while the SPI queue stays busy for ~5 seconds
(`spi_stop_queue` limit). Uncommon, but exactly the dangerous case
(stuck or long transfer). Not a syzbot syscall crash; can be induced by
userspace SPI activity plus suspend. Unprivileged trigger depends on who
can open the SPI device and who can suspend (typically privileged).

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Clocks gated while the pump may still MMIO → bus hang, imprecise
  abort, or torn SPI NOR write.
- PM core is told suspend succeeded, so the machine continues into sleep
  with live SPI I/O unclocked.
- **Severity: HIGH** when it hits (corruption/hang); trigger is
  uncommon.

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** medium-high for BCMBCA devices that suspend; prevents
  clock-off during active SPI. Completes PM error handling already fixed
  on resume in this tree.
- **Risk:** very low (5 lines, standard pattern). Residual:
  `SPI_CONTROLLER_SUSPENDED` can stick if suspend fails (SPI core). That
  already exists for the majority of SPI drivers here; old code still
  set the flag **and** cut clocks.
- **Ratio:** benefit outweighs risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: EVIDENCE**

**For backporting:**
- Real PM bug: ignored `-EBUSY` from `spi_controller_suspend()`, then
  clock disable + `return 0`.
- Can unclock MMIO and corrupt in-flight SPI (including flash).
- 5-line, obviously correct, maintainer-applied (Mark Brown).
- Driver and buggy code exist in **this** 6.18.53 tree since v6.3.
- Applies cleanly; no prerequisites.
- Same class as the resume fix already in 6.18.53.
- Aligns this outlier with the rest of the SPI subsystem.

**Against:**
- No user/syzbot report; error path is uncommon (~5 s busy).
- Platform-specific (not all machines).
- Incomplete vs an unwind via `spi_controller_resume()` (SPI core marks
  suspended on failure).
- No Fixes/Cc:stable (expected here; not a reason to reject).

**Unresolved:**
- Could not fetch lore.kernel.org (403). Thread recovered via `b4 dig`
  mbox + LKML/openwall. No stable@ discussion found.

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — applied by SPI maintainer;
   pattern used across `drivers/spi`.
2. Fixes a real bug that affects users? **PASS** — ignored suspend
   failure + clock teardown.
3. Important issue? **PASS** — hang/abort/data corruption on active SPI
   during suspend, not a style tweak.
4. Small and contained? **PASS** — +5/−1, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — clean on v6.18.53.

**Step 9.3: EXCEPTION CATEGORIES**

Record: Not a device-ID/quirk/DT/build/doc exception. Ordinary small
bugfix.

**Step 9.4: DECISION**

This belongs in this 6.18.y tree. The bug is in the tree, the fix is
surgical, and leaving clocks on when the queue cannot stop is the
correct hardware behavior.

---

### Problem for stable users

On Broadcom BCMBCA HSSPI, suspend called `spi_controller_suspend()`
(which can return `-EBUSY` after ~5 s if transfers will not stop) and
then **always** disabled PLL/core clocks and returned success. That can
cut clocks under a live transfer (`bcmbca_hsspi_do_txrx` MMIO). This
tree already fixed the matching resume error path; suspend was still
wrong.

### Stable rules / risk

Meets the rules: real bug, small, no new API, clean apply to 6.18.53.
Risk is a few lines in one PM callback. Benefit is avoiding unclocked
SPI and false-successful suspend.

### Concerns

No extra commits needed. Sashiko’s “stuck SUSPENDED flag” note is a SPI-
core limitation already shared by most drivers; it does not make the old
“disable clocks anyway” path acceptable.

---

Verification:
- [Phase 1] Parsed subject/tags/body from `git show 072b287a97bf3` /
  upstream `faa878d4805c`; no Fixes/Reported-by; Link to msgid; Mark
  Brown SOB
- [Phase 2] Diff: +5/−1 in `bcmbca_hsspi_suspend()`; ignore →
  check/return
- [Phase 2] `spi_controller_suspend()` / `spi_stop_queue()` in
  `drivers/spi/spi.c`: queued controllers can return `-EBUSY`;
  `__spi_mark_suspended()` always runs
- [Phase 2] Driver sets `transfer_one_message`;
  `spi_register_controller()` initializes the queue (`ctlr->queued =
  true`)
- [Phase 3] `git blame 072b287a97bf3^`: buggy lines from `a38a2233f23b5`
  (v6.3-rc1)
- [Phase 3] `git log --oneline -- drivers/spi/spi-bcmbca-hsspi.c`:
  resume fix `148a3f03aec89` already in v6.18.53; this commit not in
  v6.18.53
- [Phase 3] `git merge-base --is-ancestor 072b287a97bf3 v6.18.53` → no;
  `git diff v6.18.53 072b287a97bf3^ -- drivers/spi/spi-bcmbca-hsspi.c` →
  0 lines
- [Phase 3] Author series via `git log --author="Jiawen Liu" --
  drivers/spi/`
- [Phase 4] `b4 dig -c faa878d4805c` / `-a` / `-w` / `-m`: v1 2/4,
  independent series, applied by Mark Brown 2026-06-30; Broadcom/SPI
  lists on Cc
- [Phase 4] Cover letter from lkml.iu.edu: patches independent
- [Phase 4] sashiko-bot mbox msg: SUSPENDED-flag concern; no NAK from
  maintainer
- [Phase 4] lore.kernel.org WebFetch 403; stable@ search found nothing
  relevant — UNVERIFIED no stable@ thread
- [Phase 5] Callers: PM ops only; callees: `spi_controller_suspend`,
  `clk_disable_unprepare`; transfer path uses MMIO
- [Phase 5] Similar pattern already in `spi-rockchip.c` and many other
  SPI drivers
- [Phase 6] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53; buggy suspend in `v6.18.53` file
- [Phase 7] `CONFIG_SPI_BCMBCA_HSSPI` depends on `ARCH_BCMBCA`
- [Phase 8] Failure mode: unclocked SPI MMIO / possible flash
  corruption; trigger = suspend with busy queue for ~5 s
- UNVERIFIED: live user reports of this suspend path; full
  lore.kernel.org HTML (403)

**YES**

 drivers/spi/spi-bcmbca-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcmbca-hsspi.c b/drivers/spi/spi-bcmbca-hsspi.c
index a1ff33f6dc095..50beb8443ea90 100644
--- a/drivers/spi/spi-bcmbca-hsspi.c
+++ b/drivers/spi/spi-bcmbca-hsspi.c
@@ -586,8 +586,12 @@ static int bcmbca_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcmbca_hsspi *bs = spi_controller_get_devdata(host);
+	int ret;
+
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
-	spi_controller_suspend(host);
 	clk_disable_unprepare(bs->pll_clk);
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0

