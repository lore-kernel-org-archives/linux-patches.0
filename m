Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043075;
	b=GXKGPNZRQcOusnUCzh2fAHWHl+UhKFcalHOQz9TM9tcZR1hnqQTAPXYBEhVkXR/MyfuU
	 hjKnyncxe2sY5HK3B5wYIQpU7ZGbDV1Ce8T8kTrymF5pg/6j15n2YAltfaCql8/xRuTrI
	 CTIIl+D0Oheh50ySDVECWv0FvVTEcPwZ48vZ7IaELyKhBFbf1kj/Bm+Js951nJUMQs6S2
	 nGI1xX7fngKrIJ35aDZukFLzg3ba1ZZoaaSrQMc5Q3qUnNx33p5gm+seJGTrJHwO8mqzA
	 efPKY9oa4GP61JyRwtpmK/Hd+jovZwOfZuA+yYJm7gMyxlQLprMyV/vzXA4RcaM12NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043075;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=roxS8cRYGxf8HcTz2mSuxS0hMNMAg6p7e1VDNUBSnwA=;
	b=hTtj+KLrYST8/N3stNhiDoZKkHKM60tEBtm7jbQvOSr7JoaYRQWOLrPNs3e8esYtJFMN
	 OiI9NDMLWTEnqJwX+X/1JMcw+78jyCNwCxa91pUJi9E4cD33Hg9Ce5+8nOE/TRPFrcbUb
	 BqBZwhjtu4233UUrAuAcNeASq2rrb3t6aJZbxg2fM2ZtGHa/RPhNLhPqUROa042zRJAwX
	 x3Rk80o84lt2/jhm5Y0DOZYoocmFxo0HRn9ZZJe37E7A2sTLe7oK9UJn6EleMQb+g1CM1
	 zVDOTKFigy140+w3uO/G1cijDx/Gyh75PT31pvtgOy41itwTdOy032sjdZ5ZJgaCGWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNzRli2v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6860C606A32A;
	Wed, 18 Nov 2026 23:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iNzRli2v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3FA1F000C4;
	Wed, 18 Nov 2026 23:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043075;
	bh=roxS8cRYGxf8HcTz2mSuxS0hMNMAg6p7e1VDNUBSnwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNzRli2vdDoed1PyWTZ+6AgCWvYxkJI6UVXB/+4EYTlzUn/3EV1Mph0wTmlZ1TuyV
	 +xeLk1aQFxVO+ElYUouhA8AVK1ZF5dOp13G0SBXBdvv8yg9dMqyCLncisxaaCgXHuM
	 xSh1NeeVyar7oUsHcL2QuIhiCoZdzCVacjkh9qRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0081/2857] media: em28xx: requeue buffers if start_streaming fails
Date: Wed, 18 Nov 2026 15:18:35 +0100
Message-ID: <20261118150204.209296724@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



