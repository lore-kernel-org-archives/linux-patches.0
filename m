Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022752;
	b=LnAYTnXr0g7ZYZtDIu/c5+cGvTg+AogbUjDCw3G5r/LBRdDvstFRtBroGB9cKQKEAbPj
	 4cLe8ma4Oe5EA5aMFRzlTeINq61RftT/AGLSH8nMwyJvrVZDDQ2FHpx2p2LqUsA5sePwh
	 BvMsYtLZjP9pb77DSNCNRImPwLLc3c9kdXEVJe4gsxo2FDpXakg/oot7sml41mRa/WgRb
	 2sro7tFkNFZ1C9iaTR0BZN5YuQWVZVFSBCCAKjpxJTOPjNjU1ivU5jXLegRNCI1Ox30dj
	 ExzNCfdBV1Y2vWKWLSsYtBR3YYUhUE4GovSGtfgka5IzhpaZe36i+z33EjX3/DIxj6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JSYz5ECwI8RHA+jkTVA1Xit0ukCM/QfQc2QOaKJJ8SY=;
	b=WINZHbYMIhWO+UjloNzjUUiZ9iLZ+zvFz03EbQTfGHorNK5HJmfskH55rrqwBMinSVoG
	 UrML7dXN5i7bV73c+ewLzfSSEfw17b8zGsBzoPARt/yjt64Q8/A9e9xGSlpyTCguULrYy
	 Nbh2bdQirqaQGl1HYOBXDd4ZIIyoBZVR/5gDe3TkT8659O7NQfwuwJ4DsYC0lKPQ55i9Y
	 tNgwvTohAnauA7e1KmHZ1UXALmtoAfIHv6faqhl+sm8erQxLEDzQJMUWEfFYHIDsBMTX3
	 EiT5tFmvHxbs4ffamQJgrqCdGYqA7COUy6Fsp6+jVA193v7DvI8r7wEZ7/aIsqWbuEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoWGNiDD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FEB60A5BE2;
	Wed, 18 Nov 2026 17:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JoWGNiDD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E4D1F000C5;
	Wed, 18 Nov 2026 17:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022752;
	bh=JSYz5ECwI8RHA+jkTVA1Xit0ukCM/QfQc2QOaKJJ8SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoWGNiDD5ReI9lz29RtfJbi3RtTYihYXsjRqE12sulMtbulzvz7dgWNHt1bDVHQBG
	 l6uBgyZvt/eScnTpCbZFDynzsrSGLAgY3Qn61EhdaQ+WBqLxDza0w8/vb7aDbSfpDO
	 4vmDRdMCRCcW+3U0Rcn3aAsjyGMeuw6KASZTepLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr <youdoit@mail.ru>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 0124/2151] ALSA: hda/realtek: Enable mute and mic-mute LEDs on HP ENVY 17-cr0xxx
Date: Wed, 18 Nov 2026 15:30:59 +0100
Message-ID: <20261118150126.308483815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Alexandr <youdoit@mail.ru>

commit cf79cc4996bf936fe159af2a600519b3ebd4ccb7 upstream.

The HP ENVY Laptop 17-cr0xxx (subsystem ID 103c:8a2e) has mute and
mic-mute LEDs on the F8 and F5 keys that never light up on Linux: the
existing quirk entry only sets up the CS35L41 amplifiers.

The board uses the same LED wiring as the HP ENVY x360 15-ey0xxx
(103c:8a31): the mute LED is driven by COEF 0x0b bits 3:2 and the
mic-mute LED by GPIO2 with inverted polarity. Both were verified with
hda-verb on the actual hardware. Switch the entry to
ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS, which chains the amplifier
setup with ALC245_FIXUP_HP_X360_MUTE_LEDS, and use the DMI product name
of the board.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexandr <youdoit@mail.ru>
Link: https://patch.msgid.link/20261103142121.74032-1-youdoit@mail.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6991,7 +6991,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a2b, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2c, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2d, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP ENVY Laptop 17-cr0xxx", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a34, "HP Pavilion x360 2-in-1 Laptop 14-ek0xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),


