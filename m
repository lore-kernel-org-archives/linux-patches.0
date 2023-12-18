Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AB0129EC8;
	Mon, 18 Dec 2023 14:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0T+87SS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1893FC433C9;
	Mon, 18 Dec 2023 14:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908809;
	bh=Dg4SLEdRybwfy7HZCT0amhNKcnBgb3kWUByyPSIRGOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0T+87SS3gifFx3WMaZFSYIXWbQ7X+T/GWGwjaQcLNctcHSvlJ0eqjhTcV83aYBg5u
	 f5mPq7YrvOTvoW1FMD370xYvypMcEUHcLpWMUSU6GRr4QnqwScRBfI9+yW2gEqy2KP
	 LITIoBVCTfTV936Im5/axX1wUCkOlMxduBzvw4J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hartmut Knaack <knaack.h@gmx.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 42/83] ALSA: hda/realtek: Apply mute LED quirk for HP15-db
Date: Mon, 18 Dec 2023 14:52:03 +0100
Message-ID: <20231218135051.617223317@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
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

From: Hartmut Knaack <knaack.h@gmx.de>

commit 9b726bf6ae11add6a7a52883a21f90ff9cbca916 upstream.

The HP laptop 15-db0403ng uses the ALC236 codec and controls the mute
LED using COEF 0x07 index 1.
Sound card subsystem: Hewlett-Packard Company Device [103c:84ae]

Use the existing quirk for this model.

Signed-off-by: Hartmut Knaack <knaack.h@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/e61815d0-f1c7-b164-e49d-6ca84771476a@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9050,6 +9050,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x83b9, "HP Spectre x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x841c, "HP Pavilion 15-CK0xx", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8497, "HP Envy x360", ALC269_FIXUP_HP_MUTE_LED_MIC3),
+	SND_PCI_QUIRK(0x103c, 0x84ae, "HP 15-db0403ng", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x84da, "HP OMEN dc0019-ur", ALC295_FIXUP_HP_OMEN),
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),


