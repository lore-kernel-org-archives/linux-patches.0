Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E114A4E6;
	Tue, 20 Feb 2024 21:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464610; cv=none; b=Wph43frWdRngPuCQ0gtawttp4AeRhyv330plYw3m8vi7uKD3rxW1HzJVflwQ7/x/gbIgV31+TGOxk5KWqIlXkbElyUWScKwZ0OcPPs5y8LZlL3gFpg5Wga9sbvi6HFRGjbOVRO5zXjTERwiXkhmeZBAyVjThYxyEkmsEmn7fvHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464610; c=relaxed/simple;
	bh=doRk5RLZvB9e4VrTHmNce3TEb0Ik87r0NcHg84D8jlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlBJREz8jrKSJMWnQpvIn+rgcShJaTw6gqCf6iDEl7lrcS/FTao1YlG2Vg6pbHDKd9CzwjQl60V5u3Hs0/FlEioeUVYBxzXL1vT+e9NL7Pmw1w7wMtqusYO2cSLrRcGSXBpQ+iTsrdcNB9XNPmcra206syFLkLRg5vh15DX57CM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JcfeeJY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JcfeeJY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A685C433F1;
	Tue, 20 Feb 2024 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464610;
	bh=doRk5RLZvB9e4VrTHmNce3TEb0Ik87r0NcHg84D8jlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JcfeeJY2oqppKdWNwX8ElmwLkBsk64Yl19iDZXeJcw27kcrqv+0z59SlnI1hM5mlA
	 /tWsuKOnDc4fZOi2uy86muHAtA79tAafPmS7Yr1pqtMQ5kD5IxS35fHot3tLyHbTLg
	 /Wa+PxbJ3MZQi3ubaBPx0Mov0HjRALetjviWmxig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Senoner <seda18@rolmail.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 079/309] ALSA: hda/realtek: Fix the external mic not being recognised for Acer Swift 1 SF114-32
Date: Tue, 20 Feb 2024 21:53:58 +0100
Message-ID: <20240220205635.673358564@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Senoner <seda18@rolmail.net>

commit efb56d84dd9c3de3c99fc396abb57c6d330038b5 upstream.

If you connect an external headset/microphone to the 3.5mm jack on the
Acer Swift 1 SF114-32 it does not recognize the microphone. This fixes
that and gives the user the ability to choose between internal and
headset mic.

Signed-off-by: David Senoner <seda18@rolmail.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240126155626.2304465-1-seda18@rolmail.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9640,6 +9640,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x126a, "Acer Swift SF114-32", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),


