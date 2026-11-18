Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058362;
	b=ZFfICda2Doa84lhFMsQjvcKUoQD6n3yNzAxIukW5t5QCkrPMNZBtNL/MRiCqJ/nOH7ID
	 epyi35lROG728vR7YhyUTe0FiTNkMZbUS5fTwAx8FaCwv0xVPGcIESg5Wk/cbV4IhGZEV
	 djghdHBkc8dMWBPqV1TwjKQyhDOf4/cdPDGGOyPvGtxxCQP2CzkTa8pM5iHHzP3rUsr++
	 ViJm77FkW0d2tczb2DeS+Ju6UkradPZQU38YArOhNeONJElyzjfGFzUbgAhsg1YKQb3Cf
	 HCsafemCgpB2DoSUjGdpKGuQOb6AW1z/82tPKosTDjFRMSt4TMMObcWFZMERKexvzVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058362;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qyNlKaXomCz5wZh6k2m0G2tVwlySUvek5RTsJUS87p4=;
	b=20glx8h5rzcUYd0FraTeCfK0j0qlUZKzSTeGh3Wry+49KHYyiDaZ5DV5jN7C7eLNQi4i
	 A/sgQwgEZyxhpdZLgYglBZGkw4PD5i/+LCccu04yReSmIP0Us8hndLb9vhFC349a94+7E
	 ISCCKUiG8+sDO0MKk/L2kDOiy49Pqq7GszW+cDGSZsLtR1RsJlkp1uYZbyHCQB5dlnN4A
	 R6Kyomorf0x74q6MbGwB2Et/apM8rI7nplNgdf7WtkWv7IlFIJu4kfMVUvFkUuSvmayeG
	 AtHfnkouFxovr70+We3RkxhffaP1Lcl5tSjhGju12YvXas4xrrhvyi6h0aj9ZODRc9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O+/zQjiw";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F67606A32C;
	Thu, 19 Nov 2026 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O+/zQjiw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33731F000C5;
	Thu, 19 Nov 2026 03:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058362;
	bh=qyNlKaXomCz5wZh6k2m0G2tVwlySUvek5RTsJUS87p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O+/zQjiwFqo3MldXR026hf3gEBC7Y8L8l/O1KQN9N6Uh0QdGJViyh0kD2muF4UBvZ
	 ZAFYpYbx6qwcXTDgi4GgY3SHtu0D2l9CVqeTGh8r9IOQ1uQYWAroHforKk4nK2pZI5
	 h7tm7K/rV6sX5kvwjOglSKC0FqHoHKnAF38BKvUI=
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
Subject: [PATCH 5.10 0459/1848] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118145933.663087812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4f67ba3a7c028..052a3ef8ded14 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1402,7 +1402,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



