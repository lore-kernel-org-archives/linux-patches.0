Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061007;
	b=Ne2G3Tg1okLFhVRFCsEj9Ntl1PXRlMCrmjPiUC/dHyKVEzgpuVeCI802KS88mOdcCl0k
	 wfAQn9xIVtvOR4tamU06R62E5HRRWp1wzjuQcqfV0RjS4O5WEx0I7Blhbg4hEED/tdUUx
	 3FzfFetzWiYOkT9cOIA56sMVEFfcWrQCci4FEfea/Klxm9erd7l5FkhS1gAyT9rEy70OT
	 tplK4sSzs/y2clx40vUnYH6bKNK9jJuFhp+DtWQoWgqWxZcro1WqwKhFHbiXO6H3wAinM
	 xmJwOrWbwTgHAO9mPrcL0/ErQ3HpeFjRItG/gh6UsX4Ywa3M2dgexjbGLFW+aUoiVdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wqTxlPkHjfL/YrrDyq1Mg+WW+9QSceTxHeYySFv3Fl8=;
	b=PnZaklPX68Vv5hOSOcBNu1m730K2QucpJCqLuW8PkU2sObqIvH4Yo13ynJOv0HSyOZM+
	 RpcU4SWKmJiBnmlAZEONwCVLi+CK2+MyY7QLE1/oLdhgrckNQX1xjdhU9Wvrqi1M6w3wP
	 Hg6PjJxG+ZMf5NvxxCuupywFbkxwTgKH+sNfj/OyFizUidGEp22nCxIEZdVs0D4Rc+WnV
	 g7GQegnHmT0zfn32A0P73V2+Q6VcuGj0LuDijZTewXrljc2nbIwm/HDaLj4FQDM0n3zjB
	 ePgs4TLDk6bYp6Z3RJA3rFVs2dl8syP66wpCtUNsLw160aO6VE3u+cBaDgq7DtBCuTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXfqNZgH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6000606D810;
	Sat,  7 Nov 2026 14:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FXfqNZgH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4283E1F008A2;
	Sat,  7 Nov 2026 14:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061006;
	bh=wqTxlPkHjfL/YrrDyq1Mg+WW+9QSceTxHeYySFv3Fl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXfqNZgHu56t79ILeRyvqdOl3wpDGHx+n0dDRCs3ylKDfeq9SN0Dag8XBBdqGFC03
	 RRtvLGWqlofhX1tWmGa0ybdaxcZU3++SNIr5wFT+TY5RG/uLv2fzguJxBTQtKC0sXI
	 x8F+cXMvvbTN9RlotFUJ9ZUMGMqPUJuOQyw9P7O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yashraj Ghule <yashrajghule.221@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0350/1536] ALSA: hda/realtek: Fix mute LED for HP Victus 15-fa1xxx (MB 8C3F)
Date: Sat,  7 Nov 2026 08:39:26 -0500
Message-ID: <20261107135007.505278468@linuxfoundation.org>
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

From: Yashraj Ghule <yashrajghule.221@gmail.com>

[ Upstream commit 19b02fecd8f857909af779afe3816e487ac10cd0 ]

The HP Victus 15-fa1xxx with motherboard 8C3F is missing the
existing mute LED quirk for ALC245 codecs.

Add the 103c:8c3f subsystem ID to the existing
ALC245_FIXUP_HP_MUTE_LED_COEFBIT quirk.

Tested on HP Victus 15-fa1xxx (MB 8C3F). The mute LED works
as intended.

Signed-off-by: Yashraj Ghule <yashrajghule.221@gmail.com>
Link: https://patch.msgid.link/20260816110655.11592-1-yashrajghule.221@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index be165a9ae674c..583dfa32f49fe 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11100,6 +11100,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre x360 2-in-1 Laptop 16-aa0xxx", ALC245_FIXUP_HP_SPECTRE_X360_16_AA0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c30, "HP Victus 15-fb1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8c3f, "HP Victus 15-fa1xxx (MB 8C3F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



