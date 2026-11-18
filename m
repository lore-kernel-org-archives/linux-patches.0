Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033679;
	b=aNrtIfaLFbFsh7N4UHhFC6U4kNPH90uRBrQELLZ0azbXx7EBwkIJkcG+w5sOO5fS96FG
	 rJbfmag1IGQznjZwS0XmP3d0dCcQaHWO7CwRUhDpdrOmrYIBV1C59U+VC1RpTg/jI9cbn
	 vJx5+TWKHSJO8RJZOHO073MOseGTpAurRfu7tEzeXCv40G6PSkFoGG83vEM6sZlnjXwIK
	 5vd3AwNduI3db9CE8YkfISXevlIWsZ82IkWAE81ixJ3m+3cS/pf3gvO3iPNY5G+KVgKCN
	 mVw7EDvmFxJnEdtOwnKL1PoPCDPxoGI5BOPVIg4k8pY2O7X2IqQfcHGKT0gfLAsVMFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033679;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6pFNBbm3yNTrfMbM3mzoT8qp8x22ph/ctvU/505QnYQ=;
	b=vWu/fyxFSbVuZvFU+MesaXmMVJE+yWsZhjrIpDmvPZaXsviVGZ6bGVIWOX8GLqt+sE2r
	 mYGtAdNQU2mrRgWKDXHTsif27l6PLkNYmBsZFt9b58fN/l5N8G70lrWIBSw5GLv4v5LE4
	 pzQ4d6Tq3G9/Eo+w7V8hFf50mGgKrEwbzHvqwYMQEQoRmFkQn8p+NI/KQERG/NT81FF1v
	 QZVu96D9Up5ZCs0gMXbNHv86NhGnZV7CiAnwW8vYLe/FIH7Fhy+OPa6RbN5Ir1Ls3AvTH
	 sm7Xe5lOcppOxBwQCdaR/iwOdOXVGR0YyRTrzQ1iXekGwZawEDSjM7AK7DD0mRb491w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xs87Aata;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85337606A320;
	Wed, 18 Nov 2026 20:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xs87Aata
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992511F000C4;
	Wed, 18 Nov 2026 20:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033679;
	bh=6pFNBbm3yNTrfMbM3mzoT8qp8x22ph/ctvU/505QnYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xs87Aata9hjfiH8ZvbUCkifhD3zmMRpkmE1s8fZz2qFcLw27PXOxjwlp1VUcpncXm
	 wGi5yEfhbtP5IQ/Ja4d2z7mqSeA9/Q3yWWLrBBYBman++VNFuLLDKhwGQwR/wXTIb/
	 O0E6mNIEYpcBoK5TGj2jTLUVRzi5Ok4aSCgyYswc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0099/3318] media: em28xx: requeue buffers if start_streaming fails
Date: Wed, 18 Nov 2026 15:12:01 +0100
Message-ID: <20261118150317.180878308@linuxfoundation.org>
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
index a520bec031248..6ac9ad5aa25f6 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1070,6 +1070,9 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 {
 	struct em28xx *dev = vb2_get_drv_priv(vq);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
+	struct em28xx_dmaqueue *dmaq = vq->type == V4L2_BUF_TYPE_VBI_CAPTURE ?
+		&dev->vbiq : &dev->vidq;
+	unsigned long flags = 0;
 	struct v4l2_frequency f;
 	struct v4l2_fh *owner;
 	int rc = 0;
@@ -1084,7 +1087,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 	 */
 	rc = res_get(dev, vq->type);
 	if (rc)
-		return rc;
+		goto exit;
 
 	if (v4l2->streaming_users == 0) {
 		/* First active streaming user, so allocate all the URBs */
@@ -1107,7 +1110,7 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 					  em28xx_urb_data_copy);
 		if (rc < 0) {
 			res_free(dev, vq->type);
-			return rc;
+			goto exit;
 		}
 
 		/*
@@ -1132,7 +1135,18 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
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



