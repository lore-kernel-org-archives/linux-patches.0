Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625026;
	b=DBxircKGpPLiI08rZy9TnGLPxgHy90q2WRqoQLpAIawKfgiJpmAjuVVRrMfH+/hIy7mY
	 yB21tucoGWnvdD6zUJcaWWrpwL+lFOM3M1WEhyv+D0OZDzVp9QBsKcWTtkOoXapSBosww
	 ld1EHBCGJ+CiQ29kH8Y2ZopXww6zHZCYTxxBdmDedg/i2f0eheQ0wOzmOSzphV0TMlfYz
	 M8oyhJ0kBjXZ0QRXNG4CmdfqAvCEFbOhhAlVTjOxMaddSErwh+s+j1uio4G58qoP6843B
	 sIVRGvFcvOyFHFKQ3/nueswsHoLAI5BJrbrQjhf+Q9E7iKOq8LNkkQvHvqdR0TxF5Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bSJjW9s5SV55+D0VDHlgqJUQ8Bl+sBpEYOPfk7KANM8=;
	b=Po3ktcDx3TSR061YX5ncMqK1NIzPIUIAYP4AQssz4IhZgJ1P8uacJiQv/QnYQm9k+sZS
	 sk8dDgoVwTLGqUgYLwqu0PDEqsEy8sKEYLiMmhD6DmvlrFBh4ZC7A7bOrFcuKV/PK2Ikn
	 Osc+EeLi0catdiU6TmKel62Vun6TeJxA7Vn5co/iEPaqpJ3en9Tz8YWB+MjwiC1SGH6Vj
	 YownXsrWepWlSa4k6932VbAw0mNhHxEQtrAWyTShVKRLcr/NEv20+m5N8M9KOvs+GNdRR
	 b7YlYAE5xXEEIA9Hz0+oJuRXjkk3+aCfTpya3esQD885zGBjhV2tX4T5beOiAkBaTzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rW80EjwE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB18606A31E;
	Wed, 25 Nov 2026 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rW80EjwE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E71F000C4;
	Wed, 25 Nov 2026 16:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625026;
	bh=bSJjW9s5SV55+D0VDHlgqJUQ8Bl+sBpEYOPfk7KANM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rW80EjwEmsNfuF2hFRYe+l2mWKJdPOokygcVAkHQh9ch04S/cbp4+rkcqDnnR7L1H
	 uBlHcToBsfGP/F2kqsi5SjmfeJ4IXthF9/DRzrKWogBaA+x28O3Wlj42+I9eInVXzz
	 WOy2AaZ+KQrheWbnH+80DsqI6rV/Z3n5hNysDO8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandr <youdoit@mail.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/816] ALSA: hda/realtek: Enable mute and mic-mute LEDs on HP ENVY 17-cr0xxx
Date: Wed, 25 Nov 2026 15:32:11 +0100
Message-ID: <20261125143858.071135162@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Alexandr <youdoit@mail.ru>

[ Upstream commit cf79cc4996bf936fe159af2a600519b3ebd4ccb7 ]

The HP ENVY Laptop 17-cr0xxx (subsystem ID 103c:8a2e) has mute and
mic-mute LEDs on the F8 and F5 keys that never light up on Linux: the
existing quirk entry only sets up the CS35L41 amplifiers.

The board uses the same LED wiring as the HP ENVY x360 15-ey0xxx
(103c:8a31): the mute LED is driven by COEF 0x0b bits 3:2 and the
mic-mute LED by GPIO2 with inverted polarity. Both were verified with
hda-verb on the actual hardware. Switch the entry to
ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS, which chains the amplifier
setup with ALC245_FIXUP_HP_X360_MUTE_LEDS, and use the DMI product name
of the board.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Cc: <stable@vger.kernel.org>
Signed-off-by: Alexandr <youdoit@mail.ru>
Link: https://patch.msgid.link/20261103142121.74032-1-youdoit@mail.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1a68e683801b1..bfc75a1733fb5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11089,7 +11089,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a2b, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2c, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2d, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP ENVY Laptop 17-cr0xxx", ALC287_FIXUP_CS35L41_I2C_2_HP_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
-- 
2.53.0



