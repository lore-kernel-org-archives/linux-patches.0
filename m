Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DE03BFE52;
	Mon, 23 Mar 2026 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279475; cv=none; b=t92MTG4NItRT2b4IQa9qoBgiepnzW6gbZZHEDAC9a4sYo6K7SrqQsj7vmmOIeBBBb+NkIew6wdNK3DZZViirov//0vhhovxifs/qkRzJhVgDkJA07/tuLTNx/QtrOmJtIMO4KkvE3Xtn9kkJOg32lv0o/Zlir9BaZ0GM7EunwFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279475; c=relaxed/simple;
	bh=ByDm68raLxN0qvzhUvWXCeWoQIUS/oBRR28CUdDMra4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY5bbKhsaPsDMlz+6DMpUVPRh1LgyfICfCRh6oxFcLhRsqWhlIHRnud70CSClWiLDNECJO9YDU8JaiiW3/E/7YzuirbRZXyoPbBN6ovx1pthYVXwnUzaQlgCl/9+KmP5WeX5jWZ/PWa2tqp2SdYE+A5qWxYS6WQFPn0PFFh3nCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yv82XV/P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yv82XV/P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2B7C4CEF7;
	Mon, 23 Mar 2026 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279475;
	bh=ByDm68raLxN0qvzhUvWXCeWoQIUS/oBRR28CUdDMra4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yv82XV/PQpIiTKX74HbqBe13frb43oYeFNAGhfx7xz8fF77tP76+TBrEQEBzKFUkk
	 k42G0bKcxryu9X7YN3Yb5vCX78KE+l4awhjrqNPvCtlGHsvYNoOUM6ycAUlh6r3a65
	 p1MXgse3IcXnaPNn9brPhxYrYft5ed5ct1OKG/Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 030/481] media: tegra-video: Use accessors for pad config try_* fields
Date: Mon, 23 Mar 2026 14:40:12 +0100
Message-ID: <20260323134525.974986032@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 0623979d8352efe18f83c4fad95a2e61df17b3e7 ]

The 'try_*' fields of the v4l2_subdev_pad_config structure are meant to
be accessed through helper functions. Replace direct access with usage
of the v4l2_subdev_get_pad_format(), v4l2_subdev_get_pad_crop() and
v4l2_subdev_get_pad_compose() helpers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Stable-dep-of: 43e5302d2233 ("media: tegra-video: Fix memory leak in __tegra_channel_try_format()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/tegra-video/vi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/media/tegra-video/vi.c b/drivers/staging/media/tegra-video/vi.c
index 9d46a36cc0140..e82ab9044ef3b 100644
--- a/drivers/staging/media/tegra-video/vi.c
+++ b/drivers/staging/media/tegra-video/vi.c
@@ -502,6 +502,7 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
 		.target = V4L2_SEL_TGT_CROP_BOUNDS,
 	};
+	struct v4l2_rect *try_crop;
 	int ret;
 
 	subdev = tegra_channel_get_remote_source_subdev(chan);
@@ -537,24 +538,25 @@ static int __tegra_channel_try_format(struct tegra_vi_channel *chan,
 	 * Attempt to obtain the format size from subdev.
 	 * If not available, try to get crop boundary from subdev.
 	 */
+	try_crop = v4l2_subdev_get_pad_crop(subdev, sd_state, 0);
 	fse.code = fmtinfo->code;
 	ret = v4l2_subdev_call(subdev, pad, enum_frame_size, sd_state, &fse);
 	if (ret) {
 		if (!v4l2_subdev_has_op(subdev, pad, get_selection)) {
-			sd_state->pads->try_crop.width = 0;
-			sd_state->pads->try_crop.height = 0;
+			try_crop->width = 0;
+			try_crop->height = 0;
 		} else {
 			ret = v4l2_subdev_call(subdev, pad, get_selection,
 					       NULL, &sdsel);
 			if (ret)
 				return -EINVAL;
 
-			sd_state->pads->try_crop.width = sdsel.r.width;
-			sd_state->pads->try_crop.height = sdsel.r.height;
+			try_crop->width = sdsel.r.width;
+			try_crop->height = sdsel.r.height;
 		}
 	} else {
-		sd_state->pads->try_crop.width = fse.max_width;
-		sd_state->pads->try_crop.height = fse.max_height;
+		try_crop->width = fse.max_width;
+		try_crop->height = fse.max_height;
 	}
 
 	ret = v4l2_subdev_call(subdev, pad, set_fmt, sd_state, &fmt);
-- 
2.51.0



