Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D2B340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301028; cv=none; b=YXNrJzrERLWiFDG92Iojk7/ARmghjmHaZN6DEveu+s2T6WHProSs9JxHmS58dk31aqLseEQre56izo2kPSTcYWi2HNRxk5UsvUGe2DQ+vfO8YdTwJFpycW3OGpv5jIFNwVHU7B2TKdPo23Vvy1UOCc2pZw1kBjPz0LhZw7zxd1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301028; c=relaxed/simple;
	bh=UeL6fIzlbYxXddLGq+fpqzzRKWjdrEa6cp6be5Y5Qq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nw30SvohlZl1SJG+PmhsTFNweQjbAwl5lWDbJNTVCTjRq39itI02R3/pgLt09/dfylML7+c26XXNlRnyEFm/gnDRRo34bnFWp2V46FbOMnlCppajXw0ZI5xLI1OJqszhd7JTQcdDoamxig8TleT2P3JJEaXa+BPU75nEKjASTak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oTDTrfyO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oTDTrfyO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A01C116D0;
	Sat, 28 Feb 2026 17:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301027;
	bh=UeL6fIzlbYxXddLGq+fpqzzRKWjdrEa6cp6be5Y5Qq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTDTrfyOeka7A6+eV3znPaGo3bOujS+r7V+hcxTM7v0GLiTjNgyMHtvhQkkkJfo/k
	 pG+szxkrr+ZrQBJe9DsoTQZmuUPmpw053ExOY6aSTiAxab5fsRadHLOwhUjh2Xcdvg
	 8Tuk05P1FVhQh2NNcToV/qhLMRWbtnnAH4IzeaKEMKi7BsgQpPom30RkWPP3JkhJVF
	 SSshmTTD7WZ3zH/J8MUm6Y+EtH7311nAdjRK4ANm5JzJrLppaZPeMHLSzg29Hq3C11
	 bF+8lSTEjqe8/UTcsAIIMbigL/2hPyMzGmyslt3VhveqHDqmZrB5H9pyM3llrurJSU
	 j3+prx2PASdWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bharat Dev Burman <bharat.singh7924@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/752] ALSA: hda/realtek: add HP Victus 16-e0xxx mute LED quirk
Date: Sat, 28 Feb 2026 12:37:56 -0500
Message-ID: <20260228174750.1542406-165-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bharat Dev Burman <bharat.singh7924@gmail.com>

[ Upstream commit 72919c57a055f6d7b79d66731dc398e9b433f47c ]

HP Victus 16-e0xxx with ALC245 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x88eb using a new
ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT fixup, enabling correct mute LED
behavior.

Signed-off-by: Bharat Dev Burman <bharat.singh7924@gmail.com>
Link: https://patch.msgid.link/20260112184253.33376-1-bharat.singh7924@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 66da4584aa7a5..48edf55621854 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1551,6 +1551,22 @@ static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
 	}
 }
 
+static void alc245_fixup_hp_mute_led_v2_coefbit(struct hda_codec *codec,
+					  const struct hda_fixup *fix,
+					  int action)
+{
+	struct alc_spec *spec = codec->spec;
+
+	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+		spec->mute_led_polarity = 0;
+		spec->mute_led_coef.idx = 0x0b;
+		spec->mute_led_coef.mask = 1 << 3;
+		spec->mute_led_coef.on = 1 << 3;
+		spec->mute_led_coef.off = 0;
+		snd_hda_gen_add_mute_led_cdev(codec, coef_mute_led_set);
+	}
+}
+
 /* turn on/off mic-mute LED per capture hook by coef bit */
 static int coef_micmute_led_set(struct led_classdev *led_cdev,
 				enum led_brightness brightness)
@@ -3719,6 +3735,7 @@ enum {
 	ALC287_FIXUP_YOGA7_14ARB7_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
 	ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT,
+	ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
@@ -6047,6 +6064,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_v1_coefbit,
 	},
+	[ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_v2_coefbit,
+	},
 	[ALC245_FIXUP_HP_X360_MUTE_LEDS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
@@ -6520,6 +6541,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8898, "HP EliteBook 845 G8 Notebook PC", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.51.0

