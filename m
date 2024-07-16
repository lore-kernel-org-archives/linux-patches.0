Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351D919DF53;
	Tue, 16 Jul 2024 15:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145121; cv=none; b=hm+HFoFVX0hSW7NmtI33kDClYcxeVmqvWp6XD7ePrt4M/LITp2elHTLAOKqcEuPDKB5MLfJn85HoNaAYvZoMacSOZ5QRjujE7LO3yoZLWaZFiGnXWcMgyCIoE0oq5hxPAWfXczWkqWoNPJFokqz8dOS5u+PoQyWPBRctyH3tWzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145121; c=relaxed/simple;
	bh=mhhfe//jTpXMtGQnYu4FdZOHCII073u/GmSJakhFOxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GqYld2T7BmBhZy/khhOIuPnR4kfh1EvLx9h5HUPmu+GmgzBNFQBYXYdbC20J7EoGqnjCBK/rcLIj3uD3HmIVeIftr7eypjwzP2daGvWUj5xHS30xE9eWFv2GMj2+6wY90e7JLj6zPurza59c1i7U34llWlrRe7GKbIePEIYteR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O1ZvNgll; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O1ZvNgll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79800C116B1;
	Tue, 16 Jul 2024 15:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145120;
	bh=mhhfe//jTpXMtGQnYu4FdZOHCII073u/GmSJakhFOxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1ZvNgll++S0GhBpwwlee4ZeQdtmLiHlQmtgYxKvMI5Soz6n6Fnrchree8ZX+gSG1
	 jT3FE+kJKwX4ml7+Xd8OcIzdFXj1yqIeYRz1qO6lwmdLaNN7nihXaNQLkk6BDR+Gn5
	 Ogl9Lfj7NVgG1DYfqHnR6U9q/XuJe8iHYTAEo0js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal.kopec@3mdeb.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.9 106/143] ALSA: hda/realtek: add quirk for Clevo V5[46]0TU
Date: Tue, 16 Jul 2024 17:31:42 +0200
Message-ID: <20240716152800.054745201@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michał Kopeć <michal.kopec@3mdeb.com>

commit e1c6db864599be341cd3bcc041540383215ce05e upstream.

Apply quirk to fix combo jack detection on a new Clevo model: V5[46]0TU

Signed-off-by: Michał Kopeć <michal.kopec@3mdeb.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240701111010.1496569-1-michal.kopec@3mdeb.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10424,6 +10424,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1558, 0xa600, "Clevo NL50NU", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa650, "Clevo NP[567]0SN[CD]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xa671, "Clevo NP70SN[CDE]", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1558, 0xa763, "Clevo V54x_6x_TU", ALC256_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb018, "Clevo NP50D[BE]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb019, "Clevo NH77D[BE]Q", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1558, 0xb022, "Clevo NH77D[DC][QW]", ALC293_FIXUP_SYSTEM76_MIC_NO_PRESENCE),


