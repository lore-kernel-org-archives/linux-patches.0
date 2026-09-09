Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650CF548549;
	Wed,  9 Sep 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964085; cv=none; b=jMutZVAWbo4JUdQj+LOr9Mm5/Hpe+raV58keiQ+xdI9nURCbmEueyEEOsCGs8HpgIumcIF9hoG+WIKZsoBtL2O4TRLD6zXNvciqnvySZtenJiY/gGPosjRwwfbEkyCqW4WBGI2jFJNZKuw9w+27j4LkWXCBy+vsckdGcpJs5TnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964085; c=relaxed/simple;
	bh=95HTNb/AVpKsA/gxeQf3mL+s5yKSrzzy6jnrqOJfxno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYGsb9FSgnXd4XsAdOCJaI9qgNdNMRlnDrtblSi3vVx7+FmHgrryLy8gzrd+qSmndYBlWL5CgI9J95lLH6xJOASsYXHT2BqzzVGLvomA55L+am7EuDlpzWk7IJ3LUGkY2edLKBcFlgT0Nb3jPgpLEhY2owJlmbosJMwLu9EdfRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQl3p7hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQl3p7hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCC61F00A3D;
	Wed,  9 Sep 2026 14:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964084;
	bh=UvZFQ/s9SBXuNJkEHx58Tq0n/8UiCdUwiqvdWpnGqc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qQl3p7hXn6LhDCITpN7s9ff0x9/eQmnZy/tMMOms0AXfVqDEZwtWy4ebWUofnhBnS
	 3FXBD2qKEl5R5pMDr2Oi4t65LlxHCJ9F18tgPNn2QOFbuvQZaZW5N8GthvH3/QjXUN
	 KNkeQ1gkJpQf5DSMT83JIiPAVlfOIxc48+6TyIRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 300/583] media: nxp: imx8-isi: Correct color map between V4L2 and ISI
Date: Wed,  9 Sep 2026 15:39:45 +0200
Message-ID: <20260909134248.417787967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
 drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
+++ b/drivers/media/platform/nxp/imx8-isi/imx8-isi-video.c
@@ -151,7 +151,7 @@ static const struct mxc_isi_format_info
 		.fourcc		= V4L2_PIX_FMT_XBGR32,
 		.type		= MXC_ISI_VIDEO_CAP | MXC_ISI_VIDEO_M2M_OUT
 				| MXC_ISI_VIDEO_M2M_CAP,
-		.isi_in_format	= CHNL_MEM_RD_CTRL_IMG_TYPE_XBGR8,
+		.isi_in_format	= CHNL_MEM_RD_CTRL_IMG_TYPE_XRGB8,
 		.isi_out_format	= CHNL_IMG_CTRL_FORMAT_XRGB888,
 		.mem_planes	= 1,
 		.color_planes	= 1,


