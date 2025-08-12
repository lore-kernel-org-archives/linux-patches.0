Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D32FE57F;
	Tue, 12 Aug 2025 17:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020271; cv=none; b=K3M9iV2HenJOE83kIfYUXcWyS/eC7H2KOdM5ch8ukkIXXJEm4mTmXt7JbEkF5hlsmnP73d30kHefMug7YdhT71nQdoF+OG3ioM2YEtdQBt/kuYN/FqOrCTjNy7FmhkX5ne4PK2uMUm2c9Wt5XkUjZQTquxxRbuGAvhEW0AkZEFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020271; c=relaxed/simple;
	bh=fhpysE4mw2RKahjtN/x5tiMNibloNVKVVwMJmHnZkKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK/SkCR8wrXN0Cp9Uzm7yJtbaBXsD5w8/n86VCYaG+euvaCJEPcNo7nZuwocWG9bnbZ/p/9yZ1wWPOgkhn/T35hbo+WnvRSfeYfBuBoKRyGXUngUwBzTtXYWDMqxn9WmcVMPVKGq3BASGk1oQwjwhgxBdl6wbVBmSaEUkmlErOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acrn5Fr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acrn5Fr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93240C4CEF0;
	Tue, 12 Aug 2025 17:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020271;
	bh=fhpysE4mw2RKahjtN/x5tiMNibloNVKVVwMJmHnZkKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acrn5Fr58/sE3xUCPOioNQtCdHyxkcawnXkjkcYtM0/pCn8rp3Jg8LWCXj9kP5HyX
	 24hVizuPOn1ovWyW5mc8S4IBf79WgxXmev2nSZ0Rtcw9maqq4fGYK5aKIE14KMqXPU
	 +nNmJU4FC9N9VQe+A/Tn0QKxmCf/rBYKXiZ2BUl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Rezler <dawidrezler.patches@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 031/253] ALSA: hda/realtek - Add mute LED support for HP Pavilion 15-eg0xxx
Date: Tue, 12 Aug 2025 19:26:59 +0200
Message-ID: <20250812172950.057748202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Dawid Rezler <dawidrezler.patches@gmail.com>

commit 9744ede7099e8a69c04aa23fbea44c15bc390c04 upstream.

The mute LED on the HP Pavilion Laptop 15-eg0xxx,
which uses the ALC287 codec, didn't work.
This patch fixes the issue by enabling the ALC287_FIXUP_HP_GPIO_LED quirk.

Tested on a physical device, the LED now works as intended.

Signed-off-by: Dawid Rezler <dawidrezler.patches@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250720154907.80815-2-dawidrezler.patches@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9947,6 +9947,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x87cc, "HP Pavilion 15-eg0xxx", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


