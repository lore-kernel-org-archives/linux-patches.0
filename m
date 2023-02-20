Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1744E63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93433C433EF;
	Mon, 20 Feb 2023 13:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901144;
	bh=ONB8+SUyDkXyFK5MKZnn8vhVVHUTe5Z5Zg0CpID/a9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjdyHT2ukRIsAdr1SHQVMmdEH3sGf0hrJ0zU3gUOc6cfT3ItiAMOtWrIF9HQ5BPpH
	 Pql9NOF1QaTaLyxzydhr2Y5FWpSy8Ud83/S2X++ws4qdLdf6WeluFauKzqK9G5LeED
	 PnqB5LNsV591Jl2kpVqjagYnH/yxMClpFyBnYyT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bo Liu <bo.liu@senarytech.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 46/83] ALSA: hda/conexant: add a new hda codec SN6180
Date: Mon, 20 Feb 2023 14:36:19 +0100
Message-Id: <20230220133555.283039567@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
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
@@ -1124,6 +1124,7 @@ static const struct hda_device_id snd_hd
 	HDA_CODEC_ENTRY(0x14f11f86, "CX8070", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d1, "SN6180", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),


