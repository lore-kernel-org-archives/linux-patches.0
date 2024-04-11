Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A740F64CC0;
	Thu, 11 Apr 2024 10:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832221; cv=none; b=FNkjtbZqo1XAW9f8cRbjnSA63J+mpkqIraeOTyIgF3vdbcoBVx/n8U7vXzrm8+t2NmArp+HG/UL2GzU5YoLVrbiSxKnRxLgwBMChaw6z84EH6mzc+jkSYDNdLG+vHeNrolP5UQ4a77dgBR861j3lzdA7CVPoQSUi0k2ar0o54Qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832221; c=relaxed/simple;
	bh=SW+yb8L4ZDgLO0bhQLdTVSg06GntydK+NX6MHZjk730=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7r0inkeBGmSZ2Gluuq8jff7MjXucdfPi8WSpJdXWuuA3Rto5FYtqqgND+YZPZnYUOC0M0xWg39X6rZj4Ulxd1j8+qfnl+SqXmdY8VVpF/Z40kS2IsDQDbEF8IC0gWXE5FdQVqKKzNIy0WCuOoKrTS2BFLGXX3a1EWqZEjLaZDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UO0AOddF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UO0AOddF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B36C433C7;
	Thu, 11 Apr 2024 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832221;
	bh=SW+yb8L4ZDgLO0bhQLdTVSg06GntydK+NX6MHZjk730=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UO0AOddFkfR25iZghxBqlmBxqh/Yom+qMYQUlc7/ZWJuaQVCcinHFCdZNNom1UQPX
	 m8/zP5YCQEzF/FPw+4weRmqEDmC0/Eo01WdtaA3PFh0VFydZbWR08mtinyi4TDrJ6v
	 6+NAeFqLsK3SBp0rOi2cfAreR506cWau2KEt3vYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Gede Agastya Darma Laksana <gedeagas22@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 232/294] ALSA: hda/realtek: Update Panasonic CF-SZ6 quirk to support headset with microphone
Date: Thu, 11 Apr 2024 11:56:35 +0200
Message-ID: <20240411095442.567218185@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

From: I Gede Agastya Darma Laksana <gedeagas22@gmail.com>

commit 1576f263ee2147dc395531476881058609ad3d38 upstream.

This patch addresses an issue with the Panasonic CF-SZ6's existing quirk,
specifically its headset microphone functionality. Previously, the quirk
used ALC269_FIXUP_HEADSET_MODE, which does not support the CF-SZ6's design
of a single 3.5mm jack for both mic and audio output effectively. The
device uses pin 0x19 for the headset mic without jack detection.

Following verification on the CF-SZ6 and discussions with the original
patch author, i determined that the update to
ALC269_FIXUP_ASPIRE_HEADSET_MIC is the appropriate solution. This change
is custom-designed for the CF-SZ6's unique hardware setup, which includes
a single 3.5mm jack for both mic and audio output, connecting the headset
microphone to pin 0x19 without the use of jack detection.

Fixes: 0fca97a29b83 ("ALSA: hda/realtek - Add Panasonic CF-SZ6 headset jack quirk")
Signed-off-by: I Gede Agastya Darma Laksana <gedeagas22@gmail.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240401174602.14133-1-gedeagas22@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9192,7 +9192,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
-	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
+	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),


