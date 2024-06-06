Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F941BF917;
	Thu,  6 Jun 2024 14:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683558; cv=none; b=aB1GaLBwqGLIHDXuB6lYa0batOfZgX4HgpPBCS1dKgtvzaYTpxvs+ybia7RyvJWpErKwsbjI/mKGUICe2Ht13eidpdPxtC2dyEG66LvCH7wQLbuSg5vQJCIZFGADezusSt8Tc3OctlYGdfO95aFgj0eMiy8fjHBnop3KjUM/Tu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683558; c=relaxed/simple;
	bh=cIutm8C6uXW9QeUCXS2TqUtsPvD1LqFM1yJjNSH8Ghc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZkgXlKdEP2KhUoSAIIR8aln8mccznoGicG66AoI8teBkKvlAwA1wIOnQpu78v6Y9XzsclZ3WTA2oXo+ll+h2SEaQj+VjqSxZc6k49RcyF+xtr5CO6fu3nIHIesQSAxWnc2B3bfG5BZPqE5ida8/OkIgm/2eP5QC8s+AvAFzw64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4XpuCNA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4XpuCNA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02545C32782;
	Thu,  6 Jun 2024 14:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683558;
	bh=cIutm8C6uXW9QeUCXS2TqUtsPvD1LqFM1yJjNSH8Ghc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4XpuCNAMK76ykcW2RRXJDmNhEDEL1BGL7wChFbbUN7jedWwJHOQOH3s9F8qkfO3C
	 AkY+qHAJY8bXfRFl7S3x92hTs/cM0UF2hnvRi+vYJl7k57A7zOAb4pEDecLUw+5yvz
	 A3Yw/845yikAvmpSzkE/rDUC60QYY0rzrwA1kjd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Luke D. Jones" <luke@ljones.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 448/473] ALSA: hda/realtek: Adjust G814JZR to use SPI init for amp
Date: Thu,  6 Jun 2024 16:06:17 +0200
Message-ID: <20240606131714.527958965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luke D. Jones <luke@ljones.dev>

[ Upstream commit 2be46155d792d629e8fe3188c2cde176833afe36 ]

The 2024 ASUS ROG G814J model is much the same as the 2023 model
and the 2023 16" version. We can use the same Cirrus Amp quirk.

Fixes: 811dd426a9b1 ("ALSA: hda/realtek: Add quirks for Asus ROG 2024 laptops using CS35L41")
Signed-off-by: Luke D. Jones <luke@ljones.dev>
Link: https://lore.kernel.org/r/20240526091032.114545-1-luke@ljones.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c08bf42c602dd..3a7104f72cabd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9893,7 +9893,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
 	SND_PCI_QUIRK(0x1043, 0x3a20, "ASUS G614JZR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a30, "ASUS G814JVR/JIR", ALC245_FIXUP_CS35L41_SPI_2),
-	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3a60, "ASUS G634JYR/JZR", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x831a, "ASUS P901", ALC269_FIXUP_STEREO_DMIC),
-- 
2.43.0



