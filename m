Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F72F220F20;
	Tue,  6 May 2025 21:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746567451; cv=none; b=j39u9RbE8v7DobgezmVemMDuGXJRigUmgBuN14CQiBvtvmvOVOcCubOLQ0+nTu/xuh8Xl5ssVqwGqmRU+8XPpyPX5FeKyGKRL8TaOHHD0pc4BvKBdBl4TAoew/keCVVf45qje7qoUlVoZq03sGiN73vA9Xvi1hoE8g0qOM9hx/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746567451; c=relaxed/simple;
	bh=u62ORxP0NWy3hvYC+34xnC6CSweLNnDMCzbozUAyfuQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nEO1FCIOaP6BArjJjSeLyW8o67NoKP6v3OEMZPyp1AhX0JcIhqmpB8k6oX9ffMI1OUYj2tG141RCWCGuqb1dkpgXejhH+LdYQGQMjbAppmwtNPacWuk0r9R2x717uAceiwY3k5ZvS/TxSUg+cvpedyXr6YAuz7bufdgLdvOZg2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRA8APp8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRA8APp8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CECC4CEE4;
	Tue,  6 May 2025 21:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746567450;
	bh=u62ORxP0NWy3hvYC+34xnC6CSweLNnDMCzbozUAyfuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRA8APp8FU0AnHn6l309JPNVSX+GPgXLuhcFDqckMyju/zWd8yVzmVyBnBD8CaQF/
	 GClOoleAaeF3n/6i28Fo+O1xQP8w2+PRa1rfgBBzaVoen//I/hG8pl69bwF63ATaia
	 G064vX30FEgUzdvVGKwvQnOBriUEimhOxx2Xeg3KsbRVWD6Ez4rPD0+i7a1znt2Jw5
	 CNaXVIs8PbUUmKjzJitK7l7no1CetfEZTJ0bZJgbuasiEP2A5S0o/lK+cGQBua1hTK
	 e2yae0+uwyZB9hr/OUAa0Z9GAtvjT3hXSVzohxjOfNQhnpVMGAkCGrxbUyKDtQjJDM
	 XyQ813BW7wWqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>,
	perex@perex.cz,
	tiwai@suse.com,
	kailang@realtek.com,
	sbinding@opensource.cirrus.com,
	simont@opensource.cirrus.com,
	josh@joshuagrisham.com,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 4/6] ALSA: hda/realtek: Add quirk for HP Spectre x360 15-df1xxx
Date: Tue,  6 May 2025 17:37:12 -0400
Message-Id: <20250506213714.2983569-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250506213714.2983569-1-sashal@kernel.org>
References: <20250506213714.2983569-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.137
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit be0c40da888840fe91b45474cb70779e6cbaf7ca ]

HP Spectre x360 15-df1xxx with SSID 13c:863e requires similar
workarounds that were applied to another HP Spectre x360 models;
it has a mute LED only, no micmute LEDs, and needs the speaker GPIO
seup.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220054
Link: https://patch.msgid.link/20250427081035.11567-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 42 +++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 61b48f2418bf0..0c7000265a92e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6786,6 +6786,41 @@ static void alc285_fixup_hp_spectre_x360_eb1(struct hda_codec *codec,
 	}
 }
 
+/* GPIO1 = amplifier on/off */
+static void alc285_fixup_hp_spectre_x360_df1(struct hda_codec *codec,
+					     const struct hda_fixup *fix,
+					     int action)
+{
+	struct alc_spec *spec = codec->spec;
+	static const hda_nid_t conn[] = { 0x02 };
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170110 },  /* front/high speakers */
+		{ 0x17, 0x90170130 },  /* back/bass speakers */
+		{ }
+	};
+
+	// enable mute led
+	alc285_fixup_hp_mute_led_coefbit(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		/* needed for amp of back speakers */
+		spec->gpio_mask |= 0x01;
+		spec->gpio_dir |= 0x01;
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		/* share DAC to have unified volume control */
+		snd_hda_override_conn_list(codec, 0x14, ARRAY_SIZE(conn), conn);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		break;
+	case HDA_FIXUP_ACT_INIT:
+		/* need to toggle GPIO to enable the amp of back speakers */
+		alc_update_gpio_data(codec, 0x01, true);
+		msleep(100);
+		alc_update_gpio_data(codec, 0x01, false);
+		break;
+	}
+}
+
 static void alc285_fixup_hp_spectre_x360(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
@@ -7301,6 +7336,7 @@ enum {
 	ALC280_FIXUP_HP_9480M,
 	ALC245_FIXUP_HP_X360_AMP,
 	ALC285_FIXUP_HP_SPECTRE_X360_EB1,
+	ALC285_FIXUP_HP_SPECTRE_X360_DF1,
 	ALC285_FIXUP_HP_ENVY_X360,
 	ALC288_FIXUP_DELL_HEADSET_MODE,
 	ALC288_FIXUP_DELL1_MIC_NO_PRESENCE,
@@ -9290,6 +9326,10 @@ static const struct hda_fixup alc269_fixups[] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_spectre_x360_eb1
 	},
+	[ALC285_FIXUP_HP_SPECTRE_X360_DF1] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc285_fixup_hp_spectre_x360_df1
+	},
 	[ALC285_FIXUP_HP_ENVY_X360] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_hp_envy_x360,
@@ -9850,6 +9890,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
+	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x86f9, "HP Spectre x360 13-aw0xxx", ALC285_FIXUP_HP_SPECTRE_X360_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8716, "HP Elite Dragonfly G2 Notebook PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
@@ -10559,6 +10600,7 @@ static const struct hda_model_fixup alc269_fixup_models[] = {
 	{.id = ALC295_FIXUP_HP_OMEN, .name = "alc295-hp-omen"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360, .name = "alc285-hp-spectre-x360"},
 	{.id = ALC285_FIXUP_HP_SPECTRE_X360_EB1, .name = "alc285-hp-spectre-x360-eb1"},
+	{.id = ALC285_FIXUP_HP_SPECTRE_X360_DF1, .name = "alc285-hp-spectre-x360-df1"},
 	{.id = ALC285_FIXUP_HP_ENVY_X360, .name = "alc285-hp-envy-x360"},
 	{.id = ALC287_FIXUP_IDEAPAD_BASS_SPK_AMP, .name = "alc287-ideapad-bass-spk-amp"},
 	{.id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN, .name = "alc287-yoga9-bass-spk-pin"},
-- 
2.39.5

