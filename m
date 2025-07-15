Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F268C2E763C;
	Tue, 15 Jul 2025 13:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586023; cv=none; b=Z4F0+lUyqDlckYx8x5NeldpWr43G1B7K9gCsKT/fHVv9P4QcI5wkmAy2HdqfFp3kI6I0LuOL0Qfxn3cp1uexHCmHaXKT0NF83CP7A13TjhoZp0tcBQt5RK9XpaP/hL4ZPQLDDTw9+1nBoS/xiZH9PM1igfcWNph3Hmp6oBYf6KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586023; c=relaxed/simple;
	bh=wgvLIe9R+rzu5nx+GDU6AcpVTdn1GWykXnfGnNTjhBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Uc8ogtbjt+s3oIUwksMSk7057T7p720WFKX5M85Em6Z/+zNgaefQTF1wQVcrKSHw12RmcK7ylJM7M7+8CucgvlgKXSsYd4azHtOAiWCfUp76PJQEHDmqhE3uY4Fv0LzjBXhNxgHdxF4XVwb8u3oFKlsVaufMYd0n1xkHeeT8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojUU98Z8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojUU98Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FE8C4CEE3;
	Tue, 15 Jul 2025 13:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586022;
	bh=wgvLIe9R+rzu5nx+GDU6AcpVTdn1GWykXnfGnNTjhBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojUU98Z8pFpofwTLZ5V+1ALwN1RxIjyMhxxru61G2pSYHYjDrAB03sakPkwWQq9AO
	 HIZYrZhpeAdqrklPqXUh/MPcCN9fJW/QY1G+EqmruFZph1u56lQT+XIuwWuiD0QC0A
	 4Nrv+1y0sBqMnNLNWXss9FxMyZsh5xFgvpfkKcd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasmin Fitzgerald <sunoflife1.git@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/109] ALSA: hda/realtek - Enable mute LED on HP Pavilion Laptop 15-eg100
Date: Tue, 15 Jul 2025 15:13:52 +0200
Message-ID: <20250715130802.725719608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yasmin Fitzgerald <sunoflife1.git@gmail.com>

[ Upstream commit 68cc9d3c8e44afe90e43cbbd2960da15c2f31e23 ]

The HP Pavilion Laptop 15-eg100 has Realtek HDA codec ALC287.
It needs the ALC287_FIXUP_HP_GPIO_LED quirk to enable the mute LED.

Signed-off-by: Yasmin Fitzgerald <sunoflife1.git@gmail.com>
Link: https://patch.msgid.link/20250621053832.52950-1-sunoflife1.git@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 0d367cec03ade..1c2059e37fdab 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10151,6 +10151,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8991, "HP EliteBook 845 G9", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
-- 
2.39.5



