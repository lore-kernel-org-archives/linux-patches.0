Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3F51C6AB;
	Mon,  4 Mar 2024 21:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588792; cv=none; b=YKWqgAr+IRuOOkV+P/k3XEp2ymDuMVxL0Wc2klEYkT6qMnWVSjSIaHU6xhLeFRDM6X4igphqBqiRnE57ZfW4MwM2QC0OLrs6hsFljr9TZIMQIDiXKLArOK6W/BUr6eo3e2+hJpZU3I8bvqxZ/PRA4twP1gKaXHtMzB4DrBAILE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588792; c=relaxed/simple;
	bh=9a970c+rjDP7lclr6lPBqPf9FPQUg9d5kUZpwnny2gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xb0uCU57cm8EVr03LUoe8gwUuZZbU/Pucda+8ZJJCGpotzvKYTcc2OgNnq2I9/UBublfCDabHLTUx/RLwZbME6/ExG1zso4cb+HFQRkt5L1WArl6xixqJuep50CDAD2yLXwvelCWfuL+SBW1LOHgDvRTzvQu4/BuOQkn4Okcywg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGha8tl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGha8tl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E3AC433C7;
	Mon,  4 Mar 2024 21:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588792;
	bh=9a970c+rjDP7lclr6lPBqPf9FPQUg9d5kUZpwnny2gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGha8tl5F5LVVu5M6Ui/73A9Fwle8+NDcckrbqzSOnXGaxIzmeJQG+vWXPbTOgjtp
	 N9kG2frayOTltMqF+zxHwTk8i8CHj0XFpvS+2YucKDWM7sZPCmCH7SlXJxeZkaGeEA
	 jm51xHPkCr8XBJlFokN2Res6ygeG4P2U99wCQltA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Peter <flurry123@gmx.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 074/215] ALSA: hda/realtek: Enable Mute LED on HP 840 G8 (MB 8AB8)
Date: Mon,  4 Mar 2024 21:22:17 +0000
Message-ID: <20240304211559.326388994@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Peter <flurry123@gmx.ch>

commit 1fdf4e8be7059e7784fec11d30cd32784f0bdc83 upstream.

On my EliteBook 840 G8 Notebook PC (ProdId 5S7R6EC#ABD; built 2022 for
german market) the Mute LED is always on. The mute button itself works
as expected. alsa-info.sh shows a different subsystem-id 0x8ab9 for
Realtek ALC285 Codec, thus the existing quirks for HP 840 G8 don't work.
Therefore, add a new quirk for this type of EliteBook.

Signed-off-by: Hans Peter <flurry123@gmx.ch>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240219164518.4099-1-flurry123@gmx.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9687,6 +9687,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


