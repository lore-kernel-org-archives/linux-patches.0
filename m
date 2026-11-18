Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051792;
	b=whP0eH1jN22BohyuqmVc2FpY6eZb5MgMB6DGg0EPAUtnoEXaL99J/5ckrotNYFtE7g5c
	 LpSbEZO6ejwnl2FDxgOC5VLw3kdDR2UJ67LigsX0bKt0+8bqe/PMighiu4eBHWJRRH3+9
	 kxpFgYjgYh1Cc7BoeZUNHoRx3CmfSWco9nyPBq/ofPNeQBK5pq+iHoSil5p2SGfhNNY4N
	 du8D5qFppCKhyr6dkVuxND/MZrt3FHBlqcNryZe/hgg6QwlAbMqeYRdHpkDPFt9dgodmB
	 yNr9lo0E1rMUJUCXWSNefunH4BiaOAyuWyvGKKFXXDR3goyZEiEshSX332JDSM1dVCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0mm4Gx4Ku95P2zF5rhrxNjHIRpS1bIiyFN4mSms0DU=;
	b=IiHN83YHEX2ld0ea1Fic2PlLKOdI8PoFDqlFHZRPB29ZdvEjli480VobbCZ45VAeZnkR
	 xgvkZdeahM/xbOXxioz4yRMA/Qv9F6tmdql5rm+6xnsD8pgtf8FS5riB9ljKiPJusyuz2
	 CjlVCnJPHvdi0huvhlnOgBNILuZre7zyG6dEUpAQRuWz31l0CWp1rvqShDNjgPpwGkOhh
	 Jhaa8CZYZgaIqWngd5IiBUN+fVqye9OoXO/xzTlV51q3gDoT7MvyCdw6rTYpivvu41CnE
	 hb7uhjyePfQeOUheQuRakuE59V03TbmgEWiBSBZObpgnRxI7kwVRHkxBMqyf4J5UVfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulx8Ntxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED21B606A33F;
	Thu, 19 Nov 2026 01:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ulx8Ntxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481611F000C7;
	Thu, 19 Nov 2026 01:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051791;
	bh=N0mm4Gx4Ku95P2zF5rhrxNjHIRpS1bIiyFN4mSms0DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ulx8Ntxl9uXB9+FndalzI6y10CNB39aJVOIoSJjD2ORA+rGVLgNaTTy/pxmWhtOf8
	 hjOs99aV6Q+kWApJBh3zNwtxcsN2L8wDsCYOa53F+Fo6beI2+gpo9wPfv+OgOp83Jg
	 T1vLxKItk6pDhCen8rl6znTGCyhJ1X2iQ8dgCghA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0334/2214] media: usbtv: drop redundant device reference
Date: Wed, 18 Nov 2026 15:33:30 +0100
Message-ID: <20261118150023.872001350@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit dbc6798b80481a20f9aff671bc4d529eae63c9e8 ]

Driver core holds a reference to the USB interface and its parent USB
device while the interface is bound to a driver and there is no need to
take additional references unless the structures are needed after
disconnect.

Drop the redundant device reference to reduce cargo culting, make it
easier to spot drivers where an extra reference is needed, and reduce
the risk of memory leaks when drivers fail to release it.

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Stable-dep-of: cb705f75d03e ("media: usbtv: fix null-pointer dereference on disconnect")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/usbtv/usbtv-core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 2308c0b4f5e7e..275b21404dd22 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -91,7 +91,7 @@ static int usbtv_probe(struct usb_interface *intf,
 	if (usbtv == NULL)
 		return -ENOMEM;
 	usbtv->dev = dev;
-	usbtv->udev = usb_get_dev(interface_to_usbdev(intf));
+	usbtv->udev = interface_to_usbdev(intf);
 
 	usbtv->iso_size = size;
 
@@ -119,7 +119,6 @@ static int usbtv_probe(struct usb_interface *intf,
 
 usbtv_video_fail:
 	usb_set_intfdata(intf, NULL);
-	usb_put_dev(usbtv->udev);
 	kfree(usbtv);
 
 	return ret;
@@ -137,7 +136,6 @@ static void usbtv_disconnect(struct usb_interface *intf)
 	usbtv_audio_free(usbtv);
 	usbtv_video_free(usbtv);
 
-	usb_put_dev(usbtv->udev);
 	usbtv->udev = NULL;
 
 	/* the usbtv structure will be deallocated when v4l2 will be
-- 
2.53.0



