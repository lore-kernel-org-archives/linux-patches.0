Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8B51FB8B1;
	Wed,  6 Nov 2024 12:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897676; cv=none; b=GjTtBNxmmDLAEJLHRdDtf4ObDc2ajwBbM1UU5Yv+UMzz89FWkoQNbuOSM+nC9RdfIXeXrLG/kJmTco/U8yzyI0iSgmQJ0ebsiSNgZVcEiPINEcLlecCbgF/ToXF8Dpml7NeBtE/cpWkGtdkG3cizKKEwF2BBXVDzOAMkmn875ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897676; c=relaxed/simple;
	bh=fT9luClZJO8VOzAKeoFzM0bFg9FJryw+q/RPtFpaPms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpsxpCb8DcvrwT/8sjm8y3rIAmQdlgmqLMAQjxHszAyc6HjGzd/0aj0q1hM0v/0PwDYzwsDsY6d/4RT+ubFuOI1fes14jCdgRHXZDwKltyj6AA/IcrEgVpBHe/HHL0JxDsi9PWX4kZrYt40ZyoCHviLV9WswgkIlzSarsMZQRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcm0jjv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcm0jjv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9756CC4CECD;
	Wed,  6 Nov 2024 12:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897676;
	bh=fT9luClZJO8VOzAKeoFzM0bFg9FJryw+q/RPtFpaPms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcm0jjv+uWJ6Y+PAKNFLSfAKLvs2fIdyp99kxCAELWbRwwgpQQ3DgEGJu61ySCzq8
	 OpFftW7Nm615wf3O43AwDAuTthH7akGnjZOcRZjAPsaQsFc6cTugIduF7wTTEpggul
	 nIgY9mPrBURL9req5VJmC5/Hrhkw8hNvmx7ZV7oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 133/151] ALSA: hda/realtek: Fix headset mic on TUXEDO Stellaris 16 Gen6 mb1
Date: Wed,  6 Nov 2024 13:05:21 +0100
Message-ID: <20241106120312.520229344@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 62747d77cd9ab..3c48036fdf0b0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10403,6 +10403,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1d05, 0x115c, "TongFang GMxTGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),
-- 
2.43.0



