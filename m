Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E625AE423;
	Mon, 19 Oct 2026 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418418; cv=none; b=bDJxbDIIisDEdenoFKVw2QtfJVcrRid0zUZUhn2jyHdRR5aeyb1r/b6guRXyF+soEyTTwHIblL/59vHPdUGHNZVHHAD0aZ9nItTD37CsoDjfIbKxI+ZeeJC+xgPy4GvQDFrSLaL4H3GfkiDzuMvzz5bNnK09XxADq5GApyl2/Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418418; c=relaxed/simple;
	bh=atj6UOvgApRieG1GJGv5RDUIMlc+SFdaGNyRb7mWE5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l9RF2CHHu7XJHrogpn5SeHUbcKTzknad0FGAYbCi49FDvcUdqH0WC8bPA5VJ41TsuNckLNAjcY+oRwO9MqvS654kzhoo49WAP8Pe34KZ2yiL/6Z4QkTsnCl5fRZcCFONiMXo1ML67v7hZIZoD2LRQotZjk2GNWgV3E7RA8hRCk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dGSHiR23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dGSHiR23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A86C51F000C4;
	Mon, 19 Oct 2026 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418415;
	bh=OpFOufFlSjediWMBK9vzhB5wdkH6ywbB5g9Et8FopIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dGSHiR23DoZKzWb5kdvDKnj4VyzrCAUP4CYZ4YPLp/WPfzPo8Fe3ddN9DmqrZCFqy
	 DXGoczJQZmlD0M6Y6YVnHLu1OzH4YjUOWK93bGPXAZjFkjgn6ln2bvh9DBmzZju/Kf
	 Y3RNtFM9BnWllRiwuangGTYW5en316jY1Kt91esSwbSaDm/wvJ7lXgUboHdR0Vigw3
	 XaidOKqFkVGPwNCFwbWCHgfpLM8Y3R4BTW/8BpTmB8lOuDYpdqrER2Lj7/X4kh8W+b
	 s2VWV6TN+Ra+izuKKZPWgj6huSFLOZ03IAMKITia8W6Rsv6uC3MTgzAJ88PNzHa1Mr
	 laxTEAsaHjqmw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-iio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iio: adc: max1241: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:48:44 -0400
Message-ID: <20261019135441.1420968-233-sashal@kernel.org>
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

[ Upstream commit 790a2080e0c9eabefea3561dec301172043de236 ]

The driver has a match table for the spi bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is mainline **7.3.0-rc4** (`v7.3-rc4-27`,
`origin/master`). The change is a one-line `MODULE_DEVICE_TABLE(spi, …)`
for an existing IIO ADC driver. Below is the full checklist against that
tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[iio: adc: max1241:]` `[add]` `[export the existing SPI
id_table via MODULE_DEVICE_TABLE so udev can autoload the module]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` none (expected)
- `Reported-by:` none
- `Tested-by:` none
- `Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>`
- `Acked-by:` none
- `Link:` none in the git commit
- `Cc: stable@vger.kernel.org:` none (expected)
- `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
- `Signed-off-by: Jonathan Cameron <jic23@kernel.org>` (IIO maintainer)
- No syzbot, no CVE, no bugzilla

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `max1241_id[]` is wired to `spi_driver.id_table`, but not
  published with `MODULE_DEVICE_TABLE(spi, …)`.
- **Symptom:** `file2alias` never emits `spi:max1241`, so udev/modprobe
  will not autoload `max1241.ko` for SPI-id instantiation.
- **Failure mode:** driver stays unloaded until a manual `modprobe` /
  builtin; not a crash.
- **Version info in message:** none.
- **Root cause:** missing module-alias publication for an already-
  registered match table.
- The “source-level fix / no dynamic hardware reproduction” paragraph is
  in the original lore submission, not a stable-pipeline marker.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit autoload/modalias
fix. Same pattern as other “publish the module alias” patches.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/iio/adc/max1241.c` (`+1 / -0`)
- Function/data: none rewritten; one macro after `max1241_id[]`
- Scope: single-file, one-line surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** SPI id table exists and is used at bind time if the module
  is already loaded; `modules.alias` has no `spi:max1241`.
- **After:** build-time alias `spi:max1241` is generated (same mechanism
  as the existing `MODULE_DEVICE_TABLE(of, max1241_dt_ids)`).
- **Path affected:** module autoload for SPI-id devices. Probe/runtime
  I/O unchanged.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware matching / module autoload (logic/correctness,
device-ID class).** Not UAF, leak, race, or crash. `MODULE_DEVICE_TABLE`
is consumed by `scripts/mod/file2alias.c` (`do_spi_entry`).

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct; matches every other SPI IIO ADC in this tree.
No API, locking, or control-flow change. Regression risk is negligible.
The committed hunk matches the driver after `d04a09b41d2e2` (`{ .name =
"max1241" }`); the lore v1 still had `{ "max1241", max1241 }`, but the
macro placement is identical.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: `max1241_id[]` and `id_table` come from `8a80a71d9020b` (“iio:
adc: Add MAX1241 driver”, 2020-04-03), contained in **v5.8-rc1**. OF
table had `MODULE_DEVICE_TABLE(of, …)` from day one; SPI publication was
omitted then and stayed omitted until this commit.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Introduction commit is `8a80a71d9020b` (v5.8).
No later competing fix for the same SPI alias.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (file log, no `--all`):
- `790a2080e0c9e` — this commit (v7.3-rc1)
- `d04a09b41d2e2` — simplify id table (named initializer; not a
  prerequisite for the macro)
- `09e3bdfe499d5` — id-table formatting
- Driver added in `8a80a71d9020b`
Standalone; not patch `X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Pengpeng Hou is a regular contributor of the same
`MODULE_DEVICE_TABLE` pattern (IIO `bmi270`, rtc, vdpa, watchdog, hwmon,
fbdev). Not the IIO maintainer. Same-day sibling: `87359c88846fa` (`iio:
imu: bmi270: add missing MODULE_DEVICE_TABLE()`), also applied by
Jonathan Cameron.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Macro sits next to an array that has existed since v5.8.
Applies on both old `{ "max1241", max1241 }` and new `.name` forms.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 790a2080e0c9e` →
  https://patch.msgid.link/20260704151633.38517-1-pengpeng@iscas.ac.cn
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread: Andy Shevchenko `Reviewed-by`; Jonathan Cameron applied it.
- **Maintainer comment (verbatim from mbox):** “I'm not rushing this in
  given we don't have reports of it actually causing problems for any
  users. Applied to the testing branch of iio.git which means it'll go
  upstream in the next merge window.”
- No NAK. No `Cc: stable` in review. Landed in `iio-for-7.3a` (merge
  window), not `iio-fixes`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were Jonathan Cameron, David Lechner, Nuno
Sá, Andy Shevchenko, `linux-iio`, `linux-kernel`. Andy reviewed;
Jonathan applied.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No `Reported-by`, no bugzilla, no syzbot. Author presents it as
source-level evidence (table present, not exported). No hardware repro
claimed.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Same-day IIO sibling `bmi270` (OF table, more important for DT
autoload). This max1241 patch is a single standalone `[PATCH]`, not a
numbered series.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search for this subject/max1241 found
**no** discussion of *this* commit. Broader `MODULE_DEVICE_TABLE` search
**did** show current stable practice taking the same class, e.g. `[PATCH
6.18 190/398] Input: eeti_ts - publish the OF module alias`, ASoC
“Publish the OF/PCI module aliases” into 6.12/6.18. Those are the same
autoload-publication category Greg is shipping now.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: No function body changed. Added `MODULE_DEVICE_TABLE(spi,
max1241_id)` beside `max1241_id[]`. Related symbols:
`max1241_spi_driver.id_table`, `module_spi_driver()`.

**Step 5.2: TRACE CALLERS**
Record: Runtime callers of `max1241_probe` are SPI core bind
(`module_spi_driver`). The new macro is **not** called at runtime;
`scripts/mod/file2alias.c` `do_spi_entry` reads it at `modpost`.
Userspace trigger is udev/modprobe on `MODALIAS=spi:max1241`.

**Step 5.3: TRACE CALLEES**
Record: N/A for the added line. Existing probe still uses
regulators/GPIO/IIO register.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable when `CONFIG_MAX1241=m` and a SPI device is
instantiated by **SPI id** (`spi_board_info` / `spi_new_device` / ACPI
SPI name), not by DT. DT already autoloads via existing
`MODULE_DEVICE_TABLE(of, max1241_dt_ids)` (`of:N*T*Cmaxim,max1241`). No
in-tree DTS or board file instantiates `max1241` (only
`Documentation/devicetree/bindings/iio/adc/maxim,max1241.yaml`).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Dozens of `drivers/iio/adc/*` files already have
`MODULE_DEVICE_TABLE(spi, …)` (`max1118.c`, `max11205.c`, `ad7476.c`,
…). Historical IIO fixes of the same bug: `8f0d7daf53972` (imx25-gcq
autoload), `447ccb4e0834a` (qcom-spmi-adc5, had `Cc: stable`),
`cc3304052a89a` (stm32-dfsdm aliases).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`
- `make kernelversion` → `7.3.0-rc4`
- Driver is present (`drivers/iio/adc/max1241.c`, `CONFIG_MAX1241`).
- Bug introduced **v5.8**, long before this branch.
- `git merge-base --is-ancestor 790a2080e0c9e HEAD` → yes; this commit
  landed in **v7.3-rc1**. Current file already has the SPI
  `MODULE_DEVICE_TABLE`. That is expected on mainline; it does **not**
  mean the autoload bug is absent from older stables that still have the
  v5.8-style driver. The SPI id table and OF table this patch depends on
  are both here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. One line after the existing `max1241_id[]`
terminator. No refactor required. Table-format commits (`09e3bdfe499d5`,
`d04a09b41d2e2`) do not block the macro.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the SPI-table publication. OF publication was always
present. No alternate SPI-alias fix in the file log.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/iio/adc/` — **PERIPHERAL/IMPORTANT**: IIO ADC, one
Maxim SPI chip (`CONFIG_MAX1241`). Not mm/net/core. Users are boards
with this ADC, typically DT.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: IIO ADC is actively developed (continuous `iio-for-7.3a` / fixes
merges). This particular file is mature (added 2020, infrequent
changes).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** (`CONFIG_MAX1241=m`).
Built-in (`=y`) is unaffected. DT users already autoload via OF aliases.
Remaining gap: SPI-id (non-DT) instantiation.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Module build + SPI device named `max1241` without OF compatible.
Not every boot; not a syscall crash path. Unprivileged users do not
trigger it directly. No in-tree board/DTS consumer of the SPI id was
found.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Failure mode:** module not autoloaded; ADC node missing until
manual load. **Severity: LOW–MEDIUM** (functionality, not
oops/corruption/deadlock). Workaround: `modprobe max1241`.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** restores SPI-id autoload for a driver that already claims
  `id_table`; same class Greg is taking (“publish the … module alias”).
- **Risk:** very low (one macro, no runtime logic).
- **Ratio:** favorable *because* cost is ~zero, even though user
  population for the SPI-id path is small.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real autoload bug: SPI match table registered but not exported.
- One line, obviously correct, reviewed (Andy Shevchenko) and merged by
  the IIO maintainer.
- Same class as device-ID / module-alias publication, which stable
  currently accepts (`eeti_ts` OF alias on 6.18/7.2; ASoC OF/PCI aliases
  on 6.12/6.18).
- Earlier IIO autoload fixes used `Cc: stable` (`447ccb4e0834a`).
- Driver present since v5.8; no missing prerequisites in this tree.
- Zero runtime regression surface.

**AGAINST backporting:**
- Not a crash, UAF, deadlock, or data-corruption bug.
- OF `MODULE_DEVICE_TABLE` already exists, so the normal DT path already
  works.
- Maintainer delayed it to the merge window specifically because there
  were **no user reports**.
- No in-tree DTS/board instantiation of the SPI id.
- Author series is a static sweep of missing tables, not an incident
  report.

**UNRESOLVED:**
- How many production boards instantiate max1241 by SPI board_info/ACPI
  rather than DT (no evidence found).
- WebFetch to lore returned 403/timeout; thread was recovered via `b4
  dig -m` instead.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — one macro, reviewed, in
   mainline v7.3-rc1.
2. Fixes a real bug that affects users? **PASS** — missing `spi:` alias
   when `CONFIG_MAX1241=m`; impact is real but narrow.
3. Important issue? **PASS** under the device-ID / module-alias
   exception (not a crash). Official `stable-kernel-rules.rst` allows
   “just add a device ID”; publishing the existing SPI id is that
   mechanism.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — surrounding `max1241_id[]` /
   `id_table` exist; hunk is a single insertion.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Device ID / module-alias publication** (not a new driver, not
a new API). Closest listed exception: adding IDs to an existing driver.
Build/docs/quirk categories do not apply.

**Step 9.4: MAKE YOUR DECISION**
This tree has the driver and the SPI id table the patch exports. The
change is a one-line, zero-risk autoload fix of a type already going
into stable. Maintainer caution (no reports, not iio-fixes) lowers
severity but does not make it a cleanup or a new feature. Criterion 3 is
met via the device-ID exception, not via crash/security.

What it solves for stable users: if `max1241` is built as a module and
the chip is created by SPI id rather than DT, udev can load the driver
instead of leaving the ADC unbound. DT users are already covered; the
extra alias does not change their path.

Risk vs benefit: benefit is modest and device-specific; risk is
effectively none. That trade-off matches other “publish the module
alias” stable commits.

### Verification
- [Phase 1] Parsed tags: Reviewed-by Andy Shevchenko; SOB Jonathan
  Cameron; no Fixes/Reported-by/Cc: stable/syzbot
- [Phase 1] Body: missing SPI `MODULE_DEVICE_TABLE`; autoload aliases;
  source-level, no hardware repro
- [Phase 2] Diff: +1 line in `drivers/iio/adc/max1241.c` after
  `max1241_id[]`
- [Phase 3] `git blame`: table from `8a80a71d9020b` (v5.8-rc1); OF table
  always exported; SPI table not
- [Phase 3] No Fixes: tag; introduction commit confirmed via `git show`
  / `git describe --contains --match 'v*'`
- [Phase 3] Author also landed `87359c88846fa` (bmi270
  MODULE_DEVICE_TABLE) the same day
- [Phase 3] `git merge-base --is-ancestor 790a2080e0c9e HEAD` exit 0;
  contained in v7.3-rc1
- [Phase 4] `b4 dig -c 790a2080e0c9e`:
  https://patch.msgid.link/20260704151633.38517-1-pengpeng@iscas.ac.cn
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: IIO maintainers + linux-iio
- [Phase 4] `b4 dig -m /tmp/max1241-thread.mbox`: Andy Reviewed-by;
  Jonathan: not rushing, no user reports, testing branch / next merge
  window
- [Phase 4] lore.kernel.org/stable: no thread for this commit; other
  “publish the module alias” patches are in 6.12/6.18/7.2
- [Phase 5] `file2alias.c` `do_spi_entry` generates SPI aliases; probe
  path unchanged
- [Phase 5] No in-tree DTS/board `max1241` users (grep `arch/` and dts);
  only DT binding YAML
- [Phase 6] `git describe HEAD` = v7.3-rc4-27; `kernelversion`
  7.3.0-rc4; driver + both match tables present
- [Phase 6] Pre-fix parent `790a2080e0c9e^` has SPI table and OF
  MODULE_DEVICE_TABLE, no SPI MODULE_DEVICE_TABLE
- [Phase 7] Subsystem IIO ADC, CONFIG_MAX1241 tristate “module will be
  called max1241”
- [Phase 8] Failure mode: missing autoload, severity LOW–MEDIUM; risk
  very low
- UNVERIFIED: real-world count of non-DT max1241 boards (no evidence
  found; not used as a YES driver)
- UNVERIFIED: WebFetch lore (403/timeout); replaced by `b4 dig` mbox +
  curl

The patch is a one-line, obviously correct module-alias export for an
existing SPI id table. This tree has the driver (since v5.8). It matches
the device-ID/module-alias exception and current stable practice for
“publish the module alias” fixes, with negligible regression risk.

**YES**

 drivers/iio/adc/max1241.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/adc/max1241.c b/drivers/iio/adc/max1241.c
index d62c1a0116593..cab04beae7293 100644
--- a/drivers/iio/adc/max1241.c
+++ b/drivers/iio/adc/max1241.c
@@ -179,6 +179,7 @@ static const struct spi_device_id max1241_id[] = {
 	{ "max1241", max1241 },
 	{ }
 };
+MODULE_DEVICE_TABLE(spi, max1241_id);
 
 static const struct of_device_id max1241_dt_ids[] = {
 	{ .compatible = "maxim,max1241" },
-- 
2.53.0

