Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057449;
	b=N7zNUTm96be1CMjj0P3sKXGvzxAJnPiAXppc8z/Ww2GfuiKZXbNQGZf31aKvbUTQRn21
	 0Ryq2cU1K6D2b7j3haLTNWXN4+FilADt0HxJgLk3oXqtCCzkSMBNPk1trq5zfNPH1VZ3/
	 1CPYckO68mnnDY7GnGpJ/KHtAdTmhNTKHct13zuyxFUcUEnirmRsgs/3TKpO7ZPwOfuph
	 4p3OZIncG4/JnsRnHTwbIngjmzRgcmK28onLCMDGWn+/ATnZCFt3KuIQoICLTchElJ8iT
	 VjnhRakOxRtUevxDUhm8oN+kdP7d1+Fu437PxNJDD675TSh15Y0sVYdxn66TCFT0MIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0GulVFCS+hNSYSVU3L05ebGnaT4Ib8gyaX8kbyTxHc=;
	b=bTYH5y3dcHfbKbYGV8xzEpdxq73MmDnZVxNvUSjH6/FHaSWQYWjIbteQGr7GhO/u4jHM
	 FpGP7Pg6F95hu6L9bMMyHgADgfTCK41efYBVyur0NCKnKyuqqbXDGgTC4OtNQ58fr+qdX
	 FrbeKvMvsu4ogVwmHVzKzX3g1zXs4pyT57psIsZusC8Xq6FQzrmK9gXZb0Hp1UJnvUmg+
	 0iCD+wzkbnl50cWAD9TTzbXdhib49ycOJUHZLufaAnl3uQayHpfbJAMDSfqyluJaXtsOq
	 Ii3oIWZ7vpCEHsflm+z0zpZ4LhyvtTXWICL0i4gOyiAh72xunMLi45WN1ZpV5Hz+RWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltNRO0aj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00360A2602;
	Thu, 19 Nov 2026 03:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ltNRO0aj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B51A1F000C4;
	Thu, 19 Nov 2026 03:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057449;
	bh=X0GulVFCS+hNSYSVU3L05ebGnaT4Ib8gyaX8kbyTxHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltNRO0ajN1JRGYJTsI8rZm7vXtV9atAQ3N5Rfci/4C+ZJBWc4l23ORhNvXFgy/HB9
	 6BROTZQN2JTBaDkYGrHqclTiCEHz4moY+55C3ahg7MlEIJK2M0/SzzE7KRfaE5AjZQ
	 5VuwHn62ft5uy7YgmBm9yudPvYkqodf6eb/1D4FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0097/1848] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Wed, 18 Nov 2026 15:35:35 +0100
Message-ID: <20261118145915.157639981@linuxfoundation.org>
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

From: Rituparna Warwatkar <rwarwatkar@gmail.com>

[ Upstream commit 9fa26c971ca310dd10a3bc0014f2fc7ea7167bba ]

dvb_dmxdev_add_pid() allocates a new dmxdev_feed, links it into
filter->feed.ts and, when the filter is already running, immediately
starts the feed.

If starting the feed fails, the newly allocated feed remains on the
list. Subsequent restart and rollback paths may then operate on this
stale entry, leaving feed resources allocated and causing leaks in
drivers that allocate resources from ->start_feed() and release them
from ->stop_feed().

Remove the feed from the list and free it when
dvb_dmxdev_start_feed() fails.

Reported-by: syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9a1f5e196de6663631b
Signed-off-by: Rituparna Warwatkar <rwarwatkar@gmail.com>
Link: https://patch.msgid.link/20260714141059.63582-1-rwarwatkar@gmail.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-ID: <20260714141059.63582-1-rwarwatkar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dmxdev.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 3be74b87b8098..c055a12a72576 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -880,6 +880,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -897,8 +898,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 	feed->pid = pid;
 	list_add(&feed->next, &filter->feed.ts);
 
-	if (filter->state >= DMXDEV_STATE_GO)
-		return dvb_dmxdev_start_feed(dmxdev, filter, feed);
+	if (filter->state >= DMXDEV_STATE_GO) {
+		ret = dvb_dmxdev_start_feed(dmxdev, filter, feed);
+		if (ret < 0) {
+			list_del(&feed->next);
+			kfree(feed);
+			return ret;
+		}
+	}
 
 	return 0;
 }
-- 
2.53.0



