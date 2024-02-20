Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B62E446C9;
	Tue, 20 Feb 2024 21:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464851; cv=none; b=M9cmOsyeXYR7Kmj8XsrXSj5QUxhApHCE6wy+ikhKGso5ShA0JLijSfoFh27uK4C8Gqb2l5vg8zMgYzyvTN6Twwt+KulfmTamKPyGZz41s/l0RYSBWhcMY2WoOCf1Rq8IxABZVoV07TYH+lYSvf6WrPGzqw3YNbW7gxJTFKBeFMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464851; c=relaxed/simple;
	bh=ffMZf8Fhx8/YUMXh3yAvI+ILXAEHZ2cit50aNRu402Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbLmlZMvjrW7xA73PN5spPuQeZd+k2uWqMzlOBDSJwP0Nnuk3MawifmVjSO0zoq3KHIKEcxLF9nbZB1VtR0GUlshCZeb6ipSVO4aAUwCLwKBmaP1CgEtykvDbgmwJcOKO8ahSoMd0NiYFyIRNjGH1/z0Mz75Mi5NNHPrAYomfy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFm/Czoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFm/Czoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8DAC433C7;
	Tue, 20 Feb 2024 21:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464851;
	bh=ffMZf8Fhx8/YUMXh3yAvI+ILXAEHZ2cit50aNRu402Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFm/CzocFWQZCGsOMyz+0lGpD44JGbAxILdExkSXhGrUVjFaepEIIBrnBRUq8HrjL
	 xkMbYxVxlti9qMx8x914VCMX1GHM6rtRLVb2CarSyjTb9cU/EmWLFsdQZVsvPIKSLr
	 IB9ZGiaN+FYcf7FENX5geACR4TRd3ofKn4ObfdwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Chi <andy.chi@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 156/309] ALSA: hda/realtek: fix mute/micmute LEDs for HP ZBook Power
Date: Tue, 20 Feb 2024 21:55:15 +0100
Message-ID: <20240220205638.041953238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Chi <andy.chi@canonical.com>

commit 1513664f340289cf10402753110f3cff12a738aa upstream.

The HP ZBook Power using ALC236 codec which using 0x02 to
control mute LED and 0x01 to control micmute LED.
Therefore, add a quirk to make it works.

Signed-off-by: Andy Chi <andy.chi@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240122074826.1020964-1-andy.chi@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9951,6 +9951,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8c72, "HP EliteBook 865 G11", ALC287_FIXUP_CS35L41_I2C_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8c96, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8c97, "HP ZBook", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8ca1, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ca2, "HP ZBook Power", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca4, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ca7, "HP ZBook Fury", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8cf5, "HP ZBook Studio 16", ALC245_FIXUP_CS35L41_SPI_4_HP_GPIO_LED),


