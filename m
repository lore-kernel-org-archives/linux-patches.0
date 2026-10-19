Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85053552EA1;
	Mon, 19 Oct 2026 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418216; cv=none; b=bMv2X2N+wEsPN39fCX5U00VHs3KxndwzdG3c3M1/blZ+iMHzdHNt3xzA3M39EQDV87H98rBY8WqDObLorWSPVlMmgbNc9WX5imwibCFEHB7ppDcVohDjN9vABGvlAG7ywA3TsoW/qEQ02eY+ijPQY8Zl4/MihsgQgYaZXTr5KuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418216; c=relaxed/simple;
	bh=l2+4rCrRU9R0NV27tELmt8GLCgbifsruIkHDxZZwIwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qeZAZf1Ds8PAz6BnwZtLg8P3ooexi3tf7BIlErkrMtFgNvNu5pJ7YbDohQpJXAbLGcrfsox3lRcQfN0zQMPkS4C90X12xoq2eAqg9qcVJBLvG3LtkxXh7ZqpCiiBo6NLU0TccqGLSc1V59cMkJSVFqwDvQ3ybrHC5+/FY5SvLz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5lc6piF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5lc6piF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A041F000C5;
	Mon, 19 Oct 2026 13:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418214;
	bh=RBg2HH6BixzdAEJ3GT79k0MdNl551Cl17A6oZmv23J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5lc6piFfh6Jhb6ab3keGaF//wyPCye/BGckoOF8Mmqg9fHlqLYGGdsKLGf1/GADz
	 4MzJFEjqCJWMrqypC1/9bI5vfmU+l97BNAEMQ4fPmm4ZCwYqpYJa/EPw4k7kBBhyAU
	 dIgEHq1fq10XsNlSsleOwKJoubb23LlZjrpmAGL1NvmoxVO0l6cJ9Aj21ErUThib8G
	 3NaClWq4GKu70ERdNMNhpl6rCLkwDODGLdA0WwuCSr15vZLyvkmHArWH+xQWMD95sl
	 a+JK7Q4ZGRUTABRTfxPdY87puQx5oSsx8UQMsLw0ElLW2I4p/OZFqCLxCFoKCALgIf
	 pIrdmSwNlj5XQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomer Maimon <tmaimon77@gmail.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew@codeconstruct.com.au,
	avifishman70@gmail.com,
	tali.perry1@gmail.com,
	openbmc@lists.ozlabs.org,
	linux-gpio@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] pinctrl: npcm8xx: fix debounce register selection
Date: Mon, 19 Oct 2026 09:46:24 -0400
Message-ID: <20261019135441.1420968-93-sashal@kernel.org>
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

From: Tomer Maimon <tmaimon77@gmail.com>

[ Upstream commit 602ee6c9447e4382c7e145b26a1c940813f2a144 ]

Each DBNCS register programs debounce source selection for 16 GPIOs.
The current offset calculation advances the register address every four
GPIOs, so offsets 4-15 and 20-31 end up touching the wrong selector
register.

Advance the DBNCS offset per 16 GPIOs so each line uses the debounce
selector bank that matches the hardware layout.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4** (mainline 7.3.0-rc4). The candidate
is a one-line DBNCS offset fix in the Nuvoton NPCM8XX pinctrl driver;
the buggy formula has been in this file since the driver landed in v6.7.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[pinctrl/npcm8xx] [fix] [debounce DBNCS register offset is
wrong for most GPIOs in a bank]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Tomer Maimon \<tmaimon77@gmail.com\> (author; original
  NPCM8XX pinctrl driver author)
- Signed-off-by: Linus Walleij \<linusw@kernel.org\> (pinctrl
  maintainer; applied the patch)
- No Fixes:, Reported-by, Tested-by, Reviewed-by, Acked-by, Link:, or
  Cc: stable (absence of Fixes/Cc:stable is expected for this review)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Each DBNCS register selects debounce source for 16 GPIOs. The
  driver advanced the register pointer every four GPIOs (`gpio / 4`
  bytes).
- **Symptom:** GPIOs 4–15 and 20–31 program the wrong selector register
  (and, for most of those, an unaligned address).
- **Root cause:** Integer-division “simplification”: `(gpio / 16) * 4`
  is not `gpio / 4`.
- **Version info:** None in the message. Driver introduced in v6.7-rc1.
- **Failure mode:** Hardware debounce source is programmed into the
  wrong MMIO location.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. Subject and body describe a register-
selection bug. The 2022 pre-merge driver used `gpio / 16` with a `* 4`
stride; mainline shipped the broken `gpio / 4` form.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` (+2/−1)
- Function: `debounce_timing_setting()`
- Scope: single-file surgical fix (one expression)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Hardware: `NPCM8XX_GP_N_DBNCS0` at 0x80, `DBNCS1` at 0x84; 2 bits per
  GPIO; 16 GPIOs per 32-bit register. Bit index `(gpio % 16) * 2` was
  already correct.
- Before: `base + 0x80 + (gpio / 4)`
  - gpio 0–3: 0x80 (DBNCS0, aligned)
  - gpio 4–7: 0x81, 8–11: 0x82, 12–15: 0x83 (unaligned, inside DBNCS0)
  - gpio 16–19: 0x84 (DBNCS1, accidentally correct)
  - gpio 20–31: 0x85–0x87 (unaligned; 32-bit RMW can overlap DBNCP0 at
    0x88)
- After: `base + 0x80 + (gpio / 16) * 4` → 0x80 for 0–15, 0x84 for
  16–31.
- Path: pinconf set of `PIN_CONFIG_INPUT_DEBOUNCE` only (not a
  probe/error-path change).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Logic / hardware programming]** Wrong MMIO offset. Matches
the bit-field layout already in the same function. `npcm_gpio_set()`
does `iowrite32(ioread32(reg) | pinmask, reg)` on that pointer.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct against DBNCS0/DBNCS1 at 0x80/0x84 and `(gpio
% 16) * 2`. Minimal. Regression risk is very low: only the register
address changes; GPIOs 0–3 and 16–19 keep the same address.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: Buggy line introduced in **acf4884a57170** (“pinctrl: nuvoton:
add NPCM8XX pinctrl and GPIO driver”, Tomer Maimon, 2023-09-11),
contained in **v6.7-rc1**. Present until 602ee6c9447e4.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Bug is in the original driver merge, not a later
regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-author series merged via `pinctrl-v7.3-1` (drop RTS/CTS,
RMII, RG2 drive strength, pending GPIO events, IRQ setup, pin flags,
this debounce fix). This hunk does not depend on those other patches.
Only other debounce commit on this path is the original driver add.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Tomer Maimon is the Nuvoton/NPCM pinctrl author. Linus Walleij
applied the series. Recent npcm8xx work is a mix of pin-map corrections
and one feature (RG2 drive strength). This commit is the debounce
correctness fix.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Uses `NPCM8XX_GP_N_DBNCS0` and
`debounce_timing_setting()` as they existed at driver introduction. No
new helpers or struct fields.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 602ee6c9447e4` →
  https://patch.msgid.link/20260715122923.1938327-9-tmaimon77@gmail.com
- Subject: `[PATCH v1 8/8] pinctrl: npcm8xx: fix debounce register
  selection` (2026-07-15)
- `b4 dig -a`: only **v1**; applied version matches v1
- lore.kernel.org fetches returned **403**; patch text confirmed via
  LKML/openwall mirrors. No replies were visible on those mirror pages.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): linusw@kernel.org, brgl@kernel.org,
andrew@codeconstruct.com.au, linux-gpio, openbmc, Nuvoton/Google BMC
CCs. No Reviewed-by on the commit; maintainer SOB is Linus Walleij.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot link. Author-found hardware
mapping error.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Patch 8/8 of an npcm8xx pin/group cleanup series. Other patches
change groups, IRQ setup, or add RG2 drive strength. This offset change
does not require them. Pre-merge 2022 v2 driver used `int DBNCS_offset =
gpio / 16` and `DBNCS0 + (DBNCS_offset * 4)` — the correct formula this
commit restores.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search was not usable (403). No evidence
this was discussed on stable@ from the mirrors that did load.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `debounce_timing_setting()` only.

**Step 5.2: TRACE CALLERS**
Record:
- `debounce_timing_setting()` ← `npcm_set_debounce()` ←
  `npcm8xx_config_set_one()` on `PIN_CONFIG_INPUT_DEBOUNCE` ←
  `npcm8xx_config_set()` (`pinconf_ops.pin_config_set`)
- DT generic pinconf maps `input-debounce` to that param (`pinconf-
  generic.c`).
- **GPIO cdev debounce does not hit this path here:**
  `gpio_generic_chip_init()` does not set `gc->set_config`, and this
  driver never assigns `gpiochip_generic_config`. `gpio_do_set_config()`
  returns `-ENOTSUPP`; gpiolib-cdev then uses software debounce.

**Step 5.3: TRACE CALLEES**
Record: `npcm_gpio_set()` (32-bit RMW), `iowrite32` of DBNCPx period
registers, `DIV_ROUND_CLOSEST` for custom periods.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable when a pinctrl state applies `input-debounce` (boot DT
or pin_config_set). No in-tree dts/dtsi uses `input-debounce`
(verified). OpenBMC board DTs are often out of tree. Not a syscall hot
path on this driver as wired today.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: npcm7xx has PIN_CONFIG_INPUT_DEBOUNCE cases but no DBNCS
registers (NPCM8XX-specific adjustable debounce). No sibling copy of
this bug.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` is present.
Pre-image at 602ee6c9447e4^ is `+ (gpio / 4)`. Bug since v6.7. This
checkout already contains the fix (expected for a mainline candidate
tree). `PINCTRL_NPCM8XX` depends on `ARCH_NPCM || COMPILE_TEST`.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on the debounce formula. Surrounding gpio-generic
API churn does not affect this one line. Expected backport difficulty:
**clean apply** on any tree that still has `(gpio / 4)` in
`debounce_timing_setting`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier debounce-offset fix. `git log --grep=debounce --
drivers/pinctrl/nuvoton/` only shows the original add and this commit.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[pinctrl / Nuvoton NPCM8XX GPIO] [PERIPHERAL]** — Arbel BMC
(ARM64 Cortex-A35), used on OpenBMC server BMCs. Not core mm/fs/net.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature driver (v6.7), recent concentrated npcm8xx pin-map/IRQ
fixes in the 7.3 pinctrl pull. Debounce math had been unchanged since
introduction.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Platform-specific:** NPCM8XX BMC boards that set pinctrl
`input-debounce`. Not universal. No in-tree DT consumers found.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Applying hardware debounce via pinconf. Not every boot unless DT
requests it. Unprivileged GPIO debounce ioctl does **not** reach this
function on this driver (no `set_config`). Privilege/DT-dependent.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Primary (author): wrong DBNCS register → debounce source not applied
  to the intended line; possible corruption of neighboring DBNCS/DBNCP
  fields via unaligned 32-bit RMW.
- Unaligned `ioread32`/`iowrite32` on ARM64 Device mappings *can*
  alignment-fault; **no crash was reported**. Treat crash as possible,
  not verified.
- Severity: **MEDIUM** for functional debounce / adjacent-register
  corruption on this SoC; not a demonstrated panic/UAF/security hole.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Makes hardware debounce match the documented 16-GPIO
  DBNCS banks for NPCM8XX users who enable it.
- **Risk:** Very low (one address expression; GPIOs that already hit
  0x80/0x84 unchanged).
- **Ratio:** Favorable. Small correctness fix, not a feature.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real hardware programming bug, present since the driver was added
  (v6.7).
- Restores the mapping the author’s 2022 submission already used (`gpio
  / 16` × 4-byte stride).
- Matches DBNCS0/DBNCS1 at 0x80/0x84 and the existing `(gpio % 16) * 2`
  bit layout.
- 3-line, single-function, no API/feature change.
- Author is the driver writer; pinctrl maintainer applied it.
- Standalone; other 8/8 series patches not required.
- Applies on this tree’s pre-image without surrounding refactor.

AGAINST:
- Peripheral BMC pinctrl, not a core crash/security/corruption class as
  described.
- No Fixes/Cc:stable, no Reported-by/Tested-by (tags not required, but
  no field report).
- No in-tree `input-debounce` DT users; GPIO cdev debounce does not call
  this code.
- Series also contains non-stable material (e.g. RG2 drive strength);
  this patch itself is independent.

UNRESOLVED:
- Full lore thread (reviews/NAKs) unverified due to lore 403.
- Whether any OpenBMC DT actually sets `input-debounce` (not in this
  tree).
- Whether unaligned MMIO actually oopses on NPCM8XX (not reported).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — formula matches register
   layout; maintainer applied. No extra Tested-by.
2. Fixes a real bug that affects users? **PASS** — wrong DBNCS bank for
   24/32 lines per bank when hardware debounce is configured.
3. Important issue (crash, security, corruption, deadlock)? **PASS**
   (borderline) — wrong MMIO and possible adjacent-register RMW; not a
   documented oops. Still a hardware-feature break on a production BMC
   SoC, which stable routinely takes in pinctrl/gpio.
4. Small and contained? **PASS** — +2/−1, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same file/function; pre-image
   is the buggy line.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
driver correctness fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the NPCM8XX driver and the long-standing `gpio / 4` bug.
The patch is a minimal, obviously correct register-index fix with no
dependencies. Benefit is limited to NPCM8XX debounce configuration, but
the risk of taking it is negligible and the bug is real. That meets
stable criteria for this checkout.

------------------------------------------------
What the commit solves, for stable users
------------------------------------------------
Hardware debounce on NPCM8XX is supposed to use DBNCS0 for GPIOs 0–15
and DBNCS1 for 16–31. Integer division turned `(gpio / 16) * 4` into
`gpio / 4`, so most lines wrote the wrong (often unaligned) address.
Boards that set pinctrl `input-debounce` would not get the intended
debounce source and could disturb neighboring debounce-period registers.
The fix is one address expression.

Risk vs benefit: very low risk, modest but real benefit for NPCM8XX BMC
GPIO debounce. No series dependencies.

Verification:
- [Phase 1] Parsed commit 602ee6c9447e4: SOB Tomer Maimon + Linus
  Walleij; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: one expression in `debounce_timing_setting()`;
  DBNCS0=0x80, DBNCS1=0x84 confirmed in this file
- [Phase 2] `npcm_gpio_set()` is 32-bit RMW at the computed pointer
  (lines 124–129)
- [Phase 3] `git blame` on parent: acf4884a57170 (v6.7-rc1) introduced
  `(gpio / 4)`
- [Phase 3] `git merge-base --is-ancestor acf4884a57170 HEAD` → yes; fix
  is ancestor of HEAD
- [Phase 3] `git log --grep=debounce -- drivers/pinctrl/nuvoton/` → only
  driver add + this fix
- [Phase 4] `b4 dig -c 602ee6c9447e4` → msgid 20260715122923.1938327-9;
  v1 8/8; recipients linusw, brgl, openbmc
- [Phase 4] Pre-merge 2022 v2 used `gpio / 16` and `* 4`
  (lists.ozlabs.org OpenBMC archive)
- [Phase 4] lore.kernel.org 403 — full review thread UNVERIFIED;
  LKML/openwall showed the patch text only
- [Phase 5] Callers: `npcm_set_debounce` ← `npcm8xx_config_set_one`
  PIN_CONFIG_INPUT_DEBOUNCE
- [Phase 5] This driver has no `gc->set_config`; GPIO cdev debounce does
  not reach this function
- [Phase 5] `rg input-debounce` on dts/dtsi: no matches
- [Phase 6] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 6] Parent of fix still has `(gpio / 4)`; apply is clean
- [Phase 8] Failure mode: wrong debounce MMIO; crash via unaligned
  access UNVERIFIED
- UNVERIFIED: OpenBMC out-of-tree DT debounce use; stable@ discussion;
  review NAKs

**YES**

 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 22cc87d43ea69..28464463ff833 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2135,7 +2135,8 @@ static const struct pinmux_ops npcm8xx_pinmux_ops = {
 static int debounce_timing_setting(struct npcm8xx_gpio *bank, u32 gpio,
 				   u32 nanosecs)
 {
-	void __iomem *DBNCS_offset = bank->base + NPCM8XX_GP_N_DBNCS0 + (gpio / 4);
+	void __iomem *DBNCS_offset = bank->base + NPCM8XX_GP_N_DBNCS0 +
+				     (gpio / 16) * 4;
 	int gpio_debounce = (gpio % 16) * 2, debounce_select, i;
 	u32 dbncp_val, dbncp_val_mod;
 
-- 
2.53.0

