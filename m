Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4C926B097;
	Thu, 13 Feb 2025 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459020; cv=none; b=HpMvP5DoP9c+cdZGui+/gcXhcVO8mD36tpXJERaAcuDwfVJZfRhTM/SMfOBGGBijzlk2JBUk0uwrNokQDA7YxmVmqiAlIe262Ji2VAbQATwFnBt9k9GNa42eAqjIVvJU6tN+RX5W21CpTEp8AmxfeY6VSl83hyH1HDt9XXH7sAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459020; c=relaxed/simple;
	bh=GXuuwkdpCT/ho5BJdwArz8hVYWhzq7aJejVxcbFiMIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dVYyNzV82oc4vQwMUklUEDEAhFuo6WLHrTb6aa5U+NMWSN1FjPfXur+MVRwhIvpI2A8DWOZuM0A0iGfk7yt4ZEc05uaurQnf94Uvu3FV2QQVbj6GkZ5wRZdjd7lHNjNR8U76nLP7eZvEwZcIzvlCN0CwBqTv+S2ec+rVgwua8rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DT8U6j7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DT8U6j7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BDE0C4CED1;
	Thu, 13 Feb 2025 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459019;
	bh=GXuuwkdpCT/ho5BJdwArz8hVYWhzq7aJejVxcbFiMIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DT8U6j7wdHHQO0a6W1cAnLqpb5Xg5LIo5S2JBsF7PK2URAgj4RJpNke/cnVA3iGvH
	 s1JdVU9cPlV+4xSbTG0WA7c4D10gk59wwcpSqOA0GDwkzh2JuzONxtzm7aH+DIal+b
	 SphRTikYU5HJCENlAnHIlzKwkZB0cZkN+ELYbo0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Wiese-Wagner <seb@fastmail.to>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.13 145/443] ALSA: hda/realtek: Enable Mute LED on HP Laptop 14s-fq1xxx
Date: Thu, 13 Feb 2025 15:25:10 +0100
Message-ID: <20250213142446.195119605@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Wiese-Wagner <seb@fastmail.to>

commit 711aad3c43a9853657e00225466d204e46ae528b upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 controlling the mute
LED. Enable existing quirk for this device.

Signed-off-by: Sebastian Wiese-Wagner <seb@fastmail.to>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250120181240.13106-1-seb@fastmail.to
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10389,6 +10389,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8870, "HP ZBook Fury 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x8873, "HP ZBook Studio 15.6 Inch G8 Mobile Workstation PC", ALC285_FIXUP_HP_GPIO_AMP_INIT),
 	SND_PCI_QUIRK(0x103c, 0x887a, "HP Laptop 15s-eq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x887c, "HP Laptop 14s-fq1xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x888a, "HP ENVY x360 Convertible 15-eu0xxx", ALC245_FIXUP_HP_X360_MUTE_LEDS),
 	SND_PCI_QUIRK(0x103c, 0x888d, "HP ZBook Power 15.6 inch G8 Mobile Workstation PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8895, "HP EliteBook 855 G8 Notebook PC", ALC285_FIXUP_HP_SPEAKERS_MICMUTE_LED),


