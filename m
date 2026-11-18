Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043507;
	b=21xUvWEfVL0SOKNPD9h3kLYHJDBpmG0pJoHm7VjaBbJ+T/+8vvywVyWD/5yAbCB7Cuvy
	 ZCaAFVB9wpMdr/L/XkaZnfI5COk9GG2ctj1BR2W6TdLbrN7Tddct/r2UjX57qfzDdo8MA
	 dsKSP3NQyZPFVD76qF1p/R943SfG2oInnUHRAWlQwI/nmrXI2Ueeo4Pav5LzSI9rag66d
	 B9Ykd7F1jjS4ar0VV2ywZNzUUY+J+X7U4Btiv3Ay3IvQqTpu6kAr5A6+TXjiZDJ6CetLh
	 meK4RcH83wl0Y0lk903sakDYLbmcSfonr/AFVD6ik5MdxSYh8TlO/R3i5DRLKpngd7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUnVd+TdjphOIJ7rmhigM1javg5xPNa7cquhzrbwcWA=;
	b=aC3e0NZMuewy8nDS854A5RoziZg5bQepoC2vcDd3uARNjbLYflczmPgoms0+0p+W9vu/
	 NCHAfJk0mYhjqg4S1oyJOpQX5yYn3ZERly42i+CiYAZuTOyWw3BD9HQ80MODoOxaaDLgX
	 1Gmle7mOlwYAElmdYtqlwDtPdZehpYHpiEh0cKBBKlrDkRIBEVGzurUTw32EiGPeyiG/e
	 GAbks502+eOlVOwCHnG2hXMY/vCH8sxR3rvG0M3Vfpk8jrv6FL2whV8dGdJu09OE6Hzbl
	 W1O22W9aZb+85w4LzspxWy74kPiDOOUtCP3L5LXvB1FIQsnr8fhr7EdpIZAL0KqBnAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CuUqb6b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A52606A31C;
	Wed, 18 Nov 2026 23:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1CuUqb6b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29F941F000C4;
	Wed, 18 Nov 2026 23:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043507;
	bh=iUnVd+TdjphOIJ7rmhigM1javg5xPNa7cquhzrbwcWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1CuUqb6b8HNZ22b2Ojsv6xtNaiAmpMPp4pjwi97Ioi9uI4xHK2jdDv82BLyMkJkoO
	 bHWsBEhA1/1ExeSE4V7A7T71BfV3/pnF+MiUyvdOwGXGATL5WLe5HhuL9Ye2cDMlN9
	 q5JPTEZGkyjs6DYrI2dKxThHXJqQxygqPxDx5mkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0199/2857] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Wed, 18 Nov 2026 15:20:33 +0100
Message-ID: <20261118150208.518296886@linuxfoundation.org>
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

From: Carl Quist <equalizerjr@gmail.com>

[ Upstream commit eb2b516900f2cff6c931a0d664a625ee93855779 ]

The mute LED on the HP Laptop 15-dy0xxx (PCI SSID 103c:864f, Realtek
ALC236) does not work, because the machine has no entry in the quirk
table. No fixup is applied, so no mute LED classdev is registered and
nothing ever drives the LED.

The LED is controlled by COEF index 0x07, bit 0. This was verified on
the hardware with hda-verb: setting the bit lights the mute LED and
clearing it turns the LED off.

  hda-verb /dev/snd/hwC0D0 0x20 SET_COEF_INDEX 0x07
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x1     # LED on
  hda-verb /dev/snd/hwC0D0 0x20 SET_PROC_COEF 0x200   # LED off

That is exactly what ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 configures, and
the closely related HP Laptop 15-dw0xxx (103c:85f0) already uses it.
Bit 9 (0x200) is set by default on this board and is preserved by the
fixup's read-modify-write.

Tested on an HP Laptop 15-dy0xxx (SKU 7FU54UA#ABA, board 864F,
BIOS F.40).

Signed-off-by: Carl Quist <equalizerjr@gmail.com>
Link: https://lore.kernel.org/CAOtcGaxXndKxTK5MVSEcmF-LUy+V51K7fhE=qvLA+VvW5ZyCNA@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 68ddad4689fd3..5fbc25888f3ac 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9941,6 +9941,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



