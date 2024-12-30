Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB2215E8B;
	Mon, 30 Dec 2024 15:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573862; cv=none; b=Vgl35pUbiArN9OPlqnkFU/RH8ETIXpgJJt2+FV8qgMO4WG2WCdRI2cuGHLbLNcxYFdYuwUryHmtMsSrbLGsvZ5+WQ1sEMwbSFixhoOaM2brucfKB3dKtC3DwYL/NGPlbyngNSL8vOMo88Z7WlJm1xco+vRQ3nWt6PEQjSKjAUCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573862; c=relaxed/simple;
	bh=ZjvuZGRWQtEvfEgq3cPQeKLIm5eUoMXg8R9m5UZJlm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hB1cMzY06SelGXjc7hCLQoSjV33+LW3dl5jC3ABNfONUHAMJhAX7j5wrVO2kvJwUbUVjxirVcThImknpY+4n1tT6MyLyk6HWq13GspNHBQKdWIpA8GVihsFM8kwfrsBFU+8ZQEWvk8sOwQMgysHLsMliclJr5tKaxSRpXjU2aUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L3HqoKoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3HqoKoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D92C4CED0;
	Mon, 30 Dec 2024 15:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573861;
	bh=ZjvuZGRWQtEvfEgq3cPQeKLIm5eUoMXg8R9m5UZJlm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3HqoKoXTYG6BHdxiGVAcw1l6UMph1kJ5JfLij4aZXHtdintDLf1YbrE2M130Hvff
	 eaksHWBC1BugUcEsRAgt8Sf8AWzl3jQWiQZRG4hvzZw0SLSEM91iBP3P+o+fi0NtB+
	 WjMGH5vZFcxIW/WZ/tPrmIsjP+cox05jKUPQM7+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 55/86] ALSA: hda/realtek: fix mute/micmute LEDs dont work for EliteBook X G1i
Date: Mon, 30 Dec 2024 16:43:03 +0100
Message-ID: <20241230154213.810502215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

From: Dirk Su <dirk.su@canonical.com>

[ Upstream commit 7ba81e4c3aa0ca25f06dc4456e7d36fa8e76385f ]

HP EliteBook X G1i needs ALC285_FIXUP_HP_GPIO_LED quirk to
make mic-mute/audio-mute working.

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241126060531.22759-1-dirk.su@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 0d08f0eec961 ("ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index d61c317b49ea..e847bdb600fd 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10054,6 +10054,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.39.5



