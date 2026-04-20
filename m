Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6456E17A31C;
	Mon, 20 Apr 2026 15:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700622; cv=none; b=VYlJafWWjS+VGRWOZp8kVC51TJVmLoA9OlHnT16c9F4bdym9QITLFQAQar0QJQXM8aIRHB9Y3X0+nkgg3OG0XcKhkeYbY4eXzTPloxpP/1KDoM/E5UexELi+2en4M7gZdIZ14nDvNtdFIT+utEte80jV8Rs78erVMGJQ5PBK9to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700622; c=relaxed/simple;
	bh=4Bv1i0TQ1Fd/DTnvT+LCgympyUL4i4exzGaRRFzcR2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HTSJMnMA/2jb/JkBYKwtEFL2A1TbcPBJ5MSaapXTh0ooMVCh8B+Up6Ht5aSDL5Xr6YP14cIOaz91DkybOth/fXPn7RXGk10af+rIOnDoSjEcZVPKXvo4IRfXH5h9Cyiaa0YVBOsGI403t7fM+3InMjCVyMlaEcFUI6O3AxG8gP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSx2V58i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSx2V58i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED533C19425;
	Mon, 20 Apr 2026 15:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700622;
	bh=4Bv1i0TQ1Fd/DTnvT+LCgympyUL4i4exzGaRRFzcR2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSx2V58iQ26qUtdrW7guQ+sgOMPjcVOSFulEfCCUnRtwo/5XhodDMvSdhUX/B/80I
	 Yo1SD24jj0vbutbBxKTLnrOpxc0meg+oFbLmFj/1iwdv1T056GELl09kSNj/6dZVIX
	 NO4YXrzueSS3A2C4WJX9nFIPMMC+SuW9fPmFSOMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 023/198] ALSA: hda/realtek: add HP Laptop 15-fd0xxx mute LED quirk
Date: Mon, 20 Apr 2026 17:40:02 +0200
Message-ID: <20260420153936.451712823@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

From: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>

[ Upstream commit faceb5cf5d7a08f4a40335d22d833bb75f05d99e ]

HP Laptop 15-fd0xxx with ALC236 codec does not handle the toggling of
the mute LED.
This patch adds a quirk entry for subsystem ID 0x8dd7 using
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2 fixup, enabling correct mute LED
behavior.

Signed-off-by: Kshamendra Kumar Mishra <kshamendrakumarmishra@gmail.com>
Link: https://patch.msgid.link/DHAB51ISUM96.2K9SZIABIDEQ0@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index c782a35f9239d..0c975005793e7 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6977,6 +6977,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8da7, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8da8, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8dd4, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
+	SND_PCI_QUIRK(0x103c, 0x8dd7, "HP Laptop 15-fd0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8de8, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8de9, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
-- 
2.53.0



