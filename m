Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4A379F0;
	Mon,  8 Apr 2024 13:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583622; cv=none; b=eP3LMAfWAG/j02yaNk83Ol2iTdbY87op8n+gwDtoXRuww6ZkAb5IPY5dXBj33UnzW0GqMPczmUmbicD3M4STwRj7e5Vv1gKpp+6dKlK/4CmK/Ab7XZ6sMwOq1dG+abFRzuSnbPqJ5SYsdoHht/4Dk5oBcT3ZQ8p5ZNiWA4g2sAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583622; c=relaxed/simple;
	bh=XuezbCvt1ruLuGs3N4clcLn90765vSzkbQ3HkIOfuog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QAmlPv9CM4Q96rVmWU2eDpCEX9XER9PJd5z2dupsq/guYEo4GIZnmzwg/gBgWP3L1aI3SjbF3cSbRhNBaRbI6EbSCC5Er69iFmeCAo2VUoABuquZh4rhEYYH1SgKOF//PrKYFuCBnhWp9PwT5odTyL36BRLGty6y4RVMzvHQgCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ru+gFwd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ru+gFwd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628A0C433F1;
	Mon,  8 Apr 2024 13:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583622;
	bh=XuezbCvt1ruLuGs3N4clcLn90765vSzkbQ3HkIOfuog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ru+gFwd80+DocAk/pTDW/6CvSdDVDZGGNEz7pVEBG6Ap53vnO/HqoE3KxU4I4MgGP
	 KTw+X9k9amPveEU4FVT+13DKw0p5lVnfw1DQuJdl/IwRSw8DsVUjTifNEyZ9REKqi7
	 pPMN0lFlnw6J7HmXN0tUIGI+Yw18fuhxz2bB8hlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 202/273] ALSA: hda/realtek - Fix inactive headset mic jack
Date: Mon,  8 Apr 2024 14:57:57 +0200
Message-ID: <20240408125315.597727953@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit daf6c4681a74034d5723e2fb761e0d7f3a1ca18f upstream.

This patch adds the existing fixup to certain TF platforms implementing
the ALC274 codec with a headset jack. It fixes/activates the inactive
microphone of the headset.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240328102757.50310-1-wse@tuxedocomputers.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10427,6 +10427,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x1147, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
+	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),


