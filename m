Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057794;
	b=FsVo5HTBT5zU6ZGNHOKVKC3gPjHOrqEWnMPhmpH4LSIGkYmmnzDgDn9G5yzgU/8QOsTK
	 QcshPq2PnlD3SAkCxJNUDp7tvon0fWKJFVSZCORz1sn2zT2XrsraAwdAYs0BCZ7PFpSrN
	 Afx20Jcg8YEgqlsTF8/1wkn23R4ky0Mqo1zrSfRdxpzAFkJ+5m0ZZWMVC8XYVFZH6KcWQ
	 Z0P9JXD/FLtXA2XSTxQzTWC5QOKVGy4zbIh2feaVn6lAw+a5PGlrRJDCXtkqQcsf/xt1w
	 3ysDGAVpaBqziDImnR7tIMk08myFfNjEsGMnl23FRluel0+tLth0EpjJZpiT2qG8arQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=txMcFgSBm08xKll+HVs3i6W2mgprePYmFVPywsPtIsY=;
	b=zgRhlvzenRAfbUQj8yLI6wQyaeC+3ea67IqaveLHl0uAQ72qTWfX+XPexKxaMdRBRx82
	 CJFwkw0KTDFSzJVqXAYacWjDZ67DEFxwVtlmIplSMddUJ8MCEvxWbA1pfUwSrzBrJvysi
	 Cza1ln8kYEf2KJjxYG87CfpdF8M6EK3vHFoQ5J3k0nhveR108O4SF8Gwr3VlqnE9Pf3QN
	 KmPy5Fy+oJTrrZvNxVxyycDnODn+VAE5/cKnzTmqo1c9/XJDIFPIlDLEdlgV9tOPhRNfM
	 F9gm17rOnIkiCs8AMrZEKfdZMw5X+VBLaKJTLQxn2jCeG9YiHJg5GQ3WqXJLFLL/1DA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcWYrcrm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E54606A32C;
	Thu, 19 Nov 2026 03:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pcWYrcrm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D871F000C4;
	Thu, 19 Nov 2026 03:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057793;
	bh=txMcFgSBm08xKll+HVs3i6W2mgprePYmFVPywsPtIsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pcWYrcrmiwSkp7GFQ74gBTPh3tMVh3GCPXvVJg3o+c0W6zhCRQUp2l5POaCMUzf3k
	 PJWTQa3zWI6cdu/SeQ9idGvkkiaynIkFIaU/aR6SkENq6OTLpWCUgwTZsQKJ02H7C5
	 jp23ePOOO/eYx9eQRSLCf2/fIZRKKJbwTbp/eUVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0255/1848] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed, 18 Nov 2026 15:38:13 +0100
Message-ID: <20261118145922.857409090@linuxfoundation.org>
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

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit 3dbbbc3cafa2de377d9b97af4e35b8b6b5282047 upstream.

gspca uses vb2_fop_release(), but gspca_disconnect() only unregisters
the video device. If the queue owner closes the device after USB
disconnect, vb2_fop_release() releases the queue and invokes
gspca_stop_streaming() at that point.

gspca_stream_off() calls subdriver stop callbacks and
usb_set_interface() through gspca_dev->dev. By the time the late close
runs, the USB core can have freed the usb_device, resulting in a
use-after-free. This was observed as a KASAN use-after-free in sd_stopN().

Use vb2_video_unregister_device() so the queue is released and streaming
is stopped synchronously during disconnect, while the usb_device is still
valid. Since the helper takes the queue lock, which is usb_lock, call it
after dropping that lock.

Fixes: f729ef5796d8 ("media: videobuf2-v4l2.c: add vb2_video_unregister_device helper function")
Cc: stable@vger.kernel.org # 5.10.x
Suggested-by: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/gspca/gspca.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1641,9 +1641,8 @@ void gspca_disconnect(struct usb_interfa
 #endif
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
-
 	mutex_unlock(&gspca_dev->usb_lock);
+	vb2_video_unregister_device(&gspca_dev->vdev);
 
 	/* (this will call gspca_release() immediately or on last close) */
 	v4l2_device_put(&gspca_dev->v4l2_dev);


