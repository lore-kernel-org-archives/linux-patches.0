Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B999D5D3C44;
	Mon, 19 Oct 2026 14:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418502; cv=none; b=LognfyZGvOv91UcRJufILyM0BcOFFRKFFZkmKOQN27ezlmDidIrLSMnVXgTYLPsEwyK+NHjcIHBpjvlnzjUQ+pzefzDapYTbIkmwKlzAI0kTR3MCKL55dfMqaNBMm0VhMI13nqso7bKxwN3D0rnsUegQuxojjv7gdoqpXQFJ0tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418502; c=relaxed/simple;
	bh=9uEfvAuOiYOJcHxMy0F3ENWFF6EcCpNXoDLQ2cXBcbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ufhbF6w2+PLSmc2I5qCgf83oNakggjV+LQWQFaD9HaQ+693Pn67JCUHtOFnAqsQi1QDC5q564Su3TrhUpEoDTSut/KE+djmY8DzTSKSFLLdgTsvBGWoS8NstGbEz8NwS3kSnHaKv92gtQQPBMUoA8lXhvQRiSko7yYi45Z1R/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f1TrjllH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f1TrjllH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10321F000C6;
	Mon, 19 Oct 2026 14:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418499;
	bh=brGJVCCR968UDegg086AWZ0DWO31Q6p+SXo1Qipf9ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1TrjllHaHDtc4iZw20WqO7wlw3GbOnNR40JMr+9UCsk2xMNgijd5nVSQTWy8iOtc
	 gja6vNESHpUU4PePFKd09lliq4kdzfNhKWDFIzVEUMoYSZh6T10ZR4evgRrpugkb+R
	 HzY8dn4LfSnbZzr1Ktnrc1KYaw70zy9Z4Z9QEptxk4kypOr+Mqy8TkPARA/KDW3dJ+
	 42dEIkTIW+U4QchwoMQo7MPVrvGkBbOYkfC4/BVAQL7/C2dtZCcnHt8Fzql8j2LbDd
	 kwE7mH9gR7LjhlgTOZKAdYwm+fhTJD2GU2II1xbBZt27R9lgcyy0hx1WemdQHyRWZF
	 ehAo79G1acymg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] gpio: pca9570: Use I2C match data
Date: Mon, 19 Oct 2026 09:49:43 -0400
Message-ID: <20261019135441.1420968-292-sashal@kernel.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 415c63896b76fd98883e190bc7518383cb01779c ]

The driver stores chip metadata in both the OF match table and the I2C
id table, but probe currently reads it with device_get_match_data().
That helper only returns firmware-node match data, so an I2C-id/modalias
match can leave chip_data NULL before the driver dereferences it to read
ngpio.

Use i2c_get_match_data() so the I2C id table driver_data is consumed
when firmware match data is not present.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624053744.72612-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[gpio/pca9570] [Use] Switch probe from firmware-only match
  data to I2C match data so I2C-id/modalias binds get chip metadata`

**Step 1.2: Tags**
- Record:
  - `Fixes:`: none (expected for this review)
  - `Reported-by:`: none
  - `Tested-by:`: none
  - `Reviewed-by:`: none
  - `Acked-by:`: none
  - `Link:` `https://patch.msgid.link/20260624053744.72612-1-
    pengpeng@iscas.ac.cn`
  - `Cc: stable`: none (expected)
  - `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
  - `Signed-off-by: Bartosz Golaszewski
    <bartosz.golaszewski@oss.qualcomm.com>` (GPIO maintainer)
  - Pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
    415c63896b76...]` ignored per instructions

**Step 1.3: Body**
- Record: `[Bug] Probe uses device_get_match_data() while chip metadata
  lives in both OF and I2C id tables. That helper only returns firmware-
  node data.` `[Symptom] I2C-id/modalias bind leaves chip_data NULL;
  probe then reads chip_data->ngpio.` `[Versions] None stated.` `[Root
  cause] Wrong match-data helper; I2C id table driver_data is never
  consumed.`

**Step 1.4: Hidden bug fix?**
- Record: This is an explicit bug fix, not cleanup. The subject says
  “Use” rather than “fix”, but the body describes a NULL dereference on
  probe.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `[Files] drivers/gpio/gpio-pca9570.c: 1 insertion, 1 deletion`
  `[Function] pca9570_probe()` `[Scope] Single-file, one-line surgical
  change`

The candidate as applied on this tree is exactly that one-line swap.
Mainline context around `devm_mutex_init()` is not in 6.18.y
(`mutex_init()` is still used here); it does not affect the hunk.

**Step 2.2: Code flow**
- Record: `[Before] gpio->chip_data =
  device_get_match_data(&client->dev); then gpio->chip.ngpio =
  gpio->chip_data->ngpio;` `[After] Same dereference, but chip_data
  comes from i2c_get_match_data(client).` Path: probe / initialization,
  not an error path.

**Step 2.3: Bug mechanism**
- Record: `[Category] Memory safety — NULL pointer dereference`
  `[Mechanism] device_get_match_data() is fwnode-only
  (drivers/base/property.c). i2c_device_match() can still bind via
  i2c_match_id() when there is no OF/ACPI data. Probe then dereferences
  NULL. i2c_get_match_data() tries firmware data first, then
  id_table->driver_data.`

Verified helper:

```121:137:drivers/i2c/i2c-core-base.c
const void *i2c_get_match_data(const struct i2c_client *client)
{
        struct i2c_driver *driver = to_i2c_driver(client->dev.driver);
        const struct i2c_device_id *match;
        const void *data;

        data = device_get_match_data(&client->dev);
        if (!data) {
                match = i2c_match_id(driver->id_table, client);
                if (!match)
                        return NULL;

                data = (const void *)match->driver_data;
        }

        return data;
}
```

The id table already stores the pointers probe needs:

```158:163:drivers/gpio/gpio-pca9570.c
static const struct i2c_device_id pca9570_id_table[] = {
        { "pca9570", (kernel_ulong_t)&pca9570_gpio},
        { "pca9571", (kernel_ulong_t)&pca9571_gpio },
        { "slg7xl45106", (kernel_ulong_t)&slg7xl45106_gpio },
        { /* sentinel */ }
};
```

**Step 2.4: Fix quality**
- Record: `[Quality] Obviously correct; this is the I2C-core helper used
  by pca953x/pcf857x in this tree.` `[Regression risk] Very low.
  Firmware path is unchanged (helper still calls device_get_match_data
  first). No locking, API, or data-structure change. Still no NULL check
  after the lookup; that is not a regression versus the OF path.`

## Phase 3: Git history

**Step 3.1: Blame**
- Record: `[Introduced] Pointer dereference of match data: b8a34582c7f7f
  (“gpio: pca9570: add a platform data structure”, 2022-10-27, contained
  in v6.2-rc1).` Before that, 16d44b6085c1d (2020) used
  `(uintptr_t)device_get_match_data()`, so a missing firmware match set
  `ngpio = 0` instead of oopsing. The crash exists from v6.2 onward.
  Helper `i2c_get_match_data()`: 564d73c4d9201, contained in v6.5-rc1;
  present in this tree.

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` tag. Buggy commit `b8a34582c7f7f` is an ancestor
  of HEAD.

**Step 3.3: File history**
- Record: Recent file commits are GPIO callback renames, kerneldoc,
  probe-style switch, chip_data rename, slg7xl45106/pca9571 support. No
  prerequisite refactor is required for this one-line swap. Standalone,
  not patch X/Y.

**Step 3.4: Author**
- Record: Pengpeng Hou has several GPIO fixes on this branch
  (MODULE_DEVICE_TABLE, probe-failure handling). Not the GPIO
  maintainer. Maintainer Bartosz Golaszewski applied the patch.

**Step 3.5: Dependencies**
- Record: Depends only on `i2c_get_match_data()`, which exists in
  v6.18.53 (`include/linux/i2c.h` and `drivers/i2c/i2c-core-base.c`).
  Can apply standalone. Applied commit `f191ba12096a2` is a clean 2-line
  change on this tree.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `[Lore]
  https://patch.msgid.link/20260624053744.72612-1-pengpeng@iscas.ac.cn`
  `[Revisions] v1 only, single patch` `[Feedback] Maintainer reply:
  “Applied, thanks!” No NAK, no requested changes, no Cc: stable
  suggestion.` Direct lore.kernel.org fetch returned 403; full thread
  recovered via `b4 dig -m`.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Linus Walleij, Bartosz Golaszewski, linux-gpio@, linux-
  kernel@. Correct GPIO maintainers and list. Applied by Bartosz.

**Step 4.3: Bug report**
- Record: No Reported-by / bugzilla / syzbot. Bug is deduced from the
  code: I2C-id bind + firmware-only helper.

**Step 4.4: Series**
- Record: Standalone v1. Sibling GPIO conversions already in this tree:
  `ea05787136256` (pca953x) and `db3b16dcc7e4f` (pcf857x). Not
  prerequisites.

**Step 4.5: Stable list**
- Record: Original submission did not Cc stable. lore.kernel.org/stable
  search could not be fetched (HTTP 403). No stable-specific discussion
  in the recovered thread.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: `pca9570_probe()` only.

**Step 5.2: Callers**
- Record: Only `pca9570_driver.probe`. Invoked from I2C core on client
  bind (boot DT, ACPI, `i2c_new_client_device()`, sysfs `new_device`).
  Not IRQ/hot-path.

**Step 5.3: Callees**
- Record: After the lookup, probe still uses `chip_data->ngpio`,
  `devm_mutex_init`/`mutex_init`, `pca9570_read`,
  `devm_gpiochip_add_data`. The only behavioral change is where match
  data comes from.

**Step 5.4: Reachability**
- Record: DT boards with `compatible = "nxp,pca9570"` (imx95-15x15-evk,
  imx8mp-dhcom-pdk3, stm32mp157c-lxa-tac-gen1) already get firmware
  match data and do not hit the bug. The broken path is I2C-id/modalias:
  sysfs `new_device`, board-info, or any client without a firmware node.
  That is a supported I2C instantiation method (`new_device_store` in
  i2c-core). Needs privileges to write sysfs; still a deterministic
  probe oops for that path.

**Step 5.5: Similar patterns**
- Record: Same class of I2C GPIO expanders already use
  `i2c_get_match_data()` (`gpio-pca953x.c`, `gpio-pcf857x.c`). pca953x
  also NULL-checks; this patch does not add that check.

## Phase 6: Local tree (this checkout only)

**Step 6.1: Does the bug exist here?**
- Record: Local tree is **6.18.53** (`git describe HEAD`:
  `v6.18.53-5049-g0f0bdc2b0dffb`; Makefile `VERSION=6 PATCHLEVEL=18
  SUBLEVEL=53`). At `v6.18.53`, probe still does
  `device_get_match_data()` then `chip_data->ngpio`. Bug present.
  Candidate is **not** an ancestor of `v6.18.53`. Crash-introducing
  commit `b8a34582c7f7f` (v6.2) is in this tree.

**Step 6.2: Backport difficulty**
- Record: Clean apply. On this tree the change is exactly one call swap;
  no `devm_mutex_init` conflict.

**Step 6.3: Related fixes already here?**
- Record: No earlier pca9570 match-data fix. pca953x/pcf857x already
  converted; this driver was left on the firmware-only helper.

## Phase 7: Subsystem context

**Step 7.1**
- Record: `[Subsystem] drivers/gpio (I2C GPO expander)` `[Criticality]
  PERIPHERAL / driver-specific` — NXP PCA9570/PCA9571 and Dialog
  SLG7XL45106. Not core MM/VFS, but in-tree boards and
  `CONFIG_GPIO_PCA9570` users exist.

**Step 7.2**
- Record: GPIO I2C expanders are mature. This file is low-churn except
  callback API updates. Long-standing bug (since v6.2), not churn from a
  new subsystem.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Driver-specific / config-specific (`CONFIG_GPIO_PCA9570`). DT
  users are fine. Users instantiating via I2C id/modalias oops in probe.

**Step 8.2: Trigger**
- Record: `[Trigger] Bind pca9570/pca9571/slg7xl45106 without firmware
  match data.` `[Likelihood] Uncommon vs DT, but 100% on that path (not
  a race).` `[Unprivileged?] No; sysfs new_device is privileged. Not a
  local-priv-esc issue.`

**Step 8.3: Failure mode**
- Record: `[Failure] NULL deref in pca9570_probe → kernel oops`
  `[Severity] HIGH (crash on probe for a supported bind method). Not
  data corruption or unprivileged security.`

**Step 8.4: Risk vs benefit**
- Record: `[Benefit] Prevents a deterministic probe oops; makes the
  existing I2C id table actually work.` `[Risk] Very low: one line,
  established helper, firmware path unchanged.` `[Ratio] Favorable.`

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real NULL deref when I2C-id matching; helper and dereference verified
  in this tree
- One-line, obviously correct; GPIO maintainer applied v1 with no
  objections
- `i2c_get_match_data()` already in 6.18.y; applies cleanly
- Same pattern already used by sibling GPIO I2C expanders
- In-tree DT users exist, so the driver is not dead; the I2C id table
  with `driver_data` is currently unused/wrong

Against:
- No user/syzbot report
- In-tree boards use DT, so they do not hit it
- Peripheral driver, not core
- Probe still does not NULL-check `chip_data` (pre-existing)

Unresolved:
- lore.kernel.org HTTP 403 for live HTML; thread recovered via b4 mbox
- No stable@ discussion found

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — one helper swap; maintainer
   applied; helper semantics verified
2. Fixes a real bug that affects users? **PASS** — NULL deref on a
   supported I2C bind path
3. Important (crash/security/corruption/deadlock)? **PASS** — probe oops
   (HIGH, not universal CRITICAL)
4. Small and contained? **PASS** — 1 line, one file
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — clean on 6.18.53; helper present

**Step 9.3: Exception category**
- Record: None (not a device ID/quirk/DT/build/docs exception). It is a
  normal small crash fix.

**Step 9.4: Decision**
This belongs in this 6.18.y tree: the buggy code is here, the helper is
here, and the fix is a one-line swap that stops a NULL deref on I2C-id
probe.

## What the commit solves

`pca9570_probe()` treats `device_get_match_data()` as the source of
`struct pca9570_chip_data`, then immediately reads `->ngpio`. That
helper only consults firmware nodes. I2C matching can still succeed from
`id_table` (sysfs `new_device`, board info, modalias). `chip_data` is
then NULL and probe oopses. `i2c_get_match_data()` keeps the DT path and
consumes the id-table pointers this driver already stores.

For 6.18 stable users this is a small crash fix, not a feature. DT
boards keep working; non-firmware instantiation stops oopsing.

## Verification
- [Phase 1] Parsed tags: author + GPIO maintainer SOB, lore Link; no
  Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: 1 line in `pca9570_probe()`; `device_get_match_data` →
  `i2c_get_match_data`
- [Phase 2] `device_get_match_data()` is fwnode-only
  (`drivers/base/property.c:1346`)
- [Phase 2] `i2c_get_match_data()` falls back to `id_table->driver_data`
  (`i2c-core-base.c:121`)
- [Phase 2] `i2c_device_match()` binds OF, then ACPI, then I2C id
  (`i2c-core-base.c:140`)
- [Phase 3] Blame: crash introduced by `b8a34582c7f7f` (v6.2-rc1);
  helper from `564d73c4d9201` (v6.5-rc1)
- [Phase 3] `git merge-base --is-ancestor b8a34582c7f7f HEAD` → yes;
  helper ancestor → yes
- [Phase 4] `b4 dig -c 415c63896b76`: v1 only; recipients GPIO
  maintainers; mbox: “Applied, thanks!”
- [Phase 4] lore.kernel.org WebFetch: HTTP 403; used b4 mbox instead
- [Phase 5] `pca9570_probe` only used as `i2c_driver.probe`
- [Phase 5] DT users: imx95-15x15-evk, imx8mp-dhcom-pdk3,
  stm32mp157c-lxa-tac-gen1
- [Phase 6] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53
- [Phase 6] `v6.18.53:drivers/gpio/gpio-pca9570.c` still uses
  `device_get_match_data`; candidate not in `v6.18.53`
- [Phase 6] Applied form on this branch: clean 2-line change
  (`f191ba12096a2`)
- [Phase 8] Failure mode: NULL deref in probe → oops; DT path unaffected
- UNVERIFIED: live lore.kernel.org/stable HTML search (HTTP 403)

The patch is obviously correct, fixes a real probe oops, is one line,
and applies cleanly to this 6.18.y tree.

**YES**

 drivers/gpio/gpio-pca9570.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-pca9570.c b/drivers/gpio/gpio-pca9570.c
index c5a1287079a06..f7cc3fbf45336 100644
--- a/drivers/gpio/gpio-pca9570.c
+++ b/drivers/gpio/gpio-pca9570.c
@@ -128,7 +128,7 @@ static int pca9570_probe(struct i2c_client *client)
 	gpio->chip.get = pca9570_get;
 	gpio->chip.set = pca9570_set;
 	gpio->chip.base = -1;
-	gpio->chip_data = device_get_match_data(&client->dev);
+	gpio->chip_data = i2c_get_match_data(client);
 	gpio->chip.ngpio = gpio->chip_data->ngpio;
 	gpio->chip.can_sleep = true;
 
-- 
2.53.0

