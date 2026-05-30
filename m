Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FA1348C46;
	Sat, 30 May 2026 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158249; cv=none; b=eDCuRB6c9JJitX/VeasDkSgnYUpQzBFT6Ffw0eG8WlVu85lB5jfuclVlXrt8/pwhWEXgqRzaC7IKQ9vtGQpHD3jSfwM0CDdgf1f3d14kRCAbl6Nm8mAzZ6MZK4LB+Xhd4nP3+7iMUNHxIfoSJalNl6/qj5dxxxgwvTvJohYW84k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158249; c=relaxed/simple;
	bh=MEa+POPfIZlCRr7iQjm3DOnUB5eMzVf4SP8NiHKhRn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5ckHoRcUqLhVbWb7EvhJANV3/JUAdUM0mg6W2yTzE4btvzC+oH0WnauptR0mjaJdtJKipoAM2a+gUz5jdE4hnCT79pxU/Bd5JwIjFbgo8VdOa8wb/jVbcVVg8UQ5ghqOlHz9Xbs3Wm3iZQ6T3z/ofROm+vpiEyH/FaeArb8vq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vwOr5U20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vwOr5U20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235AE1F00893;
	Sat, 30 May 2026 16:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158247;
	bh=WknNfhVZ6FynkHPO3vEgfrHLyRCrOaE6WZDiXHJXex0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vwOr5U20mACDRxS3x2lvlMAoo8POgtvC2+2dycODZbV+wI03SM33XeL2yyj4NuWjd
	 VVmgerjwo6YabP7UGSUfwGqy7wT6FOJuiQg0J6SEEwfD5qatYHB82MVgHS+bkAwoWR
	 EyDmzqBA+b/I0mNfvszPTHZ6BwQkk0TbT2+Jscfo=
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
Subject: [PATCH 6.1 014/969] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Sat, 30 May 2026 17:52:18 +0200
Message-ID: <20260530160300.865897909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 74828de545e22..23361e78189d0 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2177,6 +2177,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



