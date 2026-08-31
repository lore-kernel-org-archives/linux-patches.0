Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9334D2ECF;
	Mon, 31 Aug 2026 13:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183552; cv=none; b=Pu89KUdWFloH5PYaoFI/ylcVnOT6WxHM1D9QLA9yM7Bsfyk1fV1WjOrUD5Af2tFJm10938LPOq/5/Ia6/2ZIjUuXyI+xCWEaEqLfRurVqhzkE5hWNIsmgjYH/YkYRTkFIdWQIJUw/9pOUvL8TPF9h8h6TlRMJ0lNsmgjp5tUoWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183552; c=relaxed/simple;
	bh=0XsVvKqzClDxE3pPtdVUtM3v+FIpI7sz7HeXr7yHpNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kgXXnKs492tMYj/sqzEpinjUIPWOxZbA9H2vjt+QAXbmFUKlpldidNW6Wx1uKeaS0NckI9F8rsTDTVuI/dm762lSdkwj1z/FoUHYeMH95zWExPBPMjdXpvCULsbZfw7cuYEhVorfs44cumer3qQhQsLaDKdjTcoIk5AUmn0F+C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MubOgp/p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MubOgp/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C11F000E9;
	Mon, 31 Aug 2026 13:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183549;
	bh=ubcilX10XsCkRyDH2cvUO4AwIqCV8LoAk71EABItaLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MubOgp/pAPreaCavnkA9WQ2Abg7vtAxupQl5+LoqYyboi3q8i6uxyRAIWVb09qHWH
	 V6oo6VvkMujO0LhGkSzX6Ys+PqA20NJInzvoJbfC2chNJeO1HXbcF8eTFqHsUYkplb
	 EatZNkugiRQQf3OXcGuTUzNH7eehD0KTOFsF+1u6shKANozxq+RZR1DnD/ScF8rHkc
	 Lpy/rs6sAv1cboRFDU6SrjAFuhi4ALGoZF3YKNpG/1JQSSpN7CdKi29ZPD+gh2XgpV
	 uMCmIjHwizXGZj/6MJocJuwZYVjdU/S/u7z8NmyqLJD1VFmDW0hWrBJiz5y3nlvEOC
	 huCK2Ayz4h0Nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Miao Li <limiao@kylinos.cn>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] iio: light: stk3310: Deal with the ps interrupt issue in PM
Date: Mon, 31 Aug 2026 09:23:11 -0400
Message-ID: <20260831133314.4125787-163-sashal@kernel.org>
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

From: Miao Li <limiao@kylinos.cn>

[ Upstream commit 9c1d639e90cf42f5c1401f91f38ffd89af6dd970 ]

On the Inspur HS326 laptop(which integrated with HiSilicon M900
processor), if the STK3311-X chip's PS interrupt is configured
in "Recommended interrupt mode", the interrupt cannot be triggered
normally after waking from suspend or hibernation.

In this case, neither disabling and re-enabling the interrupt nor
resetting the PS threshold register can restore the interrupt to
normal operation.

If the interrupt is disabled in suspend() then reset the PS threshold
register and enable the interrupt in resume(). This resolves the issue.

Signed-off-by: Miao Li <limiao@kylinos.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[iio: light: stk3310]` `[Deal with]` — PM workaround for
proximity-sensor (PS) interrupt handling across suspend/resume.

**Step 1.2 — Tags**

Record:
- **Signed-off-by:** Miao Li `<limiao@kylinos.cn>` (author)
- **Signed-off-by:** Jonathan Cameron `<jic23@kernel.org>` (IIO
  maintainer)
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-
  by:`, `Link:`, or `Cc: stable@vger.kernel.org` tags (expected for
  manual review)

**Step 1.3 — Body analysis**

Record:
- **Bug:** On Inspur HS326 (HiSilicon M900) with STK3311-X, PS
  interrupts in "Recommended interrupt mode" stop firing after
  suspend/hibernation.
- **Symptom:** Proximity threshold interrupts never resume; userspace
  cannot get proximity events after wake.
- **Root cause (author):** Standby-only PM is insufficient; the chip
  needs PS interrupt disabled before suspend, PS threshold registers
  rewritten, and interrupt re-enabled on resume.
- **Versions:** Not specified in the message; hardware-specific report.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Although not labeled "fix", this is a real
suspend/resume functional bug. It also tightens error handling in
`stk3310_write_event()`, `stk3310_write_event_config()`, and
`stk3310_init()` (explicit error returns and state tracking).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/iio/light/stk3310.c` — ~69 insertions, ~7 deletions
- **Functions modified:** `stk3310_write_event()`,
  `stk3310_write_event_config()`, `stk3310_init()`, `stk3310_suspend()`,
  `stk3310_resume()`
- **Struct modified:** `stk3310_data` (+`ps_int_enabled`, `ps_thdl`,
  `ps_thdh`)
- **Scope:** Single-file, surgical driver PM fix

**Step 2.2 — Code flow changes**

Record:
- **`stk3310_write_event()`:** Before: wrote threshold register,
  returned error code without tracking. After: tracks
  `ps_thdl`/`ps_thdh` in software on successful writes.
- **`stk3310_write_event_config()`:** Before: wrote interrupt enable,
  returned `ret`. After: tracks `ps_int_enabled`, explicit unlock+return
  on error.
- **`stk3310_init()`:** Before: enabled PS interrupt, returned `ret`
  (could be non-zero on success path confusion). After: sets
  `ps_int_enabled=true`, `ps_thdh=STK3310_PS_MAX_VAL`, returns 0 on
  success.
- **`stk3310_suspend()`:** Before: only `stk3310_set_state(STANDBY)`.
  After: disables PS interrupt first if enabled, then standby.
- **`stk3310_resume()`:** Before: only restored ALS/PS enable state.
  After: restores state, rewrites threshold registers from cached
  values, re-enables PS interrupt.

**Step 2.3 — Bug mechanism**

Record: **Hardware PM quirk / incomplete PM restore (category h).** The
driver's suspend/resume since 2015 only toggled sensor standby/enable
bits. It did not manage PS interrupt configuration or threshold
registers across PM cycles. On STK3311-X (Inspur HS326), this leaves the
interrupt path broken after wake.

**Step 2.4 — Fix quality**

Record: **Obviously correct** for the described hardware issue. Minimal
state cache mirrors what userspace/driver already configured. Low
regression risk: operations are gated on `ps_int_enabled` and non-
default threshold values. No new APIs, no locking changes beyond clearer
error-path unlock in `write_event_config()`.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: Suspend/resume introduced in `be9e6229d67696` ("iio: light: Add
support for Sensortek STK3310", 2015-04-27). The incomplete PM behavior
has been present since driver introduction. Present in this tree at
lines 671–692.

**Step 3.2 — Fixes: tag**

Record: **N/A** — no `Fixes:` tag.

**Step 3.3 — Related file history**

Record: Recent `stk3310.c` changes in this tree are cleanups
(`7804363d596a8` simplify write_event_config, `a50f537002096` stk3013
support, chip-ID relaxations). No prior fix for this PM interrupt issue.
Fix is **standalone** (patch 1/3 of v4 series; patches 2/3 are style
cleanups only).

**Step 3.4 — Author context**

Record: Miao Li is not a frequent stk3310 contributor in this tree.
Jonathan Cameron (IIO maintainer) Signed-off-by on upstream commit
`9c1d639e90cf4`.

**Step 3.5 — Dependencies**

Record: **None.** Self-contained. Upstream commit `9c1d639e90cf4`
(2026-05-31) applies cleanly to current HEAD (`git apply --check`
succeeded). Not yet in HEAD (`v6.18.44`); present on `autosel` branch as
backport candidate `b0cd7204e0d7f`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 9c1d639e90cf4` matched v4 submission:
- https://patch.msgid.link/20260504030408.105762-2-limiao870622@163.com
- Series revisions: v1 (2026-04-27) → v2 → v3 → v4 (2026-05-04, 3-patch
  series)
- Applied version is latest v4 patch 1/3

**Step 4.2 — Reviewers**

Record: `b4 dig -w` CC'd Jonathan Cameron (`jic23@kernel.org`), Andy
Shevchenko, linux-iio, linux-kernel. Jonathan Cameron Signed-off-by on
merged commit confirms maintainer acceptance. No explicit stable
nomination found in fetched lore pages (lore.kernel.org blocked by bot
protection; lkml.iu.edu provided patch content only).

**Step 4.3 — Bug report**

Record: Hardware-specific report from author on Inspur HS326 / HiSilicon
M900. No syzbot, bugzilla, or multi-user Reported-by tags. Severity from
reporter: proximity interrupts permanently broken after suspend until
reboot.

**Step 4.4 — Series context**

Record: v4 0/3 cover describes patch 1 as the interrupt fix; patches 2/3
are `uint32_t`→`u32`/padding and `sizeof()` cleanups — **not required**
for the bug fix.

**Step 4.5 — Stable list**

Record: **Not searched successfully** on lore stable list (bot
protection). No evidence found against backport.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `stk3310_suspend()`, `stk3310_resume()`,
`stk3310_write_event()`, `stk3310_write_event_config()`,
`stk3310_init()`, IRQ path `stk3310_irq_event_handler()`.

**Step 5.2 — Callers**

Record:
- `stk3310_suspend/resume` — called via `DEFINE_SIMPLE_DEV_PM_OPS` on
  system suspend/resume (common laptop path).
- `stk3310_write_event/write_event_config` — IIO userspace ioctl/event
  interface (`stk3310_info` ops table).
- `stk3310_init` — called from `stk3310_probe()` during device
  enumeration.

**Step 5.3 — Callees**

Record: `regmap_field_write()`, `regmap_bulk_write()`,
`stk3310_set_state()` — standard regmap/I2C register access, no exotic
dependencies.

**Step 5.4 — Reachability**

Record: Triggered on every system suspend/resume cycle on machines with
STK3310/STK3311 and IRQ wired (`client->irq > 0` in probe). Userspace
proximity event consumers are affected. Not a syscall crash path, but a
common PM path on affected laptops.

**Step 5.5 — Similar patterns**

Record: Other IIO light drivers in this tree implement suspend/resume
state preservation (e.g., `ltr501`, `cm3232`, `al3010`). The stk3310
driver was missing interrupt/threshold restore — an outlier compared to
peers.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`). Current `stk3310_suspend()` only calls
`stk3310_set_state(STANDBY)`; `stk3310_resume()` only restores ALS/PS
enable bits. No `ps_int_enabled`/`ps_thdl`/`ps_thdh` fields exist. Bug
present since driver introduction (2015).

**Step 6.2 — Backport complications**

Record: **Clean apply expected.** `git show 9c1d639e90cf4 --
drivers/iio/light/stk3310.c | git apply --check` succeeded on HEAD. No
conflicting recent PM refactors in this file.

**Step 6.3 — Related fixes already present?**

Record: **No.** `git log --grep` found no prior stk3310 PM interrupt fix
in this tree. Grep confirms `ps_int_enabled` absent.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem**

Record: **drivers/iio/light** — IIO ambient-light/proximity sensor
driver. Criticality: **PERIPHERAL** (hardware-specific), but
suspend/resume is a core laptop PM concern for affected machines.

**Step 7.2 — Activity**

Record: IIO light subsystem actively maintained in 6.18.y (recent fixes
for si1133 races, opt3001 timeout, veml6030 events, etc.). stk3310
itself had minor cleanups but no PM fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Users of hardware with STK3310/STK3311/STK3311-X proximity
sensor and IRQ configured — specifically reported on Inspur HS326
(HiSilicon M900). Config-dependent: `CONFIG_STK3310` + device present +
IRQ > 0.

**Step 8.2 — Trigger conditions**

Record: System suspend or hibernation, then resume. **Common** on
laptops. Unprivileged users can trigger via standard PM. Not a race —
deterministic hardware PM bug.

**Step 8.3 — Failure mode severity**

Record: Proximity sensor interrupts stop working after resume; ALS may
still function. No kernel oops, deadlock, or data corruption. Userspace
proximity-dependent features (screen blanking during calls,
lid/proximity policies) break until reboot. **Severity: MEDIUM**
(functional regression on PM path, not CRITICAL crash).

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Restores proximity interrupt functionality after suspend
  on affected hardware; low user count but 100% reproducible on those
  machines.
- **Risk:** Very low — ~70 lines, single driver, gated operations,
  maintainer-reviewed.
- **Ratio:** Favorable for stable — classic hardware PM quirk/workaround
  pattern.

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real, reproducible hardware bug on production laptop (Inspur HS326)
- Suspend/resume PM quirk — established stable category
- Small, self-contained, maintainer Signed-off-by
- Driver and buggy code exist in 6.18.44 since 2015
- Applies cleanly to this tree
- Standalone (no series dependencies)

**AGAINST backport:**
- Not crash/security/corruption/deadlock
- Narrow hardware scope (STK3311-X on specific platforms)
- Long-standing bug (not a recent regression)
- No syzbot or multi-user reports

**Unresolved:** No explicit `Cc: stable` or reviewer stable nomination
found; full lore review thread not readable due to bot protection.

**Step 9.2 — Stable rules checklist**

| Criterion | Result |
|-----------|--------|
| 1. Obviously correct and tested? | **PASS** — clear PM sequence,
maintainer SOB, hardware-verified |
| 2. Fixes real bug affecting users? | **PASS** — proximity interrupts
broken after suspend on real hardware |
| 3. Important issue? | **PASS (borderline)** — functional PM regression
on laptops, not crash-level |
| 4. Small and contained? | **PASS** — one file, ~76 lines |
| 5. No new features/APIs? | **PASS** — internal state tracking for
existing functionality |
| 6. Applies to local tree? | **PASS** — verified clean apply to 6.18.44
|

**Step 9.3 — Exception category**

Record: **Hardware quirk/workaround** for suspend/resume on STK3311-X —
fits the stable exception for device-specific PM workarounds.

**Step 9.4 — Decision rationale**

This commit fixes a real suspend/resume hardware interaction bug in a
driver that has been in stable kernels since v4.1. While the failure
mode is functional rather than a kernel crash, proximity sensor
interrupts are user-visible and the bug triggers on every suspend cycle
on affected laptops. The fix is small, maintainer-approved, applies
cleanly to Linux 6.18.44, and follows the established pattern of
backporting driver PM quirks for real hardware.

---

## Verification

- [Phase 1] Parsed commit message and tags from user-provided diff and
  `git show 9c1d639e90cf4`
- [Phase 2] Diff analysis: 1 file, 5 functions, PM state-tracking +
  suspend/resume sequence
- [Phase 3] `git blame -L 671,692`: suspend/resume from `be9e6229d67696`
  (2015-04-27)
- [Phase 3] `git log --oneline -20 -- drivers/iio/light/stk3310.c`: no
  prior PM interrupt fix
- [Phase 3] `git show 9c1d639e90cf4`: upstream commit dated 2026-05-31,
  Jonathan Cameron SOB
- [Phase 3] `git merge-base --is-ancestor b0cd7204e0d7f HEAD` → not
  ancestor; fix not in HEAD
- [Phase 4] `b4 dig -c 9c1d639e90cf4`: lore URL found, v1–v4 revisions
- [Phase 4] `b4 dig -c 9c1d639e90cf4 -w`: jic23@kernel.org CC'd
- [Phase 4] `b4 dig -c 9c1d639e90cf4 -a`: v4 is latest, patch 1/3 is the
  fix
- [Phase 4] lkml.iu.edu: fetched v4 cover and patch 1/3 content
- [Phase 5] Read `stk3310.c`: PM ops, IRQ probe path, IIO event ops
  confirmed
- [Phase 5] `iio_device_alloc()` uses `kzalloc()` — `ps_thdl` defaults
  to 0 verified
- [Phase 6] `git describe HEAD` → v6.18.44; `make kernelversion` →
  6.18.44
- [Phase 6] Grep: no `ps_int_enabled` in current tree — buggy code
  present, fix absent
- [Phase 6] `git show 9c1d639e90cf4 -- drivers/iio/light/stk3310.c | git
  apply --check` → clean apply
- [Phase 8] Failure mode: proximity interrupts dead after resume,
  severity MEDIUM
- UNVERIFIED: Full lore review thread replies (bot protection on
  lore.kernel.org/patch.msgid.link)
- UNVERIFIED: Whether Jonathan Cameron explicitly nominated for stable
  in list replies

**YES**

 drivers/iio/light/stk3310.c | 76 +++++++++++++++++++++++++++++++++----
 1 file changed, 69 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/light/stk3310.c b/drivers/iio/light/stk3310.c
index a75a83594a7ee..3be6934218866 100644
--- a/drivers/iio/light/stk3310.c
+++ b/drivers/iio/light/stk3310.c
@@ -117,6 +117,9 @@ struct stk3310_data {
 	struct mutex lock;
 	bool als_enabled;
 	bool ps_enabled;
+	bool ps_int_enabled;
+	uint32_t ps_thdl;
+	uint32_t ps_thdh;
 	uint32_t ps_near_level;
 	u64 timestamp;
 	struct regmap *regmap;
@@ -296,10 +299,17 @@ static int stk3310_write_event(struct iio_dev *indio_dev,
 
 	buf = cpu_to_be16(val);
 	ret = regmap_bulk_write(data->regmap, reg, &buf, 2);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to set PS threshold!\n");
+		return ret;
+	}
 
-	return ret;
+	if (reg == STK3310_REG_THDH_PS)
+		data->ps_thdh = val;
+	else
+		data->ps_thdl = val;
+
+	return 0;
 }
 
 static int stk3310_read_event_config(struct iio_dev *indio_dev,
@@ -331,11 +341,17 @@ static int stk3310_write_event_config(struct iio_dev *indio_dev,
 	/* Set INT_PS value */
 	mutex_lock(&data->lock);
 	ret = regmap_field_write(data->reg_int_ps, state);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to set interrupt mode\n");
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	data->ps_int_enabled = state;
+
 	mutex_unlock(&data->lock);
 
-	return ret;
+	return 0;
 }
 
 static int stk3310_read_raw(struct iio_dev *indio_dev,
@@ -504,10 +520,15 @@ static int stk3310_init(struct iio_dev *indio_dev)
 
 	/* Enable PS interrupts */
 	ret = regmap_field_write(data->reg_int_ps, STK3310_PSINT_EN);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(&client->dev, "failed to enable interrupts!\n");
+		return ret;
+	}
 
-	return ret;
+	data->ps_int_enabled = true;
+	data->ps_thdh = STK3310_PS_MAX_VAL;
+
+	return 0;
 }
 
 static bool stk3310_is_volatile_reg(struct device *dev, unsigned int reg)
@@ -671,9 +692,18 @@ static void stk3310_remove(struct i2c_client *client)
 static int stk3310_suspend(struct device *dev)
 {
 	struct stk3310_data *data;
+	int ret;
 
 	data = iio_priv(i2c_get_clientdata(to_i2c_client(dev)));
 
+	if (data->ps_int_enabled) {
+		ret = regmap_field_write(data->reg_int_ps, 0x0);
+		if (ret < 0) {
+			dev_err(dev, "failed to disable ps int at suspend.\n");
+			return ret;
+		}
+	}
+
 	return stk3310_set_state(data, STK3310_STATE_STANDBY);
 }
 
@@ -681,6 +711,8 @@ static int stk3310_resume(struct device *dev)
 {
 	u8 state = 0;
 	struct stk3310_data *data;
+	__be16 buf;
+	int ret;
 
 	data = iio_priv(i2c_get_clientdata(to_i2c_client(dev)));
 	if (data->ps_enabled)
@@ -688,7 +720,37 @@ static int stk3310_resume(struct device *dev)
 	if (data->als_enabled)
 		state |= STK3310_STATE_EN_ALS;
 
-	return stk3310_set_state(data, state);
+	ret = stk3310_set_state(data, state);
+	if (ret < 0)
+		return ret;
+
+	if (data->ps_thdl != 0x0) {
+		buf = cpu_to_be16(data->ps_thdl);
+		ret = regmap_bulk_write(data->regmap, STK3310_REG_THDL_PS, &buf, 2);
+		if (ret < 0) {
+			dev_err(dev, "failed to set reg THDL_PS at resume.\n");
+			return ret;
+		}
+	}
+
+	if (data->ps_thdh != STK3310_PS_MAX_VAL) {
+		buf = cpu_to_be16(data->ps_thdh);
+		ret = regmap_bulk_write(data->regmap, STK3310_REG_THDH_PS, &buf, 2);
+		if (ret < 0) {
+			dev_err(dev, "failed to set reg THDH_PS at resume.\n");
+			return ret;
+		}
+	}
+
+	if (data->ps_int_enabled) {
+		ret = regmap_field_write(data->reg_int_ps, STK3310_PSINT_EN);
+		if (ret < 0) {
+			dev_err(dev, "failed to enable ps int at resume.\n");
+			return ret;
+		}
+	}
+
+	return 0;
 }
 
 static DEFINE_SIMPLE_DEV_PM_OPS(stk3310_pm_ops, stk3310_suspend,
-- 
2.53.0

