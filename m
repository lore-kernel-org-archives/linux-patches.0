Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019444;
	b=CbD8xDY6gjyExk1WHzRUf5LQxcz3Frn8OjGG41tYoOX9Wwjlr8cy0jWVkon8IGbKk1uu
	 LqtCazRCt/aFUOw9kzvEVjX4F04vvfnOWmBICWPGaJ7F1vsRxp4J2xcTHqzZrChy1SHL7
	 98scYNreGiHYmxqmb8c+RP0jPGo8ZCjoe4SZxJSPb1xgzmTqG2hVaTiumhDqTe8teju1h
	 QiJA+GS9pDQLNWISWE9zPu+D9SHtCJjSaNygodVw06RpzecKTockC26PmaIMIhH1rbePV
	 xCvjVrHyprV3zi83HfF2tHupmnzABYhAkN+MIYrzGjcQoXGpFBZz4EdzayH+bVB9IIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxMlh8i3N7fQPgkDBWo77dGfqZ5V9/dKUj/SsHiqFds=;
	b=eVFB3iUuf6LTlnScAwaSXN0CK1t2sBsVzUauNcJ7fI31IpGyvE+euNdLFkL1V48F/qSo
	 XfNyRdVic9cP8ij3hOXMz/eMdi9ch/GI2mXWuAWXwowX3puMwlXTOk5/Qjoj7vmF8krzb
	 YtEGmdPvcbeW95HcO234vuh4YF4OFOuORPPnUDzFFwAVE0KMqFEi0vehsOwHF8EWDj0mt
	 S0xgU0dwxqsv8dn/5Or1usm+5MjJwAZE7zqXGx0BzUf3jFlYBC1XQqvMQPOwLfjTnYDLU
	 cbOLq3nfGqMwdNWCqhnFO2p5ZPR+Y4+Z3PPlLaB6px39hR95SI7+qX0sDzV9tpzyOQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJnVznGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94160A2624;
	Wed, 18 Nov 2026 16:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJnVznGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179C91F000C5;
	Wed, 18 Nov 2026 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019444;
	bh=kxMlh8i3N7fQPgkDBWo77dGfqZ5V9/dKUj/SsHiqFds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJnVznGifRMdKP0c5QP5WEbhzpkD7nqlGvKQOYin6Zw92PlQB5c/hLgkbQsFg5zdH
	 mCLSnaxnhYRMdxKsO230kAF/66TLgvqGgpRBq478WP8e44T+gNyv1ln88gRIbEvlHa
	 I3UymoloMAI9oK9svlNAMMjKiWr0Xwli5eYDODXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksim Krasutski <krasutskimaksim@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1598/2651] ALSA: hda/realtek: Fix mute LEDs on HP ENVY 17-cr1xxx
Date: Wed, 18 Nov 2026 15:47:18 +0100
Message-ID: <20261118150345.401651493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 8d8a0b85d5618..e61cb50a8de97 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7734,7 +7734,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be5, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be6, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be7, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy x360 2-in-1 Laptop 15-fh0xxx", ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



