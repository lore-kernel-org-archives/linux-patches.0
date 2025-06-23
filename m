Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB41324A06B;
	Mon, 23 Jun 2025 13:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684481; cv=none; b=EPdGQLW6C8Y+ur5v6IfwIw+MjCWBTZDmTzmYGKTdoazvod4BEVqxggPIubxXIpdWATOODhRTkTmJUvVjpKxp4dKu8iNQPGIifMhGk3VFLCAwDjcf1QTfd9KMkPfAw67K0f1+gSSKMx697TNe8iBJ7dZCMbCC1Z3zvoxHmo7nMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684481; c=relaxed/simple;
	bh=v4dkyuESmsX1CF0zJt7YKZNLI94BlZZ72pt8u7tvSWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=da9seUXkK3GKpuPMDCdP4Wdqna1WvGr19B/+vCThYlEI0lPEhtAqju6TixPWh1KtCYH+aDLWdACSHAE5WQp5OHaYdpWSKmCfP7Hnm9kX/bDbIrLz1eRAjk6HgmJB5Qvb717T2Nd9iZRi8CSNdOObs7ZgZk9qumrd8lVSmO6soOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RLkud+Sy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RLkud+Sy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDC9C4CEEA;
	Mon, 23 Jun 2025 13:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684481;
	bh=v4dkyuESmsX1CF0zJt7YKZNLI94BlZZ72pt8u7tvSWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RLkud+SyicfboIar9VzjaO24Yayv9STpQwhPmpw7BK+NOD4qo3pqyQb2UbYuV9Kyh
	 3rMIhvjiMabKktjR+mCMf9ZK37ARxZfNiWRA0qMwhJEWb8HZYxfEy5d1AUR1hnIfz9
	 8GIJY1ZOpYJiIQvcKEY+F9u0cLpRZKbhiI7Gd4gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 086/592] media: imx-jpeg: Move mxc_jpeg_free_slot_data() ahead
Date: Mon, 23 Jun 2025 15:00:44 +0200
Message-ID: <20250623130702.323798271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

commit 46e9c092f850bd7b4d06de92d3d21877f49a3fcb upstream.

Move function mxc_jpeg_free_slot_data() above mxc_jpeg_alloc_slot_data()
allowing to call that function during allocation failures.
No functional changes are made.

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |   40 ++++++++++++-------------
 1 file changed, 20 insertions(+), 20 deletions(-)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -752,6 +752,26 @@ static int mxc_get_free_slot(struct mxc_
 	return -1;
 }
 
+static void mxc_jpeg_free_slot_data(struct mxc_jpeg_dev *jpeg)
+{
+	/* free descriptor for decoding/encoding phase */
+	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
+			  jpeg->slot_data.desc,
+			  jpeg->slot_data.desc_handle);
+
+	/* free descriptor for encoder configuration phase / decoder DHT */
+	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
+			  jpeg->slot_data.cfg_desc,
+			  jpeg->slot_data.cfg_desc_handle);
+
+	/* free configuration stream */
+	dma_free_coherent(jpeg->dev, MXC_JPEG_MAX_CFG_STREAM,
+			  jpeg->slot_data.cfg_stream_vaddr,
+			  jpeg->slot_data.cfg_stream_handle);
+
+	jpeg->slot_data.used = false;
+}
+
 static bool mxc_jpeg_alloc_slot_data(struct mxc_jpeg_dev *jpeg)
 {
 	struct mxc_jpeg_desc *desc;
@@ -798,26 +818,6 @@ err:
 	return false;
 }
 
-static void mxc_jpeg_free_slot_data(struct mxc_jpeg_dev *jpeg)
-{
-	/* free descriptor for decoding/encoding phase */
-	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
-			  jpeg->slot_data.desc,
-			  jpeg->slot_data.desc_handle);
-
-	/* free descriptor for encoder configuration phase / decoder DHT */
-	dma_free_coherent(jpeg->dev, sizeof(struct mxc_jpeg_desc),
-			  jpeg->slot_data.cfg_desc,
-			  jpeg->slot_data.cfg_desc_handle);
-
-	/* free configuration stream */
-	dma_free_coherent(jpeg->dev, MXC_JPEG_MAX_CFG_STREAM,
-			  jpeg->slot_data.cfg_stream_vaddr,
-			  jpeg->slot_data.cfg_stream_handle);
-
-	jpeg->slot_data.used = false;
-}
-
 static void mxc_jpeg_check_and_set_last_buffer(struct mxc_jpeg_ctx *ctx,
 					       struct vb2_v4l2_buffer *src_buf,
 					       struct vb2_v4l2_buffer *dst_buf)


