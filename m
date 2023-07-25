Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71918F59
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A9DC433C8;
	Tue, 25 Jul 2023 10:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282168;
	bh=CW1YHLspWvSzcAVlQ1V3mBdlnP7+z0xe/Uqm0aDuToo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2jVAQ7rirbuhMOPgMmA5EgD2A/cDgY2v7X5Ky2nenk+DjtX8u6qqqTmb3HwjDmU3
	 r5z6yTnbQQERvLYb0EVtg87xcalaJR3Y90HtozuB2TjaR3MxF2Gy/1JXzpUjXRy4oN
	 BIEqO3QH6x2C59n8ZI+8rg5qb8z7BS/yZ/ZndVWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.4 004/227] ALSA: hda/realtek: Add quirk for Clevo NS70AU
Date: Tue, 25 Jul 2023 12:42:51 +0200
Message-ID: <20230725104514.976801634@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoffer Sandberg <cs@tuxedo.de>

commit c250ef8954eda2024c8861c36e9fc1b589481fe7 upstream.

Fixes headset detection on Clevo NS70AU.

Co-developed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230718145722.10592-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9647,6 +9647,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0x5157, "Clevo W517GU1", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51a1, "Clevo NS50MU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x51b1, "Clevo NS50AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0x51b3, "Clevo NS70AU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x5630, "Clevo NP50RNJS", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70a1, "Clevo NB70T[HJK]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0x70b3, "Clevo NK70SB", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


