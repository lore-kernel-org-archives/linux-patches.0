Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044932;
	b=p+wU/No7RN5AMbly0EVCVSE4Wt55rdcqCVtqBDSbDLnGN2/3zgNMybyUSpK9LzZHjH/H
	 p3e5vsZfLKBvASsuwtygmtoqBs/3FgJPh7nElSu4iHORmdvuNQWQiBg2NGRiGZHc83EGw
	 oYc0ZaM2gvCDZemNZzlQbZQcSD0m7KtcHX4VytrYWKj0fTg4kOQgrcMDySORFtdvcDpA9
	 VjzIpxGpMmU04x0WC95O6rtsVItJCYSW0AuA0OW8kmFwVdF36AJu8EFCxNSBATayS46rC
	 lOyliXOkEav9apKnGDbX/JWOk1OUMAqh6xBfwhQvVTq8prW3Bg59tXtSY8YlYLXRMEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a+gYNCzEctgnKy945nn/6NP4IBNdpL5MO2jBx0n4zjY=;
	b=T2exIrwdblHun8jEyxrpvoCmR2GrTTEGqggoh7mI4HxE5AzOVMizAOsLiAKAe8UvIpdS
	 SQCdd3R3BZlngmnKlYYIIJ4tQvQjlp/+Ld/0JY7U1xQmT0+D69v/l/Fg1YNt7vL1CWWdo
	 Dha8nwWMgg948/Tl911Wxz2fKsRn5CqQL48N3wsipDWUyWb7fUDZ9bRlhf8YaMil7/KB7
	 sqlCHimyvEGdvLAjGN2eDsg4evxVWhlEg1hB+bYQAS/i+N111/QWdWjz1Iyibv7lRif8r
	 +VmSzrxHPB0KO6q9e715FA0+am8PpYrQiyvvsN4zkSHOmZTRkQ1x8jPQzJNKwEybuIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yw2kArTw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1575606A31C;
	Wed, 18 Nov 2026 23:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yw2kArTw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469341F000C4;
	Wed, 18 Nov 2026 23:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044931;
	bh=a+gYNCzEctgnKy945nn/6NP4IBNdpL5MO2jBx0n4zjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yw2kArTwhGfRPiKiKW4+nF4WzNp8CF3ykJZQ0vxziLkRQclCkrziMrwDGyQhi3zLD
	 MWewCw3VvWTImR6FI3M4u7za1THe3cbNbufQ4Pzs3oH2/qcjuRwuJeD8XDqFWcXCAg
	 ZAG6HtQ/pkJi6oZdSyg2viY8nMWIOVKXTO9/8em0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0744/2857] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Wed, 18 Nov 2026 15:29:38 +0100
Message-ID: <20261118150228.340711354@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 2af02ccd048b77713695d7817cf645ca50bf349e ]

Attempting to unbind a dvbdevice that is in the process of feeding
data causes a UAF as we free the underlying device without
stopping the feed first. Fix this by stopping the stream first using
vidtv_stop_streaming(). However, our codepath in the reproducer
(mentioned in the below reply) does not decrement our users
(dmxdev->dvr_dvbdev->users) to 1 after it has been incremented to 2
by our read() in the reproducer, that is only possible on .release.
This can cause a task hang as dvb_dmxdev_release() uses wait_event()
in the wait_queue unless we use a close(fd)(in the reproducer).
Is this a problem? Please advise.

Reported-by: syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c7fc4794e59786f5b4dc
Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vidtv/vidtv_bridge.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index f3042bc5a6230..149a2d358750b 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -551,6 +551,8 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 
 	mutex_destroy(&dvb->feed_lock);
 
+	vidtv_stop_streaming(dvb);
+
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
 		dvb_frontend_detach(dvb->fe[i]);
-- 
2.53.0



