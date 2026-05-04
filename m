Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B98FA3DDDDA;
	Mon,  4 May 2026 13:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903035; cv=none; b=brzEOdmJ0JOig4XiAb5/5PXVU1M0XAz70W+UkXqJyWkkgLHlD/TtK6hdwLQpT8g+HJtm99EhnUF+NSaTDcCdAQp05ER7ZINudEknO1n5DJ4fN0GLxn/3NeGpRYi0T6gxlbk4bM6157yg/HKSycHeWQwRWqTtX8M3FmKzaQ2GKPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903035; c=relaxed/simple;
	bh=DkoHH/4PXvLYl21+bFAJMnxRPZUANFsIBZ1W3xgek2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sufo5XH4WL+1zg/2REvzlOie7a1n6PddJOAmuOHQecM8kohHQhMPZ6YB9NuoMAUTj+e/QoKsLM97+gitS2JE6EbYmn8lSomSTMY21xdyjD5mhSb+u7O2QfTMj+iawk9bMvB4sBWXM0YF+vZMMsq/2K70Nt+tgohb8Hzh1Ubko0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR496OKP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR496OKP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BB0C2BCC4;
	Mon,  4 May 2026 13:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903035;
	bh=DkoHH/4PXvLYl21+bFAJMnxRPZUANFsIBZ1W3xgek2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR496OKPFYcXLhA0EYsU7JA4PXtFVvBLDrmvrP0YPhy0f2VyvS5FaIoWsoM2EouWY
	 UzPYa92V/rxfkpQypKj37Ue/gjXV5NgSaPu0PVP1ax0d/hdWEUKWCphzviMpSafWGP
	 0FM+DfQ5L1otX3JI+w9iux5U0fDq3C2YOIS0GT74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Paul Elder <paul.elder@ideasonboard.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Michael Riesch <michael.riesch@collabora.com>,
	Isaac Scott <isaac.scott@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 079/307] media: rockchip: rkcif: comply with minimum number of buffers requirement
Date: Mon,  4 May 2026 15:49:24 +0200
Message-ID: <20260504135145.784902971@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Riesch <michael.riesch@collabora.com>

commit 48c8292d4445088d8b3c9d639c7982744a94d819 upstream.

Each stream requires CIF_REQ_BUFS_MIN=1 buffers to enable streaming.
However, it failed with only one buffer provided.

Comply with the minimum number of buffers requirement and accept
exactly one buffer.

Fixes: 501802e2ad51 ("media: rockchip: rkcif: add abstraction for dma blocks")
Cc: stable@kernel.org
Tested-by: Paul Elder <paul.elder@ideasonboard.com>
Tested-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Michael Riesch <michael.riesch@collabora.com>
Reviewed-by: Isaac Scott <isaac.scott@ideasonboard.com>
Reviewed-by: Paul Elder <paul.elder@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../platform/rockchip/rkcif/rkcif-stream.c    | 44 +++++++++----------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkcif/rkcif-stream.c b/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
index e00010a91e8b..f15bee4f7cd7 100644
--- a/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
+++ b/drivers/media/platform/rockchip/rkcif/rkcif-stream.c
@@ -106,42 +106,42 @@ static int rkcif_stream_init_buffers(struct rkcif_stream *stream)
 {
 	struct v4l2_pix_format_mplane *pix = &stream->pix;
 
-	stream->buffers[0] = rkcif_stream_pop_buffer(stream);
-	if (!stream->buffers[0])
-		goto err_buff_0;
-
-	stream->buffers[1] = rkcif_stream_pop_buffer(stream);
-	if (!stream->buffers[1])
-		goto err_buff_1;
-
-	if (stream->queue_buffer) {
-		stream->queue_buffer(stream, 0);
-		stream->queue_buffer(stream, 1);
-	}
-
 	stream->dummy.size = pix->num_planes * pix->plane_fmt[0].sizeimage;
 	stream->dummy.vaddr =
 		dma_alloc_attrs(stream->rkcif->dev, stream->dummy.size,
 				&stream->dummy.buffer.buff_addr[0], GFP_KERNEL,
 				DMA_ATTR_NO_KERNEL_MAPPING);
 	if (!stream->dummy.vaddr)
-		goto err_dummy;
+		return -ENOMEM;
 
 	for (unsigned int i = 1; i < pix->num_planes; i++)
 		stream->dummy.buffer.buff_addr[i] =
 			stream->dummy.buffer.buff_addr[i - 1] +
 			pix->plane_fmt[i - 1].bytesperline * pix->height;
 
+	stream->buffers[0] = rkcif_stream_pop_buffer(stream);
+	if (!stream->buffers[0])
+		goto err_dummy_free;
+
+	stream->buffers[1] = rkcif_stream_pop_buffer(stream);
+	if (!stream->buffers[1]) {
+		stream->buffers[1] = &stream->dummy.buffer;
+		stream->buffers[1]->is_dummy = true;
+	}
+
+	if (stream->queue_buffer) {
+		stream->queue_buffer(stream, 0);
+		stream->queue_buffer(stream, 1);
+	}
+
 	return 0;
 
-err_dummy:
-	rkcif_stream_return_buffer(stream->buffers[1], VB2_BUF_STATE_QUEUED);
-	stream->buffers[1] = NULL;
-
-err_buff_1:
-	rkcif_stream_return_buffer(stream->buffers[0], VB2_BUF_STATE_QUEUED);
-	stream->buffers[0] = NULL;
-err_buff_0:
+err_dummy_free:
+	dma_free_attrs(stream->rkcif->dev, stream->dummy.size,
+		       stream->dummy.vaddr,
+		       stream->dummy.buffer.buff_addr[0],
+		       DMA_ATTR_NO_KERNEL_MAPPING);
+	stream->dummy.vaddr = NULL;
 	return -EINVAL;
 }
 
-- 
2.54.0



