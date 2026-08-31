Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D16476CFC;
	Mon, 31 Aug 2026 13:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184384; cv=none; b=RiJWTsrqswPGQowMGWYt6gYbtblMaH/6HS/3az72+A50ttVOSzeaBC2VIzZATLg+bQglkusbaPmwmCwGh3Ra8g5vS96wJJyavKX6/cglYG3SFwM5laVM2na2hDSbDaVS+YVQULk7rbufKKM21mkQpuJwBjVTlsdzLvFWdkwVs90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184384; c=relaxed/simple;
	bh=iGsyk2xkd5IdhFlzaDksZSvBVs/rG6Q3mYhjfxXwobM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OY6Z/Triuix8V7waGH9mn7W9qDkeVHLnVQBxX5iC/nHz80nggnOdjEgtaugq4jy25avgFC1npsuQFvwtsJEdJnmqVyKqpLpJZBIF0wtMpJnV0aK7v3l6TT6B++bj3uXUuL2586Dy55ROjZCffmKNEM2j1jCQv7Exa/OOzMKFkiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4fPT2G0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4fPT2G0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10D41F00ADF;
	Mon, 31 Aug 2026 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184382;
	bh=BNoiXg/D8F/gdUJJr2kFK4p66LUE2tpkUiRHnFizDzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P4fPT2G0NnPVXycXykRYy5Lq42WSVCV9SmCjgTA5e/+Xj8sfckEHgIXkMSX8qOz4b
	 V+OSMNQllQYT2jG1udvHoBP7mFV+eevnY6LFREbbDS1BAvy+L7gVSOTI0d2OiMmrjx
	 bMx4v3UrbQ4eU9CA3plv7ScIHIeHHPjjPYQU89JsyZg6M/5K9vl/54k5LkHZ53skbP
	 oz/7eRFWRnewFk6t4OJow4A6JCTk122DBb2Cf907qFkQvc9bcggL6TTdc4gbXP2B9W
	 Zn/948gfhtREYQz3Bu1ZQF8SxgC/8ECQ4sbINC4rmUC2nKY+mGQgnA6IM6zCAbYPJL
	 8gohU+weOujUA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@lunn.ch,
	olteanv@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: dsa: mv88e6xxx: fix number of g1 interrupts for 6320 family
Date: Mon, 31 Aug 2026 09:31:28 -0400
Message-ID: <20260831133314.4125787-660-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Marek Behún <kabel@kernel.org>

[ Upstream commit d201c2612e5aada0c931cd55115175e0a5141023 ]

The 6320 family has 9 global1 interrupt, not 8. Fix it.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-2-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[net: dsa: mv88e6xxx]` `[fix]` — correct the number of
  global1 (g1) interrupts for the 6320 switch family.

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Marek Behún <kabel@kernel.org>` — author
  - `Link:
    https://patch.msgid.link/20260504153227.1390546-2-kabel@kernel.org`
    — patch submission
  - `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` — netdev
    maintainer merge
  - No `Fixes:`, `Reported-by:`, `Cc: stable`, `Tested-by:`, or
    `Reviewed-by:` in the commit under review
  - The March 2025 `[PATCH net 03/13]` version on netdev included
    `Fixes: dc30c35be720 ("net: dsa: mv88e6xxx: Implement interrupt
    support.")`

**Step 1.3 — Body**
- Record: The 6320 family has 9 global1 interrupts, not 8. Symptom: with
  `g1_irqs = 8`, the driver only sets up and dispatches IRQs 0–7;
  hardware IRQ 8 (`MV88E6XXX_G1_STS_IRQ_AVB`) is never mapped or
  handled. No explicit crash report in the message; the failure mode is
  incorrect interrupt handling on 6320/6321 hardware.

**Step 1.4 — Hidden bug fix?**
- Record: No — this is an explicit, straightforward hardware-parameter
  correction, not disguised cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
- Record: 1 file changed (`drivers/net/dsa/mv88e6xxx/chip.c`), 2 lines
  modified (+2/−2). Functions affected: none directly — only the
  `mv88e6xxx_table[]` static data for `[MV88E6320]` and `[MV88E6321]`.
  Scope: single-file, surgical constant fix.

**Step 2.2 — Code flow change**
- Record:
  - **Before:** `g1_irqs = 8` → `chip->g1_irq.nirqs = 8` in
    `mv88e6xxx_g1_irq_setup_common()`, creating 8 IRQ mappings (0–7).
  - **After:** `g1_irqs = 9` → 9 IRQ mappings (0–8), covering all
    global1 interrupt sources including AVB at bit 8.
  - Affected path: probe-time G1 IRQ domain setup and all subsequent G1
    interrupt dispatch/masking for 6320/6321 when `chip->irq > 0`.

**Step 2.3 — Bug mechanism**
- Record: **Logic / hardware correctness bug.** `g1_irqs` drives:
  1. IRQ domain size and mapping creation (lines 299–307)
  2. Mask register manipulation via `GENMASK(chip->g1_irq.nirqs, 0)`
     (lines 316, 330, etc.)
  3. IRQ dispatch loop `for (n = 0; n < chip->g1_irq.nirqs; ++n)` (line
     176)

  With `nirqs = 8`, bit 8 (`MV88E6XXX_G1_STS_IRQ_AVB`, defined in
`global1.h`) is included in mask operations (`GENMASK(8,0)` covers bits
0–8) but excluded from the dispatch loop (only 0–7). If bit 8 asserts,
the handler loop in `mv88e6xxx_g1_irq_thread_work()` can spin
indefinitely (`do { ... } while (reg & ctl1)`) without ever clearing bit
8 — a stuck-interrupt / high-CPU condition.

**Step 2.4 — Fix quality**
- Record: Obviously correct — a single constant correction per chip
  entry, matching the hardware spec and consistent with similar chips
  (e.g. MV88E6341 uses `g1_irqs = 9`). Minimal regression risk; only
  expands the IRQ domain by one entry.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: Current `g1_irqs = 8` for MV88E6320/MV88E6321 is present in
  this tree at lines 6264 and 6292. Git blame attributes these lines to
  merge commit `5d324e5159d9e` (shallow stable tree history limits
  deeper blame).

**Step 3.2 — Fixes tag**
- Record: The March 2025 netdev version references `Fixes: dc30c35be720`
  ("net: dsa: mv88e6xxx: Implement interrupt support.", Oct 2016). That
  commit exists in this tree and introduced the G1 IRQ framework. The
  wrong value for 6320/6321 was set when those chip entries were added
  to `mv88e6xxx_table[]` (copied from older 8-interrupt chips like
  6085/6097).

**Step 3.3 — Related changes**
- Record: Part of Marek Behún's "Fixes for mv88e6xxx (mainly 6320
  family)" series — 13 patches in March 2025 `[PATCH net]`, 5 patches in
  May 2026 `[PATCH net-next]`. This specific patch is standalone (2
  constant changes, no code dependencies on sibling patches).

**Step 3.4 — Author context**
- Record: Marek Behún is an active mv88e6xxx contributor; the series was
  sent to DSA/mv88e6xxx maintainers (Andrew Lunn, Vladimir Oltean,
  netdev list). No author-specific history available in this shallow
  tree.

**Step 3.5 — Dependencies**
- Record: No prerequisites. Self-contained; applies directly to existing
  `mv88e6xxx_table[]` entries.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record: Found via openwall netdev archives:
  - Cover: https://lists.openwall.net/netdev/2026/05/04/232 (`[PATCH
    net-next 0/5] Fixes for mv88e6xxx for 6320/6321 family`)
  - Patch: https://lists.openwall.net/netdev/2026/05/04/231 (`[PATCH
    net-next 1/5]`)
  - Earlier net version:
    https://lists.openwall.net/netdev/2025/03/13/157 (`[PATCH net
    03/13]`)
  - `b4 dig` did not match by commit hash (commit not in local tree);
    lore fetch via patch.msgid.link was blocked by bot protection.

**Step 4.2 — Reviewers**
- Record: CC'd to Andrew Lunn, Vladimir Oltean, Russell King, Vivien
  Didelot, Tobias Waldekranz, netdev@, Fidan Aliyeva (Ericsson). Merged
  by Jakub Kicinski. No explicit stable nomination found in cover
  letters; Andrew Lunn requested Fixes tags be omitted for the net-next
  resubmission.

**Step 4.3 — Bug reports**
- Record: No `Reported-by:` or syzbot/bugzilla links. Bug identified by
  driver maintainer/developer based on hardware documentation and
  comparison with sibling chips.

**Step 4.4 — Series context**
- Record: One of 5 (net-next) / 13 (net) fixes for 6320/6321 family.
  This patch is independently applicable.

**Step 4.5 — Stable list**
- Record: No stable@ discussion found. Not a negative signal per review
  guidelines.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: No functions modified. Data consumed by
  `mv88e6xxx_g1_irq_setup_common()`, `mv88e6xxx_g1_irq_thread_work()`,
  `mv88e6xxx_g1_irq_bus_sync_unlock()`,
  `mv88e6xxx_g1_irq_free_common()`.

**Step 5.2 — Callers**
- Record: `mv88e6xxx_g1_irq_setup()` called from chip probe when
  `chip->irq > 0` (line 7364). Sub-IRQs mapped from this domain are used
  by:
  - `mv88e6xxx_g1_atu_prob_irq_setup()` — ATU problem IRQ (bit 3)
  - `mv88e6xxx_g1_vtu_prob_irq_setup()` — VTU problem IRQ (bit 5)
  - `mv88e6xxx_g2_irq_setup()` — device IRQ (bit 7) for G2 interrupt
    controller

**Step 5.3 — Callees**
- Record: `irq_domain_create_simple()`, `irq_create_mapping()`,
  `irq_find_mapping()`, `handle_nested_irq()`,
  `mv88e6xxx_g1_read/write()` for G1 status/control registers.

**Step 5.4 — Reachability**
- Record: Triggered on probe of MV88E6320/6321 hardware with an IRQ line
  configured (device tree `interrupts` property or platform data).
  Common on embedded DSA switch boards. Not reachable from arbitrary
  userspace syscalls, but affects system stability on affected hardware
  during normal network operation (especially with PTP/AVB — 6320 ops
  include `mv88e6352_avb_ops` and `mv88e6352_ptp_ops`).

**Step 5.5 — Similar patterns**
- Record: Chips with 9 G1 interrupts (e.g. MV88E6123, MV88E6341)
  correctly use `g1_irqs = 9`. Older 8-interrupt chips (6085, 6095,
  6097) correctly use `g1_irqs = 8`. The 6320/6321 entries are
  inconsistent with their sibling 6341 and their own `ptp_support =
  true` capability.

---

## Phase 6: Cross-Referencing Against Local Tree

**Step 6.1 — Buggy code present?**
- Record: **YES.** Local tree is **v6.18.43** (`git describe HEAD` →
  `v6.18.43-1-gc7f0dac02d232`). MV88E6320 and MV88E6321 entries exist
  with `g1_irqs = 8` at lines 6264 and 6292. Bug is present.

**Step 6.2 — Backport complications**
- Record: Trivial clean apply — two identical constant changes. No
  refactoring conflicts expected.

**Step 6.3 — Related fixes already present?**
- Record: No existing fix for this issue found in the tree. The buggy
  values remain.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
- Record: `drivers/net/dsa/mv88e6xxx` — DSA switch driver for Marvell
  88E6xxx Ethernet switches. Criticality: **IMPORTANT** (networking
  driver for embedded/industrial switch hardware, not core kernel).

**Step 7.2 — Activity**
- Record: Active development; 6320/6321 family received a dedicated fix
  series in 2025–2026 indicating real hardware deployment and ongoing
  driver maturation.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users of MV88E6320 or MV88E6321 Marvell DSA switches running
  with hardware IRQ mode (`CONFIG_NET_DSA_MV88E6XXX` + IRQ line in DT).
  Embedded, automotive, and industrial networking platforms.

**Step 8.2 — Trigger conditions**
- Record: Any assertion of G1 interrupt bit 8 (AVB). More likely when
  PTP/AVB features are active (both chips have `ptp_support = true` and
  use `mv88e6352_avb_ops`/`mv88e6352_ptp_ops`). Polling mode (`chip->irq
  <= 0`) is unaffected. Trigger is hardware-event-driven, not userspace-
  exploitable.

**Step 8.3 — Failure mode severity**
- Record: **HIGH** — unhandled IRQ bit 8 can cause the G1 IRQ thread to
  spin in the `do { ... } while (reg & ctl1)` loop, leading to sustained
  high CPU usage and degraded/stuck interrupt processing. Missed AVB/PTP
  interrupt events are also possible. Not a typical kernel oops, but a
  real stability issue on affected hardware.

**Step 8.4 — Risk-benefit**
- Record: Benefit **HIGH** for 6320/6321 users (correct interrupt
  handling, prevents potential IRQ storms). Risk **VERY LOW** (2-line
  constant fix, no API changes, no behavioral change for correctly-
  configured chips). Ratio strongly favors backport.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Real driver bug: wrong hardware interrupt count for 6320/6321
- Bug present in local v6.18.43 tree
- Can cause IRQ handler spin / system degradation when bit 8 fires
- 6320 family uses PTP/AVB ops, making IRQ 8 relevant
- Consistent with sibling chip MV88E6341 (`g1_irqs = 9`)
- Trivial 2-line fix, obviously correct
- Standalone, no dependencies
- Part of maintainer-reviewed 6320 fix series

**Evidence AGAINST backport:**
- Niche hardware (specific Marvell switch chips only)
- No user crash reports or syzbot findings
- Only affects IRQ mode, not polling mode
- Interrupt bit 8 may not fire on all deployments

**Unresolved questions:**
- Exact kernel version when MV88E6320 support was first added (git
  history too shallow in this stable checkout to determine via `git log
  -S`)
- Whether irq 8 has been observed firing in production (no reports in
  commit message)

Neither unresolved question affects the local-tree decision: the bug and
the fix both apply to this tree.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — constant correction matching
   hardware; merged to mainline by netdev maintainer.
2. Fixes a real bug affecting users? **PASS** — wrong IRQ count on real
   hardware.
3. Important issue? **PASS** — HIGH severity (potential IRQ storm /
   degraded networking on 6320/6321).
4. Small and contained? **PASS** — 2 lines, 1 file.
5. No new features or APIs? **PASS** — corrects existing interrupt
   setup.
6. Can apply to local tree? **PASS** — buggy code present, trivial
   apply.

**Exception category:** Hardware quirk/workaround — correcting a wrong
hardware parameter in the chip descriptor table.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Found earlier netdev version with `Fixes: dc30c35be720` at
  https://lists.openwall.net/netdev/2025/03/13/157
- [Phase 2] Diff analysis: 2 lines in `mv88e6xxx_table[]` for MV88E6320
  and MV88E6321, `g1_irqs` 8→9
- [Phase 2] Read `mv88e6xxx_g1_irq_setup_common()` (lines 294–327) and
  `mv88e6xxx_g1_irq_thread_work()` (lines 159–198)
- [Phase 2] Confirmed `GENMASK(nirqs, 0)` with nirqs=8 covers bit 8 but
  dispatch loop only handles 0–7
- [Phase 3] `git describe HEAD`: v6.18.43
- [Phase 3] `git blame` on lines 6264/6292: attributed to
  `5d324e5159d9e`
- [Phase 3] `git show dc30c35be720`: exists in tree (2016 interrupt
  support commit)
- [Phase 4] Web search + openwall: found series cover at
  https://lists.openwall.net/netdev/2026/05/04/232 and patch at
  https://lists.openwall.net/netdev/2026/05/04/231
- [Phase 4] `b4 dig -c HEAD`: no match (commit not in tree)
- [Phase 4] patch.msgid.link fetch: blocked by bot protection
- [Phase 5] `grep g1_irqs`: confirmed MV88E6341 uses 9, MV88E6320/6321
  use 8
- [Phase 5] `grep G1_STS_IRQ`: irq 8 = `MV88E6XXX_G1_STS_IRQ_AVB` in
  `global1.h`
- [Phase 5] Read probe path: `mv88e6xxx_g1_irq_setup()` at line 7364
  when `chip->irq > 0`
- [Phase 5] Confirmed `mv88e6320_ops` uses `mv88e6352_avb_ops` and
  `mv88e6352_ptp_ops`
- [Phase 6] Confirmed buggy `g1_irqs = 8` at lines 6264 and 6292 in
  local tree
- [Phase 6] MV88E6320 and MV88E6321 chip entries and full driver support
  present in tree
- [Phase 8] Assessed failure mode: potential IRQ handler spin on
  unhandled bit 8 — severity HIGH
- UNVERIFIED: Exact introduction commit for MV88E6320 support (shallow
  git history; `git log -S` too slow and killed)

**YES**The background `git log -S "MV88E6320"` searches all timed out or
were killed — this stable checkout has very shallow history (only 2
commits touching `chip.c`), so those commands weren't practical here.

That doesn't change the backport verdict: the buggy `g1_irqs = 8` values
are present in v6.18.43 for MV88E6320/6321, and the fix is a
straightforward 2-line correction. The exact commit that introduced 6320
support remains unverified, but it's not needed for the decision.

**YES**

 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 09002c853b78e..b115575f157fe 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -6261,7 +6261,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
 		.atu_move_port_mask = 0xf,
@@ -6289,7 +6289,7 @@ static const struct mv88e6xxx_info mv88e6xxx_table[] = {
 		.global1_addr = 0x1b,
 		.global2_addr = 0x1c,
 		.age_time_coeff = 15000,
-		.g1_irqs = 8,
+		.g1_irqs = 9,
 		.g2_irqs = 10,
 		.stats_type = STATS_TYPE_BANK0 | STATS_TYPE_BANK1,
 		.atu_move_port_mask = 0xf,
-- 
2.53.0

