Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830947;
	b=30AZIfRwbPta8u5kamPBp86MhhbhQ9megpoJe+GBvx0EMC9KiNeTp0K7bIU1gGVJX8yB
	 4Fk1J2UagZD3l0SlgER6MR7XMwelg5yvfljCvtuLnoBjeGHfKta0E88DDyjvMpg1lBVPn
	 93klMxKN2hAjI0SE2cLzHCvigFxAp/ymbjjkrtTR80Im/S9qUckyP6BGZH2YqETLFpiKp
	 W949r158s+cNa6HadeQaOy0nkDMuPmPiklqgGOzBiEoUwKlxU6+7foWhXYdBOG/ko+6ec
	 b+LVrxzhUTTQK3CaVcDLFfgOUqGBBEGy5irVXeZIu5pndvJQYEMMPrnlyRpzbJQd7Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1za71HMjRN42cMh5Rg6w0HF12xrM/UV+CW3Km9VULbk=;
	b=XDcZNkyKoWiljLLyOtchPIL0H9/slI73eYTVl6AM2CSKixu+vUQ/Cj7riNP3J87+2Yd9
	 hUa2/lVS4rtdiR9qEMKFht5KNuDsMd7VHLDliJOWEIpkSYnYGCyP5bkpXN0wqP5hu8pZT
	 enbMfsHIE4eltMu0XPVIXW4pLBsjhaznQ60WUIXps8PbXOSYdSMMlBWPnM7/96bUgOZDm
	 YbFTDLJXWv9GJ2YJq546cb29WNs19wu0eEUh1X52tlTcCBVCS7KGaDcRaLf1Lu2yYd3St
	 Tl/CXd4cK222FmlJPCYcy3kCmb6BdK0CKE92Wc+a4uMBCOnpx90b9RHt6XGBuGZRXYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpdrPXHu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573FB606A844;
	Wed,  4 Nov 2026 22:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mpdrPXHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DFC1F00919;
	Wed,  4 Nov 2026 22:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830947;
	bh=1za71HMjRN42cMh5Rg6w0HF12xrM/UV+CW3Km9VULbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mpdrPXHuHtM4t6WcOoo4KIFP32igMLm34NafdHNDleln0QabrS5jO3OtUP2XelRiS
	 czzjqx2wigeWdYbfY5Ey5TEAPZK8VH+ADXBfONtHZEDBGj8ok19rKOorImTuPTcm+2
	 sowhoroZZIi+XGXrM9CGl+uA8Jl26NcD2m/1tBI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yashraj Ghule <yashrajghule.221@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0416/1005] ALSA: hda/realtek: Fix mute LED for HP Victus 15-fa1xxx (MB 8C3F)
Date: Wed,  4 Nov 2026 16:02:29 -0500
Message-ID: <20261104211055.743729783@linuxfoundation.org>
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

From: Yashraj Ghule <yashrajghule.221@gmail.com>

[ Upstream commit 19b02fecd8f857909af779afe3816e487ac10cd0 ]

The HP Victus 15-fa1xxx with motherboard 8C3F is missing the
existing mute LED quirk for ALC245 codecs.

Add the 103c:8c3f subsystem ID to the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk.

Tested on HP Victus 15-fa1xxx (MB 8C3F). The mute LED works
as intended.

Signed-off-by: Yashraj Ghule <yashrajghule.221@gmail.com>
Link: https://patch.msgid.link/20260816110655.11592-1-yashrajghule.221@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 9ec18f779a700..bc33930e83b9f 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6974,6 +6974,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c2d, "HP Victus 15-fa1xxx (MB 8C2D)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8c3f, "HP Victus 15-fa1xxx (MB 8C3F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



