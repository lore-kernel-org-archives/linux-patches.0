Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829772;
	b=ssONpYLL6CHcPkdLMpig+th56F784jgrBZ/a9dOUW3YmM53HzpGqqCBYp7j4trGXNiMG
	 R9oy95TYZHdRaApWebZNwM7bBHHfL6FVHohNlGHjm0KlmLDd+OmqadxclWp004naHgCdI
	 1Y6J/fBQZYIJp3sODpoTBPcTei53bxntjW0d0e0w3K57iNSeYSIWvOc8GtW4/8QtcLkY9
	 gxehtm+qWOZjWzQbDkhfB6gr2TPwrYZQfc1gYySMtze6JkJYw1jIN0G7BkdNa4BsWyqlB
	 d3d2AQuaONFSLt4HAC8vwyCjNGkeYqAUh7rxKx0WzYNeHLGcVHNs0Jmq64cDquTFr9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=181VP/ifI6V+GnG78xTDIKQQ1nurqupUs+sm/Wo1S/g=;
	b=GiyWtAxMgwA9QdqujdBBROlP7W/FpSH3IyObPUNUV7GRjrgntfEoWQtVwzMoHwC4xHtH
	 0bWHDocfrcK2ZTffOwOL29DdUoG0y4eWyJ+p+d28LOLDCG52kGtQquOtlybMATU4aj59i
	 TxnuWoR8dS5LBN29RFN46AUs5HgDXgTn3N1O6iNU029TuJ2JhzE95Pw+OU3R3nTonh3XC
	 D/9y23TzFwJqQgPRQXOq6Hyn8wfJf7vV+vqIYt4sbdx2nKOK0g7E6urP433jn4M2NeYoo
	 iho4E5lo/y8gttDOxsQrkmWg+enBD0N9XRIlSoErLbs+e6cchVeRpNmajOFcbYDcZ2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n7/DQcPU";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5FE606B2E9;
	Wed,  4 Nov 2026 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7/DQcPU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0091F000C1;
	Wed,  4 Nov 2026 22:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829771;
	bh=181VP/ifI6V+GnG78xTDIKQQ1nurqupUs+sm/Wo1S/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7/DQcPUTAOAhhdGA2bQLQjASSlKO20gXQyAl9LHOSIqQvPc1xkdy3CqvtFIgXvHG
	 ADEoSA6ybYx1oSFGEI1A34GoOMci3BVzm7aQR9aFBH2RsuMS1TE16rm4AyyCd5xFqx
	 iuz7kja51ssHxj831vCRdW3Kf6csUpN9UBzLwC8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0330/1005] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Wed,  4 Nov 2026 16:01:03 -0500
Message-ID: <20261104211053.197142257@linuxfoundation.org>
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
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 68d5e5aa7f62d..f2b0eb8501a78 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6772,6 +6772,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x860c, "HP ZBook 17 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



