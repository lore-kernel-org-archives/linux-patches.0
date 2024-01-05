Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FFC28FA;
	Fri,  5 Jan 2024 14:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DpZSmZPs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925DEC433C8;
	Fri,  5 Jan 2024 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465773;
	bh=9XeR/GhrlH2lAutuHpRvJlbs/HIkn9CwJCqX0K6X9Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DpZSmZPsVnzGpWaN9Th2+1eu5HfSWDqLPPSFKObvOakeCZTZnDxy9ymWDZyR/ZRC2
	 mrJpZqXCfKavWeRar9tk7SCcDG3tYgJL7tthRpVrbR3w6XySEFv5nwIf7xPt+6i9ee
	 6SxBNzkZTEuzbp9vME8OtW4b6ax7UG7Rwhd3J14Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 22/47] ALSA: hda/hdmi: Add quirk to force pin connectivity on NUC10
Date: Fri,  5 Jan 2024 15:39:09 +0100
Message-ID: <20240105143816.371983225@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143815.541462991@linuxfoundation.org>
References: <20240105143815.541462991@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Vehmanen <kai.vehmanen@linux.intel.com>

[ Upstream commit e81d71e343c6c62cf323042caed4b7ca049deda5 ]

On some Intel NUC10 variants, codec reports AC_JACK_PORT_NONE as
pin default config for all pins. This results in broken audio.
Add a quirk to force connectivity.

BugLink: https://github.com/clearlinux/distribution/issues/2396
Signed-off-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Link: https://lore.kernel.org/r/20210720153216.2200938-1-kai.vehmanen@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 3b1ff57e24a7 ("ALSA: hda/hdmi: add force-connect quirk for NUC5CPYB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 56943daccfc72..a0de66674faaf 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1825,6 +1825,7 @@ static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}
 };
 
-- 
2.43.0



