Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8E440911F;
	Fri,  7 Aug 2026 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116423; cv=none; b=s8JQ8gYLtGuQKGDrBWsgZJkaUY4ip8vIlOKOVM0O/K1aPm3Ef+EnmVB7CySVKknBr/GUVWv0/ThNJE9mWlUzv9X23GD3O2DqDXC+6d02C4qdzSTzmo09ikMg8lvmfP4IfHqb4amzMFbIsgHVM3RKaH5YsZI/nsnTNLPjI59KGpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116423; c=relaxed/simple;
	bh=t0sJ58VQh0zeR4zgp7Hs7yX2lxfmQGb6l+GZKwb6KBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hrt7j6G18G48nA9yTSyLQJNYGAw46zwrvJTNWWgC/9jg4sR6BF+Gh1Is77ZMrpCjH29GVzOrza7c84Idz5+MaM2RIF4WQwYuwiaxyNo+LbQF/NaVVmnaiKVmPS3TQf98nK0j1IAMn4SFm8KcVg3DY7XvAREhdVe2ypwvyuqGxL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUWGzCE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUWGzCE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93A411F000E9;
	Fri,  7 Aug 2026 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116422;
	bh=pan9yDUC/lrQFjQYEKbmjdQTPmgkzdT5foY9g2i2wNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUWGzCE6s2J6dCMQoj2vRrDRgMgaAwyQefXGVbYcf9Qhyk8TgiCOXBEFFRzwhuNUI
	 l8pqtdT4xQYmL7iZwXAToEcc66xEavze7ie2mIi8C0TJQQLBeubpfxIjuLBGNdwBIG
	 J836oLVg+KBJxQ73c1jBzdT4u5sCbHl864ImUVjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 227/261] media: i2c: imx219: Access height from active format in imx219_set_ctrl
Date: Fri,  7 Aug 2026 16:39:44 +0200
Message-ID: <20260807143420.268284647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit aa86ac42eec4dd7e987c12390a0a487187e2d9ae ]

Use the active format height instead of the mode height in
imx219_set_ctrl(). This prepares for dropping the mode field from the
imx219 structure.

The state is retrieved using v4l2_subdev_get_locked_active_state() as
the subdev active state and the control handler share the same lock.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: 2c4f1ba73543 ("media: imx219: Fix maximum frame length in lines")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -500,13 +500,18 @@ static int imx219_set_ctrl(struct v4l2_c
 	struct imx219 *imx219 =
 		container_of(ctrl->handler, struct imx219, ctrl_handler);
 	struct i2c_client *client = v4l2_get_subdevdata(&imx219->sd);
+	const struct v4l2_mbus_framefmt *format;
+	struct v4l2_subdev_state *state;
 	int ret = 0;
 
+	state = v4l2_subdev_get_locked_active_state(&imx219->sd);
+	format = v4l2_subdev_get_pad_format(&imx219->sd, state, 0);
+
 	if (ctrl->id == V4L2_CID_VBLANK) {
 		int exposure_max, exposure_def;
 
 		/* Update max exposure while meeting expected vblanking */
-		exposure_max = imx219->mode->height + ctrl->val - 4;
+		exposure_max = format->height + ctrl->val - 4;
 		exposure_def = (exposure_max < IMX219_EXPOSURE_DEFAULT) ?
 			exposure_max : IMX219_EXPOSURE_DEFAULT;
 		__v4l2_ctrl_modify_range(imx219->exposure,
@@ -546,7 +551,7 @@ static int imx219_set_ctrl(struct v4l2_c
 		break;
 	case V4L2_CID_VBLANK:
 		cci_write(imx219->regmap, IMX219_REG_VTS,
-			  imx219->mode->height + ctrl->val, &ret);
+			  format->height + ctrl->val, &ret);
 		break;
 	case V4L2_CID_TEST_PATTERN_RED:
 		cci_write(imx219->regmap, IMX219_REG_TESTP_RED,


