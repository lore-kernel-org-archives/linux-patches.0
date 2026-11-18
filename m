Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034364;
	b=U/N7dFH0LLRPGF1PxC8eIzrKU+EPKIuMrsJMlw/r/nN8eQLy0saKMquW3kmmXEBBHT5T
	 qeif5nrPxWSCdHitaBFaUlLF1Jj+mMREF1OLiK47f69IkoCCN8jEOyh81WEuzSus9smgE
	 sy/vF6hTXn/cKG6iA0HHnLShjJg3V64mlQFpYdzWAGHhu3laVvY7+ArQ0wdcvI5pY33zB
	 Gj2l7JiAkRqL5Fm6TV1e91i2rl6x9HOMxVMyuMYWVTjOCHxEtVGh+48hDXrzJEMVr3puL
	 r8gSYJtQs+UN6doT6HGO2TXsiDMsvOQfDyTUCc6Fr3yc/txe3ULG0PiRvPJ8BRsUcGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Yq9ju9s4+PuTNUDfZL2xC+qAcY7Zr7YfZ6HKAHhi0kI=;
	b=tUFaJnG8KvBKYGaylc2HEKRUJ8I4iTCZhgcKORXwdpmpwRHg1RnvMfHbGkme/KyN4Slt
	 OMZgO1gOFrrXFpKqf1jP5itC7mkYujm8vYZCjko3bZNRjAXK6sj6GFiX72fLcIozxfSjZ
	 IEi9kf4TgkrsncyD72PbSJ/h1Y0YmE2EpeYBV4JS5ghv5b5tHEvARdbyo3XulA1bfR/Zq
	 P9BZIAPrDZpPaK531KbA3KDJdWJyxBjX/nuLyikW1isLs9kF0iktkNFcJbN02ooxyOowl
	 3PsGtAcDBuEe73nJy5Zc8NZrKI/PZWfc5Y3fxICGRmrnF76EBMZQT3ORolUlg2qKozg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1QQzptP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1330606A31C;
	Wed, 18 Nov 2026 20:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w1QQzptP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F05EE1F000C4;
	Wed, 18 Nov 2026 20:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034364;
	bh=Yq9ju9s4+PuTNUDfZL2xC+qAcY7Zr7YfZ6HKAHhi0kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w1QQzptPtwg8Jox+FM3BNCq/U2qk56DHIU/ZCIle4PqC3Zkq2FXJuUc0QXnyVFa+Q
	 B9rtDISReJGgUPRVZVwB+hApUY+xT25l7ViNeSrqI85gODtJdlja/Z7iqUGUS/9glM
	 ZyS7HFBtSkq+VZujDHmEFmvUPpRyfH681Jol3n/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Banha <luisbanha26@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0344/3318] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-ec1xxx
Date: Wed, 18 Nov 2026 15:16:06 +0100
Message-ID: <20261118150326.334723058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Banha <luisbanha26@gmail.com>

[ Upstream commit 775aa96c310d59f3d15a6e5a9bd1796fd1ba95ec ]

The mute LED on the HP Pavilion Gaming Laptop 15-ec1xxx (103c:87b2)
does not work automatically. Add the ALC285_FIXUP_HP_MUTE_LED quirk
to fix this behavior.

Signed-off-by: Luis Banha <luisbanha26@gmail.com>
Link: https://patch.msgid.link/20260921230105.16844-1-luisbanha26@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 921331681a4ca..dda1cc3592cca 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10158,6 +10158,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b2, "HP Pavilion Gaming Laptop 15-ec1xxx", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



