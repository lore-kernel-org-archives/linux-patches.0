Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8374655820B;
	Mon, 31 Aug 2026 13:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184036; cv=none; b=Z64RtRXsjoh6ro5RjefUbtqbHeoY4VPQYHxP8ykI+LnEjT4lAZ6JzJc+xlKWz7DkPe5w7RC5jOh8MrMvQ2ESNE0mUxAbgk05A8ZQvnJpKHWsY3GnXO/4MzDRCKjy9yrCxxf9tRy80Uf+ZBMcCGa6MbCax27gEM3NNXiaBW+mUNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184036; c=relaxed/simple;
	bh=NcK4P1CGk+aDIjSRTj+dtZpbuS52Zgf27SntGYnC+9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQr1L2OdYNRMAAu797rIHNiLDpB5cFta9AZcUmdT/RV9CgA9fDWXhfrBASX85o3niWeqePNEeZFIrcie19jQnob3SxQebDvz+OM8+FQ1THbHSf3k6W3Bb/YF0PzGOXceKUUgGWI8tjxKCJSTuNVpG9DxPqav6RxlohX+d44dh2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R/p7rej7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R/p7rej7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3B61F00A3F;
	Mon, 31 Aug 2026 13:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184033;
	bh=WbiPvEsz4cjRvtCEuN3SotjWZZ8/mhoflAbKzVEP7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/p7rej7y/TXWVtz0VyET6fOVjxjP65ApHQCcZdVqPpI8bQeUiDyq5H6RQ7HIZ6Dn
	 6iQ+I6M90GBT4xRk+rJmsbzPeFPK7ZtKkRUj0F4QolnFg5jGgxqwPawpBIZmypfgZn
	 Co2QGj7MXw1WAWXhVZb08RQ7x5FQ3uNUMhNWTBmSMvgM2ze9zx/7DSirO2JdxkjWbE
	 n9NRMAz71J381LHkfWm1IXIjdJhJLcEv04o/LcwvB4/pjel2LYbOnUfqSR++iscBDX
	 SFbu6YjLrj5b5kEOG3Ciig1wLamPQaq9BQzZl+xbAeB0P6A+TyqoBsIIMWOWE6EZd6
	 DHsZCjwDzvA5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kory Maincent <kory.maincent@bootlin.com>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	linux-hwmon@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] hwmon: (adt7462) Add of_match_table to support devicetree
Date: Mon, 31 Aug 2026 09:27:59 -0400
Message-ID: <20260831133314.4125787-451-sashal@kernel.org>
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

From: Kory Maincent <kory.maincent@bootlin.com>

[ Upstream commit cd1b42617aafe01810ab7d3b9948d2f5fa9fb8af ]

Add of_match_table to add support of devicetree probing.

Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
[rgantois: Removed of_match_ptr().]
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/r/20260608-adt7462-bindings-v2-1-272982c40325@bootlin.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `hwmon: (adt7462) Add of_match_table to
support devicetree`

**Local tree:** `v6.18.44` (Makefile: VERSION=6, PATCHLEVEL=18,
SUBLEVEL=44)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[hwmon/adt7462]` `[Add]` — Add `of_match_table` to enable
Device Tree probing for the existing ADT7462 hwmon driver.

### Step 1.2: Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none (Guenter Roeck committed it as hwmon
  maintainer)
- **Acked-by:** — none
- **Link:** https://lore.kernel.org/r/20260608-adt7462-bindings-v2-1-
  272982c40325@bootlin.com
- **Cc: stable:** — none
- **Signed-off-by:** Kory Maincent, Romain Gantois (noted removal of
  `of_match_ptr()`), Guenter Roeck

No syzbot, no user bug reports, no explicit stable nomination in commit
message.

### Step 1.3: Body Analysis
**Record:**
- **Bug described:** The ADT7462 I2C hwmon driver lacks an
  `of_match_table`, so it cannot be probed via Device Tree even when a
  DT node declares `compatible = "onnn,adt7462"`.
- **Symptom:** Fan controller / temperature monitor chip is not bound on
  DT-based platforms; hwmon sensors never appear.
- **Root cause:** Driver was written for legacy I2C detect probing only;
  DT binding was added separately without the corresponding driver OF
  table.

### Step 1.4: Hidden Bug Fix?
**Record:** Not a crash/leak/race fix. This is **hardware enablement** —
completing DT integration that was partially merged. The driver probe
path itself is unchanged; only the matching mechanism is added.
Classified as a functional gap, not a hidden memory-safety fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/hwmon/adt7462.c` — +8 lines, 0 removed
- **Functions modified:** None functionally; changes are at
  module/driver registration level
- **Scope:** Single-file, surgical addition

### Step 2.2: Code Flow Change
**Record:**
- **Hunk 1 (include):** Adds `#include <linux/mod_devicetable.h>` for
  `MODULE_DEVICE_TABLE(of, ...)`.
- **Hunk 2 (of_match table):** Adds `adt7462_of_match[]` with `{
  .compatible = "onnn,adt7462" }` and `MODULE_DEVICE_TABLE(of, ...)`.
- **Hunk 3 (driver struct):** Sets `.of_match_table = adt7462_of_match`
  in `adt7462_driver`.
- **Before:** I2C core could only match via `id_table` or legacy
  `.detect` on non-DT buses.
- **After:** I2C core can match DT nodes with `compatible =
  "onnn,adt7462"` to this driver.

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware/DT enablement.** On DT platforms,
I2C devices are instantiated from the device tree at boot. Without
`of_match_table`, the I2C subsystem has no way to associate the DT node
with `adt7462_driver`. The `.detect` callback is not used for OF-
instantiated devices.

### Step 2.4: Fix Quality
**Record:** Obviously correct — standard pattern used by dozens of hwmon
drivers in this tree (e.g., `tmp108.c`, `ltc4282.c`, `sht4x.c`). Minimal
diff. No regression risk for non-DT users (OF table is only consulted
for DT nodes). Romain Gantois removed unnecessary `of_match_ptr()`
wrapper per maintainer feedback.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `adt7462_driver` structure dates to 2014 (commit
`a2cc242823399`). Driver has never had `of_match_table`. `.probe`
updated in 2023 (`1975d167869ef`). The "bug" is longstanding absence of
DT support, exposed when DT binding and board DTS were added in
6.13/6.14.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no `Fixes:` tag present.

### Step 3.3: Related File History
**Record:**
- `3d973b98d2744` (v6.13): `dt-bindings: trivial-devices: add
  onnn,adt7462` — binding added
- `de153911ffcb6` (v6.14): `ARM: dts: aspeed: Add device tree for
  Ampere's Mt. Jefferson BMC` — board DTS with `compatible =
  "onnn,adt7462"` at i2c8:0x5c
- `cd1b42617aafe` (v7.2, NOT in this tree): driver OF table added
- Both binding and Jefferson DTS are ancestors of HEAD (v6.18.44);
  driver fix is NOT

### Step 3.4: Author Context
**Record:** Kory Maincent and Romain Gantois (Bootlin). Guenter Roeck
(hwmon maintainer) committed. No prior hwmon commits from these authors
in this tree. Maintainer-reviewed and accepted.

### Step 3.5: Dependencies
**Record:** Standalone — no prerequisite commits. Requires only that
`onnn,adt7462` binding exist (present since v6.13) and that `adt7462.c`
driver exist (present since v4.x). Patch applies cleanly (`git apply
--check` succeeded).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c cd1b42617aafe` found thread at https://patch.msgi
d.link/20260608-adt7462-bindings-v2-1-272982c40325@bootlin.com. Part of
a 2-patch series (v1 added binding, v2 added driver OF table). Lore page
blocked by bot protection — could not read review thread content.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` shows CC to Guenter Roeck, Rob Herring,
Krzysztof Kozlowski, Conor Dooley, Thomas Petazzoni, linux-hwmon@,
devicetree@, linux-kernel@. Appropriate maintainers included.

### Step 4.3: Bug Reports
**Record:** No bug reports, syzbot links, or bugzilla references.

### Step 4.4: Series Context
**Record:** v1 (2026-06-03) added DT binding; v2 (2026-06-08) added
driver OF table. Binding portion was already merged separately in v6.13
(`3d973b98d2744`); only the driver portion remains missing from this
tree.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). No stable nomination found in
commit message.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** No functions modified. Changes affect `adt7462_of_match[]`
(new), `adt7462_driver` (registration), and module tables.

### Step 5.2: Callers
**Record:** `adt7462_probe()` is called by I2C core during device
binding. Currently unreachable from DT on Ampere Jefferson; after fix,
reachable when DT node `fan-controller@5c` with `compatible =
"onnn,adt7462"` is present.

### Step 5.3: Callees
**Record:** `adt7462_probe()` uses `devm_kzalloc`,
`devm_hwmon_device_register_with_groups` — unchanged.

### Step 5.4: Reachability
**Record:** On Ampere Mt. Jefferson BMC (`aspeed-bmc-ampere-
mtjefferson.dts`), the ADT7462 fan controller at I2C bus 8, address 0x5c
is declared in DT. Without this fix, no driver binds. With fix, probe
runs at boot on that platform. Not reachable from userspace syscalls;
platform-specific embedded path.

### Step 5.5: Similar Patterns
**Record:** Standard hwmon DT enablement pattern. Similar commit:
`393de14673d60 hwmon: (sht21) Add devicetree support` (+13 lines, same
pattern).

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** `drivers/hwmon/adt7462.c` in v6.18.44 lacks
`of_match_table` (verified: no matches for `adt7462_of_match`). DT
binding (`onnn,adt7462` in `trivial-devices.yaml`, since v6.13) and
board DTS (`aspeed-bmc-ampere-mtjefferson.dts`, since v6.14) are both
present. The integration is incomplete in this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply.** `git apply --check` on commit diff
succeeded with no conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** None. `git log --grep="adt7462.*of_match"` found no matching
commit in HEAD. Binding commit `3d973b98d2744` is present; driver OF
table commit `cd1b42617aafe` is NOT.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/hwmon/` — **PERIPHERAL** (specific I2C sensor/fan
controller driver). Critical for BMC thermal management on affected
platform but not a core kernel path.

### Step 7.2: Activity
**Record:** hwmon subsystem actively maintained. adt7462 driver last
touched for struct initialization cleanup (`d8a66f3621c28`). Low churn
on this specific file.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** **Platform-specific** — users of Ampere Mt. Jefferson BMC
(ASPEED AST2600) with `CONFIG_SENSORS_ADT7462=y/m`. Currently the only
in-tree DTS using `onnn,adt7462`. Enterprise server BMC deployments.

### Step 8.2: Trigger Conditions
**Record:** Boot on DT platform with `compatible = "onnn,adt7462"` node.
Deterministic — happens every boot on Jefferson BMC. Not triggerable by
unprivileged users; embedded platform init path.

### Step 8.3: Failure Mode Severity
**Record:** ADT7462 fan controller and temperature sensors never
initialize. No kernel crash, oops, or data corruption. **Severity:
MEDIUM** for affected platform (loss of fan monitoring/thermal
management on server BMC); **LOW** globally (single known board).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Enables fan/thermal monitoring on Ampere Jefferson BMC;
  completes DT integration already shipped in this tree. Real hardware
  fix for a real platform.
- **Risk:** Very low — 8 lines, standard pattern, no logic changes, no
  impact on non-DT systems.
- **Ratio:** Moderate benefit for embedded/BMC users, very low risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- DT binding and Ampere Jefferson board DTS already shipped in v6.18.44
  without driver OF support — incomplete integration
- Fan controller is completely non-functional on Jefferson BMC without
  this fix
- Tiny (8 lines), obviously correct, applies cleanly
- Falls under stable **DT exception**: "Enabling already-supported
  hardware on new boards"
- Driver already exists; only adds matching glue for already-declared
  hardware
- Zero regression risk for existing non-DT users

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock fix
- Technically adds DT probing capability (feature addition)
- Only one in-tree board currently affected
- No user bug reports or syzbot findings
- Binding was merged 3 major versions before driver fix — gap has
  existed since v6.14

**Unresolved:**
- Could not read lore review thread (bot protection) — stable nomination
  in review unverified

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — standard OF table pattern;
   maintainer-committed; no functional logic changes
2. Fixes real bug affecting users? **PASS** — DT-declared hardware is
   non-functional on Jefferson BMC in this tree
3. Important issue? **PASS (borderline)** — not crash/security, but loss
   of fan/thermal monitoring on server BMC is operationally significant
   for that platform
4. Small and contained? **PASS** — 8 lines, one file
5. No new features or APIs? **PASS with exception** — adds DT probing
   path, but qualifies under DT exception for enabling hardware on
   boards already in tree
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: Exception Category
**Record:** **Device Tree update** — enabling already-supported hardware
(ADT7462 via existing driver) on a board (Ampere Mt. Jefferson) whose
DTS and binding are already present in v6.18.44.

### Step 9.4: Decision Rationale

This tree (v6.18.44) already contains the `onnn,adt7462` DT binding
(since v6.13) and the Ampere Mt. Jefferson BMC device tree (since v6.14)
declaring a `fan-controller@5c` node. Without the driver's
`of_match_table`, that hardware cannot be driven — the I2C core has no
mechanism to bind the existing driver to the DT node. The commit
completes an integration that was partially merged into this stable
series.

While this is not a crash or security fix, it is a real functional
defect for the Jefferson BMC platform and fits the stable exception for
DT updates that enable hardware on boards already supported in-tree. The
patch is minimal, standard, and applies cleanly with no regression risk.

---

## Verification

- [Phase 1] Parsed commit `cd1b42617aafe`: subject, SOBs, Link tag; no
  Fixes/Reported-by/syzbot
- [Phase 2] Diff analysis: +8 lines in `adt7462.c`; adds include,
  `of_match_table`, `MODULE_DEVICE_TABLE(of)`
- [Phase 3] `git describe HEAD`: v6.18.44
- [Phase 3] `git blame` on driver struct: dates to 2014, never had OF
  table
- [Phase 3] `3d973b98d2744`: DT binding in tree since v6.13; confirmed
  ancestor of HEAD
- [Phase 3] `de153911ffcb6`: Jefferson DTS in tree since v6.14;
  confirmed ancestor of HEAD
- [Phase 3] `cd1b42617aafe`: NOT ancestor of HEAD; only on v7.2+
  branches
- [Phase 3] `git apply --check`: patch applies cleanly
- [Phase 4] `b4 dig -c cd1b42617aafe`: found lore thread; v1/v2 series
  identified
- [Phase 4] `b4 dig -w`: Guenter Roeck, Rob Herring, Krzysztof Kozlowski
  CC'd
- [Phase 4] Lore fetch: blocked by Anubis bot protection — review
  content UNVERIFIED
- [Phase 5] Grep `onnn,adt7462`: only in `aspeed-bmc-ampere-
  mtjefferson.dts` and binding YAML
- [Phase 5] Read DTS lines 466-472: `fan-controller@5c` with `compatible
  = "onnn,adt7462"`, `reg = <0x5c>`
- [Phase 5] Grep `adt7462_of_match` in tree: no matches (fix absent)
- [Phase 6] Read current `adt7462.c` lines 1811-1826: no
  `of_match_table` present
- [Phase 6] Compared with other hwmon drivers: standard `of_match_table`
  pattern confirmed
- [Phase 8] Failure mode: no driver binding on DT platform; fan/thermal
  sensors absent; severity MEDIUM for platform

**YES**

 drivers/hwmon/adt7462.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/hwmon/adt7462.c b/drivers/hwmon/adt7462.c
index 174dfee47f7a7..f935c3477b364 100644
--- a/drivers/hwmon/adt7462.c
+++ b/drivers/hwmon/adt7462.c
@@ -12,6 +12,7 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
+#include <linux/mod_devicetable.h>
 #include <linux/mutex.h>
 #include <linux/log2.h>
 #include <linux/slab.h>
@@ -1814,10 +1815,17 @@ static const struct i2c_device_id adt7462_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, adt7462_id);
 
+static const struct of_device_id adt7462_of_match[] = {
+	{ .compatible = "onnn,adt7462" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, adt7462_of_match);
+
 static struct i2c_driver adt7462_driver = {
 	.class		= I2C_CLASS_HWMON,
 	.driver = {
 		.name	= "adt7462",
+		.of_match_table = adt7462_of_match,
 	},
 	.probe		= adt7462_probe,
 	.id_table	= adt7462_id,
-- 
2.53.0

