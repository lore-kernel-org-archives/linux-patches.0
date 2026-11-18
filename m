Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030112;
	b=ONqGv6xMEOsBV2JTU3IyLsgScy2kj1ybrEapDxBBmaMRCA1TB8T2GIkzrkem/5rq4OcG
	 n/DSl4v1K3gP5oBiEJx0E+AXDrfz4Q3f2l5Mn2XYnABsVDy/dFZ8nJPWhUaoCbhRiSqcp
	 kNV1GB4eSQzYUJwAl9SlzMR1mY5HelnEmCaOmc0y2lYBttiPVglF416lhCLgrAJ8Qfl5u
	 jLywm1B3xSrOenNmCkKghkFLcYpTynFLfuysJqCajrHuq98VZEl4Hv/GuGTFHlKOYb5hf
	 kSbzbf19fQGWFCERrGKcHrWt2hiMMpFvPchzLWQjzdoac+bhCQnxIldiZYzz1lXY2SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=haMjeQNkj+m0n12r7M4alNn/NMoxjwg/A9aj6mPIn2s=;
	b=rTBLtBd9gfuxvEhN2HV0bp03vLsMeTIK4cO0vzYS4cIOnI+LEAXo7M/vWHFCVLq87Api
	 Z5/MwWvkdK35freHeqFSu8C9x1XTYJ5BUZLW8QB1EfsF5tJB5dmw/lUCpTNGmUBPXf40m
	 aPZRFXdUaBrqyXHCz8w+p+ZhfUKQgZRwcgjW5F/FI/mlnVuJit0VPbhtNpJj5y0EoM7nK
	 xnep7anWcIq0PqriQ2yUfbGf9po2+O3r6uDAPv2UIN5jazhc8mJ9zR+j8ncH1v5R/ayfz
	 bocnVR2431Tw04CiBrGBKW8UYlAbDEv/wOcJ/nD8xwAYb0NjIKoNsA5CkcLucY1UJMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgVSWVpq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD560606A93E;
	Wed, 18 Nov 2026 19:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SgVSWVpq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0867E1F000C8;
	Wed, 18 Nov 2026 19:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030112;
	bh=haMjeQNkj+m0n12r7M4alNn/NMoxjwg/A9aj6mPIn2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SgVSWVpqJclgXimKPEmXpZsAMv5ILs+pgUkUcl0AZH0KzlO1PqlmX4auUXWJA7+tW
	 hEJ0FmS1TxrBSERuNVfDMUiz7p9rq6QdYnejP8y0irNNjMyEq4sSDTDiAvacGsjGRX
	 mMgs3xFPzJ6tM1vd5ivntSg3QNfzlK9RnFGOaCWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e08e0a15269eefa87790@syzkaller.appspotmail.com,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0588/1756] mtd: block: prevent reclaim I/O during request processing
Date: Wed, 18 Nov 2026 15:45:15 +0100
Message-ID: <20261118150032.425412588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index ee7e1d9089861..25c930f20ee61 100644
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



