Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017338;
	b=Nb8PQrE/aTzStIjGLZTptIkf5+TH/Rp7aNlaxjpWdbXgQoIbsPdRjCIyBtw2XFNwUm/p
	 VaSkonAiaF2VggCC3WW1Sv6eLj6udcpXPK9MyTQNik99/cXVQSESiImGhwKC1/HZhGDHX
	 4XRK8NZMkfRHQFd0T8duH38gbnC0Bjd6tAMKLJAE68xtEEQNoDQJDD888BX7gFja9GE3o
	 BQBF4v10ZQNA2WI6kujoxDJ7KW9vgx3/uo0VkdkssOu6OPZvuk+IHgzIUtZKdNl+RVe/F
	 cR0rUWgWRFBkjKLdU9hIp15eZHPsN3WXBU8xei6cujVm8VxTWPMYP9nAZXkymruPkkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GHE/2XC88oBCS7HWAze3HZoLEZKeHMBUigCPuVDuT24=;
	b=lbLWG14moYmxN4DNG3UUvLVFbKwxhyd3xL5WaGZiJxZoeegLhvGiVIV/wRssbt7b671s
	 l+gCH4xwY5TItG/+vfJWU2D7LEz+H4VJj1rP7Z1CHGGFBY5rvnDveGlQmpUGG5TfzHZZ3
	 5ZoaEpcye9i86aCPcEz0KFMLr95wo4sbu90+NVxLs+tTItVW2gbOR1Tk0dI9WwiVct0Ld
	 vrYABi1SoeiPugv71OKfUaBbwnwkyxkMrieGEao3VlibOQw0VvaQM8HK2mAOofuOrT61a
	 XCDOtM9U+vO1YuTGVF65WJvyIj50lK0zGAoGbtzUD8B/+hLr8hJSQuu2XHl/27DQYcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kc8bHbvG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40CC606A331;
	Wed, 18 Nov 2026 15:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kc8bHbvG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326261F000C4;
	Wed, 18 Nov 2026 15:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017338;
	bh=GHE/2XC88oBCS7HWAze3HZoLEZKeHMBUigCPuVDuT24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kc8bHbvGd7785UL7lLfkIFRbbUILMj/YjxDLshXrEEgv6ydS9/VGa5wnwpOw4B+fL
	 OqWSeQQWIVZGcxNmejJgPCQdlrxJlHwIg/zcLIyzTUuFE1xckwDPyan9yQaLlMf+tH
	 JecNGAMlk1zo7/NacsHXCYjJvNr2+5wBhC6ra7Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0849/2651] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:34:49 +0100
Message-ID: <20261118150318.443509507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4d2e7b7774e90..42f250344f0cd 100644
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



