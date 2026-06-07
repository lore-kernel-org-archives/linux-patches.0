Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3834EF04;
	Sun,  7 Jun 2026 11:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830017; cv=none; b=TSoKrmiYwQYqjlmSosBy2eTWTwKV5z0Yy5nYP56SxPydZEBNDtydFC5Pl8OawkcsWZfdYl0XKOvgbHVJXj9sxtDhS2fVorQv6VroiFotOFLw4hzm9GBdfN+GmHiPTFp4cb1tbaIYpeGiqZhn4ukNRWZsEitOGWh/9rQ4AUk1d5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830017; c=relaxed/simple;
	bh=2MAVcwPn46Ds7I+3S8Nvglb8zyBybs+g6M4+DzNY/7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBVeApbXSXE1D21Z5CrLP7j1sMhhVDc28Z0sGushhuD30fQwMFfBlzPeznnTWdV114hXPRuJOmYHJ6SNIG9qJXHfhVgChtlOcsgNKjS7zqa/SFrCc4s4GVP7nCeNGFr/csO8T3SoaDdCTtOKbdnOjJbhbfe/g7BsMsfcgzk8UZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fq58Nd44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fq58Nd44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706161F00899;
	Sun,  7 Jun 2026 11:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830006;
	bh=RQSFQ1r9efP8M45KBS3dsUhKmc8xnYzpFC7R51tFwLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fq58Nd44euYSz2Yb3vxuN5erWfR0CUOW9q/gT2Nwqqw1OVrn3k2DERuRJc3vxtIs8
	 VGjmng+N4rRw+Prlt0zNUlxOhcyJfO6I3WZ4uRr0WFgsD5r2Kp2Ev2RcNh3OQ9YyP6
	 iLKFm4Ztoow00pfZfEiQpXWDK9WsfbEdqAcx91Dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 324/332] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP 16 Piston OmniBook X
Date: Sun,  7 Jun 2026 12:01:33 +0200
Message-ID: <20260607095740.025632066@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 9e5fb6098d21e1f9be9982b46c3e5b8329d4e7d2 ]

The ALC245 sound card on this machine requires the quirk
`ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX` to fix the mic and mute LED.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221509
Cc: <stable@vger.kernel.org>
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260519015535.891156-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7182,7 +7182,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8da0, "HP 16 Clipper OmniBook 7(X360)", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da1, "HP 16 Clipper OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC245_FIXUP_HP_ENVY_X360_15_FH0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8dc9, "HP Laptop 15-fc0xxx", ALC236_FIXUP_HP_DMIC),
 	SND_PCI_QUIRK(0x103c, 0x8dd4, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
 	SND_PCI_QUIRK(0x103c, 0x8dd7, "HP Laptop 15-fd0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),


