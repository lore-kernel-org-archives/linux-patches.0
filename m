Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE86C217723;
	Thu, 30 Jul 2026 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424628; cv=none; b=shAtLq3uG3AAE256JLRWlJDZRoMl8yLECg8KBT4l7C+L+0HnkAXTtXFfP2mE68HC8eG3w9IbRffSN8KvsapqdnL43fIq7J7X3lpplIZ6dcsArdy8Lly4vvSis5zF8sMqGBGPCl8nyr3bkFV7YaeEKiV9h1J5slDEj6Wrq8mVpuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424628; c=relaxed/simple;
	bh=drVylwC9jJnwZ1UxsEJd4ENkelz2LpiUeNhvLgtm724=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2ItNYRlEQat2rbaYe6AdLsLDBCSk4X7RCFAaw+n86250ORAHPiq/kOpvBTPtmLUTeCKwWJ+nUgnyIOmXgAPG7jzJ3GrOYgiQyBQAbnsdETBFe2RNormCnjEMg1Pb0bIun4AoqG7jzA31Ob7jTMuiLDqJ8v/5MOC4QfDWFTblmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XP7F53zp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XP7F53zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3E71F000E9;
	Thu, 30 Jul 2026 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424626;
	bh=pyjKn1VimS/mejvMoTglOUH9q9TkGFHihr7m0mIejcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XP7F53zp7R7j2ZH6b+Ecy6OKz/eP1+ll6jpN0CPGW1xUUpsj3LWQ9+qRCXxknLzo+
	 ZU0IYwu1frVKem1vxk9BVzNQYj2HhzjcUOAFZYg/o5i2jabpj+RzYTnrR2Gc0hCOgw
	 0zD5YR41/hBkjtoWHUauOHaKuqn9ieoQ3aLXsML4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Guoniu Zhou <guoniu.zhou@nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 416/675] media: nxp: imx8-isi: Fix potential out-of-bounds issues
Date: Thu, 30 Jul 2026 16:12:26 +0200
Message-ID: <20260730141453.974065850@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -412,4 +413,19 @@ static inline void mxc_isi_debug_cleanup
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


