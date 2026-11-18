Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051691;
	b=3r6gC0NyVvFhqFto1dwgmbChAf2Dtjv1y1pDNkOS57ftoiW916d+6capoV5o7NbWm2W0
	 bzKCgAKqjMhevfSmjOujClHiU5COAMahQap2KhrtKzcOCMi1QazxSfnDX17HigYKg+yMy
	 eUGeXKh5EfLoGgpwhDgyRT3MGHcVUinGvPNLXAGE2fnq5FotJcoafAW3oyfX8yVlPE1+B
	 0JvHIM36qsHnPWjAOGY/ZFqeAAQBkTj4a7YarU4k4o5AjBKcLkoltwqE5BW6AWdSDMkub
	 T2WYYUz3ElhvUsgx47rnsNVnlkCZkUTXvkFgeGIw/PjtdI0dyg/rmliwtqwc7pkcc4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mDomTz/EHA1EP0+cF4Ge96wqZK0JWZ/UNmCrF+tzEZk=;
	b=EaJs6HzDLyvky7xw6uSvlWBoynnEXEXXLLyEgFW7DMYzKVnSbd+rWQ+Pl21LDETg3JJq
	 e4b/9fWLbUiorl/eNURebUJkyHl5S/D+jSCG+/FV75GqQ2eCU4Wz2hrw97uNzigj4xH7f
	 UfP6U/cvVI8YhHniGOIqkOxGYv4eZVpIf2R87dJ0nrk4hmBzHrq3C9itpcp6x7c7+hIjm
	 ybCXtvqxzCDFbg4XYXo4jdgfmmhj1YT0uNB/8lyBQ3RKL04HkUgLWtPmn5wG+Da5EovEB
	 V6Qz4Q3Xo01Mwq4kxRH1jumo/UktOdmtSEZMIp2ow/IUCbLHIhq1ZyNsHPJsb4hNC6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mByBnE1R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503A3606A31C;
	Thu, 19 Nov 2026 01:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mByBnE1R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98701F000C4;
	Thu, 19 Nov 2026 01:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051691;
	bh=mDomTz/EHA1EP0+cF4Ge96wqZK0JWZ/UNmCrF+tzEZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mByBnE1RTO0S67RVDiV4WAfkyZIdvtJPa6QHZl1kKN6bNtCSSpL9e7etUINi0JVPw
	 pf3D4HQg52GDF3XvT6XRVwhx9R+BssZfjvTsblC6pNuTFmtosFyxPfszkAKTa0O6sE
	 ioEyutH/L2Ot+CJtVMOOFDM4HUDBbuQP60Lmud0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+9782320f78c23f40@bugs.sh,
	Xiang Mei <xmei5@asu.edu>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0261/2214] media: em28xx: reject audio endpoint with zero packet size
Date: Wed, 18 Nov 2026 15:32:17 +0100
Message-ID: <20261118150020.550820449@linuxfoundation.org>
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


