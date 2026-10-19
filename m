Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C55A877C;
	Mon, 19 Oct 2026 13:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418398; cv=none; b=npjRpqcf9Eq1/1n+xjZwRNJ2Jp9mX6iZACuvxMp3ewrIdZgm0806PRVbWAYAE+VmUjdyTjs4Lqz70bU6xlNcYhC+ZJXok4zjVGaP4XMLRhl+CzP5fpFEwBavAHNgDz8NwUjxGqMMgLjeYVmem6+rqSYKlagNGB3w9uVtGqYJQRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418398; c=relaxed/simple;
	bh=+rgjnN/rn8QdW3E3GektyquPiRgfKGPkpWDkXktqH6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XVUnXvs7G9AIOsB/sUL5EmzzZdaSG6SkpQKpg+r8YdP4kZttt42hpl1yiO9f8Cu9muJFmH1RCGhaCf1ASohoeSJ3ugKKrWq/RzTCsyR6+vk/w4PkL4hjOynK2CutJAB9UmDllVGyRkqyOhJkoDOuTOiRMaKxqHcFjlXtfiRksak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LgGNWYvW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LgGNWYvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DA21F000C6;
	Mon, 19 Oct 2026 13:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418396;
	bh=nN/oj2G5DXBDEezzna4kzmDv57r3wtSqLKW0ihvmoIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LgGNWYvWdAWYEOfEGwPYju1kkIERwCaqrmJPwJh5Hoc2QXTBw0kRbzU/+tm4xqdwW
	 cw6M8tqI/3bZI251JuyYiSjoulXy86IuF8WpQbYCeg+3b7JhyqQ1pIvB6TEaUMLPws
	 ygOkWvJzVaP1rchokQ8aCgdhuAAhpCZfui5mj6FDm/9wkAuThse+FkAZ0NHr2QGjpp
	 k99UpEqCiMDZjj0E3L7WVez9ghKan+e3G9H5gEFk5JvHQAJcYwXxICM2ls9zjfEgQV
	 Otugq+bYo3Y630lnh8lOOYfEyMmhZK9zu72xZWsN+4iJyBUCWBKwhJlMjAdFtCp56G
	 mq9DKuBLDWoDA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Liu <1298662399@qq.com>,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: bcm-qspi: return error from failed controller suspend
Date: Mon, 19 Oct 2026 09:48:31 -0400
Message-ID: <20261019135441.1420968-220-sashal@kernel.org>
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

[ Upstream commit 44d09ef0ba690ac46d17eb05c12a47a5dd75e231 ]

spi_controller_suspend() can fail if the SPI core cannot stop the
controller. bcm_qspi_suspend() ignored that error, disabled the
controller clock, uninitialized the hardware, and returned success.

Return the suspend error before tearing down the clock and hardware
state.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>
Link: https://patch.msgid.link/tencent_21BF5F9512F56D45FD9018BAF14ED2805808@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`autosel`). The buggy ignore-and-teardown
path is in that base, and this is a small PM error-path fix that belongs
there.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[spi / bcm-qspi] [return] [propagate
`spi_controller_suspend()` failure instead of tearing down
clocks/hardware and reporting success]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — **absent** (expected for autosel review; not a negative)
- `Reported-by:` — **absent**
- `Tested-by:` — **absent**
- `Reviewed-by: Kamal Dasu <kamal.dasu@broadcom.com>` — **driver
  maintainer** (MAINTAINERS: “BROADCOM SPI DRIVER”)
- `Acked-by:` — none on this commit; sibling patch 2/3 was Acked-by
  William Zhang (Broadcom)
- `Link: https://patch.msgid.link/tencent_21BF5F9512F56D45FD9018BAF14ED2
  805808@qq.com`
- `Cc: stable@` — **absent** (expected)
- `Signed-off-by: Jiawen Liu <1298662399@qq.com>` (author)
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (SPI maintainer)
- Pipeline tags (`[Upstream commit 44d09ef0ba69…]`, Sasha Levin SOB)
  **ignored** per instructions

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `spi_controller_suspend()` can fail when the SPI core cannot
  stop the controller. `bcm_qspi_suspend()` discarded that return value.
- **Symptom:** On that failure the driver still
  `clk_disable_unprepare()`s, calls `bcm_qspi_hw_uninit()`, and
  **returns 0**, so PM continues as if suspend succeeded.
- **Root cause (author):** ignored error, then hardware teardown.
- **Version info in message:** none.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** It is an explicit error-propagation fix: keep
clocks/HW up and fail device suspend if the controller cannot be
stopped.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/spi/spi-bcm-qspi.c` — **+5 / −1**
- Function: `bcm_qspi_suspend()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: **Before:** always call `spi_controller_suspend()`, then disable
the clock, uninit HW, return 0. **After:** if `spi_controller_suspend()`
returns non-zero, return that error **before** clock disable /
`bcm_qspi_hw_uninit()`. Normal success path unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Logic / PM error-path]**
`spi_controller_suspend()` → for queued controllers, `spi_stop_queue()`.
That polls up to 500 × ~10 ms and returns **`-EBUSY`** if the queue is
still non-empty or `ctlr->busy`. This driver sets `host->transfer_one =
bcm_qspi_transfer_one`, so `spi_register_controller()` calls
`spi_controller_initialize_queue()` and sets `ctlr->queued = true`.
Failure is therefore reachable.

Old code then:
1. Disables the controller clock
2. `bcm_qspi_hw_uninit()` writes MSPI registers (clears `MSPI_SPCR2`,
   write lock, status)
3. Reports success so system suspend proceeds

That can interrupt an in-flight QSPI transfer (this hardware is used as
SPI NOR on Broadcom STB / iProc).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct** and matches the standard pattern already
used by many SPI drivers (`spi-rockchip`, `spi-qup`, `spi-dw-core`,
`spi-bcm63xx`, etc.). **Regression risk is low:** 5 lines, error path
only. Residual SPI-core quirk: `spi_controller_suspend()` still calls
`__spi_mark_suspended()` even on `spi_stop_queue()` failure; that is
pre-existing core behavior, not introduced here, and is the same
contract other drivers already rely on.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Ignore-and-teardown dates to **`fa236a7ef24048`** (“spi: bcm-qspi: Add
  Broadcom MSPI driver”, Kamal Dasu, 2016) which called
  `spi_master_suspend()` and always returned 0.
- Rename to `spi_controller_suspend(qspi->host)`: **`ec271c04ae93b8`**
  (2023), no functional change.
- Clock path: **`1b7ad8c405c3dc`** (2020) switched to
  `clk_disable_unprepare()`.
- Bug has been in the driver since introduction (**v4.9-era**), not new
  6.18 code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No `Fixes:` tag.** Buggy behavior is original suspend
implementation, not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Standalone among bcm-qspi changes. Same author submitted a
3-patch series of the same pattern:
- `spi: bcm63xx: return error from failed controller suspend`
- `spi: bcm63xx-hsspi: …`
- **this patch (3/3)**
- later sibling: `spi: bcmbca-hsspi: …`
Each driver is independent; this patch does not need the others.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Jiawen Liu is a regular SPI error-handling contributor, not this
driver’s maintainer. Weight comes from **Reviewed-by Kamal Dasu**
(listed maintainer) and **SOB Mark Brown**.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None.** Uses `qspi->host` and `spi_controller_suspend()`, both
in v6.18.53. Standalone.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 44d09ef0ba69` → **https://patch.msgid.link/tencent_21BF5F95
  12F56D45FD9018BAF14ED2805808@qq.com**
- Subject: `[PATCH 3/3] spi: bcm-qspi: return error from failed
  controller suspend`
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: Kamal Dasu **Reviewed-by**; no NAK; no request for further
  changes

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To Mark Brown (`broonie@`); Cc `linux-spi`, Kamal
Dasu, `bcm-kernel-feedback-list`, Jonas Gorski, Kursad Oney, William
Zhang. Right maintainers were on the patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: **No bugzilla/syzbot/user crash report.** Bug is derived from
code review of ignored return value.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 3/3 series; each patch is a per-driver copy of the same check.
This commit is self-contained.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** — `lore.kernel.org/stable/` HTTP 403 from this
environment. SPI list thread (via `b4 dig -m`) had no stable nomination
and no objection.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `bcm_qspi_suspend` (modified). Callees of interest:
`spi_controller_suspend`, `clk_disable_unprepare`, `bcm_qspi_hw_uninit`.

**Step 5.2: TRACE CALLERS**
Record: Wired via `bcm_qspi_pm_ops` (`SIMPLE_DEV_PM_OPS` /
`DEFINE_SIMPLE_DEV_PM_OPS`), exported and used by:
- `drivers/spi/spi-brcmstb-qspi.c` (`brcm,spi-brcmstb-qspi` / `brcm,spi-
  brcmstb-mspi`)
- `drivers/spi/spi-iproc-qspi.c`
Called from the PM core on system suspend, not from a syscall directly.

**Step 5.3: TRACE CALLEES**
Record: `spi_controller_suspend` → `spi_stop_queue` (queued) → `-EBUSY`
after ~5s; then `__spi_mark_suspended`. `bcm_qspi_hw_uninit` performs
MMIO to stop MSPI.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: **Userspace-reachable indirectly:** suspend-to-idle/S3 with in-
flight SPI (SPI-NOR, userspace spidev, etc.). Not a syscall crash path;
a **system-suspend** path. If QSPI backs system flash, interrupting a
write/erase is a **data-corruption** risk.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same ignore-return bug was fixed in sibling Broadcom SPI drivers
in the same series. Vast majority of in-tree SPI drivers already check
`spi_controller_suspend()`’s return.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
`make kernelversion` → **6.18.53**.
`v6.18.53:drivers/spi/spi-bcm-qspi.c` still has:

```c
spi_controller_suspend(qspi->host);
clk_disable_unprepare(qspi->clk);
bcm_qspi_hw_uninit(qspi);
return 0;
```

Original driver commit `fa236a7ef24048` **is** an ancestor of
`v6.18.53`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** to this 6.18.y file: the pre-image hunk is byte-
identical in `v6.18.53`. No `master` vs `host` rename needed (already
`qspi->host`).

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix is **not** in `v6.18.53` (`git log v6.18.53
--grep="return error from failed controller suspend" -- drivers/spi/` is
empty). No alternate fix in the file.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drivers/spi, Broadcom QSPI]** **[IMPORTANT for that hardware,
PERIPHERAL globally]**. Not core mm/net, but this controller commonly
backs SPI-NOR on Broadcom STB and iProc boards.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (2016), still maintained (Kamal Dasu). SPI core
still actively developed. This is a long-standing hole, not churn from a
new subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific:** Broadcom STB and iProc
QSPI users who suspend. Config: `CONFIG_SPI_BCM_QSPI` and SoC glue
drivers.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: System suspend while the SPI message queue cannot drain within
~5s (`-EBUSY`). Unprivileged users cannot trigger it except insofar as
they can generate SPI traffic and then suspend (typically privileged).
**Not common** on a healthy idle bus; **realistic** if a transfer is
stuck or messages keep arriving during freeze.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure mode:** clock off + MMIO uninit while the controller
is still busy, then suspend proceeds. Outcomes: hung MMIO, incomplete
SPI NOR program/erase, **possible flash corruption**, later resume with
HW already torn down. **Severity: HIGH** (data corruption / crash on a
real suspend error path). Not a panic on every boot.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit: medium–high** for affected platforms (correct abort of
  suspend; no teardown while busy).
- **Risk: very low** (5 lines, error path, maintainer-reviewed, same
  pattern as many drivers).
- **Ratio: favorable.**

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real ignored-error bug: teardown + success after
  `spi_controller_suspend()` fails
- Driver is queued (`transfer_one`), so `-EBUSY` is a real return
- Teardown while busy can corrupt SPI-NOR or touch unclocked MMIO
- 5-line, obviously correct, matches subsystem convention
- Reviewed by the listed Broadcom SPI maintainer; applied by Mark Brown
- Buggy code present since 2016; present in **this** 6.18.53 tree
- Applies cleanly; no prerequisites

**AGAINST:**
- No user `Reported-by`, syzbot, or `Fixes:`
- Trigger is the uncommon queue-stop timeout, not every suspend
- Affects only Broadcom QSPI platforms
- No explicit `Cc: stable` (not a negative under these rules)

**UNRESOLVED:**
- Could not query `lore.kernel.org/stable/` (HTTP 403)
- No public reproducer beyond the code path

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — trivial check; maintainer
   Reviewed-by; in mainline via Mark Brown
2. Fixes a real bug that affects users? **PASS** — ignored PM error then
   unsafe HW teardown
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   HIGH: possible SPI-NOR corruption / MMIO after clock gate if queue
   stop fails
4. Small and contained? **PASS** — +5/−1, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — hunk matches `v6.18.53`

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Not an exception category** (not a new
ID/quirk/DT/build/docs). It is a normal small bugfix.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to **this 6.18.y tree**. The bug exists here,
the fix is surgical, and failing to stop the SPI queue must not be
reported as a successful suspend.

---

### What the commit solves for stable users

On Broadcom QSPI, suspend used to disable the clock and uninit MSPI even
when the SPI core could not stop the queue, then return success. That
lets suspend continue with the controller still busy. The patch fails
the device suspend instead, which is what every modern SPI driver
already does.

### Stable rules and risk

Meets all six criteria: real PM bug, small, no new API, clean apply on
6.18.53. Risk is far below benefit.

### Concerns

No user reports; trigger is an error path. Sibling series patches are
independent and not required. Residual `__spi_mark_suspended()` on
failure is a pre-existing SPI-core issue, not a reason to skip this
driver fix.

### Verification
- **[Phase 1]** Parsed tags: Reviewed-by Kamal Dasu; Link to msgid; no
  Fixes/Reported-by/Cc: stable
- **[Phase 2]** Diff: +5/−1 in `bcm_qspi_suspend()`; check
  `spi_controller_suspend()` before `clk_disable_unprepare` /
  `bcm_qspi_hw_uninit`
- **[Phase 2]** `spi_stop_queue()` in `drivers/spi/spi.c` returns
  `-EBUSY` after 500 polls
- **[Phase 2]** `host->transfer_one` set in `bcm_qspi_probe`;
  `spi_controller_initialize_queue()` sets `queued = true`
- **[Phase 3]** Blame: ignore-return since `fa236a7ef24048` (2016);
  rename `ec271c04ae93b8` (2023)
- **[Phase 3]** `git merge-base --is-ancestor fa236a7ef24048 v6.18.53` —
  yes
- **[Phase 3]** Series is 3 independent per-driver patches; this one is
  standalone
- **[Phase 4]** `b4 dig -c 44d09ef0ba69` → lore msgid above; v1 only;
  Kamal Reviewed-by; no NAK
- **[Phase 4]** `b4 dig -w`: Mark Brown + linux-spi + Broadcom list
- **[Phase 4]** UNVERIFIED: stable@ lore search (403)
- **[Phase 5]** Callers: `spi-brcmstb-qspi.c`, `spi-iproc-qspi.c` via
  `bcm_qspi_pm_ops`
- **[Phase 6]** `git describe HEAD`: `v6.18.53-5049-g0f0bdc2b0dffb`;
  `make kernelversion`: 6.18.53
- **[Phase 6]** `git show v6.18.53:drivers/spi/spi-bcm-qspi.c` still has
  the buggy sequence; pre-image matches
- **[Phase 6]** `git log v6.18.53 --grep="return error from failed
  controller suspend" -- drivers/spi/` empty
- **[Phase 8]** Failure mode: suspend proceeds after clock-off/HW uninit
  while queue busy → HIGH (corruption/crash risk)

**YES**

 drivers/spi/spi-bcm-qspi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index cfdaa5eaec76d..ae5545be0a45c 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1694,13 +1694,17 @@ EXPORT_SYMBOL_GPL(bcm_qspi_remove);
 static int __maybe_unused bcm_qspi_suspend(struct device *dev)
 {
 	struct bcm_qspi *qspi = dev_get_drvdata(dev);
+	int ret;
 
 	/* store the override strap value */
 	if (!bcm_qspi_bspi_ver_three(qspi))
 		qspi->s3_strap_override_ctrl =
 			bcm_qspi_read(qspi, BSPI, BSPI_STRAP_OVERRIDE_CTRL);
 
-	spi_controller_suspend(qspi->host);
+	ret = spi_controller_suspend(qspi->host);
+	if (ret)
+		return ret;
+
 	clk_disable_unprepare(qspi->clk);
 	bcm_qspi_hw_uninit(qspi);
 
-- 
2.53.0

