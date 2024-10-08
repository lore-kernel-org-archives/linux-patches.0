Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723AB18F2FA;
	Tue,  8 Oct 2024 13:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392560; cv=none; b=Hf/xV6eiVH06JRRimMQE3rlhiQT3kTR1j0MB9k4HPj4uRuwptqorTlsy46mO1/dnl5A06EGGA4W3rP5TQCc/71LSkKv/8kBSYSiW33sqQI/xD4F8X3ZX5HGIA5OEA7p8FEAXc0PirdFsEt+emhOEUwW5u+ij17yf69Ao+D17AUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392560; c=relaxed/simple;
	bh=WNh6THWuIgnb/inOKQvIcdI7JfL9j1KJJ0HftVifdzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahk/guiyBwEv+50qZLKUwzhehv37CB76+aXmeU+FdUUQYzmMqoH+HNlPdnwyvmbMXyAY9UnP/8l59fYSXgKMLybihketpC49OaRVrNr6LojJFk+Z2jfU3QNi5F3MY8QSUJrQegRSn3tB7Hu3mwPWJXXz1xV0zihQVOZ78y4lzsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCsxR0oV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCsxR0oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EC7C4CEC7;
	Tue,  8 Oct 2024 13:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392560;
	bh=WNh6THWuIgnb/inOKQvIcdI7JfL9j1KJJ0HftVifdzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCsxR0oVwiPrQYv0uLzDdlGEoCVP9+T4UsY88mQPnEasaY2Fzpqq1E539/JkaNB4b
	 cDrcctmOzPfJzAYRP7nLM77Qr7SdvOfRrtQITbGVJlCEcqLd5u1imANS2T/73oB2Tb
	 eM9DThOW4h3DDV8cWW8c+Kq44EDN9xY8JV1MwGjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.11 452/558] media: sun4i_csi: Implement link validate for sun4i_csi subdev
Date: Tue,  8 Oct 2024 14:08:02 +0200
Message-ID: <20241008115720.046547094@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -39,6 +39,10 @@ static const struct media_entity_operati
 	.link_validate = v4l2_subdev_link_validate,
 };
 
+static const struct media_entity_operations sun4i_csi_subdev_entity_ops = {
+	.link_validate = v4l2_subdev_link_validate,
+};
+
 static int sun4i_csi_notify_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_subdev *subdev,
 				  struct v4l2_async_connection *asd)
@@ -214,6 +218,7 @@ static int sun4i_csi_probe(struct platfo
 	subdev->internal_ops = &sun4i_csi_subdev_internal_ops;
 	subdev->flags = V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 	subdev->entity.function = MEDIA_ENT_F_VID_IF_BRIDGE;
+	subdev->entity.ops = &sun4i_csi_subdev_entity_ops;
 	subdev->owner = THIS_MODULE;
 	snprintf(subdev->name, sizeof(subdev->name), "sun4i-csi-0");
 	v4l2_set_subdevdata(subdev, csi);


