Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831081;
	b=aK8erJBT4v3WsTvSbOD2Ou9u8tsdharE55q77pfeqHyoFp7LTybyXniFR8e3K9hvxwRL
	 rrBf76cZQkg3941DXqR0boyRQfWKxhuVCl98n2chTMR2VpFedoTBnk3COCLk7uS3mTBY6
	 KFhmoFy/A9H7IaZxTouoeojsbpvnBxP/JCUUGYuxw46SHUJ2qXVGH5ur/zivXfNXp6l4m
	 qGUgP6vnylQCnOd6n16FEXlZSkWmTpLIst6mVCYROcZiNNRSw84FTUFSpqAWxUWps1aV5
	 MDSHINkhILGpcOx4/cHUYvxeCUMVm/PzoFLTzRLUhL6a8lBK2eTNQOMZgWRG1vMKqvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831081;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i2Vkh5d+WXgqP6SVknp+CFvFXs2jzskbCK+3EzVny84=;
	b=LTUctB5E62FhAiHKoL50vsZkwqAX/0TOq3eDrkuAuAakec1JDvd0C417jmUWXfOC1N/Y
	 C8ZP713Txu6tF/u9Kmb21Qe/MbtbW96lD7dIJMCTvb3QProtM7TyTZ2QBa4pt88kpvC/D
	 jZE2NO0Pl5jSHIv/KeWwmd/Vsm7MDFGol7PWP7BI/fFh6oRfeOZPU2PM5CR7V3ylC/TdP
	 ZJxcvx99nrvgfQJrzuD9ANba6motPo3vQC/F86WHWlD/fTzL1uarT77frDO1VR2SORCxS
	 mhnx9TPhWOydq/gVqyaZroFUGUop1XYZlq1wY278jIqwAi6JLySC1fN0Fce74NDEluw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFLFFsQL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B7B606AC29;
	Wed,  4 Nov 2026 22:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFLFFsQL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3B61F00919;
	Wed,  4 Nov 2026 22:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831080;
	bh=i2Vkh5d+WXgqP6SVknp+CFvFXs2jzskbCK+3EzVny84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFLFFsQL9VK0PZiinG1sqN0KxZwR1LOuthU17LCbCJu9Bdfw/UwsT2m6fviRGRxFh
	 /bhm2CBNeUwUCEOfdrBYLU0TcDTs+PX1njq7xrJ3rULfvkGGKZ7YgDeBRoM7mK2xV+
	 KNVP5Ej5YSxNDwwrVPFbugaNq7QbvIu5iP+bPL8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0493/1005] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Wed,  4 Nov 2026 16:03:46 -0500
Message-ID: <20261104211057.775153860@linuxfoundation.org>
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



