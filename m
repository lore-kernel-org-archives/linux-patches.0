Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827217;
	b=OFp3fglFjnmvfJ8xH97sWLx10CVukxSoGsU3D4H6MEO5VbkW3F6zflpiQuYuVYT21SY7
	 j/GPJCR8AjFJ3ouRDXJK6gy+xrW5uBCb3sPTZBXGKf9oWgYT1oKdCJFw66Oqn9chwmr7F
	 tCg7Z076MPWYbq9uStQChNK3T+hbV5TwgxAofeolrI4sJ1SYjTX641gF27yqWyWY18IZN
	 A2Wbq6eQGXMLg94oakFNobrMQ9NuaBHc2fKjVykouw4/nN6RsHLQIhVVpsPqdTPV/xzZ+
	 /F7cL969YbFbx8eeVzz1NbwzvHKei6f4C4PtyJLO0fn1/5Fn6y6QDrAr217/TRJOjEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827217;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9i/rKKX179OYvB7BK8nmuNkY27UEhtKh78DgKnHsws=;
	b=E+wXgLJSZZeFHTfdYisDXS8T+tGDUSWgonpVlz7vYBhFcVASd1nlmW+m6uXA0wUTQcTI
	 YbXQVY9YfhwVSA9YLtYd03H4ND/Z05n7XHbV5DnnSodqzJr3zWs0TQiE5kf71ZlQexba7
	 ictlSg0bjqK7oN2aim71NZ8XkC6Ji8u2xKfEzqdWb78ly8pMetsyHS1yuJI+ImspzRri9
	 uf+qVYmLILYYXTlxU6bkJR3iEAtqiHBbdOQuFnGr9iyR0hTREK1fN7kayh2b/QFXwwWSo
	 P9jCkMXzNTeYQ1KAb/TVAXmyogQw0BKidCoqOww7xZ7N5uNQg//KpOnbRM7ghodQQpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kREk/Ihs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82359606B3AE;
	Wed,  4 Nov 2026 21:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kREk/Ihs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA881F000C1;
	Wed,  4 Nov 2026 21:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827217;
	bh=F9i/rKKX179OYvB7BK8nmuNkY27UEhtKh78DgKnHsws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kREk/Ihsnotn3FU0UsSUnnMLHwATwHop2/RgQtM9aUrfiCkymDJX3kb2szDaTYfB3
	 e2aIVB8pxv4rkUiZ0QFHB+5E2JJ3X9vaFSqsUBlRWDsABgOnJNbo4npBXd/psw3n7c
	 1bT4ul2PrMdYPCKq/cVhlYVwnX0sLnh3sg0Yw4yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 226/547] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed,  4 Nov 2026 16:06:50 -0500
Message-ID: <20261104211044.576470834@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1636,9 +1636,8 @@ void gspca_disconnect(struct usb_interfa
 #endif
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
-
 	mutex_unlock(&gspca_dev->usb_lock);
+	vb2_video_unregister_device(&gspca_dev->vdev);
 
 	/* (this will call gspca_release() immediately or on last close) */
 	v4l2_device_put(&gspca_dev->v4l2_dev);


