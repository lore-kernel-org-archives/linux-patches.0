Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADC3D4E4C30;
	Wed, 30 Sep 2026 15:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782808; cv=none; b=DhVMYA48iwcHhiEtsCopl/sZ1BHm27uC+oV7mZ0T+GXhRWgfTXPHH28KLsjuB8p4PSSWGir3LOaRhTYP8B+7BUXDYZCUG1TmiiF4vAxoaN6rV0IVltvGg4aCCI55kkEKgiq2889yp8JMPZNn+EzcxPEfAeibZ3F0D/3SGbNmuDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782808; c=relaxed/simple;
	bh=6BTJUVHwKfEYY6buFGaGH+8W/kZ+ALXjz4frKVWY0Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZvW0EgaDFBhX0/Wp9jPbUG2hLckzSav4ig2wBZWEt95Er+Qeh73iGpy5qAOdsGAbVc0c99nZ1cjPFhqegVC1EJDrslFygQvrQQyvadARUgTWQk44IxaSkpsh/3QBedI7ALB5/98Z8aJ4nCasQc1ARguA5CKufjTcBnsLXfHGHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9BLD0nK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9BLD0nK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E538B1F00893;
	Wed, 30 Sep 2026 15:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782800;
	bh=w52d+nFBNLn/QKSIvuQ+XRPui6ZRGMBJASFdvSJV/rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9BLD0nKJS3HomaM6mPkSo83x0QCcfVuG6KUuI5+VbFeU9+60qEFXpAnb91VRS15V
	 DxqBJREZ4byzy29H7Q/OEvXJQX0kuioI/B75K3SMnWfgFsnRaD1qHo/0p8ppRGiW9v
	 8aA6Bby5d29VQRON/iOczwUKSx8OFerHl1kTVvRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 175/595] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Wed, 30 Sep 2026 17:21:08 +0200
Message-ID: <20260930152351.505560852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Madhavender Singh <madhav@disroot.org>

[ Upstream commit bf4fc9f33ec21595143132a3e7fb8b5d2c2261cd ]

This laptop with an ALC236 codec requires the
ALC236_FIXUP_HP_MUTE_LED_COEFBIT2
fixup for its mute LED to function correctly.

Add the subsystem ID 0x103c:0x86c8 to the quirk table to apply this
fixup.

Signed-off-by: Madhavender Singh <madhav@disroot.org>
Link: https://patch.msgid.link/20260723104736.23386-1-madhav@disroot.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1b4d22d246672..ea10ee4de2f5d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9266,6 +9266,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0



