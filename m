Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853AB57F1D2;
	Mon, 19 Oct 2026 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418378; cv=none; b=WDiBpzPPniyEcPZReFwKd87emBqkHTOuA0iDalEZEtKT3roOcEita1b35c9E7+78f9FuzWsBLg8YYe43x2cTn+mJFQwWKGv8DmeSR64YhDiKbhxXp1jajOpTMd/pYr/oPFt6aygnw+5f6bRRbITrCoDBb9a2Dwos3261JPG1mTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418378; c=relaxed/simple;
	bh=qnXrjUcJJqClhLn+Ki6L+Mpuo0occNiLhMEUo1RPNt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMSz3/xsP1zIr0scAUdqz4g9+OIwY8d05i8ZLtk72+XrTIV7rFNV55/59NgndHPwbAC2n6NjrjLMBcmxUmMTbg6TJPRGO/yY7oBIrwrhITLwI0/LLq1rvG3y7t+37k3o9ymP+0te2l7t2bLAig4tC1cr7QBdOszaKMtBnIn9A1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TVAI91bk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TVAI91bk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0911F000C9;
	Mon, 19 Oct 2026 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418375;
	bh=+6Bwhcwgc/Udf0kESur2WclREBL1W9s0N9EO1i2I9X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVAI91bkHTk+TU53HruAgjl182kacQonIQX88BbYSQVfV+rgfi2Pz/hbQaYhJN2dV
	 b361DcyZ2B8H2hveZGP7kdi+RzzKktggukiXS2fT8tXEzCrh8Nszh/h6mUh2Nt4Qjd
	 RVyYTrkwcGXo4wlRQP4pJv5f0r0daMryxI0yPUZl0MUQGbZfPs12I6bqX7T+RlaHde
	 MaAvyfeaPDmKuZxtm5JJTbWHHiOnAt4dsmk+Uw6jXsSWhkQDSqwrdON3LdcW2YSc3s
	 AsXhCGu8RUZzDa3kKFf32cafZq/3mydYamSns0gromZ8Q0mKzRjOY4wAuBIyUEWLYv
	 C2x9DGnJ+3GHg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] mmc: moxart: report DMA completion timeout
Date: Mon, 19 Oct 2026 09:48:15 -0400
Message-ID: <20261019135441.1420968-204-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e29e650077e01dddf69bc8fac31e0cd60043aa7c ]

moxart_transfer_dma() waits for the DMA completion but ignores
wait_for_completion_interruptible_timeout(). It then unconditionally
reports the full transfer length in data->bytes_xfered.

Terminate the DMA channel and set data->error when the wait is
interrupted or times out. Only report host->data_len as transferred
after the completion is observed.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is mainline **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`).
The candidate is `e29e650077e01` (“mmc: moxart: report DMA completion
timeout”). Analysis below is of that commit against this checkout.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[mmc/moxart] [report] [DMA wait timeout was ignored; now
surface it as an I/O error]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Pengpeng Hou \<pengpeng@iscas.ac.cn\> (author)
- Signed-off-by: Ulf Hansson \<ulfh@kernel.org\> (MMC host maintainer;
  applied)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable (absence is expected for this review)
- Notable: maintainer SOB only; no user/syzbot report

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `moxart_transfer_dma()` calls
  `wait_for_completion_interruptible_timeout()` but discards the return
  value, then always sets `data->bytes_xfered = host->data_len`.
- **Symptom:** A timed-out or interrupted DMA transfer is reported as a
  full successful transfer.
- **Fix:** On `timeout <= 0`, `dmaengine_terminate_sync()`, set
  `data->error`, skip `bytes_xfered` update, still unmap.
- **Version info:** none in the message. Driver dates to v3.16
  (`1b66e94e6b999`).
- **Root cause (author):** ignored wait status plus unconditional
  success accounting.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not disguised. Explicit timeout/error-path fix. Also stops DMA
before `dma_unmap_sg()`, which is a memory-safety fix even though the
subject only says “report”.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/mmc/host/moxart-mmc.c` — **+9 / −2** (11-line net in
  one function)
- Function: `moxart_transfer_dma()`
- Scope: **single-file surgical fix**

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record (verified against `e29e650077e01^`):
- **Before:** map SG → optionally submit DMA → wait (return ignored) →
  always `bytes_xfered = host->data_len` → unmap. Timeout, signal, or
  failed `dmaengine_prep_slave_sg()` still looked like a full transfer,
  and unmap ran while DMA could still be active.
- **After:** same wait; if `timeout <= 0`, terminate the channel, set
  `data->error` to `-ERESTARTSYS` or `-ETIMEDOUT`, skip accounting, then
  unmap. Success path unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** logic/correctness (ignored wait) **plus** memory safety
  (unmap while DMA may still run) **plus** false success to the MMC
  block layer.
- **Mechanism:** `wait_for_completion_interruptible_timeout()` returns 0
  on timeout, `-ERESTARTSYS` if interrupted, remaining jiffies on
  success (`kernel/sched/completion.c`). `timeout ?: -ETIMEDOUT` maps
  those correctly.
- MMC block completion uses `bytes_xfered` as success size
  (`mmc_blk_mq_complete_rq()`). A full `bytes_xfered` with no error
  completes the request as OK — silent data corruption on write,
  stale/wrong data on read.
- `sh_mmcif.c` already uses the same terminate + `data->error` pattern.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct and minimal. Matches documented wait return values
  and existing MMC DMA drivers.
- `moxart_transfer_dma()` is called with the host spinlock dropped
  (`moxart_request()`), so `dmaengine_terminate_sync()` is in process
  context as required.
- Residual issues (pre-existing, not introduced): still waits even if
  `desc` is NULL; PIO wait at line 436 still ignores its return. After
  DMA error, `moxart_request()` still waits for `MASK_DATA`. Harmless
  extra delay; `data->error` is already set.
- Regression risk: **low**.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Function and ignored wait: `1b66e94e6b999` (“mmc: moxart: Add MOXA ART
  SD/MMC driver”), **v3.16-rc1**.
- Unconditional `bytes_xfered = host->data_len` after wait:
  `54fd8cd617996` (2024, “Fix accounting in DMA transfer”) — moved the
  assignment after the wait but still did not check the wait result.
- Bug class (ignored wait + unmap-while-active) has been in the driver
  since introduction.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Introduced-by is
`1b66e94e6b999`; `git merge-base --is-ancestor 1b66e94e6b999 HEAD`
succeeds.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent: platform helpers, `devm_mmc_alloc_host`, sg_miter revert, DMA
  accounting, `moxart_use_dma()`.
- Not part of a numbered series. Standalone.
- Prerequisite for a clean textual apply of this exact hunk:
  `54fd8cd617996` (already in this tree). The timeout check itself does
  not depend on that accounting change.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Pengpeng Hou is not the MMC maintainer; many nearby commits are small
  correctness/ID-table patches.
- Ulf Hansson applied it (“Applied for next, thanks!”).
- Only this moxart change from the author in `drivers/mmc/host/`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Uses `dmaengine_terminate_sync()` from `include/linux/dmaengine.h`
  (added `b36f09c3c441a`, 2015). Present here; used by other MMC hosts.
- Standalone. No new helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c e29e650077e01` →
  https://patch.msgid.link/20260623061117.35280-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only**, applied as submitted.
- Thread (saved via `b4 dig -m`): Ulf Hansson, 2026-07-06: “Applied for
  next, thanks!” No NAK, no requested changes, no Cc: stable from
  reviewers.
- lore WebFetch returned HTTP 403; discussion recovered from the mbox.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc Pengpeng Hou, Ulf Hansson, Binbin Zhou,
Huacai Chen, linux-mmc, linux-kernel. Maintainer was the recipient and
applied it. Zhou/Chen look like list/CC noise (Loongson MMC), not
reviewers of this driver.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, no bugzilla/syzbot link. Code-inspection fix,
not a user report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. Same author also has `mmc: sdhci-of-ma35d1: add
missing MODULE_DEVICE_TABLE()` — unrelated.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable WebFetch returned 403. `git log
--grep='DMA completion timeout' -- drivers/mmc/host/` only this commit.
**UNVERIFIED:** no confirmation of a prior stable-list NAK.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `moxart_transfer_dma()` only. Uses `moxart_dma_complete()` as
DMA callback (`complete(&host->dma_complete)`).

**Step 5.2: TRACE CALLERS**
Record:
- Sole caller: `moxart_request()` (`mmc_host_ops.request`).
- Path: MMC core request → host `.request` → DMA if `data_len >
  fifo_width && have_dma`.
- Process context, lock dropped. Userspace block I/O to the SD card
  reaches this.

**Step 5.3: TRACE CALLEES**
Record: `dma_map_sg` / `dmaengine_prep_slave_sg` / `dmaengine_submit` /
`dma_async_issue_pending` / wait / (new) `dmaengine_terminate_sync` /
`dma_unmap_sg`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from normal MMC/SD reads and writes on MOXA ART
(UC-7112-LX and related). Timeout is 1000 ms (`host->timeout =
msecs_to_jiffies(1000)`). Unprivileged I/O on that hardware can hit it.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record:
- PIO path in the same file already sets `data->error = -ETIMEDOUT` on
  FIFO wait failure — DMA was inconsistent.
- `moxart_request()` still ignores the PIO completion wait return (line
  436). Same class of bug, not this patch.
- `sh_mmcif.c` checks timeout/interrupt, zeros `bytes_xfered` on error,
  calls `dmaengine_terminate_sync()`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. File and function have been here since v3.16. Pre-image
confirmed at `e29e650077e01^`. `git merge-base --is-ancestor
e29e650077e01 HEAD` succeeds (fix already on this mainline snapshot).
Introduced ~v3.16.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Hunk is local to `moxart_transfer_dma()`. APIs used exist here.
**Clean apply** on this tree (already applied). No conflicting later
logic change except an unrelated platform-helper commit.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: `54fd8cd617996` only moved accounting after the wait; it did not
check the wait. No other timeout fix for this DMA path.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record:
- Subsystem: MMC host (`drivers/mmc/host/moxart-mmc.c`),
  `CONFIG_MMC_MOXART`, `depends on ARCH_MOXART || COMPILE_TEST`.
- Hardware: MOXA ART (Faraday FA526 ARMv4), UC-7101 / UC-7112-LX /
  UC-7110 / IA240 / IA241 / IA3341.
- Criticality: **PERIPHERAL** (legacy industrial SoC), but the bug is in
  the host’s main DMA I/O path.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Driver is mature (2014) with occasional fixes. Not an active
rewrite. Long-standing bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / platform-specific** — MOXA ART boards with
this MMC host and DMA enabled. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: DMA completion misses the 1s wait, or the waiter is
  interrupted.
- Also: `dma_map_sg`/prep failure (completion never signaled) previously
  still reported a full transfer.
- Commonness: timeout is not every I/O; when it happens the old code
  treated it as success.
- Unprivileged userspace I/O on that hardware can reach it.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- False `bytes_xfered` + no `data->error` → block layer completes I/O as
  OK (`mmc_blk_mq_complete_rq` uses `bytes_xfered`). **Data
  corruption.**
- `dma_unmap_sg()` while the engine may still be running → DMA to
  unmapped memory, crash or memory corruption.
- Later `moxart_wait_for_status(MASK_DATA)` can still timeout and set
  `data->error`, but unmap already happened inside
  `moxart_transfer_dma()`, and if the controller finished while the DMA
  engine did not, MASK_DATA can succeed and the false-success path
  remains.
- Severity: **HIGH** (corruption / use of unmapped DMA buffers). Not a
  panic on every timeout, but the failure mode is serious.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** HIGH for MOXA ART users (correct I/O error, DMA stopped
  before unmap). LOW globally (few platforms).
- **Risk:** VERY LOW (9 lines, error path, maintainer-applied, same
  pattern as other hosts).
- **Ratio:** benefit outweighs risk for a stable backport of this driver
  fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real bug: ignored wait, fake full transfer, unmap while DMA may still
  run.
- Failure mode is data corruption and DMA-to-unmapped-memory, not
  cosmetics.
- Small (+9/−2), obviously correct, process-context terminate.
- PIO path already reports timeout; DMA did not.
- Bug present since v3.16; DMA I/O path of an in-tree driver.
- MMC maintainer applied v1 with no objections.
- `dmaengine_terminate_sync` and the surrounding function exist in this
  tree.

AGAINST:
- Niche ARMv4 industrial SoC; no Reported-by / syzbot.
- Author looks like an audit-style contributor; not a hardware user
  report.
- PIO completion wait still ignores its return (incomplete sibling).
- No Fixes:/Cc: stable (not a negative per the review rules).

UNRESOLVED:
- Stable-list discussion could not be fetched (HTTP 403).
- No public confirmation of how often DMA actually times out on
  UC-7112-LX hardware.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — return-value handling
   matches the API; maintainer applied it; same pattern as `sh_mmcif`.
2. Fixes a real bug that affects users? **PASS** — false success and
   unmap-while-active on this host’s DMA path.
3. Important issue? **PASS** — data corruption and DMA memory safety;
   HIGH, not a panic-on-boot.
4. Small and contained? **PASS** — one function, 9 insertions.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — pre-image and APIs are here;
   commit is already an ancestor of HEAD.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk, DT, build, or doc fix). Qualifies
as a normal bugfix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the buggy DMA path. The patch is a small, maintainer-acked
correction of ignored DMA completion that otherwise reports a full
transfer and unmaps buffers while the engine may still run. That is
stable-worthy even on a niche host: the risk is negligible and the
failure mode is corruption.

Verification:
- [Phase 1] Parsed tags: author + Ulf Hansson SOB only; no
  Fixes/Reported-by/Cc: stable
- [Phase 1] Body: ignored wait + unconditional `bytes_xfered`
- [Phase 2] Diff: +9/−2 in `moxart_transfer_dma()`; timeout<=0 →
  terminate_sync, set error, skip accounting
- [Phase 2] Pre-image at `e29e650077e01^` confirmed ignored wait then
  `bytes_xfered = host->data_len`
- [Phase 2] `wait_for_completion_interruptible_timeout` returns
  -ERESTARTSYS / 0 / remaining jiffies (`kernel/sched/completion.c`)
- [Phase 2] `mmc_blk_mq_complete_rq()` completes OK when `bytes_xfered
  != 0`
- [Phase 3] Blame: wait from `1b66e94e6b999` (v3.16); accounting move
  `54fd8cd617996` still ignored wait
- [Phase 3] `git merge-base --is-ancestor 1b66e94e6b999 HEAD` and
  `e29e650077e01 HEAD` both true
- [Phase 3] `dmaengine_terminate_sync` added in `b36f09c3c441a` (2015);
  present in this tree
- [Phase 4] `b4 dig`: lore
  https://patch.msgid.link/20260623061117.35280-1-pengpeng@iscas.ac.cn ;
  v1 only
- [Phase 4] mbox: Ulf “Applied for next, thanks!”; no NAK; no Cc: stable
- [Phase 4] WebFetch lore/stable: HTTP 403 (UNVERIFIED stable-list
  history)
- [Phase 5] Only caller `moxart_request()`; lock dropped; 1s timeout
- [Phase 5] Sibling `sh_mmcif` uses the same terminate/error pattern
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] Buggy DMA wait present before the commit; patch already on
  HEAD
- [Phase 7] `CONFIG_MMC_MOXART` / ARCH_MOXART (UC-7112-LX family)
- [Phase 8] Failure mode: false MMC success + DMA unmap while active;
  HIGH
- UNVERIFIED: frequency of DMA timeouts on real MOXA hardware; stable
  mailing-list discussion

The patch is small, correct, and fixes a real DMA-timeout path that can
complete I/O as success and unmap live buffers. That meets stable
criteria for this tree.

**YES**

 drivers/mmc/host/moxart-mmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 3dd8f232052f6..4a4d8b19b18cc 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -264,6 +264,7 @@ static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 	u32 len, dir_slave;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *dma_chan;
+	long timeout;
 
 	if (host->data_len == data->bytes_xfered)
 		return;
@@ -296,11 +297,17 @@ static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 		dma_async_issue_pending(dma_chan);
 	}
 
-	wait_for_completion_interruptible_timeout(&host->dma_complete,
-						  host->timeout);
+	timeout = wait_for_completion_interruptible_timeout(&host->dma_complete,
+							    host->timeout);
+	if (timeout <= 0) {
+		dmaengine_terminate_sync(dma_chan);
+		data->error = timeout ?: -ETIMEDOUT;
+		goto unmap;
+	}
 
 	data->bytes_xfered = host->data_len;
 
+unmap:
 	dma_unmap_sg(dma_chan->device->dev,
 		     data->sg, data->sg_len,
 		     mmc_get_dma_dir(data));
-- 
2.53.0

