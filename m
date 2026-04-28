Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24B03EF678;
	Tue, 28 Apr 2026 10:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777372896; cv=none; b=FHSMu4nMAzxXHe045T8OiXny8FBfm5pgRwswmfemCFUEZcEpQhcQiD+EhHYkxb88wN78dfeexXuvwAAa+4lJr8ZhRuXQ07Zbi+u69wavFBLx5HEzvHKqY8TgxApIllFQO45li5cUGPegJY75KQ/g19pWmrVTax9eCIPYeBWqHtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777372896; c=relaxed/simple;
	bh=0TvWbBh4U/QB9F2vsPBTvPWiuHyPhPtd5/8TwgA8YEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d3xH0oQXdmC37pJpzrf+i0/ejHOTawnM7wfZGKgiMwOt/YOq/p7594G5/qN2ekoWnvScMVPniEYhE3JewAKhZ83QQnidIHlVbcwjaAUMIDGrsVrCkHgPkwuOLMT3opgtvmAk/RUCZWBWqRdXMeQ5s037lXKQDzHzvko05qJGthI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qJb/NE1w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qJb/NE1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 535A1C2BCAF;
	Tue, 28 Apr 2026 10:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777372896;
	bh=0TvWbBh4U/QB9F2vsPBTvPWiuHyPhPtd5/8TwgA8YEg=;
	h=From:To:Cc:Subject:Date:From;
	b=qJb/NE1wnyYMhoh1DLllF8ecDlSdwQ1lEnGwAAgsTfT3pG7dOVhr7jZJJev4vEYPI
	 t3MvdiUT+JDh9kAurv89KX9roXZeJh9rYw8I4R4Lm2rPhTwGS44YN6utpHthN4lDM8
	 Dcrqph94rLN2VvwXBYGzfwkfbM3th3wX38ckqIKqc/jB6DvTccx7c5PLPS3m3mJXdI
	 fKaYnBTn+qZkbV6AHVheshdx/vlmfDShCKJaT5SKZkQjcNmA43JbfZATYs3jsJ6nRd
	 RH3yIEDkSNGL6VkdE/AnROB+mCN8xnEbieboj/BiZO1drFNqF6RHQLzILpTgOT0dng
	 Dixbx8LqTclmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Timofey Tarasenko <timka.tarasen@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ALSA: hda/realtek: add quirk for HONOR MRB-XXX M1020
Date: Tue, 28 Apr 2026 06:40:12 -0400
Message-ID: <20260428104133.2858589-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.2
Content-Transfer-Encoding: 8bit

From: Timofey Tarasenko <timka.tarasen@gmail.com>

[ Upstream commit d9448dca423543c6c0a9890d3ff53a5d51895318 ]

Adds pin fixups to enable subwoofer and JACK functionality
on Honor Magicbook Art 14 2025 (HONOR MRB-XXX M1020)

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221147
Signed-off-by: Timofey Tarasenko <timka.tarasen@gmail.com>
Link: https://patch.msgid.link/20260415074657.1217862-1-timka.tarasen@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to make a thorough analysis.

## Phase 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject line parsing**
- Subsystem: `ALSA: hda/realtek:`
- Action verb: "add quirk"
- Summary: Add audio quirk for HONOR Magicbook Art 14 2025 (HONOR MRB-
  XXX M1020)
- Record: `[ALSA: hda/realtek] [add quirk] [enable subwoofer and JACK on
  Honor Magicbook Art 14 2025]`

**Step 1.2: Commit tags**
- `Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221147` - real
  user bug report
- `Signed-off-by: Timofey Tarasenko` (author)
- `Link: https://patch.msgid.link/...` - mailing list submission link
- `Signed-off-by: Takashi Iwai` (maintainer) - the ALSA HDA maintainer
- No `Fixes:` tag (expected - this is hardware enablement, not a
  regression fix)
- No `Cc: stable` (expected for review pipeline - per problem statement,
  absence isn't negative)
- Record: `[Bugzilla closed by patch] [Signed off by ALSA maintainer
  Takashi Iwai]`

**Step 1.3: Commit body analysis**
- Bug: subwoofer and JACK functionality don't work out-of-the-box on
  HONOR Magicbook Art 14 2025
- Symptom: hardware features non-functional without correct pin
  configuration
- Mechanism: HDA codec auto-config does not produce correct pin
  defaults; explicit pin config needed
- Record: `[Subwoofer + headset jack non-functional] [Failure mode:
  missing audio output and jack detection] [Root cause: BIOS pin
  defaults inadequate, override needed]`

**Step 1.4: Hidden bug fix detection**
- This is overtly hardware enablement via quirk, not disguised as a fix
- Without it the laptop's audio hardware is partially non-functional
- Record: `[Not disguised cleanup - it is an explicit hardware-enabling
  quirk]`

## Phase 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- 1 file: `sound/hda/codecs/realtek/alc269.c` (+13/-0 net)
- 4 small additions: enum entry, fixup definition, SND_PCI_QUIRK entry,
  model name entry
- Scope: Single-file, additive-only, surgical
- Record: `[1 file, ~13 lines added, 0 removed] [Functions touched: none
  - data tables only] [Scope: surgical, additive only]`

**Step 2.2: Code flow change**
- Before: PCI ID 0x1ee7:0x2081 (HONOR MRB-XXX M1020) hits the alc269
  driver but no specific fixup applies, leaving BIOS-default pin
  configuration
- After: The driver's quirk table matches this PCI ID and applies pin
  overrides for nodes 0x14 (speaker, 0x90170111), 0x19 (mic-in headset
  jack, 0x03a1113c), 0x1a (subwoofer, 0x22a190a0), 0x1b (speaker,
  0x90170110)
- Record: `[Before: BIOS pin defaults wrong -> sub/jack don't work] ->
  [After: explicit pin config applied at probe -> hardware fully works]`

**Step 2.3: Bug mechanism**
- Category: Hardware workaround / quirk (item h in the bug categories)
- Mechanism: BIOS/firmware reports incorrect pin defaults; the patch
  overrides them via the standard HDA_FIXUP_PINS mechanism, which is the
  canonical method for these problems
- Record: `[Bug category: hardware quirk for incorrect BIOS pin
  defaults] [Mechanism: pintbl override of 4 widget pin configurations]`

**Step 2.4: Fix quality**
- Identical pattern to dozens of existing quirks in the same file (e.g.,
  line 7755 `HONOR BRB-X M1010`, the touchpad quirk for the same laptop
  family in HID)
- The pin values follow standard Realtek pin defaults format (0x90170110
  = internal speaker, 0x03a1113c = headset jack, 0x22a190a0 = subwoofer-
  style internal speaker)
- Cannot regress: applies only to the specific PCI ID 0x1ee7:0x2081
- Record: `[Fix quality: high, follows established patterns] [Regression
  risk: zero for users without this exact device]`

## Phase 3: GIT HISTORY INVESTIGATION

**Step 3.1: blame the changed lines**
- The neighbouring entries (HONOR BRB-X M1010 at line 7755) were added
  by `b26e2afb3834d` ("ALSA: hda/realtek: Fix headset mic on HONOR
  BRB-X" - Aug 11 2025)
- The enum scaffolding has existed since the file was created
- Record: `[The quirk infrastructure has been stable for years; HONOR-
  style quirks are an established pattern]`

**Step 3.2: Fixes: tag**
- Not applicable: hardware enablement, not a regression fix
- Record: `[No Fixes: tag - hardware never worked correctly without this
  quirk]`

**Step 3.3: File history of related changes**
- The HONOR BRB-X M1010 quirk (`b26e2afb3834d`) was explicitly tagged
  `Cc: <stable@vger.kernel.org>` and went to stable
- Similar recent quirks: `dd9b99b822684` (Acer Swift SFG14-73 - Cc:
  stable), `1fbf85dbf02c9` (HP Victus - Cc: stable), `0bdf27abaf894`
  (ASUS Strix G16 - Cc: stable)
- Record: `[Pattern established: similar HONOR quirk b26e2afb3834d was
  Cc:stable; multiple recent peer quirks Cc:stable]`

**Step 3.4: Author's other commits**
- Author Timofey Tarasenko has no other commits in this tree (first-time
  contributor closing a bugzilla)
- The patch was reviewed and signed-off by Takashi Iwai, the actual ALSA
  HDA maintainer
- Record: `[Author: bug reporter / first-time contributor] [Vetted by
  maintainer Takashi Iwai]`

**Step 3.5: Dependencies**
- The fixup uses only HDA_FIXUP_PINS infrastructure that has existed for
  over a decade
- No prerequisite commits required
- Record: `[Standalone] [Zero prerequisites - HDA_FIXUP_PINS is core
  infrastructure]`

## Phase 4: MAILING LIST RESEARCH

**Step 4.1-4.5:**
- Direct fetches to lore.kernel.org and bugzilla.kernel.org are blocked
  by Anubis anti-bot challenge from this environment
- The commit message itself contains the Bugzilla and lore links
- The commit was applied with the maintainer's Signed-off-by, indicating
  maintainer approval after review
- The HONOR MagicBook Art 14 family already has companion quirks merged
  elsewhere (HID touchpad, HONOR BRB-X audio)
- Record: `[lore/bugzilla unreachable from this environment due to
  Anubis] [Maintainer SOB present] [Companion HONOR-family quirks
  already accepted to stable]`

## Phase 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key functions**
- No function changes - data table additions only
- Affected logic: `snd_hda_pick_fixup()` matching at codec probe time

**Step 5.2-5.4: Reachability**
- The quirk table is consulted during `alc269_fixup_tbl` lookup at HDA
  codec probe (boot/resume/module-load)
- Triggered exclusively when the HDA controller exposes subsystem ID
  0x1ee7:0x2081
- For all other systems, the new entries are inert (the SND_PCI_QUIRK
  arrays are matched by SSID, the fixup is referenced only by enum
  index)
- Record: `[Reachability: only when matching SSID 0x1ee7:0x2081 is
  present] [No impact on any other system]`

**Step 5.5: Similar patterns**
- The same line block contains hundreds of analogous SND_PCI_QUIRK
  entries; the immediate predecessor is the HONOR BRB-X entry (line
  7755) which was Cc: stable
- Record: `[Identical pattern repeated across the entire
  alc269_fixup_tbl - this is the canonical way to add device-specific
  audio quirks]`

## Phase 6: STABLE TREE ANALYSIS

**Step 6.1: Code in stable trees?**
- ALC269/ALC256 driver and `alc269_fixup_tbl` exist in every active
  stable tree (5.4+)
- The HDA_FIXUP_PINS framework is decade+ old
- Record: `[Driver and quirk table present in all active stable trees:
  5.4, 5.10, 5.15, 6.1, 6.6, 6.12]`

**Step 6.2: Backport complications**
- File path differs between stable trees: in 6.17+ the file is
  `sound/hda/codecs/realtek/alc269.c` (after splits `aeeb85f26c3bb` and
  `6014e9021b28e` in July 2025); in 6.16 and earlier it is
  `sound/pci/hda/patch_realtek.c`
- The four hunks add new enum entries / new struct entries / a new
  SND_PCI_QUIRK row / a new model name; they apply cleanly with only
  path adjustment because no surrounding code was modified
- Record: `[Backport difficulty: trivial - same content, only path
  differs for stable < 6.17]`

**Step 6.3: Already in stable?**
- Not yet present in stable trees; the new SSID 0x1ee7:0x2081 has no
  entry
- Record: `[Not in stable; nothing already addresses this device]`

## Phase 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem criticality**
- ALSA HDA realtek driver - widely-used audio codec driver shipped with
  most x86 laptops
- Criticality classification: PERIPHERAL (specific hardware) but with
  high user count
- Record: `[Subsystem: sound/hda] [Criticality: peripheral but
  ubiquitous - applies only to one specific laptop SKU]`

**Step 7.2: Subsystem activity**
- High activity - dozens of similar quirks added per release
- Record: `[High activity, well-maintained, quirk additions are
  routine]`

## Phase 8: IMPACT AND RISK

**Step 8.1: Affected users**
- Owners of HONOR Magicbook Art 14 2025 laptops (HONOR MRB-XXX M1020)
- Quirk is keyed off SSID 0x1ee7:0x2081, so only this exact device is
  affected
- Record: `[Affected: HONOR Magicbook Art 14 2025 owners only; zero
  impact on others]`

**Step 8.2: Trigger conditions**
- Triggered every probe (boot/resume/module reload) on the matching
  laptop
- Record: `[Trigger: 100% of boots on the affected device, no impact
  otherwise]`

**Step 8.3: Failure mode without fix**
- Subwoofer not driven, headset jack mic input/detection broken on the
  laptop
- Severity: MEDIUM - functional regression for the user but not a
  crash/security issue
- Record: `[Failure mode: missing audio output (subwoofer) and broken
  headset functionality] [Severity: MEDIUM - usability/functionality]`

**Step 8.4: Risk-benefit**
- Benefit: real hardware works on stable kernels for affected users
- Risk: virtually zero - additive change, gated by exact SSID
- Record: `[Benefit: medium (per-device, but real)] [Risk: minimal]
  [Ratio: strongly favors backport]`

## Phase 9: SYNTHESIS

**Step 9.1: Evidence**
- FOR: Real user bug (Bugzilla 221147), maintainer SOB by Takashi Iwai,
  identical pattern to peer HONOR quirk that went to stable, additive-
  only, gated by exact SSID, fits the "AUDIO CODEC QUIRKS" exception
  explicitly listed as stable-eligible
- AGAINST: Path differs between mainline and stable (cosmetic backport
  hurdle only)
- Unresolved: Cannot directly fetch lore for the original review thread
  (Anubis challenge)

**Step 9.2: Stable rules**
1. Obviously correct? Yes - data table additions, no logic
2. Real bug? Yes - bugzilla user report
3. Important? Functional hardware enablement (audio HW partly broken
   without it)
4. Small? Yes - ~13 lines, 1 file
5. No new features/APIs? Correct - reuses existing HDA fixup framework
6. Applies to stable? Yes with trivial path change for trees <6.17

**Step 9.3: Exception category**
- Falls into "AUDIO CODEC QUIRKS (sound/pci/hda/patch_realtek.c)" - the
  policy explicitly states "These are all YES for stable - they fix real
  hardware for real users."

**Step 9.4: Decision**
- Strong YES - textbook stable-worthy hardware quirk

## Verification

- [Phase 1] Parsed the commit message: confirmed Closes: bugzilla,
  maintainer SOB by Takashi Iwai, no Fixes: or Cc:stable (expected)
- [Phase 2] Read `sound/hda/codecs/realtek/alc269.c` lines 4090-6669 and
  7740-7755: verified the diff inserts cleanly into existing tables; pin
  values match standard Realtek pintbl format (verified via existing
  entries 0x90170110 in many other fixups)
- [Phase 3] `git log --oneline --grep=HONOR -- sound/`: found
  `b26e2afb3834d` peer quirk; `git show b26e2afb3834d`: confirmed Cc:
  stable in similar HONOR BRB-X quirk
- [Phase 3] `git show` on 7 recent peer quirks (`dd9b99b822684`,
  `720460722310c`, `1fbf85dbf02c9`, `bac1e57adf08c`, `0bdf27abaf894`,
  `7bae956cac043`, `0d3429f12133c`): three explicit Cc:stable, others
  not - confirms maintainer treats device quirks as stable-eligible on a
  per-device basis
- [Phase 3] `git log --oneline --grep="quirk for HONOR"`: found
  `7a5ab80711143` HID quirk for same HONOR MagicBook Art 14 family -
  confirms real product family with multiple needed quirks
- [Phase 4] WebFetch lore.kernel.org and bugzilla.kernel.org: BLOCKED by
  Anubis anti-bot, marked UNVERIFIED for direct review thread content;
  commit message links are recorded though
- [Phase 5] Grep for `0x1ee7` in current tree: confirmed only one
  existing entry (HONOR BRB-X M1010) - the new SSID 0x2081 is not yet
  present
- [Phase 6] `git log --diff-filter=A --
  sound/hda/codecs/realtek/alc269.c` and `git show aeeb85f26c3bb` and
  `git show 6014e9021b28e`: confirmed the file was created via
  split+move in July 2025 (mainline 6.17), so older stable trees use
  `sound/pci/hda/patch_realtek.c`
- [Phase 8] Reachability: pin fixup applies only when subsystem ID
  0x1ee7:0x2081 matches at codec probe - confirmed via `SND_PCI_QUIRK`
  macro semantics in the same file
- UNVERIFIED: Direct read of lore.kernel.org thread (b4 dig fallback not
  run due to environment limits, but the patch is already applied with
  maintainer SOB so review presumably occurred)
- UNVERIFIED: Exact stable trees the maintainer would target - but the
  policy in the prompt explicitly classifies audio codec quirks as YES

## Decision

This is a textbook hardware quirk addition - small, surgical, gated by a
unique SSID, fixing real hardware (subwoofer + headset jack) for real
users on a shipping laptop with a Bugzilla report. It matches the
explicit "AUDIO CODEC QUIRKS" exception that the stable rules allow,
follows the same pattern as the peer `HONOR BRB-X M1010` quirk that was
Cc: stable, and is signed off by the ALSA HDA maintainer. Backport
requires only a trivial path change for stable trees older than 6.17.

**YES**

 sound/hda/codecs/realtek/alc269.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 45f9d64873885..d35932b46267f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4124,6 +4124,7 @@ enum {
 	ALC245_FIXUP_ACER_MICMUTE_LED,
 	ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED,
 	ALC236_FIXUP_HP_DMIC,
+	ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6666,6 +6667,16 @@ static const struct hda_fixup alc269_fixups[] = {
 			{ 0x12, 0x90a60160 }, /* use as internal mic */
 			{ }
 		},
+	},
+	[ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO] = {
+		.type = HDA_FIXUP_PINS,
+		.v.pins = (const struct hda_pintbl[]) {
+			{ 0x14, 0x90170111 },
+			{ 0x19, 0x03a1113c },
+			{ 0x1a, 0x22a190a0 },
+			{ 0x1b, 0x90170110 },
+			{ }
+		}
 	}
 };
 
@@ -7753,6 +7764,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1ee7, 0x2081, "HONOR MRB-XXX M1020", ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO),
 	SND_PCI_QUIRK(0x1f4c, 0xe001, "Minisforum V3 (SE)", ALC245_FIXUP_BASS_HP_DAC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
@@ -7973,6 +7985,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC236_FIXUP_LENOVO_INV_DMIC, .name = "alc236-fixup-lenovo-inv-mic"},
 	{.id = ALC2XX_FIXUP_HEADSET_MIC, .name = "alc2xx-fixup-headset-mic"},
 	{.id = ALC245_FIXUP_BASS_HP_DAC, .name = "alc245-fixup-bass-hp-dac"},
+	{.id = ALC256_FIXUP_HONOR_MRB_XXX_M1020_AUDIO, .name = "alc256-honor-mrb-xxx-m1020-audio"},
 	{}
 };
 #define ALC225_STANDARD_PINS \
-- 
2.53.0

