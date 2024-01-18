Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F333AB65C;
	Thu, 18 Jan 2024 10:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575038; cv=none; b=tNkes4hg3wD9edqe5BSVP+EYUKOnUZ0Cf99mGDKFboxH5Q0aqOrRxb4/270IoJn5UkkfPeLkT6fSr8y7+CgZbqxlsrbFZpB13KrJHHwxDesc/BZ09qvChbGRRyMeWv1q45Rll6G41fZVi5fYRvTiztDu7mfQOyfHovY94UhLzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575038; c=relaxed/simple;
	bh=zfG0HL/tnSI+lxV0iHqFertDZH+QZ1QVdAobVHDG1rk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=NvqQ1qmfsoqqbgKZXmwdZHSYmiKZ7Iaki79ZhzX9c40luGeoWifTrMzMGLFvxGJJMGQL+dqlO1pHEnJnbbxlj4Tek/2QPvyXClbmW8DLurMLI+7mXfXj5S9L9zyyZD9nfEKbc9D73I4PACpttB7XMnzcu5oHXTT/kfAXnkciAgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJKwF784; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJKwF784"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A86C433F1;
	Thu, 18 Jan 2024 10:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575037;
	bh=zfG0HL/tnSI+lxV0iHqFertDZH+QZ1QVdAobVHDG1rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJKwF784hLx0vU1xN7LEKBLthETljN/cNTKMAjsMReQ35E8ZfJrYmNO3j9TMGt3CS
	 0xa2rG1x5pO1h57h3pHliRX+i75itADHSkVmljuUucH9DI6O5g4ylx6cgWb9lilrOw
	 i2I9zxgw6UzGZ2wPnht8Kri6l9CFZaX46cN5bLbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Jason Schwanke <tom@catboys.cloud>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 07/28] ALSA: hda/realtek: Fix mute and mic-mute LEDs for HP Envy X360 13-ay0xxx
Date: Thu, 18 Jan 2024 11:48:57 +0100
Message-ID: <20240118104301.493360051@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>
References: <20240118104301.249503558@linuxfoundation.org>
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

From: Tom Jason Schwanke <tom@catboys.cloud>

commit 6b3d14b7f9b1acaf7303d8499836bf78ee9c470c upstream.

This enables the mute and mic-mute LEDs on the HP Envy X360 13-ay0xxx
convertibles.
The quirk 'ALC245_FIXUP_HP_X360_MUTE_LEDS' already exists and is now
enabled for this device.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216197
Signed-off-by: Tom Jason Schwanke <tom@catboys.cloud>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/651b26e9-e86b-45dd-aa90-3e43d6b99823@catboys.cloud
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9829,6 +9829,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x877d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8780, "HP ZBook Fury 17 G7 Mobile Workstation",


