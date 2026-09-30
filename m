Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55904515980;
	Wed, 30 Sep 2026 16:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784804; cv=none; b=WtseVwEfQlPE4RYwXpWP7hofuWWubSAzZkLqPjE5EbdTrgPH2gJUHVxA13KKI21Rl8QJPJqVZYbUBGMFEphn6aLfxAX2EXI8qJqxcTgrEJOviDLsSXY+H7br/GkDncHkFLiS7L4McnQX00QJ3F4KfMfXX5hC5PldWtM1Dlqg+d8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784804; c=relaxed/simple;
	bh=ZqUx+1X9maS7NQV15Tcx83HYBWpXGEqGUBgBDpZqFiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITh7uc4cFI6h9ORTGwXyS6LJKygwHQLI5RAIJxvPrYm1Cn0uBrqVpcqE2B2cmOGaSbM3QTytHG3VfCDG6Ac2OSWoKcgBBOtT9HS5dc5LO3YJrgheEoGnJD1/lIu0aedRIzcRBHPvOaL6SqPJlrQTuwM14WJwnhGroS/A7WJUbN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8UveJlY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8UveJlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6271F00899;
	Wed, 30 Sep 2026 16:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784799;
	bh=GBUwqrZCiIONuv09dd+nQ6bgmgiqRU11xXPeQOQwQkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8UveJlYjsNTkW+Wh/AF4/LcIQE47kBYIg7y2mVKiIc0FrGerqUUcC4E0+qvsWY7m
	 6yVtDJU5MfAi+Gi0OiGr3GcSnN7cuHZMIIvTXzT6d17Zsv8gK6Pr4cUMbz0F5PfOOZ
	 lH6lQoXSeoyMQ07zNBNFS99OmDlCuBwzMPXlQVTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhavender Singh <madhav@disroot.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 282/982] ALSA: hda/realtek: Add mute LED quirk for HP Laptop 14s-dr1xxx
Date: Wed, 30 Sep 2026 17:16:58 +0200
Message-ID: <20260930152422.856544002@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c2b941bf338db..5382e6036cbb5 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9933,6 +9933,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x869d, "HP", ALC236_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x86c1, "HP Laptop 15-da3001TU", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86c7, "HP Envy AiO 32", ALC274_FIXUP_HP_ENVY_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x86c8, "HP Laptop 14s-dr1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x86e7, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
 	SND_PCI_QUIRK(0x103c, 0x863e, "HP Spectre x360 15-df1xxx", ALC285_FIXUP_HP_SPECTRE_X360_DF1),
 	SND_PCI_QUIRK(0x103c, 0x86e8, "HP Spectre x360 15-eb0xxx", ALC285_FIXUP_HP_SPECTRE_X360_EB1),
-- 
2.53.0



