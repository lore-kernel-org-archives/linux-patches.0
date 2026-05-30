Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30133AFAE2;
	Sat, 30 May 2026 17:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162628; cv=none; b=f5haCU9qwOKYcetUWAY0e12gUGd6XGOu7R4z3jb8xbiwwrbZhtTiJVlmR2pOTKCZnEu4EFhFf08ofepVWjxfeTN0M1mWZzTavyPyXajxfjJ4mTu6OrbG8qR3KlSKAVdY7xEJuG7Z8Zi9PmfLrFUIiDNcl3Wju7O1tVgrHW6QT7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162628; c=relaxed/simple;
	bh=uiD8K+wYrqD/SmjhiVmwbHMGqd4M6N4eDvjyFakobWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHiZWIMBVex+ba+QO1mnr1bN8rtDJD3QQ5Osyb9wyBM725B0zfkT7CO7lfw+gPfEL/c8lJhQ7sx5D3z7TMDqyGKUw3TfxjqdwmZ8sxwSlB5ptsOHxQmTPY05lwq6/imEQ8mPG4z45j15yfKZ1Br4nYYihb7dVVVcw9/fGx1LGIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MJxHCtJE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MJxHCtJE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92841F00893;
	Sat, 30 May 2026 17:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162626;
	bh=LnuRw32cWOymJufuPKdcXxqEcQcFEExmwpOXG4O4E0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MJxHCtJE9O7ukhnR7d8Tz1mKOaLIU4/9+DH4fMSIyTxZ/kjQRN2WdwDn3yz0nZlVt
	 GRF/nAV5zOEOEqrue9xxfbQVsD2gMBu3Kao6ofXsRq3UrS+v9fxDSb7flJdMxhuc4U
	 XuX1Eed9PG0eQUPv58BXoIm1KybqeHRlWTsyg70Q=
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
Subject: [PATCH 5.15 009/776] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Sat, 30 May 2026 17:55:23 +0200
Message-ID: <20260530160240.493270302@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 33a1a35485721..4cf2f48b401ee 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -1863,6 +1863,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



