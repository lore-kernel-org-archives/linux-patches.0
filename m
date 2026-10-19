Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E6D55C9ED;
	Mon, 19 Oct 2026 14:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418542; cv=none; b=XkFL7oiM1k1w9XpnYKytGufPA2VDwR2bAP+hOsS9gILN+4Sl4Q4Yuv/QFLmpqEvWw5m/XEeNW/vhYc/IM/AhoThGezodfeRWI6I61pghLK5EFmjCptGVEYe+jqPWvuv7r4rjroZ+bVQC3woC4t3UgG0ARuoX3jzW2vql9GanfFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418542; c=relaxed/simple;
	bh=mBnFuEmR5M6hh2W7Mvg2qJy5zsN47fRlz1J+n0UnHyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e/RNxc2o3NJ6jkVE832M8clw2XL39E15H6kMUZOLPD00Nobe6e9K9TeD3pxlx7UXUsrWOlDzZhRCzCWiVH+o42S42gt8smo9/9gFumS1NeNjBCxe1tCuirPzJhjD6AMgRLdL7PqXTSZO3ARQADpdPNk1BnfN/RSue7Y/ED6rxfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HRTl4aWl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HRTl4aWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682A51F000C8;
	Mon, 19 Oct 2026 14:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418539;
	bh=wJanyPYzwia2YgvpTrDGiPJGpcwS4lC4ifSQzdR5SHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRTl4aWlONJurGA/9b0VRcMR4JjqtttSTmjkohkdYIilm7mCInBvDOtiOHa0fl7HU
	 PVYf0ZsoGqrMRjoV6hrWORT0Knu84VPpd7t2k8xAq77bZRPRH85fdyGjbOY6fx3nSr
	 kQJSqYOcO7LehP893by7/+VuMACn2OUtkyEq6/Dd0uoUi414jYIi3JYORwfwDOhdOI
	 zAH+17OCh7W88dr1pjqpkvYdb9ktMUd/YjdSJxB2A4BD71dpqF1Yk+774eujnB5nQ/
	 Hdyd51u7l0g00ayHz6IeCzgmA0EorHDJcKB7FAS4YbOr/NdEr5oZgh8DU6cPWDpg2I
	 uMCk4xQ7oBrbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jonas.gorski@gmail.com,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: bcm63xx: return error from failed controller suspend
Date: Mon, 19 Oct 2026 09:50:11 -0400
Message-ID: <20261019135441.1420968-320-sashal@kernel.org>
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

[ Upstream commit bbbc1ef5b35341c5122418a14f8924688a4bb954 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm63xx_spi_suspend() ignored that error, disabled the
controller clock, and returned success.

Return the suspend error before tearing down the clock.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803725905@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The tree is **6.18.53** (`v6.18.53`, Makefile `VERSION=6 PATCHLEVEL=18
SUBLEVEL=53`). The buggy suspend path is in this checkout; the upstream
fix is not in `v6.18.53`. Verdict is for this tree only.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[spi: bcm63xx:]` `[return]` Return error from failed
`spi_controller_suspend()` instead of ignoring it and disabling the
clock.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Signed-off-by: Jiawen Liu <1298662399@qq.com>` (author)
- `Link: https://patch.msgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803
  725905@qq.com`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, or `Cc: stable` (absence expected for this review)
- Author SOB only besides Mark Brown (Sasha Levin SOB ignored per rules)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- [Bug] `bcm63xx_spi_suspend()` ignores `spi_controller_suspend()`
  failure, then `clk_disable_unprepare()` and returns 0.
- [Symptom] Suspend reported success with the controller clock already
  torn down after a failed queue stop.
- [Version info] None in the message. Code has been this way since the
  driver was added.
- [Root cause] `spi_controller_suspend()` can return `-EBUSY` when
  `spi_stop_queue()` cannot drain the queue; the driver treated that as
  success.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit error-propagation / PM correctness
fix (clock must not be gated if the core could not stop the controller).

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/spi/spi-bcm63xx.c` (+4 / -1)
- Function: `bcm63xx_spi_suspend()`
- Scope: single-file surgical PM error-path fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before: call `spi_controller_suspend(host)` and ignore the
result, then always `clk_disable_unprepare(bs->clk)` and `return 0`.
After: capture `ret`; if non-zero, return it immediately and leave the
clock enabled.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: [Logic / PM error handling] The SPI core can fail to stop the
queued pump (`spi_stop_queue()` polls ~5s then returns `-EBUSY`).
Continuing to ungated-clock teardown and reporting success leaves the
kthread able to touch the controller with the clock off (hang /
imprecise abort) and lets system suspend proceed with an active/busy SPI
block.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and matches the long-standing pattern in other
in-tree SPI drivers (`spi-atmel`, `spi-rockchip`, `spi-bcm63xx-hsspi`,
etc.). Minimal. Regression risk is low: on failure, suspend aborts and
the clock stays on. Residual SPI-core quirk: `spi_controller_suspend()`
still calls `__spi_mark_suspended()` even on `spi_stop_queue()` failure
(pre-existing; not introduced here).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Ignore-and-disable-clock dates to `b42dfed83d95a3` (“spi: add
Broadcom BCM63xx SPI controller driver”, 2012-03-09). Present in this
tree. `spi_controller_suspend()` has returned `spi_stop_queue()` errors
and marked `SPI_CONTROLLER_SUSPENDED` since `bef4a48f4ef798`
(2023-11-10, already in `v6.18.53`).

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. The behavioral gap exists
because the driver never checked a return value that can fail.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Related in this tree: `0acbfd61aee18` (“spi: bcm63xx: disable
clock on resume failure”) is already in `v6.18.53` (explicit `Cc:
stable`). Same author’s series: `spi-bcm63xx-hsspi` and `spi-bcm-qspi`
get the same suspend check; each patch is per-driver and standalone.
This is patch 1/3, self-contained.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jiawen Liu is not the driver maintainer; Jonas Gorski is listed
as Odd Fixes. Mark Brown applied the series. Author also sent the
sibling Broadcom SPI suspend checks.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `spi_controller_suspend()` /
`clk_disable_unprepare()`. Dry-run apply of this hunk onto
`v6.18.53:drivers/spi/spi-bcm63xx.c` succeeded (`rc 0`).

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c bbbc1ef5b35341c5122418a14f8924688a4bb954` → https://patch.m
  sgid.link/tencent_0BD7D4091B90EC17A8B2BA5EBA8803725905@qq.com
- `-a`: v1 only, `[PATCH 1/3]`
- Thread: submission + Mark Brown “Applied to for-7.3” (no NAK, no
  requested respin, no reviewer `Cc: stable`)

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): `broonie@kernel.org`, `linux-spi@vger.kernel.org`,
Broadcom list, `jonas.gorski@gmail.com`, Broadcom SPI contacts.
Maintainer applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, syzbot, or bugzilla. Code-inspection fix. No
evidence of a field crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Series is three independent driver patches (bcm63xx, bcm63xx-
hsspi, bcm-qspi). This one does not need the others. Resume-side
counterpart (`spi: bcm63xx: disable clock on resume failure`) already
landed in `v6.18.53`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No stable-list discussion found for this subject.
lore.kernel.org WebFetch returned 403; thread recovered via `b4 dig -m`.
UNVERIFIED: exhaustive lore.kernel.org/stable search via HTTP.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `bcm63xx_spi_suspend()`; callees `spi_controller_suspend()`,
`clk_disable_unprepare()`.

**Step 5.2: TRACE CALLERS**
Record: Only wired through `DEFINE_SIMPLE_DEV_PM_OPS(bcm63xx_spi_pm_ops,
...)` → platform driver `.pm`. System-sleep path, not a syscall.
Triggered on suspend/hibernate of BCM63xx/BMIPS boards with this
controller.

**Step 5.3: TRACE CALLEES**
Record: `spi_controller_suspend()` (`drivers/spi/spi.c`): if
`ctlr->queued`, `spi_stop_queue()`; always `__spi_mark_suspended()`;
returns `-EBUSY` on timeout. `spi_stop_queue()` waits up to 500 × ~10
ms.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: `bcm63xx` sets `host->transfer_one_message` and does not set
`host->transfer`, so `spi_register_controller()` calls
`spi_controller_initialize_queue()` and `ctlr->queued = true`. The
failure path is reachable. Userspace can keep the queue busy (SPI flash,
sensors); a stuck IRQ/transfer makes `-EBUSY` realistic.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same ignore-then-ungate bug was fixed in sibling Broadcom SPI
drivers. Many other SPI hosts already check and return
`spi_controller_suspend()` errors.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, at `v6.18.53` in `bcm63xx_spi_suspend()`:

```c
spi_controller_suspend(host);
clk_disable_unprepare(bs->clk);
return 0;
```

`git merge-base --is-ancestor bbbc1ef5b35341c5122418a14f8924688a4bb954
v6.18.53` → not an ancestor. Bug present since 2012; fail-able
`spi_controller_suspend()` since 2023 (in this tree).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding `bcm63xx_spi_resume()` already matches
current mainline (resume error path already backported).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Resume-side clock rollback is already in `v6.18.53`. No earlier
version of this suspend check.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/spi/` Broadcom BCM6348/BCM6358 controller. Criticality:
PERIPHERAL (SoC-specific), but real OpenWrt/BMIPS users.
`CONFIG_SPI_BCM63XX` depends on `BCM63XX || BMIPS_GENERIC ||
COMPILE_TEST`. Maintainer status: Odd Fixes.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: File still gets real fixes in 6.18.y (shared reset, CS,
deregistration, resume clock). Mature driver, not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific: BCM63xx and BMIPS platforms
using this SPI host, on system suspend.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: System suspend while the SPI message pump is still busy after
~5s. Not every boot; can be hit if a transfer is stuck or the queue
cannot drain. Unprivileged users can keep SPI busy; they cannot directly
call the PM callback (needs suspend permission).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Clock gated while the queued pump may still run → MMIO with
clock off, possible bus hang, incomplete in-flight SPI (flash). PM
reports success, so the system continues suspend. Severity: HIGH (hang /
possible device corruption on a rare path). Not a universal panic.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: Benefit: high for affected boards (do not sleep with SPI still
active and clock off). Risk: very low (4 insertions, error return only).
Residual: on failure the core still sets `SPI_CONTROLLER_SUSPENDED` and
PM skips resume for this device (`is_suspended` stays false), so SPI may
stay `-ESHUTDOWN` until a later successful suspend/resume. That core
behavior already exists; other hosts already return the error the same
way. Ratio: favor backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real PM bug: ignore failure, ungated clock, return success
- Failure mode is hang / in-flight SPI with clock off, not cosmetic
- Driver is queued, so `spi_controller_suspend()` can return `-EBUSY`
- 5-line, obviously correct, same pattern as other SPI hosts and the
  sibling series
- SPI maintainer applied it; driver maintainer was CCed
- Buggy code is in `v6.18.53`; patch applies cleanly; no prerequisites
- Resume-side analogue already taken for this stable tree

AGAINST:
- No user/syzbot report; inspection-only
- Trigger is uncommon (queue-stop timeout)
- Peripheral SoC driver, Odd Fixes
- Sent to for-7.3 merge window, not as an urgent -rc fix
- SPI core still marks suspended on failure (pre-existing)

UNRESOLVED:
- HTTP fetch of lore.kernel.org/stable returned 403 (thread obtained via
  `b4`)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — mechanical return-value
   check; maintainer applied v1 with no NAK
2. Fixes a real bug that affects users? **PASS** — clock off + fake
   success on failed controller stop
3. Important issue? **PASS** — hang / inconsistent hardware on suspend,
   not a new feature
4. Small and contained? **PASS** — +4/-1, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — dry-run clean on `v6.18.53`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not an ID/quirk/DT/build/docs exception). Qualifies as a
normal small bugfix.

**Step 9.4: DECISION**
Backport. The bug exists on this 6.18.53 tree, the fix is surgical, and
leaving suspend success + clock off after a failed queue stop is worse
than aborting suspend.

------------------------------------------------
What the commit solves for this tree
`bcm63xx_spi_suspend()` must not disable the controller clock or report
success if `spi_controller_suspend()` failed. On BCM63xx this host is
queued, so that call can return `-EBUSY`. Continuing would let the pump
access the block with the clock off and let system suspend proceed
anyway.

Stable rules
Meets all six criteria: small, obviously correct, no new API, real PM
bug, applies cleanly here.

Risk vs benefit
Benefit is avoiding a hang/inconsistent SPI across suspend on these
SoCs. Risk is a 4-line error return that matches the rest of the SPI
stack.

Concerns
No field report; rare trigger; Odd Fixes driver. None of that outweighs
a clean, standard PM error-path fix whose resume counterpart is already
in this tree.

Verification:
- [Phase 1] Subject/tags parsed from the supplied message and `git show
  df107c1912ab6` / upstream `bbbc1ef5b353`
- [Phase 2] Diff is +4/-1 in `bcm63xx_spi_suspend()` only
- [Phase 3] `git blame` / `git show b42dfed83d95a3`: ignore-clock-off
  since 2012; `bef4a48f4ef798` in `v6.18.53`
- [Phase 3] `git merge-base --is-ancestor bbbc1ef5… v6.18.53` → not
  present; buggy code confirmed via `git show v6.18.53:drivers/spi/spi-
  bcm63xx.c`
- [Phase 3] `0acbfd61aee18` resume fix already in `v6.18.53`
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 1/3, Mark Brown applied, no NAK;
  lore HTTP 403
- [Phase 5] `spi_register_controller()` queues this driver;
  `spi_stop_queue()` can return `-EBUSY`
- [Phase 6] `patch --dry-run` of this commit onto `v6.18.53` file: rc 0
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.53
- [Phase 7] MAINTAINERS: Odd Fixes, Jonas Gorski; Kconfig `SPI_BCM63XX`
- [Phase 8] PM core: failed suspend does not set `is_suspended`, so this
  device’s resume is skipped — pre-existing core mark-suspended-on-error
- UNVERIFIED: exhaustive lore.kernel.org/stable HTTP search (403)

**YES**

 drivers/spi/spi-bcm63xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 8d152e906daac..f73dc14533dcc 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -643,8 +643,11 @@ static int bcm63xx_spi_suspend(struct device *dev)
 {
 	struct spi_controller *host = dev_get_drvdata(dev);
 	struct bcm63xx_spi *bs = spi_controller_get_devdata(host);
+	int ret;
 
-	spi_controller_suspend(host);
+	ret = spi_controller_suspend(host);
+	if (ret)
+		return ret;
 
 	clk_disable_unprepare(bs->clk);
 
-- 
2.53.0

