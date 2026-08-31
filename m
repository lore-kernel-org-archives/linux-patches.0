Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA134766AB;
	Mon, 31 Aug 2026 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183336; cv=none; b=f0bUixa3HT2+FK1GB7Z2vi1+w4CoyYxD4Z36wLbp06o48BhOFhzFlqIkLtCPY+7Dhu62UgFnOT2gnuD2tUO8lC+nijD2uaX3XlQi0acsXbc+zvu7SIyhKKR8GSzgHsAAJl1eFmtJWgDDFxjqzqlr66utXl8NX3JqeTq/FfaQKxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183336; c=relaxed/simple;
	bh=Ji3iuCbt85ZOnV7oyha6glxbxHK50IsmotDAdsBlp3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oALOHXaQnb3FlLYPxttEyvsVBL9rBf63MXoHaCa/1vgWt0FC2iHnyc5VDlxWrDEBgZcSv6oP7g3E4Q+TQF4bwAy0zHY1e72BHpgj0SiqBCiYJdfKkH5C922dSu/AosN3NOEFHZqqMoYPm70+GnaWMXEqWKFtNujzgfAlknjb+mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMCwncYk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMCwncYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F571F00A3E;
	Mon, 31 Aug 2026 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183334;
	bh=dyqWhSF0HVROorFdmbzrMiaIDT7tFT1lvgaoCfGYIDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMCwncYkoez6m149pRqUKZvocUcqSDoZJRlovyFAsLUTaw0FCsV6Vi31y1zzZ3mBQ
	 ZREMpcpw917V4z94t1lyqBZL/psIk0UxIOVfc1ckK6gJY28+UNbZkGmVAN44lI46F9
	 j4H2G21mXFfg3Eo+zZg09HHvkl1YIhMz3giRGt+MWxQ6XC9ViPWrjo/k2ZQ3z7ynDR
	 6XP9OvQXidj4kGiPzrY8S+2z7sDsWcwFjauxpwL8lt8QFLtAkoMWGXBn7P5WM3oLQ0
	 gKCQr26XCO1Kk8uXHiqeAwP0HcC+55WjlfmZo6ce7z74Ix8moMTflupehQRUti2uIe
	 da8FABIVDr/pg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iio: accel: mma8452: switch to non-devm request_threaded_irq()
Date: Mon, 31 Aug 2026 09:21:54 -0400
Message-ID: <20260831133314.4125787-86-sashal@kernel.org>
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

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

[ Upstream commit 0a6726ec20cd4c0101f2de0ca485a11676224dea ]

Avoid using devm_request_threaded_irq() as the driver requires explicit
error-handling path(s). Using devm_* API together with goto-based
unwinding breaks the expected LIFO resource release model.

Add explicit IRQ cleanup in the driver teardown paths to follow kernel
resource management conventions.

Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**

Record: `[iio: accel: mma8452]` `[switch]` — Replace
`devm_request_threaded_irq()` with manual `request_threaded_irq()` and
explicit `free_irq()` in probe error and remove paths.

**Step 1.2 — Tags**

Record:
- **Fixes:** — none
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** — none
- **Link:** — none
- **Cc: stable:** — none (expected for manual review)
- **Signed-off-by:** Sanjay Chitroda (author), Jonathan Cameron (IIO
  maintainer)

Notable: no fuzzer report, no user bug report, no explicit stable
nomination. Maintainer sign-off is present.

**Step 1.3 — Body analysis**

Record:
- **Bug:** `devm_request_threaded_irq()` combined with manual
  `goto`-based probe unwind breaks devm’s LIFO release model; IRQ stays
  registered while driver manually tears down buffer/trigger/other
  resources.
- **Symptom:** Interrupt handler can run during manual teardown (probe
  failure or `remove()`), accessing structures being destroyed.
- **Root cause:** devm releases IRQ only after probe returns or after
  `remove()` completes, but the driver manually cleans up
  buffer/trigger/regulators before that point.

**Step 1.4 — Hidden bug fix?**

Record: **Yes.** Despite “switch”/“conventions” wording, this is a real
teardown-order bug fix, not style-only cleanup.

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**

Record:
- **File:** `drivers/iio/accel/mma8452.c` (+12 / −7)
- **Functions:** `mma8452_probe()`, `mma8452_remove()`
- **Scope:** Single-file surgical fix

**Step 2.2 — Code flow changes**

Record:
- **Hunk 1 (probe IRQ registration):** `devm_request_threaded_irq()` →
  `request_threaded_irq()` — IRQ no longer tied to devm.
- **Hunk 2 (probe error paths):** After IRQ registration,
  `pm_runtime_set_active()` / `iio_device_register()` failures now `goto
  free_irq` instead of `goto buffer_cleanup`.
- **Hunk 3 (new `free_irq:` label):** Calls `free_irq(client->irq,
  indio_dev)` before `buffer_cleanup`.
- **Hunk 4 (`remove()`):** Adds explicit `free_irq()` before
  `iio_triggered_buffer_cleanup()`.

**Before → after on probe failure after IRQ setup:**
- Before: IRQ remains active through `buffer_cleanup` /
  `trigger_cleanup`
- After: IRQ freed first, then buffer/trigger cleanup

**Before → after on `remove()`:**
- Before: IRQ active for entire `remove()`; devm frees only after
  `remove()` returns
- After: IRQ freed before buffer/trigger teardown

**Step 2.3 — Bug mechanism**

Record: **Category:** teardown race / potential UAF in interrupt
context.

`mma8452_interrupt()` (lines 1053–1083) can call
`iio_trigger_poll_nested(indio_dev->trig)` and `iio_push_event()`. With
devm, IRQ stays live while `iio_triggered_buffer_cleanup()` and
`mma8452_trigger_cleanup()` run in probe error and remove paths.

**Step 2.4 — Fix quality**

Record: Fix is minimal, obviously correct, and matches standard non-devm
IRQ pattern. Low regression risk; no API changes.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**

Record: `devm_request_threaded_irq()` introduced in `28e3427824ccc8`
(2015-06-01, “iio: mma8452: Basic support for transient events”). Bug
present since v4.1 era; definitely present in this 6.18.y tree.

**Step 3.2 — Fixes: tag**

Record: N/A — no Fixes: tag.

**Step 3.3 — Related file history**

Record: Part of v3 series “iio: accel: mma8452: improve coding style, pm
and resource cleanup” (10 patches). Sibling patch `5bdff291d20c3`
(“handle I2C read error(s)”) **is already in this tree** as stable
commit `1cddef80a180a`. IRQ fix (`0a6726ec20cd4`) is **not** in this
tree.

**Step 3.4 — Author context**

Record: Sanjay Chitroda; Jonathan Cameron committed. Same author has
another teardown fix already backported here: `04a4d98222109`
(“ssp_sensors: cancel delayed work_refresh on remove”).

**Step 3.5 — Dependencies**

Record: **Standalone.** Does not depend on other series patches
(codestyle/header-sort patches are independent). `git apply --check` on
current tree: **clean apply**.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**

Record: `b4 dig -c 0a6726ec20cd4` → [PATCH v3 02/10](https://patch.msgid
.link/20260505174640.3998281-3-sanjayembedded@gmail.com). Series v2 and
v3 found. Lore fetch blocked by bot protection; could not read thread
replies.

**Step 4.2 — Reviewers**

Record: `b4 dig -w` — CC’d: `jic23@kernel.org`, `linux-
iio@vger.kernel.org`, and other IIO maintainers/reviewers.

**Step 4.3 — Bug reports**

Record: None found.

**Step 4.4 — Series context**

Record: 10-patch series; this is patch 02/10. I2C read-error fix from
same series already backported to 6.18.y; IRQ fix was not.

**Step 4.5 — Stable list**

Record: UNVERIFIED — lore stable search inaccessible.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**

Record: `mma8452_probe()`, `mma8452_remove()`, `mma8452_interrupt()`

**Step 5.2 — Callers**

Record: `mma8452_probe()` — I2C driver probe during device enumeration.
`mma8452_remove()` — device unbind/module unload. `mma8452_interrupt()`
— hardware IRQ thread.

**Step 5.3 — Callees in interrupt path**

Record: `i2c_smbus_read_byte_data()`, `iio_trigger_poll_nested()`,
`iio_push_event()` — all touch live IIO/trigger state.

**Step 5.4 — Reachability**

Record: Triggered when `client->irq` is non-zero (interrupt-capable
board config). Probe error path reachable on `iio_device_register()`
failure etc. Remove path runs on every unbind/unload.

**Step 5.5 — Similar patterns**

Record: Same devm+goto anti-pattern exists in other IIO drivers; this
fix is driver-specific.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code present?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
`v6.18.44`). `drivers/iio/accel/mma8452.c` still uses
`devm_request_threaded_irq()` at line 1685 with `goto buffer_cleanup` on
later failures; `remove()` has no `free_irq()`.

**Step 6.2 — Backport complications**

Record: **Clean apply** verified with `git apply --check`. No conflicts
expected.

**Step 6.3 — Related fixes already present?**

Record: `1cddef80a180a` (I2C read error propagation) is present. IRQ
teardown fix is **not** present.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**

Record: `drivers/iio/accel/` — IIO accelerometer driver. **Criticality:
PERIPHERAL** (hardware-specific, not core kernel).

**Step 7.2 — Activity**

Record: Moderately active; several accel driver fixes backported to
6.18.y recently.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**

Record: Systems with Freescale/NXP MMA8452-family accelerometer on I2C
**and** IRQ line configured (embedded/phone-class boards). Config-
dependent (`CONFIG_MMA8452` or module).

**Step 8.2 — Trigger conditions**

Record:
- **Probe failure** after IRQ registration (e.g. `iio_device_register()`
  OOM) — uncommon
- **Driver remove/unbind** with IRQ configured and hardware generating
  interrupts — more realistic
- Unprivileged users cannot directly trigger; requires device
  presence/removal

**Step 8.3 — Failure mode severity**

Record: IRQ handler may access buffer/trigger/device state during
teardown → possible kernel oops/UAF in interrupt context. **Severity:
HIGH** (crash potential), but **low likelihood** (narrow race window, no
reports in ~11 years).

**Step 8.4 — Risk-benefit**

Record:
- **Benefit:** Prevents teardown race on probe error and remove; correct
  resource ordering
- **Risk:** Very low (12-line, localized change)
- **Ratio:** Moderate benefit, very low risk

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence**

**FOR:**
- Real bug: IRQ active during manual teardown in probe error and remove
  paths
- Interrupt handler touches IIO buffer/trigger state that is being
  destroyed
- Small, surgical, maintainer-committed fix
- Applies cleanly to 6.18.y
- Bug present since 2015 in this driver
- Same author’s teardown fixes have been backported to this tree before

**AGAINST:**
- No crash reports, syzbot, or Fixes: tag
- Peripheral driver; only IRQ-enabled MMA8452 hardware
- Bug latent ~11 years without reported incidents
- Stable already took sibling I2C-read fix from same series but not this
  one
- Framed as resource-management correctness rather than demonstrated
  crash

**UNRESOLVED:**
- Lore thread review comments inaccessible
- No confirmation of real-world crash reproduction

**Step 9.2 — Stable rules checklist**

1. Obviously correct and tested? **PASS** — logic is sound; no Tested-by
   but maintainer committed
2. Fixes a real bug? **PASS** — verified teardown ordering bug in code
3. Important issue? **PASS (borderline)** — crash/UAF potential on
   remove, but unreported and hardware-specific
4. Small and contained? **PASS** — 19 lines, one file
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

**Step 9.3 — Exception categories**

Record: None (not quirk/DT/build/docs).

**Step 9.4 — Decision rationale**

This is a legitimate teardown-order bug: with
`devm_request_threaded_irq()`, the IRQ remains registered while
`mma8452_remove()` and probe error paths manually destroy the triggered
buffer and trigger that `mma8452_interrupt()` uses. The fix is minimal,
correct, and applies cleanly to 6.18.44. Severity is borderline for
stable — no reported crashes, niche hardware — but the failure mode
(oops/UAF in IRQ context during driver removal) meets the conservative
stable bar for teardown races, especially given very low backport risk.

---

## Verification

- [Phase 1] `git show 0a6726ec20cd4 --format=fuller`: parsed message,
  tags, no Fixes/Reported-by
- [Phase 2] `git show 0a6726ec20cd4`: confirmed +12/−7 diff in
  probe/remove
- [Phase 2] Read `mma8452_interrupt()` at lines 1053–1083: handler uses
  trigger/events during teardown
- [Phase 3] `git blame -L 1680,1720`: devm IRQ from `28e3427824ccc8`
  (2015)
- [Phase 3] `git log all-next -- drivers/iio/accel/mma8452.c`: found
  commit `0a6726ec20cd4`, series context
- [Phase 3] `git show 1cddef80a180a`: sibling I2C fix already in stable
  6.18.y
- [Phase 3] `git apply --check` on patch: clean apply to HEAD
- [Phase 4] `b4 dig -c 0a6726ec20cd4`: lore URL found
- [Phase 4] `b4 dig -c 0a6726ec20cd4 -a`: v2/v3 series revisions found
- [Phase 4] `b4 dig -c 0a6726ec20cd4 -w`: maintainers CC’d
- [Phase 4] WebFetch lore URL: **FAILED** (bot protection)
- [Phase 5] Grep/read `mma8452.c`: confirmed interrupt →
  `iio_trigger_poll_nested()` / `iio_push_event()`
- [Phase 6] `git describe HEAD`: v6.18.44
- [Phase 6] Grep `devm_request_threaded_irq` in tree: still present (bug
  not fixed)
- [Phase 6] `git branch --contains 0a6726ec20cd4`: not in stable branch
- [Phase 7] `git log -20 -- drivers/iio/accel/`: subsystem activity
  assessed
- [Phase 8] Read probe/remove error paths: confirmed `goto
  buffer_cleanup` with active IRQ before fix

**YES**

 drivers/iio/accel/mma8452.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/accel/mma8452.c b/drivers/iio/accel/mma8452.c
index cefc7cf4bd835..279a9b3648860 100644
--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1682,18 +1682,16 @@ static int mma8452_probe(struct i2c_client *client)
 		goto trigger_cleanup;
 
 	if (client->irq) {
-		ret = devm_request_threaded_irq(&client->dev,
-						client->irq,
-						NULL, mma8452_interrupt,
-						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-						client->name, indio_dev);
+		ret = request_threaded_irq(client->irq, NULL, mma8452_interrupt,
+					   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					   client->name, indio_dev);
 		if (ret)
 			goto buffer_cleanup;
 	}
 
 	ret = pm_runtime_set_active(&client->dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	pm_runtime_enable(&client->dev);
 	pm_runtime_set_autosuspend_delay(&client->dev,
@@ -1702,7 +1700,7 @@ static int mma8452_probe(struct i2c_client *client)
 
 	ret = iio_device_register(indio_dev);
 	if (ret < 0)
-		goto buffer_cleanup;
+		goto free_irq;
 
 	ret = mma8452_set_freefall_mode(data, false);
 	if (ret < 0)
@@ -1713,6 +1711,10 @@ static int mma8452_probe(struct i2c_client *client)
 unregister_device:
 	iio_device_unregister(indio_dev);
 
+free_irq:
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 buffer_cleanup:
 	iio_triggered_buffer_cleanup(indio_dev);
 
@@ -1738,6 +1740,9 @@ static void mma8452_remove(struct i2c_client *client)
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
+	if (client->irq)
+		free_irq(client->irq, indio_dev);
+
 	iio_triggered_buffer_cleanup(indio_dev);
 	mma8452_trigger_cleanup(indio_dev);
 	mma8452_standby(iio_priv(indio_dev));
-- 
2.53.0

