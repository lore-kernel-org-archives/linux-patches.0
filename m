Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3823264F1;
	Mon, 20 Apr 2026 16:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701250; cv=none; b=JZh4RlkRpFLR73GUWQQqS+V6sgEtyW0msqLs50qRajfXSbYhRfxKaArUtwhxO6jp0lKrH99tBUBNehj1PTokclcQvp2B2kA4umYmMPi78djuLIlHvz2ZfEa7pM/OEIond8TUoPcXJTMymND88+xwrERgP4Gagxt5JXYF5VisDTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701250; c=relaxed/simple;
	bh=YCRE6IUokoAOQOnSZ9jksCVJgdXIYqvYCxjE0cpV/qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EcRLqw5MJJHvBHMWNhpqpeNE9Jjg4IyQJG5QfNZVSyP3sJp0ZJJ85t3xaBP1r8ZCM4uxUhrEGfLlh9gVtNasnWPowe/neYvs3xyrpahS5bT0lW0x1azeTvl3bsEvBd+uzKMjc+tlLkiWUUsnb4QPdGFX9N+wfvyahoigUz8FrPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y7FbLi/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y7FbLi/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC0EC2BCB4;
	Mon, 20 Apr 2026 16:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701250;
	bh=YCRE6IUokoAOQOnSZ9jksCVJgdXIYqvYCxjE0cpV/qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y7FbLi/olyycSvJMXxhNVTpbflinfhRC5eebNCThDyvMyA0yIh1uBiN2N2CYzMW86
	 gam20IRGIAcpoxzDKMzkZV4nuxftBEImMR8M89AKLKmrPbwOVGE1jtcNKP7l7zO/6c
	 9B8tHYYoJkhtnl6pgK/ScBLgZHhM3Kr1WGt2Df3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A9sar=20Montoya?= <sprit152009@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/162] ALSA: hda/realtek: Add mute LED quirk for HP Pavilion 15-eg0xxx
Date: Mon, 20 Apr 2026 17:40:45 +0200
Message-ID: <20260420153927.497898065@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 96df0d12b68dc..440ec4e1528ae 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10909,6 +10909,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cb, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0



