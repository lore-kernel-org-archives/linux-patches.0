Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591635;
	b=bJiuMDRTiuS2i7Z6bapXBpuEX9cNcyB9PaML2HOP3/63fjGSFXdIWo08JXCawXVtobF3
	 hJIYDMFqGGfJ1NCWlBdbAQ0ymMymoVsJ0oQHcOxd5ipSllvO7/2Cv/OuVaMLuIbkOqLr2
	 yVf4LNV4OGbEzRV+J16S0TIAoaiTDxjjf1zOrqKBpDv/YKH1Z+mu5k7KRJ/5Bit3C38O5
	 BOzSQGCfAHtTpbpQjuOJR0AtRdzlniBDWqpC6oCNEa/Ij3Kbqooe79XAftP98NxgGvi/H
	 VV6bXm+jbnChlBe4+NRNRIdJx2BwmoRdAlJ/i7sfTnXVcaWGAtrvkMcYqDX389HEc3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6vMEZQ2cHkP3/Ax8L5F9zIgeVUw/0iJoMBc9l01holw=;
	b=2p89SziGmnxbdS8NQzPT8XcqPHSMsP+Jke/8pxtGj4TFuZr2K4gKG6KydLxv6Asf/QAe
	 YUmKneVL0XngtKN7sGhHjCn2GXymiJSAy35GgYGVoDJfKw7PzEncKYtlOHe/edGfQqMIK
	 L9d88RsjXxf1d6T+RnGW0o8oUKKcGHhAiRLc1n0y/u9rqryGTj4fkRC9Yr59SVhFskTJO
	 zIt6nNjp6fEvHy+DRAKp4PntmVUaFSmABxtL2iZ9+wlROVXo8Lbu7YezEBP0ZKDq54ARL
	 ODFlKdikLp7icfyXIuE+D+RQ6em9Y1ZeW6LZYIRJM76enW0sdX8fvebfBxlkRLpWOEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDQiqzMa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAA1606F71D;
	Fri, 13 Nov 2026 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GDQiqzMa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4E31F000C4;
	Fri, 13 Nov 2026 17:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591635;
	bh=6vMEZQ2cHkP3/Ax8L5F9zIgeVUw/0iJoMBc9l01holw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GDQiqzManR8lThOxurwdptZ8LpJcwpF8C8Qg9t5c19wOxUgo1MFEoyfTHI7j4ruxq
	 70oQ+oRuZ//u68vuUckE7gk6P8EM52lWy98dO6zAuS5rG0a3n6t4FRsetRkTtmpIrJ
	 paSO0dPlwgwYTtJqLZ23biITPg4i1cWAX5NAe/ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 654/670] ALSA: usb-audio: add volume quirks for MS LifeChat LX-3000
Date: Fri, 13 Nov 2026 10:53:38 -0500
Message-ID: <20261113153834.074184387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 82c8596264047..45145ef7db7c5 100644
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
index 70026525972b0..cfcf9f845ee36 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2158,6 +2158,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



