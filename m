Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF921DDC23;
	Wed,  7 May 2025 18:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643772; cv=none; b=pLyQbtOUmbaXnSIu+8EGD5pKxtozu4Z8aB13Vo4mN5s7IBtFQI8zCa+VUnWQz/gCIKYInPMIpslvZTORjFKf3pOb0q4BakccVwHQZrIEyjRU7EcxSPPCW4BR+J8BQxgznyuWOMww4h2BQl3A0Mx2KI4d0hUnl+VqACftdxgL7QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643772; c=relaxed/simple;
	bh=qQoClXpuWHzYFopyr/An1+ttcgk4ajwitpNqWKgAml0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoaubWv0CUQK7kx12kcNDZu8jvlkLjAsP0XTnvkn9fvyNd9jXkNMAN3RcCBMan9pd3z0zLiYMeu0xL/FHONnsISwT1NwwYUsfc+yuzFZk+P2ZNg77oxX6b2bU4xS9XDxrffCJm6EryO3DDMTH36sSLuL/kVOvqrW61YoNu700e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktVjyxkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktVjyxkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44C3C4CEE2;
	Wed,  7 May 2025 18:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643772;
	bh=qQoClXpuWHzYFopyr/An1+ttcgk4ajwitpNqWKgAml0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktVjyxkN24rHAvUc9ZHcO/pbXovLWuX9rEwF2xHx8wU8zJ92bqQKYqjoCUMIhKIfx
	 eQRt36U2lpjtbJr2dz90NTCkjvxz5ZnNFUHr/sPVbNkPXTItMxLkJIkrcGY/AmXfzc
	 InaCJx5QJxat1qC4LXDxVM4H8f5AkbBy6auNALMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.14 002/183] ALSA: hda/realtek - Add more HP laptops which need mute led fixup
Date: Wed,  7 May 2025 20:37:27 +0200
Message-ID: <20250507183824.787076390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

commit 63f5235e0291152a2ac2c4ef3c1196cb6dfb3ef7 upstream.

More HP EliteBook with Realtek HDA codec ALC3247 and combined CS35L56
Amplifiers need quirk ALC236_FIXUP_HP_GPIO_LED to fix the micmute LED.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250430101843.150833-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10732,8 +10732,11 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8de8, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8de9, "HP Gemtree", ALC245_FIXUP_TAS2781_SPI_2),
 	SND_PCI_QUIRK(0x103c, 0x8dec, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ded, "HP EliteBook 640 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dee, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8def, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8df1, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e14, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),


