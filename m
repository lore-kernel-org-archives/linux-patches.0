Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051806;
	b=tQkypjZ0cP9kwYm0lsNLYt0BWmLgg94QcN/eZhC77fThN291TruiRMKXa/8SANQR4Vfm
	 stONE8itZtRl+yNhH6JrmvRwL6IWFx8HNqGbOcpQ28mmH8ICXSEDuRTyMBQEOS6IKPGrd
	 VF7yt3XwQP5mWZOrqsDM68tkV8ohAbIV4zJYNHn0ArnN1NIms8czeoQsfzXFTV/xPVM4/
	 YoPQw/ggYLpi9RnTwfBmvkbge426gdLwopuQpN4OUvlLkeic02mYhyBLPVMoGkZ5dYJr/
	 HuTODOhM+iERG4Se2//D9mXP3o2zhgJaG1uLfQkhu7yOWIJMFZNOOM120Ry9lBqbdWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ez8kJEMVwe3BpZfcPsMn9Os/7FlaEu4FLaf9F16YBSE=;
	b=mzBIH23ohv/Muvum39viJXfikv1ITDG3GmrGmkhUWS+wN0RxacxVUevOtivxboN7ZQ92
	 L1ZWXk4t8sSd3ETVn+bnWRPagBUuQMJvwIKvnAICSoMmXIQEwPsUE20Qc0D7l/tte7Wfj
	 CzLV511fWHNDlL7ZY/xmy9VrF1tadS6Clm9UyF0L+pQwYu2S1ohaWJK7QEbaXwVdQ8jRT
	 uy8rU46lga/oyzgrJszTPz3h23zfMRGWu6QI6WiPwS5uVGQ78lhfkFPkknlSFl/vyyyQR
	 9yN4umT2SgsDNkzEg4NoMW4pgqNRUxjPw7jqSAuVZt+K0gVn6K0ZzooI/orIyJaK0yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G0BVi/wq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836D2606A32F;
	Thu, 19 Nov 2026 01:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G0BVi/wq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BA11F000C4;
	Thu, 19 Nov 2026 01:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051805;
	bh=ez8kJEMVwe3BpZfcPsMn9Os/7FlaEu4FLaf9F16YBSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0BVi/wq7dxY5mYz8tDvHzM/7H+Op3z0cjjg+WWvB0/lR+Shc9ULUvoD+LADp5f0w
	 2v5MootAOSBpw9H/EoacLtG6epKnhG7bBQ7crt5w53qFUvcDif9B9uVGZY4tbfx65/
	 3lwY9LOHTiTf7j1TD0UKxUu2n4nS4aKS+B55uEzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@kernel.org>,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.15 0312/2214] media: gspca: use vb2_video_unregister_device() on disconnect
Date: Wed, 18 Nov 2026 15:33:08 +0100
Message-ID: <20261118150022.626995120@linuxfoundation.org>
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


