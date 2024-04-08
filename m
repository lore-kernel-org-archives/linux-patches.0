Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1185F6A352;
	Mon,  8 Apr 2024 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583652; cv=none; b=QnDes9qy/sppspStf/ODSOf7Nqop/MXdjoPhim7tv5nIypUdIJ+nlPeQ5KtcJMduQGaVc8XeQUaxTRJclFHV65MZpYknI5u6E6S/AEA+Wr01RcUyDxf2ztd5klJfB8DSpyIesTfUVKDaFSmvUlVCTiHlrjzaxz4oR7wiUDdWYNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583652; c=relaxed/simple;
	bh=wcpnKYlSsxXwvGPDV99VpWpk6NCEDEJiRKW9Xa73dJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZApLbRPPUAaD6EQWli+TNxTBY/EwFvJqLUjI1CYCb/H3qWo3XcoHqgU4x+G46wtHykap/ZTfZfHRfijrca3lzak9ciuJIcCcsyArhf3yBduhuHGZInY3ggJ3seX3lw2g3ikJ9HF7jwpAGCnoo2RBfrDn24fhIqXN7HY231tc90k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXiIRSSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXiIRSSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B530C433F1;
	Mon,  8 Apr 2024 13:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583651;
	bh=wcpnKYlSsxXwvGPDV99VpWpk6NCEDEJiRKW9Xa73dJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXiIRSSUZP/JLIzHBr1Onn28T5jwRK78ga8aLgKlfdlMfUvPn8Yl3SKejzotYq4RD
	 PbKuWXi3TxejhjdIqVpX1epxDvRh5uaXQAiDwJ/Y3WTSrftoUMAGK3SCO34i/it5zB
	 tF2IoYUIRbkbPnytUKKXiMeOpDoU2F4dd2Iej+8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Gede Agastya Darma Laksana <gedeagas22@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 205/273] ALSA: hda/realtek: Update Panasonic CF-SZ6 quirk to support headset with microphone
Date: Mon,  8 Apr 2024 14:58:00 +0200
Message-ID: <20240408125315.704913514@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10189,7 +10189,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1254, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x12cc, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
-	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_HEADSET_MODE),
+	SND_PCI_QUIRK(0x10f7, 0x8338, "Panasonic CF-SZ6", ALC269_FIXUP_ASPIRE_HEADSET_MIC),
 	SND_PCI_QUIRK(0x144d, 0xc109, "Samsung Ativ book 9 (NP900X3G)", ALC269_FIXUP_INV_DMIC),
 	SND_PCI_QUIRK(0x144d, 0xc169, "Samsung Notebook 9 Pen (NP930SBE-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),


