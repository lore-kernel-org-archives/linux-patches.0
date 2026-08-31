Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877FE4503E0;
	Mon, 31 Aug 2026 13:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183739; cv=none; b=oVsRzYVZhMRDO8FeV1c0yWVBeRHcEpdNXpFi0AtSFpmpUsndXE/qn9kcN3foxPahtV9ByV85Y0kXDT5MZ1bk1ybhUxNL7VW9lTGdDQLlCgPv4MNCf9Q5NyjD7byFtA7c/EKn5BVwqWLMPk9PTgEQfHRZKX8RYsoXypVBt8AMtqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183739; c=relaxed/simple;
	bh=gJkgKkIlKjHv7i8UbIL0fSwWesp+q8aGft91VxdSjmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=izzkmdG9MScuiy/eZjS3Daut8PrrLIvyFpdr5LiFZzYRnroxHGHOyS+OYNwrVnmjvurvtD3+yLUjkfx4Qlrwg5v6hA/oyiDaTteSBhqdUqliibwL1yxzxzIE3MnX6i0xBjup8VgqBJy9mP13MlDISdbAuwadlsDb+irn07I0Z0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiBhIK1D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiBhIK1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7B51F00A3D;
	Mon, 31 Aug 2026 13:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183736;
	bh=xtMewim9srNYaEbaRlQ0rwAMxDKSDk1DOz8Kl9xTsgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiBhIK1DLKJLUcKUTMp63twAkFnHETd3uWOtsLH8S+1WEH+jSU0Fu8fDTHLLOh7Kv
	 cZtGdxsBWU+dp7DY9T31R7ZApsQia7vVQqHoxXtBz74ojCT11pWUFH8PZw4lzkRcTW
	 sjzjVAhIG7J1B1slH1r9/FTSzH2zA6khCKcXGWNpJU7MDsYAFOjz/JEYe2HbD+o9cp
	 7QlSuIIi9g/m0yt1Iex2RFTe92crUEJXcd28JQttzQhqm/kEVCeqacbKnQUtqcLjuK
	 c30MO4XpseuT43wPMUH9O5mBw6a9IeGd6RLwDnEJ+X/nrvwuT6DxgMnoDbgFlaCBRP
	 K/AEzjZNAA9fg==
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
Subject: [PATCH AUTOSEL 6.18-5.15] net: dsa: mv88e6xxx: define .pot_clear() for 6321
Date: Mon, 31 Aug 2026 09:25:01 -0400
Message-ID: <20260831133314.4125787-273-sashal@kernel.org>
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

[ Upstream commit 17826d9708a57d27011d0a6efdebb628d6f8299a ]

Commit 9e907d739cc3 ("net: dsa: mv88e6xxx: add POT operation") did not
add the .pot_clear() method to the 6321 switch operations structure.
Add them now.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260504153227.1390546-4-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[net: dsa: mv88e6xxx] [define] [add missing .pot_clear()
callback for MV88E6321 switch ops]`

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Marek Behún <kabel@kernel.org>` (author)
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` (net maintainer
  merge)
- `Link:
  https://patch.msgid.link/20260504153227.1390546-4-kabel@kernel.org`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: patch 3/5 in Marek Behún’s “Fixes for mv88e6xxx for 6320/6321
family” series. An earlier March 2025 submission to `net` (stable path)
included `Fixes: 9e907d739cc3` for the same change.

**Step 1.3 — Body analysis**
Record:
- Bug: commit `9e907d739cc3` (“add POT operation”) added `pot_clear` to
  most switch ops tables but omitted `mv88e6321_ops`.
- Symptom: Priority Override Table (POT) is not cleared during chip
  setup on MV88E6321.
- Root cause: missing `.pot_clear = mv88e6xxx_g2_pot_clear` in
  `mv88e6321_ops`.
- No crash report, no user bug report in the message.

**Step 1.4 — Hidden bug fix?**
Record: Yes. Despite the simple “add them now” wording, this is a real
driver initialization bug, not style cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- 1 file: `drivers/net/dsa/mv88e6xxx/chip.c`
- +1 line, -0 lines
- Modified structure: `mv88e6321_ops`
- Scope: single-file, surgical one-liner

**Step 2.2 — Code flow change**
Record:
- Before: `mv88e6xxx_pot_setup()` called from `mv88e6xxx_setup()` finds
  `chip->info->ops->pot_clear == NULL` for 6321 and returns 0 without
  doing anything.
- After: `mv88e6xxx_g2_pot_clear()` runs, zeroing all 16 Global2
  Priority Override Table entries.
- Affected path: switch probe/setup initialization (normal path, every
  boot).

**Step 2.3 — Bug mechanism**
Record:
- Category: logic/correctness — missing hardware initialization callback
- Mechanism: `mv88e6xxx_pot_setup()` only acts when `ops->pot_clear` is
  non-NULL; 6321 was the sole omission among G2-family peers.

**Step 2.4 — Fix quality**
Record:
- Obviously correct: identical to `mv88e6320_ops` and 20+ other chips in
  the same file.
- Minimal, no unrelated changes.
- Regression risk: very low; only adds init behavior already used
  everywhere else in the family.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record:
- `mv88e6321_ops` area currently attributed to base merge
  `5d324e5159d9e` (shallow tree limits deeper blame).
- In `9e907d739cc3` (2017-07-18): `mv88e6320_ops` got `.pot_clear`,
  `mv88e6321_ops` did not — omission present since POT support was
  introduced.

**Step 3.2 — Fixes: tag**
Record: Not applicable in this commit. Referenced commit `9e907d739cc3`
exists as a git object; POT infrastructure (`mv88e6xxx_pot_setup`,
`mv88e6xxx_g2_pot_clear`) is present in this tree.

**Step 3.3 — Related changes**
Record:
- Same fix appeared in Marek Behún’s March 2025 `[PATCH net 07/13]`
  series (with `Fixes:` tag); that series does not appear merged.
- May 2026 `[PATCH net-next 3/5]` series reapplied it to net-next;
  applied as `17826d9708a5` per lore.
- Standalone one-liner; no series dependencies.

**Step 3.4 — Author context**
Record: Marek Behún is an active mv88e6xxx contributor; series CC’d
Rad/Ericsson contacts (`lev_o@rad.com`), indicating production hardware
use of 6320/6321 family.

**Step 3.5 — Prerequisites**
Record: No prerequisites. `mv88e6xxx_g2_pot_clear()` and
`mv88e6xxx_pot_setup()` already exist in this tree.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
Record:
- Series cover: `https://lore.kernel.org/netdev/20260504153227.1390546-
  1-kabel@kernel.org`
- Patch 3/5: `https://lore.kernel.org/netdev/20260504153227.1390546-4-
  kabel@kernel.org`
- Applied to net-next by Jakub Kicinski (patchwork notification,
  2026-05-06).
- No explicit stable nomination found in thread.

**Step 4.2 — Reviewers**
Record: CC’d Andrew Lunn, Vladimir Oltean, Russell King, Vivien Didelot,
Tobias Waldekranz, netdev list.

**Step 4.3 — Bug reports**
Record: None. No syzbot, no user crash report. Author-driven correctness
fix for supported hardware.

**Step 4.4 — Related patches**
Record: Part of 5-patch 6320/6321 family series (interrupt count,
SPEED_200, pot_clear, rmu_disable, devlink ATU hash). This patch is
independent.

**Step 4.5 — Stable list history**
Record: No stable-list discussion found. Earlier March 2025 `net`
submission included `Fixes:` tag, suggesting stable intent, but no `Cc:
stable` found.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `mv88e6xxx_pot_setup()`, `mv88e6xxx_g2_pot_clear()`,
`mv88e6xxx_setup()`, `mv88e6321_ops` (static const).

**Step 5.2 — Callers**
Record:
- `mv88e6xxx_setup()` (DSA `.setup` callback at line 7140) calls
  `mv88e6xxx_pot_setup()` at line 4047.
- `mv88e6xxx_setup()` runs during DSA switch registration/probe —
  standard device bring-up path.

**Step 5.3 — Callees**
Record: `mv88e6xxx_g2_pot_clear()` loops 16 times calling
`mv88e6xxx_g2_pot_write()` to zero Global2 POT entries
(`MV88E6XXX_G2_PRIO_OVERRIDE`).

**Step 5.4 — Reachability**
Record: Triggered on every MV88E6321 probe/boot when driver is built and
hardware is present. Not userspace-triggerable directly, but affects all
6321 deployments.

**Step 5.5 — Similar patterns**
Record: Every other comparable `mv88e6xxx_ops` structure in `chip.c`
defines `.pot_clear = mv88e6xxx_g2_pot_clear` except `mv88e6321_ops`.
`mv88e6320_ops` (same `MV88E6XXX_FAMILY_6320`) has it at line 5178.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.43)

**Step 6.1 — Buggy code present?**
Record: **Yes.** Local tree is `v6.18.43` (`VERSION=6`, `PATCHLEVEL=18`,
`SUBLEVEL=43`). `mv88e6321_ops` (lines 5192–5242) lacks `.pot_clear`;
`mv88e6320_ops` at line 5178 has it. MV88E6321 chip entry exists at
lines 6275–6300.

**Step 6.2 — Backport complications**
Record: Clean apply expected — single line insertion between
`.mgmt_rsvd2cpu` and `.hardware_reset_pre`, matching the upstream diff
exactly.

**Step 6.3 — Fix already present?**
Record: No. `git log --grep="define .pot_clear"` returns nothing. Bug
still present in this checkout.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**
Record: `drivers/net/dsa/mv88e6xxx` — network/DSA switch driver.
Criticality: **IMPORTANT** (peripheral driver, but networking
correctness on embedded/telecom switches).

**Step 7.2 — Activity**
Record: Driver is mature and actively maintained; recent 6320/6321
family fix series indicates ongoing production use.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: Users of Marvell 88E6321 DSA switches only
(embedded/telecom/automotive Ethernet). Config-dependent on
`CONFIG_NET_DSA_MV88E6XXX`.

**Step 8.2 — Trigger conditions**
Record: Every driver probe of an 88E6321 device. Deterministic, not a
race. Unprivileged users cannot trigger directly.

**Step 8.3 — Failure mode severity**
Record: Stale Priority Override Table entries may cause incorrect packet
priority/QoS behavior. **Severity: MEDIUM** — functional networking
misbehavior, not kernel crash, oops, deadlock, or memory corruption.
Per-port `port_disable_pri_override` still runs during port setup, but
that is a separate per-port register, not the Global2 POT table.

**Step 8.4 — Risk/benefit**
Record:
- Benefit: **MEDIUM** — restores intended hardware init parity with 6320
  and all other supported chips; relevant for production 6321
  deployments.
- Risk: **VERY LOW** — one-line addition of existing callback.
- Ratio: favorable, but severity of the underlying bug is not critical.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Verified real bug: sole chip variant missing `pot_clear` since 2017.
- Bug exists in v6.18.43 tree; fix applies cleanly.
- One-line, obviously correct, zero API change.
- Called on every 6321 probe; ensures POT table is zeroed as intended.
- Sibling `mv88e6320_ops` and all other G2 chips already do this.
- Author previously submitted same fix to `net` (stable path) with
  `Fixes:` tag.
- Production hardware context (Rad/Ericsson).

**Evidence AGAINST backport:**
- No crash, security issue, deadlock, or data corruption.
- No user bug reports or syzbot findings.
- Bug present ~9 years without urgent reports — suggests limited
  practical impact (POT may often be zero after reset).
- Does not strictly meet “important issue” examples in stable-kernel-
  rules.rst.
- Narrow hardware population.

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — trivial, mirrors identical
   chips; no Tested-by but logically sound.
2. Fixes a real bug affecting users? **PASS** — real init omission on
   supported hardware.
3. Important issue? **BORDERLINE/FAIL** — QoS/priority init correctness,
   not crash/corruption/security.
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features/APIs? **PASS**.
6. Can apply to local tree? **PASS** — verified present and applicable.

**Exception category:** Hardware initialization completeness fix for
existing supported device (analogous to quirk/workaround category).

---

## Problem Summary

When an MV88E6321 switch is probed, `mv88e6xxx_pot_setup()` silently
skips clearing the Global2 Priority Override Table because
`mv88e6321_ops` lacks the `pot_clear` callback. Every other comparable
chip in the driver, including the closely related MV88E6320, performs
this clear. The result can be stale priority-override entries and
incorrect QoS behavior on 88E6321 hardware. This is not a kernel crash,
but it is a genuine driver initialization defect on supported hardware
in the v6.18.43 tree.

The fix is a single line adding `.pot_clear = mv88e6xxx_g2_pot_clear` to
`mv88e6321_ops`, matching the established pattern. Risk is negligible;
benefit is restoring correct init for 6321 users on this stable tree.

---

## Verification

- [Phase 1] Parsed commit message and tags; no Reported-by/syzbot; Link
  to lore series confirmed.
- [Phase 2] Diff: +1 line in `mv88e6321_ops`, adds `.pot_clear =
  mv88e6xxx_g2_pot_clear`.
- [Phase 3] `git show 9e907d739cc3`: confirmed 6320 got `pot_clear`,
  6321 did not in 2017.
- [Phase 3] `mv88e6xxx_pot_setup` and `mv88e6xxx_g2_pot_clear` verified
  present in tree.
- [Phase 4] Fetched lore mbox via curl: series 3/5, applied to net-next;
  March 2025 net series had same fix with `Fixes:` tag.
- [Phase 5] `mv88e6xxx_setup()` → `mv88e6xxx_pot_setup()` call chain
  verified at lines 3953/4047.
- [Phase 5] `mv88e6xxx_g2_pot_clear()` clears 16 POT entries in
  `global2.c:324-336`.
- [Phase 6] `git describe HEAD`: v6.18.43; buggy code confirmed missing
  `pot_clear` in `mv88e6321_ops`.
- [Phase 6] `mv88e6320_ops` at line 5178 has `pot_clear`;
  `mv88e6321_ops` at 5192–5242 does not.
- [Phase 8] Failure mode: incorrect QoS/priority, severity MEDIUM (not
  crash).
- [Phase 4] b4 dig on `9e907d739cc3`: found 2017 original POT thread
  (used curl for May 2026 series due to lore bot protection on
  WebFetch).

**YES**Two background git history searches failed (they timed out on
this shallow tree), but that didn’t block the analysis.

I already had what we needed from direct code inspection, `git show
9e907d739cc3`, grep, and the lore mbox fetch. The conclusion stands:
**YES** for v6.18.43 — `mv88e6321_ops` is the only comparable chip
missing `.pot_clear`, and the one-line fix restores correct Priority
Override Table initialization on probe.

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index b115575f157fe..f324b88450427 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5228,6 +5228,7 @@ static const struct mv88e6xxx_ops mv88e6321_ops = {
 	.set_egress_port = mv88e6095_g1_set_egress_port,
 	.watchdog_ops = &mv88e6390_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6352_g2_mgmt_rsvd2cpu,
+	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.hardware_reset_pre = mv88e6xxx_g2_eeprom_wait,
 	.hardware_reset_post = mv88e6xxx_g2_eeprom_wait,
 	.reset = mv88e6352_g1_reset,
-- 
2.53.0

