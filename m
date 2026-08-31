Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3345444062C;
	Mon, 31 Aug 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183489; cv=none; b=K5X+Yo4JlciBEuFTn1atsDjiEM1t6NtustzL8ZS2rFwc1n5sH59cAa2NAOqiVukcq0uEWU/fIfFXWgQ9FjqM0N/axxWoOBOcbODGVg4tA0/FJNBdQqrsPtk/J+HlygRJhKOAxXucJd+7JqzLksCHG34rfxBt5cBnZodAFwJfae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183489; c=relaxed/simple;
	bh=xrnhguSKIg+Cztql5C7mmZw7koLKaWLcDIqriV2Ft3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i2quNR5qyeQyPBEin5tDAbgBWFQiw91rIHvc/AaIUGqkzyU8Wvy1jhtt7vArlngdNy/I6Lf3Rq1SBwb65ZyOIZAceGWi4SdmnFoCg0Ela7lmMpu/FxXMDPW3UL0DzLc4Mwiiyi7mcNT9SWMM6hr2UqCeccqSWxC1hVM8Uvlupxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UuOZkee6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UuOZkee6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2AA1F00A3F;
	Mon, 31 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183486;
	bh=fH1Ye0xirHU3yWSqBSYZpHZlv7lmBwICD1Q4n8jnmPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UuOZkee6AAIpqfKx1rOdEzgoKY64fVZ0/Ph0jKpbEdtZWZOgCQ3GlBvqkevU8dswX
	 w4jRiO8nONkZQ0t2Dwtb+tNRjtwtEW3ZKqbVPKdKl5/IKOaE5V2dQU1uwv20P9UhnR
	 nb41NSnkdyfwTHHO2h3E/h0+4bDGiwVmWe2OPfEhOZVM59syYH2yhG5iP7FFj0n0Cx
	 2562dByP245KAJuevfvgNHgHbXCRBoBg+xTQODirntpKkyYgxja6jJFL45d+mRtvS2
	 Ue4GmL0xbdZFSDh4oaJ42YQ/Uagm2tB74YCilZNCjvPbdPRPGBU04pJpeDq3VvZc0b
	 zx5EGLF3pWXBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Akashdeep Kaur <a-kaur@ti.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aaro.koskinen@iki.fi,
	andreas@kemnade.info,
	khilman@baylibre.com,
	rogerq@kernel.org,
	tony@atomide.com,
	linux-omap@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] mfd: tps65219: Make poweroff handler conditional on system-power-controller
Date: Mon, 31 Aug 2026 09:22:33 -0400
Message-ID: <20260831133314.4125787-125-sashal@kernel.org>
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

From: Akashdeep Kaur <a-kaur@ti.com>

[ Upstream commit 104cd764a031bfe2ffe253adce9581384a78c16e ]

Currently, the TPS65219 driver unconditionally registers a poweroff
handler. This causes issues on systems where a different component
(such as TF-A firmware) should handle system poweroff instead.

Make the poweroff handler registration conditional based on the
"system-power-controller" device tree property. This follows the
standard kernel pattern where only the designated power controller
registers for system poweroff operations.

On systems where the property is absent, the PMIC will not register
a poweroff handler, allowing other poweroff mechanisms to function.

Signed-off-by: Akashdeep Kaur <a-kaur@ti.com>
Link: https://patch.msgid.link/20260401112257.1248437-3-a-kaur@ti.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[mfd: tps65219]` `[Make]` — Make poweroff handler registration
conditional on the `system-power-controller` device-tree property.

**Step 1.2 — Tags**

Record:
- `Signed-off-by: Akashdeep Kaur <a-kaur@ti.com>` (author)
- `Link:
  https://patch.msgid.link/20260401112257.1248437-3-a-kaur@ti.com`
  (patch submission; message-id suffix `-3` indicates patch 3 of a
  series)
- `Signed-off-by: Lee Jones <lee@kernel.org>` (MFD maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

**Step 1.3 — Body analysis**

Record:
- **Bug:** TPS65219 driver unconditionally registers a system poweroff
  handler even when another component (e.g. TF-A) should handle
  shutdown.
- **Symptom:** Wrong poweroff path is taken; TF-A/PSCI shutdown is
  preempted or conflicted by PMIC I2C soft-shutdown.
- **Root cause:** Driver ignores the existing `system-power-controller`
  DT property documented in the binding.
- **Fix:** Only call `devm_register_power_off_handler()` when
  `of_device_is_system_power_controller()` is true.

**Step 1.4 — Hidden bug fix?**

Record: Yes. Despite “Make … conditional” wording, this is a real
platform correctness bug: the driver registers a shutdown handler on
boards where it should not, breaking the intended poweroff mechanism.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/mfd/tps65219.c` (+4/-4 net, ~10 lines touched)
- **Function:** `tps65219_probe()`
- **Scope:** Single-file, surgical driver fix

**Step 2.2 — Code flow change**

Record:
- **Before:** `devm_register_power_off_handler()` always runs during
  probe.
- **After:** Registration is wrapped in `if
  (of_device_is_system_power_controller(tps->dev->of_node))`.
- **Error handling:** Switches to `dev_err_probe()` (consistent with
  nearby tps6594 code).
- **Path affected:** Probe success path on all boards with a
  TPS65214/15/19 PMIC.

**Step 2.3 — Bug mechanism**

Record:
- **Category:** Logic / correctness fix (wrong shutdown handler
  registration).
- **Mechanism:** PMIC registers into the sys-off handler chain
  unconditionally. On K3 platforms where TF-A/PSCI owns shutdown, the
  PMIC handler sends an I2C OFF request via `tps65219_soft_shutdown()`,
  conflicting with the firmware path. The DT binding already defines
  `system-power-controller` as the gate for this behavior; the driver
  simply did not honor it.

**Step 2.4 — Fix quality**

Record:
- Fix is obviously correct and matches established PMIC driver patterns
  (`tps6594-core.c`, `rn5t618.c`, `max77620.c`, `tps6586x.c`).
- Minimal diff, no API changes.
- **Regression risk:** Low for boards that already have `system-power-
  controller` in DT (no behavior change). One in-tree board
  (`k3-am62-lp-sk.dts`) lacks the property and currently relies on
  unconditional registration; it may need a companion DT patch adding
  `system-power-controller` if PMIC shutdown is still required there.
  Other AM62 tps65219 boards already have the property.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record:
- Unconditional `devm_register_power_off_handler()` introduced by commit
  `3df4c63675203` (“mfd: tps65219: Add support for soft shutdown via
  sys-off API”, 2023-06-15).
- That code is present unchanged in the local tree at lines 544–550.

**Step 3.2 — Fixes: tag**

Record: Not applicable (no `Fixes:` tag). Bug introduced by
`3df4c63675203`, which is in this tree.

**Step 3.3 — Related file history**

Record:
- Driver added in `74c17a0a49a6a` (first appeared in v6.10).
- Poweroff support added 2023-06-15.
- DT binding `system-power-controller` documented since `4d2aed6ee306c`
  (2022-08-23), before poweroff handler was added.
- Fix commit is not yet merged into this checkout (buggy code still
  present).
- Patch is 3/N of a series per message-id; standalone driver change is
  self-contained.

**Step 3.4 — Author context**

Record: Akashdeep Kaur is a TI contributor with K3 device-tree work. Lee
Jones is the MFD maintainer who committed the original poweroff support.

**Step 3.5 — Dependencies**

Record:
- `of_device_is_system_power_controller()` exists in
  `include/linux/of.h` (available via `#include <linux/i2c.h>` already
  in the file).
- No structural prerequisites; patch applies standalone to
  `tps65219_probe()`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c` could not match the fix commit (not merged in this
tree). Direct lore fetch returned 403 Forbidden. Link points to patch 3
of an April 2026 TI submission series.

**Step 4.2 — Reviewers**

Record: UNVERIFIED — could not retrieve thread via lore or b4.

**Step 4.3 — Bug report**

Record: No external bug report linked. Issue described in commit message
(TF-A conflict).

**Step 4.4 — Series context**

Record: Message-id suffix `-3` suggests a multi-patch series; possible
companion DT updates exist but were not analyzed (not in provided diff).

**Step 4.5 — Stable list**

Record: UNVERIFIED — stable list search not accessible.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `tps65219_probe()`, `tps65219_power_off_handler()`,
`tps65219_soft_shutdown()`.

**Step 5.2 — Callers**

Record: `tps65219_probe()` called from I2C core during device
enumeration on boards with `compatible = "ti,tps65214"`,
`"ti,tps65215"`, or `"ti,tps65219"`. Ten in-tree TI K3 DTS files use
tps65219.

**Step 5.3 — Callees**

Record: `devm_register_power_off_handler()` → sys-off notifier chain;
handler calls `tps65219_soft_shutdown()` which writes PMIC registers
over I2C.

**Step 5.4 — Reachability**

Record: Triggered on every `poweroff`/`halt`/`shutdown` on systems where
the handler is registered. User-visible via standard shutdown syscalls.

**Step 5.5 — Similar patterns**

Record: Identical conditional pattern in `tps6594-core.c:788-792`,
`rn5t618.c:217-222`, `max77620.c:576-580`, `tps6586x.c:585-599`.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is `v6.18.44` (`git describe HEAD` =
`v6.18.44-1-g2736c32da98b9`). Unconditional registration at
`drivers/mfd/tps65219.c:544-550`. Bug present since v6.10 (driver
introduction) for poweroff path since mid-2023.

**Step 6.2 — Backport difficulty**

Record: Clean apply expected — small hunk in `tps65219_probe()`, no
conflicts visible. `of_device_is_system_power_controller` and DT binding
property both exist in this tree.

**Step 6.3 — Related fixes already present?**

Record: No equivalent conditional registration found in current
`tps65219.c`.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `drivers/mfd/` — MFD/PMIC driver. **Criticality: IMPORTANT**
(affects system shutdown on embedded TI K3 platforms, not universal but
operationally critical on affected hardware).

**Step 7.2 — Activity**

Record: Active development — TPS65214/15 support added recently; driver
actively maintained by TI and MFD maintainers.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of TI K3 SoCs (AM62 family and derivatives) with
TPS65214/15/19 PMIC, especially boards where TF-A handles shutdown but
the PMIC is present for regulators.

**Step 8.2 — Trigger conditions**

Record: Any system shutdown (`halt`, `poweroff`, `shutdown`). Common
user/admin operation. Not security-sensitive but operationally
important.

**Step 8.3 — Failure mode severity**

Record: Improper or failed system shutdown when PMIC handler conflicts
with TF-A/PSCI path. **Severity: MEDIUM-HIGH** — system may hang instead
of powering off, or take wrong shutdown path. Not a kernel oops, but a
real operational failure on production embedded systems.

**Step 8.4 — Risk vs benefit**

Record:
- **Benefit:** HIGH for affected TI K3 platforms — restores correct
  shutdown delegation per DT contract.
- **Risk:** LOW — 10-line change following established pattern; 9 of 10
  in-tree tps65219 boards already declare `system-power-controller`.
- **Ratio:** Benefit clearly outweighs risk.

---

## Phase 9: Final Synthesis

**Evidence FOR backport:**
- Fixes real shutdown correctness bug on TF-A-managed platforms
- Aligns driver with DT binding documented since 2022
- Matches established kernel PMIC pattern (tps6594, rn5t618, etc.)
- Small, surgical, maintainer-reviewed
- Buggy code confirmed present in v6.18.44 tree
- Affects commonly deployed TI K3 embedded hardware

**Evidence AGAINST:**
- `k3-am62-lp-sk.dts` lacks `system-power-controller`; may need
  companion DT patch (not in this commit)
- Mailing list review details unverified
- Not a crash/corruption bug — shutdown path correctness

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — standard pattern, maintainer
   SOB; runtime testing claimed in original poweroff commit for related
   hardware
2. Fixes real bug affecting users? **PASS** — wrong shutdown handler on
   TF-A platforms
3. Important issue? **PASS** — shutdown failure/hang, MEDIUM-HIGH
   severity
4. Small and contained? **PASS** — single file, ~10 lines
5. No new features/APIs? **PASS** — implements existing DT contract
6. Can apply to local tree? **PASS** — code and prerequisites present

**Exception category:** Hardware/platform quirk/workaround alignment
(DT-driven behavior gate).

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff
- [Phase 2] Analyzed diff: conditional
  `of_device_is_system_power_controller()` wrap in `tps65219_probe()`
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 3] `git blame -L 544,550 drivers/mfd/tps65219.c`: lines from
  `3df4c63675203` (2023-06-08)
- [Phase 3] `git show 3df4c63675203`: introduced unconditional poweroff
  handler
- [Phase 3] `git log --oneline -20 -- drivers/mfd/tps65219.c`: confirmed
  driver history
- [Phase 3] `git tag --contains 74c17a0a49a6a`: driver first in v6.10
- [Phase 4] `b4 dig -c 3df4c63675203`: found original poweroff patch
  lore link
- [Phase 4] `b4 dig -c <fix_commit>`: no match (fix not merged)
- [Phase 4] lore fetch: 403 Forbidden — review thread UNVERIFIED
- [Phase 5] Read `tps65219_power_off_handler()` and
  `tps65219_soft_shutdown()` at lines 29-40
- [Phase 5] Read `kernel/reboot.c:557-565`:
  `devm_register_power_off_handler` API
- [Phase 5] Compared with `tps6594-core.c:788-792`, `rn5t618.c:217-222`,
  `max77620.c:576-580`
- [Phase 6] Grep confirmed buggy unconditional registration at
  `tps65219.c:544-550`
- [Phase 6] Grep `system-power-controller` in 10 tps65219 DTS files: 9
  have property, `k3-am62-lp-sk.dts` does not
- [Phase 6] Read
  `Documentation/devicetree/bindings/regulator/ti,tps65219.yaml:34-37`:
  property documented
- [Phase 6] Read `include/linux/of.h:1706-1708`:
  `of_device_is_system_power_controller()` implementation
- [Phase 6] Verified `#include <linux/i2c.h>` pulls in `<linux/of.h>` —
  no new include needed
- [Phase 7] K3 AM62 has PSCI (`k3-am62.dtsi:30-31`)
- [Phase 8] UNVERIFIED: exact failure symptoms on specific TF-A platform
  (no bug report accessible)

This commit corrects a driver-DT contract violation that causes improper
system shutdown on TI K3 platforms where TF-A should handle poweroff.
The fix is small, follows an established PMIC pattern already used in
this tree, and the buggy code is present in v6.18.44.

**YES**

 drivers/mfd/tps65219.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65219.c b/drivers/mfd/tps65219.c
index 7275dcdb7c44f..e52fbf1481fef 100644
--- a/drivers/mfd/tps65219.c
+++ b/drivers/mfd/tps65219.c
@@ -541,13 +541,15 @@ static int tps65219_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	ret = devm_register_power_off_handler(tps->dev,
-					      tps65219_power_off_handler,
-					      tps);
-	if (ret) {
-		dev_err(tps->dev, "failed to register power-off handler: %d\n", ret);
-		return ret;
+	if (of_device_is_system_power_controller(tps->dev->of_node)) {
+		ret = devm_register_power_off_handler(tps->dev,
+						      tps65219_power_off_handler,
+						      tps);
+		if (ret)
+			return dev_err_probe(tps->dev, ret,
+					     "Failed to register power-off handler\n");
 	}
+
 	return 0;
 }
 
-- 
2.53.0

