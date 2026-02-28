Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7F047B43F;
	Sat, 28 Feb 2026 17:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301296; cv=none; b=ZLrfPICDVPP4D8DbgPSlLXiY+AG9Lx2ERdwp6Ld0cfb4v8Wv5AJzx0RmQeCAYUobXjGY0Rj0TTfeEzRl5jUeqPgIRYRZDJHqJzmw6hwX7dY4EHMn+5dBwb4uGSdKSmJ6A9plmlYUBnjffsd2at4DDDNi0q2eMU7bBdcLVkLpGYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301296; c=relaxed/simple;
	bh=fdZxNkDEir7Gj+h8PL+4WK7qPvK1K5hf3Uh8lZeH47E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a9AR8yxCm9fonoOfYeOYxh34mjVQ3DVug2fzVKl5inYmQRo6ZeZ4TfhlkPzymCcuX8tHRITqzP/UO8WxivmAFf/iyASUNroIdxlzmZRusUkDoY5GMdSxi+Iw3n2JeTakwEeLt9FOc/YW2Ae8RVLzPj2R5BMzjtKxt/WuoPPwebM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pVB+IgE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pVB+IgE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3736C2BCB0;
	Sat, 28 Feb 2026 17:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301296;
	bh=fdZxNkDEir7Gj+h8PL+4WK7qPvK1K5hf3Uh8lZeH47E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pVB+IgE/pPvZI9oPHnwb0eeYK8U9PyD0M95M0FWKITenTjGhmeUCQ22eNP0hqMZG9
	 8Ou5iTILJs9hu1azOtZCBrWVE2Yyd61kEQSosR2OYvrvVvKmPGvnZ3MmjZfDwgeJWO
	 MLLQqYgnlrnXEUG+AQ8IyM7goNOtFxk2i5mqRuebfncdORLuM7B6Cq185VDtb/R/6M
	 CT8sP7EDJFdVMXrWOOiN0YWzoOpMj9Vpl7OicQDx9lLEeq+gZxYo7Ycj+Sj3mLNwE2
	 +rOA/0n45N0/+NyAeaLF3P30qUGdoNvXpl4KXOf7BF0cUTc4m/uYhYZyuJyjVbNVOB
	 x98UFDuix7EUg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ricardo Ribalda <ribalda@chromium.org>,
	stable@vger.kernel.org,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 481/752] media: uvcvideo: Fix support for V4L2_CTRL_FLAG_HAS_WHICH_MIN_MAX
Date: Sat, 28 Feb 2026 12:43:12 -0500
Message-ID: <20260228174750.1542406-481-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 4238bd6dc6ba36f44d89a60338223d5a4f708cbf ]

The VIDIOC_G_EXT_CTRLS with which V4L2_CTRL_WHICH_(MIN|MAX)_VAL can only
work for controls that have previously announced support for it.

This patch fixes the following v4l2-compliance error:

  info: checking extended control 'User Controls' (0x00980001)
  fail: v4l2-test-controls.cpp(980): ret != EINVAL (got 13)
        test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL

Fixes: 39d2c891c96e ("media: uvcvideo: support V4L2_CTRL_WHICH_MIN/MAX_VAL")
Cc: stable@vger.kernel.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 14 ++++++++++++--
 drivers/media/usb/uvc/uvc_v4l2.c | 10 ++++++----
 drivers/media/usb/uvc/uvcvideo.h |  2 +-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 2905505c240c0..2738ef74c7373 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1432,7 +1432,7 @@ static bool uvc_ctrl_is_readable(u32 which, struct uvc_control *ctrl,
  * auto_exposure=1, exposure_time_absolute=251.
  */
 int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
-			   const struct v4l2_ext_controls *ctrls,
+			   const struct v4l2_ext_controls *ctrls, u32 which,
 			   unsigned long ioctl)
 {
 	struct uvc_control_mapping *master_map = NULL;
@@ -1442,14 +1442,24 @@ int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
 	s32 val;
 	int ret;
 	int i;
+	/*
+	 * There is no need to check the ioctl, all the ioctls except
+	 * VIDIOC_G_EXT_CTRLS use which=V4L2_CTRL_WHICH_CUR_VAL.
+	 */
+	bool is_which_min_max = which == V4L2_CTRL_WHICH_MIN_VAL ||
+				which == V4L2_CTRL_WHICH_MAX_VAL;
 
 	if (__uvc_query_v4l2_class(chain, v4l2_id, 0) >= 0)
-		return -EACCES;
+		return is_which_min_max ? -EINVAL : -EACCES;
 
 	ctrl = uvc_find_control(chain, v4l2_id, &mapping);
 	if (!ctrl)
 		return -EINVAL;
 
+	if ((!(ctrl->info.flags & UVC_CTRL_FLAG_GET_MIN) ||
+	     !(ctrl->info.flags & UVC_CTRL_FLAG_GET_MAX)) && is_which_min_max)
+		return -EINVAL;
+
 	if (ioctl == VIDIOC_G_EXT_CTRLS)
 		return uvc_ctrl_is_readable(ctrls->which, ctrl, mapping);
 
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 9e4a251eca880..30c160daed8cb 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -765,14 +765,15 @@ static int uvc_ioctl_query_ext_ctrl(struct file *file, void *priv,
 
 static int uvc_ctrl_check_access(struct uvc_video_chain *chain,
 				 struct v4l2_ext_controls *ctrls,
-				 unsigned long ioctl)
+				 u32 which, unsigned long ioctl)
 {
 	struct v4l2_ext_control *ctrl = ctrls->controls;
 	unsigned int i;
 	int ret = 0;
 
 	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
-		ret = uvc_ctrl_is_accessible(chain, ctrl->id, ctrls, ioctl);
+		ret = uvc_ctrl_is_accessible(chain, ctrl->id, ctrls, which,
+					     ioctl);
 		if (ret)
 			break;
 	}
@@ -806,7 +807,7 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *priv,
 		which = V4L2_CTRL_WHICH_CUR_VAL;
 	}
 
-	ret = uvc_ctrl_check_access(chain, ctrls, VIDIOC_G_EXT_CTRLS);
+	ret = uvc_ctrl_check_access(chain, ctrls, which, VIDIOC_G_EXT_CTRLS);
 	if (ret < 0)
 		return ret;
 
@@ -840,7 +841,8 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 	if (!ctrls->count)
 		return 0;
 
-	ret = uvc_ctrl_check_access(chain, ctrls, ioctl);
+	ret = uvc_ctrl_check_access(chain, ctrls, V4L2_CTRL_WHICH_CUR_VAL,
+				    ioctl);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 3f2e832025e71..8480d65ecb85e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -787,7 +787,7 @@ int uvc_ctrl_get(struct uvc_video_chain *chain, u32 which,
 		 struct v4l2_ext_control *xctrl);
 int uvc_ctrl_set(struct uvc_fh *handle, struct v4l2_ext_control *xctrl);
 int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
-			   const struct v4l2_ext_controls *ctrls,
+			   const struct v4l2_ext_controls *ctrls, u32 which,
 			   unsigned long ioctl);
 
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
-- 
2.51.0

