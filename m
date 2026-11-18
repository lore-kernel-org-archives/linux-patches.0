Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040296;
	b=dZqbhtEUptRTecLugmcguVCa9Fuw9Eg2/4kC1e2ncIZU1J9gVxQfZIOHswNlB1iZLKRd
	 pa8Up5EdqOeRKt6qTdcdSlCZx7uwKECoL8XG5dDLvhwHUafrmuUy4Py15vynYvwZy8J73
	 6IGeS4I6kwqZu3wYNRkoajSZU7rKftb5+cQANTbygy2rzwJDm4vN80NH6OnMDfHTlNM+5
	 FozXwCe2Racx8SN1D5HC99fhW6auri+CkezO4C04QIk8Cig/qj5zhE2oRh1BW9HjqUFOQ
	 hDO/vtOO/HjZO4VK4AMV5E+5VTjS42kD/ySQpBXDjbRlQcEVd5J4JNGRIgt9h6uBbMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040296;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aR2RHvUVFfqkRbT43aj6wuGzEjlRdOBnIjZ0S+t7B1c=;
	b=0C2PTut/bYORiu0+KqeOgzpFqNh4PBzqi6gsV0dlXLurPWweCcRD+lQVDa4R5sL4JjBH
	 9aWHK6wpm6xm4HqxT/qmF95Twd0g5U6OOzOBb/Cx1XIbU+eFkVUzm0W5bm8nYDNR+xV2P
	 UfiJ5H3OJ1zsIkRjkBjimv93CxS1JeEQYuwe0wHuYxwhOG8XcFq+sgWpgIno1dC0PJ4VT
	 086cIuiWlVBBrZP5qrCnKWtEYlFjvzMXvUAPLTiEMsm9xGZotbTHEm8fgLKmULMD6pAg7
	 k1Mlk/LQG/voiLijMCsF0o+5sjqUtZVxKreLExAWWE0IfM8ZnZKN9R76tsvhbhSBtLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13MwPKWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026EC606A320;
	Wed, 18 Nov 2026 22:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13MwPKWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525A21F000C4;
	Wed, 18 Nov 2026 22:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040295;
	bh=aR2RHvUVFfqkRbT43aj6wuGzEjlRdOBnIjZ0S+t7B1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13MwPKWnpKorR4IaWLY/4c2QmOjHXSrFVoDEU/6F6QeaLApojYfpJpIgvdOJeo7Fu
	 Ucl5JRo34liTjtag++x6FWm+SLnjMzXqfOw0oa/BL2KwifY7ss4s36FEU2PpXuEXnN
	 Nah7IjwEXgEqPZy+a5NCqeeWwGbaPH1UQzLVsq+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2366/3318] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:49:48 +0100
Message-ID: <20261118150432.553169051@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit d498b2ddda99eed28cde177b1620dbcea246a1c4 ]

The blktrans request callbacks run under dev->lock and may allocate
memory with GFP_KERNEL. For example, mtdblock_writesect() uses vmalloc()
to allocate its eraseblock cache. Direct reclaim can then recurse into
block I/O and deadlock on resources held by the request being processed.
syzbot reports a circular locking dependency involving the device mutex
and fs_reclaim.

Commit d5ba1c8ffd0b ("mtd: don't use PF_MEMALLOC") removed PF_MEMALLOC
from the MTD request thread. That flag had prevented direct reclaim,
so its removal made allocations during request processing eligible for
reclaim without excluding I/O.

Wrap request processing in mtd_queue_rq() in a NOIO scope. This covers
both the request and background callbacks, including allocations made
by lower MTD drivers, and prevents reclaim from initiating filesystem
or block I/O.

Fixes: d5ba1c8ffd0b ("mtd: don't use PF_MEMALLOC")
Assisted-by: Codex:gpt-6-astra
Reported-by: syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e08e0a15269eefa87790
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtd_blkdevs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 5bc32108ca03b..e2f8691cfe813 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -18,6 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/hdreg.h>
 #include <linux/mutex.h>
+#include <linux/sched/mm.h>
 #include <linux/uaccess.h>
 
 #include "mtdcore.h"
@@ -167,6 +168,7 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 				 const struct blk_mq_queue_data *bd)
 {
 	struct mtd_blktrans_dev *dev;
+	unsigned int noio_flags;
 
 	dev = hctx->queue->queuedata;
 	if (!dev) {
@@ -174,10 +176,13 @@ static blk_status_t mtd_queue_rq(struct blk_mq_hw_ctx *hctx,
 		return BLK_STS_IOERR;
 	}
 
+	/* Reclaim must not recurse into I/O while processing requests. */
+	noio_flags = memalloc_noio_save();
 	spin_lock_irq(&dev->queue_lock);
 	list_add_tail(&bd->rq->queuelist, &dev->rq_list);
 	mtd_blktrans_work(dev);
 	spin_unlock_irq(&dev->queue_lock);
+	memalloc_noio_restore(noio_flags);
 
 	return BLK_STS_OK;
 }
-- 
2.53.0



