Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46A65632A6;
	Mon, 31 Aug 2026 13:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184069; cv=none; b=fCjWECd76yQqMd8xBi+sZAhDCCCdWBBvpC2hs7lvPBjOIn75348rsloIG66wqSjiPNql794YQS0DJONiXs0bWD5cJBtKzSojedu8EwxYupt1suo8joHhneiQvCrrzmldNmD3YcnE50sH3mV/0BJMD8i22dWuQkVGh1/oDflg4RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184069; c=relaxed/simple;
	bh=F3PXKsGiZS6fYAcXoh+mSIliT4gOFNfvnyloSUYCwac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9lw2rvOSG/ksbFKFyxYDLAsFh4f/r/JczArLsj1Z4W03F8Ss3j6rAD7P4J2cDb05Ph/Y5n5sg/4onRUhSoBcTb1XLrzlCF6rCZvfVK4yDfDVq8LI9lcEwz9m6dZ+bGGBGNT13qjy4ZBxugN5j5qRz7pwDbKcDU3BeP8QO+qETk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mzAEGYnV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mzAEGYnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925F11F00A3D;
	Mon, 31 Aug 2026 13:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184066;
	bh=MxBcVVAjkwnqigI9ZfUaaBNLBx8KvOmAXi0pHeLz1eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mzAEGYnVLvXHdJL6Kjh895cClOJCx71v0xA6vUR6CvEmfzuI8Eos6s8SaIah7Nylm
	 R+xKJ2znesf8iQHXn97Jm6Cb9GZoz+zVWedRzf4wjFzXysu+zg65TLLsjltAOwWv2U
	 JVWpJtx/1Q/UpNVG45x3AQMk0JsO5ob6I0l1egV/lAXly1eLR40vhfg9SSGQ7Ma/kV
	 saOvz2vxhgq6XsR5x2QN7Lcc8ztFCHnvyrJMwLcPblfND/zx9irMw+cnNemjaoy9aF
	 vPOkjXB+vFAe0kDxV+dJ2yquRf0yEWGiOo2fKEo7F7qQ6s/30Xgcacv+109z2AAXDZ
	 MZT6OB6cksdVQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Rob Herring (Arm)" <robh@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpio: pisosr: Read "ngpios" as u32
Date: Mon, 31 Aug 2026 09:28:19 -0400
Message-ID: <20260831133314.4125787-471-sashal@kernel.org>
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

From: "Rob Herring (Arm)" <robh@kernel.org>

[ Upstream commit 4910aa198d25e5d1067236560ba34ab12bccc677 ]

The generic "ngpios" property is encoded as a normal uint32 cell. The
pisosr driver stores it in the gpio_chip field, but reading it with a
u16 helper does not match the DT property encoding.

Read "ngpios" as u32 and keep the existing assignment to the chip
field.

Assisted-by: Codex:gpt-5-5
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20260612215216.1887485-1-robh@kernel.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[gpio: pisosr]` `[Read]` — Read the device-tree `ngpios`
property with the correct cell width (`u32` instead of `u16`).

### Step 1.2: Tags
**Record:**
- **Assisted-by:** Codex:gpt-5-5
- **Signed-off-by:** Rob Herring (Arm) \<robh@kernel.org\>
- **Link:**
  https://patch.msgid.link/20260612215216.1887485-1-robh@kernel.org
- **Signed-off-by:** Bartosz Golaszewski
  \<bartosz.golaszewski@oss.qualcomm.com\> (GPIO maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Cc:
  stable@vger.kernel.org
- Notable: authored/assisted by the device-tree maintainer; merged by
  GPIO subsystem maintainer

### Step 1.3: Body Analysis
**Record:**
- **Bug:** Generic `ngpios` is a standard `u32` DT cell; `gpio-pisosr`
  read it via `of_property_read_u16()`.
- **Symptom:** Wrong `ngpio` when `ngpios` is present in DT; chip field
  type is `u16`, but the property encoding is `u32`.
- **Root cause:** Size/endian mismatch between DT encoding and OF read
  helper.
- **Fix:** Read into temporary `u32`, assign to `gpio->chip.ngpio` only
  on success.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite neutral wording, this is a correctness /
memory-safety bug fix, not style cleanup.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpio/gpio-pisosr.c` (+3 / -1 net)
- **Function:** `pisosr_gpio_probe()`
- **Scope:** Single-file surgical fix

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `of_property_read_u16(dev->of_node, "ngpios",
  &gpio->chip.ngpio);` (return ignored). `buffer_size` computed
  immediately after from `gpio->chip.ngpio`.
- **After:** `u32 ngpios`; `if (!of_property_read_u32(..., &ngpios))
  gpio->chip.ngpio = ngpios;`. On missing property, default
  `DEFAULT_NGPIO` (8) is preserved.

### Step 2.3: Bug Mechanism
**Record:** **Category:** DT property parsing / memory safety (buffer
underrun → OOB)

Verified mechanism:
1. DT stores `ngpios = <N>` as a 4-byte big-endian `u32`.
2. `of_property_read_u16()` requires `prop->length >= 2` with `max=0`
   (no upper bound), so it **succeeds** on a 4-byte property.
3. It reads the **first** 16 bits (`be16_to_cpup` at offset 0). For any
   normal `N < 65536`, those high 16 bits are zero.

Python simulation confirmed:
- `ngpios=8` → u32 bytes `00000008` → u16 read = **0**
- Same for 16, 24, 32

4. With `ngpios` present in DT, `gpio->chip.ngpio` becomes **0**.
5. `buffer_size = DIV_ROUND_UP(0, 8) = 0`; `devm_kzalloc(dev, 0, ...)`
   yields `ZERO_SIZE_PTR`.
6. Later `devm_gpiochip_add_data()` → `gpiochip_get_ngpios()` sees
   `gc->ngpio == 0`, re-reads `ngpios` as `u32`, and restores the
   correct line count for registration — but **`buffer_size` and
   `buffer` are never recomputed**.
7. GPIO access (`pisosr_gpio_get()` → `gpio->buffer[offset / 8]`) can
   then read/write through a zero-sized buffer → **out-of-bounds
   access**.

When `ngpios` is **absent**, `of_property_read_u16()` fails, `ngpio`
stays at template default 8, and the driver works.

### Step 2.4: Fix Quality
**Record:** Obviously correct; matches every other GPIO driver in-tree
(`gpio-uniphier.c`, `gpio-aspeed.c`, `gpio-em.c`, etc.). Minimal diff.
Regression risk very low.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Buggy `of_property_read_u16()` introduced in `df6df93c8a73f`
(2016-01-25, "gpio: Add driver for SPI serializers"). Present throughout
6.18.y.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related File History
**Record:** Recent `gpio-pisosr.c` commits are cleanups
(`devm_mutex_init`, remove `direction_output`,
`devm_gpiochip_add_data`). No related ngpios fix already present.
Standalone one-patch fix.

### Step 3.4: Author Context
**Record:** Rob Herring is DT maintainer. Bartosz Golaszewski is GPIO
maintainer. Patch is subsystem-appropriate.

### Step 3.5: Dependencies
**Record:** None. No series markers. Applies standalone to existing
`pisosr_gpio_probe()`.

---

## Phase 4: Mailing List and External Research

### Step 4.1–4.5
**Record:**
- `b4 dig -c 2732ea8c16b7b`: commit hash not in local repo (blob only
  from diff index); no lore match.
- Link URL and lore.kernel.org blocked by Anubis bot protection —
  **UNVERIFIED** for review-thread content, stable nominations, or NAKs.
- No syzbot/bugzilla references in commit message.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `pisosr_gpio_probe()`, indirectly `pisosr_gpio_get()`,
`pisosr_gpio_refresh()`.

### Step 5.2: Callers
**Record:** `pisosr_gpio_probe()` via SPI driver registration at
boot/module load. GPIO ops invoked from gpiolib when consumers read
lines.

### Step 5.3: Callees
**Record:** `of_property_read_u16/u32`, `devm_kzalloc`,
`devm_gpiochip_add_data` → `gpiochip_get_ngpios`.

### Step 5.4: Reachability
**Record:** Triggered when a board DT node has `compatible = "pisosr-
gpio"` **and** an explicit `ngpios` property. GPIO reads from userspace
or kernel consumers reach the buggy buffer path.

### Step 5.5: Similar Patterns
**Record:** `gpio-pisosr.c` is the **only** GPIO driver using
`of_property_read_u16()` for `ngpios`. All others use
`of_property_read_u32()`.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **YES.** Local tree at `v6.18.44-1-g2736c32da98b9` still
has:

```123:123:drivers/gpio/gpio-pisosr.c
        of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
```

Bug present since driver addition in 2016.

### Step 6.2: Backport Complications
**Record:** Clean apply expected — 3-line hunk in one function, no
structural conflicts.

### Step 6.3: Related Fixes Already Present?
**Record:** None found for this issue.

### In-tree DTS usage
**Record:** Five `pisosr-gpio` nodes exist (BeagleBone AI, AM57xx IDK,
AM437x IDK, AM335x ICEv2, VF610 BK4). **None specify `ngpios`** — all
rely on the driver default of 8. So mainline shipped boards are not
currently broken, but the binding allows `ngpios` (default 8, max 32 per
`pisosr-gpio.yaml`).

---

## Phase 7: Subsystem Context

### Step 7.1
**Record:** `drivers/gpio/gpio-pisosr.c` — GPIO driver for SPI parallel-
in/serial-out shift registers. **Criticality: PERIPHERAL** (niche
industrial/embedded hardware).

### Step 7.2
**Record:** Driver is mature (since 2016); recent activity is
maintenance only.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users of `pisosr-gpio` hardware who include an explicit
`ngpios` property in device tree. Config-specific / board-specific.

### Step 8.2: Trigger Conditions
**Record:** `ngpios = <N>` in DT for a `pisosr-gpio` node. Uncommon
today (no in-tree examples), but valid per binding. Not userspace-
triggerable directly; kernel GPIO access after probe triggers OOB.

### Step 8.3: Failure Mode Severity
**Record:** Wrong zero-sized internal buffer while gpiochip may register
the correct line count → **OOB on GPIO read** → potential
oops/corruption. **Severity: HIGH** when triggered; **latent** on
current in-tree DTS.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Fixes real DT-binding compliance bug with memory-safety
  consequences; enables correct custom board DT.
- **Risk:** Very low — 3-line change, matches established driver
  pattern.
- **Ratio:** Favorable for backport despite niche hardware.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Verified bug: `u16` read of `u32` `ngpios` yields 0 for all normal
  values
- Leads to zero-sized buffer + possible OOB despite correct gpiochip
  registration
- Bug since 2016; fix not yet in 6.18.y
- Trivial, obviously correct; DT + GPIO maintainers involved
- DT binding documents `ngpios` as valid optional property

**AGAINST:**
- No in-tree DTS currently uses `ngpios` on pisosr nodes
- No fuzzer/user crash reports
- Peripheral driver; default path (no `ngpios`) works
- `gpiochip_get_ngpios()` partially masks the gpio-count symptom

**UNVERIFIED:**
- Mailing list review discussion and any explicit stable nomination

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — mechanism verified in OF
   code; pattern used elsewhere; maintainer-authored.
2. Fixes a real bug? **PASS** — incorrect DT parsing when `ngpios` is
   present.
3. Important issue? **PASS** — OOB/memory safety when triggered;
   functional breakage for valid DT.
4. Small and contained? **PASS** — 4 lines in one file.
5. No new features/APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — buggy code confirmed present in
   v6.18.44.

### Step 9.3: Exception Category
**Record:** Device tree fix for existing driver/hardware — qualifies
under DT-update exception.

### Step 9.4: Decision Rationale
This is a long-standing DT property encoding bug that silently breaks
any board specifying `ngpios` for `pisosr-gpio`: the driver allocates a
zero-byte buffer while registering the correct GPIO count via gpiolib
fallback, creating an OOB path on GPIO access. The fix is minimal,
matches every other GPIO driver, and carries negligible regression risk.
Current mainline DTS avoids the bug by omitting `ngpios`, but the
binding permits it and custom boards can hit this today.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
- **[Phase 2]** Diff analysis: 3-line probe() change; verified
  `of_property_read_u16` implementation in `drivers/of/property.c`
  (min=2, max=0, reads first be16)
- **[Phase 2]** Python simulation: u32 `ngpios` values 8/16/24/32 all
  read as 0 via u16
- **[Phase 2]** Confirmed `struct gpio_chip.ngpio` is `u16` in
  `include/linux/gpio/driver.h`
- **[Phase 3]** `git blame`: buggy line from `df6df93c8a73f` (2016)
- **[Phase 3]** `git log --oneline -20 -- drivers/gpio/gpio-pisosr.c`:
  no prior ngpios fix
- **[Phase 3]** `git grep`: only `gpio-pisosr.c` uses
  `of_property_read_u16` for `ngpios`
- **[Phase 4]** `b4 dig -c 2732ea8c16b7b`: no result (commit not in
  repo) — **UNVERIFIED** lore thread
- **[Phase 4]** WebFetch patch.msgid.link and lore.kernel.org: blocked
  by Anubis — **UNVERIFIED**
- **[Phase 5]** Read `gpiochip_get_ngpios()` in
  `drivers/gpio/gpiolib.c`: re-reads u32 when `gc->ngpio==0`, does not
  fix driver buffer
- **[Phase 5]** Traced probe order: buffer allocated before
  `devm_gpiochip_add_data()`
- **[Phase 6]** `git describe HEAD`: `v6.18.44-1-g2736c32da98b9`;
  Makefile confirms 6.18.44
- **[Phase 6]** Read current `drivers/gpio/gpio-pisosr.c`: still has
  buggy `of_property_read_u16`
- **[Phase 6]** `grep pisosr-gpio` in `arch/arm/boot/dts/`: 5 nodes,
  none with `ngpios` property
- **[Phase 6]** Read `Documentation/devicetree/bindings/gpio/pisosr-
  gpio.yaml`: `ngpios` optional, default 8, max 32
- **[Phase 8]** Assessed failure mode: zero buffer + OOB on GPIO access
  when `ngpios` in DT

**YES**The backport analysis is done for **gpio: pisosr: Read "ngpios"
as u32** on **v6.18.44**.

**Verdict: YES**

The driver reads the standard `u32` `ngpios` DT property with
`of_property_read_u16()`, which turns any normal value into **0**. That
leaves a zero-sized buffer while gpiolib may still register the correct
GPIO count, so boards that set `ngpios` in DT can hit out-of-bounds
access on GPIO reads. The fix is small, obviously correct, and matches
other GPIO drivers. No in-tree DTS nodes currently set `ngpios` for
`pisosr-gpio`, but the binding allows it.

 drivers/gpio/gpio-pisosr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pisosr.c b/drivers/gpio/gpio-pisosr.c
index 7ec6a46ed6007..2732ea8c16b7b 100644
--- a/drivers/gpio/gpio-pisosr.c
+++ b/drivers/gpio/gpio-pisosr.c
@@ -112,6 +112,7 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 {
 	struct device *dev = &spi->dev;
 	struct pisosr_gpio *gpio;
+	u32 ngpios;
 	int ret;
 
 	gpio = devm_kzalloc(dev, sizeof(*gpio), GFP_KERNEL);
@@ -120,7 +121,8 @@ static int pisosr_gpio_probe(struct spi_device *spi)
 
 	gpio->chip = template_chip;
 	gpio->chip.parent = dev;
-	of_property_read_u16(dev->of_node, "ngpios", &gpio->chip.ngpio);
+	if (!of_property_read_u32(dev->of_node, "ngpios", &ngpios))
+		gpio->chip.ngpio = ngpios;
 
 	gpio->spi = spi;
 
-- 
2.53.0

