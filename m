Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D8F15B0FE;
	Tue,  2 Jul 2024 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940458; cv=none; b=PPaXrWzcRxhsVzy87odzfTv9C6L0vRk/WfNtylk5tYFMKZiDQS87sG8CdmoIENAdf6peP+Hny+Jvts0aItmrMwRa6k67m1ehBKqxP7mN0p3KmkeZWkctf8pVXONVXqQIamsGJnmla9yP4ApRbI6QCeb6TBxbvL/WTMvfYrRyOlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940458; c=relaxed/simple;
	bh=90caugnR8N8ePYozfn0ihrLRJ1Wy+PKGUdUevzUiRzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq35Zjc51gDpFUF2bZ1VlzI+9Of2JpjOvN22ZZSj56VlME553g+Hreju0JGF9n0rOy02Eq9R56wbMjZtcCVABRKNs2ou60tPRBbl3mx+4aaEwvClN9eS6I2h43Y07wbJrRSfwFJFs7rPMbbVph/AzHRAGr/aRo8ebmPWPJWt06Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9IQNORV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9IQNORV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B833C116B1;
	Tue,  2 Jul 2024 17:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940458;
	bh=90caugnR8N8ePYozfn0ihrLRJ1Wy+PKGUdUevzUiRzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9IQNORVye1/K1oHvAuZk7Spy41Qan/iCPfezswUL5WWpLqVGYKFCtjWnCNc11JRt
	 tiF6BXO4KlNHueGpta92TJYP1/hBJhCHngFHmVkfzdnp6g7fqcRaDycdP8AQowIfw1
	 E7LERTgo3o7AP2U5jCDuy/po825oioxLAwFAS2Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dirk Su <dirk.su@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 161/222] ALSA: hda/realtek: fix mute/micmute LEDs dont work for EliteBook 645/665 G11.
Date: Tue,  2 Jul 2024 19:03:19 +0200
Message-ID: <20240702170250.131642825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10187,6 +10187,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c7c, "HP ProBook 445 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7d, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c7e, "HP ProBook 465 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c7f, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c80, "HP EliteBook 645 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8c81, "HP EliteBook 665 G11", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c89, "HP ProBook 460 G11", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8a, "HP EliteBook 630", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c8c, "HP EliteBook 660", ALC236_FIXUP_HP_GPIO_LED),


