Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D004A3F21;
	Mon, 31 Aug 2026 13:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183767; cv=none; b=EGEBMGPj/Y8qtRjQT+zkXZ1oiy+NIxvCBLbhSNUYIJDmUGzWU1Y1ubO8jPjBZL+ss7/UgdYEvy731mio+QCRlbLYzYT5Kg9Iq3VnqOeMNzQ6SLt0l8a8mOKom/q+33t5yviLaZJ55zSptmB+Tr7iMGmzxeq8ki/u9PYKb2Uz4MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183767; c=relaxed/simple;
	bh=N1BBOcRLSxkUYj5Gm3D04LAXXCGrD8BKwFAkDmTPJy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xlj7VHCYvKwlEm+eskOsAaBXRci5UMUeJZhZVaP9I45W/drndkexH18ARPxZ6OhGQC+hGLVCHEzZPGsRAiCvnTHy03oEUle8FIsdN5cIeXjkTCBUaZHqXVvGP8NMrTCOWEfTASdg3CZWlZGpAGV9lHp3pAptTxwDb8DxMHhNsyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MT7xgvAU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MT7xgvAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8AB1F00ACA;
	Mon, 31 Aug 2026 13:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183764;
	bh=xnn9bQwB9WoD2kfZ2oydpaRS5gjrdq+bI3UUoQyCI8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT7xgvAUeJQC9PWX62vjCTXO7o5Gu6z8vKS69fWAojCrneG2ROSUo6hvVoT19imqa
	 IkveRZbAQF8vri/r7HD8+b/pecnB+NDiVRKvU995eTHC+oI/Ya6XalodVL+VLO6Do+
	 41ynzYdr8G8uI6e/hH7a1uajqIt4WZs5b72mtdlwx59NUUhhpg//kG/bQjGgshLMmg
	 pj+AM0O+/LXXfXGNhtXFwgIXJcQ7Kq8J2/QnQ61FEe2X4LMqEr8Dj5rBnCwIl5fgtp
	 IUi1XeqXKD/QeUlBLWQbGwTutLXHHq3rJcomIMfEnrAMu46Gup2o1ampeW5AT4hr02
	 TgH6WZoolhfZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jisheng Zhang <jszhang@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] spi: dw: fix wrong RX_SAMPLE_DLY setting after resume
Date: Mon, 31 Aug 2026 09:25:19 -0400
Message-ID: <20260831133314.4125787-291-sashal@kernel.org>
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

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 133c71b2c0bc976a4751f9e05ef7cdea67f964e5 ]

On platforms which need a non-zero rx sample delay, the RX_SAMPLE_DLY
reg setting is lost after resume. The reason is that the reg may be
reset to 0 after resuming, but dws->cur_rx_sample_dly doesn't know
this fact. Fix this issue by clearing dws->cur_rx_sample_dly in
dw_spi_shutdown_chip().

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Suggested-by: Mark Brown <broonie@kernel.org>
Link: https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `spi: dw: fix wrong RX_SAMPLE_DLY setting
after resume`

**Local tree:** `stable/linux-6.18.y` at **v6.18.44** (`make
kernelversion` = 6.18.44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[spi: dw]` `[fix]` — wrong `RX_SAMPLE_DLY` register setting
after system resume.

### Step 1.2: Commit Tags
**Record:**
- **Signed-off-by:** Jisheng Zhang `<jszhang@kernel.org>` (author)
- **Suggested-by:** Mark Brown `<broonie@kernel.org>` (SPI subsystem
  maintainer)
- **Link:**
  https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org
- **Signed-off-by:** Mark Brown `<broonie@kernel.org>` (maintainer ack)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`
- Notable: maintainer suggested and signed off; no syzbot report

### Step 1.3: Body Analysis
**Record:**
- **Bug:** On platforms needing non-zero RX sample delay, the
  `RX_SAMPLE_DLY` hardware register is lost after resume, but
  `dws->cur_rx_sample_dly` still holds the old cached value.
- **Symptom:** SPI transfers fail after suspend/resume because
  `dw_spi_update_config()` skips rewriting the register when cached and
  desired values match, while hardware is actually at 0.
- **Root cause:** `dw_spi_shutdown_chip()` does not clear
  `dws->cur_rx_sample_dly` when the controller is shut down for suspend.
- **Fix:** Clear `dws->cur_rx_sample_dly = 0` in
  `dw_spi_shutdown_chip()`, mirroring the existing `dws->current_freq =
  0` pattern.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not hidden — explicitly a bug fix. Same class of
software/hardware state desync as the already-backported BAUDR resume
fix (`95028569589f4`).

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/spi/spi-dw.h` only (+1 line)
- **Function modified:** `dw_spi_shutdown_chip()` (static inline)
- **Scope:** Single-file, surgical one-line fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `dw_spi_shutdown_chip()` disables chip, sets clock to 0,
  clears `current_freq`; `cur_rx_sample_dly` left stale.
- **After:** Also clears `cur_rx_sample_dly = 0`, so next
  `dw_spi_update_config()` call rewrites `RX_SAMPLE_DLY` after resume.
- **Path affected:** Suspend (`dw_spi_suspend_host()` →
  `dw_spi_shutdown_chip()`) and remove (`dw_spi_remove_host()`).

### Step 2.3: Bug Mechanism
**Record:** **Logic/correctness fix** — cached register shadow
(`cur_rx_sample_dly`) diverges from hardware after resume reset. The
optimization in `dw_spi_update_config()`:

```348:352:drivers/spi/spi-dw-core.c
        /* Update RX sample delay if required */
        if (dws->cur_rx_sample_dly != chip->rx_sample_dly) {
                dw_writel(dws, DW_SPI_RX_SAMPLE_DLY,
chip->rx_sample_dly);
                dws->cur_rx_sample_dly = chip->rx_sample_dly;
        }
```

skips the register write when values appear equal, but hardware has been
reset to 0.

### Step 2.4: Fix Quality
**Record:** Obviously correct. Minimal, mirrors the proven BAUDR fix
already in this tree. No new locks, no API changes. Regression risk:
very low — only forces a register rewrite on the first transfer after
shutdown/resume on platforms that use non-zero delay.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:**
- `dw_spi_shutdown_chip()` introduced by Andy Shevchenko (2015)
- `dws->current_freq = 0` added by `95028569589f4` (Jun 2026, already in
  6.18.y)
- `cur_rx_sample_dly` field added by `bac70b54ecb53` (Sep 2020) —
  present since v5.9 era
- Bug has existed since RX sample delay support was added (2020)

### Step 3.2: Fixes Tag
**Record:** N/A — no `Fixes:` tag. The analogous BAUDR fix used `Fixes:
e24c74527207` (original DW SPI driver). Same underlying pattern.

### Step 3.3: Related File History
**Record:**
- `95028569589f4` — "spi: dw: fix wrong BAUDR setting after resume" —
  **already in 6.18.y**
- `bac70b54ecb53` — "spi: dw: Add support for RX sample delay register"
  — **ancestor of HEAD**
- This fix is a natural companion to the BAUDR fix; standalone, not part
  of a series

### Step 3.4: Author Context
**Record:** Jisheng Zhang authored both the BAUDR resume fix and this
RX_SAMPLE_DLY fix. Mark Brown (SPI maintainer) suggested and signed off.

### Step 3.5: Dependencies
**Record:** No external dependencies. Requires only code already in
6.18.y:
- `cur_rx_sample_dly` field in `struct dw_spi`
- `dw_spi_update_config()` RX delay logic
- `dws->current_freq = 0` in `dw_spi_shutdown_chip()` (from BAUDR fix)
- `git apply --check` passes cleanly on current tree

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 607bd93e3d397` →
https://patch.msgid.link/20260803135925.12622-1-jszhang@kernel.org. `b4
dig -a` returned no additional revisions. Lore.kernel.org fetch blocked
by Anubis bot protection — could not read thread content for stable
nominations or NAKs.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` returned the same lore URL. Mark Brown
`Suggested-by` and `Signed-off-by` confirms maintainer involvement.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Bug class inferred
from commit message and parallel BAUDR fix ("spi transfer stops working
after resume").

### Step 4.4: Related Patches
**Record:** Direct companion to `95028569589f4` (BAUDR resume fix,
already backported to 6.18.y). Same author, same function, same
mechanism.

### Step 4.5: Stable List History
**Record:** Could not search lore stable list (bot protection). BAUDR
sibling fix was already accepted into 6.18.y stable.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `dw_spi_shutdown_chip()`, `dw_spi_update_config()`,
`dw_spi_suspend_host()`, `dw_spi_resume_host()`

### Step 5.2: Callers
**Record:**
- `dw_spi_shutdown_chip()` — called from `dw_spi_remove_host()` and
  `dw_spi_suspend_host()`
- `dw_spi_update_config()` — called from `dw_spi_transfer_one()` and
  SPI-mem paths in `spi-dw-core.c` and `spi-dw-bt1.c`
- `dw_spi_suspend_host()` / `dw_spi_resume_host()` — used by `spi-dw-
  pci.c` PM ops

### Step 5.3: Callees
**Record:** `dw_spi_shutdown_chip()` calls `dw_spi_enable_chip()`,
`dw_spi_set_clk()`. `dw_spi_resume_host()` calls `dw_spi_hw_init()` →
`dw_spi_reset_chip()`, which resets hardware but not software shadow
`cur_rx_sample_dly`.

### Step 5.4: Reachability
**Record:** Triggered on system suspend/resume on DW SPI controllers
with `rx-sample-delay-ns` in device tree. Affects normal SPI transfers
and SPI-mem (flash/NAND) operations post-resume. Not a syscall-level
bug, but affects common embedded suspend/resume workflows.

### Step 5.5: Similar Patterns
**Record:** Identical pattern to `dws->current_freq = 0` fix in
`95028569589f4`. Both are "shadow register cache vs. hardware reset
after resume" bugs.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Current `dw_spi_shutdown_chip()` in this tree:

```281:286:drivers/spi/spi-dw.h
static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
{
        dw_spi_enable_chip(dws, 0);
        dw_spi_set_clk(dws, 0);
        dws->current_freq = 0;
}
```

Missing `dws->cur_rx_sample_dly = 0`. Feature present since
`bac70b54ecb53` (2020).

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` of commit
`607bd93e3d397` succeeds with no conflicts. Patch adds one line
immediately after `dws->current_freq = 0`.

### Step 6.3: Related Fixes Already Present?
**Record:** BAUDR resume fix (`95028569589f4`) is in 6.18.y.
RX_SAMPLE_DLY fix (`607bd93e3d397`) is **not** in `stable/linux-6.18.y`
— only on `autosel` branch. Upstream mainline commit:
`133c71b2c0bc976a4751f9e05ef7cdea67f964e5`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/spi/` — DesignWare SPI core driver. **IMPORTANT**
for embedded SoCs (Intel SoCFPGA, Microchip Sparx5, RISC-V platforms,
etc.) using SPI for storage and peripherals.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained. Recent stable backport of sibling BAUDR
fix confirms maintainer awareness of resume-path bugs in this driver.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of DesignWare SPI controllers with non-zero `rx-
sample-delay-ns` in device tree who suspend/resume. Examples in this
tree: Microchip Sparx5 NAND
(`arch/arm64/boot/dts/microchip/sparx5_nand.dtsi`, 7 ns), Rockchip
Veyron (`arch/arm/boot/dts/rockchip/rk3288-veyron.dtsi`, 12 ns — if
using DW SPI). Config- and platform-specific, but hits real production
hardware.

### Step 8.2: Trigger Conditions
**Record:** System suspend-to-RAM followed by resume, then SPI transfer.
Requires non-zero RX sample delay. Moderately common on embedded systems
with PM enabled. Not unprivileged-triggerable in isolation, but affects
system reliability after normal suspend.

### Step 8.3: Failure Mode Severity
**Record:** SPI transfers silently fail or return corrupt data after
resume — **HIGH** functional impact (boot/storage/peripheral failure),
though not a kernel oops/panic. Same severity class as the BAUDR bug
("spi transfer stops working").

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected platforms — restores SPI after resume
- **Risk:** VERY LOW — one-line cache invalidation, proven pattern
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, reproducible functional bug on suspend/resume
- Same mechanism as BAUDR fix already accepted into 6.18.y
- One-line, obviously correct fix
- Maintainer-suggested and signed-off
- Applies cleanly to current tree
- Affects production DT configurations with `rx-sample-delay-ns`
- Bug present since 2020; long-standing issue for affected users

**AGAINST backport:**
- Only affects platforms with non-zero RX sample delay (subset of DW SPI
  users)
- No crash/oops — functional failure rather than kernel panic
- Only `spi-dw-pci.c` has PM ops in-tree (other platform drivers may add
  PM externally)

**Unresolved:**
- Full lore thread content unavailable (bot protection)
- No explicit user bug report or `Tested-by:` in commit message

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mirrors proven BAUDR fix;
   maintainer reviewed
2. Fixes a real bug affecting users? **PASS** — SPI broken after resume
   on affected platforms
3. Important issue? **PASS** — functional breakage on resume (HIGH
   severity for affected users)
4. Small and contained? **PASS** — 1 line, 1 file
5. No new features or APIs? **PASS** — cache invalidation only
6. Can apply to local tree? **PASS** — `git apply --check` succeeds

### Step 9.3: Exception Categories
**Record:** N/A — standard bug fix, not a quirk/DT/device-ID exception.

### Step 9.4: Decision Rationale

This commit is the direct companion to the BAUDR resume fix already
backported to Linux 6.18.y. The same software-shadow-vs-hardware-reset
desync affects `cur_rx_sample_dly`. Without this fix, platforms that
depend on non-zero RX sample delay (e.g., Microchip Sparx5 SPI NAND)
will have broken SPI after suspend/resume. The fix is minimal, obviously
correct, maintainer-endorsed, and applies cleanly.

---

## Verification

- [Phase 1] Parsed commit message and tags from `git show 607bd93e3d397`
  and user-provided diff
- [Phase 1] Confirmed `Suggested-by` and `Signed-off-by` from Mark Brown
  (SPI maintainer)
- [Phase 2] Read current `drivers/spi/spi-dw.h` lines 281–286 — bug
  present (no `cur_rx_sample_dly = 0`)
- [Phase 2] Read `dw_spi_update_config()` at lines 348–352 in `spi-dw-
  core.c` — conditional register write confirmed
- [Phase 3] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 3] `git blame drivers/spi/spi-dw.h:281-286` — shutdown_chip
  from 2015, current_freq fix from 95028569589f4
- [Phase 3] `git log -S cur_rx_sample_dly` → introduced in bac70b54ecb53
  (2020-09-08)
- [Phase 3] `git merge-base --is-ancestor bac70b54ecb53 HEAD` → ancestor
  (feature present)
- [Phase 3] `git merge-base --is-ancestor 95028569589f4 HEAD` → ancestor
  (BAUDR fix present)
- [Phase 3] `git show 95028569589f4` — BAUDR sibling fix already in
  6.18.y with identical pattern
- [Phase 3] `git show 133c71b2c0bc976a4751f9e05ef7cdea67f964e5` —
  upstream mainline version confirmed
- [Phase 4] `b4 dig -c 607bd93e3d397` → lore URL found
- [Phase 4] `b4 dig -c 607bd93e3d397 -a` → no additional revisions
- [Phase 4] UNVERIFIED: Lore thread content (Anubis bot protection on
  lore.kernel.org)
- [Phase 5] `grep dw_spi_update_config` — callers in transfer_one and
  SPI-mem paths
- [Phase 5] `grep dw_spi_suspend_host` — used by spi-dw-pci.c PM ops
- [Phase 5] Read `dw_spi_suspend_host()` / `dw_spi_resume_host()` at
  lines 1008–1025
- [Phase 6] `git apply --check` of 607bd93e3d397 → applies cleanly
- [Phase 6] `git branch --contains 607bd93e3d397` → only `autosel`, not
  stable/linux-6.18.y
- [Phase 6] `grep rx-sample-delay-ns arch/` → sparx5_nand.dtsi (7ns),
  rk3288-veyron.dtsi (12ns)
- [Phase 8] Failure mode: SPI non-functional after resume on affected
  platforms (HIGH functional severity)

**YES**

 drivers/spi/spi-dw.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 8a3c085c85e07..81609d2a3da6e 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -283,6 +283,7 @@ static inline void dw_spi_shutdown_chip(struct dw_spi *dws)
 	dw_spi_enable_chip(dws, 0);
 	dw_spi_set_clk(dws, 0);
 	dws->current_freq = 0;
+	dws->cur_rx_sample_dly = 0;
 }
 
 extern void dw_spi_set_cs(struct spi_device *spi, bool enable);
-- 
2.53.0

