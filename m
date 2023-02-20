Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D9D63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF926C433EF;
	Mon, 20 Feb 2023 13:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901489;
	bh=5d+9PlcVs72/SwBwickPbffpbNEh+EgpSD5hr+nLxRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2pnXeeSYWOgF6K2zSbQ/DAMr+5+ZdrDI2cV4hSq4invyfdxGLPOmlwYgRR/XiTfbk
	 F1qSEWoA0ScNDN8duPhX723jfND3fKuVePWzPlxWnJGvUnpJ8daDH3Cwvf0ha0U8i3
	 w3ImgiUQsu/5kf77tyAihakrS8J2lHEbA27MO2DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/118] ALSA: usb-audio: Add FIXED_RATE quirk for JBL Quantum610 Wireless
Date: Mon, 20 Feb 2023 14:35:25 +0100
Message-Id: <20230220133600.768725045@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit dfd5fe19db7dc7006642f8109ee8965e5d031897 ]

JBL Quantum610 Wireless (0ecb:205c) requires the same workaround that
was used for JBL Quantum810 for limiting the sample rate.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216798
Link: https://lore.kernel.org/r/20230118165947.22317-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 3d13fdf7590cd..3ecd1ba7fd4b1 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
 		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
+	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 
-- 
2.39.0



