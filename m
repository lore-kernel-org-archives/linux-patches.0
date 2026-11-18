Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057674;
	b=0oBsigOySYWxaiy/YMlJ4ZCFZ6uWdd6051SFr7AdqerOu2HCGPqe4Ke8TR+Pcd0M7Hxd
	 chCXA6Rup4lOpqk0TtLUti5KFHTP0JSmYpz8f1m0ioHAEKPZ5YGIbXkUmJNKlsBnmd9m/
	 0etgHdBg7lK4lQJ/KPgVyIUEkpNth64WgidM0s56k4aDPZR/qSDwH+pgn+To3Uhrk/ewi
	 ypeDM1Km6K1LxTEc87zteVJw3Y/97VeMW5UaxBq3z0PlrpZP02Po+ojoEpvpHScidN2qi
	 3bxcjSdNQrhDoJdiB053oNZHgOrJhSXL4wGK7ILmppmkzQXYo5ObqRGgbedQW0fBjCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4sv8+GDOeaG8SSKSiyGciP06aHI2WfI3Im14e77dCqQ=;
	b=NX7nKPu3gJK9DEmjRfdjNFDJyuG8xYiSnWa8zVinKnOSrGcHbZWTpyMlXkkq//UxRqqm
	 SDiKtThhQsGdsdpCWdFtdyk+xfIaTWC5UTqh+oA0ENvJehLvptUQig7FAxU7SBL4NYgTo
	 8YXF25+eZa/MQZRIsNLh/E7IXzHIByn/enbM05rKx4Zs7bH7yyJVrUlzdco4cALt05DuD
	 TYCpJPfLzXhsB9IX2TzvR2oJA16a6ZHh7QM2USMHT2Ob0RpSUP/9d3yYZU4VnHlckYuzs
	 kJ+sNADNYB4ZlLG9Cc6h4g8D+4tJY0854zLCv1hXALrAgGfOwhB9UqEJvxLW9XEGIdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4b8mLiU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEEF606A33E;
	Thu, 19 Nov 2026 03:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W4b8mLiU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E681F000C4;
	Thu, 19 Nov 2026 03:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057674;
	bh=4sv8+GDOeaG8SSKSiyGciP06aHI2WfI3Im14e77dCqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4b8mLiUASZ1YasbG6oDH7VWPNvdDrypla4+Q5F6oWuc96y1n14h3zu6I7FGjIU65
	 7FP1ef6GxMHFxxGZ8CHKKcj7Y2XumgZ8ywlNCsPwv04PZSlqHd+lPoti6X4G5MmVgJ
	 XKF0ITtRvvg/D4B3uHbxxyUEqCEW3RiMEK57o0X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+9782320f78c23f40@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0213/1848] media: em28xx: reject audio endpoint with zero packet size
Date: Wed, 18 Nov 2026 15:37:31 +0100
Message-ID: <20261118145920.952568007@linuxfoundation.org>
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
@@ -703,6 +703,13 @@ static int em28xx_audio_urb_init(struct
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


