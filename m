Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C09D537FF;
	Sun,  1 Sep 2024 16:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208241; cv=none; b=kM0vWLHBYuQgy2D9vExcvxTp9qFsfoEzYyPVfZEgGXGcy9YmmiGNOLHAYgY/FcxMUTNXnNjCt/M8Q9BG8YBa6lkLXskUKpwTg5snYwYvvu2IQQ7VhXgqgOb3wfO2FNHDrEx2sgpp39L5r5Yfiia2KitBxht/cjd9RBAJ05EqiXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208241; c=relaxed/simple;
	bh=PUpy0cisUvFfTdHo9NxsCdsz18lKhMDGZOiQNiFw1UA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V00rERiDIa0RSO67SY8RjTnZLxs2QS9x2gWpsyJGrrVKNiIU+P0kVdL5SjdUymkcpMPadZy2/EWKUAQ9PU1jQsUWcjD4c7NJpj1xkd9fKnkCSXHdvr4VZi/BOJc9k8BFCIfEeBPLza7d4hi0CSckdE79D81tBAF9Z9hoAk9vdp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqWHTwaX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqWHTwaX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD5C4CEC3;
	Sun,  1 Sep 2024 16:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208241;
	bh=PUpy0cisUvFfTdHo9NxsCdsz18lKhMDGZOiQNiFw1UA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqWHTwaXUIkPeuwqto6W8Rqkhk5kOJmQDfAlWikoJVSyWtxV8S/rYAP9fvNW00cyN
	 85gIdYKFUGekbitaQ++koK5j+fYBMnFB+Ec7HR7RUF6j2IlUIhOMxwxREGNcNbcN4p
	 srS3hDBpexcXbEBpmEaM+CQowwy+p75nA2RK2f1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Sweeney <john.sweeney@runbox.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 004/149] ALSA: hda/realtek: Enable mute/micmute LEDs on HP Laptop 14-ey0xxx
Date: Sun,  1 Sep 2024 18:15:15 +0200
Message-ID: <20240901160817.632613500@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Sweeney <john.sweeney@runbox.com>

commit 56314c0d78d6f5a60c8804c517167991a879e14a upstream.

HP Pavilion Plus 14-ey0xxx needs existing quirk
ALC245_FIXUP_HP_X360_MUTE_LEDS to enable its mute/micmute LEDs.

Signed-off-by: John Sweeney <john.sweeney@runbox.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/E1sfhrD-0007TA-HC@rmmprod05.runbox
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10221,6 +10221,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c15, "HP Spectre x360 2-in-1 Laptop 14-eu0xxx", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x8c16, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8c17, "HP Spectre 16", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8c21, "HP Pavilion Plus Laptop 14-ey0XXX", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8c46, "HP EliteBook 830 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c47, "HP EliteBook 840 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c48, "HP EliteBook 860 G11", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


