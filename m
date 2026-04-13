Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB121A680C;
	Mon, 13 Apr 2026 16:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098596; cv=none; b=bRMf727ZfBDWR/303hkfmPZNQgf1lxOVta32HweMC52q7P4Dm8pcDwBxaJ9Mjt9jxkOyEKufkTMP8FegIgfTBgh0LlM7nbGUgw2L7UCAWNEoO3aUoYIO3WFg5rkyA5XniRQinwiY8G57MzmoB7iPeb+ZVml7ptq8J0klPsknrJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098596; c=relaxed/simple;
	bh=rMHZJKsIgBgXND2e0a2hXKqaVgSYKLwm58KGD8SBe8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oN4CRY0AYqZvF9H0NZyv/qG4Up9PsJw6+gxdJxZUL+o7zsjpJ5RYppvp2YJc0nNVpDSefcKavhgaAm4LlNqXj1LgusaZ0BMeSepUl0/ONPiGV0ku6ewU+bnu2Y+q93Xki+QNkRQcX0D72CLPvu9UBVuCJNXiYAg3lj1E8BnBL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJmBcXYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJmBcXYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FF0C2BCAF;
	Mon, 13 Apr 2026 16:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098596;
	bh=rMHZJKsIgBgXND2e0a2hXKqaVgSYKLwm58KGD8SBe8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJmBcXYlJIZS0O6e7809125iGax9ka5AN1ZJyGWmNJXrPLq2Z131gGlS2zlIMk54D
	 ptXX8Nz6dec/h9uwEZXso7S4BSQTSdimHTdTNMSw6Pi8sP4lCCBjPGPymnHgTj67+v
	 RjFMYemOAk7daLDhw7afAZ3vGWPsabKmE1V3rEFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/491] ALSA: hda/conexant: Add quirk for HP ZBook Studio G4
Date: Mon, 13 Apr 2026 17:54:20 +0200
Message-ID: <20260413155819.625010738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1430ee344854..fae09c88a33c0 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1026,6 +1026,7 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x826b, "HP ZBook Studio G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),
-- 
2.51.0



