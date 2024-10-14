Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E2519E802;
	Mon, 14 Oct 2024 14:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916603; cv=none; b=efuBkO2T0bcS6lP06fAqkXDQllXXSOfEud9SQ38Q80Y0lq2QpsQJn2OyW8Xv0cSLTu0qU+WAwb0q1c1WcsfoYKGCuVZCY2mJOjulry+VGWsF8rsHQYQ7KDc3kZGst8JCb5fdmWCISS+Xhymt+iZ+9hmAoTG2D0SaEPGV5oIjXls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916603; c=relaxed/simple;
	bh=yNvti6W+ZHgl5GeUmuiDI6rYbpZ0HMttADZ23TWUYAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ia+5m/e0y27iCRz6ZHfDIha4IDQwcPLR3fnXaM3m2dPfpliGEDBfo+x8r8e3Cu8SuB9RzQpMmskeI6Yr1mc6SI/LFtBJ3s5GZ3ONIBCjyuFxPg70o3Y++QhCNni5djFWzXIW4fW51DFxzeqVod8jDqDrXSBMrMOlgr9esv/xNSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjqf2/Iw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjqf2/Iw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDBC4CEC3;
	Mon, 14 Oct 2024 14:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916603;
	bh=yNvti6W+ZHgl5GeUmuiDI6rYbpZ0HMttADZ23TWUYAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjqf2/IwCQgfV0ycrkiAfoALhsuAQZ0BtUCJxTE43lhX0ZV8ihQauKLbWHM4bjO0p
	 oVovrywWAtZYTeTysKdWewsoH5MIzOsx6kRSbOAc5vFkn/jj1yYPQgi8wccYovaZB6
	 gyOkzILcJFrMWvmgff5ryYYJMN19naHo4ZrZ32hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jean-Lo=C3=AFc=20Charroud?= <lagiraudiere+linux@free.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/213] ALSA: hda/realtek: cs35l41: Fix device ID / model name
Date: Mon, 14 Oct 2024 16:18:41 +0200
Message-ID: <20241014141043.576723303@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Loïc Charroud <lagiraudiere+linux@free.fr>

[ Upstream commit b91050448897663b60b6d15525c8c3ecae28a368 ]

The patch 51d976079976c800ef19ed1b542602fcf63f0edb ("ALSA: hda/realtek:
Add quirks for ASUS Zenbook 2022 Models") modified the entry 1043:1e2e
from "ASUS UM3402" to "ASUS UM6702RA/RC" and added another entry for
"ASUS UM3402" with 104e:1ee2.
The first entry was correct, while the new one corresponds to model
"ASUS UM6702RA/RC"
Fix the model names for both devices.

Fixes: 51d976079976 ("ALSA: hda/realtek: Add quirks for ASUS Zenbook 2022 Models")
Signed-off-by: Jean-Loïc Charroud <lagiraudiere+linux@free.fr>
Link: https://lore.kernel.org/r/1656546983.650349575.1707867732866.JavaMail.zimbra@free.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 5cfeda80cbf10..07e1547fff2e5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10092,11 +10092,11 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1da2, "ASUS UP6502ZA/ZD", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
-	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e8e, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA401),
-	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1ee2, "ASUS UM6702RA/RC", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1c52, "ASUS Zephyrus G15 2022", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.43.0



