Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1565276053;
	Tue,  8 Apr 2025 12:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116824; cv=none; b=WFEfs74FeInUd4NWWzTXISwjOfwqW42tR3iMsHdJq4BK5mMSJT/gRzUl3VNDprngfEPlsTwKXC9k1AtE/MWihcrNemlW1nqCKat+QjWQQHAUxJJ7ywHayEmrtVyqH6LuSJhFI8uPtM5ui9HFo1JAdgk32mi3Jora2BU5INMEzck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116824; c=relaxed/simple;
	bh=NIWvmteYvNsDq9xkS2f/0GFIUNhZFOmTfMlDLfIgiFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bY7QcwRexdSUZiMaEbo/SNBXpo5OUcwGdLYXVGTlp4CCVMMb9ZbQZJ2AQCwzqcqwA2aQlsVATpb2zDwevzPLFFS5EGiIKCNbh4h3oBfFBBcT5tYW2E08Ma1fkbeTjOIWtQMZlKwZKbIvqxwca8PpRHkWjilGNwrhMW1wXJUSlmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqfRPms7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqfRPms7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53666C4CEE5;
	Tue,  8 Apr 2025 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116824;
	bh=NIWvmteYvNsDq9xkS2f/0GFIUNhZFOmTfMlDLfIgiFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqfRPms762DNKbpzBtJk4pLh70Rlf17Dq6b5l3Wp9W39NWAi3Ef7Wq/9G+ieN9US7
	 y14PEBlvjI/WoxqlpZrU3YLMH7USSvbA2EpTAicdLqFkgFw8gYPZ5DApIpWCfG7sCO
	 THkbTQ++sud5xoz02corRy63cPJu/y5tW8tYm+bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/423] ALSA: hda/realtek: Add support for ASUS Zenbook UM3406KA Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:50:08 +0200
Message-ID: <20250408104852.343922930@linuxfoundation.org>
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
index 4ff531b4f50ed..f97837f211253 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10630,6 +10630,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1154, "ASUS TP3607SH", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1194, "ASUS UM3406KA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1204, "ASUS Strix G615JHR_JMR_JPR", ALC287_FIXUP_TAS2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x1214, "ASUS Strix G615LH_LM_LP", ALC287_FIXUP_TAS2781_I2C),
-- 
2.39.5



