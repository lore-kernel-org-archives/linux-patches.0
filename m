Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061949;
	b=R2NrqWIweLCR07QEi2ah5Pr7rSlt8/vE+rA2uYwJgEoqtUFYYKjl4uAg/g/BN6wszsST
	 38OBeXkz83INZsCI9aecxNNY0eI+xXVS9C3IYgOATQULfxSYHnGOBUOIktR30sPCo9LlL
	 TxL4p7hFmFD35UYBCTOmNA8qtOE3VPI4Q4QF421lE6Xwmcz26ALwi8UeA3bdS5QNhAnvu
	 12pqOV34a+eO84i2h0SvtpRis/Use0kgAmtXiAldn+2GX04tg4ZFfGH7vm8fpCqRdfPu9
	 ZBxeiZu8xXuTYerq71URcfC/UzNcskI4bSCIkLnD2xlT2iqr5zVwW7XluJ4egoKIv/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O/SzNIRcSBlpLc/k00FWkHeDz85/R8ENEicZQnZJPds=;
	b=toSEhmYalHNdhLBkr8nfW5N7fFr6ekalbzusSOQk+9MybBpbu1s4COahHQwybuFAmCDv
	 Xk5DNZb3QpFWxuBiDmjLWl5clGhQXawpYz5OvcRtcHG/f5s+R3T8t7LYOBKh7RHxEZA6F
	 Mb8tiJKZoLk0RygLLTteBoNedUvC+7C3iwiy7ul+8dPuzxF4u1QGnQwhPB329fvaY5IG6
	 iuwA8TjSv2KgN0FOs93p0QsMVX+0i2psVKKai31Nam4ZaueArLx8IWtAM2Q2+CkvWrwgZ
	 Rg/rrb/2lZDvCkEYZwE7Aspg9pAmVpA1yxbqiMItqLb9PAOzDTxTl9pW1JJiZE+3UNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKLCIyhz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48177606A330;
	Sat,  7 Nov 2026 14:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IKLCIyhz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54B21F0089F;
	Sat,  7 Nov 2026 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061949;
	bh=O/SzNIRcSBlpLc/k00FWkHeDz85/R8ENEicZQnZJPds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKLCIyhzu3+812xLnxsrZam5+KqOlNaoL+vSAQ3AdPdfSLDuJ7fWi2DNJdqHo2L4g
	 ugxNemRfMOA2w3PRe9ZL56vUow/JsfGAvsSg3nLPIlMH2N1+JuBb+Wa0+W120O0XBJ
	 ZhY90YVbltMjfofL5Rr+DtlnqzPkfaNIbyQvPjLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Xu Rao <raoxu@uniontech.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0946/1536] media: m2m-deinterlace: fix default capture field
Date: Sat,  7 Nov 2026 08:49:22 -0500
Message-ID: <20261107135024.226210888@linuxfoundation.org>
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
index 5adcef80c6987..3d2a8f07c3fba 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -826,7 +826,7 @@ static int queue_init(void *priv, struct vb2_queue *src_vq,
 	q_data[V4L2_M2M_DST].width = 640;
 	q_data[V4L2_M2M_DST].height = 480;
 	q_data[V4L2_M2M_DST].sizeimage = (640 * 480 * 3) / 2;
-	q_data[V4L2_M2M_SRC].field = V4L2_FIELD_INTERLACED_TB;
+	q_data[V4L2_M2M_DST].field = V4L2_FIELD_INTERLACED_TB;
 
 	return vb2_queue_init(dst_vq);
 }
-- 
2.53.0



