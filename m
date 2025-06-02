Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4851B81DC;
	Mon,  2 Jun 2025 14:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874738; cv=none; b=K9sUdP8zIymfenEU5KjD38nNDKRIjxOq4bCG99fPpqfsSVWJpWnWSes8u63nlNEgJg47JhXV/Wy64ZsrPLKIeTct7ZgX0yId/JPA1ES7Cna/4VHPuh79sI2MFIs91lhlUu7ueg+IDag/4YXmlAU+XNkd9Nojk8u5NoCJr4xN9Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874738; c=relaxed/simple;
	bh=249J1jcHF/fJtX+Ux+0ceH+jpeimQBGcW7vvLhDgog8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt34l3TtSINK4WlJ441X1LS3nsRFhymBCA3PEwgfA1I07tCZTzygmoZhrmQi1VOmjwOu6HI1CgIcYuuu5PXal92E23Fgko/A1P7kYpu3QIr12ObCR9kpTPvbcGABaZI8YJ8pQ2fyrsQNigQs8lnKeOAGypz6zvEvcPrWc4KAe1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zY802UL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zY802UL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC9CDC4CEEB;
	Mon,  2 Jun 2025 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874738;
	bh=249J1jcHF/fJtX+Ux+0ceH+jpeimQBGcW7vvLhDgog8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zY802UL1Odcfbp/V06F1PAKYZRqHHzkYA3NNaxBdWhPINOq/cXj5XRthu+qD/ODwS
	 ip/nvQ9NqeBWeTsE5UucJ0Lb79qnVpFTFZ5Ta2Z5X90sU+yE7GixDnhLovEZ6ccQrb
	 usP5IB9wHxeqPxmtbGHq80x0yuktRy1syrkFoleY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 121/204] media: cx231xx: set device_caps for 417
Date: Mon,  2 Jun 2025 15:47:34 +0200
Message-ID: <20250602134300.406331027@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6d218a0369661..a9d080823f10a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1966,6 +1966,8 @@ static void cx231xx_video_dev_init(
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



