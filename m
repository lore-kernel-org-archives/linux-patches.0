Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047278;
	b=x6gNDzcyEF0+FdMyplEcDXWc0HoZJ20Qrn9h6YeR8BkBgl+dB+URkANC/+LmyxZo4J2n
	 uMtgeKJjuowk/Wc3UFFFJYzXxMCjFsrhA/g+l5VM7SBbhkmrO9inPNC2t4TCqU0b/Px5/
	 mZGsCSs0kcs1mj5enA0fAhTysI3N1xL8WoSUmtqI0eV+Af+cdmvPBsBNzAmbYsAYP01YM
	 OtC6bTN3cBvjQ09iaC+wwVh2sPLNF1w0Sj4L/xADNNifojSO5UUdBGIWf1P5mxZsK3joM
	 0hBwiwln8VWsrZS1YFXEwGm4WTYgwLBuvaPCZzLdrOKfomVLUm9vJ5QGdtBFGc1Mmbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EsV2Gp9wqBw5rbW94JNMtN/IocH+EjrvRMEe9E1qM8o=;
	b=eIyr85heZDjhPERupp3jO6/gRdGyeL6psgOja/LBMXztWvmCYkdXLON7eZWjvJ4GpgTf
	 7eS1zwsWGyjwEkqVthWyXvzll3XhaYz+pVmu6BdOPnzHtlGv3fTORZ/kGgc6cOy/DBpPa
	 vbwv/VRNnDMckaGhRMGkLgJrfFWg7c/CYzPBpxr95BrU6Q7zqStzP9T4kVpBQk0GdYM4E
	 DxTiLLovNjD2hECp0FF5uRdF2MHd+xHdhBFiI1S2VfZmuYGMk39+4E6Ni/FDgBV+XDYWN
	 wrdgt+dkLJ/DjVVcpaELqQvsvVG5+zKAGLDoqjivkbrObK1kxT18xFwsz2wSTj6fWVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quOq5CVI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBAD606A31C;
	Thu, 19 Nov 2026 00:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quOq5CVI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D7A1F000C4;
	Thu, 19 Nov 2026 00:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047278;
	bh=EsV2Gp9wqBw5rbW94JNMtN/IocH+EjrvRMEe9E1qM8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quOq5CVIUb+11gqJtSTXJsrSDJ3oIz1mAIGgiqeyTrV/xJFD3/2hf+iWblpKlUTF4
	 L//87hi1BtkdSaUeKWKIoQD5EYSvybqXta+pCdLeRhVStwnXT6zVhu4YdPV9iKRqjL
	 ji1a1VO7G+1dIDJlL7GC7ztB+HYcN2DH/5Kmr7dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1581/2857] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Wed, 18 Nov 2026 15:43:35 +0100
Message-ID: <20261118150258.300985046@linuxfoundation.org>
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

From: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>

[ Upstream commit 874323b68c93c6808e034dc0113681e822e6fb42 ]

The C200 (046d:0802) reports a mic capture volume range of
1536..7680 with a resolution of 1 (6144 steps), triggering
"Warning! Unlikely big volume step count (=6144), linear volume or
wrong cval->res?" at probe and exposing a uselessly fine-grained
mixer control.  This is the same firmware behavior as the other
UVC-era Logitech webcams already carrying QUIRK_FLAG_MIC_RES_384
(C500, C600, C210, C270, C310, C510, C525, ...), so apply the same
quirk: CTL_MSG_DELAY_1M (which the Logitech VENDOR_FLG would provide
if the device-specific entry did not short-circuit the lookup) plus
MIC_RES_384.

Verified on real hardware: with the quirk the warning disappears and
the driver logs "set resolution quirk: cval->res = 384".

Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261008230844.11246-1-olivier.kaloudoff@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 52164ae35250c..45a2753d483cf 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2058,6 +2058,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_DISABLE_AUTOSUSPEND),
 	DEVICE_FLG(0x045e, 0x070f, /* MS LifeChat LX-3000 Headset */
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x046d, 0x0802, /* Logitech Webcam C200 */
+		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0807, /* Logitech Webcam C500 */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M | QUIRK_FLAG_MIC_RES_384),
 	DEVICE_FLG(0x046d, 0x0808, /* Logitech Webcam C600 */
-- 
2.53.0



