Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063236;
	b=YeQfYO2qrklNawWh2LCh98rReQcD6Ewh5jLMXh0A29x3N2M8Ln5kG94OqwVdr1lEk1Ct
	 NeFPEez4KRBHdJzeTsub8lYt6VaOthFVbCjbhS01NNBUshDtTrnHtxMQzZYh4qAwwM/oU
	 rFUCpbMV2tCzuSGoQeeCD3jPVfiZ7rpjFX5fcZrki36az3lofwcEFW0UZnK69F9NKUwYy
	 ZjOwd1w/1p+YoVlR7A2G+zPRxFlsneLVv5V1FO4PmQsc55s47QGl9Wi8JzwgN0Ipdheny
	 y7aX9B6A9bv+z5yCQSpu4Jz+LOX+LMbS8MGKiaBb1cWDxr7XHDHeSTvXEN2ogShBaiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C4D3MpxMF6whqhCTuMXkAGSuquJvQHZ4tpoEeJsG19s=;
	b=yp8v0rGJoMQrRKYa9Unh5SDclYaUIlnEtiQBxhCCvJZxV0ugawKenDh6zTuw+5OU3tJU
	 IpIKhE7cmm22Pb/Ow+BytfAfsHfDzDKcHb0Tf6R7L1wGyCyBrylUYDARNTGWW0x4+hHE8
	 r1UnEwQZKa1W9WHV6ihqd5eQhhQAYzY5YMCAX9gaWbej2z+diAjPJrhMxFy4Viz7GFWJm
	 6xpHeoxQMHEw3rndMpxLIsdxDZ2TrEHPgc0trpHSrDd5dD6iUi2/BvA6ciRIsgUzJOCEN
	 IFbpGtPFxudaGUoeAHThftDzyAwb/qeOQOKxtJsX5nlBHZQcuwdzRcT1Ig+tWBfirew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wA6dWQM/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D41606A333;
	Sat,  7 Nov 2026 14:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wA6dWQM/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE401F008A1;
	Sat,  7 Nov 2026 14:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063236;
	bh=C4D3MpxMF6whqhCTuMXkAGSuquJvQHZ4tpoEeJsG19s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wA6dWQM/jmlm4+2VrfyOEq0+r3sPTUqG98jPembDobUky1T14aoFRCe5+QwHsZrv6
	 pJ00tpu7+L0xbEHqaxoMOW/PKbk78CQh0bLdpIFReYnSL0cIhN+TcOBK1yPBVhgCkV
	 Wk/mmwgmIuDClUWUFagY8XKIIvY2eVDD0aoil8DE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Kaloudoff <olivier.kaloudoff@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 443/869] ALSA: usb-audio: Add mic resolution quirk for Logitech Webcam C200
Date: Sat,  7 Nov 2026 08:52:05 -0500
Message-ID: <20261107134908.777101091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index be80d9d14e0ad..01a5564eda7af 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2161,6 +2161,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



