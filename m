Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3683D546288;
	Mon, 19 Oct 2026 13:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418191; cv=none; b=CBT+XvEmyOZ9x5L7WUUNi0mr1Dk8yHOxwKXy2MAGcP63KvMyR5P2vi/vhgpOa3LC9YBrIcOdHOSdeutbhrO3qykw77YZ14s5fjxc8sp2Vx47CZtUYEnZwEbUIBJkFr4Xt8I0wWSpHRpChgarIUSfT+QpikeCBqQtBsjCQb+u8wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418191; c=relaxed/simple;
	bh=AX4G5M/l4pEn3tkdmVigvCkYkKoXoaKsb4/sjzEYnwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8nDTFga1Gs2I85KnU24++dActqztEjqQT8i9D3+nttRT+VMi5boeo07v3WxX2OXSmCPwYdO14tE+jmCGnZg1kMKk2HKDxYoIvyAfv3IufEsFJ2DiWtdVIyTcFsYrlzb30AlRboPWxmeBDJI9w3QcdrvRbSufFySTNvoYj+QsUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SAfbooNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SAfbooNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D1C1F000C9;
	Mon, 19 Oct 2026 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418189;
	bh=UQlDHQUdb/bd+gCQro2HwgqSCPn9jpzGKnGKL2csRHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SAfbooNotILCYa5eiTOutjebDTa1BWTuJbbynknjLoSTEc2/M2Ln8T10ZKbu1haGw
	 7tI1odBvG68DW33j1Rk/orn1z3L1ubm83mdWIjE1FOXM0cAKmU5FFrI5HPzbMKYW4w
	 PfjY2EHw0jFgz32OqV9TAYNi+w++rqr/LUuVUEYL8c0pWUs+Cj3s3iDPNwW/Pz021A
	 R6TnPPWwG2jUEMSIGso5YMh6pRaARGVG/BmHzYU5XcMAozqmzaR/KacYwWgeRG6mK8
	 Ofdh56YXzR1gyE2bC33AtQggx0gl+HqNDQbiOMoLip6IGt6LObuWaekloVy7qOqhDk
	 8PX62F1+1stJg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	jh80.chung@samsung.com,
	linux-mmc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Mon, 19 Oct 2026 09:46:06 -0400
Message-ID: <20261019135441.1420968-75-sashal@kernel.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit cb3fcb8d118b874178251d1f02613f60d25e4ddc ]

When transfer was stopped in STATE_DATA_BUSY state, there was no call to
dma_ops->cleanup function, so the DMA mapped buffer was never properly
unmapped. Fix this by calling dw_mci_stop_dma() function also in that
state to ensure proper cleanup call when DMA transfer was used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **v7.3-rc4** (`origin/master`). The
candidate is `cb3fcb8d118b8` (`mmc: dw_mmc: stop and complete DMA also
in STATE_DATA_BUSY state`): a one-line DMA-cleanup hole in a host used
on Exynos, Rockchip, and similar SoCs.

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
Record: **[mmc/dw_mmc] [stop and complete] Call DMA stop/cleanup in
`STATE_DATA_BUSY` so mapped buffers are unmapped.**

**Step 1.2 — Tags**
Record:
- Signed-off-by: Marek Szyprowski (author; DMA-mapping maintainer)
- Reviewed-by: Shawn Lin (dw_mmc co-maintainer)
- Signed-off-by: Ulf Hansson (MMC maintainer)
- No Fixes:, Reported-by, Tested-by, Link:, or Cc: stable (absence is
  expected here)

**Step 1.3 — Body**
Record: **Bug:** finishing a transfer in `STATE_DATA_BUSY` never called
`dma_ops->cleanup`, so a DMA-mapped SG list was left mapped.
**Symptom:** DMA mapping leak (DMA-API/IOMMU leftover mappings). **Root
cause:** `dw_mci_stop_dma()` already runs in the sending-data / error
paths, but not in `STATE_DATA_BUSY` before `host->data = NULL`.
**Versions:** none stated.

**Step 1.4 — Hidden bug fix?**
Record: **No disguise.** It is an explicit resource-cleanup fix.

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
Record: `drivers/mmc/host/dw_mmc.c` **+1 / −0**. Function:
`dw_mci_work_func()`. **Single-file, one-line surgical fix.**

**Step 2.2 — Flow**
Record: In `case STATE_DATA_BUSY:`, after `EVENT_DATA_COMPLETE` and
`dw_mci_stop_fault_timer()`, **before** `host->data = NULL`, the code
now calls `dw_mci_stop_dma(host)`. That function stops the DMA engine if
`host->using_dma` and then runs `dma_ops->cleanup()`. Previously this
state only nulled `host->data` and completed the request.

**Step 2.3 — Bug mechanism**
Record: **Resource leak / DMA mapping leak.** `dw_mci_dma_cleanup()`
unmaps only when `host->data` is set and `host_cookie == COOKIE_MAPPED`.
Clearing `host->data` first made later cleanup a no-op.

Verified paths:
- Success: IDMAC/EDMAC `dw_mci_dmac_complete_dma()` already calls
  cleanup, then `EVENT_XFER_COMPLETE` moves the machine into
  `STATE_DATA_BUSY`. Second cleanup is a no-op (`COOKIE_UNMAPPED`).
- Error from `STATE_SENDING_DATA`: already calls `dw_mci_stop_dma()`.
- **DMA start failure then PIO fallback:** `dw_mci_submit_data_dma()`
  sets `using_dma = 1` after a successful map, then on
  `dma_ops->start()` failure calls `stop()` but **not** cleanup, and
  **does not** clear `using_dma`. PIO then completes via
  `STATE_DATA_BUSY`. Without this line the mapping is left. Verified:
  `using_dma` is assigned only at lines 998 and 1010; PIO fallback
  (lines 1070–1103) never clears it.
- `COOKIE_PRE_MAPPED` block I/O still unmaps in `dw_mci_post_req()`;
  this change does not double-unmap that path.

**Step 2.4 — Fix quality**
Record: **Obviously correct** and matches the other data-path states.
Cleanup is idempotent. `dw_mci_start_request()` zeros `pending_events`,
so the extra `EVENT_XFER_COMPLETE` bit from `dw_mci_stop_dma()` does not
leak into the next request. **Regression risk: low.**
`dmaengine_terminate_async()` / IDMAC reset after a completed transfer
is the same stop used on errors; IDMAC start already resets the engine.

## Phase 3: Git history

**Step 3.1 — Blame**
Record: `host->data = NULL` in `STATE_DATA_BUSY` is from
**f95f3850f7a9e1** (Will Newton, 2011-01-02), first in **v2.6.38**. The
hole is old.

**Step 3.2 — Fixes: tag**
Record: **None.** Related older fix **faecf41106123** (“fix unmap sg
twice when finding data err”, 2016) made cleanup skip IDMAC complete
when `EVENT_DATA_ERROR` is set, so `stop_dma()` is the unmap path on
errors. That makes missing `stop_dma()` in `STATE_DATA_BUSY` more
important, not less.

**Step 3.3 — File history**
Record: Recent dw_mmc work is refactor (board struct, PM macros). This
commit is standalone, not `N/M`. No follow-up in `cb3fcb8d118b8..HEAD`
except an unrelated `dw_mci_pmops` move.

**Step 3.4 — Author**
Record: Marek Szyprowski is the DMA-mapping maintainer; first dw_mmc
commit in this file. Shawn Lin (dw_mmc maintainer) reviewed it. Ulf
Hansson applied it.

**Step 3.5 — Dependencies**
Record: **None.** It only calls existing `dw_mci_stop_dma()`. Applies
standalone.

## Phase 4: Mailing list

**Step 4.1**
Record: https://patch.msgid.link/20260603083935.3201411-1-
m.szyprowski@samsung.com
**v1 only** (no v2/v3). Thread (3 messages via `b4 dig -m`):
1. Patch (3 Jun 2026)
2. Shawn Lin: Reviewed-by
3. Ulf Hansson: “Applied for next, thanks! Please, let me know if you
   think there is reason to tag this for stable kernels too.” **No
   reply** in the thread.

**Step 4.2**
Record: CCs were linux-mmc, Jaehoon Chung, Shawn Lin, Ulf Hansson — the
right maintainers.

**Step 4.3**
Record: No syzbot/bugzilla. Author describes a mapping leak, not a crash
log.

**Step 4.4**
Record: Standalone, not part of a series.

**Step 4.5**
Record: **UNVERIFIED** — lore.kernel.org/stable is behind bot protection
(403/Anubis). linux-mmc thread has Ulf’s open stable question and no
nomination.

## Phase 5: Code semantics

**Step 5.1**
Record: Modified: `dw_mci_work_func`. Callee: `dw_mci_stop_dma` →
`dma_ops->stop` / `dma_ops->cleanup` (`dw_mci_idmac_stop_dma` or
`dw_mci_edmac_stop_dma`, then `dw_mci_dma_cleanup`).

**Step 5.2**
Record: `dw_mci_work_func` is the host BH work (`host->bh_work`), queued
from IRQ/timeout/DMA complete. Reachable on every data transfer for this
host.

**Step 5.3**
Record: Completes MMC requests (`dw_mci_data_complete`,
`dw_mci_request_end` → `mmc_request_done`).

**Step 5.4**
Record: Userspace (block I/O, ioctl, card init) triggers it via the MMC
core. **Yes, reachable from userspace** on DW MMC hardware.

**Step 5.5**
Record: Same `dw_mci_stop_dma()` already used in `STATE_SENDING_CMD`
(cmd+data error) and twice in `STATE_SENDING_DATA`. This fills the
missing sibling.

## Phase 6: This tree

**Step 6.1**
Record: Tree is **v7.3-rc4** (`git describe`:
`v7.3-rc4-27-gf0100363d8c37`, `VERSION=7 PATCHLEVEL=3`). Candidate **is
an ancestor of HEAD**. Buggy pattern existed here before that commit;
introduced in v2.6.38.

**Step 6.2**
Record: **Clean apply** on this tree (already applied). Context
(`dw_mci_stop_fault_timer` then `host->data = NULL`) is present.

**Step 6.3**
Record: No other fix for this hole. faecf41106123 is a related double-
unmap fix, not a substitute.

## Phase 7: Subsystem

**Step 7.1**
Record: **MMC host (Synopsys DesignWare).** **IMPORTANT** — eMMC/SD on
Exynos, Rockchip, Hisilicon, StarFive, BlueField, K3 (`MMC_DW_*` in
Kconfig). Not core mm/VFS, not staging.

**Step 7.2**
Record: File is actively maintained (refactors in 2026 plus this fix).
The state machine itself is old and stable.

## Phase 8: Impact and risk

**Step 8.1**
Record: **Driver-specific / config-specific** (`CONFIG_MMC_DW`). Large
ARM/embedded population.

**Step 8.2**
Record: Hits whenever `STATE_DATA_BUSY` finishes a DMA-using request
that did not already go through `stop_dma()`. Common path still unmaps
via the DMA complete callback or `post_req`. The leak is real on **DMA-
submit failure → PIO**, and on any DATA_BUSY completion that never ran
complete/stop. Unprivileged block I/O can reach the host.

**Step 8.3**
Record: **DMA mapping leak.** Leftover mappings: DMA-API warnings, IOMMU
table growth, coherency issues if pages are reused while still mapped.
**Severity: HIGH** on the leak path, **MEDIUM** overall because the hot
success path already unmaps.

**Step 8.4**
Record: **Benefit: high** for DW MMC users (correct DMA lifetime, stop
IDMAC after data-complete). **Risk: very low** (1 line, idempotent
cleanup). **Ratio: favorable.**

## Phase 9: Synthesis

**For backporting**
- Real DMA-mapping leak; author is the DMA-mapping maintainer.
- One line, same helper already used in sibling states.
- dw_mmc co-maintainer Reviewed-by; MMC maintainer applied it.
- Hardware is common; bug dates to v2.6.38.
- Cleanup is idempotent; next request clears pending events.
- No series dependency, no follow-up revert.

**Against**
- No Fixes:/Cc: stable (expected in this pipeline).
- Ulf explicitly asked whether it belonged in stable; author never
  answered.
- No crash/syzbot report; success-path unmap often already happened.
- Leak is most clearly proven on the DMA-start-failure → PIO path, not
  every transfer.

**Unresolved**
- No stable@ discussion found (lore blocked).
- Exact reproducer Marek hit is not in the mail (only the mechanism).

**Stable rules**
1. Obviously correct and tested? **PASS** — 1-line, reviewed, in
   mainline since 2026-07-06.
2. Real user-affecting bug? **PASS** — leftover DMA mappings on DW MMC.
3. Important (crash/security/corruption/deadlock)? **PASS** — mapping
   leak can WARN, exhaust IOMMU, and cause coherency bugs; not a panic,
   but it is a real DMA-lifetime bug, not style.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS**.
6. Applies to this tree? **PASS**.

**Exception category:** none (not a device ID / quirk / DT / build / doc
patch). It is a normal contained bugfix.

Ulf’s “tag for stable?” question is caution, not a NAK. The instructions
say missing stable tags must not drive a NO. On technical merit this
belongs in stable: tiny, correct, and it closes a DMA unmap hole in a
widely deployed MMC host.

Verification:
- [Phase 1] Parsed tags: Marek SOB, Shawn Lin R-b, Ulf SOB; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 line `dw_mci_stop_dma(host)` in `STATE_DATA_BUSY`
  before `host->data = NULL`
- [Phase 2] `dw_mci_stop_dma`/`dw_mci_dma_cleanup` read; cleanup gated
  on `COOKIE_MAPPED`
- [Phase 2] IDMAC/EDMAC complete path already calls cleanup; `using_dma`
  not cleared on DMA-start failure (lines 998, 1010, 1039–1045, 1070)
- [Phase 3] blame: f95f3850f7a9e1 (v2.6.38); candidate cb3fcb8d118b8;
  related faecf41106123 double-unmap
- [Phase 3] `git merge-base --is-ancestor cb3fcb8d118b8 HEAD` — true; no
  follow-up fix on dw_mmc.c
- [Phase 4] `b4 dig -c/-a/-w/-m`: v1 only; Shawn R-b; Ulf applied and
  asked about stable; no author reply
- [Phase 4] lore WebFetch 403; mbox used instead
- [Phase 5] callers: BH work from IRQ/DTO/DMA complete; userspace via
  MMC core
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 7] MAINTAINERS: Jaehoon Chung, Shawn Lin; Kconfig MMC_DW_*
  platforms
- [Phase 8] Failure mode: DMA mapping leak, severity HIGH on leak path
- UNVERIFIED: stable@ archive search (Anubis); exact runtime stack Marek
  saw

**YES**

 drivers/mmc/host/dw_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index c5db92bbb0946..90cc41901edaa 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2213,6 +2213,7 @@ static void dw_mci_work_func(struct work_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0

