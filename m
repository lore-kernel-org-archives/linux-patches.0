Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D541C07DF;
	Tue, 15 Oct 2024 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998178; cv=none; b=hXVsIchgbmz4e5TrED4o7QsOKttgOsbHM73cK6QQE0uaMloXtZeKI4gtNeMJ1voZA2k3oDfMs2WhijT4UhGCOBKspnCgquOUN7+K9bob5q3rJhpqs2jkPE7bLAPWM9EeTYWTqVWseQXqUrNSEhHucI8QtqQ6j1J8u+Nod7nbkoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998178; c=relaxed/simple;
	bh=nKrCdw9v3O++rln0SKIacLGG0WVHbekrFDmb6WH4Ngk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KoQQ1Me5oiYWSnUmpQNdAyNqiWdHYnq3K/Ls/Seu9uVVCDa39ZF5pDyGRKEhtqk7cdMPe5pKzqfDbUY9spmheGlZLvmzZuiJv50nP1FuIP0CyTBrOk8sZEw/ROCbiD/RAhVaN1QNpUeeSbiAddX9TnOrh+NTKQWHtmtQ1Rz/z/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zD5fT5aj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zD5fT5aj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0660EC4CEC6;
	Tue, 15 Oct 2024 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998178;
	bh=nKrCdw9v3O++rln0SKIacLGG0WVHbekrFDmb6WH4Ngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zD5fT5ajjJx0/Z9IHaIS2VBQYQ+qPdfP5IewB1bZ3fDfmRClrhYI3BUCQKFnOK2X+
	 VpWj/i7NoZd4INDFlAvlygBNLAxSUE72SEqQdXoW3KIHi6Q3dw/UEE15NyUiiYKzLM
	 jGDykSE6srPS4dHogKs1S8EjDjjnS4dBLDUUMGmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 5.10 400/518] media: sun4i_csi: Implement link validate for sun4i_csi subdev
Date: Tue, 15 Oct 2024 14:45:04 +0200
Message-ID: <20241015123932.412567596@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

commit 2dc5d5d401f5c6cecd97800ffef82e8d17d228f0 upstream.

The sun4i_csi driver doesn't implement link validation for the subdev it
registers, leaving the link between the subdev and its source
unvalidated. Fix it, using the v4l2_subdev_link_validate() helper.

Fixes: 577bbf23b758 ("media: sunxi: Add A10 CSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Chen-Yu Tsai <wens@csie.org>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
+++ b/drivers/media/platform/sunxi/sun4i-csi/sun4i_csi.c
@@ -40,6 +40,10 @@ static const struct media_entity_operati
 	.link_validate = v4l2_subdev_link_validate,
 };
 
+static const struct media_entity_operations sun4i_csi_subdev_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
 static int sun4i_csi_notify_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_subdev *subdev,
 				  struct v4l2_async_subdev *asd)
@@ -245,6 +249,7 @@ static int sun4i_csi_probe(struct platfo
 	v4l2_subdev_init(subdev, &sun4i_csi_subdev_ops);
 	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
+	subdev->entity.ops = &sun4i_csi_subdev_entity_ops;
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name), "sun4i-csi-0");
 	v4l2_set_subdevdata(subdev, csi);


