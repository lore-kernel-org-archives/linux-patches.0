Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034048;
	b=iDGuMsd70Ku+MOsAXFkoFFHgU/GAXE3UqjzLLYnFH09bGnA2JmJY7T97zD4RXVPG8WkS
	 o05q1GFCPae3QZoWYRQRf6SbE6I956XTN45qBfmPPUi7baDCCQxao/v0G0zqXTeUnOsNo
	 YfkCjDSaeO47GeZrBbG/c3LylT/awGcWiW7R6iddKWsUcXmUyxqaCM6H4gX4iIF8QB6S4
	 FlMorYpj5qistF2rTr6zGRkV22SbY4eRhCKnov34u6YOAqBqIPpqPlTNiWsT5CH48z4oJ
	 tdT5iZkhQoU4ubtl0JqOggZlHhMdSdvocVo1xh0r/RcTA9KprpGyhPoods2FTx7CXUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SZMEPbfO+majXVlGi4nUB95tTrZYpnrV03/7XC20okY=;
	b=BTIzK1ZJIraDn1hjVZ98TDfMBMjdxDcHC1OEFYKnmjN0QY1dpEQInAcBCp6tCD982OHN
	 i5SId9ng5a7uWZBtr4dOWi4WeGj7IMiT2yL7tg2BVTHD3u7jCf9WtGkK7ROxov1bDwKyT
	 RqpGGEJBlHQ/rOil7WU0yrNB1qHHhMUicY3anEuB+kIHcicPy0qTuqx11JM9RyvbHCNig
	 9RYpXsMdr0chkqIJIW60CywvcS1XkFCPjkZ1cRwG7rx5nhFL8x9QBu37c8c4b+1LsDkHC
	 xD3+vG8n74HEwmIBL2RigSmnpQZbOnqj+sI8/c7yQVhUNJbJuEccCkuJoRNUe30A0Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZI6Jl96;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756A606A331;
	Wed, 18 Nov 2026 20:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZI6Jl96
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4C31F000C4;
	Wed, 18 Nov 2026 20:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034048;
	bh=SZMEPbfO+majXVlGi4nUB95tTrZYpnrV03/7XC20okY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZI6Jl96z4QmGnuxI8lsos1CQiob4PuwM6BcfRFiyrMS3eNMpg/H7Xfe+w+KlAeA5
	 7BJn/6CJyA3vpvn3I69SD1IKSm5ljCHVAq6IG8npiu8Zd4YxRzhpEfc9y/bUBBIJDW
	 gjOoV4X5zdEFHDxks4uTjos3nrmLGyk+v46Y6Db8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Quist <equalizerjr@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0231/3318] ALSA: hda/realtek: Enable mute LED on HP Laptop 15-dy0xxx
Date: Wed, 18 Nov 2026 15:14:13 +0100
Message-ID: <20261118150321.999129075@linuxfoundation.org>
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
index 76b316fb1fcb4..77ef197d6ae48 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10127,6 +10127,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x864f, "HP Laptop 15-dy0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
-- 
2.53.0



