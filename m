Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052444;
	b=HJHHY89pPPoNmFVW89Mzc/crhXhuWMm4/SIgX7hu8gzV0Tr4Z71ZWXhY1c1uPc3h/jDT
	 ccmWGNR4v7k1Ial8lfbpqBnfgs0LJT/c1+NEWhjSfU8GJR0xNRyUuuHGduvM6nJFh/9WN
	 Q+epeiZEsuSuetuiggmWHoZR79dz2HpY0Yb9Yp6NyAExzF7UqfJBfG8vzOCyv1Sz5O0Dt
	 /sFdNWY35gSiwgf598J6nRQlDtttN+QUq8tDOzcXxLan61NnyIXDTlm5GkDAr2/VJG0O0
	 07in2gG0J1kSLqXpEp2ZjjuQ6AtZFGXM8oW1oXeQEKslFoPtA9RYTCyNd7XXFYIrWZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052444;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R883H+t5DgCi4KLU4r4eqN1XjKEv9ajTA3atwFMGLQo=;
	b=ttfYRtriSC6bqpLbphxN+T0JEVQAE2W9NITI/tG6So17znMB2f5ah43gU5Xq4cP4whvq
	 6ctQTIKMHp8qwVv/tnQ85ayAmxOHLeWc2IBKMZC+RpaeaNxekW3O2UxkdR7qyF4+HOBE1
	 aoU+9/Wpnxb0Z310EzjLeWjV7F8rq37cOc6XWixA9NXjJ1hnZCduk4ppVvZYt/isttdQU
	 N6Fm2uFXJrgzuRyNRRMPQiBjkLzlwOxYFRUFb3mohm4GrrucJCFkU70qC64Cyf/9pzzL7
	 mcc2aXomgs6INGeVXIWK9d0C6vMgF9qrR10t8d4iyoIUM6crpSoKHLKlbbHYwJP0oJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqtmCW0L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891AE606A31C;
	Thu, 19 Nov 2026 01:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqtmCW0L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1A051F000C4;
	Thu, 19 Nov 2026 01:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052444;
	bh=R883H+t5DgCi4KLU4r4eqN1XjKEv9ajTA3atwFMGLQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqtmCW0L+E2Or8gAiHUVWb9axpJDEHVSF3NphcMm8MnEjMb9Vts5o0LaohfZ8aOCS
	 1flJcyqs8VZHmjSfWlbkALH4SSi/dwGDsGPtfvZF1PqczQd0bczaIm1tQHzNan4ZQ4
	 6v+GXya9Skf4KROfKcOIutgih+zp5EebBZHN5+Sc=
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
Subject: [PATCH 5.15 0564/2214] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Wed, 18 Nov 2026 15:37:20 +0100
Message-ID: <20261118150033.551672323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f37198839a8a0..9cf40cec49c61 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1513,7 +1513,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



