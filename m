Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8513521660B;
	Thu, 12 Dec 2024 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024445; cv=none; b=HgqKuBvN8ziS/BmAiTOMfMzrmCCxe9d3gpnqNwG/S9anJeWy6/ku8c5CRQH348ySp7aCYq/ao1mTxfYYQ0wCYu2CZtRV+Vi+kuogQGsj0HSYpDHKPe9/ani3UA1dIM1J9XMgz7vMaih8AjKCJLL6OHUKz5lULFayfMaEb/iUPNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024445; c=relaxed/simple;
	bh=K2rs2QTGYHbIFblqdRhmq2LAiXpbJFmyYFN7ka64fMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f2RPK8vjw95BftGdfMMro8ZUTnVmwvFi/9Cg7Inpq/eT3HX0iuyq+SIESngBmtkyPnL+BFx2yg7Xm9BgkPSdq9BYENJcDpi7k+WA2G44iNR3OB4xmb1ZDlAauzspOtj+x/R/G7QdwK9q07ljbQTPat3UmEWXJ6GIdEOr/4IP3d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hVEZSq0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hVEZSq0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6A0C4CED0;
	Thu, 12 Dec 2024 17:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024445;
	bh=K2rs2QTGYHbIFblqdRhmq2LAiXpbJFmyYFN7ka64fMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hVEZSq0t5HhZz/Ql/pMfgT2wNKlTeeXugotT+PV+32sQjFmg7G9GzAE7zRfhoEKu6
	 WsBx7QhpMqsd2MtyRNpx4wkuBalqCJ3EhwPRUXkGBsPT7w+eL2kgVHWTCqoxEIaWc+
	 WpS1ctn01nHp0QqnYoS5TzQ0C38w1CzaCdKBpSV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 281/459] ALSA: hda/realtek: Apply quirk for Medion E15433
Date: Thu, 12 Dec 2024 16:00:19 +0100
Message-ID: <20241212144304.730473107@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ca0f79f0286046f6a91c099dc941cf7afae198d6 upstream.

Medion E15433 laptop wich ALC269VC (SSID 2782:1705) needs the same
workaround for the missing speaker as another model.

Link: https://bugzilla.suse.com/show_bug.cgi?id=1233298
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241128072646.15659-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9464,6 +9464,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x2782, 0x0228, "Infinix ZERO BOOK 13", ALC269VB_FIXUP_INFINIX_ZERO_BOOK_13),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x2782, 0x1701, "Infinix Y4 Max", ALC269VC_FIXUP_INFINIX_Y4_MAX),
+	SND_PCI_QUIRK(0x2782, 0x1705, "MEDION E15433", ALC269VC_FIXUP_INFINIX_Y4_MAX),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),
 	SND_PCI_QUIRK(0x8086, 0x2080, "Intel NUC 8 Rugged", ALC256_FIXUP_INTEL_NUC8_RUGGED),


