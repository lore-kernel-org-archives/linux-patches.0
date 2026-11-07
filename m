Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064343;
	b=QwidQrB38Sr1nLEQdqVsX8ibmABgWFGlNuqrbT79wiK715FJXOafZiH9VQlCxv/uT5nR
	 fyb7zULrrZR6RWuzapFv16pLAjjL7EuErm8QyU0lbg8EuyAjFQ4ApVM/hZfXwtpm9VAAM
	 eEuIZ1Rd5lPrh5qPVnTLj/o/FcwS7CwxH5ef4Ufoc6iBN/b6UAkm4W8jnvVDxlHuRnrI+
	 QoNCntep1FjpXIqyZsJy+wpzk1bjqMTrfWrL30O0egg0se8L7L1xFw9/hXI9W6+P9YGfD
	 iVA2cZVCVBgv+4DZyPo/2Qx08spex+fWozbuYOL8BWsV3l8BCXNire+SYYn/nckg8qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064343;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m745xAvoGDr7zp0xpkbGKt3KVJB4EA43bzigAA29Jck=;
	b=4P4kVBSMSCvcz8/BDt0Mne1/DJw48z33qHRRTaMN0SNxuTbM4dEjUq6Bg6qFAkBsB2S/
	 APLP8AC1dq0ZUnuWbXruXYjMIrTXiU/qm996Pm4796kFNEjyeZg0IS4x5PmFvWSckNdXw
	 aX7AhdZnb8yaO5gCZ7TwXd2AhGC13P6UpnooLFHembvcu055k+71IopLDAykU0mD/UQ8F
	 Jp1aYJS0mdgh1ccy5DgjUnTt1FlvY6Tg0J4ErzNwZJ9xFziXCsYCWBvF7Nyn9YryHJ2D7
	 Qa4EuzPompLV8RYqUWsiL+8fuQOYSOVSMQ1u/BNaxKZyd3JX43i3HQOIoLHTlYFskPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAFd9Dmt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40F3606A33A;
	Sat,  7 Nov 2026 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cAFd9Dmt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFC01F0089F;
	Sat,  7 Nov 2026 15:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064342;
	bh=m745xAvoGDr7zp0xpkbGKt3KVJB4EA43bzigAA29Jck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cAFd9DmtvkuCe0xIGSyHsf64GSqthfvg4to5dV1QmGn2ISPXr70WUU4Ru1pntHR8W
	 MKgMNQK4doGxBxt1DHeIGJXu71mHAWAWz2V0Sy6MlcHG1W00hH8SN0GM8QDqlU6AO2
	 v2Dh0xdFpwvuX48E6a0XGVpT+18o39dC4Q8fBkVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <98lawweijie@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0428/1257] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Sat,  7 Nov 2026 08:45:24 -0500
Message-ID: <20261107134951.313609594@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Jie Law <98lawweijie@gmail.com>

[ Upstream commit daa379e2b74d6c10ba4e3b56eeca5aa8c8704fca ]

A null-ptr-deref exists in v6.12.105 and upstream. KASAN crash log:

  KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
  Workqueue: events uvc_ctrl_status_event_work
  RIP: 0010:uvc_ctrl_status_event+0x105/0x280
   uvc_ctrl_status_event_work+0x82/0x240
   process_one_work+0x66f/0x10b0

XU controls are initialized lazily, on the first UVCIOC_CTRL_MAP or
UVCIOC_CTRL_QUERY.  Until then ctrl->info is all zeroes, so
info.mappings is not a valid list head, list_empty() returns false, and
uvc_ctrl_status_event() walks it from a NULL next pointer.

Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Jie Law <98lawweijie@gmail.com>
Assisted-by: LLM
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260907121844.2592492-1-98lawweijie@gmail.com
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 3ca108b83f1da..ea28c4e819bd4 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -2209,7 +2209,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



