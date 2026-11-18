Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043197;
	b=Jbjbpjde/QFcym67qtlgzPMkxlbdDdTCXPltBPmWQHzMZ4NGu20CE32JN1bF9L9g/k9+
	 76QBtpnQOZz4zVPdGgl3pAI1lRVOXBCEMvms7t0qwM7xVrOL8+Co3tDHnYFN7LA/GgyYJ
	 83pcCSwFkwsYUXRHurUQ3/8aGwKLPXTszOo2+JdMYZ7rdd6hOQDUAGfcjlMUtD4EdItMk
	 4z3noKuGxkue1DKjMB3j/4QUz3RD+PrXTyfvLytiwd6QOYkFgvqhPalvpWOfaaXXaUz4E
	 +kwMm5OikNeaj6tZ2Hu7rnhPs5PVCHYxLzVVtA7K6ApftnOMplCrOGr4WkUZPRId8CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o5pD/hb9B0+LI3SKoOgobNaRFAqC7fP4Kgeqq5dwncs=;
	b=4iW1rBae0+WOPXsH7OhqGaI9yk4DfuG30uy9aFC4/QhAKO0qIuK3QOfkx0WkNufg9wh0
	 Q1FwapsKuTlROk/fCOZAelGNpH/SDXemKNVqR/X1fmkRgDGS5gwdh++vYf6fuhQuJnv1a
	 8FkSgKqpw5G8p7QAkZe4c8vgDYqL2L/s3f4T+FfEVkEQVaFIjommX0ZpPUmbbAMSlcEj3
	 Du6gsZSNJl2zkN7lyCcPhXsFO/4dbHXUTe2oq61N/9QZbdZqdA34EdsqhGEyXvaehfv62
	 g5i6PB1TeuC04QUm5RTG8UqpZSq6dRA/VhpcaEPTN7Ftw5rEN2E8M2vXRS/7ZqVIBYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB9LLyCm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A64606A31C;
	Wed, 18 Nov 2026 23:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZB9LLyCm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 087311F000C4;
	Wed, 18 Nov 2026 23:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043197;
	bh=o5pD/hb9B0+LI3SKoOgobNaRFAqC7fP4Kgeqq5dwncs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZB9LLyCmrTPHiE3Ai0SCoM/QabfsXTuvqk49NHSznYEwZbT/qeIH9r/YxkF4r1Uh3
	 yJNElsLwmtmljAJiGzQrM0V9YwDCkk9JFxhbxZsi4qbJXvw9GJQdwfxqGHLzvnb/aG
	 aOFMACKnFZGJjgavXpHtxMAEwsGzQAZV/lx4zjwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9a1f5e196de6663631b@syzkaller.appspotmail.com,
	Rituparna Warwatkar <rwarwatkar@gmail.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0125/2857] media: dvb-core: fix feed leak on failed DMX_ADD_PID
Date: Wed, 18 Nov 2026 15:19:19 +0100
Message-ID: <20261118150205.849676936@linuxfoundation.org>
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



