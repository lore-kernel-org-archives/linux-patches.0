Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C09720316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HMIpmeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAACC433C7;
	Mon,  6 Nov 2023 13:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276518;
	bh=AJb+UrTGvGTRSoCewhlixd1XNnwXflNoQxKcKtHg38Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0HMIpmeAh9JOLzG8RK5i+WAbzoVU1qA8+FwBldrHHy892BC4TO1y0oFalPeNAouO0
	 f3aX+Z5v2lvkIjPZppah8q1nxSUPrGpjbmxEA6C9JpC8PJUM/gWyz5X4CsC+kaWDvI
	 lB/jz01eYcvx4qOhKRr5NslcutkqgdRmj0Sem0Ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max McCarthy <mmccarthy@mcintoshlabs.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 45/62] ALSA: usb-audio: add quirk flag to enable native DSD for McIntosh devices
Date: Mon,  6 Nov 2023 14:03:51 +0100
Message-ID: <20231106130303.413318135@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Max McCarthy <mmccarthy@mcintoshlabs.com>

commit 99248c8902f505ec064cf2b0f74629016f2f4c82 upstream.

McIntosh devices supporting native DSD require the feature to be
explicitly exposed. Add a flag that fixes an issue where DSD audio was
defaulting to DSD over PCM instead of delivering raw DSD data.

Signed-off-by: Max McCarthy <mmccarthy@mcintoshlabs.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/BL0PR13MB4433226005162D186A8DFF4AD6DFA@BL0PR13MB4433.namprd13.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2218,6 +2218,8 @@ static const struct usb_audio_quirk_flag
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2ab6, /* T+A devices */
 		   QUIRK_FLAG_DSD_RAW),
+	VENDOR_FLG(0x2afd, /* McIntosh Laboratory, Inc. */
+		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x2d87, /* Cayin device */
 		   QUIRK_FLAG_DSD_RAW),
 	VENDOR_FLG(0x3336, /* HEM devices */


