Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CB42236EB;
	Tue, 30 Sep 2025 15:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245224; cv=none; b=uDcLIaLgbjuZVZv5tAZI8kOGu8+CaK2oJoXHoKgT4A1ZBz8SD21yVhSOLfOBOyGtfHQKHkNFsEdDeO7lc8/31m/cf0IZOvVkoa+5G0XQT7ze0imuCjoaQA6yW3f0pRpH/F3tsGD2zJpwtHeQOKhwQ5Qoz6joDuHHWvbeF3GmoZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245224; c=relaxed/simple;
	bh=pQtLG+y5tVNNOONFJnU1Pm2X/ImJN8/gWrASx5ybz34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pc/cE9UhSgsKJATYvaBs8Mrnn7DLhfwwJwkpT2OS/FYK1WY8ejmIIDZqVpnuTwTuLyuwJJ6LdmgN3YVqKcjc7d1cvnyzdvfs7CxsOLLMc3U9U671jmm5ZoRSB4hVRYmMnXLxAVf30P+BwrVj7GgglWr6cztdrMaVKUcbJFUChpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymY0heIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymY0heIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FA1C4CEF0;
	Tue, 30 Sep 2025 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245223;
	bh=pQtLG+y5tVNNOONFJnU1Pm2X/ImJN8/gWrASx5ybz34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymY0heImEPdgXCKmI88QweMi2+UTGTgp2/bKt1actCtFCxmd4O1SgfIgL6PeVO1XV
	 Wa1cYiQxezpTOvGbFDVeU/9HJgTsH7fcga+mUOz7866v7d5qub7K7wUDFtgmzdMARg
	 yq1wFFDDOx0kG6eaawqClTOBwvCk9yTEL8cMsMJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 104/151] ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:14 +0200
Message-ID: <20250930143831.745289048@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit c0495cef8b43ad61efbd4019e3573742e0e63c67 ]

Fix multiple 'CHECK: Unnecessary parentheses around ...' reports from
checkpatch.pl.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-5-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 0e8cf8b06b8ad..866d309454aa3 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -376,10 +376,10 @@ static int snd_audigy2nx_controls_create(struct usb_mixer_interface *mixer)
 		struct snd_kcontrol_new knew;
 
 		/* USB X-Fi S51 doesn't have a CMSS LED */
-		if ((mixer->chip->usb_id == USB_ID(0x041e, 0x3042)) && i == 0)
+		if (mixer->chip->usb_id == USB_ID(0x041e, 0x3042) && i == 0)
 			continue;
 		/* USB X-Fi S51 Pro doesn't have one either */
-		if ((mixer->chip->usb_id == USB_ID(0x041e, 0x30df)) && i == 0)
+		if (mixer->chip->usb_id == USB_ID(0x041e, 0x30df) && i == 0)
 			continue;
 		if (i > 1 && /* Live24ext has 2 LEDs only */
 			(mixer->chip->usb_id == USB_ID(0x041e, 0x3040) ||
@@ -3254,7 +3254,7 @@ static int snd_djm_controls_update(struct usb_mixer_interface *mixer,
 	int err;
 	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 
-	if ((group >= device->ncontrols) || value >= device->controls[group].noptions)
+	if (group >= device->ncontrols || value >= device->controls[group].noptions)
 		return -EINVAL;
 
 	err = snd_usb_lock_shutdown(mixer->chip);
-- 
2.51.0



