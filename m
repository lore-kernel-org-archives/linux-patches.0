Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBC52C325E;
	Mon,  2 Jun 2025 15:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876985; cv=none; b=pYlY+gus/85t7buUBYWfA0fjsUY+ezhukFZEkqWvxogqLXued1iQZ8uIUrB84aBstougPPnyvHsMHSsWZ23C7bfyshk2i/v1TvlEw5HVIvepzbLiMAFqiC6SR7GBpNCuwx+Px5iY18P2RZCciqThFnWog3XmANV9uv/fQzPAOFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876985; c=relaxed/simple;
	bh=XCEpZ2s29Hpg0iXG7rxzj0/dTThdLO2ff2Mx0+PxPTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzL6fbKG0iL/vGdHC9M9Kg7TFPPfcGar3OuQ6INHqK+xJzSPgbr3YaL1lEkoPjhM848hA9p5HKxoJqLPOrVZrLKtOqXr3lNX1yVIrv4Wn6JnkPIy/AxGZ+v/rpNp5yyzm0qecDyecLt44Ryrwh9DJrIHivPYJe22Y0iAttXklcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hihJVWRD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hihJVWRD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83320C4CEF2;
	Mon,  2 Jun 2025 15:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876984;
	bh=XCEpZ2s29Hpg0iXG7rxzj0/dTThdLO2ff2Mx0+PxPTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hihJVWRDD26h9G5WvJTB5PU7p2Zfd1ARwtDIaXNOJVM4HM3POLUtvDRZTWRCOfn5v
	 5vKOgjKFxOgl47GmfX3M6Ki17/Tn3fEC0lUSBr7oXgw4L/zo6XQli348SSg6GC44zi
	 37Clx/Y10RZ+76xySKq4QNTu7L4IKBDdo1OV301Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/325] media: cx231xx: set device_caps for 417
Date: Mon,  2 Jun 2025 15:46:24 +0200
Message-ID: <20250602134324.173655069@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



