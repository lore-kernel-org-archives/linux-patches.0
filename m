Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035329;
	b=46x2z4ZEB4q75HHxUGE0SezByfKTIa9aAJmpsvMyp6b4Hsipm0Tpssc58YBH20QFWr44
	 KlKV3cgCt1zuk5H0bn4c8Fzm09qDDO8aJ1Yl17Bc8PUxm5p1NUoLiSaVo/VS68wfbomfX
	 xklKZTgMGCd9QVDoiONxptUClgvV3Akgs6MpLZlTxaCoU9Jx0WDW9iXTydIQsngKBgRDB
	 bo6PV5A855DPVfKiilhKX1kbJ1rEu4+x3xkkM+A77fYCZ5wAY8/Xx/bmOeCsdn5Oh9BdI
	 OcLWgKIaw3gsFo02mqXOHZMSIbgegdjt9i+c6/A7XOR3/jxuvyfX5pvUgK2sTrt6tjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MFaQZVgWboao8b55zzjIkPZphk/CSyKDs9dsfMqhxQI=;
	b=VZ+n5mWI3/xjwA3AlbYh9Jw8lCBPDFgODBMl98uosnCnORfHa1LSCaQAMLaUlRuWvx2Y
	 We49Omdgs/WtzvVM+7jFYN4789X7G8ZYnVO3zpijKveXCJqJF7skE6KJgFr2+EHePmGLT
	 f1sduxNcLVHzppuhNunvWl11E4WUCMPskZmHiySBelJPsUXZEnWjMX2t5WbkVGssVjwrk
	 m3FlTz153DT2OLFk7OOeAEnNb9ngAjG3Vz25+mH4lgdc5B4j3RSCysXUA+d/wshjXHS0z
	 6K4x05EL4+dF/wSPhGwYq5lRQ6r/h3zCih5DeTI8kr57s8tVKUcUJBfFFS0DtStotnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EU3dg07g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E333606A320;
	Wed, 18 Nov 2026 20:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EU3dg07g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E861F000C4;
	Wed, 18 Nov 2026 20:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035329;
	bh=MFaQZVgWboao8b55zzjIkPZphk/CSyKDs9dsfMqhxQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EU3dg07gPqR5sXFILWbZmQ5ao9gh4GlVGOjnxmHZSzLm9QpoHr2VWMenEEYl4tcEi
	 XUzTjC9nrX3dgQnkWqJFURnhDwfyZbyo1SxtM/GqwL1Zfba66BDqCcc+rwuY4BW7zG
	 NxNMamIpz+qZ8I6BJpNHlN7zVbEnnbO2muD+J8HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0665/3318] media: usbtv: drop redundant device reference
Date: Wed, 18 Nov 2026 15:21:27 +0100
Message-ID: <20261118150338.044953384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1f7620cd2996d..4925113af9603 100644
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



