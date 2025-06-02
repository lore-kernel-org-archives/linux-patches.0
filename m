Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6246E224AF1;
	Mon,  2 Jun 2025 14:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876104; cv=none; b=OGsFa+V7TSSq2HNg86zQAPQTC0T/NG5TxefcDl4XPsuopE+1lMX0njAtrQ7jQudvYwWY/3q5Jt53mf9+pv1FQcCDFX6cu2GK6yCR8g50Uw0VvTEQgFk1zkVGAPySfylQT1renuXVQIDcVDdSyQzXWXTp249gnT2+iyjte8DxRyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876104; c=relaxed/simple;
	bh=jEu0Yp455vhsN0JIeWp4mOiEKupQRFFRxWXkgUfPhG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHQ0mi1bYF2ssvES6eR1129V0piyAedO2vRKQ1g1jAtm1ArN4f1qCU3hQ7Vx3CYB5RpCxvOSUrhJVSYWe4TaLiPsh90yRdwWkofC/5WNO1teD0PnaQprxsa/LHqiayt9bnumSN2lVnX1PzUahDGhhyO+T2RVspLn83ukyZ6eL6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2nzYUv3G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2nzYUv3G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA55C4CEEB;
	Mon,  2 Jun 2025 14:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876104;
	bh=jEu0Yp455vhsN0JIeWp4mOiEKupQRFFRxWXkgUfPhG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2nzYUv3G4qI46CQqXOUjG5jZ2Lu86p21LjvhpuUXDOw3dUiCFoLP8nKvJQZXSAML0
	 6sH3lkDOgrXNluX2LZZ1dZK2kzED0902pQZE3SCfN5FyrbC24ySXXcfNpea+mma0Un
	 hdGePaZC4YIUoD3tziTFtqzM2dUcAw0buqxJT0h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/207] media: cx231xx: set device_caps for 417
Date: Mon,  2 Jun 2025 15:47:24 +0200
Message-ID: <20250602134301.559592939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



