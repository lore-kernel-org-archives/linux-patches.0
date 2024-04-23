Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F520149E01;
	Tue, 23 Apr 2024 21:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908715; cv=none; b=FFyeuUxve8cG3L+0l3mjFydL4uizmm2GFx1/MEARWjqI4Z5ykhYpAmbDo45j3z5wJu4APtGuGo+QgGSvNYaBmOBvspP3Ds/pOYL+UutQlCNXdGEQjVruyfiBklyIPeDxcio6ydtzQ4UCfHfQgvREOhMBC6iDs16dEf4oYtx2YNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908715; c=relaxed/simple;
	bh=xiimkrwIWYMP4fV547r32SJzofMfVZB38pC79kPp9Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6mKIbkzR3UmmAeTFZWx6aice/N7P3UVCY3BeIKutTKh2KeLQMlkj66iWPp+arCPbZDhKePtoLAn2iTK8fAef4VhT46qAlD2KcL8590cRWKUS0neo3BYPdv2tGibGqRm3kh1mQXTLzas73MtzBQ2uzI4IvrqqVk5caZDqMgqkiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXvKaTN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXvKaTN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FF4C3277B;
	Tue, 23 Apr 2024 21:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908714;
	bh=xiimkrwIWYMP4fV547r32SJzofMfVZB38pC79kPp9Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXvKaTN4d+0RQmQXVhhxk3UxQnZDt7o/elrYbgNL1CwCCMzvkjiLtCRVAWqZV4QLF
	 tMqDMkpPadA7ZBWBeGI6yRvTjBNGVjbesf7ymu1OZqNuI5+4a3keCCiWvZl60yaTng
	 rbz9dXD8FE6e57xZ90j0ZmW1gLT+6zwymMwoop3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Geoffrey D. Bennett" <g@b4.vu>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/141] ALSA: scarlett2: Default mixer driver to enabled
Date: Tue, 23 Apr 2024 14:39:01 -0700
Message-ID: <20240423213855.576544346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey D. Bennett <g@b4.vu>

[ Upstream commit bc83058f598757a908b30f8f536338cb1478ab5b ]

Early versions of this mixer driver did not work on all hardware, so
out of caution the driver was disabled by default and had to be
explicitly enabled with device_setup=1.

Since commit 764fa6e686e0 ("ALSA: usb-audio: scarlett2: Fix device
hang with ehci-pci") no more problems of this nature have been
reported. Therefore, enable the driver by default but provide a new
device_setup option to disable the driver in case that is needed.

- device_setup value of 0 now means "enable" rather than "disable".
- device_setup value of 1 is now ignored.
- device_setup value of 4 now means "disable".

Signed-off-by: Geoffrey D. Bennett <g@b4.vu>
Link: https://lore.kernel.org/r/89600a35b40307f2766578ad1ca2f21801286b58.1694705811.git.g@b4.vu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: b61a3acada00 ("ALSA: scarlett2: Add Focusrite Clarett+ 2Pre and 4Pre support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_scarlett_gen2.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/sound/usb/mixer_scarlett_gen2.c b/sound/usb/mixer_scarlett_gen2.c
index f949d22da382d..2bd46fe91394d 100644
--- a/sound/usb/mixer_scarlett_gen2.c
+++ b/sound/usb/mixer_scarlett_gen2.c
@@ -145,12 +145,12 @@
 
 #include "mixer_scarlett_gen2.h"
 
-/* device_setup value to enable */
-#define SCARLETT2_ENABLE 0x01
-
 /* device_setup value to allow turning MSD mode back on */
 #define SCARLETT2_MSD_ENABLE 0x02
 
+/* device_setup value to disable this mixer driver */
+#define SCARLETT2_DISABLE 0x04
+
 /* some gui mixers can't handle negative ctl values */
 #define SCARLETT2_VOLUME_BIAS 127
 
@@ -4237,19 +4237,20 @@ int snd_scarlett_gen2_init(struct usb_mixer_interface *mixer)
 	if (!mixer->protocol)
 		return 0;
 
-	if (!(chip->setup & SCARLETT2_ENABLE)) {
+	if (chip->setup & SCARLETT2_DISABLE) {
 		usb_audio_info(chip,
-			"Focusrite Scarlett Gen 2/3 Mixer Driver disabled; "
-			"use options snd_usb_audio vid=0x%04x pid=0x%04x "
-			"device_setup=1 to enable and report any issues "
-			"to g@b4.vu",
+			"Focusrite Scarlett Gen 2/3 Mixer Driver disabled "
+			"by modprobe options (snd_usb_audio "
+			"vid=0x%04x pid=0x%04x device_setup=%d)\n",
 			USB_ID_VENDOR(chip->usb_id),
-			USB_ID_PRODUCT(chip->usb_id));
+			USB_ID_PRODUCT(chip->usb_id),
+			SCARLETT2_DISABLE);
 		return 0;
 	}
 
 	usb_audio_info(chip,
-		"Focusrite Scarlett Gen 2/3 Mixer Driver enabled pid=0x%04x",
+		"Focusrite Scarlett Gen 2/3 Mixer Driver enabled (pid=0x%04x); "
+		"report any issues to g@b4.vu",
 		USB_ID_PRODUCT(chip->usb_id));
 
 	err = snd_scarlett_gen2_controls_create(mixer);
-- 
2.43.0



