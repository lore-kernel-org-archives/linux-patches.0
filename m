Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8594E14BFA2;
	Sun,  7 Sep 2025 20:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276347; cv=none; b=Xu5xbkeiD8+0mPpJwvNyfJBG30zlG0lomZc3sekozepT33crGQIOqKuXP1IBJNPsnryFd/qsR3Ku/cM67tm7ulWmfskscvD2MMjJroV5nFJqxA1WHqe+tk2EW1OQ5N1vdpE3PLK878UWf3RU4zuo79/3zqmy73PBrSWNxU1qVYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276347; c=relaxed/simple;
	bh=WTscjk8ZA0khWASVVpLg7KPhG/7mxJOrA2TLxqO8oBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFNkrbxaSmKUAkh99djM2okQWRsSIY9qLXPFECpFzV+NR3mdTd+nTnCVFHZItgdFJNllx3dOIBqYHLzyGMYr4YWctD1mLRZRK5uvY/LDBSOeomuFq0CILP1R0+7XJsZdThdoiYgYG0s/EPZgxu++S0xoT1sdLt8gfJyrVpdDIag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ALYrQrTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ALYrQrTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC4FC4CEF0;
	Sun,  7 Sep 2025 20:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276347;
	bh=WTscjk8ZA0khWASVVpLg7KPhG/7mxJOrA2TLxqO8oBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ALYrQrTsfEzPAKMT88VN+h0oshESAwuiAHgvzdwQIWyDdbwy9NWbKzR03Y7xc2itg
	 DrVEAxkyD6TDG7/p/bJzB837pqH24FEpaxpvCKeaoJTM3a9TYJH4O6Gfnz3nY/lRhZ
	 E2QlMlNhaWTA7kbIouROqeqFVJ8BfjdgMi9jzn8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 077/104] ALSA: hda/realtek: Fix headset mic for TongFang X6[AF]R5xxY
Date: Sun,  7 Sep 2025 21:58:34 +0200
Message-ID: <20250907195609.674501462@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit 051b02b17a8b383ee033db211f90f24b91ac7006 upstream.

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR5xxY and X6FR5xxY devices.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250826141054.1201482-1-aer@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10439,6 +10439,8 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


