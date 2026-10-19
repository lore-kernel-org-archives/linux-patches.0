Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB0E5FB80C;
	Mon, 19 Oct 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418567; cv=none; b=kjytCsKxvKVpwzgSnu4Wcl1TuvHGXeFqn95ix8+IMfkAk4lxzlSMcBPPZpq7keBx8iEEc/+9Cgw8XK3CrOQ5VPAVsTKR2CTqJ7g5oUQOslOsvYtKXNgVhR7g14qVA4oZwHAbPK1uPzE3xrVUyO6jJ9prYz04xQGQnIWVCJH0hCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418567; c=relaxed/simple;
	bh=f5RGUbe88aw1muNZv2YXeZ9VqYKZsia+RsYKAzNc+MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Welx+rgVw3Epo0bXPIukTu6X/9vdL9Q8/6eq0UguQhhkM5ljBN1pFZ7JKhRz36Yj7b5zdzrR0WTHW6P3QOn+BtYaNkeFJ96m2Le0R4keROioqXRwkoOwK/f6NPLnaR9SvcdXcX6+XSXALWMht7XwmlKqoaza42M6w36XxD13C1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RHxD2Upf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RHxD2Upf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030431F000C4;
	Mon, 19 Oct 2026 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418565;
	bh=vdl7txQPoa/iZaFlNPBI+imk6kvqcynfyYKGxoYSSxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RHxD2Upfy0QxrhHhl5dp6Fjis3xXo4qy8oJ3kcFSNG5Mp1ZBpHrB6um1XcdYS4FaW
	 Nu6Sv98eEuH3MeN9U0RiEjLFTVXpfezapDHZXGJv5F3Qtpc0WXXQ++jebBhzIFXmI6
	 jeMKqSK6YAaZHsSm7G/rCJyBhEgf90YtUgoTCs5cz9UUKvFnYKxLLKYVgc/h45UzRZ
	 l+bUIH8sqKDVmLngU17QNQjaKI3uyIH40io82pbBCVKo6Iwu1LWvesl2xUTllqfbBm
	 x/K6Uke8wI1kdBZANZYFDX+b/l+4P//MVgwk0dhUXn/JS00AUUUsCmu3mgQjgjIkQP
	 UQqWbUR+DAfvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	William Zhang <william.zhang@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	kursad.oney@broadcom.com,
	jonas.gorski@gmail.com,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: bcm63xx-hsspi: return error from failed controller suspend
Date: Mon, 19 Oct 2026 09:50:29 -0400
Message-ID: <20261019135441.1420968-338-sashal@kernel.org>
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

[ Upstream commit 3b5414d76a0381db77b9694537254af7acfa187a ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_hsspi_suspend() ignored that error, disabled the
PLL and core clocks, and returned success.

Return the suspend error before disabling the clocks.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Acked-by: William Zhang <william.zhang@broadcom.com>
Link: https://patch.msgid.link/tencent_B5A06807924A77C8690730EBF7A052AABE05@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `spi: bcm63xx-hsspi: return error from
failed controller suspend`

Local tree is **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`, Makefile
`VERSION=6` / `PATCHLEVEL=18` / `SUBLEVEL=53`). The verdict is only for
this tree.

Upstream commit: `3b5414d76a0381db77b9694537254af7acfa187a` (Mark Brown,
2026-06-30). It is not an ancestor of `v6.18` or `v6.18.53`. The buggy
suspend path **is** present at `v6.18.53`.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject**
Record: `[spi] [return/propagate] return error from failed controller
suspend` — subsystem `spi: bcm63xx-hsspi:`; verb “return” meaning “stop
ignoring a failure.”

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Jiawen Liu <1298662399@qq.com>` (author)
- `Acked-by: William Zhang <william.zhang@broadcom.com>` (listed
  maintainer of this driver)
- `Link: https://patch.msgid.link/tencent_B5A06807924A77C8690730EBF7A052
  AABE05@qq.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
- No `Fixes:`, no `Reported-by:`, no `Cc: stable` (expected for this
  review)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`

**Step 1.3 — Body**
Record:
- **Bug:** `bcm63xx_hsspi_suspend()` ignores `spi_controller_suspend()`
  failure, then disables PLL and core clocks and returns 0.
- **Symptom:** system suspend is reported successful while the SPI queue
  may still be running and clocks are gated.
- **Root cause:** missing return-value check on
  `spi_controller_suspend()`.
- **Version info:** none in the message. Bug is in the original 2013
  driver (`142168eba9dc5`).

**Step 1.4 — Hidden bug fix?**
Record: Not hidden. It is an explicit error-path correctness fix
(ignored failure → clocks torn down anyway).

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record: one file, `drivers/spi/spi-bcm63xx-hsspi.c`, **+5 / −1**.
Function: `bcm63xx_hsspi_suspend()`. Surgical, single-file.

**Step 2.2 — Flow**
Record: **Before:** call `spi_controller_suspend(host)` and ignore the
result; always `clk_disable_unprepare()` on PLL and core clocks; return
0. **After:** if `spi_controller_suspend()` fails, return that error and
leave clocks enabled.

**Step 2.3 — Bug mechanism**
Record: **Logic / PM error-path.** `spi_controller_suspend()` for a
queued controller calls `spi_stop_queue()`, which polls up to 500 × ~10
ms and returns `-EBUSY` if the queue is still busy. The core still
`__spi_mark_suspended()` and returns that error. The driver then gated
clocks and lied to PM with success.

This driver sets `host->transfer_one_message` and does **not** set
`host->transfer`, so `spi_register_controller()` runs
`spi_controller_initialize_queue()` and sets `ctlr->queued = true`. The
failure path is reachable.

**Step 2.4 — Fix quality**
Record: Obviously correct; matches the established SPI driver pattern
(`spi-bcm63xx.c`, `spi-rockchip.c`, `spi-atmel.c`, etc.). Minimal.
Regression risk is low: on failure, suspend is aborted instead of
proceeding with clocks off. Pre-existing SPI-core behavior
(`__spi_mark_suspended()` even on queue-stop failure) is unchanged; this
patch does not make that worse, and it is the same contract every other
checked driver uses.

---

## PHASE 3: GIT HISTORY

**Step 3.1 — Blame (at `v6.18.53`)**
Record: ignored `spi_controller_suspend(host)` line from `2c40be6bc95bd`
(rename `master`→`host`, 2023). Original ignore-and-return-0 suspend is
`142168eba9dc5` (2013-12-04, “add bcm63xx HSSPI driver”), ancestor of
this tree.

**Step 3.2 — Fixes: tag**
Record: none. Buggy code has been in the driver since introduction; that
commit is in this tree.

**Step 3.3 — Related file history**
Record: `v6.18.53` already contains `b782a7cb0a424` (“disable clocks on
resume failure”, Can Peng, `Cc: stable`, `Fixes: 142168eba9dc`). That is
the resume-side counterpart of the same class of bug. No later revert of
this suspend fix.

**Step 3.4 — Author**
Record: Jiawen Liu; same-week series of the same one-line check on `spi-
bcm63xx.c`, `spi-bcm-qspi.c`, `spi-bcmbca-hsspi.c`. Not the driver
maintainer; **William Zhang**, who is, acked this patch.

**Step 3.5 — Prerequisites**
Record: none. Needs only `spi_controller_suspend()` (present since the
original driver) and the existing clock disable sequence. Standalone;
series 2/3 touches only this file. 1/3 is `spi-bcm63xx.c`, 3/3 is `spi-
bcm-qspi.c`.

---

## PHASE 4: MAILING LIST / EXTERNAL

**Step 4.1 — Original discussion**
Record: `b4 dig -c 3b5414d76a0381db77b9694537254af7acfa187a` → https://p
atch.msgid.link/tencent_B5A06807924A77C8690730EBF7A052AABE05@qq.com
`b4 dig -a`: **v1 only**, `[PATCH 2/3]`. Thread saved via `b4 dig -m`.
No NAK, no requested respin.

**Step 4.2 — Recipients (`b4 dig -w`)**
Record: `broonie@kernel.org`, `linux-spi@vger.kernel.org`,
`william.zhang@broadcom.com`, `kursad.oney@broadcom.com`,
`jonas.gorski@gmail.com`, `kamal.dasu@broadcom.com`, `bcm-kernel-
feedback-list@broadcom.com`. Right maintainers were on Cc.

**Step 4.3 — Bug report**
Record: no syzbot/bugzilla. Found by code review of ignored
`spi_controller_suspend()` returns.

**Step 4.4 — Series**
Record: 2/3 in a three-driver series. Each patch is a self-contained
per-driver check. William Zhang: `Acked-by` on this patch. Kamal Dasu:
`Reviewed-by` on 3/3 (`spi-bcm-qspi`). Mark Brown applied it.

**Step 4.5 — Stable list**
Record: lore.kernel.org search via WebFetch returned **403**. No stable-
thread evidence found. Absence of `Cc: stable` is expected for this
pipeline.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Functions**
Record: `bcm63xx_hsspi_suspend()` only.

**Step 5.2 — Callers**
Record: wired through `SIMPLE_DEV_PM_OPS(bcm63xx_hsspi_pm_ops, ...)` /
`platform_driver.driver.pm`. Invoked from the PM core on **system
sleep**, not a syscall hot path. Requires `CONFIG_SPI_BCM63XX_HSSPI` and
`CONFIG_PM_SLEEP`.

**Step 5.3 — Callees**
Record: `spi_controller_suspend()` → `spi_stop_queue()` (can return
`-EBUSY`); then `clk_disable_unprepare()` on PLL and core clocks.

**Step 5.4 — Reachability**
Record: Yes, on suspend of BCM63xx/BCMBCA boards that use this
controller (`brcm,bcm6328-hsspi`, `brcm,bcmbca-hsspi-v1.0` in MIPS
bcm63xx and ARM/ARM64 bcmbca DT). Trigger is suspend while the SPI queue
stays busy for ~5 seconds.

**Step 5.5 — Similar patterns**
Record: same ignore-error bug in sibling Broadcom SPI drivers; same
return-check already used in many in-tree SPI drivers. Systematic, not a
one-off style tweak.

semcode MCP tools were not available; this used `git grep` and direct
reads of `spi.c` / the driver.

---

## PHASE 6: LOCAL TREE CROSS-CHECK

**Step 6.1 — Buggy code in this tree?**
Record: **Yes**, at `v6.18.53` `bcm63xx_hsspi_suspend()`:

```c
spi_controller_suspend(host);
clk_disable_unprepare(bs->pll_clk);
clk_disable_unprepare(bs->clk);
return 0;
```

Bug introduced 2013, present for the whole 6.18.y lifetime.

**Step 6.2 — Backport difficulty**
Record: **clean apply with +6 line offset** (`patch --dry-run` succeeded
against the `v6.18.53` file). Surrounding `remove()` differs from later
mainline; the suspend hunk itself matches.

**Step 6.3 — Related fixes already here?**
Record: resume-path clock cleanup (`b782a7cb0a424`) **is** in
`v6.18.53`. This suspend-path check is **not**. No alternate fix for the
ignored suspend error.

---

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**
Record: **SPI driver** (`drivers/spi/spi-bcm63xx-hsspi.c`). Criticality:
**IMPORTANT** (platform SPI, often SPI flash on Broadcom CPE/BCA SoCs),
not core MM/VFS. Not staging.

**Step 7.2**
Record: Mature driver (2013), still maintained (William Zhang / Kursad
Oney / Jonas Gorski). Recent PM fix already landed in this stable
series.

---

## PHASE 8: IMPACT AND RISK

**Step 8.1 — Who is affected**
Record: users of `CONFIG_SPI_BCM63XX_HSSPI` on BCM63XX / BMIPS /
ARCH_BCMBCA (routers, gateways, BCA ARM64 boards). Not universal.

**Step 8.2 — Trigger**
Record: system suspend while `spi_stop_queue()` times out (`-EBUSY`
after ~5s of a non-empty queue or `ctlr->busy`). Unprivileged users
cannot hit it directly unless they can suspend. Timing-dependent; real
when a transfer is stuck or a long SPI flash op overlaps suspend.

**Step 8.3 — Failure mode**
Record: clocks gated while the controller may still be busy; PM is told
suspend succeeded. Possible bus hang, incomplete SPI transaction, or
SPI-flash corruption if a NOR/NAND op is in flight. Severity: **HIGH**
(hang / possible corruption on the error path), not a guaranteed oops on
every suspend.

**Step 8.4 — Risk/benefit**
Record: **Benefit: medium-high** for those platforms (correct suspend
abort, clocks stay on). **Risk: very low** (5 lines, error path only,
same pattern as peer drivers; resume counterpart already in this tree).
Ratio favors backport.

---

## PHASE 9: SYNTHESIS

**Step 9.1 — Evidence**

For:
- Real PM bug: ignored `-EBUSY`, then clock gate + success.
- Queued controller, so `spi_stop_queue()` can actually fail.
- Possible hang / in-flight SPI (including flash) with clocks off.
- 5-line, obviously correct, no new API.
- Acked by driver maintainer; applied by SPI maintainer.
- Resume-side analogue already in 6.18.53 as a `Cc: stable` fix.
- Applies to `v6.18.53` with only a line-number offset.
- Bug present since 2013 in this tree.

Against:
- No `Reported-by` / syzbot / crash log.
- Trigger is the uncommon queue-stop timeout, not every suspend.
- SPI core still marks the controller suspended on failure (pre-
  existing; this patch does not fix or worsen that).
- Peripheral SoC driver, not core kernel.

Unresolved: lore.kernel.org HTML/WebFetch was 403; discussion recovered
via `b4 dig -m` instead.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — trivial check; acked by
   maintainer; in mainline.
2. Real bug affecting users? **PASS** — wrong suspend result and clocks-
   off while busy.
3. Important (crash/security/corruption/deadlock)? **PASS** — hang /
   possible SPI-flash corruption if suspend proceeds after queue-stop
   failure; same class as the resume fix already in this tree.
4. Small and contained? **PASS** — +5/−1, one function.
5. No new features/APIs? **PASS**.
6. Can apply to this tree? **PASS** — buggy code present; applies with
   offset 6.

**Step 9.3 — Exception category**
Record: none (not a device ID / quirk / DT / build / docs exception). It
is a normal small bugfix.

**Step 9.4 — Decision**
This belongs in 6.18.y: it stops the driver from disabling HSSPI clocks
and reporting successful suspend when the SPI core could not stop the
queue. The matching resume cleanup is already here; this is the suspend-
side hole that lacked a `Cc: stable` tag.

---

## What the commit solves (for this tree)

On Broadcom BCM63xx/BCMBCA HSSPI, system suspend called
`spi_controller_suspend()` and ignored `-EBUSY` from `spi_stop_queue()`.
It then turned off the PLL and core clocks and returned 0, so the PM
core continued suspend while the controller could still be busy. That
can hang the bus or interrupt an in-flight SPI flash transfer. The fix
returns the error and leaves clocks enabled so suspend is aborted.

It meets the stable rules: real bug, important on the failure path, five
lines, no new API, applies to 6.18.53.

Risk vs benefit: very low risk, meaningful benefit on the platforms that
use this driver. No missing prerequisites.

---

## Verification

- **[Phase 1]** Parsed tags: author Jiawen Liu; Acked-by William Zhang;
  SOB Mark Brown; Link to msgid; no Fixes/Reported-by/Cc-stable.
- **[Phase 2]** Diff: +5/−1 in `bcm63xx_hsspi_suspend()`; check
  `spi_controller_suspend()` before `clk_disable_unprepare`.
- **[Phase 2]** `spi_controller_suspend()` in `drivers/spi/spi.c`: on
  `ctlr->queued`, `spi_stop_queue()` can return `-EBUSY`; then
  `__spi_mark_suspended()`; return `ret`.
- **[Phase 2]** `spi_stop_queue()`: 500 iterations ×
  `usleep_range(10000, 11000)`, then `-EBUSY`.
- **[Phase 2]** Driver sets `transfer_one_message`, not `transfer`; core
  sets `queued = true` (also true at `v6.18.53`).
- **[Phase 3]** `git blame` at `v6.18.53`: ignore-error suspend from
  original `142168eba9dc5` (2013); `git merge-base --is-ancestor
  142168eba9dc5 v6.18.53` → YES.
- **[Phase 3]** `git merge-base --is-ancestor
  3b5414d76a0381db77b9694537254af7acfa187a v6.18.53` → NO (fix not in
  6.18.53).
- **[Phase 3]** Resume counterpart `b782a7cb0a424` **is** ancestor of
  `v6.18.53` (Can Peng, `Cc: stable`).
- **[Phase 3]** No revert of this change in `drivers/spi/spi-bcm63xx-
  hsspi.c`.
- **[Phase 4]** `b4 dig -c 3b5414d76a0381…`: lore msgid above; v1 only;
  William Zhang Acked-by; no NAK.
- **[Phase 4]** `b4 dig -w`: SPI list + Broadcom maintainers Cc’d.
- **[Phase 4]** `b4 dig -m /tmp/hsspi-thread.mbox`: 4 messages, series
  2/3 standalone.
- **[Phase 4]** WebFetch of lore.kernel.org: 403; discussion taken from
  b4 mbox instead.
- **[Phase 5]** Callers: `SIMPLE_DEV_PM_OPS` → platform PM; CONFIG
  `SPI_BCM63XX_HSSPI` depends on `BCM63XX || BMIPS_GENERIC ||
  ARCH_BCMBCA`.
- **[Phase 5]** DT: `brcm,bcm6328-hsspi` / `brcm,bcmbca-hsspi-v1.0` on
  bcm63xx MIPS and bcmbca ARM/ARM64.
- **[Phase 6]** `git describe HEAD` / `make kernelversion`: 6.18.53.
- **[Phase 6]** `git show v6.18.53:drivers/spi/spi-bcm63xx-hsspi.c`:
  still ignores suspend error.
- **[Phase 6]** `patch --dry-run` against that file: hunk succeeded at
  line 895 (offset 6).
- **[Phase 7]** MAINTAINERS: “BROADCOM Broadband SoC High Speed SPI
  Controller DRIVER”, M: William Zhang.
- **[Phase 8]** Failure mode verified from `spi.c` + driver suspend
  path, not from a user crash report.
- **UNVERIFIED:** live reproduction of `spi_stop_queue()` timeout on BCM
  hardware; stable@ lore thread (HTTP 403).

The fix is small, surgical, present as a real bug in this 6.18.53 tree,
and meets the stable criteria.

**YES**

 drivers/spi/spi-bcm63xx-hsspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b8bf8b5be2cf7..719f0dfd96c96 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -895,8 +895,12 @@ static int bcm63xx_hsspi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_hsspi *bs = spi_controller_get_devdata(host);
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

