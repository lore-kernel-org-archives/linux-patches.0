Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038818;
	b=QP27dp3UV6Jf8gWk5I9AXcV2Qe65itI4v8sbgW4H0WguwwpLLYe5pqYttp/g2ekVNA2b
	 UA3VhvVv+b5LV0sfrj/hj72a9vtRcXnLSivwETvTclpZRRBVuIFYKjxmYagHTBFm6MT5y
	 Tv5vAVhY1S/somLjFqnI5VWCd8NnNdwp8u/R1Q/3ewIzmk61sFVGEt6lnVpbgnvtU67Jw
	 EgfHBn692hJCyA0WbKTjZswRywOtty0nCVEZRe/80wBhRAlGMrjU/xe6xrKnJy5CrxHw1
	 gpBtU0KGXsSNX11kdRESa/hwTMjTGyg7Q2BoAjCPs0AbBQlDTK0+JFSTRQ/YHdoVi1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uXxPI1xBrmLX7p6Xsc0eRzhmYhZz8fxS2h+5N/ulsjA=;
	b=oCoXpi8LCVGdc+oP4/MFwJdlcmeo9C1aJpGecRpvcwIVwqqFxKy8nfm517MrRrN9Qnyu
	 mv44OknQNPqWQgW2e1+WniV+LBUUfQ7lhZGuxptyW92AqlUjpXDils9oNeL/voShQh6UF
	 DGYe+vSQa1s96rerJaUclt4E5zy67DPucjfT0KRgYzGmT81kZbWVYXj5smd/jh0vzFHQ+
	 TVsSXhd/tI8+85nGufs+OX3md/Sw1bgetHdC18MaxSY403ATNMV58yCflyK5eE1mGfvLK
	 sjU2s3S8XvHnrAC4eXcXFa3Fb5O0rFv1IGA09gI5pxUXStFZ9sLavyaMFgVFcPdaK+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ym3U5qrI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604EF606A335;
	Wed, 18 Nov 2026 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ym3U5qrI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CAB1F000C4;
	Wed, 18 Nov 2026 21:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038818;
	bh=uXxPI1xBrmLX7p6Xsc0eRzhmYhZz8fxS2h+5N/ulsjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ym3U5qrIYbQzomZJRmbTr1EljQ8/tZV2lAeFvJ/PcXMHqZTBZ1d/dR6SD+A1f/IEZ
	 Uq/TqNZizBhSknUAC/JyfTPCScnhZngix3HUWvfurvubOVjEhhAmOQUl2ELWjFrh+s
	 TUbSDtw5kIQkH+bcbrL3gDCMkm96OeWedO/DX8O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1826/3318] ALSA: usb-audio: add volume quirks for MS LifeChat LX-3000
Date: Wed, 18 Nov 2026 15:40:48 +0100
Message-ID: <20261118150416.644886511@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 9af61fc91486c7ba93cf1ec3bd381978cac8308c ]

ID 045e:070f Microsoft Corp. LifeChat LX-3000 Headset
has muted minimum Speaker Playback Volume, and 4 amixer steps were
observed to produce 1 actual volume step.

Apply min_mute quirk and correct res=48 -> 4*48.
Tested with the device.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 874323b68c93 ("ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c  | 8 ++++++++
 sound/usb/quirks.c | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index 0a729ec282179..e70853cfec65a 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1156,6 +1156,14 @@ static void volume_control_quirks(struct usb_mixer_elem_info *cval,
 		}
 		break;
 
+	case USB_ID(0x045e, 0x070f): /* MS LifeChat LX-3000 Headset */
+		if (!strcmp(kctl->id.name, "Speaker Playback Volume")) {
+			usb_audio_info(chip,
+				"set volume quirk for MS LifeChat LX-3000\n");
+			cval->res = 192;
+		}
+		break;
+
 	case USB_ID(0x0471, 0x0101):
 	case USB_ID(0x0471, 0x0104):
 	case USB_ID(0x0471, 0x0105):
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 6f999315cca1c..302736f271932 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2058,6 +2058,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x045e, 0x083c, /* MS USB Link headset */
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_CTL_MSG_DELAY |
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
+	DEVICE_FLG(0x045e, 0x070f, /* MS LifeChat LX-3000 Headset */
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x046d, 0x0807, /* Logitech Webcam C500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0808, /* Logitech Webcam C600 */
-- 
2.53.0



