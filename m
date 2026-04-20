Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3951EB5CE;
	Mon, 20 Apr 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701198; cv=none; b=fTOuAzlICtBZB2tqV/PttdPyvmQlnBTpFT9qHVZUCcVz+t+P4z2B25PHGcs8LnLaYiWFZglXidr/2FtRQHT0/WjV2jNBsob/8Zcm5JKg1cm6OPqd4Z0RKj/oYVjankSnVpQzj4VYXVn3AiG0FHXfEORWPqPqKGJ8hbSNzQhO/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701198; c=relaxed/simple;
	bh=sooX3V52DR9uVKq3sidBFbbZnMBdWdLKaEIAIZjudsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfsmlLPo5BL1d2HQZM5G5m4Gmu0egQI4wlHE27FmJHlMY2/YNuxhKsE0arGf19eC5ypDNopVuLSXRVdBVN5rwwKs7nNnz8CXmb4b1zf2/upu0hmWWve2129P07aGbNTr6t55wMpB7BI8Da5dTDJKxTkcDOjxUpBViwEUDR5eX5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ri8LIAKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ri8LIAKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9561DC19425;
	Mon, 20 Apr 2026 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701197;
	bh=sooX3V52DR9uVKq3sidBFbbZnMBdWdLKaEIAIZjudsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ri8LIAKeIw1eHXOgQeRyCHACBgJP8Blnnybzm1WquP1sUTtmq2CfESWcOSLqRDXCZ
	 RJ119NPqQpEPSdZoUlWhJE4dHOwxzSza3ocd8InQGTWvTreDVF48KJJ8VK0wbCP9Yu
	 +RIXuSN4hE05jfre7WJXmbUBx4/qf6TiSjpwLl4w=
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
Subject: [PATCH 6.12 021/162] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Mon, 20 Apr 2026 17:40:53 +0200
Message-ID: <20260420153927.787936437@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5c3a97ea46e04..fb81dcd6ca2ac 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2285,6 +2285,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



