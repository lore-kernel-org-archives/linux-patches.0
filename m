Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDF12505A7;
	Wed,  5 Mar 2025 17:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197212; cv=none; b=p7YPQ4ibSITdF8pmEKgB0o+irohRQ7UVVDT+tRAoWf0kpM63oFL+56so0IjE6R+42fOPGyvPpMlaXI1QDm1jaA+NhdQHu1fiwwz7agSGt6fTtp5eYI8PdlSRa5rl1N6LXn9AMDaYlnUe+FFBB/0x3iaZuWtL04L2XYbFC1foAdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197212; c=relaxed/simple;
	bh=O0VoDS4vzNS0RPzc/keBQbIuqulYoHgy+kmR0d5Efuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK6TQiN/HKbxVxK0NxveLhtuaqJV/0WwNJ9IxQKmbR6tBxODit003qn6fZn1Wue6UNDJSZFEl6WiuB6ao9zJCpVvYBn1lo9tAPmws+5burfRUCzPcmadkDxpUiaI3VlBuIfd0MS4qrE3u0R+QOT76mpKmomHpiOwChzG0Ij0fGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAz/SbDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAz/SbDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA6BC4CED1;
	Wed,  5 Mar 2025 17:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197212;
	bh=O0VoDS4vzNS0RPzc/keBQbIuqulYoHgy+kmR0d5Efuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAz/SbDocatA+dxMNiv0/x27AQHc/XiCHe9QXYMLW9TsJFfLRgR7yjAzzC4IezvuP
	 fLCv6EacespSK2g/P6FcbsQpGuJiYTe+w4snLd207xkmLVIR5Xpg8X+vwfIcg5baQL
	 Sh4oxWaPD0eJse3wRbGC795RytN//PnsmgPG7nbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Veness <john-linux@pelago.org.uk>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 079/176] ALSA: hda/conexant: Add quirk for HP ProBook 450 G4 mute LED
Date: Wed,  5 Mar 2025 18:47:28 +0100
Message-ID: <20250305174508.637358604@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: John Veness <john-linux@pelago.org.uk>

commit 6d1f86610f23b0bc334d6506a186f21a98f51392 upstream.

Allows the LED on the dedicated mute button on the HP ProBook 450 G4
laptop to change colour correctly.

Signed-off-by: John Veness <john-linux@pelago.org.uk>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/2fb55d48-6991-4a42-b591-4c78f2fad8d7@pelago.org.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_conexant.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1098,6 +1098,7 @@ static const struct snd_pci_quirk cxt506
 	SND_PCI_QUIRK(0x103c, 0x814f, "HP ZBook 15u G3", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x8174, "HP Spectre x360", CXT_FIXUP_HP_SPECTRE),
 	SND_PCI_QUIRK(0x103c, 0x822e, "HP ProBook 440 G4", CXT_FIXUP_MUTE_LED_GPIO),
+	SND_PCI_QUIRK(0x103c, 0x8231, "HP ProBook 450 G4", CXT_FIXUP_MUTE_LED_GPIO),
 	SND_PCI_QUIRK(0x103c, 0x828c, "HP EliteBook 840 G4", CXT_FIXUP_HP_DOCK),
 	SND_PCI_QUIRK(0x103c, 0x8299, "HP 800 G3 SFF", CXT_FIXUP_HP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x829a, "HP 800 G3 DM", CXT_FIXUP_HP_MIC_NO_PRESENCE),


