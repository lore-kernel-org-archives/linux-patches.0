Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035143;
	b=IPspIVrWq0Dz+o4HqLhLgGZ8KV6dG3AoRr/R+kROndjKQiaFoONRcrikypD2byw7fxJt
	 3CkjON8k6i4p1LFG5j55slMPbPrpVHjUomnFmp8839sgcZy1R5gRLzFXEEoXV1oRhs+A9
	 4RhWWhUZ8XJurb4xGUs11TupbiYb2999+FGU8XlFWHMFDQq/SBXfqrdRvB+TXkpbxHbml
	 kGiKSDiHzXoVnLqnXGk3Ajw+QrQZfLQDcewt4WdEeAjTVsIWE77HPxkn9VYhp7BpFxYPH
	 tq+kVCM4TNImric0MVMVafE3tvChpOiYhJIBunKjZfZShcidIzCn5Vkh8r7Vx6H2P9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o0sKzjcqA6NlGiJXOjtj/MfNzozQO2vY6Ki/6eofL6o=;
	b=gX8QZobjQBFyASwfdLU9ma1j/ouy641kmCcW9osbumDUQ5ZeecgJhVupG5ajmY7xKQgP
	 OtT94UXfzdii0Gld9dAPt6giwheZRC56uEqQg7VTIF76oDXXY53u7hHUFpmdGAKVDfUyo
	 I3UG+RzqNEOcHegS74wApFa/wPJB1TIvxO3qwXjecbnj1K5slcbT1WaG3g/UVZ88TQTuL
	 wpQ6ZTqhlMwoQqz3TJgF3mJHDwlXXzPnc9uK3+MQ/PNuZ5EA2V2kPRYFPSXgkja/+STEb
	 P7RUOctYgzWsQ9luWAwN4uaG6MteOS8knZFMyMHmEMXwWIS+2j4osSKW4cZq5PjKTXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yxe/J4eG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF21606A31C;
	Wed, 18 Nov 2026 20:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yxe/J4eG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FAD1F000C4;
	Wed, 18 Nov 2026 20:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035143;
	bh=o0sKzjcqA6NlGiJXOjtj/MfNzozQO2vY6Ki/6eofL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yxe/J4eGb1We8UpfEa2GC9ZbTlRLBK3qS2EBsCXEzko/ov45Bf6tQHPzO6l1gW9sk
	 WCV31I2FYZDdvZ91hUwIfGzKnYvEM9rdJcQLiN3t2zIQbnihvx67tF9MkU9nVJ+1zw
	 kPIHJ9Yc/d3IXhWcC6FLsdiBrqp/BknBbgaU0DEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0620/3318] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed, 18 Nov 2026 15:20:42 +0100
Message-ID: <20261118150336.425882798@linuxfoundation.org>
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
@@ -1643,9 +1643,8 @@ void gspca_disconnect(struct usb_interfa
 #endif
 
 	v4l2_device_disconnect(&gspca_dev->v4l2_dev);
-	video_unregister_device(&gspca_dev->vdev);
-
 	mutex_unlock(&gspca_dev->usb_lock);
+	vb2_video_unregister_device(&gspca_dev->vdev);
 
 	/* (this will call gspca_release() immediately or on last close) */
 	v4l2_device_put(&gspca_dev->v4l2_dev);


