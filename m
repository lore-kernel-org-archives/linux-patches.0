Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1139376037;
	Wed, 21 Feb 2024 14:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524627; cv=none; b=ph57vHqa2WVA1ofiuK8eXIIcGmdwSBBILIRAuV0GzKPbB0z7mpRpPLNPu2tXR5sksaZoOLfqsIaNSsfFXS92PJQhb79430ZmXCNQXXQokmpEvMmqBn+aBKAPUdO0h+RKO+yY2ASOqES6s+j1sDTq3oihJCtny7CnsnYc9Ujb908=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524627; c=relaxed/simple;
	bh=krm8yX6kK/maOXqCMaDkLsnMR45Rl9DjIJ4WYt0HxVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SI9DWW5RUqfHTZgjCUiZbcYWBGqqQY8cB8cVcqDRYaWCoDLbkcs0EQkORuzqH01zUQvpMZjJxi++3YLrLqmWUWjY2YsGk5tCm74CXOV1wCUPVOlDObKVaYWern0y4aQUK7WbAY56mvvJyOqz0r4wTQ70rXmkWderzFY09pWbhhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hIMgcJpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hIMgcJpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7528DC433C7;
	Wed, 21 Feb 2024 14:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524626;
	bh=krm8yX6kK/maOXqCMaDkLsnMR45Rl9DjIJ4WYt0HxVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIMgcJpPKhkUK+Xw9JoHjrNmgKyIwjccZuUOPHpNadBXsEar+PZA/XdvVt3+ZbdFD
	 RejU9zzNYc9nTo5mOx6nsrK02jy6bTiHuPeNBJ/VLlqBtlNMznT6h49X24Jx3z2+7S
	 DOX1jsSO+t0XObQPlSmx6f2zGwmJhK0ib8xChNCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Guzenko <l.guzenko@web.de>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 300/379] ALSA: hda/realtek: Enable Mute LED on HP Laptop 14-fq0xxx
Date: Wed, 21 Feb 2024 14:07:59 +0100
Message-ID: <20240221130003.797323277@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Luka Guzenko <l.guzenko@web.de>

commit f0d78972f27dc1d1d51fbace2713ad3cdc60a877 upstream.

This HP Laptop uses ALC236 codec with COEF 0x07 controlling the
mute LED. Enable existing quirk for this device.

Signed-off-by: Luka Guzenko <l.guzenko@web.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240128155704.2333812-1-l.guzenko@web.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9026,6 +9026,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x8786, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8787, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
 	SND_PCI_QUIRK(0x103c, 0x8788, "HP OMEN 15", ALC285_FIXUP_HP_MUTE_LED),
+	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


