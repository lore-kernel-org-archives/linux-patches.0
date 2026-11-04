Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831532;
	b=o6w2vly3NKQ0AoAlzsYtELEpsTrKNbUfaeYXBZf1JZ0ELarKzJJJ77Di40XZlgYn5YHD
	 +phgBXJGILyDXd3tIWq8OKmCBi2mLaVLSB7skMYcBm5amdxSaZJ0hMKmi+qdUz2xgBxIQ
	 zq6tsJHwb3ivTWn2AicE+EzlK7xUqUOsG37wM3z0wmqn6ZddM8Qp5Jbkk0eqvxM4Bg92G
	 o51mUr2lhKuG/xNewp6ss9ZyG/nMr0qDZUuCORo5kdDzxsG1pXSEIIxtBVk1eCd6NAnsO
	 gp73EeKWO1HlWfL3fq+AbdaMI7m+xipwlVGRiZQMoZaeM/bd2mUDmHPeborCVsohjGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ciO/wiJ0UwxYod6kL217YeKN7HAJUS/DmzOB6GANYME=;
	b=QvCwudO/UfRyi2TMmFKfJCG2HG4WGlbP/56qe0yEpGHGRMbohQMsEIvme7kwa8tluzcp
	 VmIWTc299etIF4JwEwlzjketVP9aP1qkaOIVsOnJEh6SpSZpIAlO2Gi+VbiH6iRLA2xlm
	 zuwX5SVBfNDt9t1DHO8RUgiO5XzTk6+C8epmN4Pkwqk3hqskvcfDq1V3JiJStCaM8XUYM
	 1RTCAVykE+PuV90d4XrcxEt/cUaORLNOn4/lzrHhgtK44sotFzQvjAkdU0qVORbTrHT+J
	 okigHqrh4qZMIUe+s9hpx3Ho1c+64uD6X+g4ooGM1gyFDnNiE6OmBBXZYRPGnb4Gm7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZAHJ57Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902B5606A859;
	Wed,  4 Nov 2026 22:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TZAHJ57Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBC41F000C1;
	Wed,  4 Nov 2026 22:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831532;
	bh=ciO/wiJ0UwxYod6kL217YeKN7HAJUS/DmzOB6GANYME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TZAHJ57YPb+WWHCF9Vr+iChwJjnZKoFc7t/kH3ApkPjHpha9prTEkP7sCP/Eq2Y07
	 MfU5wnLkB/swHTHfR1J0tCMIY0ZSbx3eh6LuSBHTiCwwV1JAY/JcotBb8nX7M+9EXe
	 wacb4alG5UHPE36aSnOPqnJVALviJAbVAQlZ0M18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0722/1005] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed,  4 Nov 2026 16:07:35 -0500
Message-ID: <20261104211103.739494861@linuxfoundation.org>
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


