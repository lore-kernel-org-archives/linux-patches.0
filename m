Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061113;
	b=3lNEp9ADk469CATiU69GtUuGx6KM6G+9xofZ+enZ5F2sCEIWPvhMZlYJ9Jq9qd7PkE2X
	 PGItJLjLrvi2JbevfPfgYEpQORGGMAv/L+ozr6I0uKHZ6EqRhkDhMieWWWk8QbQuoDwV/
	 Y0LgQKIFLb/v2WnrkKFseA3d09a3r75ac6nf/iZkJyoQZZH6X02UwQOcB6rXYkgYNE3/2
	 GSbpcGfDOw7OPmxXccipo2pjpAVPKXFtxJOKX2U0PEW4MuqYeVWOf30qsqM2WGvNIKnyf
	 WFkblAghcqoA7ZXXY6oSOZxDYEOvv+pD/9KvYrIXsxQo5G+EhzqF6u3E8hY+VTV94PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r3yfC9kHygrHDvM1UtHs8PjVRgfX/dU50dQVozq1hyA=;
	b=Im3+d1rO25MrADjDzLa+cyVqYWga2oRQE7rromJ0nLKxdycduQj16cgFIMu9gf/V0vcZ
	 KWd2mU5W819VR2nzPECy6LRT34jp67s/e+Z6ms8+MRcArDCJs0kfpUV7NOUw4FUZvHw6n
	 kMjT7qoPAmWWurOcHZ1t5KfN3vLeXpKIY6Y59LO4sJ6Sfpm6nIqlsegWkrtcGrSJPqHu0
	 9xY0kttGzowWIdY8kL7ld9/cFOKt1nkMwAgvGpwru9krEtcysVSKafLd0haJmoqcoaIH/
	 sx6RdhgxmcOtAYwTmdrj2EGNq1foJFQp7fkwQ/WO72JU5Dj8nn7UpTdi4KpG7sMLV5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLePL5tB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CAA606A332;
	Sat,  7 Nov 2026 14:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DLePL5tB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133F71F0089F;
	Sat,  7 Nov 2026 14:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061113;
	bh=r3yfC9kHygrHDvM1UtHs8PjVRgfX/dU50dQVozq1hyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DLePL5tBcJwSX7e1zN9q+oS1phbYWjeEMZTkdC+7muKyJGV2HaPfZJ93ZF123TOF6
	 nds8PTpXtatQ6dhvr+Zs+wYaTVJsJy1b/Px+kURmtHelYZcdgjJYpe8c7hQ29mFkHu
	 3jYSNcIaFBNadakOH+IF2e+lI4JCDMoysadezHFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0430/1536] media: em28xx: use video_unregister_device for radio_dev
Date: Sat,  7 Nov 2026 08:40:46 -0500
Message-ID: <20261107135009.644071852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Rohinthan P <rokinthanp03@gmail.com>

[ Upstream commit 2579cbe68005f46fc7f8f95364f6b101b07b9d1c ]

Commit 7c8bf63b7937 ("media: em28xx: use vb2_video_unregister_device")
converted device unregistrations in em28xx to use
vb2_video_unregister_device() instead of video_unregister_device().

However, radio devices do not have an associated videobuf2 queue
(v4l2->radio_dev.queue is NULL). Calling vb2_video_unregister_device()
on a radio device triggers a WARNING in vb2_video_unregister_device():

    !vdev->queue
    WARNING: drivers/media/common/videobuf2/videobuf2-v4l2.c:1264 at vb2_video_unregister_device+0x1f8/0x200
    Call Trace:
     em28xx_v4l2_init+0x1c39/0x3150 drivers/media/usb/em28xx/em28xx-video.c:3085

As documented in vb2_video_unregister_device(), video_unregister_device()
should be used instead when vdev->queue is NULL.

Revert to calling video_unregister_device() for v4l2->radio_dev in both
em28xx_v4l2_fini() and the em28xx_v4l2_init() error unwind path.

Fixes: 7c8bf63b7937 ("media: em28xx: use vb2_video_unregister_device")
Reported-by: syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f26bc23e42eeb548dee1
Signed-off-by: Rohinthan P <rokinthanp03@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-video.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index d473f8dd5cdc1..6e3f3470b9d8a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2245,7 +2245,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		vb2_video_unregister_device(&v4l2->radio_dev);
+		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
@@ -2903,7 +2903,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 		dev_info(&dev->intf->dev,
 			 "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		vb2_video_unregister_device(&v4l2->radio_dev);
+		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev,
-- 
2.53.0



