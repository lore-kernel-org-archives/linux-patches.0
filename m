Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D15F6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99163C433F0;
	Mon, 16 Jan 2023 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887019;
	bh=Hhaael2frZSe6Jse1qUuGwLB43dKPfzxCToi/yJM1MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jaTdEfElhZ3Of7iLcU5QEt1X45oKcFbJRutGrbMIB4stSYMEzoLgr4PV7OPPHa0cN
	 uww/iWOPOOhcIuCY+swmzE8p0RlYVY/c9ijp0dRIj74Sb5lM0vudzW1WzOwelzJdra
	 Sv0L/ncqAFUe8CH0cuok4xhwq2992hwFfvVM6JR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Chan <adchan@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 609/658] ALSA: hda/hdmi: Add a HP device 0x8715 to force connect list
Date: Mon, 16 Jan 2023 16:51:37 +0100
Message-Id: <20230116154937.360880386@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Chan <adchan@google.com>

commit de1ccb9e61728dd941fe0e955a7a129418657267 upstream.

Add the 'HP Engage Flex Mini' device to the force connect list to
enable audio through HDMI.

Signed-off-by: Adrian Chan <adchan@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230109210520.16060-1-adchan@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1821,6 +1821,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8715, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	{}
 };


