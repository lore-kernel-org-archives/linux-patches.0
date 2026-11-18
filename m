Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044488;
	b=qKOb2nv1EfdaXtShuI0kugXoAqbnTwIqk+CgD36WopA74ao0omIkOwkC/Ct+NUk1JOGw
	 2c3D04F+7+PnuH5M1IT9ymFZTUGMSNt38RySPlkqCyCpaBxhz4BlafV+z4KRDkCRcw0Wt
	 6LN7PdkNVIDX+W0MeLCuSTW17EuGA/fTG6C5vIpMwzIHXQcuGrGwrBr2gC0ibxoC4M+2C
	 eMlHqnS7jWvR4PuHgIUYfh22Ha96+BmiZsWl7YP0qULFUjNHR2VcixongG9kXaqWzrmtk
	 rxtEIuVqbM57fAuuHnFMNFq7eJ3Cp53B4ewkBj6S3IZ0gsB+YUQzR5CRt13MXY4IkVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cs0siXlyENCqeSgUig8BILzIyj+dKYPcwmAEAu8SyOM=;
	b=kCekVAIcMEx7niQC/hIQt7bm3A8QF/Dzrj/AZIXzMpmqe4w/BRudnCKGLfxm1i5xJuwC
	 rCZ11fBS4lxGIEzm7vM0y+9sFiFweUam/kP5mTR1Y3++7iAJPyor26rAF7VwMatxz7c+t
	 LVhdGNbH/IWx6ypRYDj5UlTqemwzURHaJEOYJCYW0GuOAwgFp2gbMRrBgtSB8urT74cUM
	 0LvSSBuLX7UY2ECy06KvTy36AyX7NKotGU//1h5HFGI18C97jiIkD0GnL7qFZU99qfnWO
	 uoHzjLleqmgDRZXFHQ66kBc0XPLEy5hrPHyIQcVFfEyuUmLt9xzGclzxDAYIsdWcrwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hs9p01Eg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D34606A31C;
	Wed, 18 Nov 2026 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hs9p01Eg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E65D1F000C4;
	Wed, 18 Nov 2026 23:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044487;
	bh=Cs0siXlyENCqeSgUig8BILzIyj+dKYPcwmAEAu8SyOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hs9p01EgsCcO0Aj9B+ZlhDSGm7TA0Q2iPOCBL5pMwtd8kzsg+FJDL5cViW0FxPlcw
	 aSs9jJFMBY0hwoxB0L5mN9btgbsCzFCJ94yB67P3hO4sri4LpkPGdGXfW6Z4LPlUrl
	 VqDV2uO3NNFIJGW8m+MdI72ahjR4QuOV06DF4bCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0586/2857] media: usbtv: drop redundant device reference
Date: Wed, 18 Nov 2026 15:27:00 +0100
Message-ID: <20261118150222.584250023@linuxfoundation.org>
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



