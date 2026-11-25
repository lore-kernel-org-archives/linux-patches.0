Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618523;
	b=RA8xwVkrVPg+nzkdDhGh5OjOoNXq/tWUolGzPscDt0cds35/niQwqZkyGHMFpZZHlPPo
	 IUdRdIzx91Izqw7JR2jHf+F/Bouw+fWU1oE3Jm1NpD6WLEzSeyN5/4nW0eWJT5Jls9KK8
	 99dmbTjXNU/RO3N2OFglznfadv3/zaDykWxUwdy4kG8GVUA6u/R3WGCZwWsF/6kvC6u7V
	 MBd7P8bm3WabVjwlbSzAMGE44tQK8sRXtEu/nknb28f2EHym8DKgHCRhh4iMa37t0Pyiz
	 p055hsTdGH4tZWNcxZG3Ce0XKgPrd3pvbdksxvMEJbaaBG0PqDr0vVvorzCE09NGKng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeZTMD05UQG5ezNX9sLx5b8Z3inveNXJYYD/oVMxqhU=;
	b=Wcnd1bGKinJ0Hz5CTalcM2jGIeOryv3bFGWdRALDCtQfdMlqo4pjTiJywwJqNHbEAbqm
	 t8jF7rJrtlAQMUeEsRw/fpRfbC/GbBGl5NZ/l78FZQ6BFGCEM6UDEurTQ3Ih+GN1OYo3Z
	 p/ILKMeSJDluE/IGztdWJUNNH/FKvtpBTmtlGbOD0ttMUxZ0LOZ9RfbQ4+0Tn96c9/m31
	 jLHuv139KCUOcy7c6Wk+NwldQWxhxnUiqbrBgGuWtavLdS7bf5rSk37cvQOSf4LXTKwLI
	 mQF2+KVTAJqCLDLix8821M3lyXcescJpYg04Zw/C85peIwUnHO5TTd25Jp7FyufTTGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDZUSUaI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6100606A32A;
	Wed, 25 Nov 2026 14:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TDZUSUaI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D85DF1F000D0;
	Wed, 25 Nov 2026 14:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618523;
	bh=QeZTMD05UQG5ezNX9sLx5b8Z3inveNXJYYD/oVMxqhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TDZUSUaIyviYiUtB5xFMt1sCcUOaYT2jofR9u/kossWThirJbY4164qj48EiedFAo
	 07BVFnIUiN7gEtiGbAskJKdNJH/s1upBE28b2ua+2ZvEHwEGNXuJSdiaWls7l5PwGB
	 S5/oHuMZs/jDEjxIw5Mzic28+oEBVhQVD6o+aPYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0305/1005] ALSA: hda/realtek: Use inverted mute LED quirk for HP ZBook 8 G2a
Date: Wed, 25 Nov 2026 15:27:23 +0100
Message-ID: <20261125143828.880690821@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 022e9f8f094279ecd632b3846968790fad7d8ad6 ]

HP ZBook 8 G2a (SSIDs 0x103c:0x8f40, 0x103c:0x8f41, 0x103c:0x8f42,
0x103c:0x8f62) use the Realtek ALC245 codec with a TAS2781 amplifier
via I2C. They share the same hardware configuration as the related
0x103c:0x8f94 / 0x103c:0x8f95 models but were left on
ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED, which drives the speaker mute
LED backwards: off when muted and on when unmuted.

Reassign these SSIDs to ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED
so the LED follows mute state correctly.

Fixes: 9afbbf490322 ("ALSA: hda/realtek - Enable Mute LED and Tas2781 for HP platform")
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Link: https://patch.msgid.link/20261105025647.1116662-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 2c12ab2f8d206..a54cd3ebaa5cd 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7934,11 +7934,11 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8f3a, "HP EliteBook 6 G2i", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8f3c, "HP EliteBook 6 G2a", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8f3d, "HP EliteBook 6 G2a", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
-	SND_PCI_QUIRK(0x103c, 0x8f40, "HP ZBook 8 G2a 14", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
-	SND_PCI_QUIRK(0x103c, 0x8f41, "HP ZBook 8 G2a 16", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
-	SND_PCI_QUIRK(0x103c, 0x8f42, "HP ZBook 8 G2a 14W", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8f40, "HP ZBook 8 G2a 14", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
+	SND_PCI_QUIRK(0x103c, 0x8f41, "HP ZBook 8 G2a 16", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
+	SND_PCI_QUIRK(0x103c, 0x8f42, "HP ZBook 8 G2a 14W", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
 	SND_PCI_QUIRK(0x103c, 0x8f57, "HP Trekker G7JC", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8f62, "HP ZBook 8 G2a 16W", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x8f62, "HP ZBook 8 G2a 16W", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
 	SND_PCI_QUIRK(0x103c, 0x8f7e, "HP Messi", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8f94, "HP ZBook 8 G2a 14", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
 	SND_PCI_QUIRK(0x103c, 0x8f95, "HP ZBook 8 G2a 16", ALC245_FIXUP_HP_TAS2781_I2C_MUTE_LED_INVERTED),
-- 
2.53.0



