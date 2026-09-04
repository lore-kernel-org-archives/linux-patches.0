Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3738638B7D4;
	Fri,  4 Sep 2026 06:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501682; cv=none; b=EnF+wKsG9gtREQeuJOj04WJ/if5OqpFTzVELnxBWS3gXnB29ZzC0r6s8bFAUR4Jkv5B5mtyUXo4vr3me+KKp7OeGF+3faT2pNCEpyR7gF86mZ/wKrFe8LulBeZaoyqhCvkWMZ5+eeJSHYUFKCyOGOt4Lxgpsglivp+gNEjFKg74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501682; c=relaxed/simple;
	bh=mtTEO/pdy/64dY+srE9njVY0hrhQUqIJ8LZtUZHYWXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxlLOEMn5XVY8qUNL7m+MIGP9vBVlScOye7fFCJyOOlDracTFwnFTtF206nCUevthelbB0N2nFSXTYYoBx+oezIioJ1inXs/AZiuHCMCaNCEgn9CkAkmAy1KKZphGX1uGAAocVrpE6rTObM1dwOnMv2NBL76VDWmhbqAI+nPIAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQi0B6WL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQi0B6WL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87ADF1F00A3D;
	Fri,  4 Sep 2026 06:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501681;
	bh=sgnuj01BTp/kRmlepEQ3Dfb2KEaiC4xuTZbss8ViGC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQi0B6WLXzZvMo8lp2TJXasgRk+Ogis112z6ez4jQeCgEu60MoXhfZ1N60FtereDc
	 K/M8yfH0AvGv8qfJTExYZsoD4/vplR77A7ri9ZdBz4fCVdn/iw1DE7QW/JpfJs4UDC
	 Mga7G6t92KnSbd71dDQQVu/Tb3grgSWnOP2cdQs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 496/552] ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx
Date: Fri,  4 Sep 2026 07:00:53 +0200
Message-ID: <20260904045801.904330635@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eckhart Mohr <e.mohr@tuxedocomputers.com>

commit e72d5659a2606056a0c34af212b46a3275a55bbf upstream.

Fix microphone detection on built in headphone jack for some devices

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260821144437.27233-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7563,6 +7563,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x30ba, "TongFang XxAF5xxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


