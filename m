Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F349D8486;
	Sat, 30 Dec 2023 12:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMV/D77Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A43C433C7;
	Sat, 30 Dec 2023 12:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937966;
	bh=j6ZndwVx7F9QkeC/fAtCCwbp2Cyeg6dVMvAzwZGwzHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMV/D77YeHI5SopQZXuhXP/kTvMwOuCocJVtjHmhnHDKrutuyFFnb0TturAEA5lkH
	 ivEFP003lACDdNTl9TL3rpuVtisD49s2pL7KaFd1iVT/pN4oE171jvrSXDzlup5IRi
	 QU+JHuVCuTrjcKSrbvqyBgxDv0GEYJ9Zxcz5xcN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Villeret?= <clement.villeret@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 107/156] ALSA: hda/realtek: Add quirk for ASUS ROG GV302XA
Date: Sat, 30 Dec 2023 11:59:21 +0000
Message-ID: <20231230115815.862922419@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Villeret <clement.villeret@gmail.com>

commit 02a460adfc4920d4da775fb59ab3e54036daef22 upstream.

Asus ROG Flowx13 (GV302XA) seems require same patch as others asus products

Signed-off-by: Clément Villeret <clement.villeret@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/0a27bf4b-3056-49ac-9651-ebd7f3e36328@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9864,6 +9864,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1483, "ASUS GU603V", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1493, "ASUS GV601V", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1517, "Asus Zenbook UX31A", ALC269VB_FIXUP_ASUS_ZENBOOK_UX31A),
+	SND_PCI_QUIRK(0x1043, 0x1533, "ASUS GV302XA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1573, "ASUS GZ301V", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1662, "ASUS GV301QH", ALC294_FIXUP_ASUS_DUAL_SPK),
 	SND_PCI_QUIRK(0x1043, 0x1663, "ASUS GU603ZV", ALC285_FIXUP_ASUS_HEADSET_MIC),


