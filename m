Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D9814F9DA;
	Tue, 20 Feb 2024 21:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462898; cv=none; b=FO2cvrEroeYuZnMgxSe2f9vn4JOlxQlUYr7mxAZTbzTZ6cKbNnhNKlh0LaGTLksrujqAQFVHaQOXdVpN/Yioea1f1U4dKSADNcR2IJLH4xE7Xe3XKa6xIN0Vd7R7dK/AmmU3zuApXZGKs1Xuw0qo1THEHLCnayd266rfep8KUcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462898; c=relaxed/simple;
	bh=94r20CpRRivFwajZpfSVksakSnejnSZUG4ZZeQySdeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+EDojHXzwDX4Zm0HluV0SI4C9J0LCq+uhfnWHSk5mmCvBwSL2JyKzHUDvPQ8AQ6h/f9HUfGmFiUiF/8PPdjSBZFGwUCoi6X/oQ/z86IIWOaHN2J/HGOGlUoBj569AR2E6XQ6CJuNkykFl1XBtX8gSreYSAQXq9Mmr9rM1rK8M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Yk+P55T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Yk+P55T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A198C433F1;
	Tue, 20 Feb 2024 21:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462898;
	bh=94r20CpRRivFwajZpfSVksakSnejnSZUG4ZZeQySdeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Yk+P55Tovuu+kEpiVq6IskeUG9zkZF30J2ihsJ2c5MspW+fjrNG1eeMDoA46sZeS
	 HZ7/S2+66ehcPSqHxA5QK73lGhKWiqdrZx9KqvZHCXMwrTRE56vk0MINTtiAMBMfvH
	 tfdyw9SU8S2sGydvwn64g1bxksDvObPQMb/PgoqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Senoner <seda18@rolmail.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 042/197] ALSA: hda/realtek: Fix the external mic not being recognised for Acer Swift 1 SF114-32
Date: Tue, 20 Feb 2024 21:50:01 +0100
Message-ID: <20240220204842.339682250@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -9431,6 +9431,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x126a, "Acer Swift SF114-32", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),


