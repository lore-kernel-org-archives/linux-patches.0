Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F074723645D;
	Fri, 24 Apr 2026 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037637; cv=none; b=Pvu7mb7YRLZlzR6j8SJgfzFuumFZUnJeyx3l1+sCghHa7VTci3wP5kyiWCZXKgpg0oiLcc3i7+sXUxrd2aEzWZR6/dsx3S9Ff+MTF6RxTRNgrSCAKwl0Bimp7bi+/LK2wL3YE92JPpIeyKBVMH06lDR9PFYzPIWqB9TXDec9ZEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037637; c=relaxed/simple;
	bh=6Zodb86HV+ME/mrWhrUta/x+BKkt4xerG4BQ8eafDA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gck/ZwUX1RtruwelFGQEIBypo66//pTcAgv3sHbuWpHMqU1u7OtKWmUbSzTzxGxeZNBWLZhLZ21Fw3hZvsV2TdenYdD2v6FQLI6KpE8USLN+Fu2mOupugtVTMuGal5NQ1Sw+FzQ5ZynSKyPS6bM30BjzWOtXAmkWXEi15TzOxqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0rl4gHM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0rl4gHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593D5C19425;
	Fri, 24 Apr 2026 13:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037636;
	bh=6Zodb86HV+ME/mrWhrUta/x+BKkt4xerG4BQ8eafDA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0rl4gHM3EWYBEiRVcK6ZK842ZEhpi1yeULJ3nXpRhqNPMPs1Edls7XFv1opk8Fef
	 Kc05rpBBZnQ+H+hmEmMC713+IzKNOT34LMJM5Ab7VTObBqulpWZ/4wcEiD+vPyjNNk
	 AqbuDgTYI0IzrATXDVe+LH8EtxKDtJB1/U7Hc46I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Kovalchuk <coderpy4@proton.me>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/166] ALSA: hda/realtek: Add HP ENVY Laptop 13-ba0xxx quirk
Date: Fri, 24 Apr 2026 15:28:37 +0200
Message-ID: <20260424132533.529595593@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Kovalchuk <coderpy4@proton.me>

[ Upstream commit 793b008cd39516385791a1d1d223d817e947a471 ]

Add a PCI quirk for HP ENVY Laptop 13-ba0xxx (PCI device ID 0x8756)
to enable proper mute LED and mic mute behavior using the
ALC245_FIXUP_HP_X360_MUTE_LEDS fixup.

Signed-off-by: Andrii Kovalchuk <coderpy4@proton.me>
Link: https://patch.msgid.link/u0s-uRVegF9BN0t-4JnOUwsIAR-mVc4U4FJfJHdEHX7ro_laErHD9y35NebWybcN16gVaVHPJo1ap3AoJ1a2gqJImPvThgeNt_SYVY1KaDw=@proton.me
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1a5e2fb0c842b..a3def674103b3 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10094,6 +10094,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x8730, "HP ProBook 445 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8735, "HP ProBook 435 G7", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8736, "HP", ALC285_FIXUP_HP_GPIO_AMP_INIT),
+	SND_PCI_QUIRK(0x103c, 0x8756, "HP ENVY Laptop 13-ba0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x8760, "HP EliteBook 8{4,5}5 G7", ALC285_FIXUP_HP_BEEP_MICMUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x876e, "HP ENVY x360 Convertible 13-ay0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x877a, "HP", ALC285_FIXUP_HP_MUTE_LED),
-- 
2.53.0



