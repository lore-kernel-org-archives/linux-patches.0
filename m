Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A52D19F120;
	Mon, 23 Jun 2025 22:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717190; cv=none; b=ULVjk/P8d7awbxtJI4UinBn8wJsLWu9IIy14tIsEL4mGGo5xHlPUp+YwMXI34HU5lMTptF5zNYqW9oXGTiVpBNk6zhIVOylU2VoDDYWMA/imyPN1E7IQ8Cb2ZMOT6/ES7OZ05OTC0GKevAmKdJn7jDzhPEoo9wb4FHojEY0zUfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717190; c=relaxed/simple;
	bh=fSE2ERtrPYlvZ80qT/wnBIvS4RMb7wcgTx8n4v0diVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/hJmym9WnbLMSX5Ui5mShezhXCikPLmjC0dmV9oO1aDZbTHqt2fRoHxSDdLzkYuL92H2D1vSWUUIQALUwMPSEcYDY+U1xgxTGdQpHYeSubjI/QW+BJGmU1WgvNE1gCeAtqQHtnMRVauHL3rfBGe/DJhZevhEOTUy3J/EsXFUZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8QKTqqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8QKTqqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66D7C4CEEA;
	Mon, 23 Jun 2025 22:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717190;
	bh=fSE2ERtrPYlvZ80qT/wnBIvS4RMb7wcgTx8n4v0diVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8QKTqqK63NcYqHqpCkaMBl7rOju9BoxkNurGiMZahsoa2PRSWiUQJkfAw4R5HlDj
	 g8YQEzJJd7FH1zhpggrmoh1umZDJSqhcNO3fJcxka9hkmlKHOj4R3dGx1pSt/I3tHp
	 ihMW1out1CgbmjWXB2vGnEXmXtBxitu4x5rFbbWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Chiu <chris.chiu@canonical.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 335/414] ALSA: hda/realtek: Fix built-in mic on ASUS VivoBook X513EA
Date: Mon, 23 Jun 2025 15:07:52 +0200
Message-ID: <20250623130650.359178609@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Chiu <chris.chiu@canonical.com>

commit c6451a7325874c119def1d4094f6815c0c8fdc23 upstream.

The built-in mic of ASUS VivoBook X513EA is broken recently by the
fix of the pin sort. The fixup ALC256_FIXUP_ASUS_MIC_NO_PRESENCE
is working for addressing the regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250610035607.690771-1-chris.chiu@canonical.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10840,6 +10840,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x103c, 0x8e60, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e61, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x103c, 0x8e62, "HP Trekker ", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1032, "ASUS VivoBook X513EA", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x1054, "ASUS G614FH/FM/FP", ALC287_FIXUP_CS35L41_I2C_2),


