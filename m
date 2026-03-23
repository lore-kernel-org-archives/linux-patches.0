Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7517A23ABAA;
	Mon, 23 Mar 2026 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282183; cv=none; b=ro3o6SsGLuCOukmNVrA40smyxov/mnBmoCp9bxyzg1TRN3bRSmMJpVe8/qHLDgpy1FjCTwRM5GanJsSoBhiXAvCbVHPGCuoCWcDjWyH/POTH5pv570GniJVZAtSgYJ6eKb60GnZJsNMyvRgkf7NByR95ZDoapi4Jy8XIoJhajCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282183; c=relaxed/simple;
	bh=6KcsMdxu/l8cmwI/loD/vFtr3N6tks9RosHjciLN2fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRtHE4WI1x0SFJWKpwvx/xl0lBvWuL5VMVcqMloWWj+lUFDTkpGInlXAqABT/91lKih/cCweWvklxwOMLKWEbSqr2mx2EkJE2hrKG9qt8fJ10dR2H74DttN++QhT7skPwViZZT0BxlhQ7H3bWqPdOIZRh3AUV381zhUj8mXlf1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y23k+bjG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y23k+bjG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7877C4CEF7;
	Mon, 23 Mar 2026 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282183;
	bh=6KcsMdxu/l8cmwI/loD/vFtr3N6tks9RosHjciLN2fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y23k+bjGBIub9GcXfWgjoF247d63KMJ5xW6qdPxplTc/scjFXtFOgoUqnOVe3pfx1
	 uwU+SsYkvIyZyEFO444dvy1+sLbBaPCyJlEF8kjH7vwDljdkFyFHImFBXP86lNqeu/
	 4R/P83krcwV3lkFTYTiQ62Hs8Ta0B/eE2Tnc4Eno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/481] ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
Date: Mon, 23 Mar 2026 14:40:45 +0100
Message-ID: <20260323134526.759766439@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1585cf83e98db32463e5d54161b06a5f01fe9976 ]

It was reported that we need the same quirk for HP ZBook Studio G4
(SSID 103c:826b) as other HP models to make the mute-LED working.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/64d78753-b9ff-4c64-8920-64d8d31cd20c@gmail.com
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221002
Link: https://patch.msgid.link/20260207131324.2428030-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index a3d68b83ebd5f..643d1f7ba5ad3 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1099,6 +1099,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x826b, "HP ZBook Studio G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
-- 
2.51.0



