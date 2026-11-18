Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047275;
	b=hHZ+1asO0+t52XKsJPAs1zDb5NLHHQ0tahCA9L7wpBcaUz1pHKAunVMpJ+xfQowK/AS0
	 p2T1OL3mfn4Xp5xWObGm38GEtlhAXwfaVTtBr5TxAj7YpLLqMRYvrIgJKWnlCNDRBsxJJ
	 HlLn5iGRQ4tjigtKKmRs38IrGYIbh2TOsLXlWQF4Ia/lmh5c2KUfbuBCQa3A0VhubJQFW
	 5YXN8eRe8E+0srd+BquQnG4H2SLejKzWTKqnOwcjPeKviaccHJvMTKqQUKI++VKkdqLjd
	 m2qFnStdkAw7WA0+LIc1pFsJvXU50SVUX2Owl53k2zmc19rQUk2w2PaYvRWA+Z3Tkzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+pMjtY1t0u3jKYbOvSOD429KxCfkVvX+pKCEkXYXLR8=;
	b=0kC5KYacjsNAL/xfvGoww5l7hwWFqPlceDvIuTg6RYB3MrW3scqu3DVBLVzRRPxJx7cq
	 ATE11AaCRYHG7H7px4oG6hwFRAnY82pO1UGBlWSkGMqXcLpU+xAQOOA+sMj3P5Ei2IcOA
	 8evsMl4lAUSvLVMKmnpvMFXQDokfQdydwnrJeByXiHa1svAp2YsnbgefddUc3rN/y2xzN
	 2GE4OnLdhr9+G++f5lOjOU3rcJls6LMDFZK3bDUUhYuSiE1tHhm4Dc952cuUr/OxGkW7L
	 MQ8jLjf+p80SBKIWIoz6uPDfRb9JUhCeNoEtK7DUNZWfEedJad1axiFEz9hz6SMzIvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnoS0+xc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6A3606A320;
	Thu, 19 Nov 2026 00:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnoS0+xc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40F41F000C4;
	Thu, 19 Nov 2026 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047275;
	bh=+pMjtY1t0u3jKYbOvSOD429KxCfkVvX+pKCEkXYXLR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnoS0+xcCUscHU1WZiJvz16usxfKnzp/A2ZMSGKOScTcUy4PfSiSVrx3OyJYuZOc9
	 AUpkYu3MIUIVJuDfLb9v1M3purty2R10xttKt2k7aRcnp35aaPz9JKiNJU1WcYhaj6
	 gMsOfRqL19/Rh9tqjIPan8od4H2J539761fWjlAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1580/2857] ALSA: usb-audio: add volume quirks for MS LifeChat LX-3000
Date: Wed, 18 Nov 2026 15:43:34 +0100
Message-ID: <20261118150258.265993039@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 45a4a8c7a697d..9d54998634094 100644
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
index 55453873524be..52164ae35250c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2056,6 +2056,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



