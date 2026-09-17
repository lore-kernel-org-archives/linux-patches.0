Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D34E4F93B4;
	Thu, 17 Sep 2026 16:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664308; cv=none; b=fwvIHDCgih+8j/iCvgQAUihKTb0Mn+PQ6VLysAQRIlZJULTENP+wGTZT7+fy83uEgeEBdMJ2mwXctrHWkYuyk7Q0A5XhpHiPiV8pyGbHHcUfxnArOq0bZRWqShujbsiu57xTT8blnC8rIO3EhmJ9hXRhpXqqZPlwbTE7mzZSSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664308; c=relaxed/simple;
	bh=xE5kXkOc5BZDQFY7I1NUw8LJiJfe1YWohr9MfFXxLwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7iUpz3Y7kZRasKyQ/ZbET4D4+CBzCApwPOUnWX9PY7hWFKrxA7gcN7ND8mdjSWwZdnDuI+oOAugBqjxLpD9d6ZGqcCwBfx3vK/HX7mC3xnn8Kx/l61JO00DcU9bAHgJGG1M7lt7y1wCBNShJjs4v8RIfvmMtjGfoa7jV4Kj1g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXLjiHiE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXLjiHiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00F81F000FF;
	Thu, 17 Sep 2026 16:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664306;
	bh=9wvLYdA61ObGY4GToowRFHvNTAHleVIKoKqEbSAMTYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pXLjiHiESGkyIXxjllNfp0kqABaIqwgOMVtTvODD1X3fnMyVeo38erllUQme11bMX
	 y8uFGZZpwfUeY0WjKfp9htdjXgzk/gjYikJAjPpOnALSAbo+x48+1BN+al367q7UtK
	 oVhhKLcPE1U0+l0q1OsVeraNhAtE4KnF955Kfk68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evelyn Ali <evelynali99@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0327/1250] ALSA: hda/realtek: ALC882: Fixup for Clevo P775TM1
Date: Thu, 17 Sep 2026 16:02:02 +0100
Message-ID: <20260917151600.957523738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Evelyn Ali <evelynali99@gmail.com>

[ Upstream commit def5e78a4e003c83adc9a8b4b72534def3a49641 ]

Clevo P775TM1 laptops come with an ESS Sabre HiFi DAC. Setting
0x1b pin VREF to 80% enables said DAC output.

Signed-off-by: Evelyn Ali <evelynali99@gmail.com>
Link: https://patch.msgid.link/20260602214122.78020-1-evelynali99@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc882.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc882.c b/sound/hda/codecs/realtek/alc882.c
index 529fecd5baa0a..fd466b6985f05 100644
--- a/sound/hda/codecs/realtek/alc882.c
+++ b/sound/hda/codecs/realtek/alc882.c
@@ -61,6 +61,7 @@ enum {
 	ALC887_FIXUP_ASUS_HMIC,
 	ALCS1200A_FIXUP_MIC_VREF,
 	ALC888VD_FIXUP_MIC_100VREF,
+	ALC898_FIXUP_CLEVO_P775TM1,
 };
 
 static void alc889_fixup_coef(struct hda_codec *codec,
@@ -236,6 +237,19 @@ static void alc1220_fixup_clevo_pb51ed(struct hda_codec *codec,
 	alc_fixup_headset_mode_no_hp_mic(codec, fix, action);
 }
 
+/* On Clevo P775TM1, VREF of pin 0x1b enables the external headphone amp */
+static void alc898_fixup_clevo_p775tm1(struct hda_codec *codec,
+				       const struct hda_fixup *fix, int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action != HDA_FIXUP_ACT_PRE_PROBE)
+		return;
+
+	snd_hda_set_pin_ctl_cache(codec, 0x1b, PIN_VREF80);
+	spec->gen.keep_vref_in_automute = 1;
+}
+
 static void alc887_asus_hp_automute_hook(struct hda_codec *codec,
 					 struct hda_jack_callback *jack)
 {
@@ -560,6 +574,12 @@ static const struct hda_fixup alc882_fixups[] = {
 			{}
 		}
 	},
+	[ALC898_FIXUP_CLEVO_P775TM1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc898_fixup_clevo_p775tm1,
+		.chained = true,
+		.chain_id = ALC882_FIXUP_EAPD,
+	},
 };
 
 static const struct hda_quirk alc882_fixup_tbl[] = {
@@ -664,6 +684,7 @@ static const struct hda_quirk alc882_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1558, 0x67f1, "Clevo PC70H[PRS]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x67f5, "Clevo PD70PN[NRT]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x70d1, "Clevo PC70[ER][CDF]", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
+	SND_PCI_QUIRK(0x1558, 0x7709, "Clevo P775TM1", ALC898_FIXUP_CLEVO_P775TM1),
 	SND_PCI_QUIRK(0x1558, 0x7714, "Clevo X170SM", ALC1220_FIXUP_CLEVO_PB51ED_PINS),
 	SND_PCI_QUIRK(0x1558, 0x7715, "Clevo X170KM-G", ALC1220_FIXUP_CLEVO_PB51ED),
 	SND_PCI_QUIRK(0x1558, 0x9501, "Clevo P950HR", ALC1220_FIXUP_CLEVO_P950),
@@ -719,6 +740,7 @@ static const struct hda_model_fixup alc882_fixup_models[] = {
 	{.id = ALC1220_FIXUP_GB_DUAL_CODECS, .name = "dual-codecs"},
 	{.id = ALC1220_FIXUP_GB_X570, .name = "gb-x570"},
 	{.id = ALC1220_FIXUP_CLEVO_P950, .name = "clevo-p950"},
+	{.id = ALC898_FIXUP_CLEVO_P775TM1, .name = "clevo-p775tm1"},
 	{}
 };
 
-- 
2.53.0



