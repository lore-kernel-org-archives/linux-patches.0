Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063465;
	b=Jce9iQTiYS0zGo2vuu/AcpRrrDkd5cu96MZV1cXUDLwwWy8QdhOiVR6p7vNHh1rIX0FK
	 YwgtolXVfaxSCR/wFY8v2dZmkptQcYMCOR18siTD+N6YOyudan06XxJ2MIfWxUYwxtvYW
	 OT+LO5LurDXCiogyVHg6wOrP/iT55s2n3WOrAhw6ex+eBJgyiq6vY+8bqvSz0Vx3fAHMH
	 1pZswV+AedYr+fJRQhcRCGrk83Al3y+4xm92OiEI9gr+rkPYwWO58tAQ/tVgg0lZ/qsVj
	 hwlroM4xL/aL5a9QvtkmBjPu4Jdd12xcU1Ivx0efosg+gRPztmtER3ICDIZVesMLVJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pf84JONHB23vDlSgw06UVAu3h9c2MPfIIwgQslG2x60=;
	b=G9CHvB+5maeD6S+A5XVw4+mNBy9Kn6jMYf9vyxATsO20Xs6tUqvuO375andXGkqFagbp
	 XfDsEuxsVq6rnp3P2zGzyt+g8xhu/ZZKZs/2vbkeG6b59sLh7a+HwVGdOYOOgVs2z8gjA
	 WEvKBc+YZ4zP6Wmi0tyVVD2WTt8LmSBYIAYIIGvdHFvl7xHyoZZT1VIkZNeRYOP0DUvCv
	 IN20iwlmFqulTXoxpZ3+rppVW3sEcjy3j8fEsQtRRN5c61qaAHUIkNc2ej/eX28aT08D3
	 vqwqpgFgVmVzZktSsi4MXyuBBwFeifTiEyXNIIeOcOqw6pfEveiK25gl2s4ArK+U8NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uqhw5DHX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9CE6082BEB;
	Sat,  7 Nov 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uqhw5DHX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6809D1F008A5;
	Sat,  7 Nov 2026 14:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063464;
	bh=pf84JONHB23vDlSgw06UVAu3h9c2MPfIIwgQslG2x60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uqhw5DHXWGTwnxtRVp6H2f9RNmAslXbAtxCwP48Bh2jf5IyU5yZgWiTjEEEyWI5RS
	 rFpIhLVXuEds0cfQDGQlAKr8ST/Or/pL4vbU1aYWlLVqJFhvKfBfz3eft0mf/Rs2OK
	 FXf5ZWsN2Ur5WWaD9LH/2Si0sliyZoGeAlgtyoTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 619/869] ALSA: hda/realtek: Fix internal speakers on Acer Aspire AL16-31P
Date: Sat,  7 Nov 2026 08:55:01 -0500
Message-ID: <20261107134914.026458445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>

[ Upstream commit d933955c456e0573b40eae4f72a3af37ab1c15c3 ]

The Acer Aspire AL16-31P (Intel Alder Lake-N, Realtek ALC269VC,
PCI/codec SSID 2782:1718) has its internal speakers wired to pin 0x1b,
but the BIOS marks that pin as not connected (0x411111f0) and only
exposes pin 0x14 as the speaker. As a result the internal speakers are
silent while headphones, HDMI and Bluetooth work.

This is the same layout as the Infinix Y4 Max and MEDION E15433, which
share the 0x2782 subsystem vendor. Reuse their fixup, which configures
pin 0x1b as an internal speaker and limits the internal mic boost.

Tested by booting with snd-hda-intel model=2782:1705: the fixup is
picked, pin 0x1b is used as a speaker output, the internal speakers
work, and they are muted when headphones are plugged in.

Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Luis Gerardo Lopez Hernandez <gamaerry@gmail.com>
Link: https://patch.msgid.link/20261017005039.9139-1-gamaerry@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 03265550c0eef..c81ecda4e7b6e 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7723,6 +7723,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
+	SND_PCI_QUIRK(0x2782, 0x1718, "Acer Aspire AL16-31P", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x4900, "MEDION E15443", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x2782, 0xa128, "Positivo N15RPE-S", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0xa212, "Lunnen Ground 14", ALC269VC_FIXUP_LUNNEN_GROUND_14),
-- 
2.53.0



