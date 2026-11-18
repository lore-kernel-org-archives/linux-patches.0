Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051544;
	b=3dvluv+mbgA23o9turiuChet+lwsf+HqBTt+1zXTaSp2msYohINtt+SGlSR+r9MXZREx
	 r+KaP+o8CPph37PbY1kk7agbfjViFpkzhJ/k5G2K0/wtgOO57h516fUxoCo18kxBAnFzc
	 MFL1CqdowTaobCrzqFzUjr/8l11V7D1h3xSvy9fz2uhH5hMfj9GXwkVTJ7SipT8Ku6+eG
	 PVpQdJUIRWYd4HUm3/SHdykJqUvYbWax5yv+1GVJLg0E11mn0zb3eKUJkIxVFxDI4ERUd
	 /VBFqazLSibCE1Nj33B8y5OkI2a2OFXqN9AaCw4tIi+XMKEGEn+P5GXRjppkXCN+rDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=47d1gd02S9tWcfj2FZusWYdwX/6sO9oOcYwMKNp+OIA=;
	b=lBaS6gNKDcrpGv2YvNP7j3ovq3ZFgSpQQEP9Sxv5YScKA+e4b2dlLQc5F1Od1/h7MZRD
	 aRePo3mWA4U+7VRsSgP49ar4799t23G/kPULriOFjfcjP+qGefDBkACNXyli843ha7SfB
	 2ztbdBF+oDv1IXlg4L6eMrrUjU519FIHdMsRYDlCUSo1IqoZx72/NjHkDlAv0iG5MtmcH
	 3y611Nk1xDTnj4CZSVDQUofMJr1QUCHAj+lKB9lF1GlqZFYOJrWgufGDi9l7/HBwMlfiY
	 CrrXb74Ym8u0jGS3j2/gb5uhDzggXdHmjCmpnbCiD8IGGxnr2APoDpPy+F8ixptjGaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3Kbgghg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09A0606A320;
	Thu, 19 Nov 2026 01:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3Kbgghg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1954C1F000C5;
	Thu, 19 Nov 2026 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051544;
	bh=47d1gd02S9tWcfj2FZusWYdwX/6sO9oOcYwMKNp+OIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3Kbgghgpoz6CrUnk6AkMg36jA7XgF0asfItiPNOABvSGoJYaJY05lr3wEBneevZp
	 8ZJR9X7C8mmfD5hDdBjkfeBW/C2T+xFYI47ytuYjGq+XYbPIIXZ4nfonPC15Zw6I/2
	 XnutQ06CBZRbZcEPi1k9YarfUYbbDvXFTLSAZL40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Bojanowski <tomasz@bojanowski.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0245/2214] ALSA: usb-audio: Add mixer mapping for MSI MAG B850M MORTAR WIFI
Date: Wed, 18 Nov 2026 15:32:01 +0100
Message-ID: <20261118150019.971610278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index dc2a5491e554c..dd697780cbfdb 100644
--- a/sound/usb/mixer_maps.c
+++ b/sound/usb/mixer_maps.c
@@ -633,6 +633,10 @@ static const struct usbmix_ctl_map usbmix_ctl_maps[] = {
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



