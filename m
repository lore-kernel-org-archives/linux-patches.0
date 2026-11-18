Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058130;
	b=e17fnlBkwMNpSRGcSP6InU3dB+qX2uqNrnGdJjUeoT/6ARSDA0gSQgdK7ziNfad50zYK
	 4CUHLSgqDEDT++B26o0wDIX9tDFO7UVC6iLm8ghQl5Icn098ehG7fKX/FJKcSJzrFBS7m
	 FFkojnwKGUtIyPyxvNZiZYnwjpNKOTx1qWQ0LtnHIqhn+uNkGmd45do6gBZ7m2yFaC4Qq
	 TVlWv1jjzyv4T6tOYlF9Db25cL7dCYjYjEOSlOapy2OUqTT/Z+ZdU3mpzMCs6slsCMA4k
	 qE5y0kKuxBsVWlVW4EN6oJeNqFClrdV3urkc9rg84EvCYYxNilHexDVt9gw48HauBfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lLCmOQb75ffifhglmBSO6ZaXscUHwmE89xfILiRp2ZM=;
	b=f6uqsoOkvCaBOi7hzadkxux3/86Y5mfJf7a07beZiG9i8BRSfzvDSGwA4tx9wM6wQyYe
	 JT8NxSRRd96v1akxFVwbx6OM+6QpEduyJDlfPlQUztI7jDs7OFMD+i9/lemKMXehB3EdR
	 lclJDRdQzgwm+BpCKlWFAnkSpLZNYA+BDi3eYHzOk7zFSvy2e5lKoYVLgRiNCOJwrXDV7
	 Z/Kq+K5k8ydjubyd1VLsMU+XE6GpTJzetjAYEUghzRVUEtA2kNAym2QeoRN0deGXGB+XD
	 2sL6t6Z6zZUCZbT1G7/341FIfZ1ZiMULWAnYHTP8NP267I2KDQ3nqpWP5WUw540liSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jeh80Qfx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84974606A320;
	Thu, 19 Nov 2026 03:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jeh80Qfx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E082A1F000C4;
	Thu, 19 Nov 2026 03:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058130;
	bh=lLCmOQb75ffifhglmBSO6ZaXscUHwmE89xfILiRp2ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jeh80Qfx83zDJriEq101vRDcnWtUAnHFSb8th+DHsdjXsuGUtn96slnhBHsBeOa7k
	 Bhx9rSlhjaDWRC6lJgp+yRidTYCjH0Yx9J2IY05zrcU4OXD/h9MdO0HINXyw4SwqTr
	 xX3NnalSNKLWTyGP3YRnss/YmWVDyWXZ6NBPB4RY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0376/1848] media: m2m-deinterlace: fix default capture field
Date: Wed, 18 Nov 2026 15:40:14 +0100
Message-ID: <20261118145929.229384563@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit 4ee3ebede5d01efdcdd88c94f9df271d2eb237de ]

queue_init() initializes default formats for both the source and capture
queues.  It first sets the source field to V4L2_FIELD_SEQ_TB, but then
stores the capture default, V4L2_FIELD_INTERLACED_TB, in the source queue
again while initializing the capture queue.

This overwrites the valid source default and leaves the capture field at
its zero-initialized value, V4L2_FIELD_ANY.  vidioc_streamon() accepts
only V4L2_FIELD_SEQ_TB or V4L2_FIELD_SEQ_BT on the source queue, and
requires the capture queue to use a compatible interlaced or NONE field.
Userspace that relies on the default formats can therefore get -EINVAL
when starting streaming.

Initialize the capture field instead.  The bug is usually hidden because
mem2mem applications commonly call S_FMT on both queues before streaming;
the TRY_FMT paths normalize the fields and S_FMT overwrites q_data[].field.

Fixes: 8f0755c06b90 ("[media] media: Add mem2mem deinterlacing driver")
Cc: stable@vger.kernel.org
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/m2m-deinterlace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1f89e71cdccfc..5c05eb2d31045 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -830,7 +830,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



