Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95A30125B2;
	Mon,  9 Feb 2026 14:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647849; cv=none; b=iuiTsTMR4CmSvGN2G2iYAYUhbUqnpBp8RXXviop+8V4WTn5TuxgbgLXwDa04LtjKjH9sE3PeF9EJpExlvqBWScMyoQTd1ACsUCZhaACrzGw6CZqA29vxBZ3Cmqe4Hbi8HutVj7QRjIm/5pB6pe/GGcfdL+Qc15H7TxzctQMVhTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647849; c=relaxed/simple;
	bh=Yj9y+tN/lev+D9EMTgU0MQMzOqo6me7aAGhKvC3/+8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qLsjIU5ZiPEVTG8AvDWQsDqXbZsm//xPxmL219is24M5BBvClLBpls8bxM0iBECT+1KxDFZl702RM0hK3Q5EU3j8SS4Ha9tmeX2UC5YpjSd1FIz1HlCRIDy9OfujRnBUCcIoI91yiUP6gMGYDNmHoHYGNSTzrxqsztseE6ljozE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeNHTyGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeNHTyGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B81CC116C6;
	Mon,  9 Feb 2026 14:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647849;
	bh=Yj9y+tN/lev+D9EMTgU0MQMzOqo6me7aAGhKvC3/+8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeNHTyGOlZvpSdxFVEseTdFuDS4edAMl/0q3CvaWvBqWZNRNhF6LuZ3d+m7svFvsQ
	 e3Chr5ZF3tkkabGiM7YxcxFuL/itw72ToWvfu6ghRwC94f5xd5zWaZfMCz+1dgsduG
	 n2yXUVhOGL/M/7WuQyERnNGGkKEPQKgSm+FGhuCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Matou=C5=A1=20L=C3=A1nsk=C3=BD?= <matouslansky@post.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 046/113] ALSA: hda/realtek: Add quirk for Acer Nitro AN517-55
Date: Mon,  9 Feb 2026 15:23:15 +0100
Message-ID: <20260209142311.858496540@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matouš Lánský <matouslansky@post.cz>

[ Upstream commit 9be25402d8522e16e5ebe84f2b1b6c5de082a388 ]

Add headset mic quirk for Acer Nitro AN517-55. This laptop uses
the same audio configuration as the AN515-58 model.

Signed-off-by: Matouš Lánský <matouslansky@post.cz>
Link: https://patch.msgid.link/20251231171207.76943-1-matouslansky@post.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 7b3658e01c95e..dab42dee93018 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10418,6 +10418,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1025, 0x1466, "Acer Aspire A515-56", ALC255_FIXUP_ACER_HEADPHONE_AND_MIC),
 	SND_PCI_QUIRK(0x1025, 0x1534, "Acer Predator PH315-54", ALC255_FIXUP_ACER_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1025, 0x159c, "Acer Nitro 5 AN515-58", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1028, 0x0470, "Dell M101z", ALC269_FIXUP_DELL_M101Z),
 	SND_PCI_QUIRK(0x1028, 0x053c, "Dell Latitude E5430", ALC292_FIXUP_DELL_E7X),
-- 
2.51.0



