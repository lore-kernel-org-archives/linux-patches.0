Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528AB2FCBFC;
	Tue, 30 Sep 2025 15:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244486; cv=none; b=Q20WjE92Mg2uwLw1PS+0pG9rxV1BjyMRd4ux/m/Wkdn5/40jabcbgWriBh1K0EcwE5uvyjM887cx922zCYCZP0btinMp1wvr8xE2qIIIe0Pxmt00e3J4Thj+IJizOF+IQi/f9Yk4Y5UcFDcZCuuw5yt30KIgH9EaVexQGvU/aEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244486; c=relaxed/simple;
	bh=rsM7/7LI3M3SMsiWhXglDhgyK05/rvz9TuP2z0RWdGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfSbbdjGzqr11TmtuCgnRu7FUbac66uIzpF1twmH33NbUmX4LzFr8GfvCPAXnFbcFxMKKuEnX+GbTRrBR4rprS37gMwA8CxJaYOqfS6rV1KBex/Y2yj5Td09/yqoKvsdQ3/aWfQo4G4sPDA6Wehz8zgEviPglrcNmWfQs2LFAdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+vAfKHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+vAfKHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3D5C116B1;
	Tue, 30 Sep 2025 15:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244486;
	bh=rsM7/7LI3M3SMsiWhXglDhgyK05/rvz9TuP2z0RWdGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+vAfKHzfSpnDU/q+VJHdApZNhPuBXCxQYhjHc3NuRCpp/scnU1aRCm0pFGY8v3l/
	 OMEfm6RmpZkbsMJsddc6YA35jfZ8tTwh1F19pHOLRO3fGuwdldykE7E6vUErX1xtIb
	 oYKecdCytuJ0m7DLzuvam7xq5CAXMeyv5y1KmYK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 006/143] ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks
Date: Tue, 30 Sep 2025 16:45:30 +0200
Message-ID: <20250930143831.495567888@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index c4d79a9ce2baa..eb245272f123a 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -380,10 +380,10 @@ static int snd_audigy2nx_controls_create(struct usb_mixer_interface *mixer)
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
@@ -3955,7 +3955,7 @@ static int snd_djm_controls_update(struct usb_mixer_interface *mixer,
 	int err;
 	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 
-	if ((group >= device->ncontrols) || value >= device->controls[group].noptions)
+	if (group >= device->ncontrols || value >= device->controls[group].noptions)
 		return -EINVAL;
 
 	err = snd_usb_lock_shutdown(mixer->chip);
-- 
2.51.0



