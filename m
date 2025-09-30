Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F139A1F152D;
	Tue, 30 Sep 2025 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244480; cv=none; b=bOytXyxvsWI7S9KFZyN4zdN1I93rkupA/iCu5WT56tEZZM+INl4TbVLTus/KZ9jjJBGXIrncbJ/7ileTrFcvc1R+IdHC5q2Czcn3PyRPU8kBmeOaWwfh9Co/Oi11aGBjelgMmT5HqF8CuCyromTmdkjOOg7vkIcS1YqeYZRmGGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244480; c=relaxed/simple;
	bh=TtrLwmtEfGsrvHTtO/oZGV2Grw4U/T1oNRKWoprD0Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzU8PJq1yAtwfC/4gUl4/de1Gr2iPs/LH6e6Q9Phzp/xgi7Csxa6+KI+VMJjQ+U0K+YYtTL0JviitpGpniFfBJp0sUVSoMuj0qG7h3yChJiF1CGTPwyvNTDFzI0Mrlxq+Tx+8Ml29J7vGsUYyobqwcXSgZO2ujgP9U6Yiwo1kvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fELAYgP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fELAYgP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6D0C4CEF0;
	Tue, 30 Sep 2025 15:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244479;
	bh=TtrLwmtEfGsrvHTtO/oZGV2Grw4U/T1oNRKWoprD0Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fELAYgP5CNAtiBsiVHVhjJc0+k6mlzqgxwmYnbmINNRLOiK0gPyu999NDTA8yF1i7
	 gS6bu+S5kab/u2yeoO/n6lAGAzne0GrFEXjFhM48/4pytQou6E1XaK656ApfDO7+Pt
	 EHi4sIFYV08fxJEWR7ZrzjWCfo4VlDWZGLq/ukZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 004/143] ALSA: usb-audio: Fix whitespace & blank line issues in mixer_quirks
Date: Tue, 30 Sep 2025 16:45:28 +0200
Message-ID: <20250930143831.418659684@linuxfoundation.org>
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

[ Upstream commit df6b4dcf2e2c3b4e34c3213a575c92d0c9415d0d ]

Address all whitespace & blank line(s) related issues reported by
checkpatch.pl:

  ERROR: trailing whitespace
  ERROR: space required after that ',' (ctx:VxV)
  WARNING: Missing a blank line after declarations
  CHECK: Please use a blank line after function/struct/union/enum declarations
  CHECK: Please don't use multiple blank lines

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250526-dualsense-alsa-jack-v1-2-1a821463b632@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer_quirks.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index 7f1e7a5fe8f0a..0aad92cb33276 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -287,7 +287,7 @@ static int snd_usb_soundblaster_remote_init(struct usb_mixer_interface *mixer)
 	mixer->rc_setup_packet->wLength = cpu_to_le16(len);
 	usb_fill_control_urb(mixer->rc_urb, mixer->chip->dev,
 			     usb_rcvctrlpipe(mixer->chip->dev, 0),
-			     (u8*)mixer->rc_setup_packet, mixer->rc_buffer, len,
+			     (u8 *)mixer->rc_setup_packet, mixer->rc_buffer, len,
 			     snd_usb_soundblaster_remote_complete, mixer);
 	return 0;
 }
@@ -389,7 +389,7 @@ static int snd_audigy2nx_controls_create(struct usb_mixer_interface *mixer)
 			 mixer->chip->usb_id == USB_ID(0x041e, 0x3042) ||
 			 mixer->chip->usb_id == USB_ID(0x041e, 0x30df) ||
 			 mixer->chip->usb_id == USB_ID(0x041e, 0x3048)))
-			break; 
+			break;
 
 		knew = snd_audigy2nx_control;
 		knew.name = snd_audigy2nx_led_names[i];
@@ -858,6 +858,7 @@ static const struct snd_kcontrol_new snd_mbox1_src_switch = {
 static int snd_mbox1_controls_create(struct usb_mixer_interface *mixer)
 {
 	int err;
+
 	err = add_single_ctl_with_resume(mixer, 0,
 					 snd_mbox1_clk_switch_resume,
 					 &snd_mbox1_clk_switch, NULL);
@@ -871,7 +872,7 @@ static int snd_mbox1_controls_create(struct usb_mixer_interface *mixer)
 
 /* Native Instruments device quirks */
 
-#define _MAKE_NI_CONTROL(bRequest,wIndex) ((bRequest) << 16 | (wIndex))
+#define _MAKE_NI_CONTROL(bRequest, wIndex) ((bRequest) << 16 | (wIndex))
 
 static int snd_ni_control_init_val(struct usb_mixer_interface *mixer,
 				   struct snd_kcontrol *kctl)
@@ -2183,6 +2184,7 @@ static const u32 snd_rme_rate_table[] = {
 	256000,	352800, 384000, 400000,
 	512000, 705600, 768000, 800000
 };
+
 /* maximum number of items for AES and S/PDIF rates for above table */
 #define SND_RME_RATE_IDX_AES_SPDIF_NUM		12
 
@@ -3271,7 +3273,6 @@ static int snd_rme_digiface_sync_state_get(struct snd_kcontrol *kcontrol,
 	return 0;
 }
 
-
 static int snd_rme_digiface_format_info(struct snd_kcontrol *kcontrol,
 					struct snd_ctl_elem_info *uinfo)
 {
@@ -3283,7 +3284,6 @@ static int snd_rme_digiface_format_info(struct snd_kcontrol *kcontrol,
 				 ARRAY_SIZE(format), format);
 }
 
-
 static int snd_rme_digiface_sync_source_info(struct snd_kcontrol *kcontrol,
 					     struct snd_ctl_elem_info *uinfo)
 {
@@ -3566,7 +3566,6 @@ static int snd_rme_digiface_controls_create(struct usb_mixer_interface *mixer)
 #define SND_DJM_A9_IDX		0x6
 #define SND_DJM_V10_IDX	0x7
 
-
 #define SND_DJM_CTL(_name, suffix, _default_value, _windex) { \
 	.name = _name, \
 	.options = snd_djm_opts_##suffix, \
@@ -3578,7 +3577,6 @@ static int snd_rme_digiface_controls_create(struct usb_mixer_interface *mixer)
 	.controls = snd_djm_ctls_##suffix, \
 	.ncontrols = ARRAY_SIZE(snd_djm_ctls_##suffix) }
 
-
 struct snd_djm_device {
 	const char *name;
 	const struct snd_djm_ctl *controls;
@@ -3724,7 +3722,6 @@ static const struct snd_djm_ctl snd_djm_ctls_250mk2[] = {
 	SND_DJM_CTL("Output 3 Playback Switch", 250mk2_pb3, 2, SND_DJM_WINDEX_PB)
 };
 
-
 // DJM-450
 static const u16 snd_djm_opts_450_cap1[] = {
 	0x0103, 0x0100, 0x0106, 0x0107, 0x0108, 0x0109, 0x010d, 0x010a };
@@ -3749,7 +3746,6 @@ static const struct snd_djm_ctl snd_djm_ctls_450[] = {
 	SND_DJM_CTL("Output 3 Playback Switch", 450_pb3, 2, SND_DJM_WINDEX_PB)
 };
 
-
 // DJM-750
 static const u16 snd_djm_opts_750_cap1[] = {
 	0x0101, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a, 0x010f };
@@ -3768,7 +3764,6 @@ static const struct snd_djm_ctl snd_djm_ctls_750[] = {
 	SND_DJM_CTL("Input 4 Capture Switch", 750_cap4, 0, SND_DJM_WINDEX_CAP)
 };
 
-
 // DJM-850
 static const u16 snd_djm_opts_850_cap1[] = {
 	0x0100, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a, 0x010f };
@@ -3787,7 +3782,6 @@ static const struct snd_djm_ctl snd_djm_ctls_850[] = {
 	SND_DJM_CTL("Input 4 Capture Switch", 850_cap4, 1, SND_DJM_WINDEX_CAP)
 };
 
-
 // DJM-900NXS2
 static const u16 snd_djm_opts_900nxs2_cap1[] = {
 	0x0100, 0x0102, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a };
@@ -3825,7 +3819,6 @@ static const u16 snd_djm_opts_750mk2_pb1[] = { 0x0100, 0x0101, 0x0104 };
 static const u16 snd_djm_opts_750mk2_pb2[] = { 0x0200, 0x0201, 0x0204 };
 static const u16 snd_djm_opts_750mk2_pb3[] = { 0x0300, 0x0301, 0x0304 };
 
-
 static const struct snd_djm_ctl snd_djm_ctls_750mk2[] = {
 	SND_DJM_CTL("Master Input Level Capture Switch", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
 	SND_DJM_CTL("Input 1 Capture Switch",   750mk2_cap1, 2, SND_DJM_WINDEX_CAP),
@@ -3838,7 +3831,6 @@ static const struct snd_djm_ctl snd_djm_ctls_750mk2[] = {
 	SND_DJM_CTL("Output 3 Playback Switch", 750mk2_pb3, 2, SND_DJM_WINDEX_PB)
 };
 
-
 // DJM-A9
 static const u16 snd_djm_opts_a9_cap_level[] = {
 	0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500 };
@@ -3867,29 +3859,35 @@ static const struct snd_djm_ctl snd_djm_ctls_a9[] = {
 static const u16 snd_djm_opts_v10_cap_level[] = {
 	0x0000, 0x0100, 0x0200, 0x0300, 0x0400, 0x0500
 };
+
 static const u16 snd_djm_opts_v10_cap1[] = {
 	0x0103,
 	0x0100, 0x0102, 0x0106, 0x0110, 0x0107,
 	0x0108, 0x0109, 0x010a, 0x0121, 0x0122
 };
+
 static const u16 snd_djm_opts_v10_cap2[] = {
 	0x0200, 0x0202, 0x0206, 0x0210, 0x0207,
 	0x0208, 0x0209, 0x020a, 0x0221, 0x0222
 };
+
 static const u16 snd_djm_opts_v10_cap3[] = {
 	0x0303,
 	0x0300, 0x0302, 0x0306, 0x0310, 0x0307,
 	0x0308, 0x0309, 0x030a, 0x0321, 0x0322
 };
+
 static const u16 snd_djm_opts_v10_cap4[] = {
 	0x0403,
 	0x0400, 0x0402, 0x0406, 0x0410, 0x0407,
 	0x0408, 0x0409, 0x040a, 0x0421, 0x0422
 };
+
 static const u16 snd_djm_opts_v10_cap5[] = {
 	0x0500, 0x0502, 0x0506, 0x0510, 0x0507,
 	0x0508, 0x0509, 0x050a, 0x0521, 0x0522
 };
+
 static const u16 snd_djm_opts_v10_cap6[] = {
 	0x0603,
 	0x0600, 0x0602, 0x0606, 0x0610, 0x0607,
@@ -3918,7 +3916,6 @@ static const struct snd_djm_device snd_djm_devices[] = {
 	[SND_DJM_V10_IDX] = SND_DJM_DEVICE(v10),
 };
 
-
 static int snd_djm_controls_info(struct snd_kcontrol *kctl,
 				 struct snd_ctl_elem_info *info)
 {
@@ -4358,4 +4355,3 @@ void snd_usb_mixer_fu_apply_quirk(struct usb_mixer_interface *mixer,
 	    (cval->control == UAC_FU_MUTE || cval->control == UAC_FU_VOLUME))
 		snd_fix_plt_name(mixer->chip, &kctl->id);
 }
-
-- 
2.51.0



