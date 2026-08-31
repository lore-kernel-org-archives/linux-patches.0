Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746E647FAF9;
	Mon, 31 Aug 2026 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183468; cv=none; b=esyJmkN+QJ+lL/YMfhT/SzWLrVpJepaRBtCyMMz8AjU/uB7G2/wKJze6RAUI/Q1VFxTlgTD8UfResg3uNY9Vlhrh9ZyTP0kGh1+6Xj+fswF2kQpFq+E7USGOZwN41xWGqpASXEzJ+amEhDHWCSy0tYlC8Sf/FaGL8dwKTBkQPzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183468; c=relaxed/simple;
	bh=xX3yamrLEumubIH127IBqYSRcKoF22Pqf/c+gAP3saM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vAInuqZB/TRsRaIIUjU2zVetmZV+ROv8QtnZYi64riS0ZUE6ye5IMnvVj+2iwG5KEDzTAkNm1rHmT52fSlzsgRdzA2XNgQuXce1yEzHlomfDpPJ6kChYXI7QGe1kVSFX6P1T3MXnPjD6LIvhn9cf+JmF80Q+zqyb9Mx8+SAOJZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hkMLDMny; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hkMLDMny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BBF1F00ACF;
	Mon, 31 Aug 2026 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183465;
	bh=4RRQ9zuGipDMmKlfsJ3plg2jO01pjaSW9DSKC9hjSdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkMLDMny5kflLBH0cq1JF6IgHKiqOI9FSK78ySWvF92MSP7VmkeVtXLjyg31q07X/
	 DA0wc4IPaBhjwE1g7A3CBprCxe83ZcFfGGlxnJk8OjKEMCtA0dnrToK/0+qRIz2yI7
	 l/wPCiGQfQDr0DIAMFRNoVhLP6bMJn3PXQL29jYKK5nNPBTqQktoYLGoVAz8kDsNNp
	 1rHtaGslLCPLb9gyKymU9AlOhh526IBsGSa8jC+7W97sIFfw2EwrE88PFkyJ5Yduoz
	 2deFSJgNkXVFrkeR0jDHKjG85wWCwpbaqc0+9RbEZ+uF7uCxqwF91qsM3hrWedZpdf
	 ElUiPfEfsXYwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brodie Abrew <brodie_abrew@selinc.com>,
	Robert Joslyn <robert.joslyn@redrectangle.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	hansg@kernel.org,
	platform-driver-x86@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] platform/x86: sel3350-platform: Retain LED state on load and unload
Date: Mon, 31 Aug 2026 09:22:20 -0400
Message-ID: <20260831133314.4125787-112-sashal@kernel.org>
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

From: Brodie Abrew <brodie_abrew@selinc.com>

[ Upstream commit 18bc6ce6bb618e1dff4473d7dd528d22519abbd7 ]

When the platform driver is loaded or unloaded, it overwrites the
existing LED states. This can cause a loss of early boot state when the
driver loads, and it can cause the ALARM contact to change state or
flicker.

Explicitly retain the existing LED state to prevent overwriting on
driver load and unload.

Tested-By: Robert Joslyn <robert.joslyn@redrectangle.org>
Reviewed-by: Robert Joslyn <robert.joslyn@redrectangle.org>
Signed-off-by: Brodie Abrew <brodie_abrew@selinc.com>
Link: https://patch.msgid.link/20260507004916.6710-1-brodie_abrew@selinc.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `platform/x86: sel3350-platform: Retain LED
state on load and unload`

**Local tree:** Linux **6.18.43** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`)

**Upstream commit:** `18bc6ce6bb618`
**Stable-series commit (not in this HEAD):** `d2b26d4859502`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[platform/x86: sel3350-platform]` `[retain]` — Keep
existing LED GPIO states when the SEL-3350 platform driver is loaded or
unloaded.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Tested-by:** Robert Joslyn `<robert.joslyn@redrectangle.org>`
- **Reviewed-by:** Robert Joslyn `<robert.joslyn@redrectangle.org>`
- **Reviewed-by:** Ilpo Järvinen `<ilpo.jarvinen@linux.intel.com>`
  (platform/x86 maintainer)
- **Signed-off-by:** Brodie Abrew `<brodie_abrew@selinc.com>` (SEL
  author)
- **Signed-off-by:** Ilpo Järvinen
- **Link:**
  https://patch.msgid.link/20260507004916.6710-1-brodie_abrew@selinc.com
- **Notable:** Hardware-tested on real SEL-3350; maintainer-reviewed; no
  syzbot/sanitizer signals.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug:** Driver load/unload overwrites existing LED GPIO states.
- **Symptoms:** Loss of early-boot LED state; ALARM contact may change
  state or flicker.
- **Root cause (author):** LEDs were initialized without preserving
  current GPIO values.
- **Version info:** None in the message.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised cleanup — explicit hardware-behavior fix. The
GPIO/ALARM contact behavior is functional, not cosmetic.

---

## PHASE 2: DIFF ANALYSIS — LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **File:** `drivers/platform/x86/sel3350-platform.c` (+103 / −33)
- **Functions modified:** `sel3350_probe()`, `sel3350_remove()`;
  LED/GPIO tables and constants
- **Scope:** Single-file, driver-local refactor + behavioral fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**

| Hunk | Before | After |
|------|--------|-------|
| LED table | Most LEDs default OFF; `sel:green:enabled` forced ON | All
LEDs use `LEDS_GPIO_DEFSTATE_KEEP`, `retain_state_suspended`,
`retain_state_shutdown` |
| GPIO lookup | Separate `sel3350_leds_table` for `"leds-gpio"` | LED
GPIOs merged into `sel3350_gpios_table` under ACPI device `SEL0003` |
| `sel3350_probe()` | Only adds lookup tables, registers `leds-gpio`
child | Pre-acquires each LED GPIO with `GPIOD_ASIS`, sets consumer
names, passes `gpiod` into `gpio_led` structs |
| Error path | Removes only `sel3350_leds_table` on failure | Adds
`err_gpio_loop` cleanup for pre-acquired GPIOs |
| `sel3350_remove()` | Removes both lookup tables | Removes only unified
`sel3350_gpios_table` |

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Category:** Logic / hardware-behavior correctness (GPIO state
  preservation)
- **Mechanism:** Without the fix, `leds-gpio` acquires GPIOs via
  `gpio_led_get_gpiod()` using `GPIOD_OUT_LOW` and initializes
  brightness from `default_state` (OFF unless explicitly ON). That
  forces outputs on probe. On unload, `gpio_led_shutdown()` turns off
  LEDs lacking `LED_RETAIN_AT_SHUTDOWN`. Together this overwrites early-
  boot and runtime GPIO states, including the ALARM line.

Verified in this tree:

```223:223:drivers/leds/leds-gpio.c
        gpiod = devm_gpiod_get_index_optional(dev, NULL, idx,
GPIOD_OUT_LOW);
```

```97:111:drivers/leds/leds-gpio.c
        if (template->default_state == LEDS_GPIO_DEFSTATE_KEEP) {
                state = gpiod_get_value_cansleep(led_dat->gpiod);
                ...
        }
        ...
        if (template->retain_state_shutdown)
                led_dat->cdev.flags |= LED_RETAIN_AT_SHUTDOWN;
```

```300:310:drivers/leds/leds-gpio.c
static void gpio_led_shutdown(struct platform_device *pdev)
{
        ...
                if (!(led->cdev.flags & LED_RETAIN_AT_SHUTDOWN))
                        gpio_led_set(&led->cdev, LED_OFF);
```

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Sound — uses existing `gpio_led` fields (`gpiod`,
  `LEDS_GPIO_DEFSTATE_KEEP`, retain flags) supported in
  `include/linux/leds.h`.
- **Regression risk:** Low. `sel:green:enabled` changes from forced-ON
  to KEEP (intentional per commit message). Pre-acquire with
  `GPIOD_ASIS` is the correct pattern to avoid clobbering hardware
  state.
- **Red flags:** Moderate diff size, but confined to one niche driver.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** Current LED definitions blame to `5d324e5159d9e` (2025-11-28
merge). Repo is shallow (`git rev-parse --is-shallow-repository` →
`true`), limiting deep history. Driver file is present at 249 lines in
HEAD and in `18bc6ce6bb618^`, confirming the pre-fix code exists in this
tree.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag — N/A.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:** Only one visible history entry for this file in the shallow
tree (`5d324e5159d9e`). Fix commit `18bc6ce6bb618` is standalone (not
part of a multi-patch series). Mbox thread shows v1→v2→v3 evolution; v3
is what landed.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Author is Brodie Abrew (SEL). Maintainer Ilpo Järvinen
reviewed and applied. Limited shallow-history visibility for broader
author history.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Required APIs (`LEDS_GPIO_DEFSTATE_KEEP`,
`struct gpio_led.gpiod`, `retain_state_*`) are present in this 6.18.43
tree. Fix is self-contained.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **URL:**
  https://patch.msgid.link/20260507004916.6710-1-brodie_abrew@selinc.com
  (`b4 dig -c 18bc6ce6bb618`)
- **Series:** v1 → v2 → v3; committed version is v3
- **Key feedback:** Ilpo Järvinen: “The code change seemed fine now.”
  Applied as `18bc6ce6bb618`.
- **Stable nomination:** None found in thread.
- **NAKs:** None found.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** `b4 dig -w` → thread on `platform-
driver-x86@vger.kernel.org`. Reviewed/tested by hardware user Robert
Joslyn; applied by maintainer Ilpo Järvinen.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** No external bug tracker link. Robert Joslyn reported testing
v1/v2 on SEL-3350 hardware in the mbox thread.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Single-patch series; standalone.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** Not searched separately; no stable discussion found in the
patch thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `sel3350_probe()`, `sel3350_remove()`, plus static data
tables.

### Step 5.2: TRACE CALLERS
**Record:**
- `sel3350_probe()` — platform driver probe on ACPI match `SEL0003`
  (SEL-3350 mainboard).
- Triggered at boot when `CONFIG_SEL3350_PLATFORM` is enabled and
  hardware is present.
- Not a syscall path; ACPI/platform enumeration only.

### Step 5.3: TRACE CALLEES
**Record:** `devm_gpiod_get()` (GPIOD_ASIS),
`platform_device_register_data("leds-gpio")`,
`gpiod_add/remove_lookup_table()`, power-supply registration.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** ACPI probe → GPIO pre-acquire (preserve state) → register
`leds-gpio` child with pre-filled `gpiod` → `gpio_led_probe()` →
`create_gpio_led()` reads KEEP state. Reachable on every boot/module
load for SEL-3350 systems.

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** `LEDS_GPIO_DEFSTATE_KEEP` used elsewhere (e.g.
`drivers/net/wireless/ath/ath10k/leds.c`, `arch/arm/mach-
sa1100/assabet.c`) for the same “don’t clobber GPIO state” pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **Yes.** `drivers/platform/x86/sel3350-platform.c` in HEAD
matches pre-fix code:
- Separate `sel3350_leds_table`
- LEDs without `LEDS_GPIO_DEFSTATE_KEEP`
- `sel:green:enabled` forced `LEDS_GPIO_DEFSTATE_ON`
- No pre-acquired `gpiod` in probe

Fix commits `18bc6ce6bb618` and `d2b26d4859502` are **not** ancestors of
HEAD (`git merge-base --is-ancestor` exit code 1).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** Expected **clean apply**. Pre-fix file index
(`02e2081e2333`) matches current tree structure. Required headers and
`struct gpio_led` fields exist.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** No duplicate or alternate fix found in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/platform/x86/` — **PERIPHERAL** (SEL-3350
industrial platform driver, `CONFIG_SEL3350_PLATFORM`).

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Active subsystem, but this driver is niche industrial
hardware (Schweitzer Engineering Laboratories protection/automation
equipment).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** **Driver-specific** — systems with SEL-3350 hardware and
`CONFIG_SEL3350_PLATFORM` enabled (built-in or module load/unload).

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:**
- **Trigger:** Driver probe at boot, or `modprobe`/`rmmod` of
  `sel3350-platform`.
- **Likelihood:** Every boot/load on affected hardware.
- **Unprivileged trigger:** No direct userspace trigger; normal system
  boot/module management.

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:**
- **Failure mode:** GPIO lines (including ALARM contact) forced to wrong
  state or flicker; early-boot LED state lost.
- **Severity:** **MEDIUM** for kernel stability (no crash/oops);
  **HIGH** for operational correctness on SEL-3350 — spurious or missed
  alarm signaling on a physical contact output used in industrial
  monitoring/protection contexts.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** Medium — small user population, but every affected user
  hits the bug on each load/unload; ALARM integrity matters on this
  hardware.
- **Risk:** Low — uses established LED/GPIO APIs; hardware-tested;
  maintainer-reviewed; single driver file.
- **Ratio:** Benefit outweighs risk for this tree where the driver and
  bug both exist.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backport:**
- Real, reproducible hardware bug on every driver load/unload
- Hardware-tested (`Tested-by`) on SEL-3350
- Maintainer-reviewed and applied
- Driver and buggy code present in Linux 6.18.43
- Fix uses existing APIs; no new userspace surface
- Hardware-workaround pattern (preserve GPIO/ALARM state)
- Functional ALARM-contact impact, not cosmetic LEDs

**AGAINST backport:**
- No kernel crash, security issue, data corruption, or deadlock
- Very narrow hardware scope (`CONFIG_SEL3350_PLATFORM`)
- Diff is ~70 net lines (larger than a one-liner)
- Shallow git history limits full introduction-date verification

**Unresolved:** Exact kernel version when `sel3350-platform` was first
merged (shallow clone); not needed — driver is confirmed present in this
6.18.43 tree.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — maintainer + hardware
   Tested-by; mechanism verified in `leds-gpio.c`.
2. Fixes a real bug affecting users? **PASS** — verified GPIO-clobber
   behavior on SEL-3350.
3. Important issue? **PASS (operational/hardware)** — ALARM contact
   state change on industrial equipment; not a kernel crash but
   materially affects deployed systems using this driver.
4. Small and contained? **PASS** — one file, one driver; moderate size
   but focused.
5. No new features or APIs? **PASS** — behavioral fix using existing
   `gpio_led` fields.
6. Can apply to the local tree? **PASS** — pre-fix code matches; APIs
   present; fix not yet in HEAD.

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
**Record:** **Hardware quirk/workaround** — preserves correct GPIO/ALARM
state on a specific platform where default `leds-gpio` initialization is
wrong.

### Step 9.4: DECISION RATIONALE
For **this** 6.18.43 tree, the driver exists, the bug exists, the fix is
technically sound and hardware-validated, and it prevents incorrect
ALARM-contact behavior on SEL-3350 systems. It fits stable’s hardware-
workaround exception and carries low regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, and body from provided commit message
  and `git show 18bc6ce6bb618`
- [Phase 1] Confirmed Tested-by, Reviewed-by (Joslyn, Järvinen), Link
  tag; no Fixes:/syzbot tags
- [Phase 2] Read full current `sel3350-platform.c` (249 lines, pre-fix
  state)
- [Phase 2] Read `leds-gpio.c` lines 97–111, 223, 273–277, 300–310 for
  bug mechanism
- [Phase 2] Read `include/linux/leds.h` `struct gpio_led` — `gpiod`,
  `LEDS_GPIO_DEFSTATE_KEEP`, retain flags present
- [Phase 2] Counted diff: +104/−34 lines via `git show`
- [Phase 3] `git blame` on LED table → all lines from `5d324e5159d9e`
- [Phase 3] `git rev-parse --is-shallow-repository` → `true`
- [Phase 3] `git show 18bc6ce6bb618^:...` → 249-line pre-fix file exists
- [Phase 3] No Fixes: tag to follow
- [Phase 4] `b4 dig -c 18bc6ce6bb618` → lore URL found
- [Phase 4] `b4 dig -m /tmp/sel3350_thread.mbox` → downloaded thread; v3
  series, maintainer approval, hardware testing noted
- [Phase 4] `b4 dig -w` → platform-driver-x86 list recipients confirmed
- [Phase 4] No stable nomination or NAK found in mbox
- [Phase 5] Traced probe path: ACPI → `sel3350_probe()` → `leds-gpio`
  registration
- [Phase 5] Grep found `LEDS_GPIO_DEFSTATE_KEEP` usage in ath10k,
  assabet
- [Phase 6] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 6] `git merge-base --is-ancestor 18bc6ce6bb618 HEAD` → exit 1
  (fix not in HEAD)
- [Phase 6] `git merge-base --is-ancestor d2b26d4859502 HEAD` → exit 1
  (stable commit not in HEAD)
- [Phase 6] Confirmed `CONFIG_SEL3350_PLATFORM` in
  `drivers/platform/x86/Kconfig`
- [Phase 7] Driver is peripheral/platform-specific
- [Phase 8] Assessed trigger (every boot/load) and severity (operational
  ALARM contact)
- [UNVERIFIED] Exact upstream merge commit that first introduced
  `sel3350-platform.c` (shallow history; `-S` searches timed out)

**YES**The background git jobs mostly matched what we already had from
the main review.

**Confirmed**
- The repo is a **shallow clone**, so deep history searches are slow or
  incomplete.
- The fix commits (`18bc6ce6bb618`, `d2b26d4859502`) are **not** in the
  current 6.18.43 HEAD.
- The pre-fix `sel3350-platform.c` is present in this tree.

**Failed / incomplete**
- `git log -S` searches for when `SEL3350_PLATFORM` / `sel3350-platform`
  were introduced timed out or produced no extra history.
- `git branch --contains` on the fix commit hung and was killed.

That doesn’t change the conclusion: for this 6.18.43 tree, the driver
and buggy code are present, the fix is hardware-validated and should
apply cleanly, and the backport recommendation remains **YES**.

 drivers/platform/x86/sel3350-platform.c | 136 ++++++++++++++++++------
 1 file changed, 103 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/sel3350-platform.c b/drivers/platform/x86/sel3350-platform.c
index 02e2081e2333b..f3a3142356325 100644
--- a/drivers/platform/x86/sel3350-platform.c
+++ b/drivers/platform/x86/sel3350-platform.c
@@ -9,6 +9,8 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/array_size.h>
+#include <linux/err.h>
 #include <linux/gpio/consumer.h>
 #include <linux/gpio/machine.h>
 #include <linux/leds.h>
@@ -30,19 +32,82 @@
 #define SEL_PS_B_DETECT "sel_ps_b_detect"
 #define SEL_PS_B_GOOD   "sel_ps_b_good"
 
+#define AUX_LED_GRN1        "sel_aux_led_grn1"
+#define AUX_LED_GRN2        "sel_aux_led_grn2"
+#define AUX_LED_GRN3        "sel_aux_led_grn3"
+#define AUX_LED_GRN4        "sel_aux_led_grn4"
+#define ALARM_STATE_USER    "sel_alarm_state_user"
+#define ENABLE_STATE_USER   "sel_enable_state_user"
+#define AUX_LED_RED1        "sel_aux_led_red1"
+#define AUX_LED_RED2        "sel_aux_led_red2"
+#define AUX_LED_RED3        "sel_aux_led_red3"
+#define AUX_LED_RED4        "sel_aux_led_red4"
+
+static const char *const sel3350_leds_gpio_names[] = {
+	AUX_LED_GRN1,
+	AUX_LED_GRN2,
+	AUX_LED_GRN3,
+	AUX_LED_GRN4,
+	ALARM_STATE_USER,
+	ENABLE_STATE_USER,
+	AUX_LED_RED1,
+	AUX_LED_RED2,
+	AUX_LED_RED3,
+	AUX_LED_RED4,
+};
+
 /* LEDs */
-static const struct gpio_led sel3350_leds[] = {
-	{ .name = "sel:green:aux1" },
-	{ .name = "sel:green:aux2" },
-	{ .name = "sel:green:aux3" },
-	{ .name = "sel:green:aux4" },
-	{ .name = "sel:red:alarm" },
+static struct gpio_led sel3350_leds[] = {
+	{ .name = "sel:green:aux1",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:green:aux2",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:green:aux3",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:green:aux4",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:red:alarm",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
 	{ .name = "sel:green:enabled",
-	  .default_state = LEDS_GPIO_DEFSTATE_ON },
-	{ .name = "sel:red:aux1" },
-	{ .name = "sel:red:aux2" },
-	{ .name = "sel:red:aux3" },
-	{ .name = "sel:red:aux4" },
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:red:aux1",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:red:aux2",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:red:aux3",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
+	{ .name = "sel:red:aux4",
+	  .default_state = LEDS_GPIO_DEFSTATE_KEEP,
+	  .retain_state_suspended = 1,
+	  .retain_state_shutdown = 1,
+	},
 };
 
 static const struct gpio_led_platform_data sel3350_leds_pdata = {
@@ -50,25 +115,6 @@ static const struct gpio_led_platform_data sel3350_leds_pdata = {
 	.leds = sel3350_leds,
 };
 
-/* Map GPIOs to LEDs */
-static struct gpiod_lookup_table sel3350_leds_table = {
-	.dev_id = "leds-gpio",
-	.table = {
-		GPIO_LOOKUP_IDX(BXT_NW, 49, NULL, 0, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_NW, 50, NULL, 1, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_NW, 51, NULL, 2, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_NW, 52, NULL, 3, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_W,  20, NULL, 4, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_W,  21, NULL, 5, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_SW, 37, NULL, 6, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_SW, 38, NULL, 7, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_SW, 39, NULL, 8, GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP_IDX(BXT_SW, 40, NULL, 9, GPIO_ACTIVE_HIGH),
-		{},
-	}
-};
-
-/* Map GPIOs to power supplies */
 static struct gpiod_lookup_table sel3350_gpios_table = {
 	.dev_id = B2093_GPIO_ACPI_ID ":00",
 	.table = {
@@ -76,6 +122,16 @@ static struct gpiod_lookup_table sel3350_gpios_table = {
 		GPIO_LOOKUP(BXT_NW, 45, SEL_PS_A_GOOD,   GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP(BXT_NW, 46, SEL_PS_B_DETECT, GPIO_ACTIVE_LOW),
 		GPIO_LOOKUP(BXT_NW, 47, SEL_PS_B_GOOD,   GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP(BXT_NW, 49, AUX_LED_GRN1, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_NW, 50, AUX_LED_GRN2, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_NW, 51, AUX_LED_GRN3, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_NW, 52, AUX_LED_GRN4, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_W,  20, ALARM_STATE_USER, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_W,  21, ENABLE_STATE_USER, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_SW, 37, AUX_LED_RED1, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_SW, 38, AUX_LED_RED2, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_SW, 39, AUX_LED_RED3, GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP(BXT_SW, 40, AUX_LED_RED4, GPIO_ACTIVE_HIGH),
 		{},
 	}
 };
@@ -149,6 +205,7 @@ struct sel3350_data {
 static int sel3350_probe(struct platform_device *pdev)
 {
 	int rs;
+	int i;
 	struct sel3350_data *sel3350;
 	struct power_supply_config ps_cfg = {};
 
@@ -158,9 +215,19 @@ static int sel3350_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sel3350);
 
-	gpiod_add_lookup_table(&sel3350_leds_table);
 	gpiod_add_lookup_table(&sel3350_gpios_table);
 
+	for (i = 0; i < ARRAY_SIZE(sel3350_leds); ++i) {
+		sel3350_leds[i].gpiod = devm_gpiod_get(&pdev->dev,
+						       sel3350_leds_gpio_names[i],
+						       GPIOD_ASIS);
+		if (IS_ERR_OR_NULL(sel3350_leds[i].gpiod)) {
+			rs = -EPROBE_DEFER;
+			goto err_gpio_loop;
+		}
+		gpiod_set_consumer_name(sel3350_leds[i].gpiod, sel3350_leds[i].name);
+	}
+
 	sel3350->leds_pdev = platform_device_register_data(
 			NULL,
 			"leds-gpio",
@@ -209,11 +276,15 @@ static int sel3350_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_gpio_loop:
+	while (i--)
+		devm_gpiod_put(&pdev->dev, sel3350_leds[i].gpiod);
+	goto err_platform;
+
 err_ps:
 	platform_device_unregister(sel3350->leds_pdev);
 err_platform:
 	gpiod_remove_lookup_table(&sel3350_gpios_table);
-	gpiod_remove_lookup_table(&sel3350_leds_table);
 
 	return rs;
 }
@@ -224,7 +295,6 @@ static void sel3350_remove(struct platform_device *pdev)
 
 	platform_device_unregister(sel3350->leds_pdev);
 	gpiod_remove_lookup_table(&sel3350_gpios_table);
-	gpiod_remove_lookup_table(&sel3350_leds_table);
 }
 
 static const struct acpi_device_id sel3350_device_ids[] = {
-- 
2.53.0

