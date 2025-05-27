Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E382D2110E;
	Tue, 27 May 2025 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367132; cv=none; b=S6UzGe6NMDeMDnTql/qpgLse0t+I0WfcjeYmSYeNmuvaBY49ea9JQVS7D56RNuJglRXrQuLP+a3OIGl6lDnR01mYp8PcfA0ZSF6CKNcXCmu67aKi+DbC2fGs0ihK9at6Bl4nFpa31pFqxLltC4p6N3YeTQ2DV5kwzlHKrMGej98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367132; c=relaxed/simple;
	bh=hCvYQ/EgsT9/NaU6QBDNg/JbS9rGwmGXPuEVn6a8vcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrxobzIYhnHlipZM6q/gUihWZHtnKq/qrASP38rafZXO31tQuvnEqG9qSn+qHZ9cK76w2GlYn7gqNiRxulPNyWi5cQhwJ41olpGq+Lek6QtfJSnEreSNF3gUfJWbsdozBF94qcpIyKw1B7RgJyxuasjWNg0tDc+7l+Kcoxfv1wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wz2K7IMy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wz2K7IMy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E056C4CEE9;
	Tue, 27 May 2025 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367131;
	bh=hCvYQ/EgsT9/NaU6QBDNg/JbS9rGwmGXPuEVn6a8vcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wz2K7IMyFUQpQVR+M2yEL87mnIGVUKuzNtdbQP7ny2IN3uX3cI5Vr0s23e2OKfSVK
	 rrFd2mS81yPQutZtDF2b5he82cwpmpMrdDbVRjF5u8L7b63+ZDYzsebdFGt1NnibCc
	 UE1ggfJ2HZXwCwMSOOE2QWIkASON0GYIuyoFLv2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 289/783] media: cx231xx: set device_caps for 417
Date: Tue, 27 May 2025 18:21:26 +0200
Message-ID: <20250527162524.858195346@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index a4a9781328c50..06d61e52f018c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1720,6 +1720,8 @@ static void cx231xx_video_dev_init(
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



