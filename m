Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98ED3D75D0;
	Fri, 24 Apr 2026 13:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037734; cv=none; b=WZtFQqgciSamyy+QcpoTl7B4wZaZI56Oeqx96+IMsQv9nj9gWJmhZx/+pqJKhu94+XEgJ4xi9cnBigpCDaTI8HZ9QG2DuczyaZhSZDNMT+9MmgLb2OkJ/FYizAo59/rnXABWG6G6+68fjq/NeNYvhdtRb7VGVEQvH1Fp5itLSIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037734; c=relaxed/simple;
	bh=KkRvjc8zRr/hylml0aljC0GR3ciRd2bb0kqiTyyeRC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJLiKB4mnfzjP9YLGtqqJA4LKilz35IIRb4y8vlNgrSG3RdAFdctXe4GtSD/E/iKiecjweqAU5lhd9iJDFzBh7pYW7xcb3PNg2bZ2f7d+dBXzrG+046cW/cyAn4o7oMLhJuNv6YANkChekwhkLvmgoSCdwpQYqoYFGrFbtkkJYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bU2gCMi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bU2gCMi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2D8C4AF09;
	Fri, 24 Apr 2026 13:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037734;
	bh=KkRvjc8zRr/hylml0aljC0GR3ciRd2bb0kqiTyyeRC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bU2gCMi8FCzauKvVVLVQlmYr6wWh04RGa2OSEaaM54vuefppMSRyUW/LRGOYFWYnM
	 YxVJLAJ+QjNs0NaKWWuCGR0TU5Owrj6VcrpslnMS94heGFGdCK7ATWEH5CgqgXQQ3x
	 N1lqQ6nlJt7t31UeSjGCmG9TaZL8y4zQdZam2jQc=
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
Subject: [PATCH 6.6 016/166] ALSA: usb-audio: Fix quirk flags for NeuralDSP Quad Cortex
Date: Fri, 24 Apr 2026 15:28:50 +0200
Message-ID: <20260424132536.219862515@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 04896ab01f372..847878438b8b7 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2185,6 +2185,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
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



