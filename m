Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034418;
	b=hdF2Q2li6Rkghz0LlDrkYcv+DV+giQwI7UnZWSKUgc2jhknRsLDtK7bbxJ7lR7lDKVHg
	 daOZDhJtPbFG7BlWrOsSGna88Uh3FhsnwnatmdoyYtFlq1O2RLCYNzKafzS9EYOzPmhvo
	 sV9LH9IxynhsG8s/kqxcoUSkXADfTsHRh+Z8QVa0J3NoEiciYnCXlygLwpBpyaZNtasJn
	 VZMzQk53RfhrGcSTgQlEcJlSZ2woG2ax5WhsARvnFBrYxI9sIE/m3JzUX9qJhzUKjU1hu
	 G0HUJ2jr9/FloyZfnnwezcl63v5U4RloPBodS3ofgVkY4iHvIS3QGb9Zt9wqrLf6ipQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0GZrm/hKfmSysS5gC4ygHT6C4ef4Z6jIrlvyfw1ZWM=;
	b=kNChEFYwXIg1xJIwu1zLaPuGW9D4KNRo/Mpy3usvmYLCMQ3uoGHvMK0YpQC6CoD+g6uZ
	 /oK2mj1ebViY5lZQIbBbhhsObIvLFN1dnDr+BRZu0zmW7AQpUBJWVeUWC1eJHNJHA5twm
	 38h5zUBK1EKMZJ/jBbyAfQKxsaPjemNimnSBP/PHMBVHdtJ4OGAy8apPt93zHCjZDIA4n
	 iVZO084B+XnHNoN3M0I+47YCzj5u4084cJqO4L4/HEC/TTW0gLWVY/JawrzhaoRGk4TYH
	 m5rF08sR7XzIp3ay8RE1rwcQQVTXu6l6m/7o1zmeXYYPRo7timrR/I7oxncF90Ey+oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPTqOt67;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6F1606A335;
	Wed, 18 Nov 2026 20:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPTqOt67
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3FB1F000C7;
	Wed, 18 Nov 2026 20:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034418;
	bh=z0GZrm/hKfmSysS5gC4ygHT6C4ef4Z6jIrlvyfw1ZWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPTqOt67lJ1wv63m/xlycAxCh70GPuu4407abuJeZ2b5GJD+SIQnjfXwuwJTX36kq
	 Qmk2+035G5c/dQZH48+j9yx4AyZRPq3Ab/cLeknSTSl1mRMuBinWQfk7C2l2ouUqvH
	 hgA6YeEKtqG3S9X95BzWzN3UYRXBW7iWTO5NIN4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+9782320f78c23f40@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0361/3318] media: em28xx: reject audio endpoint with zero packet size
Date: Wed, 18 Nov 2026 15:16:23 +0100
Message-ID: <20261118150326.969427178@linuxfoundation.org>
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


