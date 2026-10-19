Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA7053AEBD;
	Mon, 19 Oct 2026 14:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418721; cv=none; b=FuSF9geWptv4QAqZPAePunZiWg1BaAL72M0nAV4V+/zqJbLucsF/qi7HGCY9+Kke/nN8Gq4JO7VDk9c40RhdG07BsK54KcCAgaSGJUyWLq4LGuyxSLgHhyv0u3SU7mnvy7DmcnpNPmhncVfqHtbVoOBFSl8MzO6i2wncSPB4bC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418721; c=relaxed/simple;
	bh=1GHERZvj7WRGStB8C1B5WYnW05EF+5bN4u4hksV/hak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CajaZ7si6v16nok3uFTjpuljGpTEGg54n7RxMkwWpifqnG8qZcTr44J1ssITUmjL78qTUMwhpzCsv3wqvWXB5/0HfgCR8uwQ9QS9GozCYOW8hUPOjHQB2p9yYfNIOCK/Xszmp9yTkvDtEDM8IinplRrZXUslrDu5WZjTdq6XczI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ac3mMtoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ac3mMtoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D948D1F000C9;
	Mon, 19 Oct 2026 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418718;
	bh=3HkTGF9xh3harCN/8UsuYuja0pY//1FUxUgh35dHIcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ac3mMtoGk9aVZCAD6QvBDoj2v5FAIfGicvGOQCKgvgHfX5Gt7B5b5mEPyg3TS+FH8
	 /LFmqbkav4mddqxqFcCeIVHT+hJct4ebPFaRHyNRgUqN5/gm3025TxgikGOl3n6bob
	 DW/UBIlSFXNNkADMcGt0u+u1QyOZfjnqX2qU983/d8mog1RqmKEOsQs+1j62biVME5
	 fOzTokXlW98pt3iHplc94RbFNAdNuzI5pCvD567a9LcyCaQg44fYkc68hzklp/Ezqv
	 KfqrFmIvr3XPGFaZ7RMWU21Zo8FQMSktmT5UJupDMr3usXop8pXfmR+BccAUHCzZ4J
	 HJQ5g2HvviIHA==
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
Subject: [PATCH AUTOSEL 6.18-6.12] pinctrl: npcm8xx: enable RMII outputs from RMII groups
Date: Mon, 19 Oct 2026 09:52:17 -0400
Message-ID: <20261019135441.1420968-446-sashal@kernel.org>
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

[ Upstream commit c6ccdc305589dd7c7976116e0870a23f291c5fa9 ]

NPCM8xx uses GCR_INTCR4 bits to release the R1, R2 and RMII3
transmit outputs from Hi-Z.

Those bits need to follow the mandatory r1, r2 and rmii3 pin
groups. The R1_OEn, R2_OEn and R3_OEn side groups are optional and
should not be required just to enable RMII transmit outputs.

Program the INTCR4 bits when the corresponding RMII groups are
selected and clear them again when those pins switch back to GPIO or
another shared function.

Signed-off-by: Tomer Maimon <tmaimon77@gmail.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a real NPCM8xx hardware-programming bug (RMII TX left in Hi-Z),
and the local 7.3 tree already has the driver and the affected mux path.

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[pinctrl/npcm8xx] [enable] [program INTCR4 so RMII TX leaves
Hi-Z when r1/r2/rmii3 groups are selected]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Signed-off-by: Tomer Maimon `<tmaimon77@gmail.com>` (author; Nuvoton)
- Signed-off-by: Linus Walleij `<linusw@kernel.org>` (pinctrl
  maintainer)
- No Fixes:, Reported-by:, Tested-by:, Reviewed-by:, Acked-by:, Link:,
  or Cc: stable
- Absence of Fixes/Cc-stable is expected for this review and is not a
  negative signal

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: NPCM8xx GCR_INTCR4 bits 12–14 release R1/R2/RMII3 transmit pads
  from Hi-Z. The driver muxed the mandatory `r1`/`r2`/`rmii3` groups but
  never programmed those bits.
- Symptom: RMII TX stays tri-stated, so those Ethernet ports cannot
  transmit.
- Root cause: INTCR4 was (incorrectly) treated as belonging to optional
  `R1_OEn`/`R2_OEn`/`R3_OEn` side groups; those groups are separate pins
  and do not program INTCR4.
- Version info: none in the message. Driver itself arrived in v6.7-rc1.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. The cover letter of the series calls
the set a “cleanup,” but this patch is explicit hardware-correctness: TX
is stuck in Hi-Z until INTCR4 is programmed. That is a functional bug,
not a style change.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c` (+61 / −0)
- New helpers: `npcm8xx_rmii_output_enable_mask()`,
  `npcm8xx_set_rmii_output_enable()`
- Modified: `npcm8xx_setfunc()` (one call at the end)
- New defines: `NPCM8XX_GCR_INTCR4`,
  `NPCM8XX_INTCR4_R1_RMII_EN/R2_RMII_EN/RMII3_EN`
- Scope: single-file surgical change

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: `npcm8xx_setfunc()` only updated MFSEL/I2CSEGSEL bits from
  `pincfg[]`. INTCR4 was never written.
- After: after that mux, INTCR4 bits 12–14 are set iff the selected mode
  is `fn_r1`/`fn_r2`/`fn_rmii3` for pins in those groups; they are
  cleared when those pins go back to GPIO or another function.
- Paths: pinmux set (`npcm8xx_pinmux_set_mux`) and GPIO request
  (`npcm8xx_gpio_request_enable`). Normal mux/GPIO path, not an error
  path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: `[Hardware programming / logic correctness]` Incomplete mux:
existing RMII groups did not drive the SoC output-enable bits, so TX
pads stayed Hi-Z. Fix programs those bits from the same `setfunc()` path
that already muxes the groups. Pin lists match `r1_pins[]`, `r2_pins[]`,
and `rmii3_pins[]` exactly.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Quality: obviously correct against the driver’s own group tables; no
  API/data-structure change.
- Regression risk: low–medium. Linux now writes INTCR4 bits that used to
  be left at firmware values. Clearing the whole R1/R2/RMII3 enable when
  a single pin in that group is requested as GPIO is the stated intent,
  but it can drop TX for the rest of that RMII if one pad is taken as
  GPIO. No deadlock/locking change.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record: `npcm8xx_setfunc()` comes from `acf4884a57170` (“pinctrl:
nuvoton: add NPCM8XX pinctrl and GPIO driver”, 2023-08-28; first in
**v6.7-rc1**). INTCR4 handling is new in this commit. The bug is
“missing programming since the driver was added,” not a recent
regression.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. The incomplete mux has been there
since the original driver.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: Same-day 8-patch series from Tomer, merged via `pinctrl-v7.3-1`:
1. drop RTS/CTS from bmcuart1
2. **this commit**
3. RG2 drive strength
4. clear pending GPIO events
5. rename GPIO7 IOX2
6. move GPIO IRQ setup
7. JM1/SMB7 flags
8. debounce register selection
This patch does not depend on the others. No later follow-up on INTCR4.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Tomer Maimon is the original npcm8xx/npcm7xx pinctrl author
(Nuvoton). That is a strong subsystem-author signal, not a drive-by
change.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Standalone. Uses existing `npcm8xx_setfunc()`,
`fn_r1`/`fn_r2`/`fn_rmii3`, and `regmap_update_bits()` on the GCR
syscon. No new helpers from other patches.

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c c6ccdc305589d` →
  https://patch.msgid.link/20260715122923.1938327-3-tmaimon77@gmail.com
- Series: `[PATCH v1 0/8] pinctrl: npcm8xx: fix pinmuxing and
  configuration handling` (2026-07-15)
- Only v1; no v2/v3
- Cover letter: issues found by comparing upstream with the newer
  Nuvoton tree
- Linus Walleij: “No comments so patches applied.”
- No Cc: stable, no NAKs

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc included Linus Walleij, Bartosz Golaszewski,
Andrew Jeffery, linux-gpio, openbmc, and Google/Nuvoton BMC people. Only
the maintainer reply is in the thread; no Reviewed-by/Tested-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No Reported-by, bugzilla, or syzbot. Evidence is the author’s
hardware description (Hi-Z TX), not a user crash report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Patch 2/8. Independent of 1/8 (UART pins) and 3/8 (RG2 drive
strength). Safe to take alone.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable returned 403. UNVERIFIED whether stable@
discussed this commit. The mbox has no stable nomination.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: KEY FUNCTIONS**
Record: `npcm8xx_rmii_output_enable_mask`,
`npcm8xx_set_rmii_output_enable`, `npcm8xx_setfunc`

**Step 5.2: TRACE CALLERS**
Record:
- `npcm8xx_setfunc` ← `npcm8xx_pinmux_set_mux` (DT/pinctrl mux) and
  `npcm8xx_gpio_request_enable` (GPIO request)
- Reachable when a consumer selects `r1`/`r2`/`rmii3` or when those pads
  are claimed as GPIO
- Not IRQ/hot-path

**Step 5.3: TRACE CALLEES**
Record: `regmap_update_bits()` on GCR INTCR4. Side effect is only those
three bits.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Device-tree pinctrl for NPCM8xx RMII groups → pinmux → `setfunc`
→ INTCR4. Userspace cannot trigger it without those pins being muxed.
In-tree `nuvoton-npcm845-evb.dts` only enables UART/watchdog, but
`nuvoton-common-npcm8xx.dtsi` already defines `r1`/`r2`/`rmii3` mux
nodes for board DTs (typical OpenBMC).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: npcm7xx pinctrl has no INTCR4 RMII enable. This is npcm8xx-
specific. No sibling copy-paste bug.

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes. Local tree is **v7.3-rc4** (`7.3.0-rc4`). `PINCTRL_NPCM8XX`
and `npcm8xx_setfunc()` are present. `git merge-base --is-ancestor
c6ccdc305589d HEAD` is true (the fix is already in this checkout). The
pre-fix mux without INTCR4 existed from v6.7 through this series.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply on this file’s `setfunc()`/GCR-define region. Those
sites were stable from the original driver until this commit. Later 7.3
include churn (`mod_devicetable.h`) is unrelated.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the only INTCR4/RMII-output change. No alternate fix.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: SUBSYSTEM AND CRITICALITY**
Record: `[drivers/pinctrl/nuvoton] [PERIPHERAL]` — Nuvoton NPCM8xx BMC
pinmux. Important for that BMC’s RMII, not a core mm/fs/net path.

**Step 7.2: SUBSYSTEM ACTIVITY**
Record: Mature driver (v6.7) with a 2026 vendor-sync series. Not a
brand-new subsystem.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: WHO IS AFFECTED**
Record: NPCM8xx (Arbel) BMC boards that mux `r1`/`r2`/`rmii3`. Config:
`PINCTRL_NPCM8XX` / `ARCH_NPCM`. Not universal.

**Step 8.2: TRIGGER CONDITIONS**
Record: Selecting those RMII pin groups (boot pinctrl). Common on boards
that use RMII Ethernet; unused if those groups are never muxed. Not a
userspace-triggered security path.

**Step 8.3: FAILURE MODE SEVERITY**
Record: `[RMII TX held in Hi-Z → no Ethernet transmit] [MEDIUM, HIGH for
BMC management if that port is the OOB NIC]`. Not a panic, UAF, or
filesystem corruption.

**Step 8.4: RISK-BENEFIT RATIO**
Record:
- Benefit: BMC RMII actually transmits when the existing groups are
  selected; firmware no longer has to paper over Linux.
- Risk: ~61 lines, three GCR bits, no locking. Behavior change vs “leave
  INTCR4 to firmware.”
- Ratio: favorable for trees that already ship this driver.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Concrete hardware bug: TX pads stay Hi-Z without INTCR4
- Existing pin groups; this completes mux, it does not add a new
  function/API
- 61 lines, one file, pin lists match group arrays
- No series dependencies
- Driver author + pinctrl maintainer
- Driver and bug exist in this tree (since v6.7)
- Hardware-workaround exception (broken/incomplete SoC programming)

AGAINST:
- Not crash/security/corruption/deadlock
- Cover letter is a Nuvoton-tree sync, no user report or Tested-by
- In-tree EVB DTS does not enable Ethernet
- Writes INTCR4 that firmware may already own
- Part of an 8-patch “cleanup” series (this patch is still self-
  contained)

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403)
- Could not confirm how many shipping boards rely on firmware vs Linux
  for INTCR4

**Step 9.2: STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches group tables;
   maintainer applied v1. Tested-by is missing, but the change is
   inspectable.
2. Fixes a real bug that affects users? **PASS** — RMII TX does not
   leave Hi-Z.
3. Important issue? **PASS** (MEDIUM, hardware-workaround exception) —
   dead BMC Ethernet TX, not a kernel oops.
4. Small and contained? **PASS** — 61 lines, one driver.
5. No new features or APIs? **PASS** — no new userspace API; programs a
   register the existing groups already required.
6. Can apply to the local tree? **PASS** — `pinctrl-npcm8xx.c` and
   `npcm8xx_setfunc()` are here; the patch is already an ancestor of
   HEAD.

**Step 9.3: EXCEPTION CATEGORIES**
Record: Hardware workaround / incomplete mux for existing NPCM8xx RMII
groups. Not a new driver.

**Step 9.4: DECISION**
This tree is 7.3 and already contains NPCM8xx pinctrl. The bug is real:
selecting the documented RMII groups never released TX from Hi-Z. The
fix is small, local, and does not need the rest of the series. That is
the same class of change as a hardware quirk: the existing function does
not work until the SoC bit is programmed. Benefit outweighs the INTCR4
behavior change.

Verification:
- [Phase 1] Parsed tags: only author + Linus Walleij SOBs; no
  Fixes/Reported-by/stable
- [Phase 2] Diff: +61 lines in pinctrl-npcm8xx.c; INTCR4 helpers + call
  from setfunc
- [Phase 2] Pin lists verified equal to r1_pins/r2_pins/rmii3_pins
- [Phase 3] git describe HEAD: v7.3-rc4-27-gf0100363d8c37; make
  kernelversion 7.3.0-rc4
- [Phase 3] git merge-base --is-ancestor c6ccdc305589d HEAD: yes
- [Phase 3] Driver added acf4884a57170, first contained in v6.7-rc1
- [Phase 3] git blame setfunc: original driver except the new INTCR4
  call
- [Phase 3] No Fixes: tag; no INTCR4 history before this commit
- [Phase 4] b4 dig -c: lore/msgid 20260715122923.1938327-3; series v1
  2/8
- [Phase 4] b4 dig -a: only v1
- [Phase 4] b4 dig -w: linusw, brgl, andrew, openbmc, linux-gpio, Google
  BMC CCs
- [Phase 4] mbox: Linus “No comments so patches applied”; no NAK; no Cc:
  stable
- [Phase 4] lore.kernel.org HTTP 403 for WebFetch; stable-list search
  UNVERIFIED
- [Phase 5] Callers: pinmux_set_mux and gpio_request_enable only
- [Phase 6] Buggy mux without INTCR4 present from v6.7 until this commit
- [Phase 6] In-tree EVB DTS has no ethernet node; common dtsi still
  defines r1/r2/rmii3 muxes
- [Phase 8] Failure mode: RMII TX Hi-Z, severity MEDIUM (BMC NIC)

**YES**

 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 61 +++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 0aae1a2534594..c94441b2acdae 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -26,6 +26,7 @@
 #define NPCM8XX_GCR_SRCNT	0x068
 #define NPCM8XX_GCR_FLOCKR1	0x074
 #define NPCM8XX_GCR_DSCNT	0x078
+#define NPCM8XX_GCR_INTCR4	0x0c0
 #define NPCM8XX_GCR_I2CSEGSEL	0x0e0
 #define NPCM8XX_GCR_MFSEL1	0x260
 #define NPCM8XX_GCR_MFSEL2	0x264
@@ -78,6 +79,9 @@
 #define NPCM8XX_GPIO_PER_BANK	32
 #define NPCM8XX_GPIO_BANK_NUM	8
 #define NPCM8XX_GCR_NONE	0
+#define NPCM8XX_INTCR4_R1_RMII_EN	BIT(12)
+#define NPCM8XX_INTCR4_R2_RMII_EN	BIT(13)
+#define NPCM8XX_INTCR4_RMII3_EN	BIT(14)
 
 #define NPCM8XX_DEBOUNCE_MAX		4
 #define NPCM8XX_DEBOUNCE_NSEC		40
@@ -1796,6 +1800,61 @@ static const struct pinctrl_pin_desc npcm8xx_pins[] = {
 	PINCTRL_PIN(251, "JM2/CP1_GPIO"),
 	};
 
+static u32 npcm8xx_rmii_output_enable_mask(unsigned int pin)
+{
+	switch (pin) {
+	case 178:
+	case 179:
+	case 180:
+	case 181:
+	case 182:
+	case 193:
+	case 201:
+		return NPCM8XX_INTCR4_R1_RMII_EN;
+	case 84:
+	case 85:
+	case 86:
+	case 87:
+	case 88:
+	case 89:
+	case 200:
+		return NPCM8XX_INTCR4_R2_RMII_EN;
+	case 110:
+	case 111:
+	case 209:
+	case 210:
+	case 211:
+	case 214:
+	case 215:
+		return NPCM8XX_INTCR4_RMII3_EN;
+	default:
+		return 0;
+	}
+}
+
+static void npcm8xx_set_rmii_output_enable(struct regmap *gcr_regmap,
+					   const unsigned int *pin,
+					   int pin_number, int mode)
+{
+	u32 mask = 0;
+	u32 val = 0;
+	u32 bit;
+	int i;
+
+	for (i = 0; i < pin_number; i++) {
+		bit = npcm8xx_rmii_output_enable_mask(pin[i]);
+		mask |= bit;
+
+		if ((mode == fn_r1 && bit == NPCM8XX_INTCR4_R1_RMII_EN) ||
+		    (mode == fn_r2 && bit == NPCM8XX_INTCR4_R2_RMII_EN) ||
+		    (mode == fn_rmii3 && bit == NPCM8XX_INTCR4_RMII3_EN))
+			val |= bit;
+	}
+
+	if (mask)
+		regmap_update_bits(gcr_regmap, NPCM8XX_GCR_INTCR4, mask, val);
+}
+
 /* Enable mode in pin group */
 static void npcm8xx_setfunc(struct regmap *gcr_regmap, const unsigned int *pin,
 			    int pin_number, int mode)
@@ -1834,6 +1893,8 @@ static void npcm8xx_setfunc(struct regmap *gcr_regmap, const unsigned int *pin,
 						   BIT(cfg->bit4) : 0);
 		}
 	}
+
+	npcm8xx_set_rmii_output_enable(gcr_regmap, pin, pin_number, mode);
 }
 
 static int npcm8xx_get_slew_rate(struct npcm8xx_gpio *bank,
-- 
2.53.0

