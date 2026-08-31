Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB442E425;
	Mon, 31 Aug 2026 13:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183217; cv=none; b=DBCWm4ZPdQdFQwWA9qA/fMQmby84n5vXiSIArM85SJZeQhIdn5fDWDW1ZegUg1Zi8nRUJ6dghYbSiFZ97cazNnkwcUKyybLryadxsJHW05aZlZx9ievaMUoCG4Ptq/6iLr4w/B1XnDkVV+adbnlFbYT8Gg7KwHnSOHbJht50kAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183217; c=relaxed/simple;
	bh=te9lBsObeD2HvG+eVSNqGwRxdEUCCwxOLWUiuE/QCkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OIdeAn+9Bz7orPfNH60dCgYALuYiG2/ik/vCSjgx+57+CmyJseRsZOZUHD3r3UF0jcxIPm39VXQEIE8stOHbsL509Ht3NJksHWW/4BSCjwDwTVxaOkEsyconNJw+LF+O5ltfJU9uCcnHTujeLJ1DIUKGJz0KaHqBzKKwtHNBvJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8K2SMBy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8K2SMBy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8B11F00A3D;
	Mon, 31 Aug 2026 13:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183214;
	bh=pNF0DMU5ekme0mlE1jwe1Y2+gkGX3ce/3LSBh3uopR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8K2SMByOS+WBVBAEFkc+VmcOgHnwxyCFZIWbSc6J8fOx1UrIjHecDWk+XeKaABoa
	 fSEL+1SFth+TYwE4PmllcCcfer0eSbPCYcmS4jIfFChfyevKIpKr+Nrdi8++cL6De/
	 /5rThEDaKkkGsELksB64nEZ2C/AjXzfjYPG6HSwoTmqawTQ1Lpk2EH7gXEPvSb2sAG
	 tVMNVvdSS5mzlYtL7KcjF8afyt+QJl7QgaVEaWoIgEZl8eqEMS/72rlGhIF6355Xd1
	 M0xcMexd451DCJPLLh+oqJF4Awdvz1pxLU8zwSGJLJhtnCYQ+czNgXkudylPx7lD9z
	 pyo21ceOJWb2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Lin <thomas_lin@lecomputing.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rafael@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] spi: dw-mmio: Add ACPI ID LECA0002 for LECARC SoCs
Date: Mon, 31 Aug 2026 09:20:41 -0400
Message-ID: <20260831133314.4125787-13-sashal@kernel.org>
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

From: Thomas Lin <thomas_lin@lecomputing.com>

[ Upstream commit 019947c495850461242fdcc0780258805595036c ]

This ID requires a custom initialization function
dw_spi_hssi_no_dma_init() that sets dws->dws.ip to DW_HSSI_ID.

Signed-off-by: Thomas Lin <thomas_lin@lecomputing.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260521-lecarc-acpi-ids-v1-2-ae0ae90b2817@lecomputing.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: `spi: dw-mmio: Add ACPI ID LECA0002 for
LECARC SoCs`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD at
`1efe5d048a391`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[spi: dw-mmio]` `[Add]` — Add ACPI ID `LECA0002` for LECARC
SoCs SPI controller enablement on ACPI/ARM64 platforms.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Thomas Lin \<thomas_lin@lecomputing.com\> (author)
- **Reviewed-by:** Andy Shevchenko \<andriy.shevchenko@linux.intel.com\>
- **Link:** https://patch.msgid.link/20260521-lecarc-acpi-
  ids-v1-2-ae0ae90b2817@lecomputing.com
- **Signed-off-by:** Mark Brown \<broonie@kernel.org\> (SPI maintainer
  merge tag in final commit)
- **Acked-by:** Mark Brown (in v1 mbox submission)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@
- Notable: subsystem maintainer ack; no syzbot/user bug reports

### Step 1.3: Body text
**Record:**
- **Bug description:** LECARC SoCs expose SPI via ACPI HID `LECA0002`;
  without this ID the existing `dw_spi_mmio` driver does not bind.
- **Symptom:** SPI controller non-functional on LECARC ACPI boots (no
  driver probe).
- **Root cause:** Missing ACPI ID in `acpi_apd.c` (clock/platform device
  creation) and `spi-dw-mmio.c` (driver match + HSSI init).
- **Init requirement:** Must use `dw_spi_hssi_no_dma_init()` to set
  `dws->ip = DW_HSSI_ID` (HSSI register layout, no DMA).
- **Version info:** None explicit; part of v5 series dated 2026-05-21.

### Step 1.4: Hidden bug fix?
**Record:** No — this is hardware enablement (ACPI ID addition), not a
regression fix. The function rename (`dw_spi_intel_init` →
`dw_spi_hssi_no_dma_init`) is cosmetic; behavior is unchanged. Without
the ACPI entry, hardware simply does not probe; there is no pre-existing
broken path for current 6.18.y users.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
| File | Changes |
|------|---------|
| `drivers/acpi/acpi_apd.c` | +6 lines (new `leca_spi_desc`, table
entry) |
| `drivers/spi/spi-dw-mmio.c` | +2 lines net (rename + ACPI entry) |
| **Total:** ~15 lines | **Functions:** none structurally changed;
rename only |
| **Scope:** Single-subsystem, surgical ACPI ID addition |

### Step 2.2: Code flow per hunk
**Record:**
1. **`acpi_apd.c` — `leca_spi_desc`:** Adds APD descriptor with
   `fixed_clk_rate = 400000000` so ACPI scan creates a platform device
   with correct clock for `LECA0002`.
2. **`acpi_apd.c` — device ID table:** Maps `"LECA0002"` →
   `leca_spi_desc` under `CONFIG_ARM64`.
3. **`spi-dw-mmio.c` — rename:** `dw_spi_intel_init` →
   `dw_spi_hssi_no_dma_init`; identical body (sets `DW_HSSI_ID`, no DMA
   setup).
4. **`spi-dw-mmio.c` — OF table:** Updates `intel,keembay-ssi` to use
   renamed init (no behavior change).
5. **`spi-dw-mmio.c` — ACPI table:** Adds `{"LECA0002",
   dw_spi_hssi_no_dma_init}` so driver probes and configures HSSI IP
   correctly.

**Before → After:** LECARC SPI ACPI node ignored → platform device
created + `dw_spi_mmio` probes with HSSI register programming.

### Step 2.3: Bug mechanism
**Record:** **Category:** Hardware enablement / ACPI ID addition
(exception category, not crash/leak/race fix). **Mechanism:** Without
ACPI match, `dw_spi_mmio` never probes; with probe but wrong IP type
(`dws->ip` defaults to 0 = PSSI via `devm_kzalloc`),
`dw_spi_update_config()` would use PSSI register field masks instead of
HSSI — incorrect SPI operation. The init function prevents that.

### Step 2.4: Fix quality
**Record:** Obviously correct — follows existing `HISI0173` pattern in
both `acpi_apd.c` and `spi-dw-mmio.c`. Reuses proven `dw_spi_intel_init`
logic. Minimal risk; rename is zero functional change. No API changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** `dw_spi_intel_init` introduced in `dc4e6d9fbf9a3`
(2022-07-13, Intel Keem Bay). ACPI SPI support since `32215a6c6beb8`
(2018-12-03, `HISI0173`). All prerequisite code long present in 6.18.y.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent changes to `spi-dw-mmio.c` in 6.18.y include reset
error handling (`18a5f1af596e6`), `remove` callback conversion —
unrelated to this hunk. Standalone patch; companion GPIO patch
(`LECA0001`) is separate subsystem.

### Step 3.4: Author history
**Record:** No prior Thomas Lin commits in `drivers/spi/` or
`drivers/acpi/` in this tree. First-time contributor for this platform;
patch reviewed/acked by SPI maintainer.

### Step 3.5: Dependencies
**Record:** No code dependencies on other commits. Part of 2-patch
series (GPIO + SPI) for full LECARC ACPI support, but SPI patch is self-
contained. `DW_HSSI_ID`, `dw_spi_intel_init`, ACPI framework all
present. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** `b4 am -l '20260521-lecarc-acpi-
ids-v1-2-ae0ae90b2817@lecomputing.com'` — thread found (v5, 2 patches).
Cover: `arm64: Add LECARC ACPI IDs for DesignWare GPIO, SPI`. SPI patch
acked by Mark Brown, reviewed by Andy Shevchenko. No stable nomination
found in cover or patch. No NAKs in retrieved thread.

### Step 4.2: Reviewers
**Record:** Andy Shevchenko (Reviewed-by), Mark Brown (Acked-by/Signed-
off-by), Bartosz Golaszewski reviewed GPIO patch. Appropriate subsystem
coverage.

### Step 4.3: Bug reports
**Record:** None — no user/syzbot reports. Enablement for new LE
Computing LECARC SoC platform.

### Step 4.4: Series context
**Record:** Patch 2/2 of series. Patch 1 adds `LECA0001` to `gpio-
dwapb.c` (not in 6.18.44 tree). Full platform needs both; SPI patch
independently valuable.

### Step 4.5: Stable list
**Record:** Could not search lore stable list (bot protection). No
stable discussion found in retrieved mbox.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dw_spi_hssi_no_dma_init()` (renamed from
`dw_spi_intel_init`), `acpi_apd_create_device()`, `dw_spi_mmio_probe()`,
`dw_spi_update_config()` (uses `dw_spi_ip_is()`).

### Step 5.2: Callers
**Record:** Init called from `dw_spi_mmio_probe()` via
`device_get_match_data()` when ACPI/OF matches.
`acpi_apd_create_device()` called during ACPI scan at boot. Boot-time
device enumeration path.

### Step 5.3: Callees
**Record:** Init only sets `dwsmmio->dws.ip = DW_HSSI_ID`. Probe
continues to `dw_spi_add_host()`. `dw_spi_update_config()` branches on
`dw_spi_ip_is(dws, PSSI)` vs HSSI paths.

### Step 5.4: Reachability
**Record:** Triggered at boot on LECARC hardware with ACPI +
`CONFIG_ARM64` + SPI enabled. Not userspace-triggered; affects platform
bring-up only.

### Step 5.5: Similar patterns
**Record:** `HISI0173` uses identical dual-registration pattern
(`acpi_apd.c` + `spi-dw-mmio.c`). `intel,keembay-ssi` already uses same
init via OF. LECA0002 mirrors Keem Bay HSSI-no-DMA pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy/missing code exists?
**Record:** **YES — code is missing.** `LECA0002` absent from both
`acpi_apd.c` and `spi-dw-mmio.c`. `dw_spi_intel_init` present (line
231). `LECA0001` also absent from `gpio-dwapb.c`. Infrastructure fully
present since 2018–2022.

### Step 6.2: Backport complications
**Record:** **`git apply --check` PASS** — patch applies cleanly to
6.18.44 without modification. Minor line-number offset only
(`dw_spi_remove_host` vs mainline `dw_spi_remove_controller` not in
hunks).

### Step 6.3: Related fixes already present?
**Record:** None. `git log --grep=LECA0002` and `git log --grep=lecarc`
return no matches in this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/spi/` + `drivers/acpi/` — **IMPORTANT** (common
infrastructure), but fix affects only LECARC ARM64 ACPI platform users.

### Step 7.2: Activity
**Record:** `spi-dw-mmio` actively maintained; recent stable-relevant
fixes (reset handling). Mature driver with established ACPI ID pattern.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** LECARC SoC users booting 6.18.y with ACPI on ARM64. Very
small, platform-specific population. No impact on existing hardware.

### Step 8.2: Trigger conditions
**Record:** Boot on LECARC with `LECA0002` ACPI node. Deterministic for
that hardware. Not triggerable by unprivileged users on other platforms.

### Step 8.3: Failure mode severity
**Record:** Without patch: SPI does not work (hardware non-functional) —
**MEDIUM** for affected users (platform bring-up blocked), **NONE** for
everyone else. Not a crash/corruption on existing systems.

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables SPI on LECARC for 6.18.y distributors shipping
  that hardware — aligns with official stable rule allowing device ID
  additions.
- **Risk:** Very low — ~15 lines, table entries only, no logic changes
  beyond rename.
- **Ratio:** High benefit for LECARC users, negligible risk for all
  others.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence compile

**FOR backport:**
- Official `stable-kernel-rules.rst` line 15: *"must either fix a real
  bug … or **just add a device ID**"*
- ACPI ID addition to existing `dw_spi_mmio` and `acpi_apd` drivers —
  textbook stable exception
- Small (~15 lines), reviewed, maintainer-acked
- Applies cleanly to 6.18.44
- Follows established `HISI0173` pattern
- Correct HSSI init prevents wrong register programming if probed

**AGAINST backport:**
- Not a bug fix for existing 6.18.y users
- Very niche hardware (LECARC)
- Companion GPIO patch (`LECA0001`) also needed for full platform
- Must land in mainline first (procedural stable requirement)
- No user bug reports or crash reports

**Unresolved:** Whether commit is merged to mainline yet (not in
6.18.44); lore stable-list search blocked.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — maintainer ack, reviewer
   sign-off, mirrors existing IDs
2. Fixes real bug affecting users? **PASS** — via device-ID exception;
   SPI non-functional without it on LECARC
3. Important issue? **PASS (qualified)** — platform hardware enablement
   for affected users; not crash/security
4. Small and contained? **PASS** — ~15 lines, 2 files
5. No new features/APIs? **PASS** — ACPI ID only; no new uapi
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception category
**Record:** **NEW DEVICE ID (ACPI ID)** — explicitly permitted by
stable-kernel-rules.rst and analysis guidelines.

### Step 9.4: Decision rationale

For **Linux 6.18.y**, this commit adds an ACPI HID to two existing,
mature drivers so LECARC SPI hardware can probe and operate correctly.
It does not fix a regression affecting current users, but stable rules
explicitly allow backports that *"just add a device ID."* The change is
minimal, maintainer-reviewed, applies cleanly, and reuses existing init
logic. Distributors shipping LECARC on 6.18.y need this patch.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from user-provided commit and
  mbox
- **[Phase 2]** Diff analysis: 2 files, ~15 lines; rename verified
  identical to `dw_spi_intel_init`
- **[Phase 3]** `git describe HEAD` → v6.18.44; `git blame` on lines
  231–237 → `dc4e6d9fbf9a3` (2022); ACPI support `32215a6c6beb8` (2018)
- **[Phase 3]** `git log --oneline -15 -- drivers/spi/spi-dw-mmio.c
  drivers/acpi/acpi_apd.c` — no LECA commits
- **[Phase 3]** `git log --grep=LECA0002` / `--grep=lecarc` — no matches
  in tree
- **[Phase 4]** `b4 am -l` on msgid — v5 series, 2 patches, Mark Brown
  Acked-by
- **[Phase 4]** Read cover letter and mbox — platform enablement, no
  stable Cc
- **[Phase 4]** lore.kernel.org WebFetch — blocked by bot protection
- **[Phase 5]** `grep dw_spi_ip_is` — IP type controls register
  programming in `spi-dw-core.c`
- **[Phase 5]** `dw_spi_mmio_probe` — init via `device_get_match_data()`
  at line 376
- **[Phase 6]** `grep LECA0002` — not present in tree
- **[Phase 6]** `grep dw_spi_intel_init` — present at lines 231, 416
- **[Phase 6]** `git apply --check` — **clean apply confirmed**
- **[Phase 6]** `grep LECA0001` in gpio-dwapb — not present (companion
  patch missing)
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst`
  line 15 — device ID exception confirmed
- **[Phase 8]** Impact: platform-specific SPI enablement only

---

**YES**The background git searches finished: there are **no commits** in
this 6.18.44 tree matching `LECA0002`, `lecarc`, or `dw_spi_intel_init`
in commit messages. That confirms the LECARC SPI ACPI support isn’t
present yet and nothing equivalent was already backported.

That lines up with the earlier analysis: the patch applies cleanly here
and is a good stable candidate under the ACPI device-ID exception. The
companion GPIO patch (`LECA0001`) is also still missing from this tree
if full LECARC ACPI bring-up is needed.

 drivers/acpi/acpi_apd.c   | 7 +++++++
 drivers/spi/spi-dw-mmio.c | 7 ++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/acpi_apd.c b/drivers/acpi/acpi_apd.c
index 49539f7528c64..cd0fcfaeafc75 100644
--- a/drivers/acpi/acpi_apd.c
+++ b/drivers/acpi/acpi_apd.c
@@ -181,6 +181,12 @@ static const struct apd_device_desc hip08_spi_desc = {
 	.setup = acpi_apd_setup,
 	.fixed_clk_rate = 250000000,
 };
+
+static const struct apd_device_desc leca_spi_desc = {
+	.setup = acpi_apd_setup,
+	.fixed_clk_rate = 400000000,
+};
+
 #endif /* CONFIG_ARM64 */
 
 #endif
@@ -251,6 +257,7 @@ static const struct acpi_device_id acpi_apd_device_ids[] = {
 	{ "HISI02A2", APD_ADDR(hip08_i2c_desc) },
 	{ "HISI02A3", APD_ADDR(hip08_lite_i2c_desc) },
 	{ "HISI0173", APD_ADDR(hip08_spi_desc) },
+	{ "LECA0002", APD_ADDR(leca_spi_desc) },
 	{ "NXP0001", APD_ADDR(nxp_i2c_desc) },
 #endif
 	{ }
diff --git a/drivers/spi/spi-dw-mmio.c b/drivers/spi/spi-dw-mmio.c
index 7a5197586919c..8f7afe0e49aea 100644
--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -228,8 +228,8 @@ static int dw_spi_hssi_init(struct platform_device *pdev,
 	return 0;
 }
 
-static int dw_spi_intel_init(struct platform_device *pdev,
-			     struct dw_spi_mmio *dwsmmio)
+static int dw_spi_hssi_no_dma_init(struct platform_device *pdev,
+				   struct dw_spi_mmio *dwsmmio)
 {
 	dwsmmio->dws.ip = DW_HSSI_ID;
 
@@ -413,7 +413,7 @@ static const struct of_device_id dw_spi_mmio_of_match[] = {
 	{ .compatible = "amazon,alpine-dw-apb-ssi", .data = dw_spi_alpine_init},
 	{ .compatible = "renesas,rzn1-spi", .data = dw_spi_pssi_init},
 	{ .compatible = "snps,dwc-ssi-1.01a", .data = dw_spi_hssi_init},
-	{ .compatible = "intel,keembay-ssi", .data = dw_spi_intel_init},
+	{ .compatible = "intel,keembay-ssi", .data = dw_spi_hssi_no_dma_init},
 	{
 		.compatible = "intel,mountevans-imc-ssi",
 		.data = dw_spi_mountevans_imc_init,
@@ -428,6 +428,7 @@ MODULE_DEVICE_TABLE(of, dw_spi_mmio_of_match);
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id dw_spi_mmio_acpi_match[] = {
 	{"HISI0173", (kernel_ulong_t)dw_spi_pssi_init},
+	{"LECA0002", (kernel_ulong_t)dw_spi_hssi_no_dma_init},
 	{},
 };
 MODULE_DEVICE_TABLE(acpi, dw_spi_mmio_acpi_match);
-- 
2.53.0

