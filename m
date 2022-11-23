Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963EC1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:35:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA3FC433D6;
	Wed, 23 Nov 2022 09:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196103;
	bh=UH7N4mulveR3/AEhSRAXCvgZfsF4zIQEscJ0MjGYYK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUD/D6hMMyfSK3QQkQajYqIESs2RzV3G8cjyI8Gq/ZqM0CuYJZylufUtBKTKWs5Ga
	 AZRVgEw0H+mlIa2o32JOVS2l+3uDIsNphTlKVvNOz5tUKYtfD6bOcvcpsg2yOXAroH
	 CUU3UxEWJ6ULyO5/NwFcF6ZJkNO3ftWMaNhVBohg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 120/181] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360
Date: Wed, 23 Nov 2022 09:51:23 +0100
Message-Id: <20221123084607.567754396@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

commit 1abfd71ee8f3ed99c5d0df5d9843a360541d6808 upstream.

Samsung Galaxy Book Pro 360 (13" 2021 NP930QBD-ke1US) with codec SSID
144d:c1a6 requires the same workaround for enabling the speaker amp
like other Samsung models with ALC298 codec.

Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1205100
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221115170235.18875-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9079,6 +9079,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),


