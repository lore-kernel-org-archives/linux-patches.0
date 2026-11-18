Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024589;
	b=i/yHrBF71Y1RKO4702tQ3C2nsGtJ70S9+629zSuCrHWqidl+adURT9RA245po5kBWKR1
	 OS7g8/N7zrUoZnEeSesQoEw5hj6hihJO18VifIbqp+m6kk7ic3vIuOtu3SnDCam8Hj9c6
	 /7FbrSuI+a4A223QgdYUwvOOMbS4XckjIKDo2qzAfQMksnxMsq4h5aSVHQyA1C8sRNwes
	 3mfYa/QKjbTLCUCBWk62SjhTyo5pqo+CSLj3kwfHTbCYXLsWa8xYvXuQITh8+/krbXkJ7
	 z8oMDukzLo6eLGLhYOH4In3tLsTogQePm30nQkvzzBUFCqg9QnfszEiXCODBhPeiFng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024589;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ky/YX5DKM1LuPiDl8C/my62WiDkt2RLA2gyxR0KPwA=;
	b=4sRWPFJKQVE3qaLE974h4jtchsz3Ts5Egqb5nksRWQhbTlSpDuWs09tqiiS1xjG03ICY
	 IkdPVao4eKw05Ax0iuwkapvJC+z8zsvT/28VWJ8Zk29CK1sPgpcGhHo2vNe/5x5JUbNDU
	 9zIuf0dLiEWZUiQXtk3xn7U+70bLtp5Nhsqxv7SSEryAiV84MgV07vu52a7US9bF9I4on
	 Uw8PccO+2KE8mp3Fxb3w9YthjRLQHYJ1fwtBcnCpEsTAMxgnnZUibGdgiEkenTuQsw/0Z
	 GLcw81wL6yiMHNh15y5dspxB6DvtfwmnG1GKJM12xlG3DVQmp3xtSkBl1g0edp+pO+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thYWmgKv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A604C606A31C;
	Wed, 18 Nov 2026 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thYWmgKv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA921F000C4;
	Wed, 18 Nov 2026 17:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024589;
	bh=9ky/YX5DKM1LuPiDl8C/my62WiDkt2RLA2gyxR0KPwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thYWmgKvBWQ5iKa/FuhS8eAW3hl3USaFbuT1qz7GkACoRd/v+cOw1NZm0yehPb3s3
	 KdmKMcd/pj5bqf0V2p7eq+V/8Vqy5q2I2GAuVZvZbBqWPQVhsO7K4OfCqLmlqHhhah
	 av5EUUl+143PYfk2jxxxzrcTBt2vQoZ1MfhCMkOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0738/2151] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:41:13 +0100
Message-ID: <20261118150148.919504332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 28e09d0804405..245c19cb22590 100644
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



