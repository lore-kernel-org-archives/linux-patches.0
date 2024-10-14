Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43418481B3;
	Mon, 14 Oct 2024 15:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919345; cv=none; b=KCXPvRL4xesF/HK3HaF1BRq0W7esvJJKs2XLzTwXYAwwzMJUaLpRKzhOq/kGqdJg1O5m8HpX8sd9UHrNBfP4RZ/3B8CIUjKo4O8Tu5pZap8WVCShu43ohZ91XqJG7rXQ/KKHpfBa27yWt1n2btr3dHrOb4LmAOm/7Wuxzl+emoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919345; c=relaxed/simple;
	bh=Drb5TpX8Qlv5o0Wrz0Ca8EeBGbMKkzmM5ArdQsc/EiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwrdmQmyO7a1ffwYdNDFBZ+qLxBsz8VFaa1bZgO6aIM9AKdIzuEMJvNq4/4kWFMDbn+HB/le54lvF6XevAsCwtPYDvD8ov5wUiDgZ3GUr2WTfEIiISv1YsboPJh3ifleeCViyBKVhOCVumNMCVRSI2B8Nuts+7fFPFdyGuFg7O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6ZSjkiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6ZSjkiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3059C4CEC3;
	Mon, 14 Oct 2024 15:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919345;
	bh=Drb5TpX8Qlv5o0Wrz0Ca8EeBGbMKkzmM5ArdQsc/EiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6ZSjkiwSlzjpOkuWXEiyORChUD7KhNWJi6J4GrcsJ9MDcuqLhSTEVOAlcfhYL6ye
	 ZpvV4ja0ylsHvASbBF3TaO/LF2PHvCUusL54MLOUKqli3u4gx3Xv04k6e56CqXaVm7
	 zby8q949cmJv2pJqLKIrbv8l9pqXW76A9qo6lDVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.1 583/798] media: sun4i_csi: Implement link validate for sun4i_csi subdev
Date: Mon, 14 Oct 2024 16:18:57 +0200
Message-ID: <20241014141240.907347705@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -214,6 +218,7 @@ static int sun4i_csi_probe(struct platfo
 	v4l2_subdev_init(subdev, &sun4i_csi_subdev_ops);
 	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
+	subdev->entity.ops = &sun4i_csi_subdev_entity_ops;
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name), "sun4i-csi-0");
 	v4l2_set_subdevdata(subdev, csi);


