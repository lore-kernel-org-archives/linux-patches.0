Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B9320CCCA;
	Tue, 26 Aug 2025 13:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215128; cv=none; b=Dg7AOfn5QHOqB4Gao6FvYPqfJ5aXJXLXlKpc0uCpnrmhYIfvZeDqlzWYP2DL612kufPWTviMZSU4mReokrwivcs/Sb16AUlyCQLKF9abI28LQm51l3SUoQp1+TDWfsO0OmDSdYnh92QD7I9bIP/OpxQvjoRfn23ISxXX09Yp4Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215128; c=relaxed/simple;
	bh=fJHBRDQI51JUvnow1Ce/q66X8LTi59T7+V9IMEVUA5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTivCzWmISlWZkQtobArecNBixgZT3uosHbVxlQoABJpnCDS88Pl5agEK3cEtrKR/547FO9KwSE2rIvNsrCRKEc5Be3/WiSG22QxOK8h8nypU6IJFMl65hSzCeNCB75tzlEx8SYHsQ7UBVV35abY8Jm/Jr22MTYIoA2OQXBX0XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AliWMM2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AliWMM2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA15C4CEF1;
	Tue, 26 Aug 2025 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215128;
	bh=fJHBRDQI51JUvnow1Ce/q66X8LTi59T7+V9IMEVUA5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AliWMM2FtXGoqdjgAaalOQfREUzjeF71Bz8URSYLFbDOH85Hhv8pEYsBFwnQnPo+V
	 MXOSEXeP7aDySyN79i+XoWd5Us1WgcJwV7dbD0eMFEBbmRkpiPqS4Q+Pg+Rqpeipje
	 eAP/XKiWE6i9yMlV6N3ZVtM4ltEI0t7V5LShvJQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evgeniy Harchenko <evgeniyharchenko.dev@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 398/482] ALSA: hda/realtek: Add support for HP EliteBook x360 830 G6 and EliteBook 830 G6
Date: Tue, 26 Aug 2025 13:10:51 +0200
Message-ID: <20250826110940.660211400@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9915,6 +9915,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x84e7, "HP Pavilion 15", ALC269_FIXUP_HP_MUTE_LED_MIC3),
 	SND_PCI_QUIRK(0x103c, 0x8519, "HP Spectre x360 15-df0xxx", ALC285_FIXUP_HP_SPECTRE_X360),
 	SND_PCI_QUIRK(0x103c, 0x8537, "HP ProBook 440 G6", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8548, "HP EliteBook x360 830 G6", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x854a, "HP EliteBook 830 G6", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x85c6, "HP Pavilion x360 Convertible 14-dy1xxx", ALC295_FIXUP_HP_MUTE_LED_COEFBIT11),
 	SND_PCI_QUIRK(0x103c, 0x85de, "HP Envy x360 13-ar0xxx", ALC285_FIXUP_HP_ENVY_X360),
 	SND_PCI_QUIRK(0x103c, 0x860f, "HP ZBook 15 G6", ALC285_FIXUP_HP_GPIO_AMP_INIT),


