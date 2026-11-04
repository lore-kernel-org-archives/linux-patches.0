Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829560;
	b=qJaFCIAZewgYgE/tY3iZk8Scn0tI+G33sSJFNfn8mdpLivt7Xhs8FTEMk3k+2v7w+8+I
	 e0DRLFTqvF4VDdNSoYj1QbwsNpUamc8HH9mIxfuom5x7XeMiUVDGlx1CLMqvQ19R/XV6b
	 XquAH+kJ+LSHI929Zyai0WCAwqyqwei/2LY03Fz9vSg91WpagmhIPlnbgnVE7LVkx7sqo
	 dA3IIMt3gvy0aXb4oNQlAZFTGWEms6fw92x6e51EPMMRvlazBE73w1BT9N9CzmJjtw+IM
	 HuYEpFycmQH1nHIUCpNpAD1s0IZeGdUT0O2LiYQsXNeVK8RhsBad8StRQq6XV4SEZiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829560;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7RygcyD12jL9P8ATtYniEJ3GtulPHANwfyddp2vjhTU=;
	b=CMYfPMISa4ENZsVddlqG7wxQBfUPv3P1r+qnqPraJxuiBCWRLS4rLRlOi81WDhUYthYA
	 8+MC/qWNxC4pPS+rilNr/t1AhU69cbvqSGuocwIkLqtxWYFw4B0R05cW4aNqsjd5T+1cf
	 cEv39C4gYEfTADSNil97LxUB9FUdeYEUkjg2KukVAM5bnjUF19abupyk15s8Gq5Obu0Vp
	 zXR2N06Fsy5ppyohX6GuXJWMV0gxDB5BkpOt+QJ45z4fj1bIbdCN0NIeCosFQyC2JT2J3
	 oWlVyQPijnm8Jw1P5B7Ki2qssWwIPht/mPIJTnupHgQ0a0hC0Y/wfeecfuy+jPg2qvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZBUCCmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8342606B2C1;
	Wed,  4 Nov 2026 21:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uZBUCCmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DAB1F0093A;
	Wed,  4 Nov 2026 21:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829559;
	bh=7RygcyD12jL9P8ATtYniEJ3GtulPHANwfyddp2vjhTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uZBUCCmb2R4VB4rM/UC5b3fTgKxhkP7ynGRpd2VxjfHP3o97OJ73/JOjRA2HymiLD
	 tZCucGJ1pam2hagWQ/Esuf3uQ8aXpf6T3kVK8Bq6Ae5+neeMgHxoqqWv0Ja6Kdcd4h
	 XRWR/RzR4bQ/CP33YOoM+pWP0PVaSATUkUYcrpug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0202/1005] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Wed,  4 Nov 2026 15:58:55 -0500
Message-ID: <20261104211049.451087690@linuxfoundation.org>
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
index ab34be22cd1aa..f6fb54ad05e7a 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -871,6 +871,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -888,8 +889,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
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



