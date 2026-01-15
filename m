Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F3E41C5D59;
	Thu, 15 Jan 2026 16:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496038; cv=none; b=k8O73JbQv9aW4pQYA5HS/4qNcI12qM3xq6QJMgF5T/KFk6cqebJuHWPwlpmoQhEH71JgUut3Ndo5Uy6iz20KiKWkI4hqss30nCIeYd6b3jzUuWv35E9Wz1wLe6tXq9HgPxDcndtIXzRJvLAML4Dh23jmMD9YbYiA4TLh60VNVLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496038; c=relaxed/simple;
	bh=EKu2NvtAaSLKEC4k4/km8O/vcDJdTFTDtgII+zhVF5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf+rE0oSK71RPbEyI86gNK9vOT1kqj7eaHzgqREqgYZc5syUZLNdRXxmPhGivzEVc8MpzpRSpwykqodlA+KcLEatpYWUrJ/D2jiVjE4uqEQFcQppWjiqvhJQuwhgnm3Fmoa3HJhDLtPLjK1JWbRLr04FEHtdqSdXxXcmTMMZU5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMxvOEBq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMxvOEBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74267C116D0;
	Thu, 15 Jan 2026 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496037;
	bh=EKu2NvtAaSLKEC4k4/km8O/vcDJdTFTDtgII+zhVF5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMxvOEBqx/DyKqYqg62lmsxj3IhN+OYd2SMdKLO0/p15Yf37zfpR9QneNJJ8h3MV9
	 nNXx7UhY2Vae3/5b9Nqg0Dvxh5x4oQghn3osq+OcmU/P0YINifMc8BAiFMiAHFwGJR
	 bBDhe8kXEmTu0E3/rQ2QU3lQiUM55EUBgVV4XcEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/181] ALSA: hda/realtek: Add support for ASUS UM3406GA
Date: Thu, 15 Jan 2026 17:46:32 +0100
Message-ID: <20260115164204.314582538@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 826c0b1ed09e5335abcae07292440ce72346e578 ]

Laptops use 2 CS35L41 Amps with HDA, using External boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Link: https://patch.msgid.link/20251205150614.49590-3-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index b3582e390dfa3..eea8399e32588 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6761,6 +6761,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
 	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA/XJ/XQ/XU/XV/XI", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301VV/VQ/VU/VJ/VA/VC/VE/VVC/VQC/VUC/VJC/VEC/VCC", ALC285_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1584, "ASUS UM3406GA ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1652, "ASUS ROG Zephyrus Do 15 SE", ALC289_FIXUP_ASUS_ZEPHYRUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZI/ZJ/ZQ/ZU/ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.51.0



