Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AA91465A8;
	Tue, 25 Jun 2024 09:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308924; cv=none; b=M4EbAjoTu04b/3pl6IzFlruVCyUCm9+JdavfeHqoj94U3+rPtdjN4qlLAk1eg+3y6+5FnXhoGoWSzJVB6rItFnF6BOdNZhwXxsydM3DRSGivDUIQ7eHM9rb1bsb+weck3r2n4hxQJt0EXz/QGLEMDYCrWTRsB1Pa44l3eg+qFJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308924; c=relaxed/simple;
	bh=+PIkr1+XJlYh03lAvaN91MFmL6x1Rh4OFHWX+cE2GQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfu5w2ZUGGswC5uGBRyGFn2gmgnyOc2ZT271c0NIQ7DvCmU31zjwyVs7MY91HZGbT+C2vaJyGuOIx2RZ0m+3hZspKNYTDrni2Dh9mGW8BnnzA4dNR9K030yjpkWpnmPHwH9iUJF6uM5hT7g7RcCETfSBjM8FDIldox4Ktc2AAeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0br/qLiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0br/qLiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFCFC32781;
	Tue, 25 Jun 2024 09:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308924;
	bh=+PIkr1+XJlYh03lAvaN91MFmL6x1Rh4OFHWX+cE2GQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0br/qLiTLwPu/IsveHq049IbH/c7gwB4OOBMinoI5NTMkHcnBzp/FOzRIvoXKC8lq
	 CL4hM+hkHzUfvHLEPODJcybLiTeyjTC6QsSeQ2m/d5TMQcgyC7Muad2oK9mIV2HEiY
	 61G1ZJkIweSzD8JuzzhGrUD3b8eSwyT74Wa5y2Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 035/192] ALSA: hda/realtek: Add quirks for Lenovo 13X
Date: Tue, 25 Jun 2024 11:31:47 +0200
Message-ID: <20240625085538.509798329@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 25f46354dca912c84f1f79468fd636a94b8d287a ]

Add laptop using CS35L41 HDA.
This laptop does not have _DSD, so require entries in property
configuration table for cs35l41_hda driver.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Message-ID: <20240423162303.638211-3-sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2151fb1bd0de7..44478e0af1e41 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10257,6 +10257,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x387d, "Yoga S780-16 pro Quad AAC", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x17aa, 0x387e, "Yoga S780-16 pro Quad YC", ALC287_FIXUP_TAS2781_I2C),
-- 
2.43.0



