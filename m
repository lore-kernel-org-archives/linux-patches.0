Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296BD2566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEAC433D2;
	Tue, 18 Apr 2023 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820980;
	bh=81sE4P5bHnf2EZW0fON+R/FTeKXefsL7n/fxMc8zp1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDwfY/Gx/iqfIqpFc2Kblt+nROtEM/TXHw3ZSeFauM3g8UoCq+27Avp+B9Fa6wqvM
	 ums9NdBl2bBiY+NbRC5NmT42Wvczv+B4nr/8tD2GE8cTEP1YRTls3lWPBUwIGk/u++
	 Ob3mNxWKy7Q4OwTpCL08vUBofENht2B6UwiCsyoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 46/92] ALSA: hda/sigmatel: add pin overrides for Intel DP45SG motherboard
Date: Tue, 18 Apr 2023 14:21:21 +0200
Message-Id: <20230418120306.456864698@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit c17f8fd31700392b1bb9e7b66924333568cb3700 upstream.

Like the other boards from the D*45* series, this one sets up the
outputs not quite correctly.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197826-1-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sound/hd-audio/models.rst |    2 +-
 sound/pci/hda/patch_sigmatel.c          |    2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/sound/hd-audio/models.rst
+++ b/Documentation/sound/hd-audio/models.rst
@@ -702,7 +702,7 @@ ref
 no-jd
     BIOS setup but without jack-detection
 intel
-    Intel DG45* mobos
+    Intel D*45* mobos
 dell-m6-amic
     Dell desktops/laptops with analog mics
 dell-m6-dmic
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1949,6 +1949,8 @@ static const struct snd_pci_quirk stac92
 				"DFI LanParty", STAC_92HD73XX_REF),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_DFI, 0x3101,
 				"DFI LanParty", STAC_92HD73XX_REF),
+	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5001,
+				"Intel DP45SG", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5002,
 				"Intel DG45ID", STAC_92HD73XX_INTEL),
 	SND_PCI_QUIRK(PCI_VENDOR_ID_INTEL, 0x5003,


