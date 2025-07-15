Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319F220F08C;
	Tue, 15 Jul 2025 13:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586907; cv=none; b=QrXdI3PhqT+fyCvMVhkviCn14K5UhbolAFbpxeTTf8X5ZGwiAgIXAGQbOOT985kVTEktwya5f++WLU2gTm+C3jkcr14I8Ohg90/AE1V0jh0dMuovTzbLjm2zfd38C80O0cIANGMRBqF70YQUa+IVOhxmTUhAknYevuNrYjEAeqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586907; c=relaxed/simple;
	bh=zOfIkH0VUdbrVsbuSjevDclLZYRiOVw7YHPzb5l6c1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlxszAHPLTeDAlTuqjl+050RF2yiFuPobJFURQ7yMtAmu+dwkRP3O9i2iQoKf/PoVyEvkIu1Xh5mAlIlW754o48Qb1avgkJ8THxpfMO+F+lt/8dBTynqDyBuIPHqdOBl6b60yLb6kuqIXzQbq0SISY1F2PQsfxm0qetTmFZwqlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPGj9LAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPGj9LAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8480C4CEE3;
	Tue, 15 Jul 2025 13:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586907;
	bh=zOfIkH0VUdbrVsbuSjevDclLZYRiOVw7YHPzb5l6c1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPGj9LAC4VD8NceeHacrVAMPgeIiz56lX1fyODQbpoPnoBwwT98g7QwNTlVk0pJFa
	 tUwWIfxMt8l3a0k5hrqd+AFRA1KVW1wLmElV3bPN7ciZgaBx5+BqGgfVDeO3mDoOC0
	 kCPUPHzfk47hHFlf9VXYc8hJ9DTTayj/sTrGPEvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 063/192] ALSA: hda/realtek - Add mute LED support for HP Victus 15-fb2xxx
Date: Tue, 15 Jul 2025 15:12:38 +0200
Message-ID: <20250715130817.468547258@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edip Hazuri <edip@medip.dev>

commit ce174b48aebb3fa18fe48c59a3d10a89c414fdf2 upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on my friend's Victus 15-fb2xxx Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250627203415.56785-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10855,6 +10855,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8ce0, "HP SnowWhite", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d01, "HP ZBook Power 14 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8d07, "HP Victus 15-fb2xxx (MB 8D07)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8d18, "HP EliteStudio 8 AIO", ALC274_FIXUP_HP_AIO_BIND_DACS),
 	SND_PCI_QUIRK(0x103c, 0x8d84, "HP EliteBook X G1i", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d85, "HP EliteBook 14 G12", ALC285_FIXUP_HP_GPIO_LED),


