Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3498481A9C;
	Mon, 20 Apr 2026 13:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691904; cv=none; b=n0ezSYTLeG3Dv/ciNpKQWO+6OEPO0uh8shORRzm7zy9AbJsoa65MXwamvEK8d3jGUFo098TBIKe6IbkugK97t2oDditv2cZXt2nEeHN1ujO7vIET2ZUUNePF2dgtkFYw6J7UY0TCUsHz/tcflccqaHuJEOnNcuhh+ObJGoApAak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691904; c=relaxed/simple;
	bh=qp/1FPnW/xz76pRAwuxarVuaWIR6D3YOYIRucDmPU8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CYFTwaWJ5FpnhqZSbcTjIhvAOBUTtP2jV+UZQfysfMUDtqC7tVaA89SZgskEUbxwOAnWlaL6eySOkiqez1/A73s5H9bU9r/avrRqf9moQojivu584lcVXWGsYueDIT4L79Iw8t87LmPy/dwwgBeBayBYDJg+3anIFSE2WbsNT14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3HTAiQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3HTAiQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B99C2BCB7;
	Mon, 20 Apr 2026 13:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691904;
	bh=qp/1FPnW/xz76pRAwuxarVuaWIR6D3YOYIRucDmPU8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X3HTAiQgIw2rsvpprbi1OiSpor6RVJmQn4EcBw6hfd24SEClCYaACOwbToP58z540
	 J3Ci/gbMAWFUUbL56aZNZ5lz2pMzoBomqMPeT3Y2Ja1jll3hZhxCl8dBJsT9c7P0Vg
	 4eLMRZif/s+21wFPfefzbbi8Zm8lt1QS5o8EfkA+jvEjtze7RRoxVko7NeUSlgR3Ng
	 QPN/w1O2MwRDlySeJ5uUT6446rqT7zHI5zkrtrVGxzAlTXIWi4g/SwU4KTKWQDLj2B
	 aA7nt2XJbECsWZcU6VCLg5I+sTtLff3lBFCUlpdFDwb0KdLywRo9BtUHDg/oJPBTXQ
	 JZlSZNQ14KT5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alain Volmat <alain.volmat@foss.st.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-spi@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] spi: stm32: fix rx DMA request error handling
Date: Mon, 20 Apr 2026 09:20:55 -0400
Message-ID: <20260420132314.1023554-261-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 837f6691d5f39ea6453e4489dded40fb17755c60 ]

Avoid trying to release the RX DMA channel when an error occurs
during RX dma_request_chan() call. Instead, jump directly to
release the TX channel, if applicable.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-spi/aYXvY6NH7OlZ-OAF@stanley.mountain/T/#u
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://patch.msgid.link/20260212-spi-stm32-fix-dma-rx-release-v1-1-53a37c31626b@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed to complete the analysis. Let me
compile the full assessment.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `spi: stm32`
- **Action verb:** "fix"
- **Summary:** Fix incorrect error handling when RX DMA channel request
  fails during probe.
- Record: [spi: stm32] [fix] [rx DMA request error handling in probe
  path]

### Step 1.2: Tags
- **Reported-by:** Dan Carpenter `<dan.carpenter@linaro.org>` — well-
  known static analysis expert (Smatch maintainer)
- **Closes:** `https://lore.kernel.org/linux-spi/aYXvY6NH7OlZ-
  OAF@stanley.mountain/T/#u` — Dan's bug report
- **Signed-off-by:** Alain Volmat (author, STM32 SPI subsystem
  maintainer)
- **Link:** patch.msgid.link URL for the fix patch
- **Signed-off-by:** Mark Brown (SPI subsystem maintainer)
- Record: Reported by Dan Carpenter (Smatch static analysis). Author is
  the STM32 SPI maintainer. Merged by SPI subsystem maintainer Mark
  Brown.

### Step 1.3: Commit Body
The commit message states: avoid trying to release the RX DMA channel
when an error occurs during `dma_request_chan()` for RX. Instead, jump
directly to release the TX channel. This is clearly describing a bug
where on RX DMA request failure, the cleanup code incorrectly tries to
release a never-acquired RX DMA channel.

Record: Bug is calling `dma_release_channel()` on an ERR_PTR pointer
when RX DMA request fails. Symptom: crash/undefined behavior during
driver probe failure path.

### Step 1.4: Hidden Bug Fix Detection
Not hidden — clearly labeled as "fix" in subject line.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed:** `drivers/spi/spi-stm32.c` only
- **Lines changed:** ~6 added, ~6 removed (label and goto target
  changes)
- **Functions modified:** `stm32_spi_probe()` — the probe error-handling
  section
- **Scope:** Single-file, surgical fix in error path cleanup labels

### Step 2.2: Code Flow Change

**Before the fix:** When `dma_request_chan(spi->dev, "rx")` fails with
an error other than `-ENODEV`, the code does `goto err_dma_release`. At
that label, `spi->dma_rx` still holds an `ERR_PTR` value (non-NULL), so
`if (spi->dma_rx)` evaluates to true and
`dma_release_channel(spi->dma_rx)` is called with an invalid pointer.

**After the fix:** The goto target is changed to `err_dma_tx_release`
(new label), which skips the RX DMA release and only releases the TX
channel. The cleanup labels are split: RX release first (only reached
when RX was successfully acquired), then `err_dma_tx_release` for TX-
only cleanup.

### Step 2.3: Bug Mechanism
**Category:** Error path / resource handling bug leading to invalid
pointer dereference.

The root cause: commit `c266d19b7d4e5` ("spi: stm32: properly fail on
dma_request_chan error") moved the `spi->dma_rx = NULL` assignment
inside the `-ENODEV` branch but kept the `goto err_dma_release` in the
else branch. Before that commit, `spi->dma_rx` was always set to NULL
before any goto, making the cleanup safe.

### Step 2.4: Fix Quality
- Obviously correct: the fix ensures we skip releasing a channel that
  was never acquired.
- Minimal/surgical: only changes a goto label and reorganizes 6 lines of
  cleanup.
- Regression risk: extremely low — only affects error paths, and the
  reordering correctly reverses the acquisition order (TX before RX, so
  cleanup is RX then TX).

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy `goto err_dma_release` at line 2508 is attributed to the
original Peter Ujfalusi commit `0a454258febb73` (2019), but the actual
bug was introduced by `c266d19b7d4e5` (Alain Volmat, 2025-12-18) which
restructured the error handling and removed the safety `spi->dma_rx =
NULL` before the goto.

Record: Bug introduced by c266d19b7d4e5 merged in v7.0-rc1 (v7.0 merge
window, after v6.14).

### Step 3.2: Fixes Tag
No explicit Fixes: tag in the fix commit, but from analysis, the bug was
introduced by c266d19b7d4e5. This commit exists only in v7.0-rc1+
(confirmed via `git tag --contains`).

### Step 3.3: File History
Dan Carpenter previously reported another probe error path bug in the
same file (`f4d8438e6a402` — sram pool free). This pattern of error path
bugs in probe is consistent.

### Step 3.4: Author
Alain Volmat is the STM32 SPI subsystem maintainer — 15+ commits to this
file. He both introduced the bug (c266d19b7d4e5) and wrote the fix. High
confidence in fix quality.

### Step 3.5: Dependencies
The fix depends on commit c266d19b7d4e5 being present. Since that commit
is the one that introduced the bug, the fix is only relevant to trees
containing c266d19b7d4e5, which is v7.0-rc1+.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Patch Discussion
The fix patch message ID `20260212-spi-stm32-fix-dma-rx-
release-v1-1-53a37c31626b@foss.st.com` indicates a v1 patch (single
revision). It was merged by Mark Brown (SPI maintainer). The "Closes:"
link references Dan Carpenter's original report.

### Step 4.2: Reviewers
Merged by Mark Brown (SPI subsystem maintainer). Author is Alain Volmat
(STM32 SPI maintainer). Dan Carpenter (reporter) is the Smatch static
analysis maintainer.

### Step 4.3: Bug Report
The report from Dan Carpenter at Linaro is a static analysis finding
(Smatch/Smatch-based). Dan is extremely reputable — his static analysis
findings are almost always real bugs.

### Step 4.5: Stable Discussion
No explicit stable nomination found, which is expected for the commits
under review.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
Only `stm32_spi_probe()` — the driver probe function, specifically its
cleanup/error path labels.

### Step 5.2: Callers
`stm32_spi_probe` is called by the platform driver framework during
device enumeration. It is the `.probe` callback for the
`stm32_spi_driver`. This is a standard driver entry point called when
device-tree matching finds an STM32 SPI controller.

### Step 5.4: Reachability
The bug is reachable during normal device probe when the RX DMA channel
request fails for reasons other than `-ENODEV` (e.g., `-EBUSY`,
`-ENOMEM`, `-EPROBE_DEFER` deferred probe). This is a realistic scenario
on STM32 embedded platforms.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable Trees
The buggy commit `c266d19b7d4e5` was merged in v7.0-rc1. It is NOT in
v6.14 or any earlier release. Therefore, this fix is only relevant to
the **7.0.y stable tree**.

### Step 6.2: Backport Complications
The fix should apply cleanly to 7.0.y since the buggy code c266d19b7d4e5
exists there unchanged.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
- **Path:** `drivers/spi/spi-stm32.c`
- **Subsystem:** SPI driver for STM32 (ARM embedded platform)
- **Criticality:** PERIPHERAL — affects STM32 embedded/IoT users
  specifically, but STM32 is a very widely used embedded platform.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
STM32 SPI users on v7.0.y where the RX DMA channel request fails during
probe.

### Step 8.2: Trigger Conditions
Triggered when `dma_request_chan()` for the RX channel returns an error
other than `-ENODEV` during `stm32_spi_probe()`. This can happen with
DMA controller misconfiguration, resource contention, or deferred probe
scenarios.

### Step 8.3: Failure Mode
Calling `dma_release_channel()` with an ERR_PTR value causes a **kernel
crash** (invalid pointer dereference inside `dma_release_channel()`).
Severity: **HIGH** (kernel crash during probe).

### Step 8.4: Risk-Benefit Ratio
- **BENEFIT:** Prevents kernel crash on probe failure path — HIGH
- **RISK:** Very low — 6 lines changed, only in error cleanup labels,
  obviously correct
- **Ratio:** Strongly favorable for backporting

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence
**FOR backporting:**
- Fixes a real crash: `dma_release_channel()` called with ERR_PTR value
- Found by Dan Carpenter (highly reputable static analysis expert)
- Author is the STM32 SPI maintainer; merged by SPI subsystem maintainer
- Tiny, surgical fix (6 lines, single file, only error path labels)
- Obviously correct — only skips releasing a never-acquired channel
- Bug is in v7.0.y stable tree (introduced by c266d19b7d4e5)

**AGAINST backporting:**
- Only affects STM32 platforms (not universal)
- Only affects v7.0.y (bug was introduced in v7.0 merge window)
- Only triggers on probe failure path (not normal operation)

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — trivially verifiable goto
   label change
2. Fixes a real bug? **YES** — crash from invalid pointer in cleanup
   path
3. Important issue? **YES** — kernel crash on probe failure
4. Small and contained? **YES** — 6 lines in one file
5. No new features/APIs? **YES** — pure bugfix
6. Can apply to stable? **YES** — should apply cleanly to 7.0.y

### Step 9.3: Exception Categories
Not applicable — this is a straightforward bugfix.

### Step 9.4: Decision
This is a clear, small, correct bugfix for a crash in a driver probe
error path. It meets all stable kernel criteria.

## Verification

- [Phase 1] Parsed tags: Reported-by Dan Carpenter (Smatch/Linaro),
  Closes link to lore report, Signed-off-by Mark Brown (SPI maintainer)
- [Phase 2] Diff analysis: ~6 lines changed in `stm32_spi_probe()`
  cleanup labels — goto target changed from `err_dma_release` to
  `err_dma_tx_release`, cleanup split into separate RX/TX labels
- [Phase 2] Verified bug mechanism: `spi->dma_rx` holds ERR_PTR when
  goto fires; `if (spi->dma_rx)` is true for ERR_PTR;
  `dma_release_channel(ERR_PTR)` causes crash
- [Phase 3] git blame: buggy `goto err_dma_release` at line 2508 traces
  back through c266d19b7d4e5 (2025-12-18)
- [Phase 3] git show c266d19b7d4e5: confirmed this commit removed the
  safety `spi->dma_rx = NULL` before the goto, introducing the bug
- [Phase 3] `git tag --contains c266d19b7d4e5`: first in v7.0-rc1, not
  in v6.14 or earlier
- [Phase 3] Author Alain Volmat has 15+ commits to spi-stm32.c, is the
  STM32 SPI maintainer
- [Phase 3] b4 dig -a c266d19b7d4e5: part of "spi: stm32: stability &
  performance enhancements" series (v2)
- [Phase 5] `stm32_spi_probe` is the platform driver .probe callback
  (line 2689), called during device enumeration
- [Phase 6] Buggy code only exists in v7.0-rc1+ (confirmed via git log
  v6.14..v7.0-rc1)
- [Phase 6] Fix should apply cleanly — file unchanged between fix commit
  and current 7.0 tree (bug still present in current tree at line 2508)
- [Phase 8] Failure mode: kernel crash from dma_release_channel() on
  ERR_PTR — severity HIGH

**YES**

 drivers/spi/spi-stm32.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 33f211e159ef1..6d5eefa41f717 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -2505,7 +2505,7 @@ static int stm32_spi_probe(struct platform_device *pdev)
 			spi->dma_rx = NULL;
 		} else {
 			dev_err_probe(&pdev->dev, ret, "failed to request rx dma channel\n");
-			goto err_dma_release;
+			goto err_dma_tx_release;
 		}
 	} else {
 		ctrl->dma_rx = spi->dma_rx;
@@ -2574,11 +2574,11 @@ static int stm32_spi_probe(struct platform_device *pdev)
 	if (spi->sram_pool)
 		gen_pool_free(spi->sram_pool, (unsigned long)spi->sram_rx_buf,
 			      spi->sram_rx_buf_size);
-err_dma_release:
-	if (spi->dma_tx)
-		dma_release_channel(spi->dma_tx);
 	if (spi->dma_rx)
 		dma_release_channel(spi->dma_rx);
+err_dma_tx_release:
+	if (spi->dma_tx)
+		dma_release_channel(spi->dma_tx);
 err_clk_disable:
 	clk_disable_unprepare(spi->clk);
 
-- 
2.53.0

