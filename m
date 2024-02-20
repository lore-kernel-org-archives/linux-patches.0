Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42566446C9;
	Tue, 20 Feb 2024 21:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464839; cv=none; b=uVKclcZxAmm+LavKreHU3VujmHx+bXPZ3oHHax9XRrpsF0OhEDu+eP9ke1RV7b5aFU+u1qNfg3e8wuizEWQyMwPxNffhUmXpkwQHbKCaO5LPkRxEAugXgqTRgrTviydR3AXdNs61fdTr4tVEEGIwVjyQf07kngoxrogM8Hb93js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464839; c=relaxed/simple;
	bh=K6AZK+pCAbzORmqCzYJYRf1AklVbm5xDz+rHS9/j5+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbA7kGl6uR5VMzTf5cErmwYMsOj6HwRMdUCMecc+wmSy+jyIDJzKkheRFwNLB/Sc5GuAe1//GsHz/6cDd5FWm0yPDTq7d7kDXS2NMYwrtV5+xpU0B45/17iZRRT4EfRtQnbsgequwrtH7L4VklLC9sn/4+tN5sKsy+CcYCjBp5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH3NOnrz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH3NOnrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B9CC433C7;
	Tue, 20 Feb 2024 21:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464839;
	bh=K6AZK+pCAbzORmqCzYJYRf1AklVbm5xDz+rHS9/j5+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH3NOnrzBCXtTFMVlEOPOAnqZLt1X9H2UUy35L17PDHB5VuIgzH9KqRxXtkT6fUDk
	 7mNfuHgN9bC6W0wnDn2YLZZGkfKY8q9twCzWwizlT/tn2HSvXH+jCxiuFwjtJmLBI5
	 VYb/ORvTfqh6NuKECflN07DQyGcHUxy+eNT2YThQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 153/309] ALSA: hda/realtek - Add speaker pin verbtable for Dell dual speaker platform
Date: Tue, 20 Feb 2024 21:55:12 +0100
Message-ID: <20240220205637.955727184@linuxfoundation.org>
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

From: Kailang Yang <kailang@realtek.com>

commit fcfc9f711d1e2fc7876ac12b1b16c509404b9625 upstream.

SSID 0x0c0d platform. It can't mute speaker when HP plugged.
This patch add quirk to fill speaker pin verbtable.
And disable speaker passthrough.

Signed-off-by: Kailang Yang <kailang@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/38b82976a875451d833d514cee34ff6a@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -439,6 +439,10 @@ static void alc_fill_eapd_coef(struct hd
 		alc_update_coef_idx(codec, 0x67, 0xf000, 0x3000);
 		fallthrough;
 	case 0x10ec0215:
+	case 0x10ec0285:
+	case 0x10ec0289:
+		alc_update_coef_idx(codec, 0x36, 1<<13, 0);
+		fallthrough;
 	case 0x10ec0230:
 	case 0x10ec0233:
 	case 0x10ec0235:
@@ -452,9 +456,7 @@ static void alc_fill_eapd_coef(struct hd
 	case 0x10ec0283:
 	case 0x10ec0286:
 	case 0x10ec0288:
-	case 0x10ec0285:
 	case 0x10ec0298:
-	case 0x10ec0289:
 	case 0x10ec0300:
 		alc_update_coef_idx(codec, 0x10, 1<<9, 0);
 		break;
@@ -9722,6 +9724,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0beb, "Dell XPS 15 9530 (2023)", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0c0d, "Dell Oasis", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),


