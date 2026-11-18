Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043055;
	b=C929i90xjTTwF56eKuTjtqP6ZCFGqfGuFmiVL6HxJhbCRBukm5npAkRk6NxvNw/aTo7m
	 hwjNDLgoLRX/qFETRkbgesR6LQZQy3uotad2jp2hBY5QVPSXVOtgdHSbk/nP6tz6MA0ec
	 jtmY6xa2tqt9ITgtLgpzjLS4INe7dQisoa5HpkKGWBZeRZRE4KSIHrZs7P+rDvs8YbYTI
	 UvC5swjlx2UIaC4rQ06sLU8jMqWT9GG4N85zMUEIWRcMwKe6n8aY0mzSrOIBRQsFtXdjl
	 OJW4NCI32XapT2kSwqcfMIQPT52OU/IfwKUUqy77jI8Fr1XectOdsrn9wXjXMRTniIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7aimlcFk0xg7EZ5EKWYWCkDQ728Mp/G/NKryZsapfwE=;
	b=yFUJUna3X65jbInI7Bx78tBpFy5lpfWI7FkE90SK5agngtakyPs2/z/2TxT7/MO7fPqQ
	 vHrXqSeluj1zTP21s9WPp2r6gOVCG96/SmJbeNIwbTysO+Gt+Ye4DGubk4ypxugbm1XTT
	 gaWQ3jJ7ddFExFcpAe3yoXcJ4VYJak+gOgLMwMma/hP9ITqQ4BqQQFSTa7Jr25bJ74dxO
	 4x35bmgxs8Kp3Dj80cgTfNm/9xoJ0VRV+Xr+t8puuLgywBrZKzEmpdM1VMW3p6gXD2yG5
	 6bl0/zAXHL38hOqvqhFGnh0YYu5U0VwOa37bwnZo2yclhvUkijdMUgXIs1JANYCYuKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5qK6Vxc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9026E606A31C;
	Wed, 18 Nov 2026 23:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5qK6Vxc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E05131F000C4;
	Wed, 18 Nov 2026 23:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043055;
	bh=7aimlcFk0xg7EZ5EKWYWCkDQ728Mp/G/NKryZsapfwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L5qK6VxcUrp6EA5P10HX4tW92eBo1Jn7J6M3oXoX9CbD0mBXAAl4WevAAdrSN5FkD
	 mJgx0gKH7GhvNMlK5+aBT6ZJmAvUIiyU71ObPsLp1y5c8Vkwg+mpoqU+fbmh79WWJg
	 ZIt2n0GWC7Yxr6d3UbR60TngKrILG3ojrdEv3boY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0075/2857] usb: gadget: u_audio: clean up capture endpoint on feedback failure
Date: Wed, 18 Nov 2026 15:18:29 +0100
Message-ID: <20261118150204.009746103@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 7a0d4f60da261f61dcb50c8e05fa53cc7d4d4427 ]

u_audio_start_capture() enables the capture OUT endpoint, queues capture
requests and marks the stream active before setting up the optional
feedback endpoint.

If feedback endpoint configuration or enablement fails, the function
returns an error while the capture endpoint remains enabled and its
requests may remain queued. The current code even leaves TODO comments
at these return paths.

Unwind the already started capture endpoint on these failures. Also set
fb_ep_enabled only after usb_ep_enable() succeeds, so the software state
matches the endpoint state.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/183621D513E0DE8B+20260611091229.4017443-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/u_audio.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/u_audio.c b/drivers/usb/gadget/function/u_audio.c
index 6cbcb8c4710dd..d72ab219f1aa5 100644
--- a/drivers/usb/gadget/function/u_audio.c
+++ b/drivers/usb/gadget/function/u_audio.c
@@ -641,15 +641,15 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 	ret = config_ep_by_speed(gadget, &audio_dev->func, ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "config_ep_by_speed in_ep_fback failed (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
 
-	prm->fb_ep_enabled = true;
 	ret = usb_ep_enable(ep_fback);
 	if (ret < 0) {
 		dev_err(dev, "usb_ep_enable failed for in_ep_fback (%d)\n", ret);
-		return ret; // TODO: Clean up out_ep
+		goto err_out_ep;
 	}
+	prm->fb_ep_enabled = true;
 	req_len = ep_fback->maxpacket;
 
 	req_fback = usb_ep_alloc_request(ep_fback, GFP_ATOMIC);
@@ -680,6 +680,12 @@ int u_audio_start_capture(struct g_audio *audio_dev)
 		dev_err(dev, "%s:%d Error!\n", __func__, __LINE__);
 
 	return 0;
+
+err_out_ep:
+	set_active(prm, false);
+	free_ep(prm, ep);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(u_audio_start_capture);
 
-- 
2.53.0



