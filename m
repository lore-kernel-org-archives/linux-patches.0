Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFEED2571BD;
	Thu, 17 Apr 2025 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915925; cv=none; b=SqROwy9/bmeQ2D3jim4an71fhYLxSE+QOQJFBkr+nA4e/YBsCfSyW35jvXsQLWUZQFl8WvXBPryUnQr8Ki4eLYUgOsb/ceY706OAjYzXyaYK3MA+J+OLi7cmLu0TIxGutnLLfRHiFNSXJno9crecm7wFlQloYbI9uY2B9E2IaOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915925; c=relaxed/simple;
	bh=ApsQm/fCTTzw/aJC2vU+b/In+LtVyujkbGVsaK5sNe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9p/OVwDeBXPLXrzYGUzTl0CEn5jmJ0zaBPzBgppS5eTxxC7zkXbvQEdiLKFeE2kYwgLYumP3zS09sqO+NMOM5EUa/wXBtO+n3hEYBvV8qKSVXXQUSWPXsKOgOoe554Q05DxbY9WYW7VvJJlZjulLfHPpF8yAkNOa63TakmHTEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+ieQXtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+ieQXtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57650C4CEE4;
	Thu, 17 Apr 2025 18:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915924;
	bh=ApsQm/fCTTzw/aJC2vU+b/In+LtVyujkbGVsaK5sNe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+ieQXtBGQJjXMnOmtqBYeAXiBpV5ZCR09YThQtij0OOgviT3djLTxdocM/abSaR0
	 yH1Oqgdor9S0Jg1X5ycvaMeIkHnCbnsZI0wD3BSngLYQtWutVaxeoRP6Z/GoamAAN+
	 jgJI+tSzUvjneyIOe9jKXO2xrSq+mC29hgCIGLwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sharan Kumar M <sharweshraajan@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 256/393] ALSA: hda/realtek: Enable Mute LED on HP OMEN 16 Laptop xd000xx
Date: Thu, 17 Apr 2025 19:51:05 +0200
Message-ID: <20250417175117.891158860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sharan Kumar M <sharweshraajan@gmail.com>

commit e5182305a5199246dbcb4053299dcb1c8867b6ff upstream.

This patch adds the HP OMEN 16 Laptop xd000xx to enable mute led.
it uses ALC245_FIXUP_HP_MUTE_LED_COEFBIT with a slight modification
setting mute_led_coef.off to 0(it was set to 4 i guess
in that function) which i referred to your previous patch disscusion
https://bugzilla.kernel.org/show_bug.cgi?id=214735 .
i am not sure whether i can modify the current working function so i
added another version calling
ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT. and both works for me.

Tested on 6.13.4-arch1-1 to 6.14.0-arch1-1

Signed-off-by: Sharan Kumar M <sharweshraajan@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250329154105.7618-2-sharweshraajan@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4744,6 +4744,22 @@ static void alc245_fixup_hp_mute_led_coe
 	}
 }
 
+static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
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
@@ -7851,6 +7867,7 @@ enum {
 	ALC287_FIXUP_TAS2781_I2C,
 	ALC287_FIXUP_YOGA7_14ARB7_I2C,
 	ALC245_FIXUP_HP_MUTE_LED_COEFBIT,
+	ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT,
 	ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	ALC287_FIXUP_THINKPAD_I2S_SPK,
 	ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD,
@@ -10084,6 +10101,10 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
 	},
+	[ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_hp_mute_led_v1_coefbit,
+	},
 	[ALC245_FIXUP_HP_X360_MUTE_LEDS] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc245_fixup_hp_mute_led_coefbit,
@@ -10569,6 +10590,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8b97, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8bb3, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bb4, "HP Slim OMEN", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bdf, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


