Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051163;
	b=F1c68hELoj6RJMwYouTqnssmQ2nE4cho+P60fC4m2nsf6LTFdTxuTM3qo2PrUxqbrwyS
	 u2YoqKt2BoWeIHRl54flvoCDQgxKbF7X+G2fQjix0aAYyhmopdqR00kVTiiK/HBtaoH8K
	 J5sXE14XteK05JoIB3STKfXwxcerbmGonVGICOnMpU3u94ycU8h4p1TyjqjjPuhulO3R8
	 aPS5RyqhLitvBXs+/5714s4kSJPfVic3DlUu8DDWkk/CGHM+UNAPjXoIw71QiwggRIoJh
	 dpJIsUpQukA/g3vVikIvwXxo+NnBishKsBYm74Aq4MQAN+Mef7JWj61R1ebIsBtUzpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hr1UJB7RT3f5femjzNbyZbkHoOS4iaLPBvlw+Mnz3Pk=;
	b=rC0hJunF17tQCRrJvmkzrcAhQHydKGhdZJpZY2Ke8Ph8jSPZCMCioqO2pP0YrLnps5Sc
	 SsVybGPu2C4UFU4Z/6gG04ayVbMJVlh/tSHhu5vPCrN8tpsA+3QmBPkdIlRcmuQEyb8DY
	 LC9cacc2m9AVuOIOrIy4scDaMWajFTywdsvBLLw5jqTLZpCYMhPdc4L7jgmwMcbT2JYEy
	 5FGfl25ks0GoibevGgIG/OSITt0eptgMG6O+w3S0+GCUB1VlACnOlDq8j4LnR5XD8A4TV
	 +GpoTO3oEyRKO4Z2p2cK6x9ZaZPotgOxN+Q0uva1P9xVnHXg4AEb03HOwzf6/pB/Jfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A11Wko4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101F9606A31C;
	Thu, 19 Nov 2026 01:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A11Wko4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6502C1F000C4;
	Thu, 19 Nov 2026 01:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051162;
	bh=hr1UJB7RT3f5femjzNbyZbkHoOS4iaLPBvlw+Mnz3Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A11Wko4l1cthRc8pPXzraBFj1h+4xlxNVMhec5EbTMcV7k2ENQuqsHJASrhQ1YVRq
	 fzSli7374A5kWy/zYzz8zynCBNHQd2wu1Mrp72SAVV5ipHojHpcsaxcdpDGsEZDF+Q
	 r0Mn8jF/K61fv9h/lgoZU7taW9LnkeOVBYagiiq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0111/2214] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Wed, 18 Nov 2026 15:29:47 +0100
Message-ID: <20261118150014.351378671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5dd2470ecbe1..04583f43ad74f 100644
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



