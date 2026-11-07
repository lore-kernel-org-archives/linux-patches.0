Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062168;
	b=zMhgaIBUlhoDpCPg+zF30+kNSTyv3irtk9n+4PuSLNrgREaiqQNiPC/PqwchdnbBwR38
	 3q70yhMMHJvyzFoxQQPMkSyPOlRBRWiC3914OM9Gw3h4+9gbnOl0gOWa8xU9W741VtPBW
	 7Awfb4RZfjDR0hKzL7vKUqcf/J+kUFlhyLlAJ/QnfcyO9MlPXm8ZJ8/rz9svPS3SVKCW3
	 G0SD9MeGmC2XZ2g57F1gDTbt7P9s0bjDlB/d/s1CX8SHPi4wDneMrp2mB/1oUqxIJB/hY
	 oc8xAtiJmMOgN3+dk5AjxpoXLcpV6LxvzB/Ol9inx9teC7SHsAoTJMjmwQK/jNoQwhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rLF/NO4xgpCoiza7bY9/vWS0+Ctmla2nUlzwBTNNs+M=;
	b=Jtv9KRsbiLTbW9slPQqjASsJVXDiJ6e6+qbDHS2SA1ALBW0tjrvYLrWn05fau2DznKsV
	 Su8btLjV4C19Dx8GXO+vlemVMaSDmfaIlO4zgoNV/NqcF2eBlPAgpJb57/0icV22lJb+s
	 23+F0gaENCsEZSZbc3DzqTqpxfsTa6FzA4QKqb64Zidk6i9ikAEloLFNSTn1cKQiBnpPs
	 zIxDso1vLp2cBaEgoRhuzP2FBYgi56z/pjvIWn+hr6aWBht1VdeJC9F/IuEaQXyZw/dna
	 thakAvg1+rprKKC/7iDWK78y9AqhSgGELLCkPe2xHBHsau5KAnTyn5PcPDul1yqqiGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7TXTpE6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5131606A326;
	Sat,  7 Nov 2026 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V7TXTpE6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855C21F0089F;
	Sat,  7 Nov 2026 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062167;
	bh=rLF/NO4xgpCoiza7bY9/vWS0+Ctmla2nUlzwBTNNs+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7TXTpE6Fp9HEW9K/MmplPc17qGbT4qF1Gn9AMe9R4Bys3AbvCRY47kWfo6i9+AtA
	 uEdZEYr7kS+b3v/SO0Gha1aNvpOAkbOiCeYnaFix9p+ZftrM2fLZ/ihJ0KRwne4P9v
	 DMreB92PkYx0M6co8bE9aneDEishxptVvT/aCL9s=
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
Subject: [PATCH 6.12 1130/1536] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Sat,  7 Nov 2026 08:52:26 -0500
Message-ID: <20261107135029.449757223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 957d620ad671c..bae1d0733444f 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1662,7 +1662,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



