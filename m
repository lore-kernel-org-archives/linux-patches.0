Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FFE3DE44E;
	Mon,  4 May 2026 14:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903892; cv=none; b=ee1brt9iMfBk7qedTKCiL3kRhRh9EljXFrdW/uOIeeLMR2abPI5NOg+WJxn9Y+Q/lqXKz3qmZV3kLT/2z2yuJmD3XxzQCTKpYksgNJ0DTIV89PPTBXJdNqy7LWeF4paf4Vzu0xHrlzhhRhSv2iPhyekSSrTlGuSLWW3HVrwncp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903892; c=relaxed/simple;
	bh=Ulf/lhKfi9c9kb0MbGm72mk5dZ94rIyklyL3HFcXt8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkFZenZjmO3YnZVoFPpdbCEcF8xluawfMfcYpKZ8gQfLH3I55SM9wQwffXX9FmvAmqz7BwHVKHOSvyA8ZQOLR6UFPFsdNPTsopu4a6leWqXSUYlvC6KNLdH6F3aC6gd4RQAqSqDNUgnu6cwHQEqR6O7FIt1dS5hIMfFcjvqKsuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DnxJ8Ce+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DnxJ8Ce+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2486C2BCC4;
	Mon,  4 May 2026 14:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903892;
	bh=Ulf/lhKfi9c9kb0MbGm72mk5dZ94rIyklyL3HFcXt8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnxJ8Ce+UZn3naDsVBO27PfKGT7+WoecimcyjR+txfGbeNvgPhj8WasrdQedqSZUd
	 EdDYqVioVEkrNxqrsgGGOl7reo95LGUrakBfSMxOo9h1Vfend2BKsA+o7pk0M8yYr8
	 +cyCziyUUpA8yBkjXrOEKDBs7FehBjLlPsb5+gqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Spencer Payton <spayton681@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 103/275] ALSA: hda/realtek - Add mute LED support for HP Victus 15-fa2xxx
Date: Mon,  4 May 2026 15:50:43 +0200
Message-ID: <20260504135146.741566270@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Spencer Payton <spayton681@gmail.com>

commit eacda758e3c01db98b5c231f56cf9a6e05ced75c upstream.

The mute LED on this laptop uses ALC245 but requires a quirk to work.
This patch enables the existing ALC245_FIXUP_HP_MUTE_LED_COEFBIT
quirk for the device.

Tested my Victus 15-fa2xxx (PCI SSID 103c:8dcd).
The LED behaviour works as intended.

Cc: stable@vger.kernel.org
Signed-off-by: Spencer Payton <spayton681@gmail.com>
Link: https://patch.msgid.link/20260421084918.14685-1-spayton681@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6967,6 +6967,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8d90, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8dcd, "HP Victus 15-fa2xxx", ALC245_FIXUP_HP_MUTE_LED_COEFBIT),
 	SND_PCI_QUIRK(0x103c, 0x8d9b, "HP 17 Turbine OmniBook 7 UMA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9c, "HP 17 Turbine OmniBook 7 DIS", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8d9d, "HP 17 Turbine OmniBook X UMA", ALC287_FIXUP_CS35L41_I2C_2),


