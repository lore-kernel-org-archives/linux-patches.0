Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6D927FD69;
	Tue, 27 May 2025 16:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365012; cv=none; b=Sl5N05q6iDDYaLpsubEKV8b7t34LOJFSbtb2vrpJxCljYDDGuNEU77wMsLMLXtkFzOKGAbC/5DwitkxAwTlUmfhFyFmPkkxNYfB2NcG8cMXN0ahPHl2KcrmbHtC52pd6gBSiGCNY2iiq97KnfqaO31vTWrvlAw7RyKI8iMjnKqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365012; c=relaxed/simple;
	bh=6P3o9BuQ9zaGFaBSSqt1jxEXAFKOZSgeOUlAYlvEWw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvbZDxW2qtZ+MP6mBBQwMmnrjdJFXmB57r77feI0xDBA5MVWMRps0NXUYYTMSU6qIw6Tp44NeepGyJNULeCx5GvVtXsBeM40QcIehVdb37li70obhot3izyotwvkHNBJATCm/RVZ8DHT7vNaAxMZtvYisNdvEZVTvej+vmiW2OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp6XpSbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp6XpSbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDA9C4CEE9;
	Tue, 27 May 2025 16:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365012;
	bh=6P3o9BuQ9zaGFaBSSqt1jxEXAFKOZSgeOUlAYlvEWw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp6XpSbvfADVyJcTR25r211Y+3FQAg2z02UCQ2aVAtYlIPAS4sH6M8a1rkOUl5hBp
	 h9vLN4FvjmhN7fNnYByXWjEEwXLAY+WAUPj8nR5hR1dqdCOo9Idg+nCZ2mYYbk3QAH
	 msUFL3sLMC9LthbKocCFGdcNpXdy4XuclNtOwclU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 239/626] media: cx231xx: set device_caps for 417
Date: Tue, 27 May 2025 18:22:12 +0200
Message-ID: <20250527162454.722778392@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index abb967c8bd352..6cb130eb32d58 100644
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



