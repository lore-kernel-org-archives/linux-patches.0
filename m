Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37AA470863;
	Mon, 19 Oct 2026 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418553; cv=none; b=I75bD6YQH//Ihke0nYAntmjsn+NNnZ9z6FSej6PyU46Yx+f6CoUK1jgoFcUFmRNPBAMRCDCIele4FNuhRIsKT/a8bTLikeoHnbl0nReN1jlvNG/ezQmyPvdRTgWcmOyxIXTOCAQMFVuQOCZ0b6E0DnDoucfgmeNSSgThShvoBWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418553; c=relaxed/simple;
	bh=SALaivAsnL7FdkP8FKu4Ia33qbK1Qf9r0RS8fYakPLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoXVxhatRGfSaRjdtzaAA8EiiIYna4cpPV897o1S3HTBXFEHO0axivy6JmDqOL0xuZ9sUHTd4eT316j9CaEPNQFeqLXHGFLowEjUAUu43qjLnuVGZHOYLx/+iqzEXCi1QL3t36FwTYwY9LTUi0w9aPyQpKqq/3mTapuxhjLCo40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AarvYVGa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AarvYVGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B97B1F000C7;
	Mon, 19 Oct 2026 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418550;
	bh=2XmanlZG9q0IdIO4ab4S5QYrOQ1uC6J3c0FBqZkNBk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AarvYVGaSyVcMYvNA6oH+H0Ne0hgsaOtT1iJrElTxAlzDIgucgZesAxTewmdJQ6FG
	 YYTdXOdfvgSmcfwkpT6r3UBUKzLE2VonrH4SMEnfofgTbSgxjX3eJjOaxDIdiwLEBt
	 7wyPI53ucaj6M2iN0hKeub7yrASL9buSirEb8e8E3Ib6Ul4YqSVIh322/+n3uCRVdk
	 8m4eEu2jNvg/MNpTZNf3bjRywNL6q3ViTno/S/BvXmBeWjLTpyk1R2wh7ZjQViOegc
	 TF0ey0VY7BMGYzcNHfrb32A/PFE8fhPe0UgrhXq8/SogKo211HqwUcLG7Yk6EEJqqH
	 QHKlaQZo1ZT7g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	linusw@kernel.org,
	brgl@kernel.org,
	pjw@kernel.org,
	samuel.holland@sifive.com,
	linux-gpio@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] gpio: sifive: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:50:19 -0400
Message-ID: <20261019135441.1420968-328-sashal@kernel.org>
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

[ Upstream commit 8fe6fa0f223f44b8b869319d1b9c383749aa147b ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704122230.75964-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the local-tree identity, the one-line diff, and the mailing-list
thread, including the GPIO maintainer asking for a `Fixes:`/`Cc: stable`
resend. Compiling the nine-phase verdict next.

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
- Record: `[gpio] [add] add missing MODULE_DEVICE_TABLE() so OF module
  aliases are generated`

**Step 1.2: Tags**
- Record:
  - `Fixes:` — none (expected)
  - `Reported-by:` — none
  - `Tested-by:` — none
  - `Reviewed-by:` — none on the applied commit
  - `Acked-by:` — none
  - `Link: https://patch.msgid.link/20260704122230.75964-1-
    pengpeng@iscas.ac.cn`
  - `Cc: stable@vger.kernel.org` — none (expected)
  - `Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>` (author)
  - `Signed-off-by: Bartosz Golaszewski
    <bartosz.golaszewski@oss.qualcomm.com>` (GPIO maintainer, committer)
  - Notable: no syzbot, no user crash report. Maintainer SOB is a
    quality signal.

**Step 1.3: Body**
- Record: **Bug:** `sifive_gpio_match[]` is wired to `.of_match_table`
  but not published via `MODULE_DEVICE_TABLE()`, so modpost does not
  emit OF aliases. **Symptom:** `gpio-sifive.ko` does not autoload from
  DT compatible strings (`sifive,gpio0`, `sifive,fu540-c000-gpio`).
  **Version info:** none in the message. **Root cause:** missing module-
  alias publication, not a runtime logic error in probe. The “source-
  level fix / no dynamic hardware reproduction” wording is extra
  justification, not a different bug.

**Step 1.4: Hidden bug fix?**
- Record: Not hidden. This is an explicit autoload fix. “Add missing
  MODULE_DEVICE_TABLE” is a standard class of real functional bugs for
  `tristate` OF drivers.

## Phase 2: Diff analysis

**Step 2.1: Inventory**
- Record: `drivers/gpio/gpio-sifive.c` — **+1 / -0**. One insertion
  after `sifive_gpio_match[]`. No functions changed. **Scope:** single-
  file surgical fix.

**Step 2.2: Code flow**
- Record: **Before:** OF match table exists and is used by
  `platform_driver.driver.of_match_table`, so a *already loaded* driver
  still binds. No `__mod_device_table__*` alias is emitted, so kmod/udev
  cannot load the module from DT. **After:** `MODULE_DEVICE_TABLE(of,
  sifive_gpio_match)` creates a used alias to that table;
  `scripts/mod/file2alias.c` (`do_of_entry`) emits
  `of:N*T*Csifive,gpio0` / `sifive,fu540-c000-gpio` aliases. **Path
  affected:** build-time modpost / userspace autoload only. Probe and
  IRQ setup are unchanged.

**Step 2.3: Bug mechanism**
- Record: **Category:** hardware enablement / missing module alias
  (logic/correctness at the module-loading boundary). **Mechanism:**
  `CONFIG_GPIO_SIFIVE=m` never autoloads; GPIO controller stays unbound
  unless `modprobe` is done by hand. Same class as device-ID additions:
  existing driver, existing hardware, missing match publication.

**Step 2.4: Fix quality**
- Record: Obviously correct one-liner; this is the documented way to
  export OF aliases. No locking, no API, no data-structure change.
  **Regression risk:** negligible. For `=y` it is a no-op at runtime. No
  new userspace ABI beyond standard `modules.alias` entries.

## Phase 3: Git history

**Step 3.1: Blame**
- Record: Match table introduced in `96868dce644d0` (“gpio/sifive: Add
  GPIO driver for SiFive SoCs”, 2019; in `v5.5-rc4`). Originally `bool`
  + `builtin_platform_driver()`, so `MODULE_DEVICE_TABLE` was not
  required. Bug became real in `6b4c76ded35826` (“gpio: sifive: Allow
  building the driver as a module”, 2023-07-25) which switched Kconfig
  to `tristate` and `module_platform_driver()` **without** adding
  `MODULE_DEVICE_TABLE`. That commit is in `v6.6-rc1` and later.
  `of_match_table = sifive_gpio_match` confirmed via blame
  (`6ae42529547a4f` dropped `of_match_ptr` in 2023).

**Step 3.2: Fixes: tag**
- Record: No `Fixes:` on the candidate. The implicit Fixes target is
  `6b4c76ded35826`, which **is** an ancestor of this tree (`git merge-
  base --is-ancestor` succeeded). GPIO maintainer Bartosz said the same
  on list (Phase 4).

**Step 3.3: File history**
- Record: Recent `gpio-sifive.c` work is generic-chip API
  (`8e1c8ccc1df8b`) and the modular conversion. No prerequisite series
  for this one line. Standalone.

**Step 3.4: Author**
- Record: Pengpeng Hou is not the GPIO maintainer; same-day sibling
  `975a1d61260cf` (“gpio: vf610: add missing MODULE_DEVICE_TABLE()”).
  Samuel Holland (SiFive, author of the modular conversion) sent the
  identical one-line change earlier (Oct 2025) as “Support module
  autoloading”.

**Step 3.5: Dependencies**
- Record: Needs `sifive_gpio_match[]`, `module_platform_driver()`, and
  `MODULE_DEVICE_TABLE(of, ...)`. All exist in this checkout. Applies
  standalone.

## Phase 4: Mailing list / external

**Step 4.1: Original discussion**
- Record: `b4 dig -c 8fe6fa0f223f44` matched patch-id to:
  - v1 (applied):
    https://patch.msgid.link/20260704122230.75964-1-pengpeng@iscas.ac.cn
    (2026-07-04, Pengpeng Hou)
  - Same diff, earlier: https://patch.msgid.link/20251016003631.3912523-
    1-samuel.holland@sifive.com (2025-10-15, Samuel Holland)
- Single revision of Pengpeng’s patch. Bartosz: “Applied, thanks!”
  (2026-07-06). No NAK.
- On Samuel’s earlier post, Bartosz wrote it should have been part of
  `6b4c76ded358` and asked him to **resend with `Fixes:` and `Cc:
  stable`**. That resend did not land; Pengpeng’s later patch (without
  those tags) was applied instead.

**Step 4.2: Recipients (`b4 dig -w`)**
- Record: Pengpeng Hou, Linus Walleij, Bartosz Golaszewski, Paul
  Walmsley, Samuel Holland, `linux-gpio`, `linux-riscv`, `linux-kernel`.
  GPIO maintainers were on To/Cc.

**Step 4.3: Bug report**
- Record: No syzbot/bugzilla. Evidence is source-level plus vendor
  (SiFive) sending the same patch. No count of field reports.

**Step 4.4: Series**
- Record: Standalone 1/1. Sibling vf610 fix is a separate driver, not a
  dependency.

**Step 4.5: Stable list**
- Record: lore.kernel.org via WebFetch returned 403. Stable-list search
  **UNVERIFIED** by HTTP. Maintainer request for `Cc: stable` is from
  `linux-gpio` mbox, not from `stable@`.

## Phase 5: Semantic analysis

**Step 5.1: Functions**
- Record: No functions modified. Added `MODULE_DEVICE_TABLE(of,
  sifive_gpio_match)` after `sifive_gpio_match[]`. Related symbols:
  `sifive_gpio_probe`, `sifive_gpio_driver`.

**Step 5.2: Callers**
- Record: `sifive_gpio_probe` is the platform `.probe`. Driver core
  calls it when OF compatible matches **and the module is already
  loaded**. Autoload is userspace (kmod) using aliases from
  `MODULE_DEVICE_TABLE`. Not IRQ/hot-path.

**Step 5.3: Callees**
- Record: Unchanged. Probe still uses generic GPIO + irqchip
  registration.

**Step 5.4: Reachability**
- Record: Reachable on SiFive FU540/FU740 and Canaan K210 DT
  (`compatible = "sifive,gpio0"` / `"sifive,fu540-c000-gpio"`).
  Userspace-visible: without aliases, GPIO never appears unless the
  module is forced. Not a syscall crash path.

**Step 5.5: Similar patterns**
- Record: Same pattern in-tree: `gpio: lpc32xx: fix module autoloading`,
  `gpio: modepin: Enable module autoloading`, `gpio: vf610: add missing
  MODULE_DEVICE_TABLE()`, `gpio: cadence: Add missing
  MODULE_DEVICE_TABLE`. Established GPIO-subsystem practice.

## Phase 6: Local tree (this checkout only)

**Step 6.1: Buggy code in this tree?**
- Record: Checkout is **Linus `origin/master`**, `git describe` =
  `v7.3-rc4-27-gf0100363d8c37`, Makefile **7.3.0-rc4**. `gpio-sifive.c`,
  `sifive_gpio_match[]`, `tristate GPIO_SIFIVE`, and
  `module_platform_driver()` are all present. Modular conversion
  `6b4c76ded35826` is an ancestor. The one-line alias export belongs on
  this code. In-tree DT: `arch/riscv/boot/dts/sifive/fu540-c000.dtsi`,
  `fu740-c000.dtsi`, `arch/riscv/boot/dts/canaan/k210.dtsi`. Defconfigs
  (`arch/riscv/configs/defconfig`, K210 defconfigs) set
  `CONFIG_GPIO_SIFIVE=y`, so *default* RISC-V configs do not hit
  autoload; `=m` (the reason the driver was made modular: multiplatform
  image size) does.

**Step 6.2: Backport difficulty**
- Record: Clean apply. Only needs the `of_device_id` table name
  `sifive_gpio_match`. No conflict with later generic-chip changes.

**Step 6.3: Related fixes already here**
- Record: No earlier alternate autoload fix. This is the first
  `MODULE_DEVICE_TABLE` on this file.

## Phase 7: Subsystem context

**Step 7.1**
- Record: **Subsystem:** GPIO (`drivers/gpio/`). **Criticality:**
  IMPORTANT for SiFive/K210 boards (GPIO is a board-level dependency),
  PERIPHERAL vs core mm/net. Not staging.

**Step 7.2**
- Record: GPIO is actively maintained (Bartosz). This driver is mature
  (since v5.5); the modular hole is from v6.6, not new experimental
  code.

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
- Record: Driver-specific, config-specific: `CONFIG_GPIO_SIFIVE=m` on DT
  platforms with those compatibles. Not universal.

**Step 8.2: Trigger**
- Record: Boot / device enumeration with the module not preloaded.
  Common for multiplatform modular kernels (the stated goal of
  `6b4c76ded358`). Unprivileged users do not trigger a crash; the
  controller simply never binds. Not a race.

**Step 8.3: Failure mode**
- Record: GPIO chip (and its irqchip) never registers if the module is
  not loaded. Dependent LEDs, resets, keys, hog lines fail. **Severity:
  MEDIUM** functionally (hardware dead until `modprobe`), not panic/UAF.
  For those boards that is user-visible breakage, not cosmetic.

**Step 8.4: Risk-benefit**
- Record: **Benefit:** high for `=m` SiFive/K210 users; restores the
  modular conversion’s purpose. **Risk:** very low (1 line, build-time
  alias only). **Ratio:** strongly favorable. Matches the device-ID /
  hardware-enablement exception.

## Phase 9: Synthesis

**Step 9.1: Evidence**
- **For:** Real autoload bug; 1-line obviously correct; GPIO maintainer
  asked for `Fixes:` + `Cc: stable` on the identical diff; SiFive
  engineer sent that diff; driver is `tristate` since v6.6; DT hardware
  exists; zero runtime regression surface; same pattern already used
  across GPIO.
- **Against:** Not a crash/security/corruption issue; in-tree defconfigs
  use `=y`; no `Reported-by`; Pengpeng’s applied patch omitted the
  `Fixes:`/`Cc: stable` Bartosz asked for.
- **Unresolved:** Stable-list archive (lore HTTP 403). No field bugzilla
  count.

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — canonical
   `MODULE_DEVICE_TABLE(of, …)`; maintainer applied it.
2. Real bug affecting users? **PASS** — `=m` never autoloads; modular
   conversion is pointless without it.
3. Important (crash/security/corruption/deadlock)? **PASS** as hardware-
   enablement (GPIO controller never binds), same bar as new device IDs
   / missing aliases — not a panic, but the device does not work.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features/APIs? **PASS** — aliases for existing compatibles.
6. Can apply to this tree? **PASS** — table, tristate Kconfig, and
   `module_platform_driver()` are here.

**Step 9.3: Exception category**
- Record: Closest to **device ID / hardware enablement**: publishing
  existing OF IDs so the existing driver autoloads. Not a new driver or
  API.

**Step 9.4: Decision**
This tree has the SiFive GPIO driver as a module-capable OF platform
driver with a match table that was never exported. That is a real,
contained autoload bug. The GPIO maintainer already treated the
identical change as stable material. It should be backported here.

### What the commit solves for this tree
Without `MODULE_DEVICE_TABLE(of, sifive_gpio_match)`, `modpost` never
writes OF aliases, so `gpio-sifive.ko` will not load from
`"sifive,gpio0"` / `"sifive,fu540-c000-gpio"`. On `CONFIG_GPIO_SIFIVE=m`
the GPIO (and irq) controller never appears unless someone `modprobe`s
it. That undercuts `6b4c76ded358` (“Allow building the driver as a
module”) on multiplatform kernels. Built-in `=y` is unaffected; the one-
liner is still correct and harmless.

### Risk vs benefit
Benefit is restoring autoload for real FU540/FU740/K210 hardware when
the driver is modular. Risk is a single build-time alias with no
probe/locking/API change.

### Concerns
No `Fixes:` on the applied commit (should be `6b4c76ded35826`); that
does not block backport. In-tree defconfigs use `=y`, so default images
already work; the users who need this are modular/multiplatform configs,
which is exactly who the tristate change was for.

Verification:
- [Phase 1] Parsed tags: Link to msgid
  `20260704122230.75964-1-pengpeng@iscas.ac.cn`; SOB Pengpeng Hou and
  Bartosz Golaszewski; no Fixes/Reported-by/Cc: stable
- [Phase 2] Diff: +1 line `MODULE_DEVICE_TABLE(of, sifive_gpio_match)`
  in `drivers/gpio/gpio-sifive.c`; probe unchanged
- [Phase 2] Confirmed `MODULE_DEVICE_TABLE` in `include/linux/module.h`
  and OF alias emission via `scripts/mod/file2alias.c` `do_of_entry`
- [Phase 3] `git blame`: match table from `96868dce644d0` (v5.5-rc4);
  modular bug from `6b4c76ded35826` (in v6.6-rc1); `git merge-base --is-
  ancestor 6b4c76ded35826 HEAD` succeeded
- [Phase 3] `git show 6b4c76ded35826`: bool→tristate +
  `builtin_platform_driver` → `module_platform_driver` without
  MODULE_DEVICE_TABLE
- [Phase 3] Author log: sibling vf610 commit `975a1d61260cf`
- [Phase 4] `b4 dig -c 8fe6fa0f223f44`: Pengpeng v1 applied; same patch-
  id as Samuel Holland Oct 2025
- [Phase 4] `b4 dig -a`: single Pengpeng revision; `b4 dig -w`: GPIO
  maintainers + linux-gpio/linux-riscv
- [Phase 4] mbox: Bartosz asked Samuel for Fixes: + Cc: stable; later
  “Applied, thanks!” on Pengpeng’s patch
- [Phase 4] WebFetch lore.kernel.org: 403 — UNVERIFIED via HTTP; thread
  recovered with b4 mbox
- [Phase 5] Callers: platform probe + OF match table; autoload is
  userspace/kmod, not a kernel hot path
- [Phase 5] Similar GPIO autoload fixes: `11baa36d31732`,
  `a5135526426df`, `e6382fcf98907`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; detached `origin/master`
- [Phase 6] Kconfig `GPIO_SIFIVE` is `tristate`; DT nodes present;
  defconfigs use `=y`
- [Phase 8] Failure mode: module not autoloaded → GPIO controller
  absent; severity MEDIUM functional / hardware-enablement
- UNVERIFIED: whether this exact commit was discussed on
  `stable@vger.kernel.org` (lore HTTP 403)
- UNVERIFIED: how many distro configs set `CONFIG_GPIO_SIFIVE=m`

**YES**

 drivers/gpio/gpio-sifive.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index 94ef2efbd14f5..e9a992cd4b9cd 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -260,6 +260,7 @@ static const struct of_device_id sifive_gpio_match[] = {
 	{ .compatible = "sifive,fu540-c000-gpio" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, sifive_gpio_match);
 
 static struct platform_driver sifive_gpio_driver = {
 	.probe		= sifive_gpio_probe,
-- 
2.53.0

