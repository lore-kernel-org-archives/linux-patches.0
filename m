Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB11E20CCD8;
	Tue,  8 Apr 2025 11:57:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113468; cv=none; b=GQLpeIMmqKiKwjfCl3NyR5ZqqcBYTVPEvsdGmMy9BecHwxZHttueAT+QWv6BMJGkDX8PyxhSv4IrPnqtNjrctSo12F1yk2Yy2DmZ18YuL8X4p1BlnY/qGCAqYpLpMecCEx/IJeYWY5cOsYW8ruH0AC2AMX9PzyEYUIXb0N0AZAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113468; c=relaxed/simple;
	bh=hQD5J2epS8Pp48oPY0ubJ41ZJkGReYem+i4QjiZKh1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhAxGKvWuSNul6Q5uZATJe1J41F2q4FWTdmmI51yM3FqEUuuF/43XH39up5eMZ/cdxIBYy6wCHlppyYNj5AAimv4/RKrsO/8K/vYvQ9NpEV67/7sn8k5EBrCWLKbYlnJXDfsqoMbHLzRmMbhfdqcnE3RrahsBuASnxBre+Du46Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xW09kevV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xW09kevV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79378C4CEEA;
	Tue,  8 Apr 2025 11:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113467;
	bh=hQD5J2epS8Pp48oPY0ubJ41ZJkGReYem+i4QjiZKh1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xW09kevV2zqlbwZ6vAI+OHOYS4Vj1rdoL+lbVhTePDG/X4kWXYFx/bSNdClr/UvMz
	 x7vXEbKu5UYh0Qt6jiU7M19MYiCksv3xiTbc6BEb+xn2G3vRfBlKkxvV1vBbmuMaMI
	 5JmaD+Uys5qllv0lALt5X/EVpM8GvGxpXyWEBEm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Gospodnetich <me@kylegospodneti.ch>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/268] ALSA: hda/realtek: Fix Asus Z13 2025 audio
Date: Tue,  8 Apr 2025 12:49:41 +0200
Message-ID: <20250408104833.133854290@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit 12784ca33b62fd327631749e6a0cd2a10110a56c ]

Use the basic quirk for this type of amplifier. Sound works in speakers,
headphones, and microphone. Whereas none worked before.

Tested-by: Kyle Gospodnetich <me@kylegospodneti.ch>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20250227175107.33432-3-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 81ebf59898a10..7a40f66f8fd88 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10236,6 +10236,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC245_FIXUP_CS35L41_SPI_2),
-- 
2.39.5



