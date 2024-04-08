Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F3F80BF3;
	Mon,  8 Apr 2024 14:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585203; cv=none; b=HFHWqyOEDcaPkf83xFefRjtiYGYZzYE99u3BDt3su+z0QECRiWM2sxt3lF33dIhAQu3hMl+5X5JI1tZ4Y82wVer2wXDnZmJllN+xNJ9bsBG6/b/Q/ArImqqKkyVikOeZAFqXC07ItbFo2sUxtRcYtJZdRdXsWxJRHkxfBSiu8QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585203; c=relaxed/simple;
	bh=3J3q2m6c7esPnt4G/qDDxy89Uu/p1ALbyQGlqyo1eUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hE7Wlx7fEROeWjOeJI3Eb5MWoXZP1P6Uz3MYBEjrfPc/0UhzHK0QVBcFQ5IyTnkMKA7Mi5t99jOYSoKfxX0YCMsvj/HjX3gi2PIO5geWzKpwgITCIPBoLycG+5vywalUaVyFQPy7nV9KEms58hBQI2ynziun8K1Fro596O9Cs+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJoEIUbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJoEIUbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C280C43399;
	Mon,  8 Apr 2024 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585203;
	bh=3J3q2m6c7esPnt4G/qDDxy89Uu/p1ALbyQGlqyo1eUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJoEIUbHu/OeAeM9H4psqKq6Yq7A6MuOTmlDWPUe9q13a1Qb7vg3R9Qq+WDQyHoCq
	 QyF250ttIL1uimfqkecFlbsNeE2Cu0k/DqyJXgUcyHVh1rvvN0JKhdei3Av6LBTWdU
	 307hIZlML/3JR3YPT3AlSD9pvbeRdFjPCsPLH2AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Gede Agastya Darma Laksana <gedeagas22@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 678/690] ALSA: hda/realtek: Update Panasonic CF-SZ6 quirk to support headset with microphone
Date: Mon,  8 Apr 2024 14:59:04 +0200
Message-ID: <20240408125424.281637076@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: I Gede Agastya Darma Laksana <gedeagas22@gmail.com>

commit 1576f263ee2147dc395531476881058609ad3d38 upstream.

This patch addresses an issue with the Panasonic CF-SZ6's existing quirk,
specifically its headset microphone functionality. Previously, the quirk
used ALC269_FIXUP_HEADSET_MODE, which does not support the CF-SZ6's design
of a single 3.5mm jack for both mic and audio output effectively. The
device uses pin 0x19 for the headset mic without jack detection.

Following verification on the CF-SZ6 and discussions with the original
patch author, i determined that the update to
ALC269_FIXUP_ASPIRE_HEADSET_MIC is the appropriate solution. This change
is custom-designed for the CF-SZ6's unique hardware setup, which includes
a single 3.5mm jack for both mic and audio output, connecting the headset
microphone to pin 0x19 without the use of jack detection.

Fixes: 0fca97a29b83 ("ALSA: hda/realtek - Add Panasonic CF-SZ6 headset jack quirk")
Signed-off-by: I Gede Agastya Darma Laksana <gedeagas22@gmail.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240401174602.14133-1-gedeagas22@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9270,7 +9270,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
-	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
+	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),


