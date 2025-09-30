Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E19217F55;
	Tue, 30 Sep 2025 15:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245442; cv=none; b=u4laIR2oNXHKBiJDXn7/qKitIfGx5lSyz394UuTJAvLIZWUhiB1sgGbF22hj1C+rpr89gEWQS/Xb2Mx5IO8dxctMhwMX2wiHVciVG+8lt5n2LZzl08UYRcMjL5PrH4VpFcwodJNmH0XUZcm96ygTR803FQLdg6RLKXY8GuIxw18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245442; c=relaxed/simple;
	bh=5/Xu8fWm6ZXxatMmOACjnrrfyt5nX4t6Kr3rnthXyis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDcwo7xwYyt898Qjd5S6on1psLd00hK04i3nXzA8fCF4obRlOq+M6FzyDGfuYAGv8w5dudrpgyBG1sAxlOfWWBVRwVVSziSEhGPi1J6G56BQlOPy4b1FIONLsOlIvlllStha9fsPJYPwSxZglZqd1oObwpypLCuaMqY3LVv/pEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYlOrWGI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYlOrWGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40958C4CEF0;
	Tue, 30 Sep 2025 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245442;
	bh=5/Xu8fWm6ZXxatMmOACjnrrfyt5nX4t6Kr3rnthXyis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYlOrWGIKrjZscHZC+NBVKJs+q4QvmRSytxCldi5MpXRqDU+GnyBK6I7rSgvjP9yI
	 FTa45wXqpAhgUK/Z1uyziRLN41+vFeu5KhPEZ/kvLGn6Tqj8zQgnUUbJ3lhaP6+8pb
	 LjDDo8IRPftSEOuwhrsn24Blgr+tZcxD7wMFyKWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 02/73] ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:06 +0200
Message-ID: <20250930143820.642304120@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4ce470e291b25..a1ab517e26b36 100644
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
@@ -3272,7 +3272,7 @@ static int snd_djm_controls_update(struct usb_mixer_interface *mixer,
 	int err;
 	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 
-	if ((group >= device->ncontrols) || value >= device->controls[group].noptions)
+	if (group >= device->ncontrols || value >= device->controls[group].noptions)
 		return -EINVAL;
 
 	err = snd_usb_lock_shutdown(mixer->chip);
-- 
2.51.0



