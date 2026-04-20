Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B18862FD1B3;
	Mon, 20 Apr 2026 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700637; cv=none; b=oRxpUqfnoOylpBGTtVDwlfF5hsi0Fc8Q02CvkS08Y1lqKrmx7eBcadsbSeOky9XEkX46u2prA6pr7T7MKSzx+6TnW4RYkUnEXM7/i+ewrkrUaN824VgYyB1CbPmP/AiIbBiUz4E1+UPhXi8dBmBZwh2mgO5R31iRDnExl8PuAR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700637; c=relaxed/simple;
	bh=B/c0dhMWvROZPWiNQ1/36+ZvBRAdl05zZQVv+wcYft0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtQSM5AQJrRdIZppC7rOJv/xAJqcNt1f/y7OSxbaSAwxK+WZ0ClXZ8BPfyEnfi00JpHBai+k7hBIbIx7OSbiQajIJEd7Ip0k2SErSnfwCJZZoxbMGV1q8pIUn/eFbx+NHJXWLH08+SSQk5DyjJpTnC709GleZQkvEiA4uFUgkME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vM1Lecdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vM1Lecdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477D7C4AF09;
	Mon, 20 Apr 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700637;
	bh=B/c0dhMWvROZPWiNQ1/36+ZvBRAdl05zZQVv+wcYft0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vM1Lecdh6iIqK1DDhYS2I6FOk/zAqA7noLPdIaZYsQS1+Y22O2Ami4HhzlaskYBJo
	 c5PN1bc/1gosCGHNc0t/vPajXRpgvh27+txykrnvW9gYFrXXnKC1srxTVqyQaSj/0o
	 e/vt9v6ft5KZRpF8vMZ20qM2cvwQKMAoB5zudQJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Wang <yuleopen@gmail.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Phil Willoughby <willerz@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 029/198] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Mon, 20 Apr 2026 17:40:08 +0200
Message-ID: <20260420153936.666418906@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Willoughby <willerz@gmail.com>

[ Upstream commit bc5b4e5ae1a67700a618328217b6a3bd0f296e97 ]

The NeuralDSP Quad Cortex does not support DSD playback. We need
this product-specific entry with zero quirks because otherwise it
falls through to the vendor-specific entry which marks it as
supporting DSD playback.

Cc: Yue Wang <yuleopen@gmail.com>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Phil Willoughby <willerz@gmail.com>
Link: https://patch.msgid.link/20260328080921.3310-1-willerz@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 9f585dbc770cb..a2c039a1b3cd6 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2296,6 +2296,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_PLAYBACK_FIRST | QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x13e5, 0x0001, /* Serato Phono */
 		   QUIRK_FLAG_IGNORE_CTL_ERROR),
+	DEVICE_FLG(0x152a, 0x880a, /* NeuralDSP Quad Cortex */
+		   0), /* Doesn't have the vendor quirk which would otherwise apply */
 	DEVICE_FLG(0x154e, 0x1002, /* Denon DCD-1500RE */
 		   QUIRK_FLAG_ITF_USB_DSD_DAC | QUIRK_FLAG_CTL_MSG_DELAY),
 	DEVICE_FLG(0x154e, 0x1003, /* Denon DA-300USB */
-- 
2.53.0



