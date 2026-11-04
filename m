Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830975;
	b=iev5f26KFpYr5l0mT+6U33hnRFdIEA7tWMxxK3GQw/Yn4qKYBKY75IDsHA4D2BIProT2
	 efJWc2uyq5ju6HOfYDvygiQ0CQoVF45IXWbLs2OV4Sv/aZ1nSP7tQce4wLZvmdxKI4tOg
	 XaPQiIwJAEHBIkzfftJcWdIrOFF9rZvG1o/lTU6r4ahkX7t2gRI4OkhwcARmahm8M8q0H
	 Yqq4HYsPYMaJIBzg6UZr0Zj0ggd2+iXX2Av2KLNmmZ4wy9T+VChmoy+70nl0KTpGxIq4a
	 bE+u5Q/EmjOIO90FXrydEsgg8G7rv9kuSZItroy4z1cMtlZMSs730zXrctQsvoJzZHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jyBCT5b6hjVKlzDyxyKbtjXV0JZh735Es17PZt7GppE=;
	b=fci3vey/0+GqchZFUE9cJSNg6My4rL32bj9k0Ya56tPdYWgZGao3ldTmVT1cz2hQSU1k
	 cjl3H6SldJxtmc0gHYQFJssfZK84fD5b/yuCqhEVs57mNmEhXKOSO0AJY9LuuDvwR/8K7
	 o7hus+A4UwFUW0qM/47dJQs+9EbhLoOp4tQwrZduJL1fORgYxIoxYSzNg+4FWZ7ldeFiO
	 CjeMRRvlwNu/6FpqNbR0aG1O8SmslNnUZGsKeZTP3uwrM+sbRCfH8IX9CODj6c97P+BLX
	 XFo4rbVMqyOz6tMwZN3TgCw+Ou/0PcgvpDaHtAp04V49C/dCJwGJyrUR0C5D7sNzwyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oaS/9Sc1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1945A606AB19;
	Wed,  4 Nov 2026 22:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oaS/9Sc1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC001F000C1;
	Wed,  4 Nov 2026 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830975;
	bh=jyBCT5b6hjVKlzDyxyKbtjXV0JZh735Es17PZt7GppE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oaS/9Sc1X1fDzgdCcIR2iaTv82jO6kjuVpiarCNSrsdl1svtcWHM6LQRxTfvm9yk1
	 fTB15LQ/x2h6hmJ9xP/9sgzOZOrdw0EFzxqnj6iOO2TpuydN7LHVmGSOOsxT+BP7Ec
	 TNtt4BwlU4atcsD9u/rYpinhfhNY9jmr4AvfGEjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chad Talbott <chad.talbott@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0436/1005] ALSA: usb-audio: Add MIN_MUTE quirk for Creative Sound Blaster Play! 3
Date: Wed,  4 Nov 2026 16:02:49 -0500
Message-ID: <20261104211056.298815143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chad Talbott <chad.talbott@gmail.com>

[ Upstream commit 352cef030f9036a658e6eb03d6bb85fa19c7c103 ]

The Creative Sound Blaster Play! 3 (041e:324d) exposes a Feature Unit
volume control with a range of -44.00 dB .. 0.00 dB over raw values
0..88, but raw value 0 is in fact a hard mute rather than -44.00 dB.

Tested on hardware.

Signed-off-by: Chad Talbott <chad.talbott@gmail.com>
Link: https://patch.msgid.link/20260819003237.452807-1-chad.talbott@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index b08e07324f830..8dcba375bd4a3 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GET_SAMPLE_RATE | QUIRK_FLAG_MIC_RES_16),
 	DEVICE_FLG(0x041e, 0x3000, /* Creative SB Extigy */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x041e, 0x324d, /* Creative Sound Blaster Play! 3 */
+		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
 	DEVICE_FLG(0x041e, 0x4080, /* Creative Live Cam VF0610 */
 		   QUIRK_FLAG_GET_SAMPLE_RATE),
 	DEVICE_FLG(0x045e, 0x083c, /* MS USB Link headset */
-- 
2.53.0



