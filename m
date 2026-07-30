Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E637BE9C;
	Thu, 30 Jul 2026 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426156; cv=none; b=NXdmVWtfWQ8tdb2oxfN3wHtRRvGy1IgwGGDy29EuVi40IaY7bO5ul3tto1ERpDwWKnDraTyz2oy7UDq3/zHKVTdE/w81oE3IX9cyOCbquPAJbUinFXhHTaI/1vFndMRdOAqeBo0eQZhC43WvYWrrqoZZvBXJSvfBkAGgGcGXxZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426156; c=relaxed/simple;
	bh=kWX2+x5pyS/2t2eJ2tnfZQoWisJadTJjSqr1p8VEX5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIbd3qOWy/H5+M7cmOCgz7y2u42ka5z0HCRT79AjhwVbXP6bJ3wQ7pwxmIQfXWRmuSAQVr1bbeAaB6ESecvhaQA6Pt3Z9914EbI5Iu2InQh/lGiU6gy6amI4ua21FRJybhovB0Xe4jMhKl4gvf2UNIlc1360cDFa7DXVi3kvE18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpOblU90; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpOblU90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39AD1F000E9;
	Thu, 30 Jul 2026 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426155;
	bh=LReIw403k65aiJD/F1QywwhGg9wCwDwr9Uk6tOe70lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpOblU90reOTm5FXoOxKRrLfH9RUjMWq4RCtEiBbHIlsog/kDjFmkaiw+up+fCj6U
	 vakF9sntX8E+UVhd5ynnTZed9CiJrgwukURqOLTMI3NtpKYviQ5ZNrKR+6TRfLyKLy
	 QTHNJAmcZKnjfjUrYgEhYsjPkM6aMy0WZwmHmHiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 318/602] media: nxp: imx8-isi: Fix potential out-of-bounds issues
Date: Thu, 30 Jul 2026 16:11:50 +0200
Message-ID: <20260730141442.648003706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,4 +404,19 @@ static inline void mxc_isi_debug_cleanup
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
@@ -504,9 +504,14 @@ __mxc_isi_m2m_try_fmt_vid(struct mxc_isi
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


