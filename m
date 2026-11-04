Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831120;
	b=3ZfDiaJ0BNqtaGq9xhHHveHgxTf4sYe6lNTmiW1OLu60VtMvjIief+/yy8zqdsjLPJ1S
	 hpikiSXAndP+KvwrCNoff5GnRzBwqi4D6FnD2iKuM9wQVuDYteZMy8bSow8LORexDItdF
	 3CqmG0rIbhqiqXtfU+oW5v7RY7HI6eW4YjM6KM7HNNx63UwX1BEfuKMS+uYkL4TnCm48s
	 XKetc0kabKvx16t1+sOtusex3mfXNL+fRfklbP7Y51cnDX5nsihuCX/8W6SurcSUgeffC
	 ayQblCEVZIyI0cz2jqJtJam8Z11iQiNZ/tTkhHZE7TVo3Ohz/rdOystyBu3428aanFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTNSO11gG7Ft62HOD3t9wNGFzvwkZe2NuzIOcLNOQIg=;
	b=3U7V+h0MvcMBIa1run9DHzMJF7RUXMSZ0vgy2PqQudmbGr7X1nhM70F78q+hiLF10WWw
	 2zSvpmz3ehBuh6F6vQTmaS5UdOQo8+l5M9zsSZUPrMtRkQPQc5AE7WPfxNIv93UDk+Ek3
	 chIaVWCFZPT+4H7RHS3cagUQSX9Ulxqy95Wip1DajxqsWCyxTTPKqRHS2Udp8IM7ARTPQ
	 8b0BVthyhzN6sZNf2CH7B72ENVT8dJQZOtmWoD1kzB6Hiotib2gL7fH+SuLSPrs6ohIrP
	 bo3O0R7nUqSMxzeqGYVP24cr5cOCiunGD0DcbXrenyTWo0OwQ5R/Ap+lD9/pKi/c+rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlCWe6Jw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69279606B3AF;
	Wed,  4 Nov 2026 22:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UlCWe6Jw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38191F000C1;
	Wed,  4 Nov 2026 22:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831120;
	bh=lTNSO11gG7Ft62HOD3t9wNGFzvwkZe2NuzIOcLNOQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UlCWe6JwcKrl0IyLjeZXO22Xw6pOuQo4Ogv23lafsE1JYTiOeCh5OihW2uEpFigdR
	 qxR53cjTsPoI6FokLefXMEmJa0QAHc0+Cycrk9FE86FMfaOMz8K71lmnZzWLdiiyxO
	 OBk/n1MBmTHoUFCtfGS3EAiVezcBswbzB4wkvUEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f26bc23e42eeb548dee1@syzkaller.appspotmail.com,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0515/1005] media: em28xx: use video_unregister_device for radio_dev
Date: Wed,  4 Nov 2026 16:04:08 -0500
Message-ID: <20261104211058.357601398@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e2907b56220b7..7d9840f3f1c88 100644
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



