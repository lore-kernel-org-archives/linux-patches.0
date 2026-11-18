Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051446;
	b=rp6OUStxb7MY9eVJ/UXIi3jzKfQZuQWquf4oz87ltAfdB/TU6N8N6J5Z9WCsFExfn7Ya
	 4EojXekkTrvhs0QCsZlbmZqtYsMeDIa6LGHcTU5MFlthZUJRAvDCuJtiSKHfCQl9DZp5A
	 rcQMYeUzQAT1LNcUqwA/Gxfwj2aG6m54V9xi1SSl4yjUCUsgPR5PKeIStl+L6sWvFAlz4
	 Qwx05BVDhRhtN7FXcfvd0GacIoDgLIGygYle42U1i9ejbI1QMFGhgXeviiNC6zTmbbJM6
	 eITQFpJD76b5VxEsARzEjSbVam4sbW1+5vrFc3Tdk7TLba60eXsryBDMipJ8hvuZ47A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdN8yNXzHC8ft5W4uqypifshmmshFDrACqEbOAAfCOA=;
	b=3435PsdXE7bZ7QR4FY464NCFen0DNepQZtBMCqlBiarMdlsEwfXrv8ktVpfHReV1f+SM
	 KbYLdmC1uPXVBwT14Uex6QJFvb0l0BWJIlJkLHuUFRypdJAfbHjG8Y3LjlIa0meLk8DEQ
	 3n3aos4DQMWLcy8r1Gby01DQD3q6XaOjePLZKDvsNrsy4z7U2xoG3eP6/xcHCGvP7RSPj
	 heX6SkAx08xugANT0ucC4jHNSPuPcsH4+9TBmXnOabXaa/h0V/IHAwZVacYFVLTXJctVZ
	 biHaFiPNLqDjeIB0Mwpb6y6tStfiPN5wQjUPgekF8LlYFuF83LQjUoIDI3zxdQli17Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BotcLGnY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB44606A32A;
	Thu, 19 Nov 2026 01:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BotcLGnY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F8A1F000C4;
	Thu, 19 Nov 2026 01:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051446;
	bh=DdN8yNXzHC8ft5W4uqypifshmmshFDrACqEbOAAfCOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BotcLGnY1weSK41ZL2Rewwiqvi+ECZuaBwxHl/dCQEjtBCPrzdPLIRSAB7DOx0CEa
	 h9Cn7Eajc6wBhMB5QJx1h7RxH9ilOZnOtFtFrl1JL6UaEFHb+e4kcSLjzfi7un2VRG
	 AT7L1VCvDug2pE7otHMAQRRvZnQ+YRqNPv4q9wY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0177/2214] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Wed, 18 Nov 2026 15:30:53 +0100
Message-ID: <20261118150017.134056274@linuxfoundation.org>
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
index 207aad871e320..96277713335cf 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9332,6 +9332,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



