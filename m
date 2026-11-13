Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591345;
	b=pc5180BMRXndplHI6V7ml74KVHnsc/1nZFy4+6swVLJn3QvyaDgmtCK63wYFGnR7WNjM
	 QyDvXE086bNhiYFqAUG9zKdHYnKcNIgPFhD0roeG6eXgCyYML4XvIjnG6rjp05myrWOMr
	 i78jL+EDeJYnV38m2+6mc0rZAKMQmv8YmY8MH8Z83mIhuIZwBuqG6CnibGMhT/ZOB8whz
	 bEbckGKk7fRMETEc8XkVGeTwqjyO0N6NanWNl9sm8+HcYmD8FIWj5WsMyA/lHPenrDMVs
	 JFAwaJK5Yn9Qoc4H84lMVoCEkuL4EXOeVNdWqs5tc8fJ26lQ2/tPXi+KoFeGk2qpK5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591345;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=065NG3isn1QwjV+ZNdFGoAgRLekx4D7BWEDZ6loN6zA=;
	b=TRfqeCiAo43fGW7kfWm1ub9+PquiVGNTaM8uTHF1xajiB3E9SE8ZBS6YUErhN4VnYlaO
	 YB6k4gqCDUQLZV1AX2wJz3gJ2VHik+OD0OfLQJNhQxxFd/KxlXXb3TS3j9HGzE0Z7V8W3
	 YVYzntggOCnzPaIHDm7agx+MVqcG3XhEmp9gHdKPsCPKDqb9oC375HX6Axe1p7gD6loro
	 DX3PLbVctC40yZn3L4erqgI/pTCo/vVIKGXpCcX5nLhTME0fexJQTSqDD4TRaxTnga2mr
	 B6x2xl+WF53rOhLT1+azKcXPu9mKI/1mVsFg4fQzBHf5nAtCBWu0m7LSKQMHDVPhmHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc5c0cJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5F6606ED8C;
	Fri, 13 Nov 2026 17:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sc5c0cJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2731F000C5;
	Fri, 13 Nov 2026 17:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591345;
	bh=065NG3isn1QwjV+ZNdFGoAgRLekx4D7BWEDZ6loN6zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sc5c0cJFWy0FJHE1EBXQIwZDNWKmlDEOL7Clgv65pnJMB//aptS6SHILbz+iZg3Q5
	 r6FV36mshYOspE2XisqjHxNUurHUcpsym+1CqX8ks/SGrSWT8ZmndvbmCBYkG7DLjZ
	 sUJIHeclUAdWfr0CvTHE1GOJMd5O/H1P01Vu1xPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 453/670] media: i2c: og01a1b: Switch from .s_stream to .enable_streams/.disable_streams
Date: Fri, 13 Nov 2026 10:50:17 -0500
Message-ID: <20261113153827.260144051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 3a594bb454ba1ecb005f753007fa1bb5c5e68bae ]

The change allows to simplify the driver code, in particular the explicit
locking scheme for stream on/off or format update serialization can be
dropped in favour to the one provided by the V4L2 core internals.

Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
[Sakari Ailus: Fix error handling for enable_streams callback.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: a26c5ac46191 ("media: i2c: og01a1b: power off sensor on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/og01a1b.c | 90 ++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 56 deletions(-)

diff --git a/drivers/media/i2c/og01a1b.c b/drivers/media/i2c/og01a1b.c
index 68573122cd6ee..95ead31dda278 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -442,9 +442,6 @@ struct og01a1b {
 
 	/* Current mode */
 	const struct og01a1b_mode *cur_mode;
-
-	/* To serialize asynchronus callbacks */
-	struct mutex mutex;
 };
 
 static u64 to_pixel_rate(u32 f_index)
@@ -616,7 +613,6 @@ static int og01a1b_init_controls(struct og01a1b *og01a1b)
 	if (ret)
 		return ret;
 
-	ctrl_hdlr->lock = &og01a1b->mutex;
 	og01a1b->link_freq = v4l2_ctrl_new_int_menu(ctrl_hdlr,
 						    &og01a1b_ctrl_ops,
 						    V4L2_CID_LINK_FREQ,
@@ -686,74 +682,66 @@ static void og01a1b_update_pad_format(const struct og01a1b_mode *mode,
 	fmt->field = V4L2_FIELD_NONE;
 }
 
-static int og01a1b_start_streaming(struct og01a1b *og01a1b)
+static int og01a1b_enable_streams(struct v4l2_subdev *sd,
+				  struct v4l2_subdev_state *state, u32 pad,
+				  u64 streams_mask)
 {
+	struct og01a1b *og01a1b = to_og01a1b(sd);
+	unsigned int link_freq_index = og01a1b->cur_mode->link_freq_index;
 	const struct og01a1b_reg_list *reg_list;
-	int link_freq_index, ret;
+	int ret;
 
-	link_freq_index = og01a1b->cur_mode->link_freq_index;
-	reg_list = &link_freq_configs[link_freq_index].reg_list;
+	ret = pm_runtime_resume_and_get(og01a1b->dev);
+	if (ret)
+		return ret;
 
+	reg_list = &link_freq_configs[link_freq_index].reg_list;
 	ret = og01a1b_write_reg_list(og01a1b, reg_list);
 	if (ret) {
-		dev_err(og01a1b->dev, "failed to set plls");
-		return ret;
+		dev_err(og01a1b->dev, "failed to set plls: %d\n", ret);
+		goto error;
 	}
 
 	reg_list = &og01a1b->cur_mode->reg_list;
 	ret = og01a1b_write_reg_list(og01a1b, reg_list);
 	if (ret) {
-		dev_err(og01a1b->dev, "failed to set mode");
-		return ret;
+		dev_err(og01a1b->dev, "failed to set mode: %d\n", ret);
+		goto error;
 	}
 
 	ret = __v4l2_ctrl_handler_setup(og01a1b->sd.ctrl_handler);
 	if (ret)
-		return ret;
+		goto error;
 
 	ret = og01a1b_write_reg(og01a1b, OG01A1B_REG_MODE_SELECT,
 				OG01A1B_REG_VALUE_08BIT,
 				OG01A1B_MODE_STREAMING);
 	if (ret) {
-		dev_err(og01a1b->dev, "failed to set stream");
-		return ret;
+		dev_err(og01a1b->dev, "failed to start streaming: %d\n", ret);
+		goto error;
 	}
 
 	return 0;
-}
 
-static void og01a1b_stop_streaming(struct og01a1b *og01a1b)
-{
-	if (og01a1b_write_reg(og01a1b, OG01A1B_REG_MODE_SELECT,
-			      OG01A1B_REG_VALUE_08BIT, OG01A1B_MODE_STANDBY))
-		dev_err(og01a1b->dev, "failed to set stream");
+error:
+	pm_runtime_put_autosuspend(og01a1b->dev);
+
+	return ret;
 }
 
-static int og01a1b_set_stream(struct v4l2_subdev *sd, int enable)
+static int og01a1b_disable_streams(struct v4l2_subdev *sd,
+				   struct v4l2_subdev_state *state, u32 pad,
+				   u64 streams_mask)
 {
 	struct og01a1b *og01a1b = to_og01a1b(sd);
-	int ret = 0;
-
-	mutex_lock(&og01a1b->mutex);
-	if (enable) {
-		ret = pm_runtime_resume_and_get(og01a1b->dev);
-		if (ret) {
-			mutex_unlock(&og01a1b->mutex);
-			return ret;
-		}
+	int ret;
 
-		ret = og01a1b_start_streaming(og01a1b);
-		if (ret) {
-			enable = 0;
-			og01a1b_stop_streaming(og01a1b);
-			pm_runtime_put(og01a1b->dev);
-		}
-	} else {
-		og01a1b_stop_streaming(og01a1b);
-		pm_runtime_put(og01a1b->dev);
-	}
+	ret = og01a1b_write_reg(og01a1b, OG01A1B_REG_MODE_SELECT,
+				OG01A1B_REG_VALUE_08BIT, OG01A1B_MODE_STANDBY);
+	if (ret)
+		dev_err(og01a1b->dev, "failed to stop streaming: %d\n", ret);
 
-	mutex_unlock(&og01a1b->mutex);
+	pm_runtime_put_autosuspend(og01a1b->dev);
 
 	return ret;
 }
@@ -771,7 +759,6 @@ static int og01a1b_set_format(struct v4l2_subdev *sd,
 				      height, fmt->format.width,
 				      fmt->format.height);
 
-	mutex_lock(&og01a1b->mutex);
 	og01a1b_update_pad_format(mode, &fmt->format);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY) {
 		*v4l2_subdev_state_get_format(sd_state, fmt->pad) = fmt->format;
@@ -794,8 +781,6 @@ static int og01a1b_set_format(struct v4l2_subdev *sd,
 					 h_blank);
 	}
 
-	mutex_unlock(&og01a1b->mutex);
-
 	return 0;
 }
 
@@ -805,15 +790,12 @@ static int og01a1b_get_format(struct v4l2_subdev *sd,
 {
 	struct og01a1b *og01a1b = to_og01a1b(sd);
 
-	mutex_lock(&og01a1b->mutex);
 	if (fmt->which == V4L2_SUBDEV_FORMAT_TRY)
 		fmt->format = *v4l2_subdev_state_get_format(sd_state,
 							    fmt->pad);
 	else
 		og01a1b_update_pad_format(og01a1b->cur_mode, &fmt->format);
 
-	mutex_unlock(&og01a1b->mutex);
-
 	return 0;
 }
 
@@ -849,18 +831,14 @@ static int og01a1b_enum_frame_size(struct v4l2_subdev *sd,
 
 static int og01a1b_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
 {
-	struct og01a1b *og01a1b = to_og01a1b(sd);
-
-	mutex_lock(&og01a1b->mutex);
 	og01a1b_update_pad_format(&supported_modes[0],
 				  v4l2_subdev_state_get_format(fh->state, 0));
-	mutex_unlock(&og01a1b->mutex);
 
 	return 0;
 }
 
 static const struct v4l2_subdev_video_ops og01a1b_video_ops = {
-	.s_stream = og01a1b_set_stream,
+	.s_stream = v4l2_subdev_s_stream_helper,
 };
 
 static const struct v4l2_subdev_pad_ops og01a1b_pad_ops = {
@@ -868,6 +846,8 @@ static const struct v4l2_subdev_pad_ops og01a1b_pad_ops = {
 	.get_fmt = og01a1b_get_format,
 	.enum_mbus_code = og01a1b_enum_mbus_code,
 	.enum_frame_size = og01a1b_enum_frame_size,
+	.enable_streams = og01a1b_enable_streams,
+	.disable_streams = og01a1b_disable_streams,
 };
 
 static const struct v4l2_subdev_ops og01a1b_subdev_ops = {
@@ -1062,7 +1042,6 @@ static void og01a1b_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(og01a1b->dev);
-	mutex_destroy(&og01a1b->mutex);
 }
 
 static int og01a1b_probe(struct i2c_client *client)
@@ -1146,7 +1125,6 @@ static int og01a1b_probe(struct i2c_client *client)
 		goto power_off;
 	}
 
-	mutex_init(&og01a1b->mutex);
 	og01a1b->cur_mode = &supported_modes[0];
 	ret = og01a1b_init_controls(og01a1b);
 	if (ret) {
@@ -1154,6 +1132,7 @@ static int og01a1b_probe(struct i2c_client *client)
 		goto probe_error_v4l2_ctrl_handler_free;
 	}
 
+	og01a1b->sd.state_lock = og01a1b->ctrl_handler.lock;
 	og01a1b->sd.internal_ops = &og01a1b_internal_ops;
 	og01a1b->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	og01a1b->sd.entity.ops = &og01a1b_subdev_entity_ops;
@@ -1194,7 +1173,6 @@ static int og01a1b_probe(struct i2c_client *client)
 
 probe_error_v4l2_ctrl_handler_free:
 	v4l2_ctrl_handler_free(og01a1b->sd.ctrl_handler);
-	mutex_destroy(&og01a1b->mutex);
 
 power_off:
 	og01a1b_power_off(og01a1b->dev);
-- 
2.53.0



