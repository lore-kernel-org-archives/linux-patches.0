Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18E7340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300999; cv=none; b=e37wy5l7DPSizcQXxofPdtV36pv/9gc1ZYN3vhgLG9rK6Bg/u8c7ZGqTa5hB0N/ehvUsYvDEkUDK1PuE3/xQ5kZLDbwkT0HJl92iO/LnGCJvOvYDCSdkjxtnaHm+9SZBZC1aBsGiWTfvoUqiPc+hK3wzvi/4CcENxwBb8kbi4Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300999; c=relaxed/simple;
	bh=jxCt0uMfHKs951p72ivQYkem2ETitUUGW3QD0odWOgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5WxQSZYOVQYO3niIKygUpvZgj6zjB+bEJ2Oqug0LPWvzAbDWvMScHfC4Ftx0pp0a2x6OljMCtbP9j+aUb1/W5kQ6tDeDGItfH8HMUtcExbG6zsK5NEaMu2rgD+hbpDkhzPPXQtlIJguckyhyd8jnSU2VGL22653F78ILuY8Urc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o4ifsUru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o4ifsUru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3250CC19423;
	Sat, 28 Feb 2026 17:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300999;
	bh=jxCt0uMfHKs951p72ivQYkem2ETitUUGW3QD0odWOgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o4ifsUruaFq02TEb1sURAQeV27/Hi9uiaN4gmL9K5pZ3kHJFZbU/IOdljw1ij65OA
	 OixLKRf7VzgkEFd94WNQjXqIRoekfynfP2U9xNhAF+583VKwcEfuzAoKEf+vq8eCAE
	 Zr9DOLFCHUXSCaUf+om49QU6/KdqXMRsQQPhUrKN0Un0uXs/O8Nd46C/H/E9nmo7Xu
	 HtPXobVPkjZho/b4D/gkNZ58vQehzysGI7uzupMmWBIvSXz8h+8dAqor5uSP+/GWXr
	 otU9gtaBu2BfBBDEXfbds+kTVBwxAImD3uhkBIvYX5RFKKAqKjYDdEs01aRF1Ow1G5
	 TnnGNtcEsm5Vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 132/752] media: omap3isp: set initial format
Date: Sat, 28 Feb 2026 12:37:23 -0500
Message-ID: <20260228174750.1542406-132-sashal@kernel.org>
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

From: Hans Verkuil <hverkuil+cisco@kernel.org>

[ Upstream commit 7575b8dfa91f82fcb34ffd5568ff415ac4685794 ]

Initialize the v4l2_format to a default. Empty formats are
not allowed in V4L2, so this fixes v4l2-compliance issues:

	fail: v4l2-test-formats.cpp(514): !pix.width || !pix.height
test VIDIOC_G_FMT: FAIL

Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/ti/omap3isp/ispvideo.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/platform/ti/omap3isp/ispvideo.c b/drivers/media/platform/ti/omap3isp/ispvideo.c
index 68e6a24be5614..eb33a776f27c9 100644
--- a/drivers/media/platform/ti/omap3isp/ispvideo.c
+++ b/drivers/media/platform/ti/omap3isp/ispvideo.c
@@ -1288,6 +1288,7 @@ static const struct v4l2_ioctl_ops isp_video_ioctl_ops = {
 static int isp_video_open(struct file *file)
 {
 	struct isp_video *video = video_drvdata(file);
+	struct v4l2_mbus_framefmt fmt;
 	struct isp_video_fh *handle;
 	struct vb2_queue *queue;
 	int ret = 0;
@@ -1330,6 +1331,13 @@ static int isp_video_open(struct file *file)
 
 	memset(&handle->format, 0, sizeof(handle->format));
 	handle->format.type = video->type;
+	handle->format.fmt.pix.width = 720;
+	handle->format.fmt.pix.height = 480;
+	handle->format.fmt.pix.pixelformat = V4L2_PIX_FMT_UYVY;
+	handle->format.fmt.pix.field = V4L2_FIELD_NONE;
+	handle->format.fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
+	isp_video_pix_to_mbus(&handle->format.fmt.pix, &fmt);
+	isp_video_mbus_to_pix(video, &fmt, &handle->format.fmt.pix);
 	handle->timeperframe.denominator = 1;
 
 	handle->video = video;
-- 
2.51.0

