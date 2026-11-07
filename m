Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061125;
	b=yc5fxh6IsVxOjz8UjJHDXBHoVTrBIDJUr3huaJ5/gJVNJjGYV3KyE3I60rMQ+gF2ITg4
	 VSfRQtXw6ulQ4vWa/VyHt/o3VrC9V56u5oi3Cn9MZvhBHM39Drg4RkbwEPYugStJND1hc
	 ekRq1fi5OppPx663o9X23GQRzV0E+HUU87g5f/vMJ/Uwv6pcWpGkb7xU32jxLq7FF/fmm
	 qZZhQqO3M83KMRZaS7m++aPUxHX+ZiuUQMI5YWPvpvOYQ6XRQ+ly7KI8UFBAZdSWkQ0Ul
	 UXiO3tacuHpJHPECBOOO4sYrkckcWatwv1zLRjExvzK4qLTbSJnIpVyjGSUyvXkMkBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ebuBq+S/kH8ts3UZjTT22VAgJfwLNwLYKGHY4ZrZ2uc=;
	b=e1c5yZxT1yu7sbblh1+G6IyJBhDO8MoOao4tYBDPL4srQluDV0ryopYvJlFT+NqUOA2c
	 jT+mC5BwxHsiZ6GR2SdhscK4i+c9mTPWfTLTOIK5ePrjqGalm9grR2wt3czNLxhsY3vKZ
	 KcAcBQ5yImqNGl7dEAQY6z7ODnnYK7ciX2dEz4L0nH8/or27zuZue6rZ8OrmuyVLa5xqC
	 sT1RzHHRrUPE/i0DKXeOx+eXlanHI7/tDg0J4O/DmoYf3i6W3ZR7dL1hjNqvWuawXbxZ1
	 H3blDwbVywE3YECyARna5v25PySQU7KPhp7kAj8hw+bRUpTNCI+6GGShBeQ7sKoj4bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8R+yuYs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8DC606A332;
	Sat,  7 Nov 2026 14:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s8R+yuYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89D91F0089F;
	Sat,  7 Nov 2026 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061124;
	bh=ebuBq+S/kH8ts3UZjTT22VAgJfwLNwLYKGHY4ZrZ2uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s8R+yuYs4p3yFlxuCTK6VX/KUZEigsZFAdB3E1GTFzK4EHI+e3AIEha34t9AGjoIa
	 fpsYdcCtMQmButhuPEAoLhDxrcKGqW88Cb4dEF3vGnIO2oK/jaHMZINNlaVNg3k+Q3
	 LbjmzYI/YtJKYtz43d/L9ZLgPB5abOtmNqeS6580=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+9782320f78c23f40@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0437/1536] media: em28xx: reject audio endpoint with zero packet size
Date: Sat,  7 Nov 2026 08:40:53 -0500
Message-ID: <20261107135009.830575217@linuxfoundation.org>
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


