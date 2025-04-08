Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DADB26A0D0;
	Tue,  8 Apr 2025 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111919; cv=none; b=rpu6zPCJd/yI28dZEXv/Miw+UDdNoboLNV+eitt4bgaxww+hZ8LqO/FjPW32O7bnSKPpQyHZdvDyNs5kwmuKi25ZfZz8iWsUMc4g1P29AaGPDRBNrXS+pks0y5EwnyFrA1U39ZgAbKJnsmzsWd97E+76bsl0jYXWYACWPeXPeDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111919; c=relaxed/simple;
	bh=fT5GOIaWNFz/3bRgELgIj+PxHC1khr8/Ih6yXSFuBAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/6VfH1A9A2BU8okhGTSGlcWx9/QDIzjma5OPVmF5TgjFXnowxsqXXxh8rsu+QIvs9gaREMBn/FHrNoBIGtnSKXjU5Y4AZ5SasDoSeTtM2EtoNDHqy4s9ZvkAxehzABycptepCGnnwFqUFfRtXO1zKmYuBIGdT6hdcPRSGxOoNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kIVDFMtI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kIVDFMtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0704C4CEE5;
	Tue,  8 Apr 2025 11:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111919;
	bh=fT5GOIaWNFz/3bRgELgIj+PxHC1khr8/Ih6yXSFuBAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kIVDFMtI7IjYIjU4jDoY8P1jtK/pNvrNpeheb1VI75WahN2Fda0PgX0fD1E4vpia1
	 uNSNrRvJXkxDC153MB+pLRiFXG9v4h9GPCFG0XFr8BlQg6/TR8p85zYgmDDt7Hd7uW
	 KW0QlD4tH75W7yl+Y5iWHIKuu7mOTz5kDPhxCYE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 609/731] ALSA: hda/realtek: Fix built-in mic on another ASUS VivoBook model
Date: Tue,  8 Apr 2025 12:48:26 +0200
Message-ID: <20250408104928.437496182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8983dc1b66c0e1928a263b8af0bb06f6cb9229c4 ]

There is another VivoBook model which built-in mic got broken recently
by the fix of the pin sort.  Apply the correct quirk
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to this model for addressing the
regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Closes: https://lore.kernel.org/Z95s5T6OXFPjRnKf@eldamar.lan
Link: https://patch.msgid.link/20250402074208.7347-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 9df400f7a144e..65ece19a6dd7d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10776,6 +10776,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c43, "ASUS UX8406MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c63, "ASUS GU605M", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
+	SND_PCI_QUIRK(0x1043, 0x1c80, "ASUS VivoBook TP401", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1c9f, "ASUS G614JU/JV/JI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JY/JZ/JI/JG", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



