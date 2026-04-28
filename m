Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF13240B6E4;
	Tue, 28 Apr 2026 10:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372959; cv=none; b=Z5JrZkmlxdVxYLB73HyTrRn1IJ6J/oGr84Z3y6x9hAHOV2U1lKeee8rN52XUD1Bj0gzxeXWev6iT9QQOkNHgWc+NX298U44Gm6AGzDJwoEeX+3vitn9B6y7wKnGp0IcEtJ1hFLbuWk2kPmnJOQJ8NWS6vNfFU2i/8MhfZf970pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372959; c=relaxed/simple;
	bh=5LYiZP7vYO+EkpvWWqnnAIKaqH/Us9EyYCZBmb881ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVCDLP1ap6635fU9QTI3E07B6IXWqALUE0ig+DkJlhxyIPfLWJdsOtPtcYuQu47wb2o7rVvwh/4gWnUHsxt7/6s0dNbNuK24KAwNLo0dCxMq2bXPCdywzWyK1c7y2Hxf4ymmaHfSd2Wu9CUPADSIi1FRw1Weob+xjdWGGY91J20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e/73hPMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e/73hPMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D3EC2BCB9;
	Tue, 28 Apr 2026 10:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372958;
	bh=5LYiZP7vYO+EkpvWWqnnAIKaqH/Us9EyYCZBmb881ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/73hPMN9EdgomwVzHukJJtlts/ilSsZCdw7CvRy9Q5xKAZ8Oi6WnUU5onmkySA3Y
	 uM18PWKu07LehJ3ax/Za9nB+svFBp7gdIE8Wm8dQElC/qj6KU+Oiy/aN14KSTs8azu
	 Jiwd2f1mYQHCktyTeprduzEbIqWGUgv/hDgP8YN/RlzViRAFdfnOwPp4y+nlL40pR0
	 Ta0IsuFS4NwCOeloYa7NRyDF6Li83fOa44GN0aJPTfvihhtrPjtIwdwqgl3iIdBZsu
	 GpoZmLgeDTbyMySYBP8Wll8ETHPIT1F1qrjWdE1v3JpK9f2wYmRUbcp5koRuNUhjQA
	 2crRS/qguvxnA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Robin Gong <yibin.gong@nxp.com>,
	Sherry Sun <sherry.sun@nxp.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	jirislaby@kernel.org,
	shawnguo@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 7.0-5.10] tty: serial: imx: keep dma request disabled before dma transfer setup
Date: Tue, 28 Apr 2026 06:40:57 -0400
Message-ID: <20260428104133.2858589-46-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428104133.2858589-1-sashal@kernel.org>
References: <20260428104133.2858589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Robin Gong <yibin.gong@nxp.com>

[ Upstream commit 74e0c9f0528bcd597cb1299a027d7be27d1c27d9 ]

Since sdma hardware configure postpone to transfer phase, have to
disable dma request before dma transfer setup because there is a
hardware limitation on sdma event enable(ENBLn) as below.

Refer SDMA 2.6.28 Channel Enable RAM (SDMAARMx_CHNENBLn) section:
"It is thus essential for the Arm platform to program them before any
DMA request is triggered to the SDMA, otherwise an unpredictable
combination of channels may be started."

Signed-off-by: Robin Gong <yibin.gong@nxp.com>
Signed-off-by: Sherry Sun <sherry.sun@nxp.com>
Link: https://patch.msgid.link/20260312094526.297348-1-sherry.sun@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to provide the full analysis.

## Analysis: tty: serial: imx: keep dma request disabled before dma
transfer setup

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line**
Record: `tty: serial: imx:` subsystem, action verb "keep" (implies
correcting improper state), one-line summary: "ensure UART DMA request
stays disabled until SDMA channel is fully configured."

**Step 1.2: Tags**
Record:
- Signed-off-by: Robin Gong (author, NXP), Sherry Sun (submitter, NXP),
  Greg Kroah-Hartman (tty maintainer)
- Link:
  https://patch.msgid.link/20260312094526.297348-1-sherry.sun@nxp.com
- NO Fixes: tag (expected)
- NO Cc: stable tag (expected)
- NO Reported-by/Tested-by/Reviewed-by

**Step 1.3: Commit body analysis**
Record: Commit explains a hardware limitation documented in the SDMA
reference manual (section 2.6.28, "Channel Enable RAM /
SDMAARMx_CHNENBLn"). When UART asserts a DMA request before the SDMA
channel script has been properly configured, "unpredictable combination
of channels may be started." No stack trace/reproducer, but cites an
authoritative NXP/Freescale hardware reference manual. Root cause: SDMA
configuration is postponed to the transfer phase, so starting the UART
DMA request before `dma_async_issue_pending()` on the corresponding
channel is a hardware-level ordering violation.

**Step 1.4: Hidden bug fix detection**
Record: Yes — "keep disabled before setup" is a classic disguised bug
fix. This corrects an improper ordering that leads to undefined hardware
behavior.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
Record: 1 file (`drivers/tty/serial/imx.c`), 3 lines modified + 2
comment lines changed, 1 line added net. Two functions touched:
`imx_uart_enable_dma()` and `imx_uart_startup()`. Scope: single-file
surgical fix.

**Step 2.2: Code flow change**

```1438:1451:drivers/tty/serial/imx.c
static void imx_uart_enable_dma(struct imx_port *sport)
{
        u32 ucr1;

        imx_uart_setup_ufcr(sport, TXTL_DMA, RXTL_DMA);

        /* set UCR1 */
        ucr1 = imx_uart_readl(sport, UCR1);
        ucr1 |= UCR1_RXDMAEN | UCR1_TXDMAEN | UCR1_ATDMAEN;
        imx_uart_writel(sport, ucr1, UCR1);

        sport->dma_is_enabled = 1;
}
```

Record:
- Hunk 1 (`imx_uart_enable_dma`): BEFORE sets `UCR1_RXDMAEN |
  UCR1_TXDMAEN | UCR1_ATDMAEN` atomically; AFTER sets only `UCR1_RXDMAEN
  | UCR1_ATDMAEN` (TXDMAEN now enabled later in `imx_uart_dma_tx`).
- Hunk 2 (`imx_uart_startup`): BEFORE calls `imx_uart_enable_dma()` THEN
  `imx_uart_start_rx_dma()`; AFTER calls `imx_uart_start_rx_dma()` THEN
  `imx_uart_enable_dma()`. The RX DMA channel is configured/submitted
  BEFORE the UART starts asserting DMA requests.

**Step 2.3: Bug mechanism**
Record: Category (h) Hardware workaround + ordering/correctness fix. The
mechanism: UART asserting DMA requests on UCR1 before SDMA has a valid
descriptor/channel configuration can trigger an ill-defined SDMA
channel, leading to corrupted/misrouted transfers. Confirmed by
verifying that `imx_uart_dma_tx()` at line 662-664 already sets
`UCR1_TXDMAEN` just before
`dmaengine_submit()/dma_async_issue_pending()` — so removing it from
`imx_uart_enable_dma()` is safe (TXDMAEN will still be set when actually
needed).

**Step 2.4: Fix quality**
Record: Obviously correct. The fix preserves exact functionality
(TXDMAEN still ends up set before TX transfer, RX DMA still starts
before UART DMA requests flow). No regression risk in the fix itself —
just reorders two well-defined function calls and defers one register
bit. No locking changes, no API changes.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
Record: `imx_uart_enable_dma` and UART DMA support originated from
commit `b4cdc8f61beb2` ("serial: imx: add DMA support for imx6q", July
2013). The `temp |= UCR1_RDMAEN | UCR1_TDMAEN | UCR1_ATDMAEN` line was
set together from day one — the buggy ordering has been present since
2013 (kernel v3.11). All active stable trees inherit it.

**Step 3.2: Fixes: tag** — Not present. The bug is a long-standing
hardware sequencing violation.

**Step 3.3: Related file changes**
Record: Recent changes to `drivers/tty/serial/imx.c` (wake event
reporting, hrtimer, nbcon, etc.) do not touch the DMA init/enable paths
— no conflicts expected.

**Step 3.4: Author's relationship**
Record: Robin Gong is an NXP engineer and has authored the equivalent
fix in the SDMA driver itself (commit `107d06441b709` in 2018) which
changed where `sdma_event_enable()` is called. He's an authority on SDMA
hardware semantics.

**Step 3.5: Dependencies**
Record: No prerequisite commits needed. The fix depends only on
`imx_uart_dma_tx()` already containing `ucr1 |= UCR1_TXDMAEN`, which I
verified exists in v5.4, v5.10, v5.15, v6.1, v6.6, v6.12.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original submission**
Record: `b4 dig -c 74e0c9f0528bc` found
https://lore.kernel.org/all/20260312094526.297348-1-sherry.sun@nxp.com/.
Single-revision v1 patch. Thread contains only the patch submission — no
review replies, no NAKs, no stable nominations. Greg KH applied it
directly.

**Step 4.2: Recipients**
Record: Sent to gregkh, jirislaby (tty maintainers), Frank.Li@nxp.com,
s.hauer@pengutronix.de, kernel@pengutronix.de, festevam, tglx, mingo.
Appropriate maintainers CC'd.

**Step 4.3: Bug report** — No explicit report linked; the fix cites the
SoC reference manual.

**Step 4.4: Related series (CRITICAL)**
Record: The SAME hardware-sequencing fix was previously applied to the
SPI driver in commit `86d57d9c07d54` ("spi: imx: keep dma request
disabled before dma transfer setup", Oct 2025). That SPI fix has already
been backported to stable branches 5.10, 5.15, 6.1, 6.6, 6.12, and 6.17
(verified via `git branch --contains`). This establishes a clear
precedent that the stable maintainers consider this exact SDMA-ordering
issue worth backporting.

**Step 4.5: Stable ML** — The SPI equivalent already flowed into stable
via AUTOSEL.

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Call chain**
Record: `imx_uart_enable_dma()` is called exclusively from
`imx_uart_startup()`. `imx_uart_startup()` is the `uart_ops::startup`
callback, invoked every time a UART port is opened. This is a common,
user-triggerable path — every process opening `/dev/ttymxcN` hits it. So
the buggy sequencing is exercised on every UART open with DMA enabled.

**Step 5.5: Similar patterns**
Record: The same bug pattern exists in `drivers/spi/spi-imx.c` and was
fixed by commit `86d57d9c07d54`, already backported broadly. The SDMA
driver itself carries a comment "Set ENBLn earlier to make sure dma
request triggered after that" (`drivers/dma/imx-sdma.c:1859`),
corroborating that this ordering requirement is well-established
hardware lore.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy code exists in stable?**
Record: YES. Verified `imx_uart_enable_dma()` and the buggy
`imx_uart_enable_dma(); imx_uart_start_rx_dma();` ordering is present in
v5.4, v5.10, v5.15, v6.1, v6.6, v6.12. `imx_uart_dma_tx()` also already
contains the `ucr1 |= UCR1_TXDMAEN` statement (the dependency for the
fix).

**Step 6.2: Backport complications**
Record: Patch applies CLEANLY (`git apply --check` succeeded with no
output) against v5.4, v5.10, v5.15, v6.1, v6.6, v6.12. No backport
adjustments needed.

**Step 6.3: Related fixes already in stable**
Record: No — this particular fix has not yet flowed to stable for the
UART driver. The sibling SPI fix is already in stable trees.

### PHASE 7: SUBSYSTEM CONTEXT

Record: `drivers/tty/serial/imx.c` — IMX UART driver. Used by millions
of embedded/industrial iMX-based systems. Criticality: IMPORTANT
(driver-specific but widely deployed). Active subsystem (recent
wakeup/RXTL fixes show ongoing maintenance).

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected users**
Record: iMX SoC users (iMX6, iMX7, iMX8, iMX9 families) using UART with
DMA (typical when hardware flow control is enabled for high-throughput
serial communication).

**Step 8.2: Triggering conditions**
Record: Every time a DMA-capable iMX UART port is opened (uart startup
path). Whether the race window actually causes misbehavior depends on:
whether the TX FIFO happens to fall below the watermark immediately
after TXDMAEN is set but before a descriptor is prepared; whether the RX
line has incoming data arriving before start_rx_dma finishes. Easily
reachable on active serial links.

**Step 8.3: Failure mode**
Record: "unpredictable combination of channels may be started" per SDMA
hardware docs. In practice this can manifest as: lost/corrupted UART
data, spurious channel activation that may corrupt memory (SDMA writing
to stale addresses), or flaky DMA behavior that's hard to debug.
Severity: HIGH (data integrity + potential silent memory corruption on a
DMA engine).

**Step 8.4: Risk-benefit**
Record: BENEFIT: prevents documented hardware misbehavior on a widely-
deployed SoC family; consistency with SPI driver fix already in stable.
RISK: very low — 3-line reordering, no new locks/APIs, dependency
(TXDMAEN in dma_tx) verified present in all stable trees, patch applies
cleanly, identical fix pattern already tested in production via SPI
backport.

### PHASE 9: FINAL SYNTHESIS

**Evidence FOR:** Fixes documented SoC hardware limitation; tiny
surgical change; author is SDMA subject-matter expert; same fix pattern
already accepted into stable (5.10→6.17) for spi-imx; code path is very
common (uart_startup); patch applies cleanly to all stable trees; falls
into the "Hardware Quirk/Workaround" exception category.

**Evidence AGAINST:** No explicit Reported-by/Tested-by (but the fix
cites authoritative SoC docs); no explicit stable nomination (but
absence is expected).

**Stable rules checklist:**
1. Obviously correct and tested? YES — TXDMAEN placement verified,
   reorder is semantically equivalent.
2. Fixes a real bug? YES — documented hardware sequencing violation.
3. Important issue? YES — data corruption / unpredictable DMA behavior.
4. Small and contained? YES — 3 lines of actual code change.
5. No new features? YES — pure correctness/reorder fix.
6. Applies to stable trees? YES — clean apply verified.

**Exception category:** Hardware workaround for SDMA ENBLn sequencing
requirement.

### Verification
- [Phase 1] Parsed tags: no Fixes/Cc-stable/Reported-by; Link to lore
  verified
- [Phase 2] Diff shows `imx_uart_enable_dma` drops TXDMAEN;
  `imx_uart_startup` swaps call order of `start_rx_dma` and `enable_dma`
- [Phase 2] Verified `imx_uart_dma_tx()` in current tree and all stable
  trees contains `ucr1 |= UCR1_TXDMAEN` at lines
  ~658/657/666/660/682/637 respectively — the fix's dependency is met
- [Phase 3] `git log -S"imx_enable_dma"` identified original DMA commit
  `b4cdc8f61beb2` (Jul 2013)
- [Phase 3] `git blame` on `sdma_event_enable` call in imx-sdma.c
  corroborates the hardware ordering requirement
- [Phase 4] `b4 dig -c 74e0c9f0528bc` found lore URL; `-a` shows only
  v1; mbox inspection shows no replies/NAKs
- [Phase 4] `b4 dig -c 86d57d9c07d54` for sibling SPI fix confirmed it
  went through review (Frank Li, Mark Brown)
- [Phase 4] `git branch --contains` for multiple SPI backport commits
  confirmed backport to 5.10/5.15/6.1/6.6/6.12/6.17
- [Phase 5] Confirmed `imx_uart_enable_dma` has a single caller
  (`imx_uart_startup`) via `Grep`
- [Phase 6] `git show vX:drivers/tty/serial/imx.c` for v5.4, v5.10,
  v5.15, v6.1, v6.6, v6.12 all show identical buggy ordering
- [Phase 6] `git apply --check /tmp/fix.patch` succeeded on v5.4, v5.10,
  v5.15, v6.1, v6.6, v6.12 (no output = success)
- [Phase 8] Failure mode per SoC reference manual — cited directly in
  commit message
- UNVERIFIED: No user bug report could be located; severity inferred
  from SoC documentation only. The exact race-window probability on a
  specific board is not quantified.

Small, well-contained hardware-sequencing fix; same issue already
accepted into stable trees for the sister SPI driver; dependency
verified; applies cleanly. Meets all stable criteria.

**YES**

 drivers/tty/serial/imx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index c488e5d372ffd..251a50c8aa387 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1442,9 +1442,9 @@ static void imx_uart_enable_dma(struct imx_port *sport)
 
 	imx_uart_setup_ufcr(sport, TXTL_DMA, RXTL_DMA);
 
-	/* set UCR1 */
+	/* set UCR1 except TXDMAEN which would be enabled in imx_uart_dma_tx */
 	ucr1 = imx_uart_readl(sport, UCR1);
-	ucr1 |= UCR1_RXDMAEN | UCR1_TXDMAEN | UCR1_ATDMAEN;
+	ucr1 |= UCR1_RXDMAEN | UCR1_ATDMAEN;
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	sport->dma_is_enabled = 1;
@@ -1567,8 +1567,9 @@ static int imx_uart_startup(struct uart_port *port)
 	imx_uart_enable_ms(&sport->port);
 
 	if (dma_is_inited) {
-		imx_uart_enable_dma(sport);
+		/* Note: enable dma request after transfer start! */
 		imx_uart_start_rx_dma(sport);
+		imx_uart_enable_dma(sport);
 	} else {
 		ucr1 = imx_uart_readl(sport, UCR1);
 		ucr1 |= UCR1_RRDYEN;
-- 
2.53.0

