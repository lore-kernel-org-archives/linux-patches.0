Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC3633D5671;
	Mon, 30 Mar 2026 12:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774874353; cv=none; b=Vwld/OMgs/hFC5nfqwS4xrLkUaNcnmawHJNI19q1IG8vnQtWFq3H0SWeRDJPIEprIQw34lX8yLNMEUTAck3XKRl+iJAke5+DLcunRm/vjDZd3tesDGiO+Lan2f0/7DqamqxdU01QVQJyED/5xxGHzg6OTZhkM81TnVL+xP1LPKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774874353; c=relaxed/simple;
	bh=UVnjFdx8SHTfxHnR5sW2FoviYU2dJnrKgQOtUHu5A8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A1I5/vfs2jTxhJyOkJ62Ng2VJM7vCu1pa9q51ce3UjKxlKCstH+Fnn5EhIx8J1k7EgxUrpUEuWPco+Tp9ld8nqmIQaSFP6/qKv4cRKEMfb53qX+NN3HB29/IrPR2CVKyUqvkCTrhAZVAw43p7w3Q5i37fRTOftAbj/Xm1R3bkcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGNTEfXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGNTEfXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C1A4C2BCB1;
	Mon, 30 Mar 2026 12:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774874353;
	bh=UVnjFdx8SHTfxHnR5sW2FoviYU2dJnrKgQOtUHu5A8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGNTEfXVjFlMT1L0RyQEnkHv78Mi/hDJY5zy64aJWp9UPAQc9aDcAJgErtDl1oCd3
	 ysU+Z4+rkTFN2kCjT4o1rsphbSZ2DrT0XcIoy6fLV4igiiU3gUhaAL1Hz02jyzqoHg
	 Z+iFJxzkg/DDDirnSwp1p37r97Zpn2Bw3qmNfLMORjGX0ir/g3vuQadqjgH2wES52E
	 J2WA4tORLigjenTNVooKMdydqG12wh+GsO/1AJdi6DNr0lTxZanYm0syuA0R9nYSFX
	 XtoLZwIDZcfgSfxD2eIB5vT9UVIj9avrCgOINVBYyCP/dL0CgG/83ARvH3941Xe+5g
	 e9lKCdEkk1XWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kailang Yang <kailang@realtek.com>,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] ALSA: hda/realtek - Fixed Speaker Mute LED for HP EliteBoard G1a platform
Date: Mon, 30 Mar 2026 08:38:34 -0400
Message-ID: <20260330123842.756154-21-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330123842.756154-1-sashal@kernel.org>
References: <20260330123842.756154-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit d3be95efc6a1e03230ef646b498050152efe2888 ]

On the HP EliteBoard G1a platform (models without a headphone jack).
the speaker mute LED failed to function. The Sysfs ctl-led info showed
empty values because the standard LED registration couldn't correctly
bind to the master switch.
Adding this patch will fix and enable the speaker mute LED feature.

Tested-by: Chris Chiu <chris.chiu@canonical.com>
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/279e929e884849df84687dbd67f20037@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
Record: [ALSA: hda/realtek] [Fixed] [Speaker mute LED not working on HP
EliteBoard G1a, models without headphone jack]

### Step 1.2: Tags
- **Tested-by**: Chris Chiu <chris.chiu@canonical.com> — Canonical
  developer verified the fix on real hardware
- **Signed-off-by**: Kailang Yang <kailang@realtek.com> — author is from
  Realtek, the codec vendor
- **Link**:
  https://lore.kernel.org/279e929e884849df84687dbd67f20037@realtek.com
- **Signed-off-by**: Takashi Iwai <tiwai@suse.de> — ALSA subsystem
  maintainer accepted it
- No Fixes:, Reported-by:, Cc: stable tags (expected for this review
  pipeline)

Record: Tested-by from Canonical, author is Realtek vendor engineer,
accepted by ALSA maintainer. No Fixes: tag.

### Step 1.3: Commit Body
Record: Bug: On HP EliteBoard G1a (models without headphone jack), the
speaker mute LED fails to function. Sysfs `ctl-led` info shows empty
values because the standard LED registration couldn't bind to the master
switch. Symptom: Non-functional mute LED. Root cause: The LED classdev
registration mechanism doesn't work properly when there is no HP pin on
the platform.

### Step 1.4: Hidden Bug Fix
Record: Not hidden — explicitly labeled as a "Fixed" in the subject.
This is a straightforward hardware quirk fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 — `sound/hda/codecs/realtek/alc269.c`
- **Lines**: ~20 added, ~1 removed (net +19)
- **Functions**: New `alc245_hp_spk_mute_led_update()`; modified
  `alc245_tas2781_i2c_hp_fixup_muteled()`
- **Scope**: Single-file, surgical fix

Record: 1 file, ~20 lines added, 1 function modified, 1 small helper
added. Single-file surgical fix.

### Step 2.2: Code Flow Change

**New function `alc245_hp_spk_mute_led_update()`**: A vmaster hook
callback that writes COEF register 0x0b with mask 0x0c, setting 0x08
when `enabled=1` and 0x04 when `enabled=0`.

**Modified `alc245_tas2781_i2c_hp_fixup_muteled()`**:
- **Before**: Always called `alc245_fixup_hp_mute_led_coefbit()` after
  TAS2781 fixup, which registers a LED classdev via
  `snd_hda_gen_add_mute_led_cdev()`.
- **After**: Reads `alc_get_hp_pin(spec)` at function entry. If no HP
  pin: sets `vmaster_mute.hook` to the new direct-write function, sets
  `vmaster_mute_led = 1`, syncs LED state during `HDA_FIXUP_ACT_INIT`.
  Only calls `alc245_fixup_hp_mute_led_coefbit()` if `hp_pin` is non-
  zero.

Record: Before: always uses LED classdev path. After: uses direct
vmaster hook when no HP pin, LED classdev when HP pin present.

### Step 2.3: Bug Mechanism
Record: [Hardware workaround]. The standard LED classdev registration
via `snd_hda_gen_add_mute_led_cdev()` cannot bind properly to the master
switch on platforms without a headphone pin. The fix bypasses the
classdev and uses the `vmaster_mute.hook` mechanism for direct register
control.

### Step 2.4: Fix Quality — Polarity and Probe Ordering Analysis

**Polarity concern**: The existing `alc245_fixup_hp_mute_led_coefbit`
path uses the LED classdev, which turns LED ON (writes 0x08) when audio
is MUTED. The new vmaster hook path writes 0x08 when `enabled=1` (audio
NOT muted). This is an apparent polarity inversion. However, the
`vmaster_mute.hook` convention (seen in analog.c, conexant.c,
senarytech.c) passes `enabled=1` for unmuted, `enabled=0` for muted — so
the new function maps unmuted → 0x08 (LED on), muted → 0x04 (LED off).
This is opposite to the mute-LED convention but may be intentionally
correct for this specific hardware platform. The Tested-by from Chris
Chiu confirms correct behavior on the target hardware.

**Probe ordering concern**: `alc_get_hp_pin(spec)` reads
`spec->gen.autocfg.hp_pins[0]`, which is populated by
`alc269_parse_auto_config()`. During `HDA_FIXUP_ACT_PRE_PROBE` (line
8595), this function runs BEFORE `alc269_parse_auto_config()` (line
8603), meaning `hp_pins[0]` is always 0 at PRE_PROBE time. This means
`!hp_pin` is ALWAYS true during PRE_PROBE, so the vmaster hook path
activates for ALL platforms using this fixup, not just no-HP models.
However, during INIT (which runs after autocfg parsing), `hp_pin`
correctly reflects the actual hardware. The `if (!hp_pin)` check in the
INIT case correctly gates the LED sync.

Record: Two technical concerns: (1) apparent LED polarity inversion vs
standard convention, (2) probe ordering means hp_pin check is always
true during PRE_PROBE. Both are mitigated by Tested-by on real hardware,
vendor authorship, and maintainer acceptance.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
`alc245_tas2781_i2c_hp_fixup_muteled` was introduced by commit
`9afbbf4903228c` (Kailang Yang, 2025-11-20, "ALSA: hda/realtek - Enable
Mute LED and Tas2781 for HP platform"). The commit first appeared in
v6.19-rc1. The ZBook 8 G2a entries (0x8f40, 0x8f41, 0x8f42, 0x8f62) were
also added by the same commit.

Record: Function introduced in 9afbbf4903228c, v6.19-rc1 (2025-11-20),
by same author.

### Step 3.2: Fixes Tag
No Fixes: tag present. If one existed, it would logically point to
`9afbbf4903228c`.

Record: N/A — no Fixes tag.

### Step 3.3: File History
Recent `alc269.c` history shows very active development with many quirk
additions and LED fixes. No intermediate fixes for this specific
function were found.

Record: Standalone fix, no visible prerequisites beyond 9afbbf4903228c.

### Step 3.4: Author
Kailang Yang (Realtek) is the codec vendor engineer and a frequent
contributor to this driver. He authored the original function
(9afbbf4903228c), the ZBook LED commit (500372aeb556a), and several
other Realtek fixes. Takashi Iwai (ALSA maintainer) accepted the patch.

Record: Author is the Realtek codec vendor engineer — maximum authority
for codec-specific behavior.

### Step 3.5: Dependencies
- Depends on `alc245_tas2781_i2c_hp_fixup_muteled()` from 9afbbf4903228c
- Depends on `ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED` and associated
  SND_PCI_QUIRK entries
- All present in v6.19, absent from v6.18 and older

Record: Dependencies all exist in 6.19.y. Cannot apply to older stable
trees.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Lore
Lore link in the commit points to internal Realtek email;
lore.kernel.org was blocked by Anubis bot protection. Could not access
patch discussion.

Record: UNVERIFIED — could not access lore discussion.

### Step 4.2: Bug Report
**Ubuntu Launchpad Bug #2136846** ("Fix speaker mute and mic mute leds
on a HP EliteBoard G1a") was found and fetched. Key findings:
- Filed by Chris Chiu (the Tested-by person) on 2025-12-19
- Platform: HP NexusX (SSID 0x103c:0x8e8a) using Realtek ALC3315+TAS2783
- The initial upstream fix (fd324768eb2c "ALSA: hda/tas2781: Add new
  quirk for HP new project") was insufficient — **Comment #3** from
  Chris Chiu: "Verified... the mic-mute led works but the mute led does
  not."
- The candidate commit is the follow-up to address the remaining speaker
  mute LED issue
- Ubuntu tracked this as an OEM-priority bug and it was marked "Fix
  Released" for linux-oem-6.17 and later confirmed "6.19 has it"

Record: Real-world bug confirmed by Ubuntu Launchpad #2136846. Mic-mute
LED worked after first fix, speaker mute LED still broken — this commit
is the specific follow-up fix.

### Step 4.3-4.4: Related Patches and Stable History
No direct stable-mailing-list discussion found. The Launchpad bug shows
Ubuntu already backported the earlier fix to linux-oem-6.17.

Record: Ubuntu already backported related fixes to their OEM kernel.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
- `alc245_hp_spk_mute_led_update()` (new) — vmaster hook for direct LED
  control
- `alc245_tas2781_i2c_hp_fixup_muteled()` (modified) — fixup function

### Step 5.2: Callers
`alc245_tas2781_i2c_hp_fixup_muteled` is called via the fixup table
entry `ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED`, triggered by SND_PCI_QUIRK
entries for:
- HP NexusX (0x103c, 0x8e8a)
- HP ZBook 8 G2a 14/16/14W/16W (0x103c, 0x8f40/8f41/8f42/8f62)

The new hook function is called by the generic vmaster framework during
Master Playback Switch changes.

Record: Called from quirk table for 5 specific HP platform SSIDs. Well-
defined scope.

### Step 5.3: Callees
- `alc_update_coef_idx()` — standard codec coefficient register update,
  used 64+ times in this file
- `alc_get_hp_pin()` — reads `spec->gen.autocfg.hp_pins[0]` or
  line_out_pins[0] if type is HP

### Step 5.4: Call Chain
PCI SSID match → `alc245_tas2781_i2c_hp_fixup_muteled` (PRE_PROBE/INIT)
→ `vmaster_mute.hook` set → generic HDA build connects hook to Master
Playback Switch → hook fires on mute state change. Reachable from
userspace ALSA mixer controls and platform hotkeys.

Record: Path reachable from userspace mixer and hardware mute button.

### Step 5.5: Similar Patterns
The `vmaster_mute.hook` mechanism is used in 4+ other codec drivers
(analog, conexant, senarytech, ca0132). The pattern of direct COEF
register writes for LED control is standard in the Realtek driver.

Record: Uses well-established patterns from multiple codec drivers.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Code Existence in Stable Trees
- **v6.19**: `alc245_tas2781_i2c_hp_fixup_muteled` EXISTS (verified via
  `git show v6.19:...`)
- **v6.18**: DOES NOT EXIST (verified, returns 0 matches)
- **v6.12**: DOES NOT EXIST (verified, returns 0 matches)
- `9afbbf4903228c` is ancestor of v6.19 but NOT ancestor of v6.18

Record: **Only 6.19.y contains the buggy code.** Not applicable to
6.18.y, 6.12.y, 6.6.y, 6.1.y, or any older LTS trees.

### Step 6.2: Backport Complications
For 6.19.y: The function body in v6.19 matches the pre-patch context of
the diff. Should apply cleanly.

Record: Clean apply expected for 6.19.y only.

### Step 6.3: Related Fixes in Stable
No related fixes for this specific issue already in stable.

Record: No duplicate fixes.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- Subsystem: sound/hda/codecs/realtek — HDA audio codec driver
- Criticality: IMPORTANT for affected laptops/workstations (audio is
  user-facing), but driver-specific

Record: IMPORTANT subsystem, driver-specific fix.

### Step 7.2: Subsystem Activity
The file is extremely active with constant quirk additions and LED
fixes. This is routine maintenance for the Realtek codec driver.

Record: Highly active subsystem; mute LED fixes are common and routine.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
HP EliteBoard G1a (NexusX) and potentially HP ZBook 8 G2a users running
6.19.y stable kernels with the `ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED`
fixup.

Record: Driver-specific, affects users of specific HP platforms on
6.19.y.

### Step 8.2: Trigger Conditions
The bug triggers on every boot — the mute LED simply never works. 100%
reproducible on affected hardware.

Record: Always triggers on affected hardware. Confirmed reproducible by
Launchpad bug.

### Step 8.3: Failure Mode Severity
Non-functional speaker mute LED. Audio mute/unmute itself works
correctly. This is a LOW severity user experience issue — no crash, no
data corruption, no security impact.

Record: Severity LOW — non-functional LED indicator.

### Step 8.4: Risk-Benefit Ratio
- **Benefit**: LOW-MEDIUM — fixes user-visible hardware feature on
  specific HP platforms. Ubuntu tracked this as OEM-priority.
- **Risk**: LOW — only activates for specific HP platform SSIDs. ~20
  lines, single file. Tested on real hardware. The probe ordering
  concern means the vmaster hook path activates for ALL platforms using
  this fixup (including ZBook), but the worst-case failure mode is wrong
  LED polarity on those platforms (still LOW severity).
- **Ratio**: Favorable — low risk, clear benefit for affected users.

Record: Benefit > Risk. Small, well-tested change with bounded failure
modes.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes a real user-facing issue confirmed by Ubuntu Launchpad bug
  #2136846
- Hardware quirk/workaround — explicitly allowed in stable rules
- Small, surgical change (~20 lines, single file)
- Author is the Realtek codec vendor engineer (maximum authority)
- Tested-by from Canonical developer (Chris Chiu) on real hardware
- Accepted by ALSA maintainer (Takashi Iwai)
- Uses well-established `vmaster_mute.hook` mechanism (4+ codec drivers)
- Applies cleanly to 6.19.y
- Ubuntu already prioritized the underlying bug as OEM-priority

**AGAINST backporting:**
- Severity is LOW (LED malfunction, not crash/security/corruption)
- Only applicable to 6.19.y (code doesn't exist in older stable trees)
- Probe ordering issue: `alc_get_hp_pin()` always returns 0 during
  PRE_PROBE, meaning the vmaster hook path activates for ALL platforms
  using this fixup, not just no-HP models
- LED polarity in the vmaster hook appears inverted from the standard
  LED classdev convention
- Code is only ~4 months old (introduced in v6.19-rc1)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** Tested-by present, but probe
   ordering question makes it not 100% "obviously correct" from code
   inspection alone. The polarity inversion is either intentional for
   this hardware or a concern. The Tested-by and maintainer acceptance
   provide practical confidence.
2. **Fixes a real bug?** YES — confirmed by Launchpad bug and Tested-by
3. **Important issue?** Borderline — LED malfunction is low severity,
   but it's a real user-visible hardware issue
4. **Small and contained?** YES — ~20 lines, single file
5. **No new features or APIs?** YES — hardware workaround only
6. **Can apply to stable?** YES — to 6.19.y only

### Step 9.3: Exception Categories
This falls squarely into the **hardware quirk/workaround** exception
category. Audio codec quirks for specific platforms are routinely
backported to stable and are explicitly listed as acceptable in stable
rules.

### Step 9.4: Decision
This is a hardware quirk fix for specific HP platforms, authored by the
Realtek codec vendor, tested on real hardware by Canonical, and accepted
by the ALSA maintainer. While there are legitimate technical concerns
about probe ordering (the `alc_get_hp_pin()` check at PRE_PROBE time)
and LED polarity inversion compared to the standard path, the worst-case
failure mode for any regression is wrong LED behavior (LOW severity),
and the fix was verified working on the target hardware. Hardware quirks
are explicitly allowed in stable, and the fix is only applicable to
6.19.y where the prerequisite code exists. The Ubuntu Launchpad bug
confirms this is a real user-facing issue that was tracked as OEM-
priority.

---

## Verification

- [Phase 1] Parsed commit message and tags from provided text: Tested-by
  Chris Chiu (Canonical), SOB from Kailang Yang (Realtek) and Takashi
  Iwai (ALSA maintainer), Link to lore
- [Phase 2] Read `sound/hda/codecs/realtek/alc269.c` lines 3700-3719
  (pre-patch function), lines 1540-1554
  (`alc245_fixup_hp_mute_led_coefbit` showing coef values: idx=0x0b,
  mask=3<<2=0x0c, on=2<<2=0x08, off=1<<2=0x04)
- [Phase 2] Read `sound/hda/codecs/realtek/alc269.c` lines 1481-1491
  (`coef_mute_led_set` → `alc_update_coef_led` using polarity +
  brightness)
- [Phase 2] Read `sound/hda/codecs/realtek/alc269.c` lines 1470-1479
  (`alc_update_coef_led` logic: if polarity, invert; write on/off based
  on boolean)
- [Phase 2] Verified vmaster hook semantics: `sound/core/vmaster.c` line
  515: `master->hook(master->hook_private_data, master->val)` —
  `master->val` for boolean is 1=unmuted, 0=muted
- [Phase 2] Verified `snd_hda_gen_add_mute_led_cdev()` at
  `sound/hda/codecs/generic.c` lines 3952-3971: sets
  `vmaster_mute_led=1`, checks `if (spec->vmaster_mute.hook)` and prints
  error if already present
- [Phase 2] Confirmed polarity: new hook writes 0x08 when enabled=1
  (unmuted), 0x04 when enabled=0 (muted) — opposite to LED classdev
  convention where brightness=1 (LED on) means muted
- [Phase 2] Verified probe ordering: `alc269.c` line 8595
  (`snd_hda_apply_fixup PRE_PROBE`) runs BEFORE line 8603
  (`alc269_parse_auto_config`), so autocfg.hp_pins is zero during
  PRE_PROBE
- [Phase 2] Verified `alc_get_hp_pin()` at `realtek.c` lines 506-513:
  reads from `spec->gen.autocfg.hp_pins[0]` and `line_out_pins[0]`, both
  empty during PRE_PROBE
- [Phase 2] Cross-checked with existing vmaster hooks:
  `ad_vmaster_eapd_hook` (analog.c:131) and `senary_auto_vmaster_hook`
  (senarytech.c:112) both use `enabled=1` → active, confirming
  convention
- [Phase 3] `git blame -L 3703,3719`: confirmed all lines from
  `9afbbf4903228c` (Kailang Yang, 2025-11-20)
- [Phase 3] `git show 9afbbf4903228c`: confirmed subject "Enable Mute
  LED and Tas2781 for HP platform", 56 lines added, 10 removed
- [Phase 3] `git blame -L 7155,7162`: confirmed ZBook entries
  (0x8f40-0x8f62) also from `9afbbf4903228c`, NexusX also from same
  commit
- [Phase 3] `git log --author='Kailang Yang' -15`: confirmed frequent
  contributor with related commits
- [Phase 4] Fetched Ubuntu Launchpad Bug #2136846: confirmed real bug,
  NexusX platform, comment #3 "mic-mute led works but the mute led does
  not" after initial upstream fix
- [Phase 5] Grep `ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED`: found 5
  SND_PCI_QUIRK entries and fixup table definition
- [Phase 5] Grep `vmaster_mute.hook`: confirmed usage in analog.c,
  conexant.c, senarytech.c — well-established pattern
- [Phase 6] `git merge-base --is-ancestor 9afbbf4903228c v6.19` → YES
- [Phase 6] `git merge-base --is-ancestor 9afbbf4903228c v6.18` → NOT
  ancestor
- [Phase 6] `git show v6.19:sound/hda/codecs/realtek/alc269.c | grep
  alc245_tas2781_i2c_hp_fixup_muteled` → found (exists in v6.19)
- [Phase 6] `git show v6.18:...` and `v6.12:...` → 0 matches (does not
  exist in older trees)
- [Phase 6] Fixup table entry confirmed: `.type = HDA_FIXUP_FUNC,
  .v.func = alc245_tas2781_i2c_hp_fixup_muteled` — no chaining to other
  fixups
- UNVERIFIED: Could not access lore.kernel.org discussion due to Anubis
  bot protection
- UNVERIFIED: Whether all ZBook 8 G2a models actually have headphone
  jacks (if they don't, the probe ordering concern is moot)
- UNVERIFIED: Whether the LED polarity inversion is intentional for this
  hardware family or a latent bug (Tested-by and maintainer acceptance
  suggest intentional, but not confirmed)

**YES**

 sound/hda/codecs/realtek/alc269.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1054191d56fa1..0c710daa945ec 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3699,22 +3699,42 @@ static void alc245_tas2781_spi_hp_fixup_muteled(struct hda_codec *codec,
 	alc_fixup_hp_gpio_led(codec, action, 0x04, 0x0);
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
+
+static void alc245_hp_spk_mute_led_update(void *private_data, int enabled)
+{
+	struct hda_codec *codec = private_data;
+	unsigned int val;
+
+	val = enabled ? 0x08 : 0x04; /* 0x08 led on, 0x04 led off */
+	alc_update_coef_idx(codec, 0x0b, 0x0c, val);
+}
+
 /* JD2: mute led GPIO3: micmute led */
 static void alc245_tas2781_i2c_hp_fixup_muteled(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
 	struct alc_spec *spec = codec->spec;
+	hda_nid_t hp_pin = alc_get_hp_pin(spec);
 	static const hda_nid_t conn[] = { 0x02 };
 
 	switch (action) {
 	case HDA_FIXUP_ACT_PRE_PROBE:
+		if (!hp_pin) {
+			spec->gen.vmaster_mute.hook = alc245_hp_spk_mute_led_update;
+			spec->gen.vmaster_mute_led = 1;
+		}
 		spec->gen.auto_mute_via_amp = 1;
 		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
 		break;
+	case HDA_FIXUP_ACT_INIT:
+		if (!hp_pin)
+			alc245_hp_spk_mute_led_update(codec, !spec->gen.master_mute);
+		break;
 	}
 
 	tas2781_fixup_txnw_i2c(codec, fix, action);
-	alc245_fixup_hp_mute_led_coefbit(codec, fix, action);
+	if (hp_pin)
+		alc245_fixup_hp_mute_led_coefbit(codec, fix, action);
 	alc285_fixup_hp_coef_micmute_led(codec, fix, action);
 }
 /*
-- 
2.53.0

