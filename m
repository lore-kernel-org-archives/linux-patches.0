Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043696;
	b=2MmsnpVukc6ydDccctC7eNXuLuZZAdDfI8TSuuFdkO5sg1RL8AsxuIJlNe8Bxnru0JHj
	 TYCZo1BDFvSnePU1tAxg7lj8ZuIysDwJYgZ+Qzj9qOoVP6glDcQXqko8sCe1b9BnjhNbP
	 WV36ym/AudiN87jrjgS7LT87HOyay4Z9L2GSZGBLEsC8Ep8BOwyJe3+WTmtcERKDp3sK1
	 YBDq7HI1QJjuMcWsFPJ63RtHmw0S+L6P82E9yhkXZ8HmvFiv/Z+Q5vd+wxdHmqLfOGCTI
	 wathF04vEgi+LVvkqMLmzmOUkjLoTR8oq1IMOT5ywtnaV9NoHY1w2+wfoAvYQubRbaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mh1BoikooqlI1IUUwdKpXXIhJj+pfbPou+5wzOwm+FI=;
	b=kF1DuJpPkpplmbomTbhJmb3JmUNmWRdTBzJc2RpJAurPpAF8WrbpmBIZ9edkDa1xSxWB
	 HwYVFPKhyXpH+lQqCAlco281eT2r502yXMG8E2fxEsxBxL5YLT/nRpnJghEnfUSHC3qVG
	 6A8p8CrJgUibfWj1Yqwh4Zsi90Jya3hiSVmb8ky3Cyxr+e+n+L9cFJjstLat7HqvjM9oE
	 XMjkizm3nJLGGtCUKUB4kMyOnkUHBZ4s4pCfBqMoiSnxOwkJFyCm0sPfyRRR8lAwKlK1e
	 Ipr/4GV+dt5i2bxxCePByCUZl4GIZRbPzgYdStwij2R9U1aRvmcH8oRpg3iJe0kKpdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjohcJPR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814E606A325;
	Wed, 18 Nov 2026 23:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rjohcJPR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFBF1F000C4;
	Wed, 18 Nov 2026 23:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043696;
	bh=Mh1BoikooqlI1IUUwdKpXXIhJj+pfbPou+5wzOwm+FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rjohcJPRurfy//2INbacodfUq49j+s6MpCZEOZuEikxBKa4R7+rYJijgEt41ZR/ct
	 Y6AcUFbFvnQOUOV4dJWmQN4nWCyIPoix7w0coAPe7GbCzdRBn53sTnk0ZfOx1sf5kz
	 ejReL74DFFa8R2QWldUI1s18FUESdssy3kof9sFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0302/2857] media: em28xx: use video_unregister_device for radio_dev
Date: Wed, 18 Nov 2026 15:22:16 +0100
Message-ID: <20261118150212.291692909@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index acc2fbadc609c..d2752b101e029 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2243,7 +2243,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		vb2_video_unregister_device(&v4l2->radio_dev);
+		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
@@ -2901,7 +2901,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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



