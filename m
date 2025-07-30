Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F518635;
	Wed, 30 Jul 2025 09:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869215; cv=none; b=JtmA/iO0fgvQBXlnZ7C0q45THa2SbT+oH7+FAJzBnStXE1vRS9eYRFZh+xu6GFAb7labhSLUf2610FQrsTiAgYk18M9P2T8VBX37YkLAiTfo0D1vNRrSZbtiyW265Jw7fUQlW4MZgHjweV5CV4JywYrzLqM9a50q8fU7PeMl3vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869215; c=relaxed/simple;
	bh=/rU+zALgZ/Sy6RhvP1j7OBF8KpCdgdMe714b8UlmnLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NK0CdS4v5m0FCt/yu1qep7XLwMIhxCBdWK6c4i23UtbSajiyyMBhBlOE8Xlhn1b+NlbCaOQAGmEh27jlKkE7HBB0Vl1ny8co7qdvs5Whky0NNS8uW381kwaNcIFina91n32Bd1usytpZ8x8IVHFGJD4mDltGqhMQk0uigg/8hOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s4bK33U/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s4bK33U/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABC5C4CEF5;
	Wed, 30 Jul 2025 09:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869214;
	bh=/rU+zALgZ/Sy6RhvP1j7OBF8KpCdgdMe714b8UlmnLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s4bK33U//++CWJsL2NbV+g5vbT9bkc8qm5mLD19VAwZoM5dwQxSRySpBfg2fNqGTs
	 YrZMqr6n39BVM41yzT/7+T8f3S65z6UFckEayQTDM9+ct7atlKVspcvHnI5bZfbn1f
	 5Tp77XqjdpRauZSDGe3B/widTB5FOweAzUJlqt6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 62/92] ALSA: hda/realtek - Add mute LED support for HP Victus 15-fa0xxx
Date: Wed, 30 Jul 2025 11:36:10 +0200
Message-ID: <20250730093233.152912461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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
@@ -10747,6 +10747,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8a2e, "HP Envy 16", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a30, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8a31, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8a4f, "HP Victus 15-fa0xxx (MB 8A4F)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8a6e, "HP EDNA 360", ALC287_FIXUP_CS35L41_I2C_4),
 	SND_PCI_QUIRK(0x103c, 0x8a74, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),


