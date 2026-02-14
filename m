Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBD021CC51;
	Sat, 14 Feb 2026 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031136; cv=none; b=bS0hUoGbFOqgJOjdAhc7IzamC95Z5dAEcfN5npQlSmP0G02H9meVL4MrMObPm9Qgl25dY7/SdIsULKiflDOzRXWkK9zkOSd19Er6m6IqxO0QVPMTstF5uWuvFqEU9Q1ODZ6AqjdP8A2NucDkz/PTc9ZC/Gr15cJOOjyK8O/mHes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031136; c=relaxed/simple;
	bh=Axe+4a3jygazRSNxWdZekxWcW1xs939tL/wHplrQ35Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LGIUzVktBw1ZKBcCA6HzpKCp9ZyaiX1X4y6563ZIFOTGbaS1UZ0HYiqvJF0peB3NuMHIKQFfjxqep3h1fN3s5tVwAB5s4LO7bN8oblwobqMQrRtd1hjpCdZC6KRiTR2edPh1axRnU3K97OYhZfpO67E/RW0HHqD3x/f/oxccgJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OXHG23Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OXHG23Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7A0C116C6;
	Sat, 14 Feb 2026 01:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031136;
	bh=Axe+4a3jygazRSNxWdZekxWcW1xs939tL/wHplrQ35Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXHG23Wlgvc6BM1xXNn7UOEkyYgxXy2oRwddSz3/H7JNnon+/f55CTC2+BrANPclW
	 K0uxqeBPGGkSVt/a2TFw/44Jxl2djZQ20Fx7oVDpEgy1aJZ7q3mDx9fOfwiIEG8b1X
	 4CRCq/wUfJoa2z1tKtC3s/odqYsL7OJCczlh36HNn8s3sSGn1AOTLHaQtRzCv+UoHi
	 VMOVduV0aOazWHqTdzGaRBx6GR8mfr9zQkZMikLuQIe9u2OpwzMit/MRGtr3z7zBWM
	 j1YdzT78G9CtYGKVavvfchEFdSoJQD/z5g8aIrLqUXzlTdfEdL/5/S6maYQWvP103E
	 2eLPF18lrNSNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damien Dagorn <damien.dagorn29@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	sbinding@opensource.cirrus.com,
	kailang@realtek.com,
	chris.chiu@canonical.com
Subject: [PATCH AUTOSEL 6.19-6.12] ALSA: hda/realtek: fix LG Gram Style 14 speakers
Date: Fri, 13 Feb 2026 19:59:16 -0500
Message-ID: <20260214010245.3671907-76-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Damien Dagorn <damien.dagorn29@gmail.com>

[ Upstream commit cc051fbd7f40226cc407558bc97c5099513e8657 ]

The LG Gram Style 14 (14Z90RS-G.AD77F, SSID 1854:0490) with Realtek ALC298
shows normal routing and volume changes, but internal speakers stay silent
unless a userland HDA-verb workaround is applied.

Add a dedicated quirk for the LG Gram Style 14 that programs the codec
coefficient sequence used by the known workaround and enables the speaker
amps only during playback.

Tested-by: Damien Dagorn <damien.dagorn29@gmail.com>
Signed-off-by: Damien Dagorn <damien.dagorn29@gmail.com>
Link: https://lore.kernel.org/CAN59QMUhd4kHrkRoJA6VzEr2VKezN2yjHnANaQoZn2-Bnwe3bQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So `num_speaker_amps` was introduced in v6.12. This means the quirk can
only cleanly backport to 6.12.y stable trees (and newer). Older stable
trees (6.6.y, 6.1.y, 5.15.y) would need the Samsung v2 infrastructure
first, which is a large refactor — not suitable as a dependency for
stable.

### Summary

**What it fixes**: Completely non-functional internal speakers on LG
Gram Style 14 laptop. This is a hardware quirk — the speakers need
specific codec coefficient programming to produce any sound.

**Meets stable rules**:
- Fixes a real bug (no audio from internal speakers)
- Is obviously correct (follows established pattern, tested by reporter,
  accepted by maintainer)
- Is a hardware quirk (explicitly allowed exception)
- Only affects one specific device model
- Zero risk to other hardware

**Risk**: Very low. The quirk is gated on a specific PCI SSID
(0x1854:0x0490). It cannot affect any other device.

**Concerns**:
- The patch is relatively large (~170 lines of new code), though most is
  static data tables
- It depends on `num_speaker_amps` infrastructure from v6.12+, limiting
  which stable trees it can target
- For 6.12.y stable, it should apply cleanly or with minor adjustments
  (the file was recently moved from `sound/pci/hda/patch_realtek.c` to
  `sound/hda/codecs/realtek/alc269.c`)

**Verdict**: This is a textbook audio codec quirk for a specific laptop
model. It makes completely non-functional speakers work. Despite the
code size, the pattern is well-established and the risk is minimal. This
is exactly the type of hardware quirk that belongs in stable.

**YES**

 sound/hda/codecs/realtek/alc269.c | 170 ++++++++++++++++++++++++++++++
 1 file changed, 170 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0924dbf1ed334..527630446631f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1854,6 +1854,163 @@ static void alc298_samsung_v2_init_amps(struct hda_codec *codec,
 	spec->gen.pcm_playback_hook = alc298_samsung_v2_playback_hook;
 }
 
+/* LG Gram Style 14: program vendor coef sequence used by HDA-verb workaround */
+struct alc298_lg_gram_style_seq {
+	unsigned short verb;
+	unsigned short idx;
+	unsigned short val;
+};
+
+static void alc298_lg_gram_style_coef_write(struct hda_codec *codec,
+					    unsigned int verb,
+					    unsigned int idx,
+					    unsigned int val)
+{
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_COEF_INDEX, 0x23);
+	snd_hda_codec_write(codec, 0x20, 0, verb, idx);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_PROC_COEF, 0x00);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_PROC_COEF, val);
+	snd_hda_codec_write(codec, 0x20, 0, AC_VERB_SET_PROC_COEF, 0xb011);
+}
+
+static void alc298_lg_gram_style_run_seq(struct hda_codec *codec,
+					 const struct alc298_lg_gram_style_seq *seq,
+					 int seq_size)
+{
+	int i;
+
+	for (i = 0; i < seq_size; i++)
+		alc298_lg_gram_style_coef_write(codec, seq[i].verb,
+						seq[i].idx, seq[i].val);
+}
+
+/* Coef sequences derived from the HDA-verb workaround for this model. */
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_preinit_seq[] = {
+	{ 0x420, 0x00, 0x01 },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_disable_seq[] = {
+	{ 0x423, 0xff, 0x00 },
+	{ 0x420, 0x3a, 0x80 },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_enable_seq[] = {
+	{ 0x420, 0x3a, 0x81 },
+	{ 0x423, 0xff, 0x01 },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_init_seq_38[] = {
+	{ 0x423, 0xe1, 0x00 }, { 0x420, 0x12, 0x6f }, { 0x420, 0x14, 0x00 },
+	{ 0x420, 0x1b, 0x01 }, { 0x420, 0x1d, 0x01 }, { 0x420, 0x1f, 0xfe },
+	{ 0x420, 0x21, 0x00 }, { 0x420, 0x22, 0x10 }, { 0x420, 0x3d, 0x05 },
+	{ 0x420, 0x3f, 0x03 }, { 0x420, 0x50, 0x2c }, { 0x420, 0x76, 0x0e },
+	{ 0x420, 0x7c, 0x4a }, { 0x420, 0x81, 0x03 }, { 0x423, 0x99, 0x03 },
+	{ 0x423, 0xa4, 0xb5 }, { 0x423, 0xa5, 0x01 }, { 0x423, 0xba, 0x94 },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_init_seq_39[] = {
+	{ 0x423, 0xe1, 0x00 }, { 0x420, 0x12, 0x6f }, { 0x420, 0x14, 0x00 },
+	{ 0x420, 0x1b, 0x02 }, { 0x420, 0x1d, 0x02 }, { 0x420, 0x1f, 0xfd },
+	{ 0x420, 0x21, 0x01 }, { 0x420, 0x22, 0x10 }, { 0x420, 0x3d, 0x05 },
+	{ 0x420, 0x3f, 0x03 }, { 0x420, 0x50, 0x2c }, { 0x420, 0x76, 0x0e },
+	{ 0x420, 0x7c, 0x4a }, { 0x420, 0x81, 0x03 }, { 0x423, 0x99, 0x03 },
+	{ 0x423, 0xa4, 0xb5 }, { 0x423, 0xa5, 0x01 }, { 0x423, 0xba, 0x94 },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_init_seq_3c[] = {
+	{ 0x423, 0xe1, 0x00 }, { 0x420, 0x12, 0x6f }, { 0x420, 0x14, 0x00 },
+	{ 0x420, 0x1b, 0x01 }, { 0x420, 0x1d, 0x01 }, { 0x420, 0x1f, 0xfe },
+	{ 0x420, 0x21, 0x00 }, { 0x420, 0x22, 0x10 }, { 0x420, 0x3d, 0x05 },
+	{ 0x420, 0x3f, 0x03 }, { 0x420, 0x50, 0x2c }, { 0x420, 0x76, 0x0e },
+	{ 0x420, 0x7c, 0x4a }, { 0x420, 0x81, 0x03 }, { 0x423, 0xba, 0x8d },
+};
+
+static const struct alc298_lg_gram_style_seq alc298_lg_gram_style_init_seq_3d[] = {
+	{ 0x423, 0xe1, 0x00 }, { 0x420, 0x12, 0x6f }, { 0x420, 0x14, 0x00 },
+	{ 0x420, 0x1b, 0x02 }, { 0x420, 0x1d, 0x02 }, { 0x420, 0x1f, 0xfd },
+	{ 0x420, 0x21, 0x01 }, { 0x420, 0x22, 0x10 }, { 0x420, 0x3d, 0x05 },
+	{ 0x420, 0x3f, 0x03 }, { 0x420, 0x50, 0x2c }, { 0x420, 0x76, 0x0e },
+	{ 0x420, 0x7c, 0x4a }, { 0x420, 0x81, 0x03 }, { 0x423, 0xba, 0x8d },
+};
+
+struct alc298_lg_gram_style_amp_desc {
+	unsigned char nid;
+	const struct alc298_lg_gram_style_seq *init_seq;
+	int init_seq_size;
+};
+
+static const struct alc298_lg_gram_style_amp_desc alc298_lg_gram_style_amps[] = {
+	{ 0x38, alc298_lg_gram_style_init_seq_38,
+		ARRAY_SIZE(alc298_lg_gram_style_init_seq_38) },
+	{ 0x39, alc298_lg_gram_style_init_seq_39,
+		ARRAY_SIZE(alc298_lg_gram_style_init_seq_39) },
+	{ 0x3c, alc298_lg_gram_style_init_seq_3c,
+		ARRAY_SIZE(alc298_lg_gram_style_init_seq_3c) },
+	{ 0x3d, alc298_lg_gram_style_init_seq_3d,
+		ARRAY_SIZE(alc298_lg_gram_style_init_seq_3d) },
+};
+
+static void alc298_lg_gram_style_enable_amps(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	int i;
+
+	for (i = 0; i < spec->num_speaker_amps; i++) {
+		alc_write_coef_idx(codec, 0x22, alc298_lg_gram_style_amps[i].nid);
+		alc298_lg_gram_style_run_seq(codec,
+					     alc298_lg_gram_style_enable_seq,
+					     ARRAY_SIZE(alc298_lg_gram_style_enable_seq));
+	}
+}
+
+static void alc298_lg_gram_style_disable_amps(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	int i;
+
+	for (i = 0; i < spec->num_speaker_amps; i++) {
+		alc_write_coef_idx(codec, 0x22, alc298_lg_gram_style_amps[i].nid);
+		alc298_lg_gram_style_run_seq(codec,
+					     alc298_lg_gram_style_disable_seq,
+					     ARRAY_SIZE(alc298_lg_gram_style_disable_seq));
+	}
+}
+
+static void alc298_lg_gram_style_playback_hook(struct hda_pcm_stream *hinfo,
+					       struct hda_codec *codec,
+					       struct snd_pcm_substream *substream,
+					       int action)
+{
+	if (action == HDA_GEN_PCM_ACT_OPEN)
+		alc298_lg_gram_style_enable_amps(codec);
+	if (action == HDA_GEN_PCM_ACT_CLOSE)
+		alc298_lg_gram_style_disable_amps(codec);
+}
+
+static void alc298_lg_gram_style_init_amps(struct hda_codec *codec)
+{
+	struct alc_spec *spec = codec->spec;
+	int i;
+
+	spec->num_speaker_amps = ARRAY_SIZE(alc298_lg_gram_style_amps);
+
+	for (i = 0; i < spec->num_speaker_amps; i++) {
+		alc_write_coef_idx(codec, 0x22, alc298_lg_gram_style_amps[i].nid);
+		alc298_lg_gram_style_run_seq(codec,
+					     alc298_lg_gram_style_preinit_seq,
+					     ARRAY_SIZE(alc298_lg_gram_style_preinit_seq));
+		alc298_lg_gram_style_run_seq(codec,
+					     alc298_lg_gram_style_disable_seq,
+					     ARRAY_SIZE(alc298_lg_gram_style_disable_seq));
+		alc298_lg_gram_style_run_seq(codec,
+					     alc298_lg_gram_style_amps[i].init_seq,
+					     alc298_lg_gram_style_amps[i].init_seq_size);
+		alc_write_coef_idx(codec, 0x89, 0x0);
+	}
+
+	spec->gen.pcm_playback_hook = alc298_lg_gram_style_playback_hook;
+}
+
 static void alc298_fixup_samsung_amp_v2_2_amps(struct hda_codec *codec,
 				const struct hda_fixup *fix, int action)
 {
@@ -1868,6 +2025,13 @@ static void alc298_fixup_samsung_amp_v2_4_amps(struct hda_codec *codec,
 		alc298_samsung_v2_init_amps(codec, 4);
 }
 
+static void alc298_fixup_lg_gram_style_14(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	if (action == HDA_FIXUP_ACT_PROBE)
+		alc298_lg_gram_style_init_amps(codec);
+}
+
 static void gpio2_mic_hotkey_event(struct hda_codec *codec,
 				   struct hda_jack_callback *event)
 {
@@ -3764,6 +3928,7 @@ enum {
 	ALC298_FIXUP_SAMSUNG_AMP,
 	ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS,
 	ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS,
+	ALC298_FIXUP_LG_GRAM_STYLE_14,
 	ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET,
 	ALC295_FIXUP_ASUS_MIC_NO_PRESENCE,
@@ -5459,6 +5624,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc298_fixup_samsung_amp_v2_4_amps
 	},
+	[ALC298_FIXUP_LG_GRAM_STYLE_14] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc298_fixup_lg_gram_style_14
+	},
 	[ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET] = {
 		.type = HDA_FIXUP_VERBS,
 		.v.verbs = (const struct hda_verb[]) {
@@ -7404,6 +7573,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1854, 0x0488, "LG gram 16 (16Z90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1854, 0x0489, "LG gram 16 (16Z90R-A)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1854, 0x048a, "LG gram 17 (17ZD90R)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1854, 0x0490, "LG Gram Style 14 (14Z90RS)", ALC298_FIXUP_LG_GRAM_STYLE_14),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),
 	SND_PCI_QUIRK(0x19e5, 0x320f, "Huawei WRT-WX9 ", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x19e5, 0x3212, "Huawei KLV-WX9 ", ALC256_FIXUP_ACER_HEADSET_MIC),
-- 
2.51.0

