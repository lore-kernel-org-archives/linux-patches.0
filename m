Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043666;
	b=3Qytx3DK+QicmhVNesjdEvJMJSSwwc8Ik2W0OEImKlbfA2TWVWngkKzMX7N4RYW0Co/m
	 b66Im7PrKP8gDnjkao5iaAKlVsgXK1Bs9m2ZW7Ptd1M+QfZD549aZ1wCaEkFysWihFYmu
	 xvVifF0+yfxZ3He2mHF67FVzWcsLxmlulspQ0AXXQBRJfTpy6sXGi6LU2pUg/aFeHzuP2
	 ohQSNPMLoq/BaGnt7il2uLAthIFYpCAM3A7n4mTcT9gZpWY3vkMu8WueuTSMluu4DJLYi
	 mG6oqBJalJEYkUDr7uqaqUTcf9nbxwiKKcCu0TUyF+njzWS1S89Ev2RZQU6GHwfhWYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4T0ApBafvnsNGYgJDfQlMQy32yQskZYlVPUIRnn27/A=;
	b=utB37KEkcwWMF+iYGj302JOY5vrUFslWoLnjM2wX9vcxdvPVMVM4V0bomPA1w+UlJ3F9
	 W/ckZutt090Dmn/7ag1xKFA0fi0F5J4DsoryiiWZtDvPXRBGLqL7kyDv6rbIMNFhoPgYy
	 GFhMNfFCbiJLbp7ULVVQHSXsqbpUeEh0SnJJfp70W+nYte+rCtYSlvg40hDv2EHFK8FEB
	 zlU+mGx+93+p19M3ovrFZv9REUHbwu9iOX5ERPen/2eOYEsX7coijrPNuwMgMNGnJDYmQ
	 2eR63n8OYkpBJGOVfNSlk5xDZgiTyv3XFXe+D/cR9JjfTroFqGumOQXGQ2FCAhaMK5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYVg7hGS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D8B606A320;
	Wed, 18 Nov 2026 23:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYVg7hGS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A06C1F000C4;
	Wed, 18 Nov 2026 23:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043665;
	bh=4T0ApBafvnsNGYgJDfQlMQy32yQskZYlVPUIRnn27/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYVg7hGS6yEkn/QZX/VuBVw2VL+D0/iJVeadqaHlf3a0uL1GsmQaJZxGfn8VBh86n
	 I0jKZXarVQOA12Pr4+9QISFm2Xc4I6/hhqX46suJhx4jgVpdRtTvj9hvmrrqhrSNWD
	 RNqd9y8tRe2XZsYeK7mlHFY1Yln9QUhJFIoPb6zY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0292/2857] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Wed, 18 Nov 2026 15:22:06 +0100
Message-ID: <20261118150211.930992755@linuxfoundation.org>
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



