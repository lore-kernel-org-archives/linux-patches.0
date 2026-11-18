Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057841;
	b=XFT9nLTOewzglG4MPQHEtzh4NNMBiXzBbXKLy7gGzDKX39LTTxTiA7b33+WFthW+xxaZ
	 5w+X5s6FqSBopH+D3VqY3hsFZE39gJs/QCW0fM6qs4KzzLQKUOCxeKQaUZaHX7twNmj0f
	 3aQ/NE10R67Fvd5dPqBgowQeb286b99yCfdaCqWR75FpyBVCbHCTvzHynPdKCSvmdAWkN
	 9T45/RO4roQ9wpvdfhx3tirimFfw1ChahLh4i8LWrHPHzuIa8PMnLwY6tK4SziLe6vk60
	 5GMwHraWbM4DQ/dQawXOJWaCBRq6BBpTNfhEohEVkEJkka4UKtxeKHdzw4q3iQMceww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vj1zREwvRGOqp/62AloO8Jan/krd89Q/Y17fmcGYuMk=;
	b=u9Ax1GTCq+cBx74PaLxg6BzfDwTHkVX0aBbZ9bhuujJLnLuuqE1HYOAcmPrSISq8IVaP
	 QVqioGjFhTY1EWKXg4BuafGhYNxxrnX3czXK3Yzpwpx5GzqEflPopVRsbASX9rYhGqR6r
	 SDYy76amLD5P7fzC4NIx4utU0nshShuJl2XXKJdLVHBxL/vkHuNMln9cwoVTmE/pvnBvZ
	 1+v5ugYcVw8fXeXs5SOBU+BOX5l9wdY4xQDs2RB9A3qwPw89vYKvVf1/eat73l5CwXld/
	 73Efvb8LlVzHMcYpsPJAEJPJ1aj4IYanNZ6sqqz93Qiq3P5RxgEUOt4eSxHF/doUH+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yu6S1jyx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83ECE606A31C;
	Thu, 19 Nov 2026 03:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yu6S1jyx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9DC91F000C5;
	Thu, 19 Nov 2026 03:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057841;
	bh=Vj1zREwvRGOqp/62AloO8Jan/krd89Q/Y17fmcGYuMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yu6S1jyx+Lnh3gWPx1soTEa6RTrqveilF/n9kbVa+TQSpmLI31gP/TWge3jcYRtEz
	 oPBesYHcFABUOZpCEBb+BU3EEogsK6X+mXsWAZ+0d+yFtRu7/o1Si4N8+Lo+C3qV6V
	 MS4uGyPlg7Wy5MpdHfwxI5xBWMg30eRY8Ncujycs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0274/1848] media: usbtv: drop redundant device reference
Date: Wed, 18 Nov 2026 15:38:32 +0100
Message-ID: <20261118145923.727227908@linuxfoundation.org>
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



