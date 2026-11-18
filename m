Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057652;
	b=3Ig3xuLCIqaAGHSY7FuIyPoebFR/AYRmGmKq1WeG4ibPvJEpPk+jfJoseiFog9qInQ0u
	 l7IUGYCAFpQ+/zrAealb1B+8AAYfwrhz3m9fSXRt3GgM+E3vVoSXTGQPhPzdeVk0iDx43
	 7+iIpo34L53KmuDXn9UPFU46gY8QwOaTjh8+mZ1UzarLWRsYTzNHH/i+sLv5bscXnQvFG
	 aVb2NWqnpzrZASnsypJJPy0kUlr0uYH4v8fZh4Yb1nNhGhKqEJIdtw+YS6L7s4LH1WhbS
	 ROibT3I5fT3NfLP95ZXyHurU0xT7bvbLIM4wUS4NXv3XHbYVcfKpeEZHJm2/XzXQdBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=loVx+lp5CJ3T3FGbo5l845fRt+vAHXHZqzoW//ciZYM=;
	b=PEk5IrgkQUzYnALJIfwKC29MGbcs1LTh5qSgQOXGw/jLUyARLlgw4II4ke1MtJlz72Ct
	 afADa3vC33LEVbQQo6ihaASPYN6qXEgB8FWswBstmJTkd5K3GrmJTSL0BFqpm/+3mb666
	 6XTwTBlaxNhAQR1d3QzO+FtW0aXjmOta5uupCV+1GEj7Cf5yeFhkIseDgQSU9KlSetHvm
	 DNpjqjiVEEIcRCePqsS5Stj85TgcYge/Fqnao81wdhWJXxzfvUiqiVha63T8KSMOPhDns
	 NncyB6aqlM1rlRuHr+GmAqK5Mw9TLFBgePgI/9MSkCcplpOKijcNg6fpqVt2XeDGH5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pty2sK13;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088FD606A320;
	Thu, 19 Nov 2026 03:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pty2sK13
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441B51F000C4;
	Thu, 19 Nov 2026 03:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057651;
	bh=loVx+lp5CJ3T3FGbo5l845fRt+vAHXHZqzoW//ciZYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pty2sK13lU5HY6OxgwXyRnc4fN4SwOwjQKotU86SaEFeXd+If2AZWiaAv6lciXBL0
	 DbnlML0bFEKXnr4mbfzP5L+JTuaz5on7ynQRkiR1S0ejNMUJf+XLkr1TEKVIWGjioM
	 g144ZrwTyVjhMvuD6q/V/nM0FTrRUCykKQzLKaNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0205/1848] media: em28xx: use video_unregister_device for radio_dev
Date: Wed, 18 Nov 2026 15:37:23 +0100
Message-ID: <20261118145920.467932017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2cdde3bfe900..43aa5844855ac 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2253,7 +2253,7 @@ static int em28xx_v4l2_fini(struct em28xx *dev)
 	if (video_is_registered(&v4l2->radio_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
 			 video_device_node_name(&v4l2->radio_dev));
-		vb2_video_unregister_device(&v4l2->radio_dev);
+		video_unregister_device(&v4l2->radio_dev);
 	}
 	if (video_is_registered(&v4l2->vbi_dev)) {
 		dev_info(&dev->intf->dev, "V4L2 device %s deregistered\n",
@@ -2911,7 +2911,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
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



