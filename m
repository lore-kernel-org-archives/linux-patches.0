Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80841CAA60;
	Wed, 19 Mar 2025 14:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395203; cv=none; b=ZOEpTCu3zwv3QcWa2oLbpnhc03lXYvXWyMtil5yldNz6ZeLV/u2p96DQ563TbGa4v6MpsovWrpSW5VVeZT83mEPJaUq/qjcYZZONM86nZkLA979yWumkv2OPbPh8qBJHJ+gMWt3Jg5di+aXY+1n2oo0PDijY8pAwuiH6lfrymp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395203; c=relaxed/simple;
	bh=IIAx7p/Y/bG1muyo2qcFpZsU5DlzD50fCECDKe8hPAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK7leLnk8jPbVtksgyvklmlNH3WacB8Sq7gMJP2kBkpR8/hvlRJCD2nXLNllZMf8EZCKS/Ce4gPdPBICSgpO4qkyx/DOsfQ4XykCiiJPq7VsfuDKHfS3Cv+zD3ijAZEQ2463RrRsGemzucaLsgwLtwVrAzwKYR1WD65EvOAivzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ji7psLWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ji7psLWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709DEC4CEE4;
	Wed, 19 Mar 2025 14:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395203;
	bh=IIAx7p/Y/bG1muyo2qcFpZsU5DlzD50fCECDKe8hPAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ji7psLWrQJjGjF+vhN2vYA5R0ugfJ0TAty/42jD3k87pV3JFp+XlkILlubgyhIzfG
	 MwNAQHkcWBrbQLjB8pZ3RX0/Q4204DjDmGtJBXnTH+sojG8DMjBOrzgSrTR574KTHr
	 s48qU1HwiPxOePsjR9bl4pDYQAOhgPRJevuVk7kE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/166] ALSA: hda/realtek: Limit mic boost on Positivo ARN50
Date: Wed, 19 Mar 2025 07:30:38 -0700
Message-ID: <20250319143021.827440002@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

[ Upstream commit 76b0a22d4cf7dc9091129560fdc04e73eb9db4cb ]

The internal mic boost on the Positivo ARN50 is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Link: https://patch.msgid.link/20250201143930.25089-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ec57148453c82..1fd6e84b0e371 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10527,6 +10527,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1f66, 0x0105, "Ayaneo Portable Game Player", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x2014, 0x800a, "Positivo ARN50", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
-- 
2.39.5



