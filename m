Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831160;
	b=CrgHg7WzPD8qE2Gi5RTDHedJkIfeDlNRj1xtyJXOftPL5Fu0pDWH06HMCehVbr/9Gh2/
	 aTbkpxWM/JsI3QQ/hYLBKCX0zTFFQH4sat+T0Cx6NiZhSIXqJAZUETw/6Q50ciRI8jlV6
	 2mGOUlq3C2CfMQsFArT6mZMIa6NiHNumbOIGPGL9I5Vj3nKmeaklmSt5aZ+YB5i5ds/7v
	 SdnxzONRqlDPtdt07Lmg+1NaIjYWbBcSos1GUuWmaBgS0K99XNCXnOw3Vv4O4bRt/Z6x1
	 ToHAYpurJI55Z9i8tCjD7vgVstqoPXNx1Ba1ukr/+QETZNM4SX2bh2C2DsSapv/9lgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c3/9R6CcIUabrObCmnWj1ouQQD3B6I9QMSYs9SJk/xM=;
	b=FceIL/JnxitqGIUBDlKicjaauR1yWWuqufXAvf8C1g6yNvJsKXpwuLtKRrgRPDBsrUu9
	 xZx8BCgJnmPCHnktPXAZ8AjZAFkKjPQY4uQsVtub+nTYp65ZlIuT1Hl22cHHagBpUvJ+U
	 pfkTrpd9QvmyAwFbkF2B3lvC1w60UOfapdE1mc1nrGpNBS4F3S3JXCtvyuvpc6Fg35bes
	 rn1NAdIKlMwBpwXh/+IYsA2hrmM2K6rObUs4FcUn3zsLV150M8UXcP6JZLz0UF5iyjRZQ
	 8J18XAZjOuxU84i2dl4k9BJnN4x74cGSwkHu3SsoK7KPXME9HzVwwvJmjhb8dBcXXVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KVG/NmIh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4E5606D82F;
	Wed,  4 Nov 2026 22:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KVG/NmIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DEFC1F000C1;
	Wed,  4 Nov 2026 22:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831160;
	bh=c3/9R6CcIUabrObCmnWj1ouQQD3B6I9QMSYs9SJk/xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KVG/NmIhJ9+IwL3TUDdm0MdHj2EbDGLiFZzTzaOyXi2/kKE0J5+LajEOQQSlPLg9t
	 6L5ZN3ayp646NNLcW+KBb5/iN+kvBoJBU5sQRPq7VpXxRy2QUsqaq3k8eLI8HfCG7v
	 4Cw+xZD/RnBzhl1zXAbbwSohQ8HiK7QuMG7QAz4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaidheer Sirigineedi <jaidheer7@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0507/1005] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg3xxx (103c:8bfd)
Date: Wed,  4 Nov 2026 16:04:00 -0500
Message-ID: <20261104211058.140962526@linuxfoundation.org>
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

From: Jaidheer Sirigineedi <jaidheer7@gmail.com>

[ Upstream commit 13dffca9043500ed6033d770b491a043fb952bc5 ]

The mute LED on the HP Pavilion Laptop 15-eg3xxx (PCI SSID 103c:8bfd,
Realtek ALC287) does not work because the machine has no entry in the
quirk table. No fixup is applied, so the mute LED is never driven, even
though the mute function itself works.

The LED is controlled via GPIO pin 4 (mask 0x10), which is exactly what
ALC287_FIXUP_HP_GPIO_LED configures. This was verified on the hardware
with hda-verb: setting the GPIO data bit lights the mute LED, and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_MASK 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DIRECTION 0x10
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x10   # LED on
  hda-verb /dev/snd/hwC0D0 0x01 SET_GPIO_DATA 0x00   # LED off

Add a quirk entry for 103c:8bfd using ALC287_FIXUP_HP_GPIO_LED.

Signed-off-by: Jaidheer Sirigineedi <jaidheer7@gmail.com>
Link: https://patch.msgid.link/20261002185951.33855-1-jaidheer7@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 0bfa64bee9d3b..a25c92834e722 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7010,6 +7010,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8be8, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8be9, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bf0, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8bfd, "HP Pavilion 15-eg3xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
-- 
2.53.0



