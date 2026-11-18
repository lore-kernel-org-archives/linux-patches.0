Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034395;
	b=R/DGYyu8aT0D6N8bIXOjOdETyAvW8mzfmk1yHtTpBfUAJ/eERyEHoCsdWHshz9nRzbB0
	 rxM4M2OTy+mnoazGmwhll78rEbcwqqNihWjXa8r0jqx218LpOtDKHz/I1qQJ7T6oGwLvL
	 fTkiLeRbka9ijWWLHiXO+KScYfaNCJ/oN0XJLcmr4x3WoDF+kONXJXkH6GE01OwR7ESor
	 b4+kiP0tdQ0YizBPlPaitKgoO4SPioz3r3W/NxfsZFfW5uaM5BEEM95+1donTgmdfnAiM
	 LcwBzgku5OPsw4olCrnUakRHVLhngNyA9NrQ/AzDqZRavd49exvC40kYvupElxlfkpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034395;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9B0rFw2bvd5EFOT8bZU4ILfvNeM4FrlEwfow63NP5Nw=;
	b=3xjr7NbpMMnceHXmnfxYQ6hgASjIxnz/HwJtp+byH7453bDt5JwaEVOClQwknwtStUyC
	 ca7iF9+ZTyRL/xY+VDcqoedS3wo4TXvvJolhIAg04Cl93VqLJjRdZ00JCAGYQr1mxn2Ck
	 9oAGd2Yl7t3GV31MN56kkf0mHOAxVReiO0XGnXkqaVq40wPIEP7iM6mNK6fVP4ObY+MKV
	 dL/Yq1I2xyVBxfGQQfsC4IaFjKkV8EbjNDRvahsbY0YPAhhjUFFSqJ8NmgpD6VmbVV7gD
	 akMIa3jOq8jwaTR97hDSzfnL3Dtc3BpwQUZ9Q0lUp64wylk1yZzQ1fBahsIzkWSK7sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiDFSX4b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B19606A31C;
	Wed, 18 Nov 2026 20:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IiDFSX4b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3F11F000C4;
	Wed, 18 Nov 2026 20:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034395;
	bh=9B0rFw2bvd5EFOT8bZU4ILfvNeM4FrlEwfow63NP5Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IiDFSX4bz20I77vGq0Tf0/LgQecgF6tyj5XVvPJfyliubYxzxQinSAw4mG42LNlU3
	 g++TKbwsRdINWXsDdhz8JhP2QGAaspQ512qrFOCKyXn2aRu8+ohU3gbP3kryqC8aa2
	 IyW69mWz6NpM7dmN1HyLC/0rd6YZo61ie5hTvowk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0354/3318] media: em28xx: use video_unregister_device for radio_dev
Date: Wed, 18 Nov 2026 15:16:16 +0100
Message-ID: <20261118150326.709714841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



