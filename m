Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038674;
	b=QU/T6tq5F6vQNVy811MNnMzxvWXkb6Z8tRjmhJcu/eg/5dI+dNmSzWFfXnFK9jAR0iHc
	 wkdl8Xvck126u1K9mAXml/BvzS5V2pVwbctq9FD3q3y6oYCfVU3O/3K4nR8//DiekKXdD
	 /Rp/0GOTyoMPDd22/+erZ82umo6360NCg8bjR3orr8wvOpcoE3e6xxO43v7/kQDTXiicG
	 QAD+Ah/G+cLsw65w/mXvw8isMhca+JY4nnJc7gVZZoAr8tIWXJs7ZV5s0+ycPZwOJ1P//
	 9Y7rGs6LHhdhd+gAXATQZtX9CgU0aoI5Ms0nrS5sMU4N7p4432UmrsWHLvsC1im5x9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sz8aUU5862UoKBvB0kTexONkpeTZBpxkhInZqDufDFI=;
	b=b20IZcjRqlSJof/Lo3qNdBGCiwsJBQglSflja8WXS6iend66wuCWZwfMYzZwrenjc4+9
	 fYSnRMG/ULbmOchpAwFwuUvSTLVnTykRcjV/gAzGYx9E9LurmMTFLFKI0Gr4hB2ahbi0W
	 R8rJIhbpuRkdeSaOgbrne5PF34FvTobiw1a/9sFgD81aShbEAXJFHvBGcNqn/RQVjB4wl
	 Okb4G8Avh0rOWSSpf8DsEvRufq20MF1IbrnonoVyG+n+74yItevGU35UKTCYc2bBJsWTy
	 cduRrdrK/Lq1TNYconMU4SfCUEKAsG45oDPM0OZUzkCRI2DXmf79m/Rbb3gwEK9Zt1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwnWAOIV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E965606A320;
	Wed, 18 Nov 2026 21:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JwnWAOIV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE6F1F000C4;
	Wed, 18 Nov 2026 21:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038674;
	bh=Sz8aUU5862UoKBvB0kTexONkpeTZBpxkhInZqDufDFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JwnWAOIVdO/5g6QNX52LDtPDiX5ABEV1GTtlXu3jxGVmpiFDziqshU3w54PG16Ulz
	 X1BYrWdVAJnbgPsynjVg67LZjgyl8PL6I+mmm0gXZI1gblz710qzRLiwFeuGDEWPOI
	 4SEvL43undw8+eVZaSCt8S8Uq5jsPcUd1L829XRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cryolitia PukNgae <cryolitia@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1825/3318] ALSA: usb-audio: rename QUIRK_FLAG_MIXER_MIN_MUTE to QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE
Date: Wed, 18 Nov 2026 15:40:47 +0100
Message-ID: <20261118150416.615219599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia@uniontech.com>

[ Upstream commit ace1817ab49b3f92b3e965caa63b4a78e69266cd ]

As a preparation of introduction QUIRK_FLAG_MIXER_CAPTURE_MIN_MUTE

Also make it printing an info while applying

Signed-off-by: Cryolitia PukNgae <cryolitia@uniontech.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250903-sound-v1-1-d4ca777b8512@uniontech.com
Stable-dep-of: 874323b68c93 ("ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c |  7 +++++--
 sound/usb/quirks.c       | 20 ++++++++++----------
 sound/usb/usbaudio.h     |  4 ++--
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 90de8ae32eb62..e3fda32bac1cb 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3921,9 +3921,12 @@ void snd_usb_mixer_fu_apply_quirk(struct usb_mixer_interface *mixer,
 	}
 
 	/* lowest playback value is muted on some devices */
-	if (mixer->chip->quirk_flags & QUIRK_FLAG_MIXER_MIN_MUTE)
-		if (strstr(kctl->id.name, "Playback"))
+	if (mixer->chip->quirk_flags & QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE)
+		if (strstr(kctl->id.name, "Playback")) {
+			usb_audio_info(mixer->chip,
+				       "applying playback min mute quirk\n");
 			cval->min_mute = 1;
+		}
 
 	/* ALSA-ify some Plantronics headset control names */
 	if (USB_ID_VENDOR(mixer->chip->usb_id) == 0x047f &&
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 5ae20ef3c6232..6f999315cca1c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2102,9 +2102,9 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x0556, 0x0014, /* Phoenix Audio TMX320VC */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0572, 0x1b08, /* Conexant Systems (Rockwell), Inc. */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0572, 0x1b09, /* Conexant Systems (Rockwell), Inc. */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x05a3, 0x9420, /* ELP HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x05a7, 0x1020, /* Bose Companion 5 */
@@ -2154,15 +2154,15 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x0b0e, 0x0349, /* Jabra 550a */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x0bda, 0x498a, /* Realtek Semiconductor Corp. */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0c45, 0x6340, /* Sonix HD USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0c45, 0x636b, /* Microdia JP001 USB Camera */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x0d8c, 0x000c, /* C-Media */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0d8c, 0x0014, /* C-Media */
-		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2125, /* JBL Quantum650 Wireless */
@@ -2174,7 +2174,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x1101, 0x0003, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x12d1, 0x3a07, /* Huawei Technologies Co., Ltd. */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x1224, 0x2a25, /* Jieli Technology USB PHY 2.0 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x1395, 0x740a, /* Sennheiser DECT */
@@ -2220,7 +2220,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x1901, 0x0191, /* GE B850V3 CP2114 audio interface */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x19f7, 0x0003, /* RODE NT-USB */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x19f7, 0x0035, /* RODE NT-USB+ */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x1bcf, 0x2281, /* HD Webcam */
@@ -2278,7 +2278,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x2912, 0x30c8, /* Audioengine D1 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x2a70, 0x1881, /* OnePlus Technology (Shenzhen) Co., Ltd. BE02T */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x2b53, 0x0023, /* Fiero SC-01 (firmware v1.0.0 @ 48 kHz) */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x2b53, 0x0024, /* Fiero SC-01 (firmware v1.0.0 @ 96 kHz) */
@@ -2290,7 +2290,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x2d95, 0x8021, /* VIVO USB-C-XE710 HEADSET */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x2d99, 0x0026, /* HECATE G2 GAMING HEADSET */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x2fc6, 0xf0b7, /* iBasso DC07 Pro */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M),
 	DEVICE_FLG(0x30be, 0x0101, /* Schiit Hel */
@@ -2298,7 +2298,7 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x3255, 0x0000, /* Luxman D-10X */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x339b, 0x3a07, /* Synaptics HONOR USB-C HEADSET */
-		   QUIRK_FLAG_MIXER_MIN_MUTE),
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x413c, 0xa506, /* Dell AE515 sound bar */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x534d, 0x0021, /* MacroSilicon MS2100/MS2106 */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 3c927316bc992..b1ac6e727dc9a 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -184,7 +184,7 @@ extern bool snd_usb_skip_validation;
  *  for the given endpoint.
  * QUIRK_FLAG_MIC_RES_16 and QUIRK_FLAG_MIC_RES_384
  *  Set the fixed resolution for Mic Capture Volume (mostly for webcams)
- * QUIRK_FLAG_MIXER_MIN_MUTE
+ * QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE
  *  Set minimum volume control value as mute for devices where the lowest
  *  playback value represents muted state instead of minimum audible volume
  */
@@ -213,6 +213,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_FIXED_RATE		(1U << 21)
 #define QUIRK_FLAG_MIC_RES_16		(1U << 22)
 #define QUIRK_FLAG_MIC_RES_384		(1U << 23)
-#define QUIRK_FLAG_MIXER_MIN_MUTE	(1U << 24)
+#define QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE	(1U << 24)
 
 #endif /* __USBAUDIO_H */
-- 
2.53.0



