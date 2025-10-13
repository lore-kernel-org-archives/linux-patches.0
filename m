Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFB8286890;
	Mon, 13 Oct 2025 15:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369399; cv=none; b=Q2jzBQtk5hzXhQcKcXwc0kC3vS+GkgqfjWMQy28DrPPLsxTIOVG5cgfd+le2Onji7cC1X0Z3tOBMpnONoQhVH1srUOQRIY2z0asGx70P9G6/GBkYeGKhrw+Xk9Ia+IP9GcEOmTqVJdvYE/9FlIEIvtOlOR8xcdDjo5h1SMG74PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369399; c=relaxed/simple;
	bh=YZkBU7qvkhA9pnBbQC5zBdLiFiWYAtmYFjFjcM7m1po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3o15iYl1Y8C7JTyjn4e25WCG98sv+LBIPQw23Be/38mpXuDO9JDGv7CWhDV7Gty/TO4KxAEyKbqlN5/Mhv9hh34YWx6igwWntKVWeDIuC/BJhOgkDwVpbyV/2G+BMLjzKy9m1KHEU3Z71T4odqiMPsWkUo/Hcn4Zs5XGYuBQoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xtk5Uz71; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xtk5Uz71"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E423AC4CEE7;
	Mon, 13 Oct 2025 15:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369399;
	bh=YZkBU7qvkhA9pnBbQC5zBdLiFiWYAtmYFjFjcM7m1po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xtk5Uz71u1nDtoCN+6yAQGW1qu3zNnDERYd9Trzsd86ljRMyxedUf7M1AMZt53u+D
	 pM2RMdK9SReG4hzOJjM0og3jtRmMTa2yIWr3rGetXqwPYnjMw5gUxBEN4D7flLyqpf
	 MWjzsatlCa0uK5Qht2rpnx5oZBJtyG+IXSqsXBNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 231/563] media: zoran: Remove zoran_fh structure
Date: Mon, 13 Oct 2025 16:41:32 +0200
Message-ID: <20251013144419.649255980@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacopo Mondi <jacopo.mondi@ideasonboard.com>

[ Upstream commit dc322d13cf417552b59e313e809a6da40b8b36ef ]

The zoran_fh structure is a wrapper around v4l2_fh. Its usage has been
mostly removed by commit 83f89a8bcbc3 ("media: zoran: convert to vb2"),
but the structure stayed by mistake. It is now used in a single
location, assigned from a void pointer and then recast to a void
pointer, without being every accessed. Drop it.

Fixes: 83f89a8bcbc3 ("media: zoran: convert to vb2")
Signed-off-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/zoran/zoran.h        | 6 ------
 drivers/media/pci/zoran/zoran_driver.c | 3 +--
 2 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/pci/zoran/zoran.h b/drivers/media/pci/zoran/zoran.h
index 1cd990468d3de..d05e222b39215 100644
--- a/drivers/media/pci/zoran/zoran.h
+++ b/drivers/media/pci/zoran/zoran.h
@@ -154,12 +154,6 @@ struct zoran_jpg_settings {
 
 struct zoran;
 
-/* zoran_fh contains per-open() settings */
-struct zoran_fh {
-	struct v4l2_fh fh;
-	struct zoran *zr;
-};
-
 struct card_info {
 	enum card_type type;
 	char name[32];
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index f42f596d3e629..ec7fc1da4cc02 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -511,12 +511,11 @@ static int zoran_s_fmt_vid_cap(struct file *file, void *__fh,
 			       struct v4l2_format *fmt)
 {
 	struct zoran *zr = video_drvdata(file);
-	struct zoran_fh *fh = __fh;
 	int i;
 	int res = 0;
 
 	if (fmt->fmt.pix.pixelformat == V4L2_PIX_FMT_MJPEG)
-		return zoran_s_fmt_vid_out(file, fh, fmt);
+		return zoran_s_fmt_vid_out(file, __fh, fmt);
 
 	for (i = 0; i < NUM_FORMATS; i++)
 		if (fmt->fmt.pix.pixelformat == zoran_formats[i].fourcc)
-- 
2.51.0



