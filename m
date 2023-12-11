Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D3FE548;
	Mon, 11 Dec 2023 18:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0171J4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B416C433C8;
	Mon, 11 Dec 2023 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321014;
	bh=eoKRJOZlbCiDQeZ2naPXjEu8LkZ3bx6om3/mey7i83I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0171J4iyMUrRzS5f0sZ9hbxThTJMAA3yvIw3QOD0qqa9qqAMkYphh/4e13I2W+WY
	 gQbJ47CuYlSSzJldGzNdShazypHC0pg5/1m7+XNNxL1yMQ9pPLOsbM1AUD8N3mccUp
	 zlOvOALL8x9F5N8BitJHMPJTW/4u6uwmmuYwC+Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sarah Grant <s@srd.tw>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 079/141] ALSA: usb-audio: Add Pioneer DJM-450 mixer controls
Date: Mon, 11 Dec 2023 19:22:18 +0100
Message-ID: <20231211182029.977938827@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Grant <s@srd.tw>

commit bbb8e71965c3737bdc691afd803a34bfd61cfbeb upstream.

These values mirror those of the Pioneer DJM-250MK2 as the channel layout
appears identical based on my observations. This duplication could be removed in
later contributions if desired.

Signed-off-by: Sarah Grant <s@srd.tw>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231201181654.5058-1-s@srd.tw
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -2796,6 +2796,7 @@ static int snd_bbfpro_controls_create(st
 #define SND_DJM_850_IDX		0x2
 #define SND_DJM_900NXS2_IDX	0x3
 #define SND_DJM_750MK2_IDX	0x4
+#define SND_DJM_450_IDX		0x5
 
 
 #define SND_DJM_CTL(_name, suffix, _default_value, _windex) { \
@@ -2926,6 +2927,31 @@ static const struct snd_djm_ctl snd_djm_
 };
 
 
+// DJM-450
+static const u16 snd_djm_opts_450_cap1[] = {
+	0x0103, 0x0100, 0x0106, 0x0107, 0x0108, 0x0109, 0x010d, 0x010a };
+
+static const u16 snd_djm_opts_450_cap2[] = {
+	0x0203, 0x0200, 0x0206, 0x0207, 0x0208, 0x0209, 0x020d, 0x020a };
+
+static const u16 snd_djm_opts_450_cap3[] = {
+	0x030a, 0x0311, 0x0312, 0x0307, 0x0308, 0x0309, 0x030d };
+
+static const u16 snd_djm_opts_450_pb1[] = { 0x0100, 0x0101, 0x0104 };
+static const u16 snd_djm_opts_450_pb2[] = { 0x0200, 0x0201, 0x0204 };
+static const u16 snd_djm_opts_450_pb3[] = { 0x0300, 0x0301, 0x0304 };
+
+static const struct snd_djm_ctl snd_djm_ctls_450[] = {
+	SND_DJM_CTL("Capture Level", cap_level, 0, SND_DJM_WINDEX_CAPLVL),
+	SND_DJM_CTL("Ch1 Input",   450_cap1, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch2 Input",   450_cap2, 2, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch3 Input",   450_cap3, 0, SND_DJM_WINDEX_CAP),
+	SND_DJM_CTL("Ch1 Output",   450_pb1, 0, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch2 Output",   450_pb2, 1, SND_DJM_WINDEX_PB),
+	SND_DJM_CTL("Ch3 Output",   450_pb3, 2, SND_DJM_WINDEX_PB)
+};
+
+
 // DJM-750
 static const u16 snd_djm_opts_750_cap1[] = {
 	0x0101, 0x0103, 0x0106, 0x0107, 0x0108, 0x0109, 0x010a, 0x010f };
@@ -3021,6 +3047,7 @@ static const struct snd_djm_device snd_d
 	[SND_DJM_850_IDX] = SND_DJM_DEVICE(850),
 	[SND_DJM_900NXS2_IDX] = SND_DJM_DEVICE(900nxs2),
 	[SND_DJM_750MK2_IDX] = SND_DJM_DEVICE(750mk2),
+	[SND_DJM_450_IDX] = SND_DJM_DEVICE(450),
 };
 
 
@@ -3263,6 +3290,9 @@ int snd_usb_mixer_apply_create_quirk(str
 	case USB_ID(0x2b73, 0x0017): /* Pioneer DJ DJM-250MK2 */
 		err = snd_djm_controls_create(mixer, SND_DJM_250MK2_IDX);
 		break;
+	case USB_ID(0x2b73, 0x0013): /* Pioneer DJ DJM-450 */
+		err = snd_djm_controls_create(mixer, SND_DJM_450_IDX);
+		break;
 	case USB_ID(0x08e4, 0x017f): /* Pioneer DJ DJM-750 */
 		err = snd_djm_controls_create(mixer, SND_DJM_750_IDX);
 		break;


