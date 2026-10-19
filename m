Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298DC6441D5;
	Mon, 19 Oct 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418784; cv=none; b=WYV1KozQ5ce6FuRT+lvvyEOb1gcwotDML5S3eBDdPwXg6CkbRMk39ZUTM6P3hLc3C8Kjy4KgF0jAezFQGpU6WLXRgy46dcJ3MKOYQMLpJGMNnr9gzyF8YT2FI9c4xqwfQTsg+Rfp0t4pGVG5aR0EfSeRF79jxS+ibiWFbEIp18w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418784; c=relaxed/simple;
	bh=BRYx6sfi+qaICiszrnJe7Au12YDnz4CgawoZ2q31LV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E2G94hRgys3gCNwxTgRWhRG2eaJlt7eaelLdqaPt/i+ovmJ8HX+v+9logcqu/y4EZ63nIGCOCGwuQIUkGiGIFcSAyo1olfxe+svyTK5rhzXsUawsfXPKMwUrWYcjsM6K/jyWipuBaoq6zPLQ3h7EZCrKqMziRhtnpoo5RBiqABg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/q02KXl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/q02KXl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164011F000C4;
	Mon, 19 Oct 2026 14:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418781;
	bh=DVtJR1vmE5OFuJ9R/f1sgyN9djO4OQA8APg4XWGVC2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H/q02KXl/2JLuuMAa5af43kcxUmUv6+Swj3sWhMW1oHtTMj/TlLuNlcANoBjv6/Zq
	 YN/U+3IWvGUNG1Opt0qmku6ZFiFs/Rz/IEN373rpm7PI+c9UPU/aohrWlltbrqJATG
	 XHvbmr3jRShmBkSENK34BNnSdN7sScQhXiSLY0zoBPiHGKC6lteIUYsrC6qeAnthTd
	 MEWdV9B9BnZ7bSQKs5o0w6dcPC6Qh0iqNiHBrWGQOUs2U3Dk6IUAJUfbPFZzyB7kXT
	 k2UiVehnnX20nauVH8kneerMk9O7rFBHJqks8L7uePaIyh2s6ckhuqtEMATSAuMBr0
	 uPUqsb09H/GRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	brgl@kernel.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] gpio: vf610: add missing MODULE_DEVICE_TABLE()
Date: Mon, 19 Oct 2026 09:53:02 -0400
Message-ID: <20261019135441.1420968-491-sashal@kernel.org>
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

[ Upstream commit 975a1d61260cf74d467f34898fade63165c80735 ]

The driver has an OF match table wired to .of_match_table, but does
not export the table with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
information is generated for OF based module autoloading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the platform driver, and the missing module alias publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260704122123.73004-1-pengpeng@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the mailing-list thread, version mapping, and driver context.
Compiling the nine-phase analysis and verdict next.

---

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[gpio: vf610:] [add] [missing MODULE_DEVICE_TABLE() so OF
module aliases are generated]`

- Subsystem: `gpio: vf610` (Freescale/NXP VF610 / i.MX GPIO driver)
- Action verb: **add** (missing export — a functional gap, not a new
  feature)
- Claimed intent: export the existing OF match table for module
  autoloading

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- **Fixes:** none (expected; not a negative signal)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by:** Linus Walleij `<linusw@kernel.org>` (GPIO subsystem
  veteran / former GPIO maintainer)
- **Acked-by:** none
- **Link:**
  `https://patch.msgid.link/20260704122123.73004-1-pengpeng@iscas.ac.cn`
- **Cc: stable:** none (expected)
- **Signed-off-by:** Pengpeng Hou `<pengpeng@iscas.ac.cn>` (author)
- **Signed-off-by:** Bartosz Golaszewski
  `<bartosz.golaszewski@oss.qualcomm.com>` (current GPIO maintainer who
  applied it)

Ignored per instructions: any pipeline “Upstream commit” / Sasha Levin
SOB (none present on the real commit).

Notable: maintainer-applied, reviewed by a GPIO expert. No user/syzbot
report.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `vf610_gpio_dt_ids` is wired to `.of_match_table` but is not
  published with `MODULE_DEVICE_TABLE(of, ...)`.
- **Symptom:** when `CONFIG_GPIO_VF610=m`, modpost does not emit
  `of:N*T*C...` aliases, so udev/modprobe will not autoload `gpio-vf610`
  from DT compatible strings (`fsl,vf610-gpio`, `fsl,imx7ulp-gpio`,
  `fsl,imx8ulp-gpio`).
- **Version info in message:** none
- **Root cause (author):** match table exists and is used by the
  platform driver; only the module-alias publication is missing. Author
  explicitly calls it a **source-level** fix with no dynamic hardware
  repro.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: **Not a disguised cleanup.** It is an explicit missing-export
fix. The “add missing” wording is the standard pattern for module-
autoload bugs. It is not a refactor, API, or feature.

---

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/gpio/gpio-vf610.c` — **+1 / −0**
- Function/object: file-scope `vf610_gpio_dt_ids[]` (not a function
  body)
- Scope: **single-file surgical fix** (one macro)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record:
- **Before:** `vf610_gpio_dt_ids` is a `const struct of_device_id[]`
  used only as `vf610_gpio_driver.driver.of_match_table`. Runtime OF
  matching still works **if the module is already loaded or the driver
  is built-in**.
- **After:** `MODULE_DEVICE_TABLE(of, vf610_gpio_dt_ids)` creates a
  `__mod_of__vf610_gpio_dt_ids_device_table` alias (see
  `include/linux/module.h`) so `scripts/mod/file2alias.c` / modpost
  emits OF modaliases into `.modinfo`.
- Path affected: **build-time module metadata only**, not probe, IRQ, or
  GPIO runtime.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record:
- **Category:** hardware enablement / module autoload (OF analogue of
  missing device IDs)
- **Mechanism:** without the alias, a modular driver is never bound to
  DT nodes unless something else loads it (`modprobe gpio-vf610`,
  initramfs list, etc.). GPIO chip never registers → pins/IRQs missing
  on affected boards.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- **Quality:** obviously correct; this is the canonical one-line fix
  used across GPIO and many other subsystems.
- **Regression risk:** **very low**. The macro is `__attribute__((used,
  alias(...)))`; it does not change probe, locking, or exported APIs.
  Built-in builds ignore module aliases.

---

## Phase 3: Git history investigation

**Step 3.1: BLAME THE CHANGED LINES**

Record:
- Match table introduced with the driver in `7f2691a19627a8` (Stefan
  Agner, 2014) — originally **built-in only** (`bool` +
  `builtin_platform_driver`).
- Compatible entries updated later: `fsl,imx7ulp-gpio` (2017),
  `fsl,imx8ulp-gpio` (2023).
- **Bug became real** when the driver was made modular:

`73dc041f8a602` — `gpio: vf610: Allow building as a module` (Jindong
Yue, 2025-04-16; merged for **v6.16**)

That commit switched Kconfig to `tristate` and `builtin_platform_driver`
→ `module_platform_driver` **without** adding `MODULE_DEVICE_TABLE`.
Reason given: Android GKI cannot carry board-specific drivers built-in.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: **No Fixes: tag.** Investigated by history instead. Introducing
commit `73dc041f8a602` **is** an ancestor of this tree (`git merge-base
--is-ancestor` succeeded). It is **in v6.16+** including this 7.3-rc4
checkout. It is **not** in v6.15.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**

Record (recent `drivers/gpio/gpio-vf610.c`):
- `975a1d61260cf` — this fix
- `656dc0c6f725a` — generic GPIO chip API (unrelated)
- `73dc041f8a602` — allow module build (**prerequisite**)
- No later commits on this file after the fix (empty
  `975a1d61260cf..HEAD`)

Standalone; not “patch X/Y”. Same-day sibling: `8fe6fa0f223f4` `gpio:
sifive: add missing MODULE_DEVICE_TABLE()` (same author, same template).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Pengpeng Hou is **not** the GPIO maintainer. This is part of a
mechanical sweep of missing `MODULE_DEVICE_TABLE()` across drivers
(gpio, rtc, vdpa, watchdog, hwmon, fbdev, soc, …). GPIO maintainer still
applied it after Walleij’s review, which keeps the change trustworthy.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Runtime prerequisite is only “driver can be a module,” which
this tree has (`tristate`, `module_platform_driver`). The one-line macro
needs no extra APIs. **Can apply standalone** on any tree that already
has `vf610_gpio_dt_ids`.

---

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 975a1d61260cf`: matched
  `https://patch.msgid.link/20260704122123.73004-1-pengpeng@iscas.ac.cn`
- `b4 dig -a`: **v1 only** (no v2/v3)
- Thread (mbox): (1) patch from Hou, (2) **Reviewed-by: Linus Walleij**,
  (3) Bartosz: **“Applied, thanks!”** →
  `brgl/c/7a6426e72ab53c7cae34952528092efd2e26edc3`
- No NAK, no stable nomination, no reviewer risk flags

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record (`b4 dig -w`): To/Cc were **Linus Walleij**, **Bartosz
Golaszewski**, `linux-gpio@vger.kernel.org`, `linux-
kernel@vger.kernel.org`. Right maintainers and list.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: no Reported-by / bugzilla / syzbot. Evidence is the missing
export, not a field crash. Same class as other “fix module autoloading”
GPIO commits (e.g. `11baa36d31732` gpio-lpc32xx, `e6382fcf98907` gpio-
spacemit).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: standalone `[PATCH]`, not a numbered series. Parallel same-day
sifive fix is independent.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — `lore.kernel.org` and `patch.msgid.link`
returned **HTTP 403** via WebFetch and curl. GPIO thread was obtained
via `b4 dig -m` (does not discuss stable).

---

## Phase 5: Code semantic analysis

**Step 5.1: KEY FUNCTIONS**

Record: no function body changed. Touches file-scope
`vf610_gpio_dt_ids[]`. Related symbols: `vf610_gpio_driver`,
`vf610_gpio_probe`, `module_platform_driver`.

**Step 5.2: TRACE CALLERS**

Record:
- `of_match_table = vf610_gpio_dt_ids` in `vf610_gpio_driver` (verified
  in-file at line 351)
- Bound via `module_platform_driver` → `platform_driver_register` at
  module init
- `MODULE_DEVICE_TABLE` is **not** a runtime caller graph; modpost
  consumes the alias at **build** time

semcode MCP: **not available** (namespace search returned no semcode
tools).

**Step 5.3: TRACE CALLEES**

Record: probe uses `device_get_match_data()` / GPIO chip registration.
Unchanged. New code allocates nothing, takes no locks, does no I/O.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: path is **reachable from userspace/boot** on NXP DT platforms
when the driver is a module: DT node with those compatibles → udev
`modalias` → `modprobe gpio-vf610`. The bug is that this chain is
**broken** without aliases. Unprivileged users do not need a special
exploit; missing GPIO is a boot/bring-up failure.

DT users verified under `arch/`:
- `arch/arm/boot/dts/nxp/vf/vfxxx.dtsi` — `fsl,vf610-gpio`
- `arch/arm/boot/dts/nxp/imx/imx7ulp.dtsi` — `fsl,imx7ulp-gpio`
- `arch/arm64/boot/dts/freescale/imx8ulp.dtsi`, `imx91_93_common.dtsi`,
  `imx94.dtsi`, `imx95.dtsi`, `imx952.dtsi` — `fsl,imx8ulp-gpio`
  (including i.MX93/94/95)

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: same missing-table pattern recently fixed in `gpio-sifive.c`,
and earlier in spacemit/lpc32xx/cadence/ath79/ts4800. Systematic, well-
understood class.

---

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **`v7.3-rc4-27-gf0100363d8c37`**, `make kernelversion` =
  **7.3.0-rc4** (mainline, not an LTS branch)
- `CONFIG_GPIO_VF610` is **tristate**; `module_platform_driver` is
  present — the modular bug **does exist** in this lineage
- The **fix commit `975a1d61260cf` is already an ancestor of HEAD**
  (landed in **v7.3-rc1**; **not** in v7.2)
- Introducing modularization `73dc041f8a602` **is** in this tree (since
  v6.16)
- Current file already has `MODULE_DEVICE_TABLE(of, vf610_gpio_dt_ids)`
  at line 86

Approximate introduction of the **bug:** **v6.16** (April/July 2025).
Driver itself: **v3.x/v4.x era** (2014).

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: **clean apply** on this tree’s driver — one line after the
existing `of_device_id` table. Match-table layout here matches the
commit hunk. No conflicting local changes.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: this exact fix **is already in HEAD**. No alternate/earlier
equivalent found (`git log --oneline --grep=MODULE_DEVICE_TABLE --
drivers/gpio/gpio-vf610.c` is this commit). No follow-up on the file
after it.

For **this checkout as a 7.3 baseline**, 7.3.y would inherit the fix
from rc1; the evaluation still asks whether the change is **stable-
worthy given that this tree’s driver is modular**.

---

## Phase 7: Subsystem and maintainer context

**Step 7.1: SUBSYSTEM AND CRITICALITY**

Record: `drivers/gpio/` — GPIO. **IMPORTANT** (not core mm/sched, but
platform GPIO is boot-critical on NXP i.MX/Vybrid: resets, IRQs,
regulators). Not staging.

**Step 7.2: SUBSYSTEM ACTIVITY**

Record: GPIO is actively maintained (Bartosz); this file still gets API
updates. The autoload hole is from the v6.16 modularization, not ancient
dead code.

---

## Phase 8: Impact and risk assessment

**Step 8.1: WHO IS AFFECTED**

Record: **driver-specific / config-specific**: `CONFIG_GPIO_VF610=m` on
`ARCH_MXC` (Vybrid VF610, i.MX7ULP, i.MX8ULP, and later i.MX9x that
compatible-string to `fsl,imx8ulp-gpio`). Built-in (`=y`) is unaffected.
Kconfig has `default y if SOC_VF610` only; i.MX7/8/9 do **not**
default-y on that symbol, so modular builds are realistic (explicitly
for **Android GKI**).

**Step 8.2: TRIGGER CONDITIONS**

Record:
- Trigger: boot/udev on DT platforms with `GPIO_VF610=m` and no explicit
  `modprobe`
- Commonness: every such boot, not a race
- Unprivileged exploit: **no**; availability/bring-up bug, not a
  sanitizer crash

**Step 8.3: FAILURE MODE SEVERITY**

Record:
- Failure: GPIO controller never probes → missing gpiochip, pin IRQs,
  board GPIOs
- Not oops/UAF/corruption
- Severity: **MEDIUM** functionally (hardware silent-fail), **HIGH** on
  boards that need those GPIOs at boot
- Fits “oh, that’s not good” plus the **device-ID / autoload** exception

**Step 8.4: RISK-BENEFIT RATIO**

Record:
- **Benefit:** restores autoload for an existing, in-tree driver on
  current NXP SoCs and GKI modular images
- **Risk:** **very low** (1 line, metadata only)
- **Ratio:** favorable for stable

---

## Phase 9: Final synthesis

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real bug: OF module aliases never generated after v6.16 made the
  driver `tristate`
- One line, obviously correct, no runtime behavior change for built-in
- Same class as device-ID additions (explicitly allowed) and many
  historical “fix module autoloading” GPIO patches
- Used on VF610, i.MX7ULP, i.MX8ULP, i.MX93/94/95 DT
- Modularization was for Android GKI — the config where autoload matters
- Reviewed by Linus Walleij; applied by Bartosz Golaszewski
- Applies cleanly; no series dependencies
- This tree **has** the modular driver, so the bug class is applicable
  here

**AGAINST:**
- Not a crash, deadlock, corruption, or security hole
- No user/syzbot report; author labels it source-level
- Mechanical sweep by a non-maintainer
- `SOC_VF610` defaults the driver to `y` (Vybrid built-in path is fine)
- Workaround: load the module by name
- **Already in this 7.3-rc4 history** (since 7.3-rc1) — but that is
  expected for a mainline commit under review, not a reason to treat the
  fix as non-bugs

**UNRESOLVED:**
- lore.kernel.org/stable search (HTTP 403)
- Whether Android GKI already lists this module in a manual load list
  (unverified; aliases still help udev/modprobe)

**Step 9.2: STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — canonical macro; reviewed
   and applied by GPIO maintainers
2. Fixes a real bug that affects users? **PASS** — modular OF autoload
   is broken; GKI/i.MX modular users hit it
3. Important issue? **PASS** (as device-ID/hardware-enablement / “oh,
   that’s not good”) — GPIO never appears; not a panic
4. Small and contained? **PASS** — +1 line, one file
5. No new features or APIs? **PASS** — publishes existing match table
6. Can apply to the local tree? **PASS** — code present; hunk matches;
   tree already contains the commit because it is mainline 7.3

**Step 9.3: EXCEPTION CATEGORIES**

Record: **Device ID / module alias publication for an existing driver**
(OF `MODULE_DEVICE_TABLE`). Not a new driver, not a new uAPI.

**Step 9.4: DECISION**

This tree is **mainline 7.3-rc4**, where `gpio-vf610` is modular.
Missing `MODULE_DEVICE_TABLE(of, ...)` is a real, user-visible autoload
bug on DT NXP platforms and GKI-style `=m` builds. The fix is one
obviously correct line with essentially no regression risk, which is the
same bar used for new device IDs in stable.

---

### What the commit solves (for stable users)

When `CONFIG_GPIO_VF610=m`, the kernel never announces OF aliases for
`fsl,vf610-gpio` / `fsl,imx7ulp-gpio` / `fsl,imx8ulp-gpio`. udev
therefore does not load the module, so the GPIO controller never probes.
That became a live bug in **v6.16** when the driver was switched from
`bool` to `tristate` for Android GKI. Adding `MODULE_DEVICE_TABLE(of,
vf610_gpio_dt_ids)` only restores the aliases the match table already
describes.

### Risk vs benefit

Benefit is working GPIO autoload on NXP boards that build this driver as
a module. Risk is negligible: module metadata only.

### Concerns

No field crash report; severity is bring-up rather than oops. That does
not outweigh the device-ID exception and the tiny, maintainer-acked
diff. No extra backports are required on this tree.

---

### Verification

- **[Phase 1]** Parsed tags: Reviewed-by Linus Walleij; Link msgid; SOB
  Hou + Bartosz; no Fixes/Reported-by/Cc:stable
- **[Phase 1]** Body: missing OF `MODULE_DEVICE_TABLE`; source-level, no
  hardware repro claimed
- **[Phase 2]** Diff: `drivers/gpio/gpio-vf610.c` +1 line after
  `vf610_gpio_dt_ids[]`
- **[Phase 2]** `include/linux/module.h:255-257`: macro is used+alias
  for file2alias; no runtime side effects
- **[Phase 3]** `git blame` lines 80–86: table from `7f2691a19627a8`
  (2014); MODULE_DEVICE_TABLE from `975a1d61260cf`
- **[Phase 3]** `git show 73dc041f8a602`: tristate +
  `module_platform_driver` without MODULE_DEVICE_TABLE; Android GKI
  rationale
- **[Phase 3]** `git merge-base --is-ancestor 73dc041f8a602 HEAD` → yes;
  `975a1d61260cf HEAD` → yes
- **[Phase 3]** Version tags: modular **in v6.16+**; fix **in
  v7.3-rc1+**, **not** in v7.2
- **[Phase 3]** `git log --oneline -20 -- drivers/gpio/gpio-vf610.c`: no
  series; sibling sifive commit same author
- **[Phase 3]** `git log 975a1d61260cf..HEAD -- drivers/gpio/gpio-
  vf610.c`: empty (no follow-up)
- **[Phase 4]** `b4 dig -c`: lore/msgid
  `20260704122123.73004-1-pengpeng@iscas.ac.cn`
- **[Phase 4]** `b4 dig -a`: v1 only
- **[Phase 4]** `b4 dig -w`: Walleij, Bartosz, linux-gpio, linux-kernel
- **[Phase 4]** `b4 dig -m`: Walleij Reviewed-by; Bartosz “Applied,
  thanks!”; no NAK; no Cc:stable in thread
- **[Phase 4]** WebFetch lore/msgid: **403** UNVERIFIED via HTTP; mbox
  used instead
- **[Phase 4]** lore.kernel.org/stable curl: **403** UNVERIFIED
- **[Phase 5]** semcode: **unavailable**
- **[Phase 5]** Read `gpio-vf610.c`: `of_match_table =
  vf610_gpio_dt_ids`; `module_platform_driver`
- **[Phase 5]** Grep DT: vfxxx, imx7ulp, imx8ulp, imx91/93, imx94,
  imx95, imx952
- **[Phase 6]** `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `make kernelversion` = 7.3.0-rc4
- **[Phase 6]** Kconfig: `tristate`, `default y if SOC_VF610` only
- **[Phase 8]** Failure mode: module not autoloaded → GPIO missing; not
  a panic
- **UNVERIFIED:** whether GKI already force-loads this `.ko` by name;
  stable@ thread beyond 403

The change is a one-line, maintainer-reviewed autoload fix for an
existing modular GPIO driver. That is appropriate stable material for
this tree’s code.

**YES**

 drivers/gpio/gpio-vf610.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index aa8586d8a787f..adfa2c2d5873d 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -83,6 +83,7 @@ static const struct of_device_id vf610_gpio_dt_ids[] = {
 	{ .compatible = "fsl,imx8ulp-gpio",	.data = &imx8ulp_data, },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, vf610_gpio_dt_ids);
 
 static inline void vf610_gpio_writel(u32 val, void __iomem *reg)
 {
-- 
2.53.0

