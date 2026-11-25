Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622720;
	b=FYIWA+KXx27pHKAOuAsAOC0gCcVIvz4uWBleAAq20G91UXDQ6FjZ9ree2bxij3gJ8VrG
	 Qws1AkswIJVoB8flkGaiiHuBo9K9GvGPZofi+25D4Kwe7R2/XuvE4IPyQAl+q++frusRU
	 OmHRO4cWx5HtHr46l81pI9EhWdh8jWaJVxpxQVS48dK+hfs7kOEx40J8MeF1C0C7GdHfz
	 ac7FwZRMfkuoWYiL9gD+pdZTjgmTVOp0P/NgcQy+DFmyb4BJCx2a+ctYLjyIZrnq0yASn
	 AtkusZqqE96+09cQtyWApmxysSnNq1T2L+5AnzCNzy1BCwtK5DeJHFzeG7dPvYMuswQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622720;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dNMUfafYeqRvAeThKR6NP02zq/ivmnUUKQw7vAMF2M0=;
	b=xZmVzy9pbC0zDW1l4x8uBJExdabjPRfk93w/Uyz+sHqQVwl5NRWLtyUhIGbTOJPLXpCS
	 mfGYV4wnugx6eD0Vj1J5ZTOYlnTrsLkPkRQp+wSWzLxzGLoB8ZiNYlHMvzPrD8F1t1Uaq
	 jOYZKp02HzTWmVrWhWeuMP53FFzck+twGOIke5DtA1E3VC7aYaG9hBKmlrK1pbx++/lxr
	 RB0qsWcWowniZZhWH8BSdw+/7jSHpQ7Bjff8b3wYk0P2ZboaY86H74ZxmLiKaHu5MIzWM
	 lp9nfT1dR3G8ppJ7wmR4TeSc2W4opbanqgGJPk2tEGTo+YFmDCWur/b4eje6H5PiA+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AacHwEaT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725B5606A31E;
	Wed, 25 Nov 2026 16:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AacHwEaT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A4EF1F000C0;
	Wed, 25 Nov 2026 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622719;
	bh=dNMUfafYeqRvAeThKR6NP02zq/ivmnUUKQw7vAMF2M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AacHwEaTE/48kAofFoHQLW0gYA2I+D28e2EaxxYNNU6SFdh/Wrp+fJ4B2eYzkUVxD
	 hAji+mnvW1NribR3Kx8rry+mb0LHRuToYwp5TDhz3I+iN1onzTxqOfXwj0mbjqOb7t
	 vD9SwCiiJBysabFoQms/eaU+CptxcBTvep8gBE6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajanesh Lal <ajaneshlal3@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 625/990] ALSA: hda/realtek: Add mute and mic-mute LEDs for HP ENVY 16 (103c:8be5)
Date: Wed, 25 Nov 2026 15:33:12 +0100
Message-ID: <20261125143836.739603379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ajanesh Lal <ajaneshlal3@gmail.com>

[ Upstream commit ed7995e4ec3789a90e37eb826bfccf43cc85d2fd ]

The HP ENVY Laptop 16-h1xxx (PCI SSID 103c:8be5) uses an ALC245 codec
with CS35L41 I2C speaker amplifiers. No LED fixup is applied for this
subsystem ID, so the speaker mute LED and the microphone mute LED are
never driven and do not follow their keys.

Add a fixup that calls the existing ALC245 mute LED COEF helper and the
GPIO mic-mute LED helper directly, then chains to the CS35L41 I2C
amplifier setup so the speakers keep working. Use it for 103c:8be5.

Tested on an HP ENVY Laptop 16-h1xxx running kernel 7.2.11: the
hda::mute and hda::micmute LEDs appear and follow their keys, and the
speaker amplifiers still bind (CS35L41 Bound in dmesg). The mic LED
GPIO pin and polarity are not verified on other hardware.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Assisted-by: Claude:claude-haiku-5-5
Signed-off-by: Ajanesh Lal <ajaneshlal3@gmail.com>
Link: https://patch.msgid.link/20261021142453.177174-1-ajaneshlal3@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Added the new enum value and fixup table entry after the tree's last entries, since the context entries the upstream patch anchors on are missing, and left out the unneeded ALC245_FIXUP_CS35L41_I2C_2_MUTE_LED additions. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 6ee95ae0e8f67..dbc7b56f4d42b 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -1585,6 +1585,14 @@ static void alc245_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
 	}
 }
 
+/* mute LED via COEF bit and mic-mute LED via GPIO, called directly */
+static void alc245_fixup_cs35l41_mute_micmute(struct hda_codec *codec,
+					      const struct hda_fixup *fix, int action)
+{
+	alc245_fixup_hp_mute_led_coefbit(codec, fix, action);
+	alc245_fixup_hp_gpio_led(codec, fix, action);
+}
+
 static void alc245_fixup_hp_mute_led_v1_coefbit(struct hda_codec *codec,
 					  const struct hda_fixup *fix,
 					  int action)
@@ -4045,6 +4053,7 @@ enum {
 	ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK,
 	ALC256_FIXUP_VAIO_RPL_MIC_NO_PRESENCE,
 	ALC245_FIXUP_ACER_MICMUTE_LED,
+	ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -6668,6 +6677,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.v.func = alc285_fixup_hp_coef_micmute_led,
 		.chained = true,
 		.chain_id = ALC2XX_FIXUP_HEADSET_MIC,
+	},
+	[ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_cs35l41_mute_micmute,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
 	}
 };
 
@@ -7103,7 +7118,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be1, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be2, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be3, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8be5, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8be5, "HP Envy 16", ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8be6, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be7, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
-- 
2.53.0



