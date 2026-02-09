Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB48023D291;
	Mon,  9 Feb 2026 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647681; cv=none; b=SRcXXggnRDA+N025B4SY4lv/ykOG8iIM94t9G2fBZ6lYIZk21buOQE0mpP96J4v7rpVcdzcU8A7/lq+jJyOWWjgvDY1i89/ULk5ZlniLqLNgJMFptojDm4juWNYb/fzipaSYh7vKqDnbc1MSQ7w8kDpWpoLCocYLy+Q9iVgyykQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647681; c=relaxed/simple;
	bh=RPnyOV/+fimNFF/sn0kVX85AEnRptWW+hQwEFzN3nrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJJIYn4TNqYrJchWl+gb5xngg5YAiHiiigCjA/EgaXPtBg2Y7v7U4w0eDEEFhiyPF4ENljq22id+mF4J/FP4/3FTaydx/HGsennGu1qlAYdZuZh3J0AyPBabvpNguqoN+ZP0gT+tfyg3qMhUNHbG3p2jWEDT0O2hfYNKosbwEqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpgTzjBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpgTzjBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B30C116C6;
	Mon,  9 Feb 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647681;
	bh=RPnyOV/+fimNFF/sn0kVX85AEnRptWW+hQwEFzN3nrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OpgTzjBiYQ5cTGui+4OqnxzA0kRtwOEe1lc+V/IlhenxaM1Uqdv+0Uq5EKN4ktWVL
	 sC6shpLaSEuGKgbVasPZi4+qai4Yug7ccrqh8NDkyVux05hTpXFGQaxSR9F1A7gXFR
	 11JqYjTy4O++I27tlrSA1SoQDM5lMpnofKjPEJd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 173/175] ALSA: hda/realtek: Really fix headset mic for TongFang X6AR55xU.
Date: Mon,  9 Feb 2026 15:24:06 +0100
Message-ID: <20260209142326.701123862@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 1aaedafb21f38cb872d44f7608b4828a1e14e795 upstream.

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR55xU devices.

The former quirk entry did not acomplish this and is removed.

Fixes: b48fe9af1e60 ("ALSA: hda/realtek: Fix headset mic for TongFang X6AR55xU")
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260123221233.28273-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7232,6 +7232,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3031, "TongFang X6AR55xU", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
@@ -7701,10 +7702,6 @@ static const struct snd_hda_pin_quirk al
 		{0x12, 0x90a60140},
 		{0x19, 0x04a11030},
 		{0x21, 0x04211020}),
-	SND_HDA_PIN_QUIRK(0x10ec0274, 0x1d05, "TongFang", ALC274_FIXUP_HP_HEADSET_MIC,
-		{0x17, 0x90170110},
-		{0x19, 0x03a11030},
-		{0x21, 0x03211020}),
 	SND_HDA_PIN_QUIRK(0x10ec0282, 0x1025, "Acer", ALC282_FIXUP_ACER_DISABLE_LINEOUT,
 		ALC282_STANDARD_PINS,
 		{0x12, 0x90a609c0},


