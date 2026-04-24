Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1803D6CCE;
	Fri, 24 Apr 2026 13:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037749; cv=none; b=bd6Y0A7XhyycA8ccIiUNZD/1GE/db2VoQPDLYl5rZsCcWuP9mp7YZH5+j/TAYFRs91+NBayCnOm4/BtTe4IukZDDX65ztFW+K/6Ex/37JzpACUEglmC/0WGy5VI6zGE658B8GnFsXWmocDvJJ/1q0XFfbY4YL0XFq6PkMgHJxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037749; c=relaxed/simple;
	bh=IEIPgBwZlgHr1Z5YN4Km0n+18HV1JyXpp21FWw2DHT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NMEsL9HXxMDDtnaZlNuPO/NE7j3A1Juya9MdOU7W8Hb4TSmSTvaw+kExpwMbqnWdkpAqTrVFiWeH9kjl8Bu0kHwoJeGJi46f/l6W9t+5huZMNL8AAHomHzHePmMkwI75pa8pwQ8PLNhNWh0HAJNxrzhD5+0bjxQOE3oE9dUDv8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu7yfcU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu7yfcU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE27DC19425;
	Fri, 24 Apr 2026 13:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037749;
	bh=IEIPgBwZlgHr1Z5YN4Km0n+18HV1JyXpp21FWw2DHT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qu7yfcU4IecBrzmqDO5/oySjg4UlknJyt41fdbBUSuCqxf9EOeIB9556FOBw/jURz
	 QB68wWEI2aRGIRjYEru2h/cyaCBkjNA0qS7QkHfBsI8Yx5sGTBIGDT6k5s0IJUxjpW
	 AwangLc2o/c6diXJ6e5jgw3LpnhyYj5dmfpR9ZpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9sar=20Montoya?= <sprit152009@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/166] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx
Date: Fri, 24 Apr 2026 15:28:45 +0200
Message-ID: <20260424132535.276314623@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: César Montoya <sprit152009@gmail.com>

[ Upstream commit 2f388b4e8fdd6b0f27cafd281658daacfd85807e ]

The HP Pavilion 15-eg0xxx with subsystem ID 0x103c87cb uses a Realtek
ALC287 codec with a mute LED wired to GPIO pin 4 (mask 0x10). The
existing ALC287_FIXUP_HP_GPIO_LED fixup already handles this correctly,
but the subsystem ID was missing from the quirk table.

GPIO pin confirmed via manual hda-verb testing:
  hda-verb SET_GPIO_MASK 0x10
  hda-verb SET_GPIO_DIRECTION 0x10
  hda-verb SET_GPIO_DATA 0x10

Signed-off-by: César Montoya <sprit152009@gmail.com>
Link: https://patch.msgid.link/20260321153603.12771-1-sprit152009@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cd30f749c79b4..0efc2b8aedb4a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10108,6 +10108,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0



