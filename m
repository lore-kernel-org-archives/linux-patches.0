Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704884;
	b=eC63uCNq+MyuJjSeBlltdlEqOxGefTECPz6WsYF+7vSDA//MvqBbqTN+Ml7nBReWaMJH
	 mh4eAh3uXxWUxiYspPzWSeqSu0y/gnYe95T923xyssb6CUza3xDL76GRArtHo2XJk9pzs
	 R7KNI3R6M1SWPf6Gns2FBbbhYJFlrV79q7IqSasaThghfpIwNshY962YuIK4LXScFHGN/
	 elhQcJKD5Arfr8geh3zpdpVzkDW0hoiqYtDzGfZ7xE1lrWZvKaQY+fo09o+16y8wt5HE0
	 fx2ZS92S+OyCQDa/cyq/CUXWt5yiPnqVPxll8qpUn0TBAyUqqiG8GHLVHJb1YmBIqTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NCQLGKdcMuOc7QUkoj6wcqZTgooVd5wD+y9kKpPQLyU=;
	b=wvmpZlX5zum/VPN2chbMniUrsef26U99lab7qhl/mcbl01HBdXZzCWwmbgDJy7wxUdNU
	 SX0oEo1JkoUl2IhnBy0qN6hSSwhuuzO/++ww3og4bu0+pOcAI8ky+zQBrTh5uryKBUk+D
	 CWy0WoTcYt7VjbEP0eW+KOTQqDbhL7UHW+3SY3YGhv/0wv4F4eoVrzpEIfh3j2UdG86jp
	 CzNuDDT3JQYYn+HG7BEXjFzNzLN7hcfFGXVQON69FdMMF81lRj9vXbghmf6jIC9Mb489e
	 jNPXVdrnHYazEK3gVkmItIweGJJqXsdJazOiLbIOeqVyxcvTpeHJ8yu4BV2mILGLrWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0D1iPcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31971606A321;
	Thu, 26 Nov 2026 14:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S0D1iPcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A091F000C0;
	Thu, 26 Nov 2026 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704883;
	bh=NCQLGKdcMuOc7QUkoj6wcqZTgooVd5wD+y9kKpPQLyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S0D1iPcRPoI1nBoUy5o49xsdVR29e9cJuYxtQqmiK56HamS1FzoeUc8SeV2d2fk3U
	 0eCb3wi91s1Nrzr8htu32od5TTx5jmJHG/mVDup1UbErUEHFp0qheEz8pKtcPumCmn
	 4AhMUZ4f2a4JWBuR1iiFhl5Fi9RnXwjsKsF5Jckc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/319] media: uvcvideo: Undup use uvc_endpoint_max_bpi() code
Date: Thu, 26 Nov 2026 15:36:09 +0100
Message-ID: <20261126144006.770307889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 5b9c75c794ce041e6e00789efef75d71915c4f4c ]

Replace manual decoding of psize in uvc_parse_streaming(), with the code
from uvc_endpoint_max_bpi(). It also handles usb3 devices.

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_driver.c | 4 +---
 drivers/media/usb/uvc/uvc_video.c  | 3 +--
 drivers/media/usb/uvc/uvcvideo.h   | 1 +
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index a521038903f20..2cd4ae6342fda 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1023,9 +1023,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
 				streaming->header.bEndpointAddress);
 		if (ep == NULL)
 			continue;
-
-		psize = le16_to_cpu(ep->desc.wMaxPacketSize);
-		psize = (psize & 0x07ff) * (1 + ((psize >> 11) & 3));
+		psize = uvc_endpoint_max_bpi(dev->udev, ep);
 		if (psize > streaming->maxpsize)
 			streaming->maxpsize = psize;
 	}
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index d0415ebe54d04..4d84726b605ec 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1841,8 +1841,7 @@ static void uvc_video_stop_transfer(struct uvc_streaming *stream,
 /*
  * Compute the maximum number of bytes per interval for an endpoint.
  */
-static unsigned int uvc_endpoint_max_bpi(struct usb_device *dev,
-					 struct usb_host_endpoint *ep)
+u16 uvc_endpoint_max_bpi(struct usb_device *dev, struct usb_host_endpoint *ep)
 {
 	u16 psize;
 	u16 mult;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 2dd8d04589abe..e2732986b7e8f 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -926,6 +926,7 @@ void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 u32 uvc_fraction_to_interval(u32 numerator, u32 denominator);
 struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
 					    u8 epaddr);
+u16 uvc_endpoint_max_bpi(struct usb_device *dev, struct usb_host_endpoint *ep);
 
 /* Quirks support */
 void uvc_video_decode_isight(struct uvc_urb *uvc_urb,
-- 
2.53.0



