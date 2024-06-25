Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4570A149E0B;
	Tue, 25 Jun 2024 09:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309051; cv=none; b=AoaPOzsoWPW3hml9sKq298PCwpGERXl4ig8cyCiBfShJ1ch++YAKoNrtY4yY6EmM8v1Nb51yV1GN/0hCPKp23Bzd46x3xpGNz1V24zVsxsE8Ye/MuopJtVDu8/CXDnNse+lQiAxjfuT+i9n6RkK4rnmDbmnzLP/8/xfWSASF4eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309051; c=relaxed/simple;
	bh=NxWji9IcsYsHTwPtfhoHbPG5YmfWf1QoyzCTF16BqEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFt+itpPapN/svSJk/g88NMBdpfo6LzCH8QVLmvcNoqhvfTB8VcsInbI1PjYvkf9wuWSJSVooFWDnCYV4a83cdk+UMfCRXb4s1Mm4sTLN+gyacs+HUBHEjlXQkh0yT/YyZ1JCJTd7zdC7fWUMmqtlxEgVy5EqwSMqJKWEx9tT5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6ghUzGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6ghUzGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8C4C32781;
	Tue, 25 Jun 2024 09:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309051;
	bh=NxWji9IcsYsHTwPtfhoHbPG5YmfWf1QoyzCTF16BqEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6ghUzGrfpEGKGpnvSm/dG18d03H0lQUSEBDuKsMU1aVx2Npyx4ha6EZPBvJxE65i
	 H+S+m55HvIPtNMQpjjYF94y743o/vBY3Ypfp3pp7mO0x5kVx0PF/Hb0USHw+NCkyrA
	 wy5JhCkODGxJZFpphBbY2GuCoNmaLEL4/Zd2cGVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajrat Makhmutov <rauty@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/192] ALSA: hda/realtek: Enable headset mic on IdeaPad 330-17IKB 81DM
Date: Tue, 25 Jun 2024 11:32:29 +0200
Message-ID: <20240625085540.132325741@linuxfoundation.org>
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

From: Ajrat Makhmutov <rautyrauty@gmail.com>

[ Upstream commit b1fd0d1285b1eae8b99af36fb26ed2512b809af6 ]

Headset microphone do not work out of the box with this laptop. This
quirk fixes it. Zihao Wang specified the wrong subsystem id in his patch.

Link: https://lore.kernel.org/all/20220424084120.74125-1-wzhd@ustc.edu/
Fixes: 3b79954fd00d ("ALSA: hda/realtek: Add quirk for Yoga Duet 7 13ITL6 speakers")
Signed-off-by: Ajrat Makhmutov <rauty@altlinux.org>
Link: https://lore.kernel.org/r/20240615125457.167844-1-rauty@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8e6574c07c975..d17209e2d4372 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10246,7 +10246,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940 / Yoga Duet 7", ALC298_FIXUP_LENOVO_C940_DUET7),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
-	SND_PCI_QUIRK(0x17aa, 0x3820, "Yoga Duet 7 13ITL6", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
+	SND_PCI_QUIRK(0x17aa, 0x3820, "IdeaPad 330-17IKB 81DM", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3824, "Legion Y9000X 2020", ALC285_FIXUP_LEGION_Y9000X_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3827, "Ideapad S740", ALC285_FIXUP_IDEAPAD_S740_COEF),
 	SND_PCI_QUIRK(0x17aa, 0x3834, "Lenovo IdeaPad Slim 9i 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
-- 
2.43.0



