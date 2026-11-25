Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622581;
	b=y5xjQyZoDMPGXh4p0O/ZV64G2CnGV/7iLjB7KrdPred9qNZG30kPH32xv+jadJG386J2
	 P9THcoww8WHQ0fbHSMQJ9YELmerasR0Q09e6zqWSlqbuAo3L3gN2q99zxgQURoZ+BEUsa
	 FlQQtvDOgWw+eR0oiiIanV4vlSaaTUXL3GhnzGjziiQlHshdWD3hE4skbs/8G1stoBuX7
	 GdiqSrtdzR4xn6wvAZo+4eQGtGfWmMahvOEgOxh0OdbN5NYlhrhM0XY6MQIRJ+lPbbpcH
	 59yv5JlUcoLQs9Cy00aLMv1sJ6zKobK6C8JnqjjJZ7adDDKTgIEssyY4qdwaCOP1pZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RhuSdlLdN15pcXhVTR5uyDGDjGQq5pTqkgII4AFcBvY=;
	b=cxpDYzg7b6wr/cWoZEs8UG4FptLn1j9OSwUSsoC9FjiEjrmT78s55pcecGUIbzJbHumy
	 gVXvUC6iQuyVmhgBbntGb1Cxg3h9zmQhOE7ehMrTgMICzm7CK9Od6UVV/pxuKG1OoqbeO
	 pax95koMzBLlKNK0KR49l/kbaIS4bDAT+nrM1Wzr8KxFHb4gCKWnosEsotesBXByrjT5J
	 43PKTZYFGsWTm5a4vHIUL7Lsp5nbA4EugHPdwW4EW4OubGmuXYF89C8aaxTFT8BKGb+uu
	 dJRzgONOZla2KmCW3SC54RN19CQ8/laQnXUKa7uw/P0P27XRsKNMXsRHtC2myCOqN4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpqymYAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486CC606A330;
	Wed, 25 Nov 2026 16:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpqymYAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4C11F000CF;
	Wed, 25 Nov 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622580;
	bh=RhuSdlLdN15pcXhVTR5uyDGDjGQq5pTqkgII4AFcBvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpqymYAhBnzHQM2KLQeLkjiDP8amcJvhJIJanSW/fvVDpDeYa09916ragv2louCzf
	 LNlkUalGV+sD/skCJeLXDovXpplQMRcDAiCPtPSlMGhDiYhpUJtC7sy0zEUso+m8be
	 1ZAqhRzpK/SiobVykv9jwfGU9H9VUx0GytQ6O7S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Krasutski <krasutskimaksim@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/990] ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx
Date: Wed, 25 Nov 2026 15:32:29 +0100
Message-ID: <20261125143835.723819700@linuxfoundation.org>
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

From: Maksim Krasutski <krasutskimaksim@gmail.com>

[ Upstream commit dd83323e4d5e22bd04f7506a9ec33533465c8393 ]

The HP ENVY Laptop 17-cr1xxx with subsystem ID 103c:8be8 uses an
ALC245 codec and two CS35L41 I2C speaker amplifiers. Its existing
quirk configures the amplifiers but does not enable the speaker
and microphone mute LED handlers.

Select ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS to retain the
amplifier setup and enable both mute indicators.

The equivalent change was tested on an HP ENVY 17-cr1xxx running
Kubuntu 26.04.1 with kernel 7.0.0-38-generic. Both keyboard mute
indicators were confirmed working.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Assisted-by: LLM
Signed-off-by: Maksim Krasutski <krasutskimaksim@gmail.com>
Link: https://patch.msgid.link/20261010185335.30949-1-krasutskimaksim@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Adjusted context lines: the neighbouring 0x8be9 quirk entry differs in this tree, so only the 0x8be8 line was changed to the HP mute-LEDs fixup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index ba850cb119ec6..6ee95ae0e8f67 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7106,7 +7106,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be5, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be6, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be7, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



