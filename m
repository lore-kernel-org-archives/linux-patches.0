Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061114;
	b=vBAJNSijQL29TC7H27FdU2OJQu0UDmRmpMmirPiRUjlpA651zyz0WRZCSJpjW4MUJht5
	 R1nrRFgXURKf3QqCSs3coaxZnEfab9witA53tAhfY3NMiQ7q3Gy9gi2pcZm+9Wd+Ivzul
	 PDr8wVwjomQKOqD143LhlVe6++8SGtPQy44QDLnsojV5JN5/M44omWfCOaw/7jRDUOJ8u
	 nmUfNPOjJkYTAtGRDp5kvch05Z2bOz9NxHqLFVWU+lZnP6MVCrSuz48+UZ0BEbRcVkVUg
	 xErhKSBC2jqqd/dGBg2CkMmdZX9w5jWimQp15wZJ1IEm5mo0qtyDwW0OgrNN/6A0ldw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YuQ4gepvSCSP5V6Zq/SgzO8qlbIiQDDwmg9p864ZkOg=;
	b=JBr2SoJ/3HU8RdCATMJvGyS1a53y35rIJaoQILoiEw+Y6QkIlVaqh9/06EysRN2BI+6F
	 F4qDWiVK6deD1e1nWW5y6Y9C+L6XagNEQt72UEeYSIOmDugmPKrFF3Yk0QJ0E6oI0v9p2
	 hDS+KGvzJi44ecT78G9GVf8SaZa6USczvd1qnDCYlqvna5jxrS3K5V4uGAdt77t5g91Ve
	 3gRx34GixDJEOKXLVBPyy9slugQHImX78jU064FbCaFw/UpQ+503V+s1lFB685W+Iumc2
	 VOWUIyfXauIGXK8+YwUMf0qI5AnsOw6/WNGQgp8phoZ14ZfYV88iMFa54ZTdBjb0MTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5TaVlWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99533606D806;
	Sat,  7 Nov 2026 14:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y5TaVlWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A711F0089F;
	Sat,  7 Nov 2026 14:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061114;
	bh=YuQ4gepvSCSP5V6Zq/SgzO8qlbIiQDDwmg9p864ZkOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5TaVlWEWvvtPUSK0hZa+VgFsu4EbTmHvspAFCJDgkPWyt7N2ZoNwD+jF5M/8KE/D
	 eydgEN78dVWjsCYssuc/30RiGAvh9R4F8wfgZsdaifUqMcXTyujGGc+U2NxgpQlIKL
	 bLD8fmUBxhMD3JZvAqPqb22jLJ+IAmBM/TtxBqzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0413/1536] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Sat,  7 Nov 2026 08:40:29 -0500
Message-ID: <20261107135009.171621971@linuxfoundation.org>
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



