Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060691;
	b=jUhBtljePaT30A01Bw9FC7n4AYnsokZ6PZtwEiEhyDetN4j6fZc9MD3nOsWuhG5nKVH9
	 JkNSXDkAu8XSu8KLleeGQ1IIgK9PINuR9Cm8zHPe2TAcqhORyMWPkLUUAPdHbFsxSZ9uq
	 gCsWo7bi8AYd8sQwI85CTb6uwCcuzqNuRSj5sIpwFvv3VMv8aOVEAJQgrEm+8K+t2Orh+
	 yyjjzF58v/z4x3YykHB7ZG9p4zVyTYbPgkzQpXWcGvbDVaeycxbClTl7w3ZPadJ0Rjc6I
	 uKouj+/O7ts9980HCs4DS4JiNT24SP7csOX5oggIAiO8fiuJnQp/7MMwGnr1A7PpKmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BRVOuU6BC6N6ME5/WHipa/0YcXxqIS7SmEMiS3X2VF4=;
	b=fn4Z/YsUqhEquVuPZlJQoFvPMQabA9GUfVlgNQjDOlDTEiAcMt7N43Ulo/L/odTHUTmy
	 Y8Cdr4TYFt4eftoJnyPSf+z/4CaptW6703xrPHM97vxHGvtCIDTZ3VwQ6wf6Z1jxapJdr
	 J/yfc6Zzyd2CGUXvJ2Y6Y6cjeWiA2B7nmv5N42BEOwfNldZdWZ8dyOi2o5ZFJEk3aiTEG
	 WS93bgPssEQ90O+shwyNfYovooJ2ZeguSWBzKl1QPXYOdxYgEAm8V1Jve800XC+kBMu6b
	 OIylavnkthY5FOInNuhTY+2H2i4iZkeUQ1IPpJWMb8tZ4UJZoMs/laxdQoM6eRYJ8mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nWvX/qzH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE7F606A326;
	Sat,  7 Nov 2026 14:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nWvX/qzH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5603D1F0089F;
	Sat,  7 Nov 2026 14:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060690;
	bh=BRVOuU6BC6N6ME5/WHipa/0YcXxqIS7SmEMiS3X2VF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWvX/qzHESLrAGp10O9u9j/p30INxzdLpYsrYCAlEOn/xn89Is+H6g5VaTsXSxSlI
	 Pc9x2Au+SnBEmSf/P2FdZp9FBoop982zJF/dzG33hNYojdT3x3T+1K9FwwHUOoc80c
	 qlrFKmsz0oDWMP+8ZgnxF/aUcMO5xHbYCg+60+YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0119/1536] media: em28xx: requeue buffers if start_streaming fails
Date: Sat,  7 Nov 2026 08:35:35 -0500
Message-ID: <20261107135001.028802220@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dd0cf2ebcc5b6..f044e1c325707 100644
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



