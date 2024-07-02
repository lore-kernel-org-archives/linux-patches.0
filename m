Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E771BE223;
	Tue,  2 Jul 2024 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941071; cv=none; b=YldIe3J5EzCc8zYfhekQ1Hs+loU5GlrOppnsWNM9Mtuoh6HsQ9uByBcn/e+toXSghh0OhqvSyO6ZLPPC7qlFoEQGfbC8yz/T9biie0hm2/iq8RuXUzCzGj1g0x8frQPB5JJsZSAxE0vMWXcGZJ/sp/RoyFiVMwebbfCh1PMSYXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941071; c=relaxed/simple;
	bh=YkducO6tRX4Xm6JmCkpFjpb8I+zIgAweyD6NjS13sPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZaZcXXmrMEs04LDJK5QHnYriwTFutkkFYPmI3EBrK68R5b/fK9ZFiVNLG80/uM64MpiGC0IpElBwisDwRZ8Cp63UtwOXVjy0N/nXohOBP7amTkca6Z6p/ZjcfuhgQZgkDMDg433x6q2E41KopBuBNgDwB6Ro/cu1iqBJo/jC2TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOEGXXxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOEGXXxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389E6C116B1;
	Tue,  2 Jul 2024 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941071;
	bh=YkducO6tRX4Xm6JmCkpFjpb8I+zIgAweyD6NjS13sPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOEGXXxLiTR3xst1X99Bk9rrycJPjkTTUmbiJZ3ijcBOpoXj1E3sARw+pD1JiYP/8
	 enIrbt5JdGY9s0ncox+P7PNc5lDLt9+HwXPyFJRFgvUMssaFvIAfHgWvgtE6gr9Gaa
	 APAihn3+h07nadZ7oEq6DbEDyxQ3vRAB0c6oCu0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 120/163] ALSA: hda/realtek: fix mute/micmute LEDs dont work for EliteBook 645/665 G11.
Date: Tue,  2 Jul 2024 19:03:54 +0200
Message-ID: <20240702170237.594817265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Dirk Su <dirk.su@canonical.com>

commit 3cd59d8ef8df7d7a079f54d56502dae8f716b39b upstream.

HP EliteBook 645/665 G11 needs ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF quirk to
make mic-mute/audio-mute working.

Signed-off-by: Dirk Su <dirk.su@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240626021437.77039-1-dirk.su@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9963,6 +9963,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c7c, "HP ProBook 445 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7d, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7e, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7f, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c80, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c81, "HP EliteBook 665 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c89, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8a, "HP EliteBook 630", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),


