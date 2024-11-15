Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771C62BB1B;
	Fri, 15 Nov 2024 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653956; cv=none; b=ldnI/1GS8A5y8O8URIIxyOonU3yzrsPIqRscvFXWr1i2g7CiNN3sSdpxnrQVRZUrBemEvJsIv4JNglbWbAuIHKPAaMAvu2ZhbM+PRrBuqB1eqbYLhvmKoB4fQZ6dZxXJRtzsV9Ca+V2gggAHOTNDnhIU/GC14QsZHSfwrGPgnYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653956; c=relaxed/simple;
	bh=o9cQHVRYfpsugsnr8VeHsQdmrHUwACFjHb8x+O9QU9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAPcQf+RY9rGtz/kypsYBjbuKnYL8PXhS0z7RS0i3LKhHWBMLbLN7Zw4W0vHkE1d6tK8m9HlvDbkw3O9LRa3OzyPFn+ca8Lt3UzC1b5DGpg0HPEMr7RY4QlsGC9Ee8DwduL7IwXEEKrNUBdaaNoq2kxOzgH3YWd6lo+FWqJyfT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2CXYdzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2CXYdzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CB8C4CECF;
	Fri, 15 Nov 2024 06:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653956;
	bh=o9cQHVRYfpsugsnr8VeHsQdmrHUwACFjHb8x+O9QU9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2CXYdzMMa49wo1QujxzqdZFLIfuTSwCiwZN4+miWTH/2veBbx1LyKMCQGo5KlLTh
	 kSpdjHjBscSazG94R77QowF/Oxzwt6wCBspl+qJo7TAJNs66ccw+r0IG9oCcan/FT1
	 ZolCMe4ykGy/mhGsgbglyzEalejwMwmv1KJW1oZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20Sch=C3=A4r?= <jan@jschaer.ch>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/82] ALSA: usb-audio: Add quirks for Dell WD19 dock
Date: Fri, 15 Nov 2024 07:38:42 +0100
Message-ID: <20241115063727.894586633@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Schär <jan@jschaer.ch>

[ Upstream commit 4413665dd6c528b31284119e3571c25f371e1c36 ]

The WD19 family of docks has the same audio chipset as the WD15. This
change enables jack detection on the WD19.

We don't need the dell_dock_mixer_init quirk for the WD19. It is only
needed because of the dell_alc4020_map quirk for the WD15 in
mixer_maps.c, which disables the volume controls. Even for the WD15,
this quirk was apparently only needed when the dock firmware was not
updated.

Signed-off-by: Jan Schär <jan@jschaer.ch>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241029221249.15661-1-jan@jschaer.ch
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 750a386b9c177..21b3d2194d48d 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3193,6 +3193,9 @@ int snd_usb_mixer_apply_create_quirk(struct usb_mixer_interface *mixer)
 			break;
 		err = dell_dock_mixer_init(mixer);
 		break;
+	case USB_ID(0x0bda, 0x402e): /* Dell WD19 dock */
+		err = dell_dock_mixer_create(mixer);
+		break;
 
 	case USB_ID(0x2a39, 0x3fd2): /* RME ADI-2 Pro */
 	case USB_ID(0x2a39, 0x3fd3): /* RME ADI-2 DAC */
-- 
2.43.0



