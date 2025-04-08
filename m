Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF83224234;
	Tue,  8 Apr 2025 11:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113489; cv=none; b=WTs0uirzZcmhGaH0M2QIEa2J045wp74dyd1RRlfO8P9L4Dq9oKoGBNubVMxJhwgwR6aohDyjIKJINBY1GAsHXlTl+Tl0tdFDDhx4aoQwDffLB7YocyD6QIVToT4G859HegMfwDqA8g/MJ4GXFxxp5ADsYZQFE8UMyH0eQaIogvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113489; c=relaxed/simple;
	bh=DqtICyy+2vbgsd8/U9CWGQdw06haF8n1gQ/ZV/at4vQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTiZX/PpM0ZTABfuBPfcN2Ugkz4o0NSSvjl9+UlXpJsuVEfs2I3/Zx8d4RmPcLo9XWakKvCyAg8+tzAmdjMCHhVDiTTKVtkheF083mpymgUUxrh2QeEwp566BxNcv06O+oUvn7iDBW83dz5YiZEG3w6EDfNS4l7eoErxSRHrjJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lg5UB4Jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lg5UB4Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0035C4CEE5;
	Tue,  8 Apr 2025 11:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113489;
	bh=DqtICyy+2vbgsd8/U9CWGQdw06haF8n1gQ/ZV/at4vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lg5UB4JngKdfG+VwgWSGw2b5WQFW2NKTVYdFYZiKpOZeaGcYiPDCUlMeB4BRpDtKM
	 pXzw5Nnky+07+1AbSeViGc0N1THGVefL8BCsR/67o5ittQTg+rJvx1INGFSPzNEOrx
	 UnlLGiL7p5HTThBX2nNP4msXRCPl/DK+y2G/BcwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/268] ALSA: hda/realtek: Add support for ASUS Zenbook UM3406KA Laptops using CS35L41 HDA
Date: Tue,  8 Apr 2025 12:49:49 +0200
Message-ID: <20250408104833.345320571@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9f6ee6489d943..eb39e421adb9b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10160,6 +10160,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x10d0, "ASUS X540LA/X540LJ", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x10d3, "ASUS K6500ZC", ALC294_FIXUP_ASUS_SPK),
 	SND_PCI_QUIRK(0x1043, 0x115d, "Asus 1015E", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x1043, 0x1194, "ASUS UM3406KA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x11c0, "ASUS X556UR", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x125e, "ASUS Q524UQK", ALC255_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1271, "ASUS X430UN", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.39.5



