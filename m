Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A226A1A3;
	Tue,  8 Apr 2025 12:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115882; cv=none; b=RzMJQXrp7EgRTljVwib26S9GFeAsgyjYKga5AD+t989JYdOhouUkXHV3hYC+IBGkMkRTrMCu8xFfIkcix3QBLGiNnfsevMaHfrVmXBhETPWcY5HZ3gmjpL/GAHKYQSclP0hLl28ti3A2dvzZclh1qmYCDmsITI18LbowE0SVLYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115882; c=relaxed/simple;
	bh=JHS9Bwsk1HYywvBlYt08VFVwEfV5Xm/7Ozp22Q5Ipkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myEAzJ8XRd+OR43bDi67A8h7XlMCjucVaVVgs1E14yMo81BFmzF6lnifXn6mqiKOfUw3Btl9fyEiLqPwqZDoIi54Ue6do/3waFUvreU0heHh6f/u9yVuFHtkKeTII+x1AF+Ef2FwUbVrZ0JX/4dHYPtth6SfaBJGOf5e0bDU/Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjqsYYHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjqsYYHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93062C4CEE7;
	Tue,  8 Apr 2025 12:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115881;
	bh=JHS9Bwsk1HYywvBlYt08VFVwEfV5Xm/7Ozp22Q5Ipkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjqsYYHRKFdkz0wosvKYMU5dv/bku3oBcUYCH5tCYjDkcy/oFLhOliuUyyXV2RTwx
	 lI8BRVfghRJXDFdsMbHxN5T3wwpqY+e4rO6f8LALWKAYCb0+4ni541s1+eOcFwODt8
	 RDZh59Z5h6r8Gfyqk7Rnsz65Pj1Rq0EO35Rh6zao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/204] ALSA: hda/realtek: Add support for ASUS Zenbook UM3406KA Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:51:09 +0200
Message-ID: <20250408104824.373757260@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 841338c82e807..66238f7e35bd3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10004,6 +10004,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1194, "ASUS UM3406KA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1271, "ASUS X430UN", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



