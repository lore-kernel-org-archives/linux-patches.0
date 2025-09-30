Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63613C465;
	Tue, 30 Sep 2025 15:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246039; cv=none; b=oVwQtgncNdqtgCeG5BFH/5C1oyb1yhOS9tp/owMPg8s7ep61kO0bLyFzw7HdGSEH1vMpS50i3JHvFORPTQqvxRJe1PPFYn82vskfQFdeVZ9HIjyECRdeNTy5rsEb2GBLnTRA8xmZ6vn978LOeuoFTG1sikOqfqdBmQgyy7+xhjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246039; c=relaxed/simple;
	bh=ev66XqK3dqf6ds8i2gj51eQ+o/ij0jF9agL6jlvtLt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEwPK2/Sat5mrtncfL+3m/y7JBY2YLqQB96mwt0e07TDDG5aBXAOWasTH1Y50A0PcD/VlQl6jraKIIoaFqWfIysNV0TLIsnhT+Tmz9fHhLiDcrbuP8RxVY1OSaemWoVnenXeY9p5XCEx7x1xAr/YyFYyxX3sZaC2eC1G7hgHmyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcG501j+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcG501j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4417C4CEF0;
	Tue, 30 Sep 2025 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246039;
	bh=ev66XqK3dqf6ds8i2gj51eQ+o/ij0jF9agL6jlvtLt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcG501j+SxbaDxGZZYFc9qZVZgg1cWaMvZsQWyirItQKNkMFzClJpF0mTb9+aI9Z/
	 p+FMz5DVQaLdQfq39qjzlfLLUR/WFSMkbGRlE7rRFx/bgwtouxXpnP+YFvmBUG1IZk
	 uCfwFDiiEgAUkP2o9POSqXwc/Ja8qWzijc8LOrF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 05/89] ALSA: usb-audio: Drop unnecessary parentheses in mixer_quirks
Date: Tue, 30 Sep 2025 16:47:19 +0200
Message-ID: <20250930143822.087000017@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a97d1ca8443ca..78c0feb7dcdb7 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -379,10 +379,10 @@ static int snd_audigy2nx_controls_create(struct usb_mixer_interface *mixer)
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
@@ -3846,7 +3846,7 @@ static int snd_djm_controls_update(struct usb_mixer_interface *mixer,
 	int err;
 	const struct snd_djm_device *device = &snd_djm_devices[device_idx];
 
-	if ((group >= device->ncontrols) || value >= device->controls[group].noptions)
+	if (group >= device->ncontrols || value >= device->controls[group].noptions)
 		return -EINVAL;
 
 	err = snd_usb_lock_shutdown(mixer->chip);
-- 
2.51.0



