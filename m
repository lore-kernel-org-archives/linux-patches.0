Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043762;
	b=1Ht/RZKPrzwRyiISVlP20WFXyDS2zs0GTn2JoMcfNO4x8AzEXs2P883i6lpmJaXVV2HF
	 8QtLv5AJFOxTw7bP0Mx4L8DTAJrNuCEXkfLqaH3IA2UW9bNtdO/L0blgqJAimooZxG7c7
	 +CtxwZ08RBNbFVLN0f+rhg8JCo5dHr0SaxKors65dXa8xFDqRO4UkDyuDDbtWXvIsfMOi
	 Cuo1ZGANaoYc6SuuIqlWmBVS1uB6ktcR8h0icgdnn51KZ6TSyYseA25vpnKGnVB7X4MZS
	 UwVJ0qMfVWdiJGKuxixbPM9yO5buDqq98e0zW7HZHp9YctwVwKxwnS/FeMLRAKftA5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043762;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qup7RHTc3NkevNCONLT8tealbC/VnoUrymQj/qTTL/U=;
	b=dARYTbnvjuUAPIClwqo/jXbrwIsLLjI80bJ/hBPXTiME0JdxEmDRwSlKpw8HBnJlqCXS
	 jcZII6S4TZ/Le1HxkwLqSVSBQpvEukxdcCr31RhV0Uox8+7Yv9dS3DBiJFci9q9zx5RBe
	 6v98fbemRTPOJmpu7YOCq9+eyzuoGVcwnjg6zJIQ/7FyO5y1zJRnN623lipsIMIAJB7O7
	 Gpzj1HGa1vx/CYh7HXnjzVnvQGyqNZ8HXaXPz9Fbt50i7vk5ZfOOm/BboxonRpjieUV9p
	 aqBep3MtjsiZjs5Wb8aBchCxRDLFdbarkViJOG9Nj0wHezSWIUd1CWZ9SBHrQBWYq6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeeX6tJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67FF606A335;
	Wed, 18 Nov 2026 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeeX6tJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3A11F000C4;
	Wed, 18 Nov 2026 23:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043762;
	bh=Qup7RHTc3NkevNCONLT8tealbC/VnoUrymQj/qTTL/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeeX6tJy60LYyPxfbiqtQg2o1Yyt4FjWxBqFaOI9Dc7QJ+bo9XmqBE1tXlmO6REsR
	 KebxRAZfOw9TuKZ2VUSPD7Mrj50A6PTxep20z1lh3DsGFfFXZEDY/NcVgt1kQITctt
	 Cx6Ei+gklAd0HzotQIW5JcFC9TR04XyrYw9YvM9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0275/2857] ALSA: hda/realtek: Add quirk for Lenovo IdeaPad Slim 3 15ABR8
Date: Wed, 18 Nov 2026 15:21:49 +0100
Message-ID: <20261118150211.328977768@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit be79a45e2ec289eb9fad519e8f5a3d4fc3789dd0 ]

The internal microphone on Lenovo IdeaPad Slim 3 15ABR8 (subsystem
17aa:3862) exhibits severe distortion at default gain levels. The
Capture Volume is fixed at 63 (max) and cannot be lowered without
explicit userspace intervention. The existing fixup
ALC269_FIXUP_LIMIT_INT_MIC_BOOST limits the gain range and resolves
the issue.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221891
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260824123752.525173-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index de300e360ca93..0fb7607817e76 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10417,6 +10417,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3862, "Lenovo IdeaPad Slim 3 15ABR8", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
-- 
2.53.0



