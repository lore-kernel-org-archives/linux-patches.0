Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9321EB5A;
	Mon,  4 Mar 2024 21:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587756; cv=none; b=tTwXKduydnW5anIW6dgrLcZO/yfFk0w5tnUQiFP+7ONsZv1mN9Ke4fXY7/pVUleFdEel9of4166RdlND+Mga5XgurmI9gqu9797ofNPAdYYI+TjizKB4y91lRDRanJqqjGZsgSETSNnvhVv7ADAXSfJ2TUDlBW3inTZ9V+AHvlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587756; c=relaxed/simple;
	bh=0CPxo/3+3wMMACv/qxMD7DJJUzQJ0mSWoq4aXlfBjv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+0QemBsmraDkjGv148sY5m6O5khxZO6sd3O8yK1Kaq9E/u/FXQX/7hfgDRgWN6xXyA/wt/KL2w0gYBFDViX3/JAoeiOkV1KjAWS6dzy3VJcb9H3AgRC17Hko1gOQ8GaP9Nbn4hIAygzCvchdDRo+l5wQC4mQW14uchHigaR6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQZzmB2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQZzmB2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C565EC433F1;
	Mon,  4 Mar 2024 21:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587756;
	bh=0CPxo/3+3wMMACv/qxMD7DJJUzQJ0mSWoq4aXlfBjv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQZzmB2xOq+oOwTfuJ7pHgC7eKm1K7+oZWzU0b/8ilRbQiO1ON4vdHWdi0eBNTZv4
	 sZq/PW9BsHcLZugptoB3Qb+mN9ASZalUZXgm6gAF31WlgXi7Q6yUqXPamIUSKFEU+C
	 CFRKVRhR20y7/th2PSG42G+r3FWIVZ1JzUuL4H2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Peter <flurry123@gmx.ch>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 078/162] ALSA: hda/realtek: Enable Mute LED on HP 840 G8 (MB 8AB8)
Date: Mon,  4 Mar 2024 21:22:23 +0000
Message-ID: <20240304211554.343468252@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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
@@ -9915,6 +9915,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8aa3, "HP ProBook 450 G9 (MB 8AA1)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aa8, "HP EliteBook 640 G9 (MB 8AA6)", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8aab, "HP EliteBook 650 G9 (MB 8AA9)", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8ab9, "HP EliteBook 840 G8 (MB 8AB8)", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),


