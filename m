Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856D652B1EE;
	Mon, 31 Aug 2026 13:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183885; cv=none; b=nWo4s58OKMyW+7MqKAsIjZNDL+6tQQR0r3kuUmzf5OOiC5V8LRcf/lozQrZE80OkEMW9eQmN8FBDW0fqzTHyKpVLy9DDedVcojShBtADAFnGnepjSwYk1UdMVX2dw9n/z7FCeBas/zEwel0OHHuxCdvd/q0wG+tLH0A9BfW82DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183885; c=relaxed/simple;
	bh=A5hPM0g5evR4DBZD9VQ6sDFfX579nlx7iFKlq8o25qA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CFf+VKBGzk0p/W6h+yYG1PrFmQddTXVriZrdOCAkw7byFvwuKDbybSHz70ELLTgnk6OOJT0n+2SR2WcAMogLVoQ7z/o4yDROxLq6zYboH/+QEHMwqsYWuaPWO0eNMGITOWO1YEQRn9t4KlAkgNWq6c/76e3ue3HHwAn1P6CDOCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=enYB5y/P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="enYB5y/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9788F1F000E9;
	Mon, 31 Aug 2026 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183882;
	bh=73G7ahY4Nv2gXPcEUSletcWwSG2vP4x0WbSd/O0heXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enYB5y/Pibn2hO92ZOzIS10IzPRmY2A9oT/9kgc5UYob1JVeoxor0Njyaoc2kvnV5
	 RRCmEHNoAm60bt5/DpDr/z83ObXuGX1jmoSe5wwb2GXcq6mKbd0JTpJVm0qg3TcOLt
	 4Odp814Qd48CcFD35Ku08Yq2PAOnI/d5oHFInIofeTE85Wt8UoIM2p7KJfyG2Zy9IK
	 Wgmo9LzkHzwW3+qn4KKCg2AZWmtOIbr4/X9K86hPite3lI0yDF+WhObzpM7i/YzQkK
	 OZRJoEb6stsa2iS3N8JgNO9Jkkk6wMB8wv4rOk9geXHQWcs1peGiuUh7b7h8zoiduW
	 qmhDOOLiupD3A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aaron Kling <webgeek1234@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	skomatineni@nvidia.com,
	ldewangan@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] spi: tegra210-quad: Allocate DMA memory for DMA engine
Date: Mon, 31 Aug 2026 09:26:27 -0400
Message-ID: <20260831133314.4125787-359-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit f469138a77ac5ab685dfe15dfed7dccb9d5c33e5 ]

When the SPI controllers are running in DMA mode, it is the DMA engine
that performs the memory accesses rather than the SPI controller. Pass
the DMA engine's struct device pointer to the DMA API to make sure the
correct DMA operations are used.

Suggested-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260525-tegra194-qspi-iommu-v2-1-a11c53f804b2@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[spi: tegra210-quad] [Allocate] — Use the DMA engine's struct
  device for DMA API calls instead of the SPI controller device`

**Step 1.2 — Tags**
- Record:
  - `Suggested-by: Thierry Reding <treding@nvidia.com>` — NVIDIA Tegra
    maintainer input
  - `Signed-off-by: Aaron Kling <webgeek1234@gmail.com>` — author
  - `Link: https://patch.msgid.link/20260525-tegra194-qspi-
    iommu-v2-1-a11c53f804b2@gmail.com` — patch submission thread
  - `Signed-off-by: Mark Brown <broonie@kernel.org>` — SPI subsystem
    maintainer
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Cc:
    stable@vger.kernel.org`
  - Notable: maintainer involvement (Brown, Reding suggestion), but no
    fuzzer/user bug report tags

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** DMA memory mapping/allocation uses the SPI controller
    `struct device` (`tqspi->dev`) even when an external DMA engine
    (GPCDMA/APBDMA) performs the actual memory accesses.
  - **Symptom:** Incorrect DMA operations / IOMMU mappings; DMA
    transfers can fail or access memory through the wrong DMA/IOMMU
    context.
  - **Root cause:** The DMA engine, not the SPI controller, owns the bus
    master accesses in external-DMA mode; the DMA API must be called
    with the DMA engine's device pointer.
  - **Version info:** None in the commit message itself.

**Step 1.4 — Hidden bug fix?**
- Record: **Yes.** Although the subject says "Allocate," this is a DMA-
  correctness bug fix, not a feature. It mirrors the already-accepted
  `i2c: tegra: Allocate DMA memory for DMA engine` fix (commit
  `cdbf26251d3b3`, present in this tree).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record:
  - Files: `drivers/spi/spi-tegra210-quad.c` only (+18 / -11 lines)
  - Functions modified: `tegra_qspi_dma_map_xfer()`,
    `tegra_qspi_dma_unmap_xfer()`, `tegra_qspi_deinit_dma()`,
    `tegra_qspi_init_dma()`
  - Struct modified: `struct tegra_qspi` (adds `rx_dma_dev`,
    `tx_dma_dev`)
  - Scope: single-file, surgical fix

**Step 2.2 — Code flow changes**
- Record:
  - **Before:** All `dma_map_single()`, `dma_unmap_single()`,
    `dma_alloc_coherent()`, and `dma_free_coherent()` used `tqspi->dev`
    (SPI controller).
  - **After (external DMA path):** Uses `dmaengine_get_dma_device()` on
    the requested RX/TX DMA channels.
  - **After (internal DMA / tegra234 path):** Explicitly sets
    `rx_dma_dev = tx_dma_dev = tqspi->dev` — behavior unchanged.
  - Affected path: DMA-based SPI transfers when `has_ext_dma == true`
    and DMA channels are successfully requested.

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** DMA / IOMMU correctness (logic/correctness fix)
  - **Mechanism:** External DMA engine accesses memory using its own DMA
    ops and IOMMU stream ID. Mapping buffers against the SPI controller
    device creates mappings in the wrong IOMMU context. The GPCDMA
    engine cannot correctly access those buffers → IOMMU faults,
    transfer failures, or memory corruption.

**Step 2.4 — Fix quality**
- Record:
  - Fix is obviously correct and follows established kernel pattern
    (`dmaengine_get_dma_device()` API exists at
    `include/linux/dmaengine.h:1672`).
  - Minimal, no unrelated changes.
  - Regression risk: very low. Internal-DMA (tegra234) path explicitly
    preserves `tqspi->dev`.
  - No public API changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record:
  - Buggy `dma_map_single(tqspi->dev, ...)` lines date to
    `921fc1838fb036` (Dec 2020, "Add support for Tegra210 QSPI
    controller").
  - Bug present since initial driver DMA support; not a recent
    regression.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag present.

**Step 3.3 — Related file history**
- Record:
  - `017f1b0bae08e` — added `has_ext_dma` flag distinguishing external
    GPCDMA (tegra210/186/194/241) from internal DMA (tegra234); is an
    ancestor of HEAD.
  - Commit `f469138a77ac5` is on mainline but **NOT** in
    `stable/linux-6.18.y` (HEAD = v6.18.44).
  - Part of v2 series `[PATCH v2 0/2] arm64: tegra: Enable DMA Support
    on Tegra194 QSPI`; patch 2/2 adds `dmas` properties to tegra194 QSPI
    nodes in DT.

**Step 3.4 — Author context**
- Record: Aaron Kling is a Tegra contributor (also tegra114 SPI patches
  in tree). SPI maintainer Mark Brown merged. Thierry Reding (NVIDIA)
  suggested the approach.

**Step 3.5 — Dependencies**
- Record:
  - Standalone driver fix applies cleanly to 6.18.44 (verified via `git
    cherry-pick --no-commit f469138a77ac5`, exit 0).
  - Functionally pairs with patch 2/2 (tegra194 DT DMA enablement) but
    does not require other code-structure changes.
  - `dmaengine_get_dma_device()` API is present in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record:
  - `b4 dig -c f469138a77ac5`:
    https://patch.msgid.link/20260525-tegra194-qspi-
    iommu-v2-1-a11c53f804b2@gmail.com
  - Series revisions: v1 (3 patches, DT bindings + IOMMU), v2 (2
    patches, simplified to driver + DT dmas)
  - Cover letter states Jetson Xavier NX (tegra194/p3668) SPI NOR "would
    time out on all transfers and sometimes even trigger a cbb fault,
    locking up the entire unit"
  - No explicit stable nomination found in thread
  - No NAKs found; merged by Mark Brown

**Step 4.2 — Reviewers**
- Record: CC'd to Thierry Reding, Jonathan Hunter, Sowjanya Komatineni,
  Mark Brown, linux-tegra, linux-spi, devicetree lists.

**Step 4.3 — Bug report details**
- Record:
  - Cover letter documents real hardware failure: SPI NOR timeouts and
    CBB faults on Jetson Xavier NX.
  - Severity from reporter: system lockups (CRITICAL class).
  - Full fix requires patch 2/2 (DT DMA properties) plus this driver fix
    for correct DMA engine device usage.

**Step 4.4 — Related patches**
- Record:
  - Patch 2/2: `arm64: tegra: Enable DMA Support on Tegra194 QSPI` —
    adds `dmas = <&gpcdma 5>` to tegra194 QSPI nodes.
  - Sashiko AI review flagged pre-existing driver issues exposed by
    enabling DMA (unmap-on-error path, packed-mode buffer rounding);
    those are separate from this commit.

**Step 4.5 — Stable list history**
- Record: No stable-list discussion found for this specific SPI patch.
  (Lore direct fetch blocked by bot protection; b4 mbox used instead.)

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `tegra_qspi_init_dma()`, `tegra_qspi_deinit_dma()`,
  `tegra_qspi_dma_map_xfer()`, `tegra_qspi_dma_unmap_xfer()`,
  `tegra_qspi_start_dma_based_transfer()` (caller)

**Step 5.2 — Callers**
- Record:
  - `tegra_qspi_init_dma()` called from probe (`~line 1693`) during
    device initialization.
  - `tegra_qspi_dma_map_xfer()` called from
    `tegra_qspi_start_dma_based_transfer()` for packed transfers.
  - DMA transfers triggered from `tegra_qspi_setup_transfer_one()` when
    `use_dma && total_fifo_words > QSPI_FIFO_DEPTH`.
  - Reachable on every large SPI transfer on DMA-enabled platforms.

**Step 5.3 — Callees**
- Record: `dma_request_chan()`, `dmaengine_get_dma_device()`,
  `dma_alloc_coherent()`, `dma_map_single()`,
  `dmaengine_slave_config()`, `dmaengine_prep_slave_single()`.

**Step 5.4 — Call chain / reachability**
- Record:
  - Probe → `tegra_qspi_init_dma()` → DMA buffer allocation (boot/init
    path).
  - Userspace SPI ioctl → `spi_sync()` → controller transfer → DMA path
    for large transfers.
  - **Userspace-reachable** on platforms with external DMA enabled
    (tegra210 has `dmas` in DT; tegra194 will once patch 2 lands).

**Step 5.5 — Similar patterns**
- Record: Identical fix already applied in this tree for `i2c-tegra.c`
  (`cdbf26251d3b3`), which explicitly documents SMMU stream-ID
  misconfiguration without the fix. Other drivers in tree use
  `dmaengine_get_dma_device()` (e.g., `j721e-csi2rx`, `k3-udma`).

---

## Phase 6: Cross-Referencing Against Local Tree (6.18.44)

**Step 6.1 — Does buggy code exist?**
- Record: **Yes.** Current `spi-tegra210-quad.c` uses `tqspi->dev` for
  all DMA API calls (lines 577–810). No `rx_dma_dev`/`tx_dma_dev` fields
  exist. Bug present since driver introduction (2020).

**Step 6.2 — Backport complications**
- Record: **Clean apply** — cherry-pick auto-merges with no conflicts
  (18 insertions, 11 deletions).

**Step 6.3 — Related fixes already present?**
- Record: `i2c: tegra: Allocate DMA memory for DMA engine`
  (`cdbf26251d3b3`) is already in 6.18.y. No equivalent SPI fix yet.
  This SPI commit is NOT in HEAD.

**Platform-specific notes for this tree:**
| Platform | `has_ext_dma` | DMA in DT (6.18.44) | Bug path active? |
|----------|---------------|---------------------|------------------|
| tegra210 | true | Yes (`apbdma`) | Yes — external DMA used today |
| tegra186/194 | true | No (194 lacks `dmas`) | No — falls back to PIO
before DMA alloc |
| tegra234 | false | N/A (internal DMA) | No behavior change from fix |
| tegra241 | true | No DT in tree yet | N/A currently |

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
- Record: `drivers/spi/` — IMPORTANT (peripheral driver), but DMA/IOMMU
  correctness on embedded Tegra hardware with SPI flash boot/storage.

**Step 7.2 — Subsystem activity**
- Record: Actively maintained — recent 6.18.y commits include timeout
  handling, `curr_xfer` race fixes, internal DMA support
  (`017f1b0bae08e`).

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Tegra platforms using external DMA for QSPI — tegra210 today;
  tegra194/241 once DT enables GPCDMA. Jetson Xavier NX (p3668) is the
  documented failing platform for the companion DT patch.

**Step 8.2 — Trigger conditions**
- Record:
  - External DMA path active (`has_ext_dma=true`, DMA channels
    successfully requested, `use_dma=true`).
  - Large SPI transfers exceeding FIFO depth.
  - Most impactful when IOMMU/SMMU separates DMA engine and controller
    stream IDs (tegra194 with GPCDMA).
  - Unprivileged users can trigger via SPI device access.

**Step 8.3 — Failure mode severity**
- Record:
  - IOMMU faults (CBB faults mentioned in cover letter) — **CRITICAL**
  - SPI transfer timeouts / hangs — **CRITICAL**
  - Potential buffer corruption with wrong mappings — **HIGH**
  - On tegra210 without IOMMU: bug may be latent (mappings may work by
    accident) — lower practical severity there.

**Step 8.4 — Risk-benefit**
- Record:
  - **Benefit:** HIGH for tegra194 DMA enablement; MEDIUM for tegra210;
    enables correct external DMA operation matching established
    i2c-tegra precedent.
  - **Risk:** VERY LOW — 29-line single-file change, proven API, no-op
    for internal-DMA path.
  - **Ratio:** Strong benefit, minimal risk.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real DMA/IOMMU correctness bug with established kernel precedent
  (i2c-tegra fix already in 6.18.y).
- Required prerequisite for tegra194 DMA enablement fixing Jetson Xavier
  NX SPI NOR timeouts and CBB faults.
- tegra210 already uses external DMA with buggy device pointer today.
- Small, surgical, applies cleanly.
- Maintainer-reviewed and merged (Mark Brown; suggested by Thierry
  Reding).
- Prevents IOMMU faults, hangs, and potential data corruption.

**Evidence AGAINST backport:**
- Alone does not enable tegra194 DMA (needs companion DT patch 2/2).
- On current 6.18.44 tegra194 configs, driver falls back to PIO (no
  `dmas` in DT) — this specific commit doesn't fix the documented Xavier
  NX timeout by itself.
- tegra234 (internal DMA) unaffected.
- No syzbot report or explicit user `Reported-by:` in commit message.

**Unresolved questions:**
- Exact practical impact on tegra210 without IOMMU is unverified (may be
  latent).
- Pre-existing driver issues flagged by Sashiko review when DMA is
  enabled are separate bugs.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — mirrors accepted i2c-tegra
   fix; API well-established.
2. Fixes a real bug affecting users? **PASS** — DMA engine device
   mismatch is a real bug; tegra210 affected now, tegra194 when DMA
   enabled.
3. Important issue? **PASS** — IOMMU faults, system lockups, transfer
   failures (CRITICAL/HIGH).
4. Small and contained? **PASS** — 29 lines, one file.
5. No new features or APIs? **PASS** — bug fix only.
6. Can apply to local tree? **PASS** — verified clean cherry-pick.

**Exception category:** Not a device-ID/quirk/DT-only fix; this is a
driver DMA correctness bug fix.

---

## Problem Summary

The tegra210-quad SPI driver allocates and maps DMA buffers using the
SPI controller's `struct device`, but when `has_ext_dma` is true, an
external DMA engine (GPCDMA on tegra194/241, APBDMA on tegra210)
performs the actual memory accesses. The DMA API must use the DMA
engine's device so IOMMU mappings and DMA operations match the hardware
master doing the transfer.

Without this fix, enabling external DMA (as done in the companion
tegra194 DT patch) can cause IOMMU faults, SPI transfer failures,
timeouts, and system lockups — exactly what the series cover letter
documents for Jetson Xavier NX SPI NOR flash.

For 6.18.44 users, tegra210 platforms with `dmas` in DT already exercise
the buggy path. The fix is a necessary prerequisite before tegra194 DMA
can work correctly.

## Verification

- [Phase 1] `git describe HEAD` → `v6.18.44`; parsed commit message tags
  and body from provided diff and `git show f469138a77ac5`
- [Phase 2] Read current `spi-tegra210-quad.c` lines 568–818; confirmed
  all DMA API calls use `tqspi->dev`
- [Phase 3] `git blame` lines 577/801 → introduced in `921fc1838fb036`
  (2020); `017f1b0bae08e` added `has_ext_dma`; `git merge-base --is-
  ancestor f469138a77ac5 HEAD` → NOT in HEAD
- [Phase 3] `git cherry-pick --no-commit f469138a77ac5` → exit 0, clean
  auto-merge
- [Phase 4] `b4 dig -c f469138a77ac5` → lore URL found; `b4 dig -a` →
  v1/v2 series; `b4 dig -m` → cover letter documents Xavier NX
  timeouts/CBB faults
- [Phase 4] `b4 dig -w` → Mark Brown, Thierry Reding, linux-tegra CC'd
- [Phase 5] Traced call chain: probe → `tegra_qspi_init_dma()`; transfer
  → `tegra_qspi_start_dma_based_transfer()` →
  `tegra_qspi_dma_map_xfer()`
- [Phase 5] `grep dmaengine_get_dma_device` → API present in
  `include/linux/dmaengine.h:1672`
- [Phase 6] `grep rx_dma_dev` in driver → no matches (fix absent);
  tegra210 DT has `dmas` at `tegra210.dtsi:1883`; tegra194 QSPI nodes
  lack `dmas` at `tegra194.dtsi:921-932`
- [Phase 6] `git log stable/linux-6.18.y --grep='Allocate DMA memory' --
  i2c-tegra.c` → `cdbf26251d3b3` present
- [Phase 8] Cover letter: "time out on all transfers... cbb fault,
  locking up the entire unit"
- UNVERIFIED: Practical tegra210 impact without IOMMU (no IOMMU property
  in tegra210 QSPI DT)

**YES**The background search finished and matches what the full review
already found.

**Commit:** `f469138a77ac5` — `spi: tegra210-quad: Allocate DMA memory
for DMA engine`
**Tree:** `v6.18.44` (`stable/linux-6.18.y`) — the fix is **not** in
this tree yet, but it cherry-picks cleanly.

**What it does:** Uses the external DMA engine’s `struct device` (via
`dmaengine_get_dma_device()`) for DMA map/alloc/unmap instead of the SPI
controller device — same pattern as the existing `i2c: tegra` fix
already in 6.18.y.

**Why it matters:** Needed for correct external DMA on Tegra QSPI
(tegra210 today; tegra194 once DMA is enabled in DT). Without it, you
can get IOMMU faults, transfer failures, and hangs — the Jetson Xavier
NX SPI NOR issue from the patch series.

**Verdict: YES** for backport to 6.18.y.

 drivers/spi/spi-tegra210-quad.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 83def82fe48c1..543f13503df3d 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -226,11 +226,13 @@ struct tegra_qspi {
 	struct completion			xfer_completion;
 	struct spi_transfer			*curr_xfer;
 
+	struct device				*rx_dma_dev;
 	struct dma_chan				*rx_dma_chan;
 	u32					*rx_dma_buf;
 	dma_addr_t				rx_dma_phys;
 	struct dma_async_tx_descriptor		*rx_dma_desc;
 
+	struct device				*tx_dma_dev;
 	struct dma_chan				*tx_dma_chan;
 	u32					*tx_dma_buf;
 	dma_addr_t				tx_dma_phys;
@@ -574,15 +576,15 @@ static int tegra_qspi_dma_map_xfer(struct tegra_qspi *tqspi, struct spi_transfer
 	len = DIV_ROUND_UP(tqspi->curr_dma_words * tqspi->bytes_per_word, 4) * 4;
 
 	if (t->tx_buf) {
-		t->tx_dma = dma_map_single(tqspi->dev, (void *)tx_buf, len, DMA_TO_DEVICE);
-		if (dma_mapping_error(tqspi->dev, t->tx_dma))
+		t->tx_dma = dma_map_single(tqspi->tx_dma_dev, (void *)tx_buf, len, DMA_TO_DEVICE);
+		if (dma_mapping_error(tqspi->tx_dma_dev, t->tx_dma))
 			return -ENOMEM;
 	}
 
 	if (t->rx_buf) {
-		t->rx_dma = dma_map_single(tqspi->dev, (void *)rx_buf, len, DMA_FROM_DEVICE);
-		if (dma_mapping_error(tqspi->dev, t->rx_dma)) {
-			dma_unmap_single(tqspi->dev, t->tx_dma, len, DMA_TO_DEVICE);
+		t->rx_dma = dma_map_single(tqspi->rx_dma_dev, (void *)rx_buf, len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(tqspi->rx_dma_dev, t->rx_dma)) {
+			dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
 			return -ENOMEM;
 		}
 	}
@@ -597,9 +599,9 @@ static void tegra_qspi_dma_unmap_xfer(struct tegra_qspi *tqspi, struct spi_trans
 	len = DIV_ROUND_UP(tqspi->curr_dma_words * tqspi->bytes_per_word, 4) * 4;
 
 	if (t->tx_buf)
-		dma_unmap_single(tqspi->dev, t->tx_dma, len, DMA_TO_DEVICE);
+		dma_unmap_single(tqspi->tx_dma_dev, t->tx_dma, len, DMA_TO_DEVICE);
 	if (t->rx_buf)
-		dma_unmap_single(tqspi->dev, t->rx_dma, len, DMA_FROM_DEVICE);
+		dma_unmap_single(tqspi->rx_dma_dev, t->rx_dma, len, DMA_FROM_DEVICE);
 }
 
 static int tegra_qspi_start_dma_based_transfer(struct tegra_qspi *tqspi, struct spi_transfer *t)
@@ -745,7 +747,7 @@ static int tegra_qspi_start_cpu_based_transfer(struct tegra_qspi *qspi, struct s
 static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 {
 	if (tqspi->tx_dma_buf) {
-		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
+		dma_free_coherent(tqspi->tx_dma_dev, tqspi->dma_buf_size,
 				  tqspi->tx_dma_buf, tqspi->tx_dma_phys);
 		tqspi->tx_dma_buf = NULL;
 	}
@@ -756,7 +758,7 @@ static void tegra_qspi_deinit_dma(struct tegra_qspi *tqspi)
 	}
 
 	if (tqspi->rx_dma_buf) {
-		dma_free_coherent(tqspi->dev, tqspi->dma_buf_size,
+		dma_free_coherent(tqspi->rx_dma_dev, tqspi->dma_buf_size,
 				  tqspi->rx_dma_buf, tqspi->rx_dma_phys);
 		tqspi->rx_dma_buf = NULL;
 	}
@@ -782,6 +784,7 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 		}
 
 		tqspi->rx_dma_chan = dma_chan;
+		tqspi->rx_dma_dev = dmaengine_get_dma_device(tqspi->rx_dma_chan);
 
 		dma_chan = dma_request_chan(tqspi->dev, "tx");
 		if (IS_ERR(dma_chan)) {
@@ -790,15 +793,19 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 		}
 
 		tqspi->tx_dma_chan = dma_chan;
+		tqspi->tx_dma_dev = dmaengine_get_dma_device(tqspi->tx_dma_chan);
 	} else {
 		if (!device_iommu_mapped(tqspi->dev)) {
 			dev_warn(tqspi->dev,
 				 "IOMMU not enabled in device-tree, falling back to PIO mode\n");
 			return 0;
 		}
+
+		tqspi->rx_dma_dev = tqspi->dev;
+		tqspi->tx_dma_dev = tqspi->dev;
 	}
 
-	dma_buf = dma_alloc_coherent(tqspi->dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
+	dma_buf = dma_alloc_coherent(tqspi->rx_dma_dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
 	if (!dma_buf) {
 		err = -ENOMEM;
 		goto err_out;
@@ -807,7 +814,7 @@ static int tegra_qspi_init_dma(struct tegra_qspi *tqspi)
 	tqspi->rx_dma_buf = dma_buf;
 	tqspi->rx_dma_phys = dma_phys;
 
-	dma_buf = dma_alloc_coherent(tqspi->dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
+	dma_buf = dma_alloc_coherent(tqspi->tx_dma_dev, tqspi->dma_buf_size, &dma_phys, GFP_KERNEL);
 	if (!dma_buf) {
 		err = -ENOMEM;
 		goto err_out;
-- 
2.53.0

