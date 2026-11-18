Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057248;
	b=Uyv4IRp8NefZauwQ4Ww7MfBtJvt1DoKUdhoIB+RK5IASSN7mMQfZ6GMB5f7YgngdJTe0
	 ZOMkkOSnzVvV28KW7IGmfdBonFx5TtsFw6FmhA5KFkFEe78AA88EopnPkU9SoogdjpECb
	 SIbr62UTFcyVugWkvO48OW0+UXVnnUvT5yU0IK7Pdujqf8T9fHkTz5PqWwJGKAlOOro0g
	 8qkvueViVgo9fVtfiDlnZSKn/OImLzS/s1rj5hBQvR8ALDjTgvRxzmEv85OzrDrkKHNSc
	 IJ/+2cOWnWCxvK8ts2nKIcQ1fsYVQWHU9zvEyWSAgvuLQZYPIfPIRrwV4FYZ74oQSJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DK/l/PEhjPAkWwzdWvp0Ylwxf/G+7lsrKK6FlRBoRFw=;
	b=4TwBs3nEOjr2Pp844kM38jSvwwQ4af75lU3WbOwgL73V6O+JzjUmgA+VhdUkASq1PZIk
	 7k7KlhBD5O0WYqg+F6ZmhyHmFoCHHC8Vd9/2ejIvwAYLpU4Qbb9BbfsPYa/Q6mkkOIbFU
	 xlZYAN+k2WqY2KRgAc9d1JK1Nmnc79rdGIO2X1VZf4XMoE5j/d2iR8In5mJFZTaK6ZHIL
	 Wf6PULLNyTyilOUZ/TRoRUttjHZL1ozQZheG5++sIK91wJavFwulqrNRoI96T+Fm2IWLk
	 9vZnCZOHaHbjc9ASV6Kvx9ZN2JUcmb9vzV+ZP+3dumuKT6vsFxb9/H9HsVcd7LTuDqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRBAh9kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B75D606A335;
	Thu, 19 Nov 2026 03:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TRBAh9kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD421F000C5;
	Thu, 19 Nov 2026 03:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057247;
	bh=DK/l/PEhjPAkWwzdWvp0Ylwxf/G+7lsrKK6FlRBoRFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TRBAh9kkeTS3ySy+9P5HbFqxwq2BuIAdT0y69yn447yyswtacTUjJy5k+M0Uxltfq
	 KHYmY8PrjuXREU/1Yezpp0qcZVbNWWuvbvkbsIMBCYrDvNrPbdcNMiILdgeSMWFRyc
	 UeMu2ZgjKNacMFJf8hliIW5EKiuAVy/S9mAYVP9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0064/1848] media: em28xx: requeue buffers if start_streaming fails
Date: Wed, 18 Nov 2026 15:35:02 +0100
Message-ID: <20261118145913.818008057@linuxfoundation.org>
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



