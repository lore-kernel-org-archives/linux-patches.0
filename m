Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060804;
	b=IA5gKSayOI9Ln9Sc2GM9IDmzwzhZoNwazzah0gFkQGCxWD434DwYaO+hTfFl9m/Bdanp
	 OdGe3tOgx6zxHDMKEH36SfP3msyyoRq6rBP6hmxwQpHA6z9VgVbqHvfgnT/3K5yW22RU9
	 Tq1rEw+p/s0XZ+6bDeRgpFMCd1gp7f4a7d/KOgE5YanA/lXJvlAih5TIvjvqz570W/0Bm
	 o4PnMuBvJ8+ljGgJxymX9Iy/dxm+gJtLMywE705NB7/oHMLF+iboA2oI4l0HB1aB12vdT
	 dNvLkAGInx70Hgu8DliqMgBkjFROTLSCa3w8Nsiz+n76fcHtVTKDYnRx/Jnpidh3M1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3VNr3W0j1VYX4R6q2h7MEEFHtmuUyIyISuKExkZYVtY=;
	b=s/rweoiGyN8MpOJof5bbqj8BuN2S2YRslvaIWzIROJXfn7m2ud635ZswL20m5aEfcLkv
	 FB4DknOwcUDrpH/E/PksAoXrYjaW3R3tAgSgVEOr0ytSXlIT6F86XLb6fV91sYb52NNfv
	 JoD/+G45pvdHShXlj2K+xozNJQYLWo8TY2wovpooKS7IhsyAOz4d5Y61XETCrP7sC3g++
	 FdIg/Em+w0CbWJItq5vOhWZgCdrH1eHNYLwjSa0HP6VbXm40XmZLtO/kONgJhPSET3Jet
	 7VkMsqKy/1JSO1zkRIjR+iIQVt9FDVkMkpgo1IaOZvdkt9432jXnhAPuXj+f+V4CAAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgz63yPq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD15606A326;
	Sat,  7 Nov 2026 14:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pgz63yPq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8681F0089F;
	Sat,  7 Nov 2026 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060804;
	bh=3VNr3W0j1VYX4R6q2h7MEEFHtmuUyIyISuKExkZYVtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgz63yPqGNL3EtgQ9u49m8erReWoate9An4JeeE5KYX9XfDh+fZcJzMJWTKyLD6i/
	 G2uM6uGCcB0uBgwXoNxGmR2ULFe73FNMtTCLu43IwVrn6zMBDb3BNM+lybrMCL2ipo
	 ejNQkh+nZQyRDDeMjpb5ekY6wCYRw4PXtM0NUkXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0167/1536] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Sat,  7 Nov 2026 08:36:23 -0500
Message-ID: <20261107135002.356315805@linuxfoundation.org>
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
index a67cce02d1577..93fc040cfaddf 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -870,6 +870,7 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
 			      struct dmxdev_filter *filter, u16 pid)
 {
 	struct dmxdev_feed *feed;
+	int ret;
 
 	if ((filter->type != DMXDEV_TYPE_PES) ||
 	    (filter->state < DMXDEV_STATE_SET))
@@ -887,8 +888,14 @@ static int dvb_dmxdev_add_pid(struct dmxdev *dmxdev,
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



