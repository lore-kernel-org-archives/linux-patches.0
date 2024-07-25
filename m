Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D0619B5AA;
	Thu, 25 Jul 2024 14:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918680; cv=none; b=cCmd/31rbmTkhhglNFWiFMkfUlws9fx2e8TyeEw3UWb94OrQr18r2fabN29u7MttK4Yfp9uToeEOZZz7AgTu3jFdtJycOgYun2IuwqsS0LWej9XB9OBA9/bn11C2qNPU9PslmMmBOPFLFG9FHq7laBa8fAi9z/G2u0v/ccnuCVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918680; c=relaxed/simple;
	bh=lXjenCw2xPBPrR9IvVxVjpSy9RH1Ifg+Acx/KJ2gak4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ao8QhqAht6DYrqjM5R0Ue91pRJ3fF5Dn3XXLLYm+AsmcaYgxe1YXgBC+TOa9XsZ9Gf+s1k08dJP9CVmF+b1nSGJW0rR65jnOD4SJLnbRUM/2MI5rU/IDxFOjbBemPkax4SaY9bzS8PCEY/Ki65PRijNwC/WZBdnGyUqYHa5LEms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1moEbhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1moEbhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79CDC116B1;
	Thu, 25 Jul 2024 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918680;
	bh=lXjenCw2xPBPrR9IvVxVjpSy9RH1Ifg+Acx/KJ2gak4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1moEbhpXF0f7kEeIuzOIn/NKkd7GTKJSL0CMVhncFdZP521Fn4wTpgNbd9G9+0RM
	 +dYPW2joq/ZWSg0OPDmrUr0Vg34rOXGFYYMJiwZCjtJvUAxNcENf2864YYXj0JpFu0
	 CN9fngsLjoLViq9l9LBK3QKxmRajwhUuGkDXIUzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seunghun Han <kkamagui@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 07/13] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360
Date: Thu, 25 Jul 2024 16:37:16 +0200
Message-ID: <20240725142728.316250330@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142728.029052310@linuxfoundation.org>
References: <20240725142728.029052310@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seunghun Han <kkamagui@gmail.com>

commit d7063c08738573fc2f3296da6d31a22fa8aa843a upstream.

Samsung Galaxy Book Pro 360 (13" 2022 NT935QDB-KC71S) with codec SSID
144d:c1a4 requires the same workaround to enable the speaker amp
as other Samsung models with the ALC298 codec.

Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240718080908.8677-1-kkamagui@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9942,6 +9942,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc740, "Samsung Ativ book 8 (NP870Z5G)", ALC269_FIXUP_ATIV_BOOK_8),
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),


