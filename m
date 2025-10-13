Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF4F3148D2;
	Mon, 13 Oct 2025 15:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370145; cv=none; b=T43K3E98b2X5DefFNIi34U5y+U6UfjYmtPu1ngU53vvBUwfp9lL9F1UbBuN7n3/2t1GISAI+vTlWJiTMBes3e/kDoZhkc1RlpMO69O1+Q/MOR1gnv4tVh7YucmO046GHlfQVBFFee1aZnzNXpdFv+RsXzUvqAgymit/G47s57sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370145; c=relaxed/simple;
	bh=ObO8EMCKe+U2uLKqeSHXp/hCHM31dNhcXY5NtRu7cgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXRBFAq+aMZqB6m91DKsZ/l99NuC9lRjygLddhLqbevMSLZvISuZXCs7Ii2b8aYZQse9Vi04Z/RMEGoR6DnfviUdYPpJA+rCXIWIeaY/03kyGOcXYJKWGJ6xyWCw38oAVuxFHDWDAF9vSfSK3fXMzIZWK7lDAc/b2iHO7UpRxUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+SQgxi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+SQgxi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EC9C4CEE7;
	Mon, 13 Oct 2025 15:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370145;
	bh=ObO8EMCKe+U2uLKqeSHXp/hCHM31dNhcXY5NtRu7cgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+SQgxi4buumryDNbIBAUYOcbPqNOU+sZl8k1oUVOGLVitlaWBl0IEBjm+aMUKUK6
	 gVSMxZf82B2R74iUDPhPRFgIfmG/dbDMQubjK44S9J3mCJGq6NWE0Ja8LrnK7IBDP1
	 N43M0/c1d6sNGOVTO9ua2WxA1LZV9v2bv/2a2I5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaden Berger <kadenb816@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.17 495/563] ALSA: hda/realtek: Add quirk for HP Spectre 14t-ea100
Date: Mon, 13 Oct 2025 16:45:56 +0200
Message-ID: <20251013144429.226795576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 50a098e3e9b1bb30cefc43cdfba3c7b9b32e14a7 upstream.

HP-Spectre 14t-ea100 model has no speaker output unless booting
previously from Windows on dual boot, a reboot while on Linux will
stop the speakers working.  Applying the existing quirk for HP Spectre
X360 EU0xxx seems fixing this speaker problem.

Reported-by: Kaden Berger <kadenb816@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/aMxdGAmfOQ6VPNU8@archlinux
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6487,6 +6487,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x89c6, "Zbook Fury 17 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x89d3, "HP EliteBook 645 G9 (MB 89D2)", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x89da, "HP Spectre x360 14t-ea100", ALC245_FIXUP_HP_SPECTRE_X360_EU0XXX),
 	SND_PCI_QUIRK(0x103c, 0x89e7, "HP Elite x2 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a0f, "HP Pavilion 14-ec1xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a20, "HP Laptop 15s-fq5xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),


