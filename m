Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28878598BF3;
	Mon, 19 Oct 2026 13:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418132; cv=none; b=L9u5Z+nOF+/11eM4HntVBMNMGGL3CEEGp1bFHXOiN5OItn9jvDaECTB0+X/uk5O7lVSBhpNUq9+FPsf81uzx3B0+PuKVYZgTDXc2NATW6h8pS1QSYkqF4FiDq6XUYKAASnXh/WOwxqxTSEi1rDxbLMefBYMXUAN/LrwzMWC+Uv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418132; c=relaxed/simple;
	bh=Aygo043rp4XYGEyuz1/HXdvWZtti0kRaRTSuN1TxxSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dcrF+IvkYq8u0UbXXEN3wvB+bwcYHAjy2k2MEPYxBc/s1cKFrKt++OLgdwUeKK84RVBQekqLcGIypRs/n8wI8rB6o3If6i0b+LjTWTJ7R/IM9C/uZ661L1MGyuSz0AL3CJet6ThaVMM4hVbpAChlv7/MGnpcxvNmCWxI6avXzL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hN8AuCAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hN8AuCAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146C41F000C8;
	Mon, 19 Oct 2026 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418129;
	bh=SJw99qlKEMQ/mL5JfxB15WQrx2ca90eJRKQjczSUWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hN8AuCAup1jPxPoPn9i0Avwavt95sfDsczJv2R8FQ+SxeXiUV0+X3UxcHKwc/cJjD
	 hrzo55W2VNBPhYEEIZ0Wwh5p1tM8ouVrY+fdzMaP9w59HWDVwRFmY8VQpiDvFivmIi
	 ZfS3RSApivRloC9vVHYxbh8G9qyGFTYanRbtjkkiWz/8b55v75BVrsr2dqCdsp67UE
	 +mB49VRSsN06DYTlFM9p0b2ilM7Kz4dm3MLI+DMQ/eVJzzgI3EfamavEkDBqJObblN
	 gJ0Nq0vXYh1IHLlw/aBJv0/HAXKLNW6t8FYgXE5AZqq3Xp8HkCW8UrKpsqej4bxgRs
	 zuovsF5+8IVPg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] ALSA: hda/conexant: Add pin config quirk for Huawei Matebook
Date: Mon, 19 Oct 2026 09:45:23 -0400
Message-ID: <20261019135441.1420968-32-sashal@kernel.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit d152afd1cd7a69c752236b6e825c4e62a74788eb ]

The headphone jack is not detected on this Huawei Matebook (Conexant
SN6140 codec). The BIOS incorrectly marks Pin 0x18 as [N/A], causing
the driver to report hp_outs=0 and no "Headphones" output appears.

Override the pin configuration for NID 0x18 to set it as a headphone
jack, which restores proper detection and audio routing.

Link: https://github.com/thesofproject/sof/issues/10687
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260807125857.678297-4-zhangheng@kylinos.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.12.111** (`pending-6.12`). This is a Conexant SN6140
pin-config quirk for one Huawei PCI/codec SSID; the driver and SN6140
support are already here.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[ALSA hda/conexant] [Add] pin config quirk for Huawei Matebook`

Subsystem: ALSA HD-audio Conexant codec. Action: add a hardware quirk
(not a feature). Intent: restore headphone jack detection on a specific
laptop whose BIOS marks the jack pin as N/A.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Link: https://github.com/thesofproject/sof/issues/10687` — user bug
  report with codec dump
- `Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>` — author
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` — ALSA maintainer
  applied it
- `Link:
  https://patch.msgid.link/20260807125857.678297-4-zhangheng@kylinos.cn`
  — lore msgid; **patch 4/4** of a series
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable` (absence expected for this review)
- Ignore any pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit
  …]`

Notable: GitHub issue is a concrete user report, not syzbot. Maintainer
SOB is a strong quality signal.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** Huawei Matebook, Conexant SN6140. BIOS marks pin NID 0x18 as
  `[N/A]`.
- **Symptom:** driver reports `hp_outs=0`; no "Headphones" sink; sound
  stays on internal speakers when a 3.5mm jack is plugged in.
- **Root cause:** wrong pin default so autoconfig never classifies a
  headphone output.
- **Fix:** override NID 0x18 to pin config `0x03211020` (headphone
  jack).
- **Version info in message:** none. GitHub issue (followed in Phase 4)
  used **Debian 13, kernel 6.12.73**.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a hidden fix. It is an explicit hardware quirk for a broken
BIOS pin config. That is the documented stable exception for codec/PCI
quirks.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File in the commit: `sound/hda/codecs/conexant.c` (+9 / −0)
- Local 6.12 path: `sound/pci/hda/patch_conexant.c` (codecs had not been
  moved yet)
- Functions/data: `enum { … }` last entry; `cxt_fixups[]`;
  `cxt5066_fixups[]`
- Scope: single-file surgical quirk; three tiny hunks

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
1. Enum: add `CXT_FIXUP_HUAWEI_MATEBOOK_HP` after
   `CXT_FIXUP_ACER_SWIFT_HP` (already the last entry in this tree at
   line 309).
2. `cxt_fixups[]`: `HDA_FIXUP_PINS` table `{ 0x18, 0x03211020 }`.
3. `cxt5066_fixups[]`: `SND_PCI_QUIRK(0x19e5, 0x3289, …)` inserted after
   the Lenovo vendor catch-all and before Lemote `0x1c06`.

Before: SN6140 probe hits `default:` in `patch_conexant_auto()`, picks
`cxt5066_fixups`, no Huawei entry, BIOS pin 0x18 (`0x40f001f0`,
connectivity N/A) is parsed, `hp_outs=0`.
After: SSID `19e5:3289` selects the new fixup.
`snd_hda_apply_fixup(PRE_PROBE)` calls `snd_hda_apply_pincfgs()` and
overrides pin 0x18 before `snd_hda_parse_pin_defcfg()`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **Hardware quirk / pin-config workaround (category h).** BIOS
advertises the headphone pin as unconnected. The driver then never
creates a Headphones path or jack-based speaker mute. Override is the
standard HDA fix (`HDA_FIXUP_PINS`), same pattern as Acer Swift SF314
and Lenovo IdeaPad Slim 5 already in this file.

Pin default `0x03211020` = Jack, external left, HP Out, 1/8" stereo,
black, association 2. Matches the GitHub user’s working `hda-jack-
retask` firmware.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and minimal. Scoped to one SSID.
`SND_PCI_QUIRK_VENDOR(0x17aa, …)` cannot match Huawei `0x19e5`.
Regression risk is limited to machines that share `19e5:3289` and need a
*different* pin 0x18 role — standard quirk risk, same as other SSID
entries. No locking, no API, no extra module parameter.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record: The bug is missing a table entry, not a newly introduced logic
bug. SN6140 IDs exist since `ca348e7fe1ab9` ("add a new hda codec
SN6140") — **ancestor of this HEAD**. Pin parse / `HDA_FIXUP_PINS` is
old (2011-era enum terminator still blamed on Takashi Iwai). Insertion
neighbors: Acer Swift (Feb 2026, already backported here as
`ab6a494abecb8b`), Lemote quirks from 2012.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Expected. Nothing to follow. The “bug” is a
BIOS pin default, not a kernel regression SHA.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record (this tree, `sound/pci/hda/patch_conexant.c`):
- `775911e09ec28` pin config quirk for Lenovo IdeaPad Slim 5 16AKP10
  (SN6140)
- `ab6a494abecb8b` Acer Swift headphone pin tweak
- `6e1664116a9609` MECHREVO headset-mic quirk
Same class of backports already landed in 6.12.y.

Standalone vs series: submitted as **4/4**. Patches 1–3 are Realtek
`alc269.c` quirks for unrelated SSIDs. This hunk does not use any of
them.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Zhang Heng has other ALSA quirk work in this tree (Realtek +
Conexant mic-bias). Not the subsystem maintainer. Takashi Iwai applied
the patch. That is the usual path for HDA quirks.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs existing `HDA_FIXUP_PINS`, `cxt_fixups[]`,
`cxt5066_fixups[]`, SN6140 `0x14f11f87`, and `snd_hda_pick_fixup()`. All
present. Does **not** need `CXT_FIXUP_LENOVO_XPAD_ACPI` (mainline
context only). Can apply standalone with a path rename plus one-line
context fuzz on the Lenovo vendor quirk string.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 am` on msgid `20260807125857.678297-4-zhangheng@kylinos.cn`
  matched the series:
  https://patch.msgid.link/20260807125857.678297-1-zhangheng@kylinos.cn
- Public copies: https://lists.openwall.net/linux-kernel/2026/08/07/1129
  and https://lkml.iu.edu/hypermail/linux/kernel/2608.0/13447.html
- Single revision of this series (no v2 of 4/4 in the thread `b4`
  analyzed)
- `b4 dig -c` on this SHA was not possible: the commit is not in this
  6.12 object graph
- No NAK in the saved series mbox. Applied by Takashi (SOB on the commit
  under review)
- Lore HTTP fetch returned 403; used `b4` + openwall/lkml mirrors
  instead

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 am` headers): To `tiwai@suse.com`; Cc `linux-
sound@vger.kernel.org`, `linux-kernel@vger.kernel.org`. Correct
maintainer and list. No extra Reviewed-by on the patch itself;
maintainer SOB is the review signal.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record — GitHub thesofproject/sof#10687 (closed):
- Author ciniap, 2026-04-07; **Kernel 6.12.73+deb13-amd64**, Intel Alder
  Lake-P Huawei, SOF `sof-hda-generic-2ch.tplg`
- Codec dump: Node 0x18 Pin Default `0x40f001f0: [N/A]`; dmesg
  `hp_outs=0`
- User fixed it with firmware pin override `{ 0x18 0x03211020 }` —
  **same value as this patch**
- Impact: speakers stay on with headphones; no private listening
- Zhang Heng later commented that the upstream patch was sent

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 1/4 Acer Nitro Realtek headset mic; 2/4 Acer Gadget E10 speaker
pin; 3/4 ASUS Vivobook Realtek headset mic; 4/4 this Conexant Huawei
pincfg. Independent table rows. 4/4 does not need 1–3.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned 403. No evidence in-tree
that this Huawei SSID was already selected. Similar Conexant pin quirks
**were** already pulled into this 6.12 branch.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: No function bodies edited. Data consumed by
`snd_hda_pick_fixup()`, `__snd_hda_apply_fixup()` / `HDA_FIXUP_PINS`,
`snd_hda_apply_pincfgs()`, `patch_conexant_auto()`.

**Step 5.2: TRACE CALLERS**
Record: `patch_conexant_auto()` is the SN6140 probe
(`HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto)`). Default
branch uses `cxt5066_fixups`. Probe-time only, not IRQ/hot path.

**Step 5.3: TRACE CALLEES**
Record: `snd_hda_codec_set_pincfg()` per pin; then
`snd_hda_parse_pin_defcfg()` / `snd_hda_gen_parse_auto_config()` build
Headphones and auto-mute.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace-visible on boot of that laptop (codec probe). Original
report is plugging headphones. Unprivileged user can trigger the broken
behavior; the quirk itself is not a syscall attack surface.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same file already has `CXT_FIXUP_ACER_SWIFT_HP` (`{ 0x16,
0x0321403f }`) and Lenovo Slim 5 SN6140 pincfg. Realtek uses
`0x03211020` widely for HP Out. Pattern is established.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.** Tree is `v6.12.111` (`pending-6.12`).
- Driver: `sound/pci/hda/patch_conexant.c`
- SN6140: `HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto)`
  and `is_cx11880_sn6140` for `0x14f11f87`
- No `CXT_FIXUP_HUAWEI_MATEBOOK_HP`, no `0x19e5` in this file
- Reporter’s kernel was **6.12.73** — this series

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Minor conflicts, not a rewrite.**
- Path: `sound/hda/codecs/conexant.c` → `sound/pci/hda/patch_conexant.c`
- Enum/fixup table context matches (`CXT_FIXUP_ACER_SWIFT_HP` is last)
- Quirk-table context: 6.12 still has `SND_PCI_QUIRK_VENDOR(0x17aa,
  "Thinkpad", CXT_FIXUP_THINKPAD_ACPI)` vs mainline `Thinkpad/Ideapad` +
  `CXT_FIXUP_LENOVO_XPAD_ACPI`. Insert still goes before
  `SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", …)`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No Huawei Matebook Conexant pincfg. Acer Swift / IdeaPad Slim 5
/ MECHREVO are different SSIDs. Not a duplicate.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `sound/pci/hda` Conexant codec. **IMPORTANT** (common laptop
audio), not core mm/VFS. User-visible breakage for that hardware.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active enough that 6.12 already received several Conexant quirks
in 2026. Mature table; this is another row, not a redesign.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / SSID-specific: Huawei machines with PCI or
codec SSID **19e5:3289** and SN6140. `snd_hda_pick_fixup()` matches PCI
SSID first, then codec SSID, so the GitHub codec SSID `0x19e53289` is
covered even on SOF (`ehdaudio0D0`).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: Every boot on that SKU; 100% repro in the bug report when
plugging 3.5mm headphones. Not a race. Unprivileged user hits it by
using the jack.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Headphones not enumerated; speakers keep playing. Not an
oops/UAF. **MEDIUM** functional/hardware-enablement failure, the class
stable already takes as audio quirks. Privacy impact (cannot mute
speakers via jack) is real.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for that SKU (headphones/auto-mute restored); reporter
  was on 6.12.
- Risk: very low (≈9 lines, one SSID, existing `HDA_FIXUP_PINS`
  machinery).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware bug with codec dump and 100% repro
- Reporter on **6.12.73**, this tree’s series
- Same pin value the user already verified via jack retask
- Textbook HDA pin quirk (stable exception)
- ~9 lines, no new API
- SN6140 + quirk tables already in 6.12
- Maintainer SOB (Takashi Iwai)
- Sibling Conexant pin quirks already in this branch
- Independent of series patches 1–3

AGAINST:
- Not a crash/security issue
- Path + one-line context need a trivial backport
- SSID-wide pin override could theoretically mis-configure another board
  sharing `19e5:3289` (normal quirk caveat; no such report found)

UNRESOLVED:
- Full lore thread replies (`b4 mbox` failed to write the file); no NAK
  found in the series mbox
- Stable list 403; no prior rejection found
- Exact Matebook marketing name beyond SSID `19e5:3289`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard pincfg; user-
   validated override; maintainer applied
2. Fixes a real bug that affects users? **PASS** — GitHub #10687, Debian
   6.12
3. Important issue? **PASS** as hardware-enablement/quirk (headphones
   dead; speakers stay on), not CRITICAL oops
4. Small and contained? **PASS** — 9 lines, one file
5. No new features or APIs? **PASS** — table entry only
6. Can apply to the local tree? **PASS** — content matches; remap path
   to `patch_conexant.c`; fuzz the 17aa vendor line

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **Hardware quirk/workaround** (HDA pin-config / PCI SSID quirk).
Also the “device ID / quirk table” class used constantly in stable
audio.

**Step 9.4: MAKE YOUR DECISION**
This belongs in this 6.12 tree. The Conexant SN6140 driver is here, the
BIOS bug is here, and the original report is this stable series.
Backport with the usual path adjustment.

Verification:
- [Phase 1] Tags: GitHub sof#10687, msgid 4/4, SOB Zhang Heng + Takashi
  Iwai; no Fixes/Cc:stable
- [Phase 1] Body: BIOS pin 0x18 N/A → hp_outs=0; override 0x03211020
- [Phase 2] Diff: +9 lines, enum + `cxt_fixups` + `cxt5066_fixups`;
  `HDA_FIXUP_PINS`
- [Phase 3] `git merge-base --is-ancestor ca348e7fe1ab9 HEAD` → SN6140
  in tree (exit 0)
- [Phase 3] `git log` on `patch_conexant.c`: Acer Swift, IdeaPad Slim 5,
  MECHREVO already backported
- [Phase 3] Series 1–3 are Realtek-only; 4/4 standalone
- [Phase 4] `b4 am` found 4-patch series; openwall/lkml copies of 4/4;
  no NAK in series mbox
- [Phase 4] sof#10687: kernel 6.12.73, pin dump 0x40f001f0, working
  override 0x03211020
- [Phase 4] lore.kernel.org WebFetch 403; `b4 dig -c` N/A (commit not in
  this repo); `b4 mbox` traceback on output path
- [Phase 5] `patch_conexant_auto` default → `cxt5066_fixups`; PRE_PROBE
  `snd_hda_apply_pincfgs`
- [Phase 5] `snd_hda_pick_fixup` matches PCI SSID then codec SSID
- [Phase 6] `git describe HEAD` → `p-6.12-3-g710455e2077bb`; Makefile
  6.12.111; file `sound/pci/hda/patch_conexant.c`
- [Phase 6] No `0x19e5` / `CXT_FIXUP_HUAWEI` in local conexant driver
- [Phase 6] Enum last entry is `CXT_FIXUP_ACER_SWIFT_HP` (clean insert);
  quirk insert before Lemote 0x1c06
- [Phase 8] Failure: missing Headphones + no auto-mute; severity MEDIUM;
  SSID-scoped
- UNVERIFIED: complete lore reply set after maintainer apply; whether
  any other SKU shares 19e5:3289 with a different pin 0x18 role

The patch is a small, SSID-scoped HDA pin quirk for a real headphone-
detection failure that was reproduced on 6.12. It matches stable’s
hardware-quirk exception and applies here with only a path remap.

**YES**

 sound/hda/codecs/conexant.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index 56d6fbdd9b06d..ef40f1cb1158e 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -298,6 +298,7 @@ enum {
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
 	CXT_FIXUP_ACER_SWIFT_HP,
+	CXT_FIXUP_HUAWEI_MATEBOOK_HP,
 };
 
 /* for hda_fixup_thinkpad_acpi() */
@@ -1043,6 +1044,13 @@ static const struct hda_fixup cxt_fixups[] = {
 			{ }
 		},
 	},
+	[CXT_FIXUP_HUAWEI_MATEBOOK_HP] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x18, 0x03211020 }, /* Headphone */
+			{ }
+		},
+	},
 };
 
 static const struct hda_quirk cxt5045_fixups[] = {
@@ -1143,6 +1151,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3978, "Lenovo G50-70", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK_VENDOR(0x17aa, "Thinkpad/Ideapad", CXT_FIXUP_LENOVO_XPAD_ACPI),
+	SND_PCI_QUIRK(0x19e5, 0x3289, "Huawei Matebook", CXT_FIXUP_HUAWEI_MATEBOOK_HP),
 	SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
 	SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
 	SND_PCI_QUIRK(0x1d05, 0x3012, "MECHREVO Wujie 15X Pro", CXT_FIXUP_HEADSET_MIC),
-- 
2.53.0

