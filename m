Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0114B265CD3;
	Tue,  8 Apr 2025 12:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115049; cv=none; b=juK9AFkfnidiyO6dqsjsyxQk8+HCSKfWzsTXWGCYjT0Eg7HXg05JXF5tCokAU0oK54hfETNXECEHXx4lvuJL6XlWkU9612rqoikPbZoVMd0OUhZNoWbXYHs4ClFfQUTUIEVuFJDM+t5b8jbp+7MAuAJBh06Ei0TPrakwhNi2bfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115049; c=relaxed/simple;
	bh=vR+qOKqzwlm8Yj/tKSwf2FjP17i7RjdtaPOvJTV64dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOhk4a2iuXqpZHw5JXki/9ZFJiVxBLiWgBQRcqA91q8f1JV+g9HeS3BUndmtUi483DV2SQpmY4zZW4PTPFWpn+gqPBbLgEPSAcSlRO4HkiBIEGfaWlFgBRJfAblm8bow5fpTGMgmZQz/Z30G2G9m5hfGxQBUmMixse21DhTkOe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v08GDe0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v08GDe0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85729C4CEE5;
	Tue,  8 Apr 2025 12:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115048;
	bh=vR+qOKqzwlm8Yj/tKSwf2FjP17i7RjdtaPOvJTV64dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v08GDe0jSEve0AGMVk6aMf7ViEWnf/XSpQwQ5KJUTdIB/avOnL4Cw89kd4it7CLvg
	 zu/YEXeXRHgXBM9AIf5LmVVwOLdRgcs3tCI2y96lKs6u6GwCEiBA1oGGuFvOT0n8Rl
	 ULJHZj/rIqBC5Oy5w1EzTpzRwlClwmiPCUenyGa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 329/499] ALSA: hda/realtek: Add support for ASUS Zenbook UM3406KA Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:49:01 +0200
Message-ID: <20250408104859.430631000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 8463d2adbe1901247937fcdfe4b525130f6db10b ]

Laptop uses 2 CS35L41 Amps with HDA, using External boost with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-8-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 248e30c3a22d0..503fb6654289b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10661,6 +10661,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1194, "ASUS UM3406KA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1204, "ASUS Strix G615JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1214, "ASUS Strix G615LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5



