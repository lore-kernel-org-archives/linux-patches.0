Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E6627FB35;
	Tue, 12 Aug 2025 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026854; cv=none; b=oJHbiqvIjaCgXqNdX6d7gHDhpSZvMkhNScEVHEpoHD0aYzU1IDQcAc4B6JfxmCl+tBgCfR0LdWWTA2bZHgm6o0y3JgsbPVWalAQXgdqh/iPjLsQNP6kUIThgAmJ1vv94FPjvY5bSFwUqKsZLjbw7T8U0E6ngxAD49G1/XAUAlks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026854; c=relaxed/simple;
	bh=8x/28C26dEJlCYn1PB6xaASBDHSbSMVYyh/H62Qpah0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kb88fwQR/FVRoCoPq8ZUnkr/yClXxgvKeCPduZ1HvoXC/3qnqEMUGQzLyClF0M9B/UmSPrgRUbWQSWIJQu+Gw5smUPk+82aqSR7Ku4MhqTZLYPM5FwWvjRmHhrIK52OnLOmGqv0Sg0aopnww7HbU4LcVguyqG3j8wUxgYZa6LZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fx4pwvrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fx4pwvrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E029C4CEF0;
	Tue, 12 Aug 2025 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026854;
	bh=8x/28C26dEJlCYn1PB6xaASBDHSbSMVYyh/H62Qpah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fx4pwvrDx3DeWT6HeySPmr2ar5QAEQ+2wnikbnlR5skbWFTsJqqw+mNxeRnloHPjn
	 wXb95mo5H4FFzetb7cYUeVD+SarygkOEnidSKx8aflinTx5YG/sa1KpIxuwwjV45NR
	 Oy1FYElSARzvWvgAiSF1X+omdT+uhzqWHvdTkG0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edip Hazuri <edip@medip.dev>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.15 460/480] ALSA: hda/realtek - Fix mute LED for HP Victus 16-s0xxx
Date: Tue, 12 Aug 2025 19:51:08 +0200
Message-ID: <20250812174416.367165523@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

commit 956048a3cd9d2575032e2c7ca62803677357ae18 upstream.

The mute led on this laptop is using ALC245 but requires a quirk to work
This patch enables the existing quirk for the device.

Tested on Victus 16-S0063NT Laptop. The LED behaviour works
as intended.

Cc: <stable@vger.kernel.org>
Signed-off-by: Edip Hazuri <edip@medip.dev>
Link: https://patch.msgid.link/20250729181848.24432-2-edip@medip.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10799,6 +10799,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8bbe, "HP Victus 16-r0xxx (MB 8BBE)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bc8, "HP Victus 15-fa1xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bcd, "HP Omen 16-xd0xxx", ALC245_FIXUP_HP_MUTE_LED_V1_COEFBIT),
+	SND_PCI_QUIRK(0x103c, 0x8bd4, "HP Victus 16-s0xxx (MB 8BD4)", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8bdd, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bde, "HP Envy 17", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8bdf, "HP Envy 15", ALC287_FIXUP_CS35L41_I2C_2),


