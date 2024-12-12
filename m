Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024802080FC;
	Thu, 12 Dec 2024 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016142; cv=none; b=s9UQeavZPboEsqRyQhyngXioFkVH6GdVQFMzXR17PI5X4gK2rHs2uF0/CaMvtQFA499hUmVp/omyNAhkuQVAMN9+xg4cQx+Ii930RlnrA3fZx6igNLckNyopqpfxrnfIJl4+kYLhMksLhhFpp0nPEUYa17k+aEnJiaDe7TG/HdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016142; c=relaxed/simple;
	bh=NjWE/Pkji4lYqDbDKx8YnSrV6bJx1R4OyIOrhyinDXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFgQAiJuuVD0UpMhYwrMoAs6pcwXnkFlZgvx8M8piheQw0TP6DVFf8o66gvleisDOHN8kI730g27r4rcvoYWDqkKDWDpt3TO+t9pc10LNevabFn26Co14OwT6GU9mkLJenhis5Xdq2dB+1TUW15wZIMQEdHFr1X+jOI1Fs+jrs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xdv0nsLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xdv0nsLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1D9C4CECE;
	Thu, 12 Dec 2024 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016141;
	bh=NjWE/Pkji4lYqDbDKx8YnSrV6bJx1R4OyIOrhyinDXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xdv0nsLMtD4MtfOvyeYF4rafvZqLh92jYNFYlQeopdeEnboqAI9ABkeq5wVluH8RE
	 ep+yp17UlXBspimxWpKUhKkY3nMHfH5VJ8gIj7/KQW5SazmeGJ+yaNfiMBN9xy5o/h
	 gZCcXamY65+FNwK7pDyMdaxkD7J3KY3Dd2Qtu69U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 144/466] ALSA: hda/realtek: Add support for Samsung Galaxy Book3 360 (NP730QFG)
Date: Thu, 12 Dec 2024 15:55:13 +0100
Message-ID: <20241212144312.486847926@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>

commit e2974a220594c06f536e65dfd7b2447e0e83a1cb upstream.

Fixes the 3.5mm headphone jack on the Samsung Galaxy Book 3 360
NP730QFG laptop.
Unlike the other Galaxy Book3 series devices, this device only needs
the ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET quirk.
Verified changes on the device and compared with codec state in Windows.

[ white-space fixes by tiwai ]

Signed-off-by: Sahas Leelodharry <sahas.leelodharry@mail.mcgill.ca>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/QB1PR01MB40047D4CC1282DB7F1333124CC352@QB1PR01MB4004.CANPRD01.PROD.OUTLOOK.COM
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10753,6 +10753,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xca06, "Samsung Galaxy Book3 360 (NP730QFG)", ALC298_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc870, "Samsung Galaxy Book2 Pro (NP950XED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc872, "Samsung Galaxy Book2 Pro (NP950XEE)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),


