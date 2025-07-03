Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B24126BFF;
	Thu,  3 Jul 2025 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554189; cv=none; b=UVsJQlXApcc0S1CMI64EX97WfHHVg05q7CsnFTF6vLIby6h7zx9PI7l11MtXxRO9jCR+k6TgYxv6itIENM4NZyfwnzNfWNGVMuHB1g7OXj8uGeJHwSweGojPezmSkSov1bG3iW2BXTbJmJElZDmT3wyjiBwrLCNgv4+lJcG6w1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554189; c=relaxed/simple;
	bh=sUKLaxnt6UNEVc47bGqZMKP6vf/0QN07B24bWKuxWRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWvaVY5hY/9Bvrpswc94HFhdodD1J3alzZb5TaK9tCDte3irGq80d5zjOmOQ+g67wSwvAfFz30qsNNVWkdi4Ka7q8Mmv22EYPm1tbF6OeT/3WUVWELuumqd2UmcTWSHDtEsDRZ24CWc3jsak0+poazKX+ysZ9RklnXEWd7zjkrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EithPcW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EithPcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D30C4CEE3;
	Thu,  3 Jul 2025 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554188;
	bh=sUKLaxnt6UNEVc47bGqZMKP6vf/0QN07B24bWKuxWRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EithPcWKkvYsDQtqZu3CxoAzBvlaYXn9km37LhQxS8PnHGwUSN1tKF3NX7wLuLjv
	 v6etRE+VlIMzkNEoDEVWn1Ap6LBEWiop1R8Fl8zBxctjvGqMS+DEr1Xxlc1XjPEuLo
	 2kkEi1Az/zwqGgzLk2LCvwnKKDkRBl6fHZzEovP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Tamara <igor.tamara@gmail.com>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/218] ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X507UAR
Date: Thu,  3 Jul 2025 16:40:57 +0200
Message-ID: <20250703144000.290431671@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salvatore Bonaccorso <carnil@debian.org>

[ Upstream commit 7ab6847a03229e73bb7c58ca397630f699e79b53 ]

The built-in mic of ASUS VivoBook X507UAR is broken recently by the fix
of the pin sort. The fixup ALC256_FIXUP_ASUS_MIC_NO_PRESENCE is working
for addressing the regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Reported-by: Igor Tamara <igor.tamara@gmail.com>
Closes: https://bugs.debian.org/1108069
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Link: https://lore.kernel.org/CADdHDco7_o=4h_epjEAb92Dj-vUz_PoTC2-W9g5ncT2E0NzfeQ@mail.gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index cb41cd2ba0ef1..94c5151c456d6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10933,6 +10933,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1df3, "ASUS UM5606WA", ALC294_FIXUP_BASS_SPEAKER_15),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1e10, "ASUS VivoBook X507UAR", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
-- 
2.39.5



