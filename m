Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42FD1EF1C;
	Sat, 13 Jan 2024 10:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdM/DVx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E8EC433C7;
	Sat, 13 Jan 2024 10:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140002;
	bh=Bi0WOo67ULixrphiuKW33WxGEFBIaYyDK4KnZM+pDHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdM/DVx8eNnhMlJYLhVrNwH+VL1Fyo/yprXsKvNxCKG/ycVdEDjPjDkEA5l/+GlhT
	 3d7mkIQle3jbpGj4mNyIxUVW5iCv7Px3UY3OOf36YnIlFBV3MBDMEbw1aFxJFOUbDs
	 08nHMtUkEmbIJPA7cyVVzUbyJ+LtlwjUNZ0Z/Reg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddhesh Dharme <siddheshdharme18@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 03/59] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP ProBook 440 G6
Date: Sat, 13 Jan 2024 10:49:34 +0100
Message-ID: <20240113094209.410870210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddhesh Dharme <siddheshdharme18@gmail.com>

commit b6ce6e6c79e4ec650887f1fe391a70e54972001a upstream.

LEDs in 'HP ProBook 440 G6' laptop are controlled by ALC236 codec.
Enable already existing quirk 'ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF'
to fix mute and mic-mute LEDs.

Signed-off-by: Siddhesh Dharme <siddheshdharme18@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240104060736.5149-1-siddheshdharme18@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9054,6 +9054,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
+	SND_PCI_QUIRK(0x103c, 0x8537, "HP ProBook 440 G6", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x861f, "HP Elite Dragonfly G1", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),


