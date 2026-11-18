Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034554;
	b=JZRt6bwdGzS9O0wIXBViuVKe6pEq0VPalVo1B8W41u5hR1dHcVRMYs/x1d/tXtJv13pc
	 /VP0PVIi1wUJMaeyxcF5AFkO2ZAgw+vvKVs+F+wUuhxYmEl5F3zQ/4be3vDzgMOOgclm5
	 wpPhfhF4uAj4Pan+3++lazaCblVDUxpUwwZ0ByeAA9YD8RcxoXs/VvAC+rtZakXoxY3Xi
	 wF/Y/xCMZrGlP8WoX9adON/UhC0TDDWeuFxdXqqjGRg8tdpct7QMEjFU8A1lP18BpmhjQ
	 xmpyu76nrUGLz5vw2eyR0Wlu3ivsp0I9i12abHZNKdwfmK2GEZq4p+o5xxhgsidPbwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034554;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IfA86APIZJeM5JqRcvim0vieD3cpSKCRSGnGlMobJVE=;
	b=bj7NtM3pOfVPJs8aGz45PSULCj2r8nXt1qxeYZXYalW3fyETct/4oy6WGrQoXP/Yd8Pw
	 06X1UqytgVBw3nogK8qr+UGXId7e+N/QUIjUmGU6LTQVmkoAvU7r1r79+i3cBjOGLv1GY
	 gd7/iov6Ny7JkO7YiQROEH4qy5Vq5EXPehnM2gw6FmrKcCiLBl/QU4HtwYN9sWQbEqA8J
	 UwF7ocuNK6dT9vEcHL7E27Vfx+U/cQLj+5olOwkcYPrMw8Qb9prog3/NiacueXIgr1R+G
	 heOKr1T91nglOWVElEmYT7GLC9pQuhXHddfmhxruCOZTmODPKBSnZdhf8GDTehPTucg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wLcnK//5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B69606A32A;
	Wed, 18 Nov 2026 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wLcnK//5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFE71F000C5;
	Wed, 18 Nov 2026 20:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034554;
	bh=IfA86APIZJeM5JqRcvim0vieD3cpSKCRSGnGlMobJVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wLcnK//5nM3ZzMHjzEznskayO4qaFwRP+WagSyHGs3SO8NcCiVG2ZDMG6hkAL60GA
	 x9U3/4a7qeP2xocaAuALGZBD4i++p9GfMEKkznYYUdW9eiDJxXvZbWYhyAgtAgToS1
	 bFocJvPZhHJgkelr0690FbvnhzEozlw7yApPy7yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Batishchev <ii343hbka@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0410/3318] ALSA: hda/realtek: Enable micmute LED on HP EliteBook 6 G1a p/n: AD3Q9ET#UUG
Date: Wed, 18 Nov 2026 15:17:12 +0100
Message-ID: <20261118150328.781871708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Batishchev <ii343hbka@gmail.com>

[ Upstream commit e7da28b820d12927de30abf554c727a319f80359 ]

The HP EliteBook 6 G1a (SSID 103c:8e0d) uses a Realtek ALC236 codec.
Without a quirk no fixup is selected and the mic-mute LED stays off.
It needs the same ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk as the
already-supported 14" variant (SSID 103c:8dfb), so add it.

Signed-off-by: Denis Batishchev <ii343hbka@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260810151440.2306217-2-ii343hbka@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Added the same HP quirk line to the older file that holds the quirk table, placed by SSID order because the upstream context entries are missing. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9a57e073fab11..d375f0729e652 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10329,6 +10329,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e0d, "HP EliteBook 6 G1a 14 (AD3Q9ET#UUG)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
-- 
2.53.0



