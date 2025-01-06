Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EA38634A;
	Mon,  6 Jan 2025 15:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178019; cv=none; b=sTMs9B7H+krLR4l25QFPKCwiNJ5c08XaDpLU4MYj9bOuj2tVceVPSji8aMaLCtBmlwp9biu5KLnMnTrPeVmVN2HONh0Hu5Xtov+4CDz0dj9LnzTx9XIcCOtKkNbglCEEPPEKlMX++P0E4KNrJEhhV4kRdSlIo/7A23XhnKjXsGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178019; c=relaxed/simple;
	bh=DClIQo+eFk7yeNUrxXP6R04+liYAJzAT5sepG3dgI2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FZVwqClF7bSPJK4BxpJNE1T7joO4QQztbGlV4d7S1xdpRWudrJ8q8vPZPV2w8O0N9UfbJhv2Y+i0x1XZS6W/iVLI8f98uS04tsxInbZZ5F2WFpkqz7SjRcTvz7qfBesoOEDZA1N7VzoAhluppraZIaWCHF64yWoFeOxSwp0qv+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGDuxoT0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGDuxoT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFB14C4CED2;
	Mon,  6 Jan 2025 15:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178019;
	bh=DClIQo+eFk7yeNUrxXP6R04+liYAJzAT5sepG3dgI2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGDuxoT0ozpoxA7JPzjpndhZu6pSYAC5AtahITMNEfvFRKk5jCj2fL+BldnmtJ91w
	 ty5Zox9QOnSfA9Q5exczdZGfhHujYOou+qgAguRHG0V132nXyBahmsiXamaPEbnUWO
	 ZkSmZoT2wr/OEvXYUHuViPmsyTNrqOgsMvrdRUoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	linux@frame.work,
	"Dustin L. Howett" <dustin@howett.net>,
	Daniel Schaefer <dhs@frame.work>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 117/156] ALSA hda/realtek: Add quirk for Framework F111:000C
Date: Mon,  6 Jan 2025 16:16:43 +0100
Message-ID: <20250106151146.135016830@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Schaefer <dhs@frame.work>

commit 7b509910b3ad6d7aacead24c8744de10daf8715d upstream.

Similar to commit eb91c456f371
("ALSA: hda/realtek: Add Framework Laptop 13 (Intel Core Ultra) to quirks")
and previous quirks for Framework systems with
Realtek codecs.

000C is a new platform that will also have an ALC285 codec and needs the
same quirk.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: linux@frame.work
Cc: Dustin L. Howett <dustin@howett.net>
Signed-off-by: Daniel Schaefer <dhs@frame.work>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241231045958.14545-1-dhs@frame.work
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10993,6 +10993,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0
 	/* Below is a quirk table taken from the old code.


