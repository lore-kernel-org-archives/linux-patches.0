Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121DD2AE68;
	Mon, 30 Dec 2024 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573665; cv=none; b=pl5IgbDfrM0UtL5vTd0RDsY8mQKjQTope5oCJkGJ3nmKLVE0snoZg3sXk0CCo0idlHsgN8r1KxNcFvpIkLWVK45UuIcD+PLWdYMkjxo6mop0YqPKC87wdp/wCmAQIrhqER6VQ0u2m5D0PAgxIVQ99h59HbZSONm8rRBIBWWQA7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573665; c=relaxed/simple;
	bh=8expRgsJpP98bLd2Eu6NqhonfwJVcXUouYBY8FaDs6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+lrGIrkdYSMkjBmiNVymrZHLwVJSan2F7m7sMyiM9L9ZbCPIH0Ai+Js1m7rNyxXiasKEF7NFwDcNQ63xbXjlMTv3EvKWNYw069u5GGOs4BvBuWnM28Lp3YNFUVlgYD6XIxdYA59B4g9fOdLMIf7EjKxqJ5sT/eMJpUDgCrCBsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdMHS/ON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdMHS/ON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AD6C4CED0;
	Mon, 30 Dec 2024 15:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573664;
	bh=8expRgsJpP98bLd2Eu6NqhonfwJVcXUouYBY8FaDs6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdMHS/ONOAjS1RUjc92JQeokrXhr7XL7RIw8oCa88fQFL/DH6FT1U//wn5yuyk/Ka
	 Ybh9WIzgq18UZMj4FOeUkQBR7OwS4UIlWV7wtA3rCtcgZQHZXHm4To1WhCvlKjsDst
	 5evOHN+Uo28JLrWJiBFvGR4nDyXwKLZvK+aObelc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 60/60] ALSA: hda/realtek: Fix spelling mistake "Firelfy" -> "Firefly"
Date: Mon, 30 Dec 2024 16:43:10 +0100
Message-ID: <20241230154209.556273497@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
References: <20241230154207.276570972@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

commit 20c3b3e5f2641eff3d85f33e6a468ac052b169bd upstream.

There is a spelling mistake in a literal string in the alc269_fixup_tbl
quirk table. Fix it.

Fixes: 0d08f0eec961 ("ALSA: hda/realtek: fix micmute LEDs don't work on HP Laptops")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://patch.msgid.link/20241205102833.476190-1-colin.i.king@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9903,7 +9903,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8d91, "HP ZBook Firefly 14 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8d92, "HP ZBook Firefly 16 G12", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e18, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
-	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firelfy 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8e19, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8e1a, "HP ZBook Firefly 14 G12A", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),


