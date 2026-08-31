Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D35947CA89;
	Mon, 31 Aug 2026 13:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183361; cv=none; b=Ym+Uy9U9nxeN/QtT3AYwcasAFAzqlhu+lcUlQbaT39vv3qzjaqp3NMN2gBcOxXUwRrR1A3w6EVtAkWKICJJPbSX4Gsx2JNAw91B19qo3D7ma9ptYPi4G0mpz8UHOT2ohz2tCCfUi5SzIkg/QPfQYMOV82lR2IlfZ4G/7ElwUpmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183361; c=relaxed/simple;
	bh=wod/HMkSv//5T2gf2RQr57j3jF8Lr7WpYo1Od7XV34c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TalAe37GtJB4dLt2xfBwQOT7OPRYCgcQtHcgBgXCiKNvLAFtlmX78PUV0nwYdbpzAs9DI0MoNIc/QpkvNkf1c+PPa1xElU/IDWWE4v+6L//qOubLeYlllY7Jly/TNdV/DCPoJotPvJObJEMrnTAp7uU6MnL/MCYkmMX0hPTL4vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FqhFjFLg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqhFjFLg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8DB1F00A3E;
	Mon, 31 Aug 2026 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183359;
	bh=ahlZPyLBgzB2r84fLnraW0FBw9ZX2LWR50RWd5H2TEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqhFjFLgO8q9937RrPLfyM77lyiOuCkusQhGqQ/NY8osD3MrWuf96Rs8rJS7yhjop
	 xjB6nRC0KJhUAnyKkjlv+IWAAwMRuppjwVh1YUQKQ3mVrG9/nTaFMBsoUfR2P4d41C
	 t7T9/9HyWeSJsMw2qkvuctmEXx8oY7VDMVf0d04lo8wIMxaVajv8pZIs153WsX1fJK
	 uDyUcbmfy4uHX8eCKc//00edIXNraC/I3h9t9WNk8Rb/WanwB8zlZfhUVmusm9wrHE
	 Gp7AZCNvFGvh8WeR/rcM7rexOuwuVto8M4rnZz26GDTRNz5xMFLxQfVEyr9WSMX0ZL
	 zA3kaOgOW0tXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Galen Hassen <rwekyes@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ALSA: hda/conexant: Add pin config quirk for Lenovo IdeaPad Slim 5 16AKP10
Date: Mon, 31 Aug 2026 09:22:09 -0400
Message-ID: <20260831133314.4125787-101-sashal@kernel.org>
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

From: Galen Hassen <rwekyes@gmail.com>

[ Upstream commit f7c4968ae3af3e819428da5416c2dfd361473f5c ]

The Lenovo IdeaPad Slim 5 16AKP10 (PCI SSID 17aa:38b6) uses the
Conexant SN6140 codec. The internal microphone is on pin 0x1a but
the BIOS configures it with pin default 0x95a60120, which includes
a jack detection bit that causes the kernel to treat it as an
unplugged external mic rather than a fixed internal mic.

Add a pin config quirk that overrides pin 0x1a to 0x95a60130,
setting the connectivity bits to indicate a fixed/always-connected
device. This allows the internal microphone to be correctly
identified and used.

Signed-off-by: Galen Hassen <rwekyes@gmail.com>
Link: https://patch.msgid.link/20260616173257.37373-1-rwekyes@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: ALSA HDA Conexant Lenovo IdeaPad Slim 5
16AKP10 Quirk

**Local tree:** `v6.18.44` (`linux-6.18.y` stable), HEAD `2736c32da98b9`
**Candidate commit:** `d69c76ccc5540` (upstream `f7c4968ae3af`) — **not
present in current HEAD**

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1 — Subject line**
Record: `[ALSA: hda/conexant]` `[Add]` — Add pin config quirk for Lenovo
IdeaPad Slim 5 16AKP10

**Step 1.2 — Tags**
Record:
- `Signed-off-by: Galen Hassen <rwekyes@gmail.com>` (author)
- `Signed-off-by: Takashi Iwai <tiwai@suse.de>` (ALSA maintainer)
- `Link:
  https://patch.msgid.link/20260616173257.37373-1-rwekyes@gmail.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Cc:
  stable@vger.kernel.org`

Notable: maintainer Signed-off-by; no syzbot/fuzzer involvement.

**Step 1.3 — Body analysis**
Record:
- **Bug:** Lenovo IdeaPad Slim 5 16AKP10 (PCI SSID `17aa:38b6`) with
  Conexant SN6140 codec; internal mic on pin `0x1a` has BIOS default
  `0x95a60120` with jack-detection connectivity bits.
- **Symptom:** Kernel treats internal mic as unplugged external mic;
  internal microphone unusable.
- **Fix:** Override pin `0x1a` to `0x95a60130` (fixed/always-connected
  connectivity).
- **Root cause:** Incorrect BIOS pin configuration, not a kernel logic
  bug.

**Step 1.4 — Hidden bug fix?**
Record: Yes — presented as "Add quirk" but fixes a real hardware
enablement bug (broken internal microphone). Classic HDA codec quirk
pattern, not cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1 — Inventory**
Record:
- **File:** `sound/hda/codecs/conexant.c` only (+12 lines)
- **Changes:** New enum `CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10`, pin
  table, fixup entry, `SND_PCI_QUIRK(0x17aa, 0x38b6, ...)`
- **Scope:** Single-file, surgical hardware quirk addition

**Step 2.2 — Code flow**
Record per hunk:
1. **Enum entry** → registers new fixup ID in existing enum.
2. **Pin table** `{ 0x1a, 0x95a60130 }` → overrides BIOS default at
   probe via `HDA_FIXUP_PINS`.
3. **Fixup table entry** → wires pin table into `cxt_fixups[]`.
4. **PCI quirk** → matches SSID `17aa:38b6` to apply fixup on probe.

Before: SN6140 codec uses BIOS pin config; pin `0x1a` seen as jack-
detect external mic (unplugged).
After: Pin `0x1a` forced to fixed internal mic; ALSA correctly exposes
internal microphone.

**Step 2.3 — Bug mechanism**
Record: **Hardware workaround / codec quirk** — incorrect BIOS HDA pin
default causes wrong jack connectivity classification. Same pattern as
existing `CXT_PINCFG_SWS_JS201D` (`0x95a70130` for internal mic on
SN6140 hardware).

**Step 2.4 — Fix quality**
Record: Obviously correct; minimal; follows established quirk
infrastructure. Regression risk very low — only affects machines
matching `17aa:38b6`. No locking, no API, no behavior change for other
hardware.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1 — Blame**
Record: Similar SN6140 quirk (`cxt_pincfg_sws_js201d`, pin `0x18` =
`0x95a70130`) introduced in `4639c5021029d` (Feb 2024, originally
`patch_conexant.c`). Long-standing, proven pattern.

**Step 3.2 — Fixes: tag**
Record: N/A — no `Fixes:` tag. Bug is BIOS misconfiguration, not
introduced by a specific kernel commit.

**Step 3.3 — Related file history**
Record: Recent `conexant.c` changes in this tree include headset mic
fixes, Acer Swift HP fix, HP ZBook quirk — all similar hardware quirk
additions. Standalone patch, not part of a series.

**Step 3.4 — Author context**
Record: Galen Hassen is a hardware reporter/contributor (also submitted
USB quirk patches). Takashi Iwai (ALSA maintainer) applied the patch on
lore ("Applied now. Thanks.").

**Step 3.5 — Dependencies**
Record: No prerequisites. Requires only existing Conexant driver
infrastructure:
- SN6140 codec ID `0x14f11f87` present since `ca348e7fe1ab9` (in this
  tree)
- SN6140 uses default `cxt5066_fixups` path via `snd_hda_pick_fixup()`
  fallthrough
- `git apply --check` on the diff against current tree: **passes
  cleanly**

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1 — Original discussion**
Record:
- Lore URL:
  https://patch.msgid.link/20260616173257.37373-1-rwekyes@gmail.com
- Series: v1 (2026-06-15) → v2 (2026-06-16); committed version is v2
  (latest)
- Takashi Iwai reply: "Applied now. Thanks." — no NAKs, no objections
- No explicit stable nomination in thread

**Step 4.2 — Reviewers**
Record: CC'd to `tiwai@suse.de`, `alsa-devel@alsa-project.org`, `linux-
sound@vger.kernel.org`. Maintainer reviewed and merged.

**Step 4.3 — Bug report**
Record: User-reported hardware issue from patch author (owns the
laptop). No bugzilla/syzbot link. Severity from user perspective:
internal microphone completely non-functional.

**Step 4.4 — Related patches**
Record: Separate Realtek quirk exists for Yoga 7 16AKP10
(`e656ef8698e28` on autosel) — different codec/subsystem; not a
dependency.

**Step 4.5 — Stable list history**
Record: No stable-specific discussion found for this patch.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1 — Key functions/structures**
Record: `cxt_pincfg_lenovo_ideapad_slim5_16akp10[]`, `cxt_fixups[]`,
`cxt5066_fixups[]`, `cx_probe()` (via `snd_hda_pick_fixup` +
`snd_hda_apply_fixup`)

**Step 5.2 — Callers**
Record: `cx_probe()` → `snd_hda_pick_fixup(codec, cxt5066_fixup_models,
cxt5066_fixups, cxt_fixups)` → matches `SND_PCI_QUIRK(0x17aa, 0x38b6)` →
`snd_hda_apply_fixup(HDA_FIXUP_ACT_PRE_PROBE)` applies pin overrides
before `snd_hda_parse_pin_defcfg()`. Called during HDA codec probe at
boot/module load.

**Step 5.3 — Callees**
Record: Standard HDA fixup framework (`HDA_FIXUP_PINS` →
`snd_hda_apply_pincfgs`). No special runtime callbacks.

**Step 5.4 — Reachability**
Record: Triggered automatically on every boot for matching hardware
(`17aa:38b6` + Conexant SN6140). Not userspace-triggerable, but affects
all users of this laptop model.

**Step 5.5 — Similar patterns**
Record: `CXT_PINCFG_SWS_JS201D` uses `0x95a70130` for SN6140 internal
mic; `CXT_FIXUP_HP_MIC_NO_PRESENCE` fixes similar jack-presence
misconfiguration on pin `0x1a`. Same bug class, same fix approach.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

**Step 6.1 — Buggy code exists?**
Record: **Yes.** Conexant driver with SN6140 support (`0x14f11f87`) and
`cxt5066_fixups[]` quirk table exist in 6.18.44. Without this quirk,
affected laptops get wrong pin config from BIOS. Quirk `17aa:38b6` is
absent (grep confirms no matches).

**Step 6.2 — Backport complications**
Record: **Clean apply** — `git apply --check` succeeded with zero
conflicts. File was moved from `patch_conexant.c` to
`sound/hda/codecs/conexant.c` in this tree, but upstream commit already
targets the new path.

**Step 6.3 — Related fixes already present?**
Record: No existing fix for `17aa:38b6` or IdeaPad Slim 5 16AKP10 in
this tree.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1 — Subsystem**
Record: `sound/hda/codecs` — ALSA HDA codec driver. **Criticality:
PERIPHERAL** (driver-specific), but HDA quirks are routinely backported
because they fix real hardware for real users.

**Step 7.2 — Activity**
Record: Actively maintained; multiple recent Conexant quirk commits in
6.18.y history.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1 — Who is affected**
Record: Owners of Lenovo IdeaPad Slim 5 16AKP10 (`17aa:38b6`) with
Conexant SN6140 codec. Config-dependent on
`CONFIG_SND_HDA_CODEC_CONEXANT`. Narrow hardware population, but 100%
affected on that hardware without the quirk.

**Step 8.2 — Trigger conditions**
Record: Every boot / codec probe on matching hardware. Not timing-
dependent; deterministic BIOS misconfiguration.

**Step 8.3 — Failure mode severity**
Record: Internal microphone non-functional (no audio input from built-in
mic). **Severity: MEDIUM** — functional regression, not
crash/corruption/security. Video calls, voice recording broken out of
the box.

**Step 8.4 — Risk vs benefit**
Record:
- **Benefit:** Restores internal microphone on a specific popular
  consumer laptop; zero-cost for all other hardware.
- **Risk:** Very low — 12-line quirk, PCI SSID-scoped, established
  pattern.
- **Ratio:** Strong benefit for affected users, negligible risk for
  everyone else.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1 — Evidence summary**

**FOR backport:**
- Real hardware bug: internal mic broken due to wrong BIOS pin config
- Hardware quirk exception category (explicitly stable-appropriate)
- Small (12 lines), single file, applies cleanly to 6.18.44
- SN6140 driver and quirk infrastructure already in tree
- ALSA maintainer (Takashi Iwai) reviewed and applied
- Follows proven pattern (`CXT_PINCFG_SWS_JS201D`,
  `CXT_FIXUP_HP_MIC_NO_PRESENCE`)
- No dependencies, no new APIs

**AGAINST backport:**
- Not a crash, security, or data-corruption issue
- Affects only one laptop model (narrow scope)
- No explicit `Cc: stable` or `Tested-by` from hardware owner

**Unresolved:** None material to the decision.

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — standard quirk pattern;
   maintainer merged
2. Fixes a real bug affecting users? **PASS** — internal mic unusable on
   affected laptop
3. Important issue? **PASS** (hardware functionality) — not CRITICAL
   severity, but hardware quirk fixes are standard stable material per
   stable-kernel-rules exceptions
4. Small and contained? **PASS** — 12 lines, one file
5. No new features or APIs? **PASS** — quirk table entry only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception category**
Record: **Hardware quirk/workaround** — codec pin configuration override
for broken BIOS. Automatic stable qualification per documented
exceptions.

**Step 9.4 — Decision rationale**
This is a textbook HDA codec hardware quirk: the Conexant SN6140 driver
already exists in 6.18.44, the patch applies cleanly, and without it the
internal microphone on the Lenovo IdeaPad Slim 5 16AKP10 is non-
functional. The fix is minimal, PCI-SSID-scoped, and follows the same
pattern as numerous other Conexant quirks already in stable trees. While
not a crash-level bug, restoring broken hardware functionality via
targeted quirks is exactly what stable kernels are expected to carry.

---

## Verification

- [Phase 1] Parsed subject, tags, body; no Fixes:/Reported-by:/syzbot
- [Phase 1] Identified hardware quirk fixing broken internal microphone
- [Phase 2] Diff: 12 lines added to `sound/hda/codecs/conexant.c`; enum
  + pintbl + fixup + PCI quirk
- [Phase 2] Bug category: hardware pin config workaround (jack-detect →
  fixed internal)
- [Phase 3] `git describe HEAD`: v6.18.44-1-g2736c32da98b9; `make
  kernelversion`: 6.18.44
- [Phase 3] `git blame` on SWS JS201D quirk: `4639c5021029d` (Feb 2024),
  same SN6140 pattern
- [Phase 3] Commit `d69c76ccc5540` NOT ancestor of HEAD; upstream
  `f7c4968ae3af`
- [Phase 3] `git apply --check` on diff against current tree: **clean
  apply**
- [Phase 3] SN6140 codec `0x14f11f87` in tree since `ca348e7fe1ab9`;
  rename commit `7f4c540e0859e` also in tree
- [Phase 4] `b4 dig -c d69c76ccc5540`: lore thread found
- [Phase 4] `b4 dig -a`: v1→v2 series; v2 is committed version
- [Phase 4] `b4 dig -w`: CC'd tiwai@suse.de, alsa-devel, linux-sound
- [Phase 4] Mbox thread: Takashi Iwai "Applied now. Thanks."; no NAKs;
  no stable nomination
- [Phase 5] Verified SN6140 (`0x14f11f87`) uses `cxt5066_fixups` via
  default fallthrough in `cx_probe()`
- [Phase 5] `grep 38b6` / `IDEAPAD_SLIM5` in conexant.c: no matches
  (quirk absent)
- [Phase 5] Similar pin value `0x95a70130` exists at line 838 (SWS
  JS201D internal mic)
- [Phase 6] Conexant driver, SN6140 support, and quirk tables confirmed
  present in 6.18.44
- [Phase 8] Failure mode: internal mic non-functional; severity MEDIUM;
  risk VERY LOW

**YES**

 sound/hda/codecs/conexant.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/sound/hda/codecs/conexant.c b/sound/hda/codecs/conexant.c
index c3c8326d0b77a..fe7445fabb887 100644
--- a/sound/hda/codecs/conexant.c
+++ b/sound/hda/codecs/conexant.c
@@ -294,6 +294,7 @@ enum {
 	CXT_FIXUP_HEADSET_MIC,
 	CXT_FIXUP_HP_MIC_NO_PRESENCE,
 	CXT_PINCFG_SWS_JS201D,
+	CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10,
 	CXT_PINCFG_TOP_SPEAKER,
 	CXT_FIXUP_HP_A_U,
 	CXT_FIXUP_ACER_SWIFT_HP,
@@ -831,6 +832,12 @@ static const struct hda_pintbl cxt_pincfg_lemote[] = {
 	{}
 };
 
+/* Lenovo IdeaPad Slim 5 16AKP10 with SN6140 */
+static const struct hda_pintbl cxt_pincfg_lenovo_ideapad_slim5_16akp10[] = {
+	{ 0x1a, 0x95a60130 }, /* Internal mic, fixed/always-connected */
+	{}
+};
+
 /* SuoWoSi/South-holding JS201D with sn6140 */
 static const struct hda_pintbl cxt_pincfg_sws_js201d[] = {
 	{ 0x16, 0x03211040 }, /* hp out */
@@ -1011,6 +1018,10 @@ static const struct hda_fixup cxt_fixups[] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = cxt_pincfg_sws_js201d,
 	},
+	[CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = cxt_pincfg_lenovo_ideapad_slim5_16akp10,
+	},
 	[CXT_PINCFG_TOP_SPEAKER] = {
 		.type = HDA_FIXUP_PINS,
 		.v.pins = (const struct hda_pintbl[]) {
@@ -1119,6 +1130,7 @@ static const struct hda_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x17aa, 0x21da, "Lenovo X220", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x21db, "Lenovo X220-tablet", CXT_PINCFG_LENOVO_TP410),
 	SND_PCI_QUIRK(0x17aa, 0x38af, "Lenovo IdeaPad Z560", CXT_FIXUP_MUTE_LED_EAPD),
+	SND_PCI_QUIRK(0x17aa, 0x38b6, "Lenovo IdeaPad Slim 5 16AKP10", CXT_PINCFG_LENOVO_IDEAPAD_SLIM5_16AKP10),
 	SND_PCI_QUIRK(0x17aa, 0x3905, "Lenovo G50-30", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x390b, "Lenovo G50-80", CXT_FIXUP_STEREO_DMIC),
 	SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
-- 
2.53.0

