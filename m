Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD522ED84A;
	Tue, 17 Jun 2025 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177849; cv=none; b=hMuxdRo+UUfxpK/dASl74SOxn2vkXBPiWwoBar76BK6wFESjaAWt9OlNKCJIxOoQki4QGq7AWWm6Faq0GAxuG5y7l5H7rs+cFJLZ49ZaBmpGhyYVV5UFxvR4xyb0cmuu5pojzSHCklOngJPFnTqfzj12Z8WWhldTZBkiFIo//sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177849; c=relaxed/simple;
	bh=aCgJSjEKsozDt+ljwK6SjdgEUDu0AO7Tduep19h+Mjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heXcisTEyfY1jJWD1a3KYQ2nG2ZMKC+BhpOL/ALICEgBNEorpRERavCH/W3A0CvlV9cHPuFzbgPon5WYsqSQYMSMKjH8sn6iFkBvDWGLLaMh46X7KTHGThHSOXWSHhOm6ciyECBlgVrJsZCl2ZOMddgstWeqQvGO1ws5pLk8HAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDqyXjW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDqyXjW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A2DC4CEE3;
	Tue, 17 Jun 2025 16:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177848;
	bh=aCgJSjEKsozDt+ljwK6SjdgEUDu0AO7Tduep19h+Mjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDqyXjW0Sre6x6g6iR+8dk0OnlqXkyAvZmE3IzmP16v/raoQML4plxPxyODhgOMtf
	 qAAq4Mv6UB2pOCVfuV/r+lFLPTnnkQnRyYzD1BgdffC/EVH/wLD4kWlAOSXJmP7xs/
	 wzmN7cso/vRZ1fT51Ak6jYbAEyBgiq1Ti4o23PAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/512] ALSA: hda/realtek: Add support for HP Agusta using CS35L41 HDA
Date: Tue, 17 Jun 2025 17:26:11 +0200
Message-ID: <20250617152435.989988048@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 7150d57c370f9e61b7d0e82c58002f1c5a205ac4 ]

Add support for HP Agusta.

Laptops use 2 CS35L41 Amps with HDA, using Internal boost, with I2C

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250520124757.12597-1-sbinding@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10832,6 +10832,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e2c, "HP EliteBook 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e36, "HP 14 Enstrom OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e37, "HP 16 Piston OmniBook X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e3a, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x103c, 0x8e3b, "HP Agusta", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),


