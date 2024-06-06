Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A88196D87;
	Thu,  6 Jun 2024 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683011; cv=none; b=obaLc9V5UFAK2mdbsFAhRoTX2/UU6fZdUAEKKm5ii/z9MVw5Ml5d6TyP+JosED/hxBSNvyTAF8e5Ql++gCqLoDFP3mo3kKfIpJzUDxvZ51EYnzUthd9ixb+8kGF6iHyURkYjmSitTRrNPQjWhkaW7oC2LKwpgD6wTViQncEjhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683011; c=relaxed/simple;
	bh=+DRskI5uyc+S+Q3jH11FLbd4FE2rwDraSA4bsbJ37kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWYpEH2fcTQqULfHoGNS8pfY3Eh6k/WuhAeFo7Nx0StdyDZAWSvd0MFBGzUTbHJ0jZ0XJ84StRogzOWnbC53gQIA1zdmtlLXKHxoc/hqSdtHJoCMASe4Ms3I06RRBPzOOb4ztH3+4KP3abDFd6vxNZlJWRBq1ZCeCG2Pg9ffpuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GEu/dYLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GEu/dYLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DAAC4AF52;
	Thu,  6 Jun 2024 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683011;
	bh=+DRskI5uyc+S+Q3jH11FLbd4FE2rwDraSA4bsbJ37kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GEu/dYLQjv8rAiIkwbvhLRkmnuGOKJNcEiPwXRtxTEEEJDL+Q/Xz4HkNoJAzkadub
	 bZfuXM0aeByTkqiiAj6yGtWfpJyRYuGIjdQbD4LR9enJ1S6PdFoMOVbPkU/iXIreyY
	 YIvYr6HpMFGK349Iq+3D7Yehij4bvRpbMEZnZ+Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 221/374] ALSA: hda/realtek: Drop doubly quirk entry for 103c:8a2e
Date: Thu,  6 Jun 2024 16:03:20 +0200
Message-ID: <20240606131659.198422976@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d731b1ed15052580b7b2f40559021012d280f1d9 ]

There are two quirk entries for SSID 103c:8a2e.  Drop the latter one
that isn't applied in anyway.

As both point to the same quirk action, there is no actual behavior
change.

Fixes: aa8e3ef4fe53 ("ALSA: hda/realtek: Add quirks for various HP ENVY models")
Link: https://lore.kernel.org/r/20240513064010.17546-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 08598a4f1fa3f..d8caa2be63c8b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10103,7 +10103,6 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8a2c, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2d, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
-	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
-- 
2.43.0



