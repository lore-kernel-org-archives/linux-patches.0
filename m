Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62E93A35A4;
	Thu, 15 Jan 2026 17:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496722; cv=none; b=WIPldclRWv/CN3IHUoRV4geBgA+W8fOuCc5c7U23z1E/RZG3wACcCs4eT/1KQBL8omGRpAy0BgokN1lLudofEOVmXIOZrP1pbfS2ILqk8OheLNG3SmfGwBlThHo9jVlGEvyYKVM5auBhp+LUeLPRYMXZ29fr9162bntpDiaF8wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496722; c=relaxed/simple;
	bh=9fiAsB73Q1BXjYyfcMv4Lt3QJ6r9A1JWhF8AzIX+ynw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuTktVlr6s5Dih4hoNbGaAgqUci5MTsxPuD6buNnextVzi5r7aKA/oqJewPPm+y5/KHCyScJAyA+MIZVsWsUriR+FQ9K+gOFg/5VQJ6CdELZ9mju+AHwBYW1wpolTKxZjgqZMUjJUMVcEy9NPvmgOYw/C9P4Jm0JO/H8e530w30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAlOoDB7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAlOoDB7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B1DC116D0;
	Thu, 15 Jan 2026 17:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496722;
	bh=9fiAsB73Q1BXjYyfcMv4Lt3QJ6r9A1JWhF8AzIX+ynw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAlOoDB7l3IPpRxNkPyl8hZ8UjgnIHBnP+b8W8XMe4Sa6jUUmqzzlBM4cjBjSpFJ4
	 4cTPCCHHqun2ywxCXuNIeai0xgNwmv2Or7VrutEOp/UjfsKzZYv7MH06SK19/jldCT
	 8FQ5SmvRvJSTQX71Z3qZ0ggasYhMS4vJMFR6UcvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	davplsm <davpal@yahoo.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/119] ALSA: hda/realtek: enable woofer speakers on Medion NM14LNL
Date: Thu, 15 Jan 2026 17:48:48 +0100
Message-ID: <20260115164156.038723339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e64826e5e367ad45539ab245b92f009ee165025c ]

The ALC233 codec on these Medion NM14LNL (SPRCHRGD 14 S2) systems
requires a quirk to enable all speakers.

Tested-by: davplsm <davpal@yahoo.com>
Link: https://github.com/thesofproject/linux/issues/5611
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://patch.msgid.link/20251212174658.752641-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 3b754259d2eb6..7b3658e01c95e 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11350,6 +11350,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1e39, 0xca14, "MEDION NM14LNL", ALC233_FIXUP_MEDION_MTL_SPK),
 	SND_PCI_QUIRK(0x1ee7, 0x2078, "HONOR BRB-X M1010", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
-- 
2.51.0



