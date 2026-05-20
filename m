Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB0C3DB63D;
	Wed, 20 May 2026 11:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779276005; cv=none; b=oSjyJSXYoDj5PpdS7J2kM5D12PNNM5DHjmNSHIa3sdYeq6nVRlVSFQU17UlYSORMLwRt0o6IX5SGjFHp3EElkQdaEINQ4bRLH3Wk0yLWNI720uYJ3xxzVJ4S3CtVXowgbSs7kUrtKRhhb64RQFBT0xxMayB50VzS1GTwtdv1nnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779276005; c=relaxed/simple;
	bh=shPqrFD2Rl2M8pTyuPm+Sbf6QmwCQHDLfL0hKgrOAmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYvMZe4nP8wdKG8sDwxtTCMivNWigdvI4UNpb1QBbeJtBZBw9cDnr/hlZ6RzWa69LZ4ST2rVxsIu4Nf2bwplxmSsy03eQK6ymNlcuboTRDMWSoMB/7RgGK665ZISPbJNjIlQ1qxqR9rxG3FsCAXGHrn61odd2IfejA8jHajApkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STbGcf+8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STbGcf+8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B89E1F00894;
	Wed, 20 May 2026 11:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779276002;
	bh=COtCp1RJxojVDhpO6z2k+0d61AGdyhLRc3KUZcoQBA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STbGcf+85YfPN8y5yggFHl4Qc4IaHZaq6RgpbwCfHQFI0SbX8mG8mT2SdMhJGu2YV
	 woyywu63Nj4+Z54dV6laIChTOOu86tPC6OL9suovJawz4VKxhO/5HZADBlX+3A3f7R
	 t98a69bXtwNacZFL67g0fUILslJBMrx68cyyXRDuMDneViWRh+kFdKvqGu7kycgj7A
	 NcC5H31tP9sZu+/jR1nOa2fKaqyXpLYyJABKTdkjgQgT0AFKlZVWBbMz0od8fctP59
	 UxbdH9gDMd/ryJRsfUveZdoyGctTQ72Chd2yyai5ONA2JcnkWOhVhZk8TdkCHNB164
	 GXuYX9vZbK3qQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniel Schaefer <dhs@frame.work>,
	"Dustin L. Howett" <dustin@howett.net>,
	linux@frame.work,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.6] ALSA: hda/realtek: fix mic boost on Framework PTL
Date: Wed, 20 May 2026 07:18:44 -0400
Message-ID: <20260520111944.3424570-12-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260520111944.3424570-1-sashal@kernel.org>
References: <20260520111944.3424570-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Schaefer <dhs@frame.work>

[ Upstream commit 67c73815220784074ff13ec07df955911caf1b73 ]

In addition to the mic jack fix, also need to avoid boosting the
internal mic too much, otherwise >50% input volume clips a lot.

Also add a second SSID. We have one for the classic chassis/speaker and
one for the new Pro chassis/speaker.

To: Jaroslav Kysela <perex@perex.cz>
To: Takashi Iwai <tiwai@suse.com>
To: linux-sound@vger.kernel.org
Cc: Dustin L. Howett <dustin@howett.net>
Cc: linux@frame.work
Signed-off-by: Daniel Schaefer <dhs@frame.work>
Link: https://patch.msgid.link/20260513155513.11683-1-dhs@frame.work
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem is `ALSA: hda/realtek`. Action verb is `fix`.
Claimed intent is to fix excessive internal microphone boost on
Framework PTL systems and add a second Framework PTL SSID.

Step 1.2 Record: Tags present:
- `To`: Jaroslav Kysela, Takashi Iwai, `linux-sound@vger.kernel.org`
- `Cc`: Dustin L. Howett, `linux@frame.work`
- `Signed-off-by`: Daniel Schaefer
- `Link`:
  `https://patch.msgid.link/20260513155513.11683-1-dhs@frame.work`
- `Signed-off-by`: Takashi Iwai
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, `Acked-by`,
  or `Cc: stable@vger.kernel.org` tag was present.

Step 1.3 Record: The commit describes a real user-visible audio defect:
the internal microphone clips heavily when input volume is above 50%. It
also states there are two SSIDs for the Framework PTL generation, one
classic chassis/speaker and one Pro chassis/speaker. No crash, stack
trace, or kernel-version range is described.

Step 1.4 Record: This is not a hidden memory-safety bug. It is an
explicit hardware quirk/audio correctness fix: it corrects the quirk
selected for one Framework PTL SSID and adds another SSID.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed: `sound/hda/codecs/realtek/alc269.c`,
9 insertions and 1 deletion. Modified areas are the Realtek fixup enum,
`alc269_fixups[]`, and `alc269_fixup_tbl[]`. Scope is a single-file,
surgical driver quirk change.

Step 2.2 Record:
- Enum hunk: before, only
  `ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE` existed; after, a
  Framework-specific chained mic-boost limiter fixup ID is added.
- Fixup table hunk: before, Framework systems only got the mic-
  presence/headset-mode chain; after, the new Framework PTL fixup first
  invokes `alc269_fixup_limit_int_mic_boost` and then chains to the
  existing Framework mic-presence fixup.
- Quirk table hunk: before, `0xf111:0x000f` used only the Framework mic-
  presence fixup; after, `0xf111:0x000f` uses the mic-boost-limiting
  chain, and `0xf111:0x010f` is added with the same chain.

Step 2.3 Record: Bug category is hardware quirk/workaround plus device
ID addition. The fix reuses existing `alc269_fixup_limit_int_mic_boost`,
which, on `HDA_FIXUP_ACT_PROBE`, finds internal analog mic pins and
overrides input amp caps to limit boost levels. No race, memory-safety,
refcount, or error-path bug is involved.

Step 2.4 Record: Fix quality is high: minimal, contained, uses existing
Realtek HDA fixup infrastructure, and only affects two explicit
Framework subsystem IDs. Regression risk is very low and limited to
those two machines; the only plausible risk is reducing available mic
gain too much on those exact SSIDs.

## Phase 3: Git History Investigation
Step 3.1 Record: `git blame` on the parent of commit
`67c73815220784074ff13ec07df955911caf1b73` shows the existing Framework
fixup/table structure came through the Realtek driver split/import
commit `c08e42c9a40ab`, while the `0xf111:0x000f` quirk line itself was
introduced by `bac1e57adf08c9` in the v7.0 cycle. Historical `git show`
verified the original Framework fixup was introduced by `309d7363ca3d9`,
first described by `git describe` as `v5.18~27^2~3`. The boost-limiting
helper pattern was present since `8903376dc6994`, described as
`v5.14-rc7~16^2~1`.

Step 3.2 Record: No `Fixes:` tag is present, so there was no Fixes
target to follow.

Step 3.3 Record: Recent file history shows many Realtek laptop quirk
commits, including `bac1e57adf08c` for Framework `0xf111:000f`. No
required multi-patch series was found for this candidate.

Step 3.4 Record: Author Daniel Schaefer previously authored Framework
`0xf111:000c` Realtek quirk work. Dustin Howett, CC’d here, authored
several Framework Realtek quirk commits. Takashi Iwai applied this patch
and is the ALSA HDA maintainer path for these commits.

Step 3.5 Record: Dependencies are the existing Framework mic-presence
fixup and existing mic-boost limiter helper. They exist in the local
current tree; older stable trees before the
`sound/hda/codecs/realtek/alc269.c` split would need a path/context
backport to `sound/pci/hda/patch_realtek.c`.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 67c73815220784074ff13ec07df955911caf1b73`
matched the patch by patch-id and found
`https://patch.msgid.link/20260513155513.11683-1-dhs@frame.work`. `b4
dig -a` found only v1. The saved thread contains Takashi Iwai’s reply:
“Applied now. Thanks.” No NAKs or requested revisions were found.

Step 4.2 Record: `b4 dig -w` lists Daniel Schaefer, Jaroslav Kysela,
Takashi Iwai, `linux-sound@vger.kernel.org`, Dustin L. Howett, and
`linux@frame.work` as original participants. Appropriate ALSA
maintainers/list were included.

Step 4.3 Record: No separate `Reported-by` bug report was linked.
Phoronix independently reports the same applied commit and repeats the
stated impact: Framework PTL internal mic clips above 50% input volume;
it identifies the hardware as Framework Laptop 13 Pro / Panther Lake.

Step 4.4 Record: Related patches include earlier Framework Realtek quirk
additions for `0xf111:0001`, `0009`, `000c`, and `000f`, plus several
prior “Limit mic boost” Realtek quirks. This candidate is standalone.

Step 4.5 Record: Web search did not find stable-list discussion for this
exact candidate. No stable-specific objection was found.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: No ordinary function body is newly changed. The
affected code is the Realtek HDA fixup selection tables plus the
existing helper `alc269_fixup_limit_int_mic_boost`.

Step 5.2 Record: Caller path is `alc269_probe`, which calls
`snd_hda_pick_fixup` using `alc269_fixup_tbl`, then applies fixups at
`HDA_FIXUP_ACT_PRE_PROBE` and `HDA_FIXUP_ACT_PROBE`. The impact surface
is limited to probe/init of matching Realtek HDA codecs with Framework
SSIDs `0xf111:000f` or `0xf111:010f`.

Step 5.3 Record: The key helper calls `snd_hda_codec_get_pincfg`,
`snd_hda_get_input_pin_attr`, and `snd_hda_override_amp_caps`.
`snd_hda_override_amp_caps` is documented in code as overriding cached
amp caps, useful to adjust amp ranges such as limiting to 0 dB.

Step 5.4 Record: The buggy path is reachable automatically during codec
probe on the affected hardware. The user-visible failure is then
triggered by normal microphone capture with input volume above 50%. This
is not an unprivileged security trigger; it is normal hardware use.

Step 5.5 Record: Similar Realtek mic-boost limiter quirks exist,
including `8903376dc6994`, `86a433862912f`, `6db03b1929e20`, and
`76b0a22d4cf7d`. Some prior similar mic-boost quirk commits carried `Cc:
stable@vger.kernel.org`.

## Phase 6: Cross-Referencing And Stable Tree Analysis
Step 6.1 Record: `v7.0` contains the `0xf111:000f` Framework line, so
the wrong/insufficient fixup exists in v7.0.y candidates. `v6.18` and
`v6.17` tags checked locally did not contain `0xf111:000f`. `v6.12` and
`v6.6` contain the base Framework fixup and boost helper, but not the
newer `000f`/`010f` IDs.

Step 6.2 Record: The patch applies cleanly to the current local tree
with `git apply --check`. It should be straightforward for v7.0.y. Older
stable trees may need mechanical backporting because the Realtek code
lived in `sound/pci/hda/patch_realtek.c` before the driver split.

Step 6.3 Record: No alternate fix for this exact Framework PTL mic boost
issue was found in local history or stable-search results.

## Phase 7: Subsystem And Maintainer Context
Step 7.1 Record: Subsystem is ALSA HDA Realtek codec driver. Criticality
is driver-specific/important for affected laptop users, not core-kernel
universal.

Step 7.2 Record: The Realtek HDA quirk area is very active; recent
history shows many laptop quirk additions/fixes in the same file.

## Phase 8: Impact And Risk Assessment
Step 8.1 Record: Affected population is Framework Laptop 13 Pro PTL and
Framework Laptop 13 PTL users with Realtek HDA audio matching
`0xf111:000f` or `0xf111:010f`.

Step 8.2 Record: Trigger is common on affected hardware: normal internal
microphone use with input volume above 50%. It is not security-sensitive
and does not require unusual kernel configuration beyond the Realtek HDA
driver.

Step 8.3 Record: Failure mode is bad/clipped microphone capture,
severity MEDIUM. It is not a crash, data corruption, deadlock, or
memory-safety issue, but it materially breaks expected laptop audio
behavior.

Step 8.4 Record: Benefit is high for the affected hardware because it
makes microphone capture usable and adds the second SSID. Risk is very
low: 10-line single-driver quirk, no API changes, no broad behavior
change.

## Phase 9: Final Synthesis
Step 9.1 Record:
- Evidence for backporting: real hardware-specific bug, explicit user-
  visible clipping, new SSID addition, standard stable-acceptable quirk
  pattern, tiny patch, existing helper reused, maintainer applied, clean
  current-tree apply.
- Evidence against backporting: not a crash/security/data-corruption
  fix; affected population is specific new hardware; older trees may
  need path/context adjustments.
- Unresolved: no local runtime test on Framework PTL hardware; exact
  older stable applicability depends on whether those trees have or
  should receive the newer Framework PTL SSIDs.

Step 9.2 Record:
1. Obviously correct and tested? Mostly yes by inspection and maintainer
   acceptance; no `Tested-by` and no local hardware test.
2. Fixes a real bug affecting users? Yes, verified from commit body and
   external report: internal mic clips above 50% volume.
3. Important issue? Medium severity, but stable rules commonly accept
   hardware quirks/device IDs.
4. Small and contained? Yes, one file, 9 insertions/1 deletion.
5. No new features/APIs? Yes, no API or userspace ABI change.
6. Can apply to stable trees? Clean on current/v7.0-style tree; older
   trees need mechanical backport.

Step 9.3 Record: This falls squarely into stable exception categories:
hardware quirk/workaround and device ID/SSID addition for an existing
driver.

Step 9.4 Decision: Backport. Although not a severe kernel stability bug,
stable policy routinely accepts small hardware quirks like this, and the
risk is confined to two Framework SSIDs while the benefit is fixing
broken microphone behavior on affected systems.

## Verification
- Phase 1: Parsed commit `67c73815220784074ff13ec07df955911caf1b73` with
  `git show`; verified tags and absence of `Fixes`, `Reported-by`,
  `Tested-by`, `Reviewed-by`, and stable CC.
- Phase 2: Verified diffstat: `sound/hda/codecs/realtek/alc269.c`, 10
  changed lines, 9 insertions/1 deletion.
- Phase 3: Ran `git blame` on parent commit around enum, fixup table,
  and quirk table; verified `0xf111:000f` came from `bac1e57adf08c9`.
- Phase 3: Ran `git show` on `309d7363ca3d9`, `8903376dc6994`,
  `bac1e57adf08c9`, `7b509910b3ad6`, and related boost quirk commits.
- Phase 4: Ran `b4 dig -c`, `b4 dig -a`, `b4 dig -w`, and `b4 dig -m`;
  verified v1-only patch, original recipients, lore URL, and maintainer
  “Applied now” reply.
- Phase 4: WebFetch of lore/git.kernel direct pages was blocked by
  Anubis, but `b4` successfully fetched the lore thread and Phoronix
  verified the applied commit ID and issue summary.
- Phase 5: Used `rg`/code reads to verify `alc269_probe` selects and
  applies fixups, and that `snd_hda_override_amp_caps` adjusts cached
  amp capabilities.
- Phase 6: Ran `git grep` against `v7.0`, `v6.18`, `v6.17`, `v6.12`, and
  `v6.6` for Framework IDs/helper presence.
- Phase 6: Ran `git apply --check` on the mbox; it applies cleanly to
  the current tree.
- Unverified: no physical Framework PTL hardware test was performed
  locally.

**YES**

 sound/hda/codecs/realtek/alc269.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b1fb5e1cf0078..3a36ae494c39b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -4097,6 +4097,7 @@ enum {
 	ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED,
 	ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED,
 	ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
+	ALC295_FIXUP_FRAMEWORK_LAPTOP_LIMIT_INT_MIC_BOOST,
 	ALC287_FIXUP_LEGION_16ITHG6,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
@@ -6346,6 +6347,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC269_FIXUP_HEADSET_MODE_NO_HP_MIC
 	},
+	[ALC295_FIXUP_FRAMEWORK_LAPTOP_LIMIT_INT_MIC_BOOST] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc269_fixup_limit_int_mic_boost,
+		.chained = true,
+		.chain_id = ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE,
+	},
 	[ALC287_FIXUP_LEGION_16ITHG6] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_legion_16ithg6_speakers,
@@ -7824,7 +7831,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
-	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000f, "Framework Laptop 13 Pro PTL", ALC295_FIXUP_FRAMEWORK_LAPTOP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0xf111, 0x010f, "Framework Laptop 13 PTL", ALC295_FIXUP_FRAMEWORK_LAPTOP_LIMIT_INT_MIC_BOOST),
 
 #if 0
 	/* Below is a quirk table taken from the old code.
-- 
2.53.0

