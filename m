Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051056;
	b=oU5hJi9X8VW0XKvWspqfcql8lDvt5tmsmsLD+wpEyh4CzwjWsEPXB0ID/IGB0SK333Ue
	 BEF2mP39VvnTY7ZUddZlvWUjODID7apEaOSpijD9Hs5cQKcYWkib6zE41dfh/iCbrjfsE
	 L6tCoEMlJGWO9Rk4nGH8nK/6TWOyGz5aGA8X03j/rC7Uls5RK5Huisq2KfE/QrhXvrPym
	 RwYOW77I68Ya/4CNRcWWF3lA/3Z3YW8NyUXlTeAPwcUyErsjcD2itZ3pavFZHlRQsIxCM
	 VZSvG/ptRF86o9CVknwbIzYTkGbjVcFbc8zGKkCVdH9pkpxu8hODhDS9F58R8gIg8EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051056;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZX+8JG5uz8Ivk3l8y0N5d2OLXDjHXvGsbvNL5VAGzps=;
	b=olMDZTYAo5zdoD+730SZP+ZVDkfSG2oC9C/oQa5YBCQ2BMuFNThoTBLQD5oNALEnBLTp
	 zkN1q295pugVhiJKJt+rSdvgOSsrpfV7lTdt2dH94x4bGGgGbgfPTjqGQlHNgOq3PSt7N
	 Uu09IXpUZ9khrRkF3/xQA6W8+DKNthD+cAECcZAAGHb0vJuMkCCpn/myJFv32LBExTpQ9
	 1KEWpy2NSjpFBooHn/NdcVZvrtMDrYOf8xDyQo67I2kdhViM3xWcoQZIVpEcj0DZfGdBt
	 Eooxn9L6iO7Nqpy+uxAaH+7QwAM8zoGn8QByi7ruhatW1BzVPuWu33qQlhpo+xbJ5BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vn770ss6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9FB606A330;
	Thu, 19 Nov 2026 01:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vn770ss6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4671F000C5;
	Thu, 19 Nov 2026 01:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051056;
	bh=ZX+8JG5uz8Ivk3l8y0N5d2OLXDjHXvGsbvNL5VAGzps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vn770ss6U56mOdkQFGlCkjcM8uFg9Q9K/n482KGguSWkZn7FHqPn+CJh1QX25pjZU
	 vfvaDXMcwuJ5+Ak85HOUMtto/kG9B/cLuNWt2zAHLEJa6IkXuTxHGqs44AG56HulEb
	 7CHRzoijOHdsW7jDwWhcV+Qj6EPP57/8sKG1LImw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0072/2214] media: em28xx: requeue buffers if start_streaming fails
Date: Wed, 18 Nov 2026 15:29:08 +0100
Message-ID: <20261118150012.862872655@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 67f87b104f4ef3108607ac9d8fa2075b13ed314d ]

If start_streaming fails, then all queued buffers must be
returned to vb2 in state QUEUED.

Otherwise it will trigger a WARN_ON.

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Tested-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index ffc7ae1ee3a9b..15f90c25fab2b 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1080,6 +1080,9 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_dmaqueue *dmaq = vq->type == V4L2_BUF_TYPE_VBI_CAPTURE ?
+		&dev->vbiq : &dev->vidq;
+	unsigned long flags = 0;
 	struct v4l2_frequency f;
 	struct v4l2_fh *owner;
 	int rc = 0;
@@ -1094,7 +1097,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	 */
 	rc = res_get(dev, vq->type);
 	if (rc)
-		return rc;
+		goto exit;
 
 	if (v4l2->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
@@ -1117,7 +1120,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  em28xx_urb_data_copy);
 		if (rc < 0) {
 			res_free(dev, vq->type);
-			return rc;
+			goto exit;
 		}
 
 		/*
@@ -1142,7 +1145,18 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	}
 
 	v4l2->streaming_users++;
+	return 0;
 
+exit:
+	spin_lock_irqsave(&dev->slock, flags);
+	while (!list_empty(&dmaq->active)) {
+		struct em28xx_buffer *buf;
+
+		buf = list_entry(dmaq->active.next, struct em28xx_buffer, list);
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
+	}
+	spin_unlock_irqrestore(&dev->slock, flags);
 	return rc;
 }
 
-- 
2.53.0



