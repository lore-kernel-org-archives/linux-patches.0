Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EF04E4C3F;
	Thu, 17 Sep 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668421; cv=none; b=T6PBgHyTMteLVnsBPIlziZ202GWxozXo+ACu/MOHfkoQ9LLorcu0i9J3lykoASEHbSW5CoKMg18P3M2PZX0xJBOsgjg4FcMbDCEdxQGE+qIXGw3/byiluEX+HORTRluFFoN8zrBXs6cQcw2J750IQ9zz26a7wjWcqWhn5fanGu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668421; c=relaxed/simple;
	bh=jk/riGQlyXdu8BZWrC2urvEx8vqp/TSDt/iBlEu/49M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MXlseTkS5yC9PGDTygy12hd/MG26GHUoTPq9TZQV7x7cqQ2jroT7L6Jn5wxczDZiDvS+3sm4XlHQdlo1LBECWe79mz1Sca4qXG6ITA5+K65py3hNYRKowNH3J9Ux7+D0WMD98mSKjBbWDhavavCf70y+hKjsrbrFEMnUmLBmfDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DhLlC8kU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhLlC8kU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F9F1F000FF;
	Thu, 17 Sep 2026 18:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668419;
	bh=7mXABrSfMbxArxYl2HDWBKE8j4vdUnokQBsIqob7g9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhLlC8kUAgH2B2AYwQ0SdAgxBh+G8odPUJmXU+COPvprgC1BYDnsROBjLlMusua6O
	 NuGIR5CLS9vjsqzJ9S51S7yZVAp9gRbwgZ53HoVgRhF7lBrlzPx/6VPUpyUBS47fSB
	 QJDCXAHMbxf4tLWkE/oEi4k9g/o8TveKd07+U3Po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcel=20K=C5=82os?= <marcel@marmak.net.pl>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0420/1102] ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs
Date: Thu, 17 Sep 2026 16:06:03 +0100
Message-ID: <20260917151550.211822164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Marcel Kłos <marcel@marmak.net.pl>

[ Upstream commit 728d34ebf91c0e80b63a66b237dd0dfc5a8e5b4d ]

The sound and microphone mute LEDs do not function on this newer
revision of the board (8AB8) while they do on the older 880D models.
I have verified this on another laptop which was manufactured before
the one with the issue.
Added the ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED from a G9 model, which
uses the same codec, to make it work. Tested on kernel version 7.1.3 on
the aforementioned newer revision notebook.

Signed-off-by: Marcel Kłos <marcel@marmak.net.pl>
Link: https://patch.msgid.link/4dab5622-9100-4730-8c99-b58da939549b@marmak.net.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 74768dd0a0e7c..f05ed4703a3a4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11007,6 +11007,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab8, "HP EliteBook 830 G8 Notebook PC (MB 8AB8)", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



