Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830820;
	b=kUUwoOjYwu5JFITNd+lw8rjLOC/Eri8VVwOBzH+gGHziwgttE6yVRNwHfhQKD0ltwAri
	 iGjdAydknkqN4mOx/sFhordclsI/qeaYDXLULGxpbALivPAIAgYbnTlTB8ihDYpN0EQky
	 jQSbxcUEHZG48SlSaouOthavAbfAnW5OyubxIxCgBpsuj/TcEqAOq9UdEBuaAMF3CT+cb
	 bX3vPMTAa5xWQkhcxOy3pnE7n1sG8aYgKKZTfNi3ZhckeVjsh4sZ5b9W6U8zEzzGtExzQ
	 Ksc6W9e95Uwb26MaNMwseFE2XfgkV/D6kOcuc+sUauSZ9/89BR3k/i4J2bcx3dFadbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830820;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=co2jgbm5xP6iNPFAAR46m84b6A0Q6v34CTKtvuePCtg=;
	b=eR63DU/mUD5DJdDFjETci321NoOARWvINufOOxYHBZxuFkxjVirlE1pEpLJJ172t3f1Y
	 yc5+HZyV+2h3NK9hH16i/bxR6l1hbQ86CJySvoS9lQ+iwLX+kRoSoS9pm7CRjPfSJGpKx
	 KnOHDMsr9PTbaVBiT4BTJAi34joYRlgpYxNIHasL4w0k0PHDHhrQXqAMdayjCbde6xMD1
	 ic0Ia0oJKA7HeEonjBP318WXCbGp0Sh37viAAgd4xuf+Ww6vSv0psLpahs1Tmh3u1/oEb
	 SVxkjmLpdTBFEFEHzSAXmk3zccjAttZC2EBpaIc7b5i2UowB1dGs1EdxNzs9G2hwfBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm1JFzUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 264D5606AC33;
	Wed,  4 Nov 2026 22:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nm1JFzUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82021F00A18;
	Wed,  4 Nov 2026 22:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830820;
	bh=co2jgbm5xP6iNPFAAR46m84b6A0Q6v34CTKtvuePCtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nm1JFzUPAr9IBXKgmtGIjUb5MepQFzATl/Jutb753a0FGXLpaghLBKlMbxefN7MC3
	 bsXn05WAcBvWWA6XbghypB9KL+0aRBpLoWLIJ8NndNA18lJ5sSGCSMOJQ02fzdHaOW
	 Or1gxgAK08hjFrsm02jnOJU0CLuC8H7Fgf2KaBv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0339/1005] ALSA: hda/realtek: Enable mute LEDs on HP Spectre x360 16-aa0xxx
Date: Wed,  4 Nov 2026 16:01:12 -0500
Message-ID: <20261104211053.449057612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Shang En Sim <sim@shangen.org>

[ Upstream commit bfcdc1c0eaeae5525c726193568e8d638b2afdc0 ]

The HP Spectre x360 2-in-1 Laptop 16-aa0xxx with PCI subsystem ID
0x103c:0x8c17 only gets the CS35L41 amplifier setup from
ALC287_FIXUP_CS35L41_I2C_2, so the speaker-mute and mic-mute keyboard
LEDs do not work.

Use ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX like subsystem ID 0x8c16 so
the mute LEDs work.

Tested on HP Spectre x360 2-in-1 Laptop 16-aa0xxx.

Signed-off-by: Shang En Sim <sim@shangen.org>
Link: https://patch.msgid.link/20260807055139.58707-1-sim@shangen.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 5098d3f375316..97ab2269dc472 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6969,7 +6969,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



