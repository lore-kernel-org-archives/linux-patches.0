Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FEDD528;
	Sun,  7 Sep 2025 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276769; cv=none; b=hKoPouJY8h2eoXPzE8GilixWwiZGsrolgIOjt5fOjsmDWg4Nafof/krlLLH/5JBrjS8VGvCBUkoDn7bZh3PJ+ETcHwq/wPLBGU2DiIysvofvgEHIUAESxW4iGPefmorrko9ZJP9LZzyUol+8jZdgHwhiYjfBaRPHZ19nhPLOId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276769; c=relaxed/simple;
	bh=lTTGloDFF5n/gygvfFojc/leSOVpi9hHHz9ZAfGrU88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc76WcsYDxkYiGRDv7uW2vOf/XXdu1JFWkEG7YawmmX4RAysrLD7FpSo/XkDy+GJYbhu4DD+yKjiVdYdkB92nwWyMBSs4hcSXvva9k6Yn53MlQOcRsDkK0Yzpo6YmDfv6ufLvrz20RxwBNQWrM90IwmNwFrF59/I4GeBkljNolY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioqQlzxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioqQlzxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC89C4CEF0;
	Sun,  7 Sep 2025 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276769;
	bh=lTTGloDFF5n/gygvfFojc/leSOVpi9hHHz9ZAfGrU88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioqQlzxSzS2aUaktT8cmsvkd6uKwQSYu0zShHvV0z8jtL6LhFvjp2DNJ8xS2AroR7
	 /+lYwJ416sRncV/dRJd4RYUH/P3LBFCSK/viPAT/HIwrnQwXHfTIxQCf7kUUkNeBFc
	 rxkZyi7qVu5bjtcN2xFk/CHp/bN6N1L6e6g6IMHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 097/121] ALSA: hda/realtek: Fix headset mic for TongFang X6[AF]R5xxY
Date: Sun,  7 Sep 2025 21:58:53 +0200
Message-ID: <20250907195612.343927566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10635,6 +10635,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


