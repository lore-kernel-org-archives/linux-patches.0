Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058122;
	b=iR0a+5FMxeQDwiDGqki98dguhVcjk8XTqbD1lUW74acLPPVcJFPSS/FT6RPBxFzDPcXt
	 fmPO1iFGbDerNnCOwl39Pu3AIxYrKojFWviCXG137TUMTYo483jAr3t57ctcxMIlijati
	 yLzszv8oZHQFoO1N/O94pyZQUkKb4hKsG6Eeq/Oic0Ui5o0vEisBIX0HqDP2e/lnKutDk
	 h+cN1hVbBKgOHewOamYwwGBwT4vSy86smLZSxdvS2hXQQZhmfMQkTVb1NKV8r6I5w9WyE
	 UhrgDZfgL0pvmalqpY9uKSwnukjpF8Q/DDX3uiiHxBHn3Y5KQQzsoWctM1YLns6bduw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yYoNTQewdrPMCLr2U+TKd3UE3WDgSOypTSg+ypEJxRQ=;
	b=BhwNUyzxVtiPBdPZ8kxhWP1iWff27qPuZZq2NGjVJ4mAm0W6BFw5jZz164CQb5hML5wT
	 rdABl/I0Mm6w+0+KyzwAFD5r/duywdwQbWR4Vbho8phGsODLAD4mH2IbH5hBemSXO71XO
	 4GWgtBl9EQaULDYdKivRS6ZRFZ+g1yyGs3D6HlPYT7MgUXfy+lRDAwDJeL8F+LcU2Ve43
	 IWMytH4ZEsSmU0c9gUp6STH2/M/Cx0Lq1mXYy/DQJ6/NT+iOAYfqZmPeeWnX7jp7prKDT
	 hsm5HDNFM4UAUdDidvabfqNB7oh7FArtv51WBlDgW5XPuYjWzFREJu1tO8EF/jRAi4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mahyiGTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408A1606A325;
	Thu, 19 Nov 2026 03:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mahyiGTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF651F000C4;
	Thu, 19 Nov 2026 03:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058122;
	bh=yYoNTQewdrPMCLr2U+TKd3UE3WDgSOypTSg+ypEJxRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mahyiGTvdMgcNJ3mIqf88OBMSo8kOVhm9oBZ0++OqSAU7YOeefVzn+6mer8SpAJ55
	 de7C155PdtVsaC3x4J+bFtWkxWBYsZ4DkS9PDIIMnrm9tcj5lolTzj+ep6PwgIoPSp
	 tNSHK4fO8QGO5REYIj6McQPwsZtwmQ44cXWu2XOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c7fc4794e59786f5b4dc@syzkaller.appspotmail.com,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0373/1848] media: vidtv: fix uaf in vidtv_bridge_on_new_pkts_avail
Date: Wed, 18 Nov 2026 15:40:11 +0100
Message-ID: <20261118145929.051964962@linuxfoundation.org>
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
index e216526db35a7..acfb66366d300 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -521,6 +521,8 @@ static int vidtv_bridge_remove(struct platform_device *pdev)
 
 	mutex_destroy(&dvb->feed_lock);
 
+	vidtv_stop_streaming(dvb);
+
 	for (i = 0; i < NUM_FE; ++i) {
 		dvb_unregister_frontend(dvb->fe[i]);
 		dvb_frontend_detach(dvb->fe[i]);
-- 
2.53.0



