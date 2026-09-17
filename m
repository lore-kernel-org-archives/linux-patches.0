Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13373207E00;
	Thu, 17 Sep 2026 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664875; cv=none; b=S8UeNpfh1r3B1cjAIMLn8yE+xSm9GKWE/33uD94u50UlmK7Ol/SCgPKBwNAgULuiNVciixpNVfgdT38uzp0Z5z0dKKLOcjKqtYiBmB6X01Kmu0oG91OleWHQ4VNXn2p/201+lJHLlX4fveV73hKzTfkH8KB3ZfOg2DVi2gfc0iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664875; c=relaxed/simple;
	bh=i7+TPYF5jCT4ewys/2QPzIY42IBX5oH7DjawHLXKg9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cb9fw+GH6AP+M16I+fzGDTsIIUGU1Xsn70JGB0ZOLUrDmGY1RwRT2TcjoygTGJu4fajUxX5ku0N2gMkUxxAteG7zjIMmJxfrXsQu07aDFkNNaSKJBCAs494sHbEFZ27l6WKPVcCJN4voi2+SBcl1Dt2vdUDX7Jp/0Zu3vZAntYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTS4iTMp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTS4iTMp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B541F000FF;
	Thu, 17 Sep 2026 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664873;
	bh=7Z+OoZrhRvQcil+9GIPBRuvyqLF8mVtwOFBcco8Iq+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTS4iTMp5si7JZRQqBPIUu7UE5j+6uk93GxR+Yrx9eG67rENkK9qJMprhrF6sS56o
	 SxvwdPl+92EF0Yw/KaAXhINPPXMAXsznZnohrFRHqv8JuF+OdfKtfGTjU1OEE7tCIP
	 mUcdJtzfDfZfEHWKSqCyUjkKVz7JgU0Mi2Javk3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubham Nayak <shubhamnayak392reborn@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0479/1250] ALSA: hda/realtek: Add quirk for HP Victus 16-e0xxx (88EE) to enable mute LED
Date: Thu, 17 Sep 2026 16:04:34 +0100
Message-ID: <20260917151604.951487266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubham Nayak <shubhamnayak392reborn@gmail.com>

[ Upstream commit 6c18817c01f6f76d9e2739903abde4d69397f2c6 ]

The mute LED on the HP Victus 16-e0xxx (board ID 88EE, ALC245 codec)
does not function by default. Add the ALC245_FIXUP_HP_MUTE_LED_COEFBIT
quirk to enable it. Tested on my HP Victus 16-e0xxx with kernel 7.1.2.

Signed-off-by: Shubham Nayak <shubhamnayak392reborn@gmail.com>
Link: https://patch.msgid.link/20260629-hp-victus-16-mute-led-v1-1-ab0f4a8a533b@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 90e64fbd5291b..f72fbdf0a91f9 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6807,6 +6807,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d1, "HP Pavilion 15-eh1xxx (mainboard 88D1)", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x88dd, "HP Pavilion 15z-ec200", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x88eb, "HP Victus 16-e0xxx", ALC245_FIXUP_HP_MUTE_LED_V2_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x88ee, "HP Victus 16-e0xxx (MB 88EE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8902, "HP OMEN 16", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x890e, "HP 255 G8 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8919, "HP Pavilion Aero Laptop 13-be0xxx", ALC287_FIXUP_HP_GPIO_LED),
-- 
2.53.0



