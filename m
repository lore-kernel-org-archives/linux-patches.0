Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEC622A7F6;
	Sat, 12 Sep 2026 14:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221797; cv=none; b=hMrrfBXOZwirpFdP8PEFDns7rs6qycyGLewZM92mMvsE6BWLFVQZQEbLckHx/SkvYUCk3eJxAPg5babHMubGW9NSuSaT0fGGyRmGcVI3bwFoZVhHH79k8nC/fYEf4SN4JvDP1LJlRhqFAlxsTEMA/dV01ySKR4nvkO1FoxhZgpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221797; c=relaxed/simple;
	bh=nyvlkoyCcH6Q7rIZ4kLaFtI+Dh1zdS3RrKRplGDyfkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebr88uG7GLSoabKWAZRnsLSgZqCwsYmOdA96VH5WDbCbhaHw6uXFo8unliaKkDFw/BCVpa8is90baOMu4tIFyKfHq+e6tYDo/p5xP4JD2FOB8KJm/G9bltvKvcmb4yXLAw21L8l5sB4VZB2u1Ifsgv0LtHlLbBs3AQHkHT0y08w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Jcv+cSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Jcv+cSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836F31F000FF;
	Sat, 12 Sep 2026 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221796;
	bh=gMzlXvccRE4YkbWM/VjS21uqPyX6EpiovQ+gYTkWevc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Jcv+cScaJr/1Kr+wmyD8nRC8maff/GqVg5CZOkUijHvPEe5HyHs1rrJuzRuTCOWD
	 rHBBP2LlT5i7+ke1GaHTGl9MUPA7LtIP3lHk9w0A0yKHwGftJ5cOiWUfke/HeS5ozK
	 EZCW4PVMsRfoDd5D58e/S50+vJisYtZBLp9MWnUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0456/1424] media: nxp: imx8-isi: Correct color map between V4L2 and ISI
Date: Sat, 12 Sep 2026 08:48:08 +0200
Message-ID: <20260912065617.496696908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 4640ec1cb0121473867e7a6850c7449340dcd428 upstream.

Fix the ISI input format for the color map V4L2_PIX_FMT_XBGR32 in
memory-to-memory mode.

Fixes: cf21f328fcaf ("media: nxp: Add i.MX8 ISI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260720-isi-v2-5-45845bc5d4fa@oss.nxp.com
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
index fe4adfa3a1f0..056603055c81 100644
--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -151,7 +151,7 @@ static const struct mxc_isi_format_info mxc_isi_formats[] = {
 		.fourcc		= V4L2_PIX_FMT_XBGR32,
 		.type		= MXC_ISI_VIDEO_CAP | MXC_ISI_VIDEO_M2M_OUT
 				| MXC_ISI_VIDEO_M2M_CAP,
-		.isi_in_format	= CHNL_MEM_RD_CTRL_IMG_TYPE_XBGR8,
+		.isi_in_format	= CHNL_MEM_RD_CTRL_IMG_TYPE_XRGB8,
 		.isi_out_format	= CHNL_IMG_CTRL_FORMAT_XRGB888,
 		.mem_planes	= 1,
 		.color_planes	= 1,
-- 
2.55.0



