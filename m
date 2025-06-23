Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFBD1EFFA6;
	Mon, 23 Jun 2025 21:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713485; cv=none; b=HqODjB3Cs+AsQxhD2jjPQd41Ub7o9Uja0u5ywpaTiCNhDoaglGxzllnGNt19GQeA+S9vOmQGqhVDYXis2LdNJNYwd782MO//VHx+/uMvd5ZXHA72oolFOn5m5OM3/f/WT0E6N/br4ZbSoyOK4coHXdRIfvcAKdRFOW5kwAPBWbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713485; c=relaxed/simple;
	bh=Az51LPuBZHk/REtVqjvzbPWZPsMW5Oh1R81LCP56Guo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8Y1uDNvbSCAbSQxoYDNDATlJq2sLJvLcI98fCIk1nPlKLSsrMkgPsEz3SIIicGSfQQbd/OuenPrwpVlaEcisici5oSGdc7HFSAskBiNoRkqE2CS9doicfcgcvI7EsFYBLk//gRj4ygE22IS281nV86MuJJWouJVxvi9ePo8Ixw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fWJy/ins; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fWJy/ins"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EABC4CEF0;
	Mon, 23 Jun 2025 21:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713485;
	bh=Az51LPuBZHk/REtVqjvzbPWZPsMW5Oh1R81LCP56Guo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fWJy/insojNinsJpt2U4jfViszy0YO88s1p2tMF2zdjO+O6mLbi9KVCMgP46UCZmm
	 gZUVFKDVT7q54j2lZr0HFU7fo0xU7ZUZqQAwNzH+CauI9XmRwjh/RPWxtTUeZrHVvH
	 Lf3uldT4kFk2O1eClPV4s9EPahacRORSmTVvO960=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 066/414] media: imx-jpeg: Move mxc_jpeg_free_slot_data() ahead
Date: Mon, 23 Jun 2025 15:03:23 +0200
Message-ID: <20250623130643.720720682@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


