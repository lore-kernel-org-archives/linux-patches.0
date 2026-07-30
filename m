Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D43E43E09D;
	Thu, 30 Jul 2026 14:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422628; cv=none; b=KN2ipktTFsPa6mKO48B9Fo42Aa+5D8aBMAlR2MFWJnI3v+AQBI7fxlrqHuAAwqXLEF64XzGBtcxrtjjI6h+/N8nU0M1mYUNaavsHvvpIiy5xuoNWAnYP/nUnuixV/RzUa0LzEyIYYijbxj4vdm1QEQzrBphqmjS/gmsB+N7AzH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422628; c=relaxed/simple;
	bh=h2Os36JGNZC8nx2hrkM7wncHfuqxxyzilhxXFeYpQLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ag6ZezL0gvug9K6E4mDvbSg82aUH/XiBKwuu3fjIRgyIlfiTdYOyTUyPB90GgYqjuNzdNnrdkAalYLSFtToPUEvWa1twVSMsgB8bZ0v2tg7DV95HCgBi5AQE7Y82CFMO/BzTxFg8O3NUluffbecEzSufIQV+v5Drgdm11PMYCXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJVjp8KS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJVjp8KS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658AF1F00A3A;
	Thu, 30 Jul 2026 14:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422627;
	bh=5Wkd/HrbSoOSFNCI87VOxMFf+5FbOtWsWKG1NOoSEtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJVjp8KST1+EdUrYFJVaXcNUR1AmIIQuJ5IL+jLbkMEIX1wwPAW2AX0Si5+aGBqop
	 Yvo9WUAvaL6bTwhr5VrYsDEbWBK8tz/Aq0zO/Z0lyJlWm6d6R491fEppCcZ2LeO9b4
	 ir1k4nUlchVJpvrf5jWebheuELVeEzEgOedJ2BtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 501/744] media: nxp: imx8-isi: Fix potential out-of-bounds issues
Date: Thu, 30 Jul 2026 16:12:54 +0200
Message-ID: <20260730141454.933236882@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@nxp.com>

commit 57a7ec5c9f38ce6c4d6209c4b75c8e57e1fea6cf upstream.

The maximum downscaling factor supported by ISI can be up to 16. Add
minimum value constraint before applying the setting to hardware.
Otherwise, the process will not respond even when Ctrl+C is executed.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Guoniu Zhou <guoniu.zhou@nxp.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patch.msgid.link/20260323-isi-v3-1-8df53b24e622@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h |   16 ++++++++++++++++
 drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c  |   11 ++++++++---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c |   13 ++++++++-----
 3 files changed, 32 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-core.h
@@ -11,6 +11,7 @@
 #define __MXC_ISI_CORE_H__
 
 #include <linux/list.h>
+#include <linux/math.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -414,4 +415,19 @@ static inline void mxc_isi_debug_cleanup
 }
 #endif
 
+/*
+ * ISI scaling engine works in two parts: it performs pre-decimation of
+ * the image followed by bilinear filtering to achieve the desired
+ * downscaling factor.
+ *
+ * The decimation filter provides a maximum downscaling factor of 8, and
+ * the subsequent bilinear filter provides a maximum downscaling factor
+ * of 2. Combined, the maximum scaling factor can be up to 16.
+ */
+static inline unsigned int
+mxc_isi_clamp_downscale_16(unsigned int val, unsigned int max_val)
+{
+	return clamp(val, max(1U, DIV_ROUND_UP(max_val, 16)), max_val);
+}
+
 #endif /* __MXC_ISI_CORE_H__ */
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-m2m.c
@@ -509,9 +509,14 @@ __mxc_isi_m2m_try_fmt_vid(struct mxc_isi
 			  const enum mxc_isi_video_type type)
 {
 	if (type == MXC_ISI_VIDEO_M2M_CAP) {
-		/* Downscaling only  */
-		pix->width = min(pix->width, ctx->queues.out.format.width);
-		pix->height = min(pix->height, ctx->queues.out.format.height);
+		const struct v4l2_pix_format_mplane *format =
+			&ctx->queues.out.format;
+
+		/* Downscaling only, by up to 16. */
+		pix->width = mxc_isi_clamp_downscale_16(pix->width,
+							format->width);
+		pix->height = mxc_isi_clamp_downscale_16(pix->height,
+							 format->height);
 	}
 
 	return mxc_isi_format_try(ctx->m2m->pipe, pix, type);
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-pipe.c
@@ -641,16 +641,19 @@ static int mxc_isi_pipe_set_selection(st
 			/* Composing is supported on the sink only. */
 			return -EINVAL;
 
-		/* The sink crop is bound by the sink format downscaling only). */
+		/*
+		 * The ISI supports downscaling only, with a factor up to 16.
+		 * Clamp the compose rectangle size accordingly.
+		 */
 		format = mxc_isi_pipe_get_pad_format(pipe, state,
 						     MXC_ISI_PIPE_PAD_SINK);
 
 		sel->r.left = 0;
 		sel->r.top = 0;
-		sel->r.width = clamp(sel->r.width, MXC_ISI_MIN_WIDTH,
-				     format->width);
-		sel->r.height = clamp(sel->r.height, MXC_ISI_MIN_HEIGHT,
-				      format->height);
+		sel->r.width = mxc_isi_clamp_downscale_16(sel->r.width,
+							  format->width);
+		sel->r.height = mxc_isi_clamp_downscale_16(sel->r.height,
+							   format->height);
 
 		rect = mxc_isi_pipe_get_pad_compose(pipe, state,
 						    MXC_ISI_PIPE_PAD_SINK);


