Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E251CF41;
	Wed, 30 Sep 2026 16:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784755; cv=none; b=FnDrTqbCO2qKQUxkukSfHHJcT7JAQx3pI32w9uq3s//XtN6iMzyf0nAyvwQu0R/3NY1R5knBsFtwYY0mvb9oEzOyzdVuYbKskjVvd9CYrXssM4R4LubWcuL7iM8RE2PMcd0iZe/lp2Z7gJ64bQ8JOvnOpjWRAXFqGAhqvVzwx1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784755; c=relaxed/simple;
	bh=w9bBobOvinbejBIPul8UkC2fdNtNea9iwsm3/8l0cCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWmLMylH5lErY7rVF3gIvAk57wdaarV3bgo72YlZQL2ujPbeiXhDqMcCPi7/FLbuOW9NeMyZs5wG19uU7QVnfJM39ZE9/oefLToDuFxeEId2OL49pcScRn5CyFgR2PUtKnen/OCM87b6qJ7cGYhBlBekj8z36LNWayGomJf23U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hki5ZqEi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hki5ZqEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4621F00898;
	Wed, 30 Sep 2026 16:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784751;
	bh=KzCpmy7GR94DyTnQ3Iiy+aTTGNtbmyrJmMosdcQcIPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hki5ZqEi7IwzhiqWL0Cjs/+o85Ag7wPqJdxD1ChdwKq4ZgwY/JUTEq74kLVo6jb+X
	 ZzGd9h+4dXbO7uS669nWnOI/9TeVk780iat+KGJ/FT0Lonu3pUCoYMj9/ufK4tuNl2
	 oowkrmAb//XeGKb8htxOW9hcP6RDQ8goBawd8lxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marcel=20K=C5=82os?= <marcel@marmak.net.pl>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 267/982] ALSA: hda/realtek: Add quirk for HP EliteBook 830 G8 (8AB8) to enable mute LEDs
Date: Wed, 30 Sep 2026 17:16:43 +0200
Message-ID: <20260930152422.538473022@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcel Kłos <marcel@marmak.net.pl>

[ Upstream commit 728d34ebf91c0e80b63a66b237dd0dfc5a8e5b4d ]

The sound and microphone mute LEDs do not function on this newer
revision of the board (8AB8) while they do on the older 880D models.
I have verified this on another laptop which was manufactured before
the one with the issue.
Added the ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED from a G9 model, which
uses the same codec, to make it work. Tested on kernel version 7.1.3 on
the aforementioned newer revision notebook.

Signed-off-by: Marcel Kłos <marcel@marmak.net.pl>
Link: https://patch.msgid.link/4dab5622-9100-4730-8c99-b58da939549b@marmak.net.pl
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index e79eb082810d7..c2b941bf338db 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10038,6 +10038,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab8, "HP EliteBook 830 G8 Notebook PC (MB 8AB8)", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
-- 
2.53.0



