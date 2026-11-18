Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045255;
	b=uvbaW5+Dx7v36Z+Y6O8kxq2l3xgOmwolOIXijNKSQ8tOwj/so/msLU6Ieh2c2+P5lZ3U
	 zu4FT0xpvhqRKxOzuMbrGwV9Acfr49LKH8/kH0pk8oxDNYPAr8c1oppy+GhqNXzVzXKY1
	 A/6yiY7HOhRwm2/uCxZbkDvEg141clGsim5EaT6RICwvmgrqHcQxwfwpzir+tJywDM2yq
	 9huNGnEG9eUr0ikannMwOo/WjYLL4wqhhHVumlEwxuqdcZ9gcpGKZt1OeD0qWtXxDBAbO
	 oIVJaEmPDctMmM5h7csawqxrgttHDgVTsfPj07Q9NJLBmJVSZOoqh4nYprhoOKzqkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i9WpMYu2941InNccnwIUVsOz4J3wHLf4bEoCt5P0jB4=;
	b=GjNpsCgG2NB1r70OMuPzgiAZTY26Fnj6UDpYhmtP0twR0zYlPvDHeko1WDbD0ZB95H9O
	 F2CACS9yst583A42K4KO1MjeRSMDiN7Bu5qSapDZLM9X6L7zOW6WPNb8uugxTgy2BYFy7
	 G4T7p04dRHDlN7RD87awTjKpDEk+S/MjypwDSHnmYIC3refWKvl8yesAYnrloqkYptS94
	 0kkSrYcUV9EIfAg/nTXYt/g38Za9zM4pRPR6KG11jIDWtSBSiFdN454YOMwmlo6rXt2RR
	 PEzw+bgVcqsbryDXPTHSiJcQ8tag0mRzaqec1elp1SQQZi0MsJ9S8P1ZlkQCCO9AF6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1WLvaFY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF76606A31C;
	Wed, 18 Nov 2026 23:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q1WLvaFY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1003B1F000C4;
	Wed, 18 Nov 2026 23:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045255;
	bh=i9WpMYu2941InNccnwIUVsOz4J3wHLf4bEoCt5P0jB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1WLvaFYzgKX0FGO0YC19tlEOlnwY083yGHnEaty7gQcHqyaqIyjTB2DyNf+To5G7
	 pmpO4FSFJs8AyCY58F24opN0oJSp9BhEEFbAE83MgO7ucKcDXj2ne27ykEr88mYXv0
	 oyMQg961El4zoyZQOf91AowKdxdnRdJgszDZl02E=
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
Subject: [PATCH 6.1 0858/2857] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Wed, 18 Nov 2026 15:31:32 +0100
Message-ID: <20261118150232.458075711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 466f947ef440d..e885f57e5a361 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1566,7 +1566,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



