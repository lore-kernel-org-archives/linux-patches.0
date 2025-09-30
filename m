Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997C92FCBFC;
	Tue, 30 Sep 2025 15:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244518; cv=none; b=jBetkwByDyM4CZBlctvilNpdb4hVXbzPFWLSDnBbRAuRdsUKaCBOfwLl7lczzH/4/YTe5SlTsYIMQKMkJ8I5kMsw5vbRoFZi3CyXMR2eQ+t3d4OXsvu/meCm3W5vaaIbtGJAxq8AstuV41T8jCJahISumOUHAr6F9Cpwdh3YCQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244518; c=relaxed/simple;
	bh=oc5ux2SZ4rn8tQM3e9bxXWn0W6hHq/mYU1Rn+ubHygE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SozoHb9oyXU43ffVOkYC8Ky8lNgEEs4cv04YUVx9c5qYywBu1ZBIq897CebkGOEupF04e5XFVng1fMyLhkom/fS75CcsOb88StctLA2Lnb4+4JDnubV7xQh4YT8bSGrvqF4jS0Mo0nhZWcOwLU9Ft0ZzugblQ+va2u7yce8lpJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Z8gLyzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Z8gLyzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7723CC4CEF0;
	Tue, 30 Sep 2025 15:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244518;
	bh=oc5ux2SZ4rn8tQM3e9bxXWn0W6hHq/mYU1Rn+ubHygE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Z8gLyzW9WphdTkFSskAn+rGIQ2pPCyJ7oHljV1SLa0CqTAcQAW5Fs2MZwyfqVd9y
	 X2UXSe4GU76Es7/5xaMEk2XpsgOrSR7nceq1F59JbAyNx6RrbuSR1D9VPb9PVQ74zV
	 WTEjqsVbp06FV6DMMQJ2OU8rPjk/fH9tSNc4+qYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoli An <anguoli@uniontech.com>,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 032/143] ALSA: usb-audio: move mixer_quirks min_mute into common quirk
Date: Tue, 30 Sep 2025 16:45:56 +0200
Message-ID: <20250930143832.525013821@linuxfoundation.org>
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

From: Cryolitia PukNgae <cryolitia@uniontech.com>

[ Upstream commit 2c3ca8cc55a3afc7a4fa99ed8f5f5d05dd2e65b3 ]

We have found more and more devices that have the same problem, that
the mixer's minimum value is muted. Accroding to pipewire's MR[1]
and Arch Linux wiki[2], this should be a very common problem in USB
audio devices. Move the quirk into common quirk,as a preparation of
more devices' quirk's patch coming on the road[3].

1. https://gitlab.freedesktop.org/pipewire/pipewire/-/merge_requests/2514
2. https://wiki.archlinux.org/index.php?title=PipeWire&oldid=804138#No_sound_from_USB_DAC_until_30%_volume
3. On the road, in the physical sense. We have been buying ton of
   these devices for testing the problem.

Tested-by: Guoli An <anguoli@uniontech.com>
Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Link: https://patch.msgid.link/20250827-sound-quirk-min-mute-v1-1-4717aa8a4f6a@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 10 +++-------
 sound/usb/quirks.c       | 12 ++++++++++--
 sound/usb/usbaudio.h     |  4 ++++
 3 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 6b47b3145d2cf..3df537fdb9f1c 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -4608,16 +4608,12 @@ void snd_usb_mixer_fu_apply_quirk(struct usb_mixer_interface *mixer,
 		if (unitid == 7 && cval->control == UAC_FU_VOLUME)
 			snd_dragonfly_quirk_db_scale(mixer, cval, kctl);
 		break;
+	}
+
 	/* lowest playback value is muted on some devices */
-	case USB_ID(0x0572, 0x1b09): /* Conexant Systems (Rockwell), Inc. */
-	case USB_ID(0x0d8c, 0x000c): /* C-Media */
-	case USB_ID(0x0d8c, 0x0014): /* C-Media */
-	case USB_ID(0x19f7, 0x0003): /* RODE NT-USB */
-	case USB_ID(0x2d99, 0x0026): /* HECATE G2 GAMING HEADSET */
+	if (mixer->chip->quirk_flags & QUIRK_FLAG_MIXER_MIN_MUTE)
 		if (strstr(kctl->id.name, "Playback"))
 			cval->min_mute = 1;
-		break;
-	}
 
 	/* ALSA-ify some Plantronics headset control names */
 	if (USB_ID_VENDOR(mixer->chip->usb_id) == 0x047f &&
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index e75b0b1df6eb2..8bc1e247cdf1a 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2199,6 +2199,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_SET_IFACE_FIRST),
 	DEVICE_FLG(0x0556, 0x0014, /* Phoenix Audio TMX320VC */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x0572, 0x1b09, /* Conexant Systems (Rockwell), Inc. */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x05a3, 0x9420, /* ELP HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x05a7, 0x1020, /* Bose Companion 5 */
@@ -2245,8 +2247,10 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0c45, 0x636b, /* Microdia JP001 USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
-	DEVICE_FLG(0x0d8c, 0x0014, /* USB Audio Device */
-		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x0d8c, 0x000c, /* C-Media */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
+	DEVICE_FLG(0x0d8c, 0x0014, /* C-Media */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
@@ -2293,6 +2297,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
+	DEVICE_FLG(0x19f7, 0x0003, /* RODE NT-USB */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
@@ -2353,6 +2359,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
+	DEVICE_FLG(0x2d99, 0x0026, /* HECATE G2 GAMING HEADSET */
+		   QUIRK_FLAG_MIXER_MIN_MUTE),
 	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 158ec053dc44d..1ef4d39978df3 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -196,6 +196,9 @@ extern bool snd_usb_skip_validation;
  *  for the given endpoint.
  * QUIRK_FLAG_MIC_RES_16 and QUIRK_FLAG_MIC_RES_384
  *  Set the fixed resolution for Mic Capture Volume (mostly for webcams)
+ * QUIRK_FLAG_MIXER_MIN_MUTE
+ *  Set minimum volume control value as mute for devices where the lowest
+ *  playback value represents muted state instead of minimum audible volume
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -222,5 +225,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_FIXED_RATE		(1U << 21)
 #define QUIRK_FLAG_MIC_RES_16		(1U << 22)
 #define QUIRK_FLAG_MIC_RES_384		(1U << 23)
+#define QUIRK_FLAG_MIXER_MIN_MUTE	(1U << 24)
 
 #endif /* __USBAUDIO_H */
-- 
2.51.0



