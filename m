Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEE946D090;
	Tue, 21 Jul 2026 17:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655469; cv=none; b=r/rZhfxmRu+wMEKaJ7eY7iVZTDLWX7km7vJ60ieJ8Vta3sbB/kOUiGmNRcS0yB91Bjy5/XC8SwcJrvEG15ySzgy4iQcv08rK82szcx7+Y8ui+AZj+XDwb020zK9fmQ3WGeGwhDGNpfpOztulHZgQXGcNzbqFiHK9/m27hcR/a/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655469; c=relaxed/simple;
	bh=tf480oDgYf2Od2Dz2LM7SjwNQwUxN2jEFiHE1D6sz2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MW0ZRK7OpzfOimfmI+xtDC6vpTcI217nbZwg+0qRw0swJovzcBmRjn/VnWsAoRipV8nZHXmpBzLvkm6Kt30cHlT+n4ki+5YPI6zKbrPIkiWiwAs4Fy3kTT13ctGbUxb9Hf4Bgx+Lv7IfrUJEaC3nWa/h+4188l6eMwwacLy1id0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcv0pU47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcv0pU47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC351F000E9;
	Tue, 21 Jul 2026 17:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655467;
	bh=veThFdtGFAh5EEtt/7OXJ3BcLfOLd2hjIU5NpEaa+Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fcv0pU47P9C1VE67akgo1Ne4v54AzxnKLH5xkjsv4bT+L8VPz14JnvtmSLgSlo+x/
	 OA/0D2ojyIjuXnp9nd26XNQTQ+06aut6lVzcqdbRKHe5YTjxgNu8/JagR3rA42OjZe
	 t7G8QMYDy4PVbNtZ7a5x6q1l6PzQdg/jtwaGkSqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eckhart Mohr <e.mohr@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 0021/1611] ALSA: hda/realtek: Add quirk for TongFang X6xx45xU
Date: Tue, 21 Jul 2026 17:02:17 +0200
Message-ID: <20260721152515.277300981@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

commit d595255241e5fec0c94adeebf2565524398e37c5 upstream.

Fix microphone detection on built in headphone jack for some devices.

Signed-off-by: Eckhart Mohr <e.mohr@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260708132135.102680-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7550,6 +7550,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3034, "TongFang X6xx45xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


