Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2138F58;
	Mon,  4 Mar 2024 21:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588348; cv=none; b=bBg/aOP3evBSu6eKqQ4Hwo2YCDekHiMaOb2DlO1CjPcOGPy0ovi28vwjD0ZZL/K8eCBxd+C5JqONI/L5wkh2peKc2myAVIOg1fPG/aHt13CVrH8t210HYkPjzj5R+faE360nuZbYQ5GCZbIAymfatoQYGQ69s33rFcHR74gNN8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588348; c=relaxed/simple;
	bh=aD0Ty8AAbX6uX+K1n/nMNSchdFYp7eWpRGjvF+Frh6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ocb0Amt6Ed1H+xx7QXtIWcAx03HyAAwE+SbnBrsxyK1N6OSxwdbH4nx53SjRce5QHP2Lo34s24Wq8Vdz1idWfiXYmOD1P0MkdiFrjTIshyy2+FZ2qtRlnaw+xf5F3EwUqxtpZ2QuXYebIszRuvNujz3HmPKCVT3afyMa3kvJz18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F31ZiDH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F31ZiDH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA3FC433F1;
	Mon,  4 Mar 2024 21:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588348;
	bh=aD0Ty8AAbX6uX+K1n/nMNSchdFYp7eWpRGjvF+Frh6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F31ZiDH+bkcwpEfAwJaWMty026GTnUl9eIBhpT9qKnE7mbiC3lBvrp8WqU0NcJSFi
	 w8kygpYfly5hL99mMy74zxhj68InecmAuOFQVlzVjId8nxxpaOtKrtXfqHSM12QKwM
	 P/K5ACy59cq9kITdYgghIiKPJkm9wi72qRu+k8uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Peter <flurry123@gmx.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 072/143] ALSA: hda/realtek: Enable Mute LED on HP 840 G8 (MB 8AB8)
Date: Mon,  4 Mar 2024 21:23:12 +0000
Message-ID: <20240304211552.224661754@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Peter <flurry123@gmx.ch>

commit 1fdf4e8be7059e7784fec11d30cd32784f0bdc83 upstream.

On my EliteBook 840 G8 Notebook PC (ProdId 5S7R6EC#ABD; built 2022 for
german market) the Mute LED is always on. The mute button itself works
as expected. alsa-info.sh shows a different subsystem-id 0x8ab9 for
Realtek ALC285 Codec, thus the existing quirks for HP 840 G8 don't work.
Therefore, add a new quirk for this type of EliteBook.

Signed-off-by: Hans Peter <flurry123@gmx.ch>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240219164518.4099-1-flurry123@gmx.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9820,6 +9820,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


