Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD2921FF2B;
	Mon, 23 Jun 2025 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716515; cv=none; b=sKGkOYsPCdO4Fn5FJw2agaRpueHuPJ3HohIjbfhLUiKxBMK3xIRwAoDIUZiIkauodPxKBarXTqMkVmsjaVJtY3R2uXBlcyKkq6YGv1RosCekJHRNFpzLyOyvAwIj6D86N1i0VPdQwBEyt7AKgWEnxzhA0uL5/g0qKKIvQ6A79zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716515; c=relaxed/simple;
	bh=BXXOy2dPk1iI0E7KQJ+57z0AWoReDPmdqNIjvlyrkF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBh9KZq3YAdxLCv4A6jjll74yO64Jva644X4Hq6dmn8uCAa9d/6jf9VD7xYmTRhHtYCqaT6wEfZgxLdir5bAZ/KlTN2i3f8oHRdm844fk/3qyDEokCuhhr02Am23DRE2PymIDJsc2zaXuPm8j9P+SJjh6FMfQ4qHwnxpUH64LQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xgh5RmKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xgh5RmKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A855FC4CEEA;
	Mon, 23 Jun 2025 22:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716515;
	bh=BXXOy2dPk1iI0E7KQJ+57z0AWoReDPmdqNIjvlyrkF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xgh5RmKYt6KLVpNc86bVpDTPNR/X0dmLbTSF4958bU7jtGYQVhW+lR6UZlGNewKw2
	 dvpw6TIP2f4yYvqqSCm67AiSMyPt1GtSEO+7H5FLojPcnTQFqbcPSmW3I2jyP1NJGU
	 VK+3NI2dwkAZbHAS792jFTveNg/dSo6znf11tnWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Lane <jon@borg.moe>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 360/411] ALSA: hda/realtek: enable headset mic on Latitude 5420 Rugged
Date: Mon, 23 Jun 2025 15:08:24 +0200
Message-ID: <20250623130642.704275679@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jonathan Lane <jon@borg.moe>

commit efa6bdf1bc75e26cafaa5f1d775e8bb7c5b0c431 upstream.

Like many Dell laptops, the 3.5mm port by default can not detect a
combined headphones+mic headset or even a pure microphone.  This
change enables the port's functionality.

Signed-off-by: Jonathan Lane <jon@borg.moe>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250611193124.26141-2-jon@borg.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9214,6 +9214,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
+	SND_PCI_QUIRK(0x1028, 0x0879, "Dell Latitude 5420 Rugged", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),


