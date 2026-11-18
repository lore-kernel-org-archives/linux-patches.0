Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034361;
	b=DVD/wHhibsPsO/ebSA2pqE+LugiSS4ilSVbrktdzsfDbEQTOmla989OybgBwkVuwzJ9X
	 Tqa1oWoU45YloIsmpXWns1OY1/gAG5mcsKJJQ7Fa95kznPTPVqi3z0NnXOOnvQEFcMRM0
	 uomsdgmqHn+Tz79oKjTk+4Dh4cPH9o+vtSu55iJgY7xvFxY1h8NTGu9Ky0UxYfnOnZqb1
	 o8QSsdTK2yZmM/TpCwJn0HNFj3IOkpP7FR0jxdAvx4apaq72/EIGHxbt1XCu0JfAtFFyu
	 KZzZX97DhAO2n477WUTa73o4z7WjCfc49NUbHCS8Sa0U0G7a8TE4SK5W6e8U+q2h6wA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034361;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SsoEgesbee0Nv2jYm6IA4Ue8hbk1tinLjre7AqAj3a4=;
	b=zKR19iQG/kZc4FOqL9L/eg7wR0wec+2UP8/gEouNPfNUgEwtiw3bamPWbQoT7kMhR/nV
	 9tR55O6YYLJddsJobhL5UymloZYJOwITXest4e3vEBp53u9X+HPf3UMEVJYGDwachKzEL
	 C+MgCsYc4SvZiPWiHxYibvcdHKhpI+Q3+Mrk2CL/5QDLBVHgESNveIFLzYgeWzSos2H83
	 cD6ndt16J1dTQXuk0e2Gy/Ki2lWdrfeHxZNJ290o2Wb99kW0QLZtb5mZpyY5SiskmslYX
	 oHUCC7nPgQiVi/AKzOgZA2hasrTuLGLaJA/LxbculkCQpGW4cgWirc7v8H2IJVGICAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bivJCx6L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C40DF606A320;
	Wed, 18 Nov 2026 20:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bivJCx6L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DF01F000C4;
	Wed, 18 Nov 2026 20:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034361;
	bh=SsoEgesbee0Nv2jYm6IA4Ue8hbk1tinLjre7AqAj3a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bivJCx6LIfGbpAOPlH1GPYs0OVUU/joMTxYTHqVHYF8YeIs2djnK4UwTqurZEI57h
	 dfe77bSKKpxvkYT9bv0kq50rYkvs1gZziy7dGeNvCDyLkygjz3NL47G6i0VI9P8Wpc
	 ZLFt+0tmOPh/amvg/TV8VQ2vjChyNYAgPkdRkIPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0343/3318] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Wed, 18 Nov 2026 15:16:05 +0100
Message-ID: <20261118150326.297917571@linuxfoundation.org>
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

From: Tomasz Bojanowski <tomasz@bojanowski.me>

[ Upstream commit 7b457ae8cf711831f19d20963f5ed2fdf4842d3a ]

The USB audio device 0db0:cc78 (Realtek ALC4080) on the MSI MAG B850M
MORTAR WIFI motherboard exposes all playback controls as "PCM", which
makes it hard to tell the outputs apart.

Its mixer layout matches the one of the MSI MPG X570S Carbon Max Wifi
(units 29, 30 and 32), so reuse msi_mpg_x570s_carbon_max_wifi_alc4080_map
for this device too. With the mapping applied, the controls show up as
"Speaker", "Front Headphone" and "IEC958".

Tested with a patched snd-usb-audio module on a 7.2.7 kernel.

Signed-off-by: Tomasz Bojanowski <tomasz@bojanowski.me>
Link: https://patch.msgid.link/20260923184957.6687-1-tomasz@bojanowski.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_maps.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/usb/mixer_maps.c b/sound/usb/mixer_maps.c
index ace4ccad8f51c..a82b9c1d578d9 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -718,6 +718,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
 		.id = USB_ID(0x0db0, 0xa073),
 		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
 	},
+	{	/* MSI MAG B850M MORTAR WIFI */
+		.id = USB_ID(0x0db0, 0xcc78),
+		.map = msi_mpg_x570s_carbon_max_wifi_alc4080_map,
+	},
 	{	/* MSI TRX40 */
 		.id = USB_ID(0x0db0, 0x543d),
 		.map = trx40_mobo_map,
-- 
2.53.0



