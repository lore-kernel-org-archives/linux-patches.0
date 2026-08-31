Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0151D525A6F;
	Mon, 31 Aug 2026 13:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183863; cv=none; b=SAo5xH9ot+9Pvfv/jRgaICRY64ObhAUl1xpB+try7s/rCjC+GeSonhA3XK6x/LTV2kLxBfNdMAJH5r3WVh7fDXKUj1/XyMWsNRoVYVjsm1ot5nS0b4liWFFd9fzqeTulA878rXAqWSZRxE82Cdw783mUuDpe0kW4kZZVRpBLEWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183863; c=relaxed/simple;
	bh=ngM2hmLXNNb2yM0KxAfiYZN18ij7FLX5uaebl+80Efg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXENkGTOOPkf0DHhfaOduShUqAr9gCLqXfYDkjen0HARZwY3JwmIQpdY3pSNn6nHRb8lHsSkI1w2bK9mEEdeXbPMAsRLzliQhL6lm18KhOqjmCELqFVSMEvBtYRec2FcWNhD8v8HFPOs+y3HuhIEDbaPFu7dWQhGNoa4kilz9J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oLEsDjHg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oLEsDjHg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46E11F00A3D;
	Mon, 31 Aug 2026 13:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183859;
	bh=PCZJYIcnf3ceMTCmR4evOhuHbJFuQAFeLPT8UgL3h3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLEsDjHgQJKnpr3j+/9S7VLlj+czzBXfkS4nUeMyEYsWteGsMezgdk1HTT25qzVE/
	 OKR1kUlzC8wzoFj+1qkSIhbNfVFBzInSHvZ3M0Q5NSlGfhUKWbuLIznwULSR90PIEA
	 pCzsSmJSA2DsvnlVryEF4MFYWhZI5qKNlkda2kQoUZTkSU6ki73leeJG7t6AUEucDz
	 +lfl7cP9jU12CoAqJilGWa9hFoUTs+NyNLNcFYet+BkeP941iYBW4nzoCzXYrBOKw3
	 A/Q6hl5ltRbfKLMaJJUsqvZva1BjjJ7G3cngYWaKUXoT8BUjiFBizc5xdQieluErEC
	 mY3unFYhu2gXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Piotr Kubik <piotr@kubik.pl>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pavel@kernel.org,
	linux-leds@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] leds: trigger: gpio: Use GPIOD_FLAGS_BIT_NONEXCLUSIVE
Date: Mon, 31 Aug 2026 09:26:15 -0400
Message-ID: <20260831133314.4125787-347-sashal@kernel.org>
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

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 26e15f2558f66b6747ef981df8054d0d92d01b60 ]

When a GPIO is shared between the LED trigger driver and another driver,
the LED trigger driver needs to request the GPIO with
GPIOD_FLAGS_BIT_NONEXCLUSIVE to allow both drivers to monitor the same
GPIO pin.

Without this flag, if another driver has already claimed the GPIO,
the LED trigger driver's gpiod_get_optional() call fails silently,
and the LED trigger doesn't work.

This is needed for scenarios like:
- SFP module presence/status LED triggered by SFP Mod_ABS/Rx_LOS

Both GPIOs are also monitored by the SFP driver for module state
management, so they need to be shared.

Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Link: https://patch.msgid.link/20260408115106.379834-1-piotr@kubik.pl
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[leds: trigger: gpio]` `[Use]` — Add
`GPIOD_FLAGS_BIT_NONEXCLUSIVE` when requesting the GPIO used by the gpio
LED trigger.

### Step 1.2: Tags
**Record:**
- **Link:**
  https://patch.msgid.link/20260408115106.379834-1-piotr@kubik.pl
- **Signed-off-by:** Piotr Kubik \<piotr@kubik.pl\>
- **Signed-off-by:** Lee Jones \<lee@kernel.org\> (LED subsystem
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, or Cc:
  stable tags
- Notable: maintainer (Lee Jones) Signed-off-by is a quality signal

### Step 1.3: Body Analysis
**Record:**
- **Bug:** When a GPIO is shared between the gpio LED trigger and
  another driver (e.g. SFP `Mod_ABS` / `Rx_LOS`), the LED trigger
  requests the GPIO exclusively; if another driver already claimed it,
  acquisition fails and the trigger does not work.
- **Symptom:** Status LEDs driven by the gpio trigger do not function on
  shared-GPIO hardware.
- **Use case:** SFP module presence/status LEDs on network appliances
  where the SFP driver also monitors the same GPIO lines.
- **Root cause:** Missing `GPIOD_FLAGS_BIT_NONEXCLUSIVE` on
  `gpiod_get_optional()`.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Although not labeled "fix", this is a functional bug
fix: shared-GPIO hardware enablement, not a refactor or optimization.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/leds/trigger/ledtrig-gpio.c` (+2 / -1 lines)
- **Function:** `gpio_trig_activate()`
- **Scope:** Single-file, surgical one-line functional change

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `gpiod_get_optional(dev, "trigger-sources", GPIOD_IN)` —
  exclusive GPIO request.
- **After:** Same call with `GPIOD_IN | GPIOD_FLAGS_BIT_NONEXCLUSIVE` —
  allows sharing with an already-claimed GPIO.
- **Path:** LED trigger activation during default-trigger setup or
  manual trigger selection.

### Step 2.3: Bug Mechanism
**Record:**
- **Category:** Logic / hardware-workaround (shared GPIO access).
- **Mechanism:** Without `NONEXCLUSIVE`, `gpiod_request()` returns
  `-EBUSY` when another consumer already holds the line.
  `gpiod_get_optional()` propagates `ERR_PTR(-EBUSY)`.
  `gpio_trig_activate()` returns that error.
  `led_match_default_trigger()` ignores the `led_trigger_set()` return
  value, so activation failure is silent and the LED never gets the gpio
  trigger.

Verified in gpiolib:

```4672:4674:drivers/gpio/gpiolib.c
        if (ret) {
                if (!(ret == -EBUSY && flags &
GPIOD_FLAGS_BIT_NONEXCLUSIVE))
                        return ERR_PTR(ret);
```

And in LED core:

```271:278:drivers/leds/led-triggers.c
static bool led_match_default_trigger(struct led_classdev *led_cdev,
                                      struct led_trigger *trig)
{
        if (!strcmp(led_cdev->default_trigger, trig->name) &&
            trigger_relevant(led_cdev, trig)) {
                led_cdev->flags |= LED_INIT_DEFAULT_TRIGGER;
                led_trigger_set(led_cdev, trig);
                return true;
```

### Step 2.4: Fix Quality
**Record:**
- Obviously correct: matches the established pattern used across many
  drivers in this tree (regulators, extcon, PHY drivers, etc.).
- Minimal change, no API changes.
- Low regression risk: only affects the shared-GPIO case; exclusive
  GPIOs behave as before.
- The flag is marked deprecated in `consumer.h`, but remains the
  supported workaround throughout this tree.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- Buggy line introduced by `9bbd6b7209cf1` (Andy Shevchenko, Nov 3
  2023): switched to `gpiod_get_optional()` without `NONEXCLUSIVE`.
- Underlying trigger-sources design from `4a11dbf04f31c` (Linus Walleij,
  Sep 26 2023).
- Both commits are present in this 6.18.44 tree.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag in commit message.

### Step 3.3: Related File History
**Record:** Recent `ledtrig-gpio.c` history is cleanups only (sysfs,
kstrtox, DEVICE_ATTR_RW). No related fix already present. Standalone
patch, not part of a series.

### Step 3.4: Author Context
**Record:** Piotr Kubik has other networking-related work in this tree
(e.g. PSE driver). This gpio-trigger fix is a focused hardware-
enablement change, not a large series.

### Step 3.5: Dependencies
**Record:**
- Requires `GPIOD_FLAGS_BIT_NONEXCLUSIVE` (present since
  `ec757001c818c`, 2018).
- Requires trigger-sources gpio trigger (`4a11dbf04f31c`, 2023) —
  present in this tree.
- No other commits required. Applies standalone.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:** `b4 dig -c <commit>` could not run — commit is not in this
checkout. Lore/patch.msgid.link fetch blocked by Anubis bot protection.
Could not retrieve thread discussion.

### Step 4.2: Reviewers
**Record:** UNVERIFIED — could not run `b4 dig -w` without commit hash.
Lee Jones Signed-off-by indicates maintainer acceptance.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Use case described in
commit message (SFP Mod_ABS/Rx_LOS LEDs).

### Step 4.4: Related Patches
**Record:** No multi-patch series indicated. SFP driver
(`drivers/net/phy/sfp.c`) claims GPIOs via `devm_gpiod_get_optional()`
without `NONEXCLUSIVE` at lines 3149–3150 — consistent with SFP-probes-
first, LED-joins-shared scenario described in the commit.

### Step 4.5: Stable List History
**Record:** UNVERIFIED — could not search lore stable list due to fetch
restrictions.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `gpio_trig_activate()` modified.

### Step 5.2: Callers
**Record:** `gpio_trig_activate` is the `.activate` callback for
`gpio_led_trigger`, invoked from `led_trigger_set()` in
`drivers/leds/led-triggers.c` during:
- Default trigger setup at LED registration (`led_trigger_set_default()`
  → `led_match_default_trigger()`)
- Late trigger module load (`led_trigger_register()`)
- Manual trigger changes via sysfs

### Step 5.3: Callees
**Record:** `gpiod_get_optional()`, `gpiod_set_consumer_name()`,
`request_threaded_irq()` (already uses `IRQF_SHARED`),
`gpio_trig_irq()`.

### Step 5.4: Reachability
**Record:** Triggered during device probe/LED registration for any
platform using `linux,default-trigger = "gpio"` with `trigger-sources`
referencing a GPIO also claimed by another driver. Requires
`CONFIG_LEDS_TRIGGER_GPIO`. SFP network appliances are the documented
case.

### Step 5.5: Similar Patterns
**Record:** `GPIOD_FLAGS_BIT_NONEXCLUSIVE` is used in 30+ locations in
this tree for the same shared-GPIO pattern (regulators, extcon, micrel
PHY, etc.). LED gpio trigger was an omission.

---

## Phase 6: Cross-Reference Against Local Tree (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** YES. Current tree at `drivers/leds/trigger/ledtrig-
gpio.c:89`:

```89:89:drivers/leds/trigger/ledtrig-gpio.c
        gpio_data->gpiod = gpiod_get_optional(dev, "trigger-sources",
GPIOD_IN);
```

Fix is not yet applied. Bug has existed since Nov 2023 in this tree.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — single-line change, no surrounding
churn. No conflicts anticipated.

### Step 6.3: Related Fixes Already Present?
**Record:** No — `git log --grep` found no matching fix in this tree.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem
**Record:** `drivers/leds/trigger/` — LED triggers. **Criticality:
PERIPHERAL** (status LEDs), but on network appliances SFP status LEDs
are operationally important.

### Step 7.2: Activity
**Record:** Moderate recent activity (cleanups in 2024–2025). trigger-
sources gpio trigger is mature in this tree.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Config-specific — systems with `CONFIG_LEDS_TRIGGER_GPIO`
and device trees wiring gpio LED triggers to GPIO lines shared with
another driver (documented: SFP Mod_ABS/Rx_LOS). Not universal, but real
on network appliance hardware.

### Step 8.2: Trigger Conditions
**Record:**
- Another driver (e.g. SFP) claims the GPIO before LED gpio trigger
  activates.
- Common probe order on SFP platforms (SFP probes first).
- Not a security issue; unprivileged users cannot trigger this directly.

### Step 8.3: Failure Mode Severity
**Record:** Status LEDs silently non-functional. **Severity: LOW to
MEDIUM** — no crash, corruption, or deadlock, but broken hardware
indication on affected platforms.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Restores intended SFP/status LED behavior on shared-GPIO
  platforms; one-line fix following established kernel pattern.
- **Risk:** Very low — minimal, well-understood change.
- **Ratio:** Moderate benefit, very low risk. Fits hardware-
  quirk/workaround exception category.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR backport:**
- Real, verified bug with understood mechanism (EBUSY on shared GPIO →
  silent activation failure).
- Small, obviously correct, maintainer-reviewed fix.
- Buggy code and all prerequisites exist in 6.18.44.
- Established `GPIOD_FLAGS_BIT_NONEXCLUSIVE` pattern used widely in this
  tree.
- Hardware workaround for network appliance SFP LED use case.

**AGAINST backport:**
- Not a crash, security, corruption, or deadlock issue.
- Affects a narrow configuration (shared GPIO + gpio LED trigger).
- `GPIOD_FLAGS_BIT_NONEXCLUSIVE` is deprecated (though still the
  required workaround).
- No in-tree DTS found yet wiring SFP GPIOs to gpio LED triggers (use
  case may be out-of-tree/future DTS).

**UNRESOLVED:**
- Full mailing list review thread (fetch blocked).
- Whether any in-tree DTS currently triggers this exact SFP+gpio-trigger
  configuration.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mechanism verified in code;
   maintainer SOB; pattern proven across tree.
2. Fixes a real bug affecting users? **PASS** — shared-GPIO LED trigger
   silently fails.
3. Important issue? **PASS (borderline)** — not crash/security, but real
   hardware functionality loss on network appliances; fits hardware-
   workaround exception.
4. Small and contained? **PASS** — 1-line functional change.
5. No new features or APIs? **PASS** — fixes existing trigger behavior.
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected.

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — shared GPIO access between LED
trigger and another driver (SFP).

### Step 9.4: Decision Rationale
For the **6.18.44** tree checked out here: the bug exists, the fix is
minimal and follows a well-established kernel pattern, and it restores
broken status-LED functionality on real shared-GPIO hardware (SFP
network appliances). Severity is below crash/corruption tier, but stable
trees routinely accept such hardware-enablement GPIO sharing fixes.
Benefit outweighs the very low regression risk.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hardware-sharing bug
- [Phase 2] Read diff and `ledtrig-gpio.c`; verified EBUSY → silent
  failure path via `gpiolib.c:4672-4674` and `led-triggers.c:271-278`
- [Phase 3] `git blame`: buggy line from `9bbd6b7209cf1` (Nov 2023);
  trigger-sources from `4a11dbf04f31c` (Sep 2023)
- [Phase 3] `git log --oneline -20 -- drivers/leds/trigger/ledtrig-
  gpio.c`: no duplicate fix
- [Phase 3] `git show ec757001c818c`: NONEXCLUSIVE support since 2018
- [Phase 4] `b4 dig`: failed — commit not in tree
- [Phase 4] WebFetch lore/patch.msgid.link: blocked by Anubis
- [Phase 5] Traced `gpio_trig_activate` → `led_trigger_set` →
  `led_match_default_trigger` call chain
- [Phase 5] `grep GPIOD_FLAGS_BIT_NONEXCLUSIVE`: 30+ existing uses in
  tree
- [Phase 5] Read `sfp.c:3149-3150`: SFP claims GPIOs without
  NONEXCLUSIVE
- [Phase 6] `git describe HEAD`: v6.18.44-1-g2736c32da98b9
- [Phase 6] Confirmed buggy code at `ledtrig-gpio.c:89` without fix
- [Phase 6] `grep trigger-sources *.dts*`: USB router use cases present;
  no in-tree SFP+gpio-trigger DTS found
- [Phase 8] Confirmed `gpiod_not_found()` only maps `-ENOENT` to NULL,
  not `-EBUSY` (`gpiolib.h:221`)

**YES**The background search finished. It turned up related work
(Puzzle-M801 board DTS with SFP+, Broadcom PHY/SFP LED handling), but
nothing that changes the backport call.

**Verdict for this 6.18.44 tree: YES**

The gpio LED trigger fails silently when another driver (e.g. SFP for
Mod_ABS/Rx_LOS) already owns the GPIO. Adding
`GPIOD_FLAGS_BIT_NONEXCLUSIVE` is a one-line fix that matches an
established pattern elsewhere in the tree, and the buggy code is still
present at `ledtrig-gpio.c:89`.

 drivers/leds/trigger/ledtrig-gpio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-gpio.c b/drivers/leds/trigger/ledtrig-gpio.c
index 7f6a2352b0acd..3199275fd250b 100644
--- a/drivers/leds/trigger/ledtrig-gpio.c
+++ b/drivers/leds/trigger/ledtrig-gpio.c
@@ -86,7 +86,8 @@ static int gpio_trig_activate(struct led_classdev *led)
 	 * The generic property "trigger-sources" is followed,
 	 * and we hope that this is a GPIO.
 	 */
-	gpio_data->gpiod = gpiod_get_optional(dev, "trigger-sources", GPIOD_IN);
+	gpio_data->gpiod = gpiod_get_optional(dev, "trigger-sources",
+					      GPIOD_IN | GPIOD_FLAGS_BIT_NONEXCLUSIVE);
 	if (IS_ERR(gpio_data->gpiod)) {
 		ret = PTR_ERR(gpio_data->gpiod);
 		kfree(gpio_data);
-- 
2.53.0

