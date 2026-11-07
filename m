Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060901;
	b=bmqK5vN5F0ZDzItMVUQvPQQX7ldCZBr02k/m6ExiaS8EuxSqHEHj2y0sGJPIYTQvy7Ru
	 MkfIVfbk3ZNOWe/othEVsHG2GajFL94hWbV8xDIaNIkYnnQC/DxgUA0RfPDr5OqGzYa1q
	 UPvQEKzpFEuseyXsRfQmR3tz2QX+XwcwH/tNGFBnHrX+YaWrpBWZ/xy2ytSIb/4vThenj
	 ldYadTziTuPqCb8ZgvyR90s4LzIjQTMOvAdpOmgOnyE5t5Xc3dmybU6OwEd2Rmacec0Tg
	 NjWirXe5+JhO9yRLyhP4l4+b5ws9CuLI9qcaoco8C0K/0heQzc3usmJMszrP/S1JZcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060901;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gV0oHmxGVWtUFUTTXcTBvDa70KfQeB2fwiCATf4ELM4=;
	b=ADDIXhq6qfKnV7M3rYzNF/QTxD0TLIMMP8QAxPoPiaInbIHQS0mU3UlWZ6iRTH81q6Qk
	 vjbt7m2MExrik4/cyRJOXZNpH4qs3yKcgWhl/EpZwPhBwWS3ogPWLyhaF1qxCnNKrTeB7
	 rCp8mGJHFabbBPBigRtIWNfkocMpU3VuL0+kVlgeam7Og3BfVS22JbWi7kpcbZKlxdwWB
	 2MNM2AX0KRh2OgLLaMkJa4BhbqxAksU6AJdjirsrqrAMnXNPnmbXGleegYRslH/yvce+I
	 13HL1xzXmqgcZ5fEUE6bpwEb0cMgPXCeQEnZ9ZhsCed7CqdQpwavJIvniM+AgHRs+TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOD3el1b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C91606D802;
	Sat,  7 Nov 2026 14:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZOD3el1b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12531F0089F;
	Sat,  7 Nov 2026 14:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060900;
	bh=gV0oHmxGVWtUFUTTXcTBvDa70KfQeB2fwiCATf4ELM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZOD3el1btrcWK62PLSxFu534cPmDSvv9A010z5Unvxf6prlHPdWji7NUowiznv0JS
	 we0pieIbs0EtLGpkqv1PDdUmt8rtuhLAma+kjRbcpWynZeUAiW6kYlbXzbVR8MPxx+
	 +Fls7UD3GhG7xMk/4H0XOVs97ik477kNiYL5cEoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0274/1536] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Sat,  7 Nov 2026 08:38:10 -0500
Message-ID: <20261107135005.370339393@linuxfoundation.org>
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
index bb02bc8962713..cde9e6a252ffe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10909,6 +10909,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



