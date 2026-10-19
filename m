Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7F66412A7;
	Mon, 19 Oct 2026 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418775; cv=none; b=ZEB3t/qb6gFkChNdL7Zzz4ZWFLZ0NKcDvxxUGegjuOR8uRhHEqd98BKzpcnCxEl5nK3zpLNXHFEt+OXgEHY+6NDBmip0CyIrv/WombLyFKJiNhJlUKlAE7fsXb6bSdM/G9mHwtUmNRlvpB107+qpL3VLw84cjbCeGL7LDNUyIJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418775; c=relaxed/simple;
	bh=9RZKm+LlYX2skDfvqazO2NeUcqxuRdWs+Q6Pu0ZJZDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tBmwqhE9hMOhxKgB5/LVmp67256bHr+YeBlVk6p2GVSDhq0WI27Tvm5QUODA/FykRZXY3W0aVtTNBiOWvY81OKFQB96ODBAEONjzA62BvirRqGd+FT42ysO9LhIp/mMA7lzlglT4DP4MsM3z6SZ3IM8qsfK3xrld/CRM5ojTZas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UxchbdT5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UxchbdT5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B337D1F000C5;
	Mon, 19 Oct 2026 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418772;
	bh=6fJnlo8O1pfL2oUAYxfdSQZxivBmSltwkVs8WY/T7Cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxchbdT5rJP/5EK6OENrna5wWBohXkCZIkYfQ+vWBXNDn3huR/XNjxB2ZbVXX339a
	 z7xk2BjruvOohdC3/Tney8S9soEWOQmBl0EU6ZlWlJJ+eDEeuHcMiY2+fZOgYzwern
	 Em9SLBgwFu6pJJCGshVxHbk9JfWYz35iMyFcUm9PvCNLHV0Q0fBeVOmoiEerlLM93r
	 vHOunXrAIdrIr8Pi7x18//Bd12MKDA1Yha1a3c5/x3vUrMxMrzVbZtSgJ5c4e4SIlR
	 d0Db6IwFFfaG9AomWS5wbdhQJOIelancEBHkX1ID2W/f4Iua00Vn9RSTpVIsM5dueL
	 fwzWcKhHLnBeA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arash Golgol <arash.golgol@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] regulator: fan53555: Add support for FAN53555BUC23X type
Date: Mon, 19 Oct 2026 09:52:56 -0400
Message-ID: <20261019135441.1420968-485-sashal@kernel.org>
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

From: Arash Golgol <arash.golgol@gmail.com>

[ Upstream commit e739acbe05b06de78ef7089470f122432f651faa ]

FAN53555BUC23X has the ID 0 and REV 0xc, starts at 600mV and
increments in 12.5mV steps.

Per the datasheet, the FAN53555BUC23X (23 option) is grouped with
the 00 and 13 options for soft-start timing (t_SS = 300us typ.),
so the existing enable_time = 400 is reused here as well.

This variant is found on the ASUS Tinker Edge R (RK3399Pro) as the
supply regulator for both vdd_gpu and vdd_cpu_b. Verified across
the full GPU OPP table with the userspace devfreq governor.

Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Link: https://patch.msgid.link/20260812125054.19111-1-arash.golgol@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1 — Subject**
- Record: `[regulator/fan53555] [Add] [support for FAN53555BUC23X chip
  revision]`

**Step 1.2 — Tags**
- Record:
  - `Signed-off-by: Arash Golgol <arash.golgol@gmail.com>` (author)
  - `Link: https://patch.msgid.link/20260812125054.19111-1-
    arash.golgol@gmail.com`
  - `Signed-off-by: Mark Brown <broonie@kernel.org>` (regulator
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
    by:`, or `Cc: stable` (absence is expected)
  - Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    ...]` if present

**Step 1.3 — Body**
- Record:
  - Bug / gap: FAN53555 option 23 (ID 0, REV 0xc) is not in the driver’s
    revision table, so probe fails.
  - Specs: 600 mV min, 12.5 mV steps; soft-start grouped with options
    00/13 (`t_SS` 300 µs typ.) so `enable_time = 400`.
  - Hardware: ASUS Tinker Edge R (RK3399Pro), `vdd_gpu` and `vdd_cpu_b`.
  - Symptom: regulator probe returns `-EINVAL` (“Chip ID %d with rev %d
    not supported”).
  - Author tested the full GPU OPP table with the userspace devfreq
    governor.

**Step 1.4 — Hidden bug fix?**
- Record: Not disguised cleanup. It is explicit hardware-variant
  support. Functionally it closes a probe-fail path for real silicon.
  The 2016 commit that added option 13 already stated that options 00,
  13, **and 23** share `DIE_ID` 0, so option 23 was a known missing ID.

---

## Phase 2: Diff analysis

**Step 2.1 — Inventory**
- Record: `drivers/regulator/fan53555.c` only; about +6 lines, 0
  removed.
- Functions: enum `FAN53555_CHIP_REV_*`;
  `fan53555_voltages_setup_fairchild()`.
- Scope: single-file surgical ID/table addition.

**Step 2.2 — Flow**
- Before: `chip_id == FAN53555_CHIP_ID_00` and `chip_rev == 0xc` fall
  into `default` and return `-EINVAL`. Probe logs “Failed to setup
  device!” and the regulator is not registered.
- After: that ID/REV sets `vsel_min = 600000`, `vsel_step = 12500`,
  `enable_time = 400`, then continues the existing Fairchild setup
  (`slew_*`, `vsel_count = FAN53555_NVOLTAGES` (64)).
- Path: I2C probe / device setup only. Other ID/REV combinations
  unchanged.

**Step 2.3 — Bug mechanism**
- Record: **Hardware workaround / device ID addition** (chip revision
  table). Same class as PCI/USB ID adds: existing driver, new ID/params
  so the silicon enumerates.
- Without it this is a **logic / missing-ID** failure, not
  UAF/leak/race.

**Step 2.4 — Fix quality**
- Record: Matches the 00/13 cases; values match the commit text and
  typical FAN53555 option-23 programming (64 × 12.5 mV from 600 mV →
  1.3875 V). `vsel_count` stays 64 after the switch, which is correct.
  Isolated `switch` arm; no API, lock, or struct change. Regression risk
  is limited to mis-identified ID 0 / REV 0xc parts; those currently
  fail probe anyway. Wrong tables are not applied to working chips.

---

## Phase 3: Git history

**Step 3.1 — Blame**
- Record: Revision split introduced in `e57cbb70b7b377` (Wadim Egorov,
  2016-04-20): “IC type options 00, 13 and **23** are sharing the same
  DIE_ID 0.” Only 00 (`REV 0x3`) and 13 (`REV 0xf`) were added; 23 was
  documented and then omitted. `fan53555_voltages_setup_fairchild()`
  dates to `ee30928ab61678` (2014). `enable_time` lines come from
  `3d546c8b107003` (already in this 6.12 tree).

**Step 3.2 — Fixes: tag**
- Record: None. Introducer is the 2016 13X patch, which is in this tree
  (`git merge-base --is-ancestor e57cbb70b7b377 HEAD` succeeded).

**Step 3.3 — File history**
- Record: Recent local commits include enable_time, probe cleanup,
  RK860X, FAN53526, BUC18X, UC13X. No prerequisite refactor beyond
  enable_time, which is already here. Standalone; not “patch X/Y”.

**Step 3.4 — Author**
- Record: Arash Golgol has no other commits on `drivers/regulator/` in
  this tree. Applied by Mark Brown (regulator maintainer).

**Step 3.5 — Dependencies**
- Record: Needs the existing Fairchild ID/REV switch and `enable_time`
  field. Both are in 6.12.111. Applies as a 6-line add. No new helpers.

---

## Phase 4: Mailing list / external

**Step 4.1 — Original discussion**
- Record: `b4 dig -c e739acbe05b0` →
  https://patch.msgid.link/20260812125054.19111-1-arash.golgol@gmail.com
- `b4 dig -a`: single v1, no v2/v3.
- Thread: 2 messages (patch + maintainer apply). No NAK, no review nits,
  no `Cc: stable` request.
- Mark Brown applied to `regulator.git for-7.3` (merge-window queue, not
  a -fixes pull). That is process classification, not a NAK of the
  change.

**Step 4.2 — Recipients (`b4 dig -w`)**
- Record: Arash Golgol; linux-kernel@vger.kernel.org; Liam Girdwood
  (`lgirdwood@gmail.com`); Mark Brown (`broonie@kernel.org`). Both
  regulator maintainers were on Cc.

**Step 4.3 — Bug report**
- Record: No syzbot/bugzilla. User report is the commit body (Tinker
  Edge R, GPU OPP verification).

**Step 4.4 — Series**
- Record: Standalone 1/1. No companion DT commit in this series.

**Step 4.5 — Stable list**
- Record: lore.kernel.org/stable search via WebFetch returned 403. `b4`
  thread has no stable discussion. UNVERIFIED: whether anyone already
  asked for this on stable@.

---

## Phase 5: Semantic / call graph

**Step 5.1 — Functions**
- Record: `fan53555_voltages_setup_fairchild()`; enum
  `FAN53555_CHIP_REV_23`.

**Step 5.2 — Callers**
- Record: Only `fan53555_device_setup()` when `vendor ==
  FAN53555_VENDOR_FAIRCHILD` (OF compatible `fcs,fan53555` / I2C id
  `fan53555`).
- Call chain: `fan53555_regulator_probe()` (I2C `.probe`) → read ID1/ID2
  → `fan53555_device_setup()` → `fan53555_voltages_setup_fairchild()`.
- Context: boot/probe, not IRQ/hot path.

**Step 5.3 — Callees**
- Record: Only field assignment; no alloc/lock/I/O in the new arm.

**Step 5.4 — Reachability**
- Record: Yes, from device enumeration when `CONFIG_REGULATOR_FAN53555`
  is set and a Fairchild FAN53555 is on I2C. Userspace then uses the
  regulator via OPP/devfreq/cpufreq. Unprivileged users do not trigger
  probe; boot/firmware does.

**Step 5.5 — Similar patterns**
- Record: Same driver already has `FAN53555_CHIP_REV_00` / `_13`, plus
  BUC18X (`DIE_ID` 8). In-tree DTs using `fcs,fan53555` include several
  RK3399/RK356x/i.MX8 boards. Runtime ID/REV decides the table; any of
  those with BUC23X silicon currently fail probe.

---

## Phase 6: This tree (6.12.111 / `pending-6.12`)

**Step 6.1 — Buggy code present?**
- Record: Yes. `drivers/regulator/fan53555.c` has ID 0 + REV 00/13 only;
  REV 0xc hits `default` → `-EINVAL`. Introduced conceptually in 2016
  when 00/13 were split and 23 was left out. Candidate SHA
  `e739acbe05b0` is **not** an ancestor of HEAD.

**Step 6.2 — Backport difficulty**
- Record: **Clean apply.** Context (enum + `enable_time = 400` on
  REV_13) matches the submitted diff. `3d546c8b107003` (enable_time) is
  already in this tree.

**Step 6.3 — Related fixes already here?**
- Record: No BUC23 / `CHIP_REV_23` commit. UC13X and BUC18X are present;
  they do not cover REV 0xc.

- Note: No in-tree DT for “ASUS Tinker Edge R” (`tinker-edge` grep
  empty). That does not remove the ID gap: identification is from I2C
  DIE_ID/DIE_REV, and out-of-tree/custom DTs plus any in-tree
  `fcs,fan53555` board with this silicon still hit the failure.

---

## Phase 7: Subsystem context

**Step 7.1**
- Record: `drivers/regulator/` — voltage regulator for CPU/GPU rails.
  **IMPORTANT** (common PMIC-class driver; not mm/core). Failure on
  CPU/GPU supplies is board-visible (no DVFS / probe error), not a core-
  kernel oops.

**Step 7.2**
- Record: Mature driver (2012+), occasional ID/clone additions. Not a
  newly added subsystem.

---

## Phase 8: Impact and risk

**Step 8.1 — Who is affected**
- Record: Driver/config-specific: `CONFIG_REGULATOR_FAN53555` and
  FAN53555 option 23 (ID 0, REV 0xc). Confirmed board: ASUS Tinker Edge
  R. Other `fcs,fan53555` boards only if they have that silicon.

**Step 8.2 — Trigger**
- Record: Every probe of that part. Not a race. Not unprivileged-
  triggerable.

**Step 8.3 — Failure mode**
- Record: Probe fails (`-EINVAL`); `vdd_gpu` / `vdd_cpu_b` never
  register. DVFS/OPP is wrong or unavailable; not a generic panic.
  Severity **MEDIUM** as a crash class, **HIGH** as “this board’s
  CPU/GPU regulator does not work.”

**Step 8.4 — Risk/benefit**
- Benefit: Enables existing driver on real hardware; fills a gap called
  out since 2016.
- Risk: Very low (6 lines, new `switch` arm only).
- Ratio: favorable for a device-ID-class change.

---

## Phase 9: Synthesis

**Step 9.1 — Evidence**

For:
- Existing driver; only a chip-rev ID and voltage/soft-start constants.
- Matches the documented stable exception for new device IDs.
- Without it, option-23 parts fail probe; CPU/GPU supplies on Tinker
  Edge R do not register.
- 2016 UC13X commit already named option 23 as sharing DIE_ID 0.
- 6 lines, obviously correct, hardware-tested, maintainer-applied.
- Applies cleanly to this 6.12 tree (`enable_time` already present).
- No behavior change for other IDs.

Against:
- New variant support, not a UAF/crash/corruption fix for already-
  supported chips.
- Maintainer queued it for the 7.3 merge window, not as a -fixes patch.
- Tinker Edge R DT is not in this tree.
- Niche part; no syzbot / multi-user reports.

Unresolved:
- UNVERIFIED: stable@ discussion (lore stable WebFetch 403).
- UNVERIFIED: how many in-tree 6.12 boards actually ship BUC23X silicon.

**Step 9.2 — Stable rules**
1. Obviously correct and tested? **PASS** — linear table like 00/13;
   author verified GPU OPPs; Mark Brown applied.
2. Real bug affecting users? **PASS** — probe `-EINVAL` on real
   option-23 parts.
3. Important? **PASS** under the device-ID exception (CPU/GPU regulator
   otherwise missing). Not a generic panic.
4. Small/contained? **PASS** — 6 lines, one file.
5. No new features/APIs? **PASS** as ID-table enablement of an existing
   driver (no new uAPI, sysfs, or driver).
6. Applies to this tree? **PASS** — code and `enable_time` context are
   here; candidate is not yet an ancestor.

**Step 9.3 — Exception**
- Record: **New device ID / chip-revision table entry on an existing
  driver.**

**Step 9.4 — Decision**
This is the same kind of change as adding a PCI/USB ID: the driver is
already in 6.12; only the missing DIE_REV 0xc parameters are added.
Leaving it out keeps CPU/GPU regulators broken on that silicon. Risk is
negligible.

---

## What the commit solves for 6.12 users

On FAN53555 option 23 (ID 0, REV 0xc),
`fan53555_voltages_setup_fairchild()` currently errors out, so I2C probe
fails and the regulator is never registered. That is the GPU and little-
core CPU supply on the ASUS Tinker Edge R. The patch adds the datasheet
min/step/enable_time so those rails work. It is not a new driver or ABI.

Risk vs benefit: 6 isolated lines vs unusable CPU/GPU DVFS on that
hardware. No change for other revisions.

Concerns: no in-tree Tinker Edge R DT; maintainer treated it as merge-
window material. Neither blocks a device-ID backport. No extra commits
required.

---

## Verification
- [Phase 1] Parsed subject/body/tags from the candidate message; no
  Fixes/Reported-by/Cc:stable.
- [Phase 2] Diff: +6 lines in `fan53555.c` (enum + `case
  FAN53555_CHIP_REV_23`); confirmed against local file around lines
  113–116 and 292–313.
- [Phase 3] `git blame` / `git show e57cbb70b7b377`: 2016 UC13X commit
  documents options 00, 13, and 23 sharing DIE_ID 0; only 00/13
  implemented.
- [Phase 3] `git merge-base --is-ancestor e57cbb70b7b377 HEAD`: yes.
  `e739acbe05b0` vs HEAD: not an ancestor.
- [Phase 3] `3d546c8b107003` (enable_time) is in this tree; patch
  context matches.
- [Phase 4] `b4 dig -c e739acbe05b0`: lore URL
  `20260812125054.19111-1-arash.golgol@gmail.com`; v1 only; To/Cc Liam
  Girdwood + Mark Brown.
- [Phase 4] Mbox: apply mail only; no NAK. Mark Brown: applied to
  `for-7.3`.
- [Phase 4] UNVERIFIED: stable@ archive (HTTP 403).
- [Phase 5] Callers: only `fan53555_device_setup()` ←
  `fan53555_regulator_probe()`.
- [Phase 6] `git describe HEAD` / Makefile: **6.12.111**
  (`pending-6.12`). Buggy default arm present. No Tinker Edge R DT.
- [Phase 8] Failure: probe `-EINVAL`, regulator absent; not a kernel
  oops.

**YES**

 drivers/regulator/fan53555.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index c282236959b18..59155cad99bc6 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -113,6 +113,7 @@ enum {
 enum {
 	FAN53555_CHIP_REV_00 = 0x3,
 	FAN53555_CHIP_REV_13 = 0xf,
+	FAN53555_CHIP_REV_23 = 0xc,
 };
 
 enum {
@@ -305,6 +306,11 @@ static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
 			di->vsel_step = 10000;
 			di->enable_time = 400;
 			break;
+		case FAN53555_CHIP_REV_23:
+			di->vsel_min = 600000;
+			di->vsel_step = 12500;
+			di->enable_time = 400;
+			break;
 		default:
 			dev_err(di->dev,
 				"Chip ID %d with rev %d not supported!\n",
-- 
2.53.0

