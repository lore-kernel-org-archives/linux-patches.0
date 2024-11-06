Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE92C1DF251;
	Wed,  6 Nov 2024 12:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896393; cv=none; b=OEH1/EiuraYeAwgplXLSNujtJTf/F1mheO1vcXPLR+ghSE6vCAgJQkHO+WwDzrM0t6w6BbiShi/Vyv1jqXtYfP/QbCIgirKMEi7ThjYu109SHmWtrsPNoQRgqlx23NbeMcSklw8ffYAgcQ51hIEDnBN/S6zYlNsYUVFjwPth2Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896393; c=relaxed/simple;
	bh=vxCbe6N3GN4heMUSFsV/ZhkPl0vmlMV/PfNA4MHYs14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8YyjIV2tj10X+XvVmI8i9QWD9B7naCExtKwyUSg3j0NXMPkVjnEyBMBxEpG7czitjjiZl5qY6Dxs2u6iS1iqosLzxsGCuXCQgGiSJgIeozstIVLJ+zQ1ydw3UHUgwi9I4HfBAFJ3z46tb6BfDjh3yiYiq0L8ouV/8va2aZChG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buy4DWx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buy4DWx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46200C4CECD;
	Wed,  6 Nov 2024 12:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896393;
	bh=vxCbe6N3GN4heMUSFsV/ZhkPl0vmlMV/PfNA4MHYs14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buy4DWx3R0WuWMa8zDu4QKQQDQu6XrHbCkHKCMeA8c2Upf1E7TQkEiCv8rv39ubF8
	 67xayPnCS2vznlTB34mhTKCknxMq3idYFsV/oD4C7Q363kMIuxZ7M8qsYWXQtn2cTB
	 jJQo5s4d7cED03yBHnErjCghp58zloLHspVmsXwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 186/245] ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1
Date: Wed,  6 Nov 2024 13:03:59 +0100
Message-ID: <20241106120323.819844041@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

[ Upstream commit e49370d769e71456db3fbd982e95bab8c69f73e8 ]

Quirk is needed to enable headset microphone on missing pin 0x19.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029151653.80726-2-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 25d4c417d3c07..660fd984a9285 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10971,6 +10971,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.43.0



