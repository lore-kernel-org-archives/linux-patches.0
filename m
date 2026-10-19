Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D4755F624;
	Mon, 19 Oct 2026 13:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418246; cv=none; b=CvXIpmtAvijRRvERsC+ufgiiOhvyOxnLelPLvLmJZgOx7j28EH93GACu58AcDCugQapp6dacvebrbQg+t2V4H5xtViRK/NmHmWBn10nPAQ7Zn39/seW4jdZNj3O6sfPaRsuDXsZU3/WXOHHI2QWIRhWo4Ek7ZKHFGpOkDKOPsJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418246; c=relaxed/simple;
	bh=qtg5o7vgcWmexblo8MQT+J0ce2cEPo8iV+2RB85ju/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hDHNXqs/6FrE6uBm7cleY2q/3M2LEqignc5DG7kcU3vZMNsJez8CgM5QFK3G7r7nBWN+y5sSUKHu8drWbPWk5XzmWMONSsRKsevgHTE0wEpqZG8CK921wu+OUkXSfzX239twSS61XbzFai+z+M+SdltDgZGIla3B9lA6bnkEvNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AItLilEc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AItLilEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B8481F000C4;
	Mon, 19 Oct 2026 13:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418243;
	bh=yI+FRH+GKlmCSgljWKtK+F9J/s6RC2srfk5ZlIgedqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AItLilEcGJ/ASp82dX0muBpn3FYL8lFmcKQS9TWM17pOFqUsHlBuYeqbAeChvNc7O
	 Z5cJpZbzQoqVnXhwfAX5fJ3GDSUvVJtyz5oZ5/8LYNjlVLNzGRvfNgvNZX0/7oQuSa
	 HzCQBHhqs/L06cegHIChUTZVnkHaPZ7jE0VmLcb4TZNTcQFC/WFbni3phI/i7HUXTq
	 8edj4GaE6NmcFCBL6k6NcgSdSQZqcnm2xD4ekZOrA0SxqbX4BkHuRqqzuiXhgHM1Fi
	 fJthc8dgHfgzFtAPOjPmQt49RZZpNdoKtKwL1wOBV5u0W3IWfH1nxFRLDY4f2UX7pn
	 KPvAcynYZdjiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Shang En Sim <sim@shangen.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ALSA: hda/realtek: Enable mute LEDs on HP Spectre x360 16-aa0xxx
Date: Mon, 19 Oct 2026 09:46:45 -0400
Message-ID: <20261019135441.1420968-114-sashal@kernel.org>
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

From: Shang En Sim <sim@shangen.org>

[ Upstream commit bfcdc1c0eaeae5525c726193568e8d638b2afdc0 ]

The HP Spectre x360 2-in-1 Laptop 16-aa0xxx with PCI subsystem ID
0x103c:0x8c17 only gets the CS35L41 amplifier setup from
ALC287_FIXUP_CS35L41_I2C_2, so the speaker-mute and mic-mute keyboard
LEDs do not work.

Use ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX like subsystem ID 0x8c16 so
the mute LEDs work.

Tested on HP Spectre x360 2-in-1 Laptop 16-aa0xxx.

Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20260807055139.58707-1-sim@shangen.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.53** (`pending-6.18`,
`p-6.18-1-g03b85e06ca9bf`). The buggy `0x8c17` mapping is present here,
and the target AA0XXX fixup already exists.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: [ALSA hda/realtek] [Enable] [map HP Spectre x360 16-aa0xxx SSID
0x8c17 to the mute-LED fixup already used by 0x8c16]

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- Fixes: none (expected for this review)
- Reported-by: none
- Tested-by: none as a tag; body says the author tested on the 16-aa0xxx
- Reviewed-by: none
- Acked-by: none
- Link: https://patch.msgid.link/20260807055139.58707-1-sim@shangen.org
- Cc: stable: none (expected)
- Signed-off-by: Shang En Sim <sim@shangen.org> (author)
- Signed-off-by: Takashi Iwai <tiwai@suse.de> (ALSA maintainer; applied
  the patch)
- No syzbot / sanitizer tags

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug: SSID `0x103c:0x8c17` is wired only to
  `ALC287_FIXUP_CS35L41_I2C_2`, so CS35L41 amps are set up but speaker-
  mute and mic-mute keyboard LEDs do not work.
- Symptom: mute/mic-mute LEDs stay dead on this 16-aa0xxx variant.
- Root cause: sibling `0x8c16` already uses
  `ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX`; `0x8c17` was left on the
  amp-only quirk.
- Version info: none in the message.
- Author’s fix: use the same AA0XXX fixup as `0x8c16`. Tested on the
  16-aa0xxx.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not hidden. This is an explicit hardware-quirk correction, not
cleanup disguised as a fix.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `sound/hda/codecs/realtek/alc269.c` (1 hunk)
- Scope: 1 line changed in `alc269_fixup_tbl[]` (SSID string + fixup id)
- Classification: single-file surgical quirk-table update

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before, `SND_PCI_QUIRK(0x103c, 0x8c17, ...)` selected
`ALC287_FIXUP_CS35L41_I2C_2` (`cs35l41_fixup_i2c_two` only). After, the
same SSID selects `ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX`. That fixup
still calls `cs35l41_fixup_i2c_two`, and also applies speaker pin
configs, GPIO amp enable, mute-LED coefbit, and GPIO LED setup. Path:
codec probe via `snd_hda_pick_fixup()`.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: [Hardware workaround / audio codec quirk] The wrong existing
fixup left mute LEDs (and the extra speaker GPIO/pin work from the 2024
Spectre fixup) unused. The new mapping reuses an already-present fixup.

Step 2.4: ASSESS THE FIX QUALITY
Record: Obviously correct: `0x8c16` and `0x8c17` were added together as
“HP Spectre 16”; `0x8c16` already got the full AA0XXX fixup. One-line
table change, no new API. Regression risk is low: the author tested
0x8c17 hardware; the new fixup still runs the old CS35L41 I2C setup.
Residual risk is that 0x8c17 could differ slightly from 0x8c16 in
speaker pin/GPIO behavior; that is unverified beyond the author’s test.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record: In this tree the `0x8c17` line is attributed to `aeeb85f26c3bb`
(“ALSA: hda: Split Realtek HD-audio codec driver”, 2025-07-09), which is
a file move. The content originated in `aa8e3ef4fe533` (“ALSA:
hda/realtek: Add quirks for various HP ENVY models”, 2024-01-26, first
in v6.9). Both `aa8e3ef4fe533` and `557f6e4ab5ba6` are ancestors of this
HEAD.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No Fixes: tag. The incomplete 0x8c17 mapping has been in the
lineage since v6.9; the AA0XXX fixup landed in `557f6e4ab5ba6` (v6.12)
for 0x8c16 only and left 0x8c17 on the amp-only quirk.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Related: `557f6e4ab5ba6` added
`alc245_fixup_hp_spectre_x360_16_aa0xxx` and switched 0x8c16. Recent
`alc269.c` history is other HP mute-LED quirks. This commit is
standalone, not patch X/Y.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Shang En Sim has no other Realtek commits in this history.
Takashi Iwai applied it. This tree already contains many similar HP
mute-LED `SND_PCI_QUIRK` backports.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: Needs `ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX` and the 0x8c17
table row. Both exist here. `git apply --check` of `bfcdc1c0eaeae`
succeeded (hunk at offset -491). Standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c bfcdc1c0eaeae`:
  https://patch.msgid.link/20260807055139.58707-1-sim@shangen.org
- `b4 dig -a`: v1 only (2026-08-06)
- Thread (mbox): Takashi Iwai “Applied to for-next branch now. Thanks.”
  No NAK, no stable request, no design concerns.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: `b4 dig -w`: To Jaroslav Kysela, Takashi Iwai; Cc linux-sound@.
Maintainer applied it.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot link. Evidence is the author’s hardware test
in the commit body. WebFetch of lore/msgid.link returned 403; the thread
was recovered via `b4 dig -m`.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone. Sibling work is `557f6e4ab5ba6` (already in this
tree).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: No lore.kernel.org/stable discussion of this subject was found.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: Table `alc269_fixup_tbl[]` only. No function body edited.
Consumed fixup: `alc245_fixup_hp_spectre_x360_16_aa0xxx`.

Step 5.2: TRACE CALLERS
Record: `alc269_probe()` → `snd_hda_pick_fixup(..., alc269_fixup_tbl,
alc269_fixups)` (around line 8517). That is HD-audio codec probe, not a
hot path or IRQ path.

Step 5.3: TRACE CALLEES
Record: New fixup calls `snd_hda_apply_pincfgs`,
`snd_hda_override_conn_list`, `alc_update_gpio_data`,
`cs35l41_fixup_i2c_two`, `alc245_fixup_hp_mute_led_coefbit`,
`alc245_fixup_hp_gpio_led`. Old quirk only called
`cs35l41_fixup_i2c_two`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: PCI/HDA enumeration at boot on this laptop. Userspace mute keys
then drive the LED hooks. Reachable on that hardware without extra
privileges.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same file already maps 0x8c16 to AA0XXX. Many nearby HP
`SND_PCI_QUIRK` mute-LED entries. This is the same pattern, for the
missed sibling SSID.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `sound/hda/codecs/realtek/alc269.c:6957`:
`SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16",
ALC287_FIXUP_CS35L41_I2C_2)`
Target enum, function, and `alc269_fixups[]` slot all exist. `git merge-
base --is-ancestor bfcdc1c0eaeae HEAD` is false, so the fix is not in
this tree yet. Incomplete 0x8c17 mapping dates to v6.9; 6.18 still has
it.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply (`git apply --check` succeeded). File layout matches
mainline (`sound/hda/codecs/realtek/alc269.c`). No rework needed.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: `557f6e4ab5ba6` is here (0x8c16 + AA0XXX function). 0x8c17 is
still on the amp-only quirk. No substitute fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: [ALSA HD-audio Realtek] [IMPORTANT] Common laptop codec path;
this change is one HP SSID only.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: High. Recent `alc269.c` log is mostly HP/Lenovo/ASUS quirk
additions, including mute LEDs. Mature quirk table, not experimental
code.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / platform-specific: HP Spectre x360 16-aa0xxx
with PCI SSID 0x103c:0x8c17 only.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every probe of that codec (boot). Mute/mic-mute keys then fail
to light LEDs. Unprivileged users hit it on that laptop. Not a race.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: Mute/mic-mute LEDs do not work. The unused AA0XXX path also has
speaker pin/GPIO amp setup that 0x8c16 already gets. Not a panic,
deadlock, or corruption. Severity MEDIUM for that hardware; this is the
documented audio-codec quirk exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record: Benefit high for those users (LEDs, and the same speaker fixup
as 0x8c16). Risk very low: 1-line table change, same fixup already used
by sibling SSID, maintainer-applied, author-tested. Ratio strongly
favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- Real hardware bug on a shipping HP Spectre x360 16-aa0xxx SSID
- Classic `SND_PCI_QUIRK` audio-codec quirk correction (stable
  exception)
- Buggy row and target fixup both exist in 6.18.53
- One-line, applies cleanly, no new API
- Author tested; Takashi Iwai applied
- Sibling 0x8c16 already uses this fixup here
- This tree already takes similar HP mute-LED quirks

AGAINST:
- No crash/security/corruption
- No Fixes:/Cc: stable (not a negative by itself)
- Author is not the subsystem maintainer (mitigated by Iwai applying it)
- Theoretical 0x8c16 vs 0x8c17 hardware difference (mitigated by test on
  0x8c17)

UNRESOLVED:
- Could not HTTP-fetch lore (403); thread recovered via b4 mbox
- No independent second-user report

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? PASS — one-line SSID remap; author
   tested; maintainer applied
2. Fixes a real bug that affects users? PASS — mute LEDs dead on this
   SSID
3. Important issue? PASS under the audio-codec quirk exception (MEDIUM,
   not a panic)
4. Small and contained? PASS — 1 line, one table
5. No new features or APIs? PASS — reuses existing fixup
6. Can apply to the local tree? PASS — `git apply --check` succeeded;
   prerequisites present

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: Hardware quirk / audio codec `SND_PCI_QUIRK` (HP mute LED +
pin/GPIO). This class is treated as stable material.

Step 9.4: MAKE YOUR DECISION
This tree already has the incomplete 0x8c17 mapping and the AA0XXX
fixup. The commit only points this SSID at that fixup. That is a small,
tested hardware quirk and should be backported.

What the commit solves: 0x8c17 currently only programs CS35L41 amps, so
mute LEDs do not work. After the change it matches 0x8c16.

Risk vs benefit: very low risk, clear user-visible fix on that laptop.
No missing prerequisites in 6.18.53.

Verification:
- [Phase 1] Parsed tags: Link to msgid; SOBs Shang En Sim and Takashi
  Iwai; no Fixes/Reported-by/Cc:stable
- [Phase 2] Diff: 1 line in `alc269_fixup_tbl`; 0x8c17
  `ALC287_FIXUP_CS35L41_I2C_2` →
  `ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX`
- [Phase 2] Confirmed AA0XXX still calls `cs35l41_fixup_i2c_two` plus
  mute-LED/GPIO/pin setup (`alc269.c:3550-3590`)
- [Phase 2] Confirmed old quirk is amp-only
  (`[ALC287_FIXUP_CS35L41_I2C_2]` → `cs35l41_fixup_i2c_two`)
- [Phase 3] `git blame -L 6954,6960`: 0x8c17 line from split commit
  `aeeb85f26c3bb`; origin `aa8e3ef4fe533` (v6.9)
- [Phase 3] `git merge-base --is-ancestor aa8e3ef4fe533 HEAD` true;
  `557f6e4ab5ba6` true; `bfcdc1c0eaeae` false
- [Phase 3] `git show 557f6e4ab5ba6`: added AA0XXX for 0x8c16, left
  0x8c17 unchanged
- [Phase 4] `b4 dig -c bfcdc1c0eaeae`:
  patch.msgid.link/20260807055139.58707-1-sim@shangen.org
- [Phase 4] `b4 dig -a`: v1 only
- [Phase 4] `b4 dig -w`: Kysela, Iwai, linux-sound
- [Phase 4] `b4 dig -m`: Iwai applied to for-next; no NAK
- [Phase 4] WebFetch lore/msgid.link: 403; used mbox instead
- [Phase 4] Stable lore search: no discussion of this patch
- [Phase 5] `alc269_probe()` calls `snd_hda_pick_fixup(...,
  alc269_fixup_tbl, ...)`
- [Phase 6] `git describe HEAD`: p-6.18-1-g03b85e06ca9bf; `make
  kernelversion`: 6.18.53; branch pending-6.18
- [Phase 6] Buggy line at `alc269.c:6957`; 0x8c16 already AA0XXX at 6956
- [Phase 6] `git show bfcdc1c0eaeae | git apply --check`: succeeded at
  offset -491
- [Phase 8] Failure mode: mute LEDs inoperative on SSID 0x8c17; severity
  MEDIUM; quirk exception applies
- UNVERIFIED: HTTP lore body (403); whether any 0x8c17 unit differs
  electrically from 0x8c16 beyond the author’s test

**YES**

 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 5098d3f375316..97ab2269dc472 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6969,7 +6969,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0

