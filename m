Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D687969942;
	Wed, 21 Feb 2024 13:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523283; cv=none; b=f9cvB3I6LmKql7IE4T3rR7mvUO+iGpC/I5JM2lUck4zGjZjluxyLKns2wRchajyiKG3hEzQ8nNR278MxDsNIWVWVW/THc4oOcT+7OcLMrKOit39CaVPV77v2BCMqSiLSmGZa57wfUq/PWbhBUVD5y2+IvWS42+JmlOGvZQDCX1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523283; c=relaxed/simple;
	bh=iX8zh1/DJWQq9dB5PTJ3kTbkr/s3aeitvEh8vTbdwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7V0WIjuNG5mT9mp317JFavSApgTCDmcqnIQt6pA0yuQUVC1H9NHOjuZH1yLYXFQy8IMVFEW2sUKfl2JQIgle7052CnZUCQtP3EnM1JDLRAJLdaIyVsEhNugQSj/kODFO3jPCK3GHhIjt0EsIIEjFE0XWn7WuE2aZ+LQ1T6CzIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3Y5WdzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3Y5WdzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47884C433C7;
	Wed, 21 Feb 2024 13:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523283;
	bh=iX8zh1/DJWQq9dB5PTJ3kTbkr/s3aeitvEh8vTbdwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3Y5WdzXEt3jqb09rQ5SM2QXoJkM7iq8RyehVYOa25fJCdQbgknU2wS2rXVM2rG/c
	 2YlUaAdetr0zeNMB5T6lKqbGNgOJA5uQYhifF6ClpjHd+RU9ua0MJZipQp69Pb1oLX
	 uHhPVrPVrrCPwBpzwglHEoFhcUbVryTpfz8iaB/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Senoner <seda18@rolmail.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 360/476] ALSA: hda/realtek: Fix the external mic not being recognised for Acer Swift 1 SF114-32
Date: Wed, 21 Feb 2024 14:06:51 +0100
Message-ID: <20240221130021.312329041@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
@@ -8905,6 +8905,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1025, 0x1247, "Acer vCopperbox", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1025, 0x1248, "Acer Veriton N4660G", ALC269VC_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x1269, "Acer SWIFT SF314-54", ALC256_FIXUP_ACER_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x126a, "Acer Swift SF114-32", ALC256_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x128f, "Acer Veriton Z6860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1290, "Acer Veriton Z4860G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1291, "Acer Veriton Z4660G", ALC286_FIXUP_ACER_AIO_HEADSET_MIC),


