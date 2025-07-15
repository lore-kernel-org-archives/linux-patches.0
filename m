Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521A327584E;
	Tue, 15 Jul 2025 13:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585717; cv=none; b=buvEAo+ZLaI3fYbgW/83snKE4fIDq3vy9ajUcVtxs774vp/xlNvaXHgnBbbGLvr+xaSZvkD+AwGIajJdyzU2RuP09r7q9AGkV2i2DLZhMPDlLSDEEvffyhNgknjdtFNLJUt8KUn+0vpw2H+Oi1IuZsPwQb3PfTmxVUYTkdwMbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585717; c=relaxed/simple;
	bh=UijHOgt2lpTZU252Smt/Gu9JX2oRv8X+rVDVHJpJejA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVcXjPHEN6YVV3Py4k0Mfuj3YV1gAvB73yBQfDJT5R4FFRV2JhBuUryGhnHNXD+zsnnpgSxodeGHp4Rc/8ibbUecyDg2DRdLnNltrp1TyFE6a0kjQaCe+HmNjMyA9ZGVVJ8tmsXbRMzHAmlSNS+wKSr1w0x9daD305wACwc0QHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/EyBvk2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/EyBvk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA85EC4CEE3;
	Tue, 15 Jul 2025 13:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585717;
	bh=UijHOgt2lpTZU252Smt/Gu9JX2oRv8X+rVDVHJpJejA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/EyBvk2zMAg+4zg2sUWK/Hmo0nZFh9+MVrf7LXsedqL2xZlf90rtJioyeXQCTri2
	 qj0zFmQoduu8iOkxzR4HyuHSlcsM9zML6vKJSSYmSLgLZasYkOGRsb+yCl3zytMHbk
	 GwGrPdsl8PhQnOwhZMXszBiNuD2vc2x68MwvxkUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yasmin Fitzgerald <sunoflife1.git@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 145/163] ALSA: hda/realtek - Enable mute LED on HP Pavilion Laptop 15-eg100
Date: Tue, 15 Jul 2025 15:13:33 +0200
Message-ID: <20250715130814.650767417@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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
index 57f17ddaf7860..0bc59b6f1b9a6 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10655,6 +10655,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8975, "HP EliteBook x360 840 Aero G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x897d, "HP mt440 Mobile Thin Client U74", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8981, "HP Elite Dragonfly G3", ALC245_FIXUP_CS35L41_SPI_4),
+	SND_PCI_QUIRK(0x103c, 0x898a, "HP Pavilion 15-eg100", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x898e, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x898f, "HP EliteBook 835 G9", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8991, "HP EliteBook 845 G9", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
-- 
2.39.5



