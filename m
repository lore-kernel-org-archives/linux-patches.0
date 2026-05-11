Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E40B4EA367;
	Mon, 11 May 2026 22:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778537999; cv=none; b=uBixu81LoZHaCSslhmq3w1WgRk/KcxUZ7F4NquCcVgf9h97CEWY+D26ma3Q/jLcTrQOOTtfRqsX352Ql+s9/BycFsXJyASoeMQQ/TWcBpOe7bf/IhNP5ROkgkpzjSjaIutANZWpP1bvagzpScSaHbHhDaZXSpb5MvL71qMksiJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778537999; c=relaxed/simple;
	bh=8T+mzpS+RN4Iph1BRrjfvkvnz0Qw2rzuU+YFeg4esqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxBbrkkKjlCdSoqQi1kcEoKqx27u7MkiOQqgbLmwOgtVI6PEhTuSnaWfoMwrk2v1QPUgRzsJT84zBWtajZW6/aX2Pq7ufXcf9HhVoGd3Z7CLly7RF3fuWru+v5UTunoTTlrvNI0FUzKWm5AHHxFoNHKmcKRe/LuULTY0spnUm7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfC/av+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfC/av+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ADEFC2BCFA;
	Mon, 11 May 2026 22:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778537999;
	bh=8T+mzpS+RN4Iph1BRrjfvkvnz0Qw2rzuU+YFeg4esqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bfC/av+VXtu4BsE9ZZJedA9x7k53U86SytVmnociD5/u/EoghHEpSZBoAT3orroZ6
	 5OjLggizV4V/BLefoJwImZ9gFByYFRI9C8nlH7Z1AwYSHp6nlrJN2hG57M4xvn5duS
	 X2elU9BFqztEt4bdT3iiw1BoyGuyL/Vo+Tap1x5w74jnAVyJGgs5pFAx6tmLiB4aJ3
	 w4AS29zVSD8hOxFp9Kqg7CcbcdsjLzGA1SDCJEWC50t3kGfPobs++Gaz0RIxhgpKaz
	 47O1FVbVD4oX1v5e4cZGWFF+/rebmqh9Goc8BchDhOwp/b6z8x8n0sT9ik1+c+hgjk
	 RearWQ3nuy8+w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Rodrigo Faria <rodrigofilipefaria@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] ALSA: hda/realtek: Add mute LED fixup for HP Pavilion 15-cs1xxx
Date: Mon, 11 May 2026 18:19:17 -0400
Message-ID: <20260511221931.2370053-18-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511221931.2370053-1-sashal@kernel.org>
References: <20260511221931.2370053-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Faria <rodrigofilipefaria@gmail.com>

[ Upstream commit 01801e20d69346e1e6cec0d908f1cea3a49e51b5 ]

Add a new fixup for the mute LED on the HP Pavilion 15-cs1xxx series
using the VREF on NID 0x1b.

The BIOS on these models (tested up to F.32) incorrectly reports
the mute LED on NID 0x18 via DMI OEM strings, which lacks VREF
capabilities. This fixup overrides the LED pin to the correct
NID 0x1b.

Signed-off-by: Rodrigo Faria <rodrigofilipefaria@gmail.com>
Link: https://patch.msgid.link/20260505185518.23625-1-rodrigofilipefaria@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Decision Summary
This should be backported. It is a small, model-specific ALSA HDA
Realtek hardware workaround for an HP Pavilion 15-cs1xxx BIOS quirk: the
BIOS reports the mute LED on NID `0x18`, but that pin lacks VREF
capability; the patch routes the existing HP VREF mute-LED handling to
NID `0x1b`. It affects only systems matching PCI SSID `103c:856a`.

## Phase Walkthrough
### Phase 1: Commit Message Forensics
Record: Subsystem is `ALSA: hda/realtek`; action is `Add`; intent is
adding a mute LED fixup for HP Pavilion 15-cs1xxx.

Record: Tags present: `Signed-off-by: Rodrigo Faria
<rodrigofilipefaria@gmail.com>`, `Link: https://patch.msgid.link/2026050
5185518.23625-1-rodrigofilipefaria@gmail.com`, `Signed-off-by: Takashi
Iwai <tiwai@suse.de>`. No `Fixes:`, `Reported-by:`, `Tested-by:`,
`Reviewed-by`, or `Cc: stable`.

Record: Bug described is incorrect BIOS/DMI OEM mute LED pin reporting.
Symptom is mute LED control using the wrong NID, so the mute LED does
not work correctly on this model. Version info: BIOS tested up to F.32.
Root cause: reported NID `0x18` lacks VREF capability; correct NID is
`0x1b`.

Record: This is a hardware quirk/fixup, not a hidden memory-safety bug.
It fixes incorrect hardware description/firmware behavior.

### Phase 2: Diff Analysis
Record: One file changed: `sound/hda/codecs/realtek/alc269.c`, 21
insertions, no removals. Modified areas: new helper
`alc295_fixup_hp_pavilion_mute_led_1b`, enum entry, fixup table entry,
PCI SSID quirk entry. Scope: single-file, surgical driver quirk.

Record: Before: HP vendor/DMI mute LED handling could derive the wrong
LED NID from BIOS OEM string. After: for PCI SSID `103c:856a`, the
driver selects a dedicated fixup that calls existing
`alc269_fixup_hp_mute_led()` and then overrides `spec->mute_led_nid =
0x1b`.

Record: Bug category is hardware workaround / quirk. Specific mechanism:
reuse existing VREF mute LED cdev setup, but force the pin to the
verified VREF-capable NID.

Record: Fix quality is good: small, contained, uses existing Realtek HDA
LED infrastructure, only selected for one HP subsystem ID. Regression
risk is very low and limited to that model.

### Phase 3: Git History Investigation
Record: Local exact-subject `git log` found no commit hash in this
checkout, so `b4 dig -c <hash>` could not be run against the target
commit. The patch was analyzed by message-id instead.

Record: `git blame` on nearby current-tree lines shows this repository’s
Realtek split file was imported through a grafted/snapshot-style commit,
so blame was not useful for the original upstream introduction of the
generic HP LED code.

Record: Related local history contains similar model-specific HP
Pavilion mute LED quirk commits: `2f388b4e8fdd6`, `068641bc9dc3d`, and
`ab2be3af8c4ea`, each one-line Pavilion mute LED quirk additions.

Record: Author history for Rodrigo Faria in this file returned no local
commits. Maintainer handling was verified from the mailing-list thread:
Takashi Iwai replied “Applied now.”

Record: Dependencies: no hard functional dependency beyond existing
Realtek HDA HP mute LED infrastructure. That infrastructure exists in
checked stable tags, though older trees use
`sound/pci/hda/patch_realtek.c` and may need manual path/context
backporting.

### Phase 4: Mailing List And External Research
Record: `b4 am` by message-id found `[PATCH v3] ALSA: hda/realtek: Add
mute LED fixup for HP Pavilion 15-cs1xxx`, 1 patch, 2 messages in
thread, DKIM-signed.

Record: Full thread shows the patch was sent to Takashi Iwai, Jaroslav
Kysela, `linux-sound`, and `linux-kernel`; Takashi replied “Applied
now.” No NAKs, objections, or stable nomination were found in the
fetched thread.

Record: `b4 am -v 2` could not find revision 2 from this message-id; web
searches also did not locate earlier cs1xxx revisions. The subject says
v3, but earlier revision discussion remains unverified.

Record: External search found public evidence of HP Pavilion 15-cs-
series systems using ALC295 audio, but no separate cs1xxx-specific bug
report was found.

Record: Stable-list searches found no cs1xxx-specific stable discussion,
but did find similar ALSA Realtek HP Pavilion mute LED quirks appearing
in stable discussion/results.

### Phase 5: Code Semantic Analysis
Record: Modified/added key function:
`alc295_fixup_hp_pavilion_mute_led_1b`.

Record: Callers: the new function is referenced from `alc269_fixups[]`;
that fixup is selected by `snd_hda_pick_fixup()` during Realtek codec
probe, using the PCI SSID quirk table. This is device
probe/configuration path, not a syscall hot path.

Record: Callees: `alc269_fixup_hp_mute_led()` scans HP DMI OEM strings,
sets LED polarity/NID, registers the mute LED cdev through
`snd_hda_gen_add_mute_led_cdev()`, and installs `led_power_filter`. The
new helper then overrides `spec->mute_led_nid`.

Record: Reachability: affected path is reachable during HDA codec probe
on matching HP hardware and later through the LED audio mute
trigger/cdev callback.

Record: Similar patterns: many existing HP Realtek quirks use
`ALC269_FIXUP_HP_MUTE_LED_MIC3`, `ALC295_FIXUP_HP_MUTE_LED_COEFBIT11`,
and related model-specific entries.

### Phase 6: Stable Tree Analysis
Record: Checked tags `v6.19`, `v6.18`, `v6.17`, `v6.16`, `v6.12`, and
`v6.6` exist locally.

Record: `v6.19` and `v6.18` use `sound/hda/codecs/realtek/alc269.c`;
`v6.6` uses older `sound/pci/hda/patch_realtek.c`.

Record: Generic HP VREF mute LED infrastructure exists in `v6.6` and
newer checked tags. `ALC295_FIXUP_HP_MUTE_LED_COEFBIT11` exists in
`v6.16+`, but not in `v6.12`/`v6.6`; the new fixup itself does not
depend on that helper, only on nearby placement/context.

Record: `git apply --check` succeeds on current `7.0.5` checkout. It
fails on a temporary `v6.18` worktree due to context drift, so stable
backports likely need minor manual adjustment. Older stable trees need
path adjustment to `sound/pci/hda/patch_realtek.c`.

### Phase 7: Subsystem And Maintainer Context
Record: Subsystem is ALSA HDA Realtek codec driver under sound.
Criticality: peripheral/driver-specific, affecting HP Pavilion 15-cs1xxx
users.

Record: The file is actively maintained and frequently receives model-
specific quirks. Recent local history includes multiple ALSA Realtek
HP/Lenovo/ASUS/Samsung quirk commits.

### Phase 8: Impact And Risk
Record: Affected users are specific to HP Pavilion 15-cs1xxx / PCI SSID
`103c:856a` with Realtek ALC295-class HDA audio.

Record: Trigger condition is normal codec probe and mute LED operation
on that hardware. No evidence found that unprivileged users can trigger
a crash or security issue; the user-visible effect is
incorrect/nonfunctional mute LED.

Record: Failure severity is LOW to MEDIUM: not a crash or data
corruption issue, but a real hardware functionality regression/quirk.

Record: Benefit is medium for affected users because it restores correct
mute LED behavior. Risk is very low because the quirk is model-specific
and uses existing LED control paths.

### Phase 9: Final Synthesis
Record: Evidence for backporting: hardware quirk category, fixes real
BIOS misreporting, limited to one PCI SSID, small patch, uses
established ALSA Realtek fixup patterns, accepted by ALSA maintainer,
and similar HP mute LED quirks are common stable material.

Record: Evidence against backporting: no crash/security/data corruption;
no explicit stable tag; current patch does not apply cleanly to at least
`v6.18` without minor context adjustment; older trees need file-
path/context adjustment.

Record: Stable rules: obviously correct enough by inspection; fixes a
real hardware bug; small and contained; no new public API; no new
feature beyond hardware-specific workaround; stable application may
require minor backport edits.

Record: Exception category applies: hardware-specific quirk/workaround
in an existing driver.

## Verification
- [Phase 1] Parsed subject, body, and tags from supplied commit message
  and fetched mbox.
- [Phase 2] Verified patch is 21 insertions in
  `sound/hda/codecs/realtek/alc269.c`.
- [Phase 3] Ran local `git log` by exact subject: no matching commit
  hash found.
- [Phase 3] Ran `git blame` around affected code: local history is
  snapshot/grafted, limiting original-introduction analysis.
- [Phase 4] Ran `b4 am` by message-id: found v3 patch, 2-message thread,
  DKIM-signed.
- [Phase 4] Read full mbox: Takashi Iwai replied “Applied now”; no
  objections found.
- [Phase 5] Traced quirk selection through `snd_hda_pick_fixup()` and
  Realtek probe path.
- [Phase 6] Checked stable tags and paths: `v6.18+` split path, `v6.6`
  old `patch_realtek.c` path.
- [Phase 6] Checked relevant symbols in stable tags: HP VREF LED
  infrastructure exists in checked stable trees.
- [Phase 6] Ran `git apply --check`: applies to current checkout, not
  cleanly to `v6.18` due context drift.
- [Phase 8] Verified failure mode from commit body and code: wrong LED
  NID affects mute LED behavior, not memory safety.
- UNVERIFIED: exact applied upstream commit SHA, because it was not
  present in local `git log`.
- UNVERIFIED: earlier v1/v2 review discussion, because `b4` and web
  search did not locate those revisions.
- UNVERIFIED: exact applicability to every active older LTS tree beyond
  the checked tags.

**YES**

 sound/hda/codecs/realtek/alc269.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 29dafa3f1d15a..9daf7a12bf95d 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1676,6 +1676,21 @@ static void alc295_fixup_hp_mute_led_coefbit11(struct hda_codec *codec,
 	}
 }
 
+/* Override wrong pin to NID 0x1b (F.32 BIOS reports 0x18 via DMI OEM string)
+ * on HP pavilion 15-cs1xxx laptops
+ */
+static void alc295_fixup_hp_pavilion_mute_led_1b(struct hda_codec *codec,
+						 const struct hda_fixup *fix,
+						 int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	alc269_fixup_hp_mute_led(codec, fix, action);
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE)
+		spec->mute_led_nid = 0x1b;
+}
+
 static void alc233_fixup_lenovo_coef_micmute_led(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -3859,6 +3874,7 @@ enum {
 	ALC290_FIXUP_SUBWOOFER,
 	ALC290_FIXUP_SUBWOOFER_HSJACK,
 	ALC295_FIXUP_HP_MUTE_LED_COEFBIT11,
+	ALC295_FIXUP_HP_PAVILION_MUTE_LED_1B,
 	ALC269_FIXUP_THINKPAD_ACPI,
 	ALC269_FIXUP_LENOVO_XPAD_ACPI,
 	ALC269_FIXUP_DMIC_THINKPAD_ACPI,
@@ -5701,6 +5717,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc295_fixup_hp_mute_led_coefbit11,
 	},
+	[ALC295_FIXUP_HP_PAVILION_MUTE_LED_1B] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_hp_pavilion_mute_led_1b,
+	},
 	[ALC298_FIXUP_SAMSUNG_AMP] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_samsung_amp,
@@ -6894,6 +6914,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8537, "HP ProBook 440 G6", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8548, "HP EliteBook x360 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x856a, "HP Pavilion 15-cs1xxx", ALC295_FIXUP_HP_PAVILION_MUTE_LED_1B),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x8603, "HP Omen 17-cb0xxx", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.53.0

