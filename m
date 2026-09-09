Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 593CC545D82;
	Wed,  9 Sep 2026 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962695; cv=none; b=kEFC97h6JPxp4FyMwdqfLJb5bXyGOZTNfOQHtQe1Gw/ve5Njq37N4NscmWCEh/eqi9BEdtxjNm7nQ7ETWF+j3QhL6ON71yQHnAufAbRtYw8umjGUFsrb69VlQHrfO9wignTFq0F/huRSCKw5KI6a7IwPQyrxFHa3r5oLvyqnh2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962695; c=relaxed/simple;
	bh=YPcCP86ilHV6nDNsbOxJK2Sil0nf45x6+AhEEjXRoQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ME8mmLWJjnu9Ex/IHxw75M1tgLzB9reXxbtU89ckR2bQxry2j2pTGGwrWvhlPJIlwAotr+Ljp9j9YOOup7G/7QRiDS4lAPlfXqbUDNqfx+FiDlkYKWJLUAwm77O5FWOAHO2WfeVYQKh+oSnCuxgL8Ct8l4ytK4Pb9ZuvV/f7Hjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Goz+1KjO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Goz+1KjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A991F00A3D;
	Wed,  9 Sep 2026 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962694;
	bh=ol0LjzFRPtT5q/Dy4dgXfkQWKyCRaml/pi7H59KgCIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Goz+1KjORsGniqKDmnNUn0Youv30XYWyPxEhLp06dbtLUIMlvNLKP4KY3qCJesw62
	 K6qOd5kwrsOsNmnRih1lL5JxpXxAubEvHR3zmTvmGyuwaHlxR7Ye3N0swkkkWGVxaS
	 /zJfwXOXwU8En42T53erRbXb9CuJzpG36qRJV/UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.2 378/556] media: nxp: imx8-isi: Correct color map between V4L2 and ISI
Date: Wed,  9 Sep 2026 15:40:58 +0200
Message-ID: <20260909134243.981203055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


