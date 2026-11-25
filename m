Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625485;
	b=L9RtNJdQernHqy9NPXvBHlCic0tBlAd5Sg4HVdClYrcheWFvTClndjJgU2C2iIA8NbKZ
	 vY2ow0H11ON4E2GZiWXSWAcUGiz768J44no2D2S9wCAY7lmSNZ3A0UHhNQn3qp8EamPOC
	 gGTj33aqfspywbeBKebQ2CIgrD3UPy8oWmgTxMw6yt1ER/SjLiVDPI/i6Nh8ZftHJqPal
	 fSJVIbn1NQxhsBR8ULTV4k+p7pZPBvc/zphYD3b/lPsP5hTJyP4cGBYpkuB/e6D4Uxygb
	 G9/Yx8p/OvqFJX8oYzac8JHvfVojSmK3cOBpuPxQg0UFoqomRfqh8Amw2eScikfUEuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PuuDka8Nep/VETAnbrMdZKBJ4tsSs7SWMqR//WByA2g=;
	b=gT/JW+ND55bvemyuwWp6HyY1gqSc8VG+BL1zcYXvsTvUopf8lrPeQN1YSFVzVgWpKXhB
	 +MeghR1wbZARCUWxo1lGTG0+QE4KT5w75QPM613iicfago8+b7dFVlWpvo0rvqvPZbo/7
	 jlDNFkwedzlI3I3Du6E6BBSJZCBkSmLEi6NE6NiDlgXcD+zg5qx5JI+iWr53mpG2QYwBo
	 H6gSbDnhw7XzFfW3TR0h19BoUdbaDtGWiCfIfQDbUH2IgKXzzqYDy9g/idCF4aNTWSwdi
	 MyP3SCk2jUmbqMXbgYTAlws7HjmPVdR1B8vBwCsXVTcwx066wO4qQ/4FNunDhcyGfeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n6c/QMha";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE29D606A321;
	Wed, 25 Nov 2026 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n6c/QMha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFFE1F000C4;
	Wed, 25 Nov 2026 16:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625485;
	bh=PuuDka8Nep/VETAnbrMdZKBJ4tsSs7SWMqR//WByA2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n6c/QMharvNLEVK29KobMxdpue+orzcnWjApZU0AwmdWohjTjxd7UieEX2gvnPc9/
	 v1WfFyA8IeKFyuF81pggtxiGmT7bqp21siUSEUoBZLhm2vcC7ztQEpuLjjLc06++6u
	 yP9i2/ccOmM4eDuDXaEb81AH/BiCkU7iQ/sfbfho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajanesh Lal <ajaneshlal3@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 532/816] ALSA: hda/realtek: Add mute and mic-mute LEDs for HP ENVY 16 (103c:8be5)
Date: Wed, 25 Nov 2026 15:34:40 +0100
Message-ID: <20261125143901.506112451@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Ported the four hunks by hand to the older file path, placing the enum value and fixup entry after existing neighbors because the upstream anchor entry is missing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 726fc58b17ee7..f2673ed691d73 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -4797,6 +4797,14 @@ static void alc245_fixup_hp_mute_led_coefbit(struct hda_codec *codec,
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
@@ -8235,6 +8243,7 @@ enum {
 	ALC287_FIXUP_CS35L41_I2C_2,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED,
 	ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS,
+	ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED,
 	ALC287_FIXUP_CS35L41_I2C_4,
 	ALC245_FIXUP_CS35L41_SPI_1,
 	ALC245_FIXUP_CS35L41_SPI_2,
@@ -10444,6 +10453,12 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC245_FIXUP_HP_X360_MUTE_LEDS,
 	},
+	[ALC245_FIXUP_CS35L41_I2C_2_MUTE_MICMUTE_LED] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc245_fixup_cs35l41_mute_micmute,
+		.chained = true,
+		.chain_id = ALC287_FIXUP_CS35L41_I2C_2,
+	},
 	[ALC287_FIXUP_CS35L41_I2C_4] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_i2c_four,
@@ -11180,7 +11195,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
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



