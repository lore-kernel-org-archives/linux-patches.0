Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284775102F;
	Mon, 11 Dec 2023 18:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mgiPJdcc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30AEC433C7;
	Mon, 11 Dec 2023 18:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319603;
	bh=YVQ4BdS8u6HHffWG2pHxO/S9vdv31JRt4jR4mIVy7yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgiPJdccAc/zeG7unK0pcBNWknVjn6PNgIa7wWLJUCb/aPLr2SBCicq3dH+rDB4Ky
	 k/vwyR/EcvuR5MrVd8hBBG2gppiS3Tg0KuKB3kMrMP5kBE9GitAKrr+0ZSZB9L1t++
	 nTlwfBxMqyfGQGIDzjq9/GVLG99NM9h9zTmNoBZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pascal=20No=C3=ABl?= <pascal@pascalcompiles.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 139/244] ALSA: hda/realtek: Apply quirk for ASUS UM3504DA
Date: Mon, 11 Dec 2023 19:20:32 +0100
Message-ID: <20231211182052.019422127@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

From: Pascal Noël <pascal@pascalcompiles.com>

commit c5c325bb5849868d76969d3fe014515f5e99eabc upstream.

The ASUS UM3504DA uses a Realtek HDA codec and two CS35L41 amplifiers via I2C.
Apply existing quirk to model.

Signed-off-by: Pascal Noël <pascal@pascalcompiles.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231202013744.12369-1-pascal@pascalcompiles.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9873,6 +9873,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x17f3, "ROG Ally RC71L_RC71L", ALC294_FIXUP_ASUS_ALLY),
 	SND_PCI_QUIRK(0x1043, 0x1881, "ASUS Zephyrus S/M", ALC294_FIXUP_ASUS_GX502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x18b1, "Asus MJ401TA", ALC256_FIXUP_ASUS_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x18d3, "ASUS UM3504DA", ALC294_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),


