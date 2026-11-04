Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831144;
	b=hdmAFj0R0FoaeuDJWlxPtH62z7eXNZwOCKu/st8wYZQarSaugoRR8Y/YK8NKTSBAYAFt
	 ZxIpJaj6IrQK+GfHKjvBA1Baa4miNCIRfKUQsaLzlfrSn5GALuRdJPmsiJUIy3n5PjC6E
	 NOm+nWeYKIk+uJKXzg7wFF/RqeI3idnavawoffvSzC+2PLH9/HdLY9bCb17glASaJV3/R
	 6BekissbzDRlaDsVVUexQL2gYceu7lO+BqbQTRJRpRppILIhlrljmmyS50a23rpCQEEqA
	 MkNGi0WP1zxPn2z8z2O3yIlvd8mZuGy/l3szm4Qg3lHsJPgW4xVcN7cz95nUZMH9aFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831144;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OhZRGeiwDpTDwjI1ZyICVNUQn2ok8GEZWmOClfYZucY=;
	b=ZRPMvuYWymqeCeCRgEK0YXx/xb7oa9CtRL1YYj1lZsBVuO+3Vy0YGyMNOazB8rBTpDoL
	 zqggrzkKkBAD7RF6RTfuQon4i4hwjL2Q9PKjapjkrGUEeXCUvWMcUn0uWOiB4WWMIxBwK
	 Cj4L2b1s983aBZmhZZSf92gSFmz3Qpu5Eml35x4lpFS/QR6iuQPzS6F42P+RcaYyEztnX
	 +gmGDlEx2iJ17eSfjlbsfg+3CoCjT/inYQSMVk4iRfrvpwZpTH7j15UDf5NxyEssqka2Q
	 f8f0SeJoPk4oPShHBgfH8nwOPvaGxtQHeBHzylwnMXM4G6IVGpoj3SdU9M0+Y/rsQEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDhXx75r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47605606B3B8;
	Wed,  4 Nov 2026 22:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qDhXx75r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68221F000C1;
	Wed,  4 Nov 2026 22:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831144;
	bh=OhZRGeiwDpTDwjI1ZyICVNUQn2ok8GEZWmOClfYZucY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qDhXx75re2+w20PZivSVzOU3rslYl+tStvPUcxx8IQA9MGtf4EfD2dw6O46n8c3Ai
	 DWaPxGGJ7OgSyaWCs4pb+dgK3JrUTKkPuU1OpEmFgCeO+vq/DteIxarPU3dmNMQ6cC
	 9XlLVY3bCK8xhbWTDD6sFJJL5mbK5kcxWrt5FpCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+9782320f78c23f40@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0524/1005] media: em28xx: reject audio endpoint with zero packet size
Date: Wed,  4 Nov 2026 16:04:17 -0500
Message-ID: <20261104211058.594848666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei <xmei5@asu.edu>

commit aebfe430ba885d2f8fc882d7a6d60a7fdbe535d8 upstream.

em28xx_audio_urb_init() divides by the audio endpoint's wMaxPacketSize
without checking it, so a USB device that declares a zero-sized audio
endpoint divides by zero at probe time.

Reject a zero-sized audio endpoint like a missing one; the caller already
unwinds on a negative return.

  Oops: divide error: 0000 [#1] SMP NOPTI
  Workqueue: usb_hub_wq hub_event
  RIP: 0010:em28xx_audio_init (drivers/media/usb/em28xx/em28xx-audio.c:718)
  Call Trace:
   em28xx_init_extension (drivers/media/usb/em28xx/em28xx-core.c:1248)
   em28xx_init_dev.isra.0 (drivers/media/usb/em28xx/em28xx-cards.c:3887)
   em28xx_usb_probe (drivers/media/usb/em28xx/em28xx-cards.c:4258)
   usb_probe_interface (drivers/usb/core/driver.c:396)
   ...
   usb_set_configuration (drivers/usb/core/message.c:2268)
   usb_generic_driver_probe (drivers/usb/core/generic.c:250)
   usb_probe_device (drivers/usb/core/driver.c:291)
   ...
   usb_new_device (drivers/usb/core/hub.c:2703)
   hub_event (drivers/usb/core/hub.c:5961)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3486)
   kthread (kernel/kthread.c:436)
   ret_from_fork (arch/x86/kernel/process.c:158)
   ret_from_fork_asm (arch/x86/entry/entry_64.S:245)
  Kernel panic - not syncing: Fatal exception

Fixes: 1b3fd2d34266 ("[media] em28xx-audio: don't hardcode audio URB calculus")
Cc: stable@vger.kernel.org
Reported-by: co+9782320f78c23f40@bugs.sh
Closes: https://lore.kernel.org/all/51lCz4R7QyTUKbh4mhXNaNzX0evpk0siOzbh%40bugs.sh/
Assisted-by: Claude:claude-opus-5
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/em28xx/em28xx-audio.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -693,6 +693,13 @@ static int em28xx_audio_urb_init(struct
 	}
 
 	ep_size = em28xx_audio_ep_packet_size(udev, ep);
+	if (ep_size == 0) {
+		dev_err(&dev->intf->dev,
+			"Audio endpoint 0x%02x has a zero packet size\n",
+			EM28XX_EP_AUDIO);
+		return -ENODEV;
+	}
+
 	interval = 1 << (ep->bInterval - 1);
 
 	dev_info(&dev->intf->dev,


