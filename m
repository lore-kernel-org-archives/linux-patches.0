Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586B81C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:53:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0385C433D6;
	Wed, 23 Nov 2022 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197186;
	bh=M1tiEDPlysW26DS+/MGU5V9FjDiIZ+/hZ8qA/D+R5Vg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l7gwZHjXAQ3qHUD9a4RXMk5/J3IbFPjJRqOQi1hegrTgeLXiaDWOj8snrTX46WiE
	 gcDD1aUfUVT6b55oJfzWU0Ur7zAbIX6CNm3RB2t4ly8nxd8AQyxe5ZMaeo4I4TYKve
	 T1xJrHqZr9Np9r56L+wfpQR0TEWr2zizxw6hQA0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Flink <emil.flink@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 222/314] ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro
Date: Wed, 23 Nov 2022 09:51:07 +0100
Message-Id: <20221123084635.589427754@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emil Flink <emil.flink@gmail.com>

commit b18a456330e1c1ca207b57b45872f10336741388 upstream.

The Samsung Galaxy Book Pro seems to have the same issue as a few
other Samsung laptops, detailed in kernel bug report 207423. Sound from
headphone jack works, but not the built-in speakers.

alsa-info: http://alsa-project.org/db/?f=b40ba609dc6ae28dc84ad404a0d8a4bbcd8bea6d

Signed-off-by: Emil Flink <emil.flink@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221115144500.7782-1-emil.flink@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9446,6 +9446,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),


