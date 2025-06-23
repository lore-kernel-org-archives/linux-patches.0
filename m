Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8739F2222B2;
	Mon, 23 Jun 2025 22:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717587; cv=none; b=W5TaNKkWWZlw6eo68wlCVqZYe4CNIziCNQXYKAGKYI8LeNbWTuxerh/pbrjbcszV+QMVrFTlAaPkkFR1rb+ddMLFLsmaHNn9kqIxH8jBPnipx90DA8ortOB5knT053jrRo/IJJ0sC+20w4n+H6xjsy7ZPamlIxHWDjxK+h1/r8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717587; c=relaxed/simple;
	bh=jG/z4W3Z57MkBrZT1c7CE8JeCBDJ7n4fepn2vH4veRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeXoceoo7HAETi6c+ihlj2z1VRBzMDcN8J54U+dwlycMAy2kJUeMlpLEuB1umDm+61waME6V1VxnKwfBUFynFBI5UMmp8H5m4qObry8JTwG4puKCeYvUKNLClurMYxeL+Ob5xmQvxyBPrMnPVf/1xjAtjYv85FqKlUILe6MXuAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPs/CKzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPs/CKzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D854C4CEEA;
	Mon, 23 Jun 2025 22:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717587;
	bh=jG/z4W3Z57MkBrZT1c7CE8JeCBDJ7n4fepn2vH4veRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EPs/CKzSo8FaV6nVKDlKE972t7uvu3pYde2huAaGvpN4Ucmsd+F0eiLQG1qEVwIvZ
	 mH0q3YriPKrfbjk9oHw3VlPsIUc/ink1z5UNtpkhYRdqeDExc4Ph94FkvDcgbWRtts
	 icahoWkXqTVA7junMcvPoz08cfI+K8Xkyw5FooOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Lane <jon@borg.moe>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 461/508] ALSA: hda/realtek: enable headset mic on Latitude 5420 Rugged
Date: Mon, 23 Jun 2025 15:08:26 +0200
Message-ID: <20250623130656.463696516@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Jonathan Lane <jon@borg.moe>

commit efa6bdf1bc75e26cafaa5f1d775e8bb7c5b0c431 upstream.

Like many Dell laptops, the 3.5mm port by default can not detect a
combined headphones+mic headset or even a pure microphone.  This
change enables the port's functionality.

Signed-off-by: Jonathan Lane <jon@borg.moe>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250611193124.26141-2-jon@borg.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9809,6 +9809,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0871, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0872, "Dell Precision 3630", ALC255_FIXUP_DELL_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1028, 0x0873, "Dell Precision 3930", ALC255_FIXUP_DUMMY_LINEOUT_VERB),
+	SND_PCI_QUIRK(0x1028, 0x0879, "Dell Latitude 5420 Rugged", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ad, "Dell WYSE AIO", ALC225_FIXUP_DELL_WYSE_AIO_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x08ae, "Dell WYSE NB", ALC225_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0935, "Dell", ALC274_FIXUP_DELL_AIO_LINEOUT_VERB),


