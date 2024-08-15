Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACD71AC893;
	Thu, 15 Aug 2024 14:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732848; cv=none; b=GaRRAaIZt4qh7x1wioKWo4vIbdz5CUH/ozVPYLia0KuUDg/DZ32fZBQpIT9QiobWa1S+TYi25aO4PMTxg2L9SZwigTjtEGG64WCNnmWNWjTT3/95SHtxA57M2qdgEZQVuPFrjQ0u1Sf95EiCH9YTRHJo7lhwREoeFtk+EEdDo98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732848; c=relaxed/simple;
	bh=isU8ahgRaF1vpRg+h2VEZNYwTI9lI1LgUKcyF08AMhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX5j20capYU/PPFz5ScRG1WocChddgmcbGBKGbYG2Fu5m+iPtSekA7yUoZSZZxDxWzlFN00JiObsX1B0XYw7ibu8SPnnQAVdaInrU8v8vAS6ST27tv1Ww0HqZ6O+DiyQM9EGhpY7AvAGszpPRgGqu6vUrciICrsSeD8VM78XGSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXpojyEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXpojyEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2409BC4AF0C;
	Thu, 15 Aug 2024 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732848;
	bh=isU8ahgRaF1vpRg+h2VEZNYwTI9lI1LgUKcyF08AMhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXpojyEkj4zFTQbMxeB1eYV/OdLmunYXuXWaxGwsUmU2+rVfUX/vOOGkTBuuP1DTY
	 /ttMld7HqwN0iMBmr+mfIK4aX9blSUv04gstYRgeOCFbORJHclnYDX2196a0hZe77t
	 sPc5+CUtBw62hHyNvaBjv2RPYg8pJGjDZ/Ad6hso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 304/352] ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4
Date: Thu, 15 Aug 2024 15:26:10 +0200
Message-ID: <20240815131931.208328586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 176fd1511dd9086ab4fa9323cb232177c6235288 upstream.

HP EliteDesk 800 G4 (PCI SSID 103c:83e2) is another Kabylake machine
where BIOS misses the HDMI pin initializations.  Add the quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806064918.11132-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1963,6 +1963,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


