Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6428DF0B;
	Wed, 30 Jul 2025 09:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868691; cv=none; b=Z0SQQjvlUPRxs6ovsE4AtlqzUPHBTQTYOT5xHy9tb11pfqnToAaIKRSuMqflQ+fxvzkr8U954T+oXXBkRBzp+qkURGsryvhbeX9NbrgUyqNe8kJmPaDz96XQLOpI+FXGSkNMWehTS1WlC5wvhvtcZv7qQoE4ZbmxYr3IOdzi6mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868691; c=relaxed/simple;
	bh=UUjbi+YD1sM+pUCuM4IUsiSpebdOSwAZR9vfGvumWTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8vY7gGpD0Rn/JE0P5S+5PAaL577MdCMn+wrhQU99UyaesKp+DKzEEn9VRL0A0fwSO334RIOwPy3tPtv4JLE+SKMbxcIQR0SfyLPDtwRLxa8q5YZcIQNnYm2mPos1qGKIyNFETYnVl10LCP5JYHJNMidl2RrF1T3KaeVDaq3uTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVJf81Nz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVJf81Nz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBC8C4CEF6;
	Wed, 30 Jul 2025 09:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868691;
	bh=UUjbi+YD1sM+pUCuM4IUsiSpebdOSwAZR9vfGvumWTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVJf81NzhL2dJU6qu2xUNsQ5GSSess96naB538ugiOjEp4mKW+970rcYJ2WFheZNh
	 m3taROewaHl1Ezrwd5OgQ86aFKIC2/N6TZ50HxZAbdOZzs6aF8nkcR9u1Rx+d+plNS
	 6jXjz+/I1DyZHVt3W7G7LiCfg9mmxAsQ+R6Wk9gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 052/117] ALSA: hda/realtek - Add mute LED support for HP Victus 15-fa0xxx
Date: Wed, 30 Jul 2025 11:35:21 +0200
Message-ID: <20250730093235.586508922@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Edip Hazuri <edip@medip.dev>

commit 21c8ed9047b7f44c1c49b889d4ba2f555d9ee17e upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on my Victus 15-fa0xxx Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250717212625.366026-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10687,6 +10687,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),


