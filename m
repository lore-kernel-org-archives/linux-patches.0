Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60F715AABE;
	Tue, 23 Jan 2024 00:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969749; cv=none; b=MQxnA2SZWn00YGHC0Qe3cf9jd7ilmEwW8FkHWcbbZ99BrN3uhTHiugRBRzQ4SkX6i0vBDfS9KvmggqQc3wlQatF+JebTCUapJEg6zkUifnrVxeb6O99UXfDQmOkT0mJjrmnp8kz9H4TY6AxYV6EPueWVQqLqL4gwEgfxeyYZwsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969749; c=relaxed/simple;
	bh=EbP13ZLD06Bmbi83NjiRq/A8K+O6AU41IQtL1Cgaap8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDJQsjjiduVul6XIdQl/gcVc13+0K+TwlLiLzf9RYLxWY9srvY4MWFWaM7jac9cro/MBBHFZhOQUzdJUcuRj5gU/B3xbyA8eIZaIDq9j42yu2TBCGEpO3hkScxUHcG91OkDEb8qDKr/WZCd1l9nXFRCDbsFGnsJS07rvDeaGsKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hh4N06JL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hh4N06JL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2222CC433F1;
	Tue, 23 Jan 2024 00:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969749;
	bh=EbP13ZLD06Bmbi83NjiRq/A8K+O6AU41IQtL1Cgaap8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hh4N06JLsjPNJzQamWcz/AQaba1EsIv7jjA0eBdGGx4lvFja4Pk5YnqYgdboXksMN
	 GVb2bBFRT9JlmsK9He52uunFSjX65HqPxDzQ07cVrensnmZ/cj7ZDW2TSO48mf9X2p
	 yixGoFyuu4+8DeAWQ9R8SbDBXGRcSl/fxjcbHIhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Li <bin.li@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 421/641] ALSA: hda/realtek: Enable headset mic on Lenovo M70 Gen5
Date: Mon, 22 Jan 2024 15:55:25 -0800
Message-ID: <20240122235831.171058406@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bin Li <bin.li@canonical.com>

commit fb3c007fde80d9d3b4207943e74c150c9116cead upstream.

Lenovo M70 Gen5 is equipped with ALC623, and it needs
ALC283_FIXUP_HEADSET_MIC quirk to make its headset mic work.

Signed-off-by: Bin Li <bin.li@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240117154123.21578-1-bin.li@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10220,6 +10220,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
+	SND_PCI_QUIRK(0x17aa, 0x334b, "Lenovo ThinkCentre M70 Gen5", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3801, "Lenovo Yoga9 14IAP7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),


