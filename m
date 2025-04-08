Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF2326B962;
	Tue,  8 Apr 2025 12:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116806; cv=none; b=GXJiqH3E+kvs2hfjEKMX3HEU1jlxrl+qJk2m+vDkItl1J9vt2S8xt7ZfMgr9VAi1RXOFk/bFaY9L/aK+vThM4zNekXNxVE1smHLTIAuZ8LHXSLPpNzoG2OeEv89AcKwtosN/xP9YsSPmsSh/32Xj6NgvNfpPTT3viQfFsb+QkHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116806; c=relaxed/simple;
	bh=OUlBst2kKe6t6XhbaPO7XjOVUMNvVdk23KlB3b+FEBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NA+nyL+4FAd/yyyNUwqhI8+KkyCzMcXjM8HQjCy6wt/AB+Ofsg/yfgHa/nXhTDbEPRXkHQU/9t7Cxf33jW2Gpg2Qvpie+QZFqh5SgmqdwoIHzpyjSsd/LtnH72mviWii6PKChNVZFXXPtXiHIGglNgk3LcxkRUkE0KAAoTVygtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeM7JXbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FeM7JXbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973D7C4CEE5;
	Tue,  8 Apr 2025 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116806;
	bh=OUlBst2kKe6t6XhbaPO7XjOVUMNvVdk23KlB3b+FEBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeM7JXbWp+PI/AgU1sTjbZT8FmebOV4bU0JFfGObm0ozDJ3t1Ytaf1YlKZgkJQhks
	 55W6lEjMrwGFIQQoez4biVaDwQfZlrdiLP2nsaurEYErg02V7qZTvYjemlSJ6wxntt
	 pVpfwmsBfIO/8a/G2y/4J4R8gu2NkLqurJvXQ2QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 276/423] ALSA: hda/realtek: Add support for ASUS ROG Strix G814 Laptop using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:50:02 +0200
Message-ID: <20250408104852.195692552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit f2c11231b57b5163bf16cdfd65271d53d61dd996 ]

Add support for ASUS G814PH/PM/PP and G814FH/FM/FP.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250305170714.755794-2-sbinding@opensource.cirrus.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7dafafaf23b74..93986c0482f07 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10727,6 +10727,8 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x3a40, "ASUS G814JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a50, "ASUS G834JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
 	SND_PCI_QUIRK(0x1043, 0x3a60, "ASUS G634JYR/JZR", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
+	SND_PCI_QUIRK(0x1043, 0x3e00, "ASUS G814FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x3e20, "ASUS G814PH/PM/PP", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3e30, "ASUS TP3607SA", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3ee0, "ASUS Strix G815_JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3ef0, "ASUS Strix G635LR_LW_LX", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5



