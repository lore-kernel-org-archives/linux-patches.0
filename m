Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060963;
	b=HzZUKJMrcjT+jafQHNVRvX1JB8aMpdwz27eBxBgrHVfJm1yPrMtN3x46heZPSQA+wHVj
	 pw99lsuXhsQMgH0dvvpmQ0/bmqMNhWIsa8q60Azx0+Wo085e2EXongnAvZY+sNh8XpCJJ
	 8MbwV+k/YJBd6HhLMgB9B2Ty/pukXUoD1sfXssq1BHm6HGeJw5weGQXTLz2TOTIHp0IRE
	 w4/VFc3YAHpPzJ5uJJRDQdu2ZqYnEmFjV2IFt1CyR/a6F0NzqrSjEto8HyjsIxr88yPQx
	 wucl41z49BEwAkfTODgdChAQs4TR6M9+ycBFvXiaVbSAxk/oqyXDSZ6jVTHTZ/V9UWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nvyN3fROtlSkSjOf/DJPt6NPuseFND7H2Xn7QsyW3mk=;
	b=gCqD5Yofl7LwFl4w8jY3c3WDi6rvfcwxHBCRciJLyRmNsf+kkgLTLIxIYCPF94ytGbEc
	 xt9WvFwK9E6Lk91UAwplQhEvMkLFtVAyGPfibyyvsCRpkydy+GlMQaEIBB+kN9qdtNqh/
	 JmMd1grzs1snrdRom4F4qso8Zec6iJM5cN0eFfftIWW6MLCLkBLORX2LsxBltbwgr3Sar
	 v3KXnw7XkNE79DPdtI6iKtrgG7r1AZe8rdKjBPYo9z29GfYJkp5Ua6vITENI1G1L24N0+
	 xj1CuGMygwbmUHiLItK8YOPMEK4XirK1mexCzwXlFT/ao1vnQtPvqFSz+A0mvVNIx2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMPxxi9f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D193606A330;
	Sat,  7 Nov 2026 14:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mMPxxi9f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D587B1F0089F;
	Sat,  7 Nov 2026 14:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060963;
	bh=nvyN3fROtlSkSjOf/DJPt6NPuseFND7H2Xn7QsyW3mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMPxxi9f5626G3uJWk69U4pX+8hwtoZz0qU3uk0sw8U3GcxC0aT5EPkQXY+rVBayh
	 eqrUEaZqmSQDmUNfjwxqUyvhNKxEfDgjtdCZa8N7gNn8NsLxr72ndbBDLAH32PCk7c
	 ru7lERC4Wr0yNNyicRK/dRNvheL7ENo5+YIkepBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Garrett Blackmon <garrett@blackmon.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0292/1536] ALSA: hda/realtek: Fix speakers on ASUS ROG Zephyrus G14 GA403UM
Date: Sat,  7 Nov 2026 08:38:28 -0500
Message-ID: <20261107135005.934379826@linuxfoundation.org>
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

From: Garrett Blackmon <garrett@blackmon.dev>

[ Upstream commit 140fe610af607fd70da95c447943fc2690855519 ]

The GA403UM (SSID 1043:1044) uses the same ALC285 codec + dual CS35L56
I2C amplifier topology as the GA403U and GA403W variants, which already
have quirk entries (1043:1b13, 1043:1024). Without the quirk, the
woofers sit on a separate DAC from the tweeters, so the hardware volume
control only scales part of the speaker system and the headset
microphone pins are not configured.

Apply the existing ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC fixup to the
GA403UM as well.

Signed-off-by: Garrett Blackmon <garrett@blackmon.dev>
Link: https://patch.msgid.link/20260807150708.33785-1-garrett@blackmon.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6b883ade4bec5..be165a9ae674c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11197,6 +11197,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1034, "ASUS GU605C", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
+	SND_PCI_QUIRK(0x1043, 0x1044, "ASUS GA403UM", ALC285_FIXUP_ASUS_GA403U_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x106f, "ASUS VivoBook X515UA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



