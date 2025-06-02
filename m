Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784DE20E6E3;
	Mon,  2 Jun 2025 14:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875630; cv=none; b=K07fqjJYLiHMi9toV0SYPJsl4gC9b2Oc8JQPkOZSVO1vyUqVRPIIs91GDY0CtEFq/s9khQows5mMkUHjSCLvd/ivrVWBDZsiD/XJ6vVG/TCleAfzYobK0wMpAyhDkmy+EC7caNAavcGWSma5QcrgyVxA4OFYYgfbg76SM07TpQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875630; c=relaxed/simple;
	bh=bJUGL9sZhhk2Ln0vLhJXKrSgFe/eeB8hJu7HWzZksuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV2vV5zdZBysxxl3Vv3xJM1pLJYWX6/Qb/HDpz8btd3ShBHnbZDrRW5W81y2dJHggpebSawoMcOEiXrwkcd0fKAEOohEFm6PTbTIt//0WcvbdAU1IxoJxkh2R6MdewjBPSiXfFkaPNGcCl+d74Z7So2DgRd9jmtzauAWUWZj0PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PaOf6pMK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PaOf6pMK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA79CC4CEEB;
	Mon,  2 Jun 2025 14:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875630;
	bh=bJUGL9sZhhk2Ln0vLhJXKrSgFe/eeB8hJu7HWzZksuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PaOf6pMKcaIN+ZhyiMMcyOPeDqoeZ14BBMmliWeRFSb9ry32sNJM/8/uYFclWZxpt
	 hR+4lKkT1ygqkdKx/0et4DxYIAKCk3dwctVTge5itgwHM9RyTX4z/9dfRx5vIZAGJj
	 aAiax9b4VxGQhSVeRQJI+GWxbRDS3VGE3+gjZgWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/270] media: cx231xx: set device_caps for 417
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134313.922475775@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit a79efc44b51432490538a55b9753a721f7d3ea42 ]

The video_device for the MPEG encoder did not set device_caps.

Add this, otherwise the video device can't be registered (you get a
WARN_ON instead).

Not seen before since currently 417 support is disabled, but I found
this while experimenting with it.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-417.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index c5e21785fafe2..02343e88cc618 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1722,6 +1722,8 @@ static void cx231xx_video_dev_init(
 	vfd->lock = &dev->lock;
 	vfd->release = video_device_release_empty;
 	vfd->ctrl_handler = &dev->mpeg_ctrl_handler.hdl;
+	vfd->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
+			   V4L2_CAP_VIDEO_CAPTURE;
 	video_set_drvdata(vfd, dev);
 	if (dev->tuner_type == TUNER_ABSENT) {
 		v4l2_disable_ioctl(vfd, VIDIOC_G_FREQUENCY);
-- 
2.39.5



