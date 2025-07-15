Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1814A2EBB88;
	Tue, 15 Jul 2025 13:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587116; cv=none; b=bat6yopbSwMdpzNAGKOCUNvqdZE3Lm7V7qWiNAUyfftuoZAxsjiadaRSITBiJVdrjJc0pr5HpbrPfjxo1l5VGUeVWf2Ph+MPd9uvk9VvK4aL3gqazuJM7rQe+DmGAAPyfbu5lS815KrtKa2KVWqCQrhHLd0e+iiQyrGH4MmBg4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587116; c=relaxed/simple;
	bh=VgSGkXmxCN8QyKU5K/MHmAbh3YySgWm1CKx3J2exdc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBDPUBAbKn/cU+oDn64PK7a/3GaoXjxqeQH/sBAJ/zmpMLT/FpjFR0kKsdjlA9JxLwQ163w2eEZHXAJyImm53no8ppqTjkW1qXIiAl8ocq1kLXJ5/KbJx9FivaC3vgQGQICmsgrqZcSQOTwBZQ2Y9/aXNOGVNmnjV7sE5UwbzAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wKGLC7+e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wKGLC7+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962FDC4CEE3;
	Tue, 15 Jul 2025 13:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587115;
	bh=VgSGkXmxCN8QyKU5K/MHmAbh3YySgWm1CKx3J2exdc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wKGLC7+eCsNdV/5B+xnG3rulgVAzff22gFaR+XdMUP8WoYw82Say0gVWLhY5r3SRo
	 cmFvYj/ZgR7Y336/yudKVumoe8vb1PrIW+pDSw1uAu5fHlHINeQCqoVJtL35kCiCqH
	 QK6lHEcTiIpOPJaJ+FJqV651jDrD29CPCHeG7gqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 173/192] ALSA: hda/realtek: fix mute/micmute LEDs for HP EliteBook 6 G1a
Date: Tue, 15 Jul 2025 15:14:28 +0200
Message-ID: <20250715130821.856012233@linuxfoundation.org>
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

From: Chris Chiu <chris.chiu@canonical.com>

[ Upstream commit 9a07ca9a4015f8f71e2b594ee76ac55483babd89 ]

HP EliteBook 6 G1a laptops use ALC236 codec and need the fixup
ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF to make the mic/micmute LEDs
work.

Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Link: https://patch.msgid.link/20250623063023.374920-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index beb9423658d72..b3cd0ab29bb6a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10886,7 +10886,9 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8def, "HP EliteBook 660 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df0, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8df1, "HP EliteBook 630 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfb, "HP EliteBook 6 G1a 14", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8dfc, "HP EliteBook 645 G12", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dfd, "HP EliteBook 6 G1a 16", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8dfe, "HP EliteBook 665 G12", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e11, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e12, "HP Trekker", ALC287_FIXUP_CS35L41_I2C_2),
-- 
2.39.5



