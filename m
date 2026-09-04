Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB254137B2;
	Fri,  4 Sep 2026 05:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500085; cv=none; b=SuuNw66f7Ic645/w8AUOQ5w2DR/DS/QYjV0NwR41xqeShv0jkFvM78AJY7Bky7kg7xnAuNTNMEwjJ0TqJqcobv0ChiCnj+DqdBG8J1Jm9jsAY6umIpke51+51g3wznLmWgar0MCqvZvbgtmhIBHsMyvw/5MyYd6leyJ384aMJaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500085; c=relaxed/simple;
	bh=VZcnJhWHOIjysczGcXIfaQf6NALYfb+WR98Sf5vyVUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuwLNBH1Dbn7lTg63fVGM/38CBwtFT0/T+24jnotud+n/jHzLiGQrTOvINWBdEN1H5WuErDqVWKQMI5oQf7685L6VyEjyTUgLEEQ+2VDaYRELMR4QxMuLsD+RI5iVbGmi9QTm/1nODQdij0ASxBU/u4XE6mpcrBJ86TVzzbIg+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Inpe3Z03; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Inpe3Z03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7305E1F00A3D;
	Fri,  4 Sep 2026 05:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500084;
	bh=fMB3lMm6gjAVXutEHA+hv+QTSppGhPj4Pxergakt0xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Inpe3Z032f68lST8OGAF4aoHMjJaCMlbGdXiqgb7V8+N6kyQYq0bsIv+mhXd3Xl6Z
	 36u7zgOgRGqkMd0ZlkGkIg8oXPOYiurWOFJ0TuXUfWEcaNZaj4OZ/T3JWJVWe6tcnx
	 0YztLFnePXd2D0eQR/xbMtNgHcwld4FQiPycwj0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 646/713] ALSA: hda/realtek: Add quirk for TongFang XxAF5xxx
Date: Fri,  4 Sep 2026 07:00:14 +0200
Message-ID: <20260904045818.312310377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -8055,6 +8055,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3033, "TongFang X6SP45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6KK45xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x30ba, "TongFang XxAF5xxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


