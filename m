Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704107;
	b=teiODgkJ27vAnE8NKXrWBvJbJGDrRgxBTmag+14lNsM01VS4qM4ndbAwlqf20dw4WmKh
	 1x9DP4sC7FVWNLpTSuOyjGJOaKhDFGntIVYmzpIgDKj1HoTbp9bmAIRz3yalk1um7uxN7
	 /2e1tH4HYhpW5KR83+WUYCj0+fOi6RH03NTI3Ye6bP0Zm6HijDbE3f2oHqhiMdC6tJc+k
	 k4DTLTHfyueuc/U1YXCRAy3XeQzs+gJh54vT+xrUXl7oWLo1XeYtSJSkxlBhkXIMsRSbq
	 IWFZSoo+T3LNlFzNdzTbwgingi8z17BLFQzzSTzwoNPKy/NO9g05OSQRdfPaAGQ7WQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YbhPHeMJkakLAN/jwTUjp8gBLGfmcCcX6qgtmah+Lu0=;
	b=QRQ44RSlkN7cfRgnDhL+sCVYeJnUlrTjbzFhHk77f6PFP0cUgojU7i4V3VsI/UdWq6Mk
	 rocwhAMNahODqI0vebBm8E1ocHNZlLFJTWmcDUzDQB9coTE7mkDNRWo81UEpwgDOYJJQN
	 qGmo2qWEFQ2PBXVW3+Bjb6vL6CS1iUuLjpx7RPwFx4Nsf/uNUvy0+mfLoFuzzjJI5/juk
	 WMqs6MfVccD9GICmK4Fwkrqbf407sk5Hu+RxV94R/3Bw97h1qQth7CwHyRfgNYt41z8rj
	 t8owwnxGLWegU3eVH8/fYYnTVRh59orXOyxTdC5XBHPzTcCw7O8ZtweMsO097YuW7Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlHQKxxF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B32606A31C;
	Thu, 26 Nov 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SlHQKxxF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACD01F000C0;
	Thu, 26 Nov 2026 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704106;
	bh=YbhPHeMJkakLAN/jwTUjp8gBLGfmcCcX6qgtmah+Lu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SlHQKxxF/BpZ/jkUWn1vUFsIvohYIZWhZmeLFwdqcJ+g+XEhaa3lF/bNTZnbn6nwp
	 aZODKhkZ+l4I9Zp+R5QTFNozUzl48D9W8cYIBLNHlsKnIs+xPSd6/BZUiPvpzEYY61
	 ACKtHyPtfKmppA1uBZDqTqHwHQ/DBbLrGLI8jBv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/265] media: uvcvideo: Undup use uvc_endpoint_max_bpi() code
Date: Thu, 26 Nov 2026 15:35:31 +0100
Message-ID: <20261126143605.176171329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
index e9fe09ed6968a..d3c87ce87f0e4 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1016,9 +1016,7 @@ static int uvc_parse_streaming(struct uvc_device *dev,
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
index 909e158a017a2..a33b99cecd390 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1788,8 +1788,7 @@ static void uvc_video_stop_transfer(struct uvc_streaming *stream,
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
index 184ff2c10560a..14ebb78d7e004 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -894,6 +894,7 @@ void uvc_simplify_fraction(u32 *numerator, u32 *denominator,
 u32 uvc_fraction_to_interval(u32 numerator, u32 denominator);
 struct usb_host_endpoint *uvc_find_endpoint(struct usb_host_interface *alts,
 					    u8 epaddr);
+u16 uvc_endpoint_max_bpi(struct usb_device *dev, struct usb_host_endpoint *ep);
 
 /* Quirks support */
 void uvc_video_decode_isight(struct uvc_urb *uvc_urb,
-- 
2.53.0



