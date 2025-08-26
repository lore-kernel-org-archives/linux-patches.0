Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39E611187;
	Tue, 26 Aug 2025 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213885; cv=none; b=EV4sVIMR/nG5iLRWKMIaBJGBKYNX4l8VEbKwLyoHFHtxJdmYhE39wHyZvkBGJiGM75twwJaKfrfi5AHCEmPGUgAIZcTSiI+hUqct+SAo+N1LWJC5fHYwKdg0hMpp+V34CIJfxiA9piHhrHNARaeCu1MKaGYeRLrQcURncR2f+MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213885; c=relaxed/simple;
	bh=mD4EDyh7n4t2Ik0fexpN+tFdyRe9iLanmotbbPAe544=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxNrtwJuzjG7gwzsDoMSEF5FBTATukn4PhbajOa01DA/hSMcszsI97YJ+f5Z44GyTyzLZwhQDgjdVTeWEl3GW9u6WC+lq4BD+yVk2qof0c+SzCpecI3WFimrsbbrStsJ6zJ1dbq3vb+BhR/PoWSpn13/oxNO/Hz9bk1hpErxAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6PwMM6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6PwMM6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373C4C4CEF1;
	Tue, 26 Aug 2025 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213885;
	bh=mD4EDyh7n4t2Ik0fexpN+tFdyRe9iLanmotbbPAe544=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6PwMM6ZpLUcss4arAchmya4e85kUFjwsgQZOZAj0iDTmue1mqbVXqrJRluAJhXaQ
	 l9Tb5JorHPYhTgxz8kFpMLfRFEcsc54UTDmD2YeRgHIKg042AUx7s5aZZ8fWAe7prR
	 6txvJlG0tkS/C4CBiTE2C6vKxgnIe5bAP5aEKpsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 485/587] ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6
Date: Tue, 26 Aug 2025 13:10:34 +0200
Message-ID: <20250826111005.312503180@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>

commit eafae0fdd115a71b3a200ef1a31f86da04bac77f upstream.

The HP EliteBook x360 830 G6 and HP EliteBook 830 G6 have
Realtek HDA codec ALC215. It needs the ALC285_FIXUP_HP_GPIO_LED
quirk to enable the mute LED.

Cc: <stable@vger.kernel.org>
Signed-off-by: Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>
Link: https://patch.msgid.link/20250815095814.75845-1-evgeniyharchenko.dev@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10071,6 +10071,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
 	SND_PCI_QUIRK(0x103c, 0x8537, "HP ProBook 440 G6", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8548, "HP EliteBook x360 830 G6", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),


