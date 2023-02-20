Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4D063BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC142C433D2;
	Mon, 20 Feb 2023 13:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901554;
	bh=FdThlU9NoGo6S45gPt5wEUNTnQFMwl45Pt6Bb9Vg/tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plSp41lHCUATKECsJH3WEfvQn7H8twwgVXTtBZaPhWdmATSof+AMXmucPH/tLZfPS
	 nBRImSzu6B7AR+aKqmEppofoXBGzSIyQu4U7XBnSFLEDRb1H82TYf5pVc6/c150fzX
	 MVQJvhbrK/CfJ51sdl9WaeWp/Fzd5rfKxV5tHRkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 060/118] ALSA: hda/conexant: add a new hda codec SN6180
Date: Mon, 20 Feb 2023 14:36:16 +0100
Message-Id: <20230220133602.833658710@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bo Liu <bo.liu@senarytech.com>

commit 18d7e16c917a08f08778ecf2b780d63648d5d923 upstream.

The current kernel does not support the SN6180 codec chip.
Add the SN6180 codec configuration item to kernel.

Signed-off-by: Bo Liu <bo.liu@senarytech.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1675908828-1012-1-git-send-email-bo.liu@senarytech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1125,6 +1125,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d1, "SN6180", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


