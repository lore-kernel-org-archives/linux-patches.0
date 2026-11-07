Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060912;
	b=ykLBudG+lY2GxqN/yVSBGOtigZX3m10OhdjqJFXPW9g33dnHfg7LhKzGQCrjxvAqECdq
	 8HKMs2yCv6+De5XPT61Mwme+d1EUMR2Y9MPdJP7pyl36f2kdjh738ArtMhnxU08dz2T61
	 /gHi8h1OLX5vVWU4e3MQfyIHv7VcPlcYJ5naFTIDX0V3yiMfBk+5MyG54cKA+/c4EKliQ
	 2JHSylIQySGRNDRZeAFCtLxwIMAJ+yuH6Z2AoDIpB4VuIqUk9R8SQnP8AZoCD2p379DdZ
	 0//n35Q1XjsCYaHLhGWP7Uc0YlLe7quLwrRA0QBwN+q+h5jKZHpKK2/xI9CreeUDZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vn1fg+M1u79jehET4I5oOPjMCpZDRSiL+Yi7efzwWyU=;
	b=LiF1ID3P6jQ4co1Zc/ghMFGVVdVSMjNX+3+vmbXChfQgWYi7o+2jW6qde3ugT0xVP/7v
	 XoyaxwP1oeIjGbbT12f5AC1FKm7tA5oddrVdDoqPQ8rRpWDAojU5IputGHhleuVz/oGg/
	 aVbiPNyrsyWkF6AE48TKYe8p/hvwfyqeqZwM6OVFcUr0QuvaRcXpVVWOxKmVdWVttmHyZ
	 LCCL8bz49+3nHFKY0C0COoiB5g5AcFe9Hve0FGRsivZxwdkEUZLCUQJTg+4f9ktMdQzwR
	 7XVV7iN4VRG5TFOYuYRu2SvdiM09N2D14qxmfI7/c1+LfxGmhZvmXN1jwpPgHZOzS5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4N0lTzs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E1606D81D;
	Sat,  7 Nov 2026 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G4N0lTzs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57891F008A1;
	Sat,  7 Nov 2026 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060912;
	bh=Vn1fg+M1u79jehET4I5oOPjMCpZDRSiL+Yi7efzwWyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G4N0lTzsz/HHnzY1/eVX247kw6RF2X19nJZfGGiVxO20CH3rz6uXERNXcOiBNNDEm
	 X5TzJtsI9C6hjXevTBjERuyxhot9vfQh+SaeHF7suTz6o6OwDWAklEMv64yT0Wq8T4
	 nksYxuKTpQYVMMkwsooiwewaonr4tnFLgaYopiYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang En Sim <sim@shangen.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0281/1536] ALSA: hda/realtek: Enable mute LEDs on HP Spectre x360 16-aa0xxx
Date: Sat,  7 Nov 2026 08:38:17 -0500
Message-ID: <20261107135005.556582359@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cde9e6a252ffe..ffef6b5f517cd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11097,7 +11097,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



