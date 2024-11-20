Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333381AA793;
	Wed, 20 Nov 2024 12:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107532; cv=none; b=ehCfjqCvsbcKnmfbpOl4DFRnwU8HO+J4cRH5rU4WzZFvTJ2huTUPK8wjocj+zHuH1ZNgrqqph6c2mJsHV8rOsYg4PW+ydYBFvXqD5LBxWfTa+bLbGcot/XJWGHMOPWmrFEJo6KEdxD+LFQEymlP7fJG5Wvrb1zw59jTC16vRI64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107532; c=relaxed/simple;
	bh=jIvnw2Ai34zh22YL7yBeHnjaijaHCxFPqcCC82ofT2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjjlfBZXklzjSWq/sDRzV5qd8uvcUlEivg0gwtE3tkd43OsAyJOOF968tx7Z+Vp+4h/4kdvIMg8peJHFs5eZrM/LbUk1hWiOEZyPHLFAlO4GUIjfLqOW3fyUhm9bBQ11DhXzPbX4xkM2cfYj/hGmr1V5TIl0NGvnZrn89wouPaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bRXstaH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bRXstaH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4072C4CECD;
	Wed, 20 Nov 2024 12:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107532;
	bh=jIvnw2Ai34zh22YL7yBeHnjaijaHCxFPqcCC82ofT2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRXstaH/sDekwc3GqgqJoB4+OTUBU4b5r/PvMrZgW3nNE3M2q9akhk0Idi1FOep+I
	 8/YIIDW39061FC0acbSJtoX3EbFy3m28WfYytBO78R40p5OotqVjml+L7bm1oqdLs4
	 IyYQX2n+FlHCDSbuOJNQai6aV5TrGRLgNsEPHiR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maksym Glubokiy <maxgl.kernel@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.11 064/107] ALSA: hda/realtek: fix mute/micmute LEDs for a HP EliteBook 645 G10
Date: Wed, 20 Nov 2024 13:56:39 +0100
Message-ID: <20241120125631.119812402@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maksym Glubokiy <maxgl.kernel@gmail.com>

commit 96409eeab8cdd394e03ec494ea9547edc27f7ab4 upstream.

HP EliteBook 645 G10 uses ALC236 codec and need the
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to make mute LED and
micmute LED work.

Signed-off-by: Maksym Glubokiy <maxgl.kernel@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241112154815.10888-1-maxgl.kernel@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10483,6 +10483,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8b59, "HP Elite mt645 G7 Mobile Thin Client U89", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8b5f, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b63, "HP Elite Dragonfly 13.5 inch G4", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b65, "HP ProBook 455 15.6 inch G10 Notebook PC", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b66, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),


