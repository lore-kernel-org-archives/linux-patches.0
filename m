Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A6537FF60;
	Sat, 12 Sep 2026 11:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213828; cv=none; b=EX71oFwY0/J0ar1nMAj8BnpILAaC6+GREW+aoq9Q90dRJ16Ez1tC4RRijUyRvW9/NLbkSqbI2NyRJTDB7qXfx4m0gW+uA5mB/B0tRbPHF5KKUolAUFJqbLgdvZUBxNMgVlZJcF1rjCF7KIzGmk9wg/3oqBHe1KBvG7Yxam2FnW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213828; c=relaxed/simple;
	bh=lQJ3fEmK3YFFBGKpx9inRYVDAdr8x3CMt+41/6uCkPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndM9wpoSs2VuyFRUGBqnYBR7dmxOiYBEZFvSId5x3BQYqJO0dQ4Lzarg3Q+Od4EVIvBEYdpqudvCchScm1rTZGF9xZAR7pTc19a8bEZh3fXKnJlISSzK/QC5Ff/gu+jfRVfXAPi9BZ94kdHE7WCj8duoH9J2m/cwHXwMZGaxiJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qs0CEzA/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qs0CEzA/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68F21F000FF;
	Sat, 12 Sep 2026 11:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213826;
	bh=qwTMFaX1tx7xBjfx8pnhQsjDe9idKuKuyzxD0d90wn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qs0CEzA/3fhk05EQrGqpo/Mm0ZMu3egSRnoFzjTMaJEJJ6W/JEt1yAfYcqXWib3pv
	 A2ixOVLTrICdyanWYPDaCfKx9/ZSyTt8Vt147CQ4wJrXqI+zDDnUGaUZusQ8lOoD4q
	 aIsBti6cyMyAeePvM0s/TWdR5Azbhlp+O/nWPEuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Frank Li <Frank.Li@nxp.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0202/1376] media: nxp: imx8-isi: Correct color map between V4L2 and ISI
Date: Sat, 12 Sep 2026 08:43:48 +0200
Message-ID: <20260912065612.051930061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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


