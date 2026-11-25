Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618319;
	b=BTwesqrFPMGNXlLSZvHcAnZQk6HHPPQcs05lIapewg2ZufdBIa16gGNnQviRbAnqQBbp
	 YZ2wkKtCvNjafYwX1wcSN4Yw9dNvt71YtfkJsqxy9OCb4axOhYp9TPuf2npWr2UvcP1tH
	 DVdpfRkimdO1dfxAhzZ4C2dJFZ+CqDm8Q9B0ck1aaXfEOsCmFL+KDdos/uTi2QSXik619
	 wWcXC00yd0OKzSH4p/wVIsVNjnERIrnRAg5rv4dd7tuYv3EZdyRXDvhBKi8YRu4zBDuMe
	 UJmjwJjs0eHKwGD/5yZmA+QfCDCWPWcJSWuxxl6xEMu5mh4rb5Jj13TURmKRRJ3+EuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oc4awykZ25xhuZza7hR4kFJLM67Xl4cKueBfCcJmiWg=;
	b=MBeAKAJa8BxYWPxF9OsvC5f6B5jjhWjb0xA6Ucy4IrpsExans0EeQqI7QZuWD7jCwX3b
	 o78o1Fht93F3KZgkUFxjTF3PrHvKeMHwQ2vewqbXFTUY+eaWhXND6D2jzCbpYBz8k1SEg
	 iUzVceFFBz9Pwk+nUNz7I2oOtbyHgc36i3hxUJZKktdeckfxQZf8lEqTAOiLoxLyg7fQG
	 WiXuyoMi4ve0HliNHHrwd+jkjW8rzeitl8zT4Ys0IY/r3hMNnyiRaexNV/AEY568XuYZn
	 BTVW/htkFLi0JdyDMZD5otq0CjA3yKUZylZnGCqNOCsXYmXUIyQ8L/bzEjNM36GXMag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O93FWwj9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFBE9606A31E;
	Wed, 25 Nov 2026 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O93FWwj9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08E31F000C6;
	Wed, 25 Nov 2026 14:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618319;
	bh=Oc4awykZ25xhuZza7hR4kFJLM67Xl4cKueBfCcJmiWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O93FWwj9bo7xx4ei6I1ATZ98ViW9WqxGtUEbuEy7KWcO5Z5F+/4Rkh6NUlsu/iGCZ
	 DB48d4bFIdH85zPjbbt9bnvv14rMbtwSfF+TXgJ+1ZOubsAef1Vux934ADLjmllVOG
	 SRZkTbr6g9lP4pbgmiFPmz99/Fkyd9vjObQhWcC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shao Mingyin <shao.mingyin@zte.com.cn>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0242/1005] zloop: fix the error code in the blk_mq_alloc_disk message
Date: Wed, 25 Nov 2026 15:26:20 +0100
Message-ID: <20261125143827.406544559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Shao Mingyin <shao.mingyin@zte.com.cn>

[ Upstream commit 703f6aee8d8d1cb6227af56169be6b1dc4d3c4d5 ]

When blk_mq_alloc_disk() fails, "ret" still holds the zero returned by the
preceding blk_mq_alloc_tag_set() call, so the error message always reports
"err=0".  Save PTR_ERR(zlo->disk) in "ret" before printing it, like the
blk_mq_alloc_tag_set() and add_disk() failure paths do.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20261031221737569WQ3bg8y80Ht7JdTCWwlkL@zte.com.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index e02a5249ae604..8884fa63c23a4 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1329,8 +1329,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 
 	zlo->disk = blk_mq_alloc_disk(&zlo->tag_set, &lim, zlo);
 	if (IS_ERR(zlo->disk)) {
-		pr_err("blk_mq_alloc_disk failed (err=%d)\n", ret);
 		ret = PTR_ERR(zlo->disk);
+		pr_err("blk_mq_alloc_disk failed (err=%d)\n", ret);
 		goto out_cleanup_tags;
 	}
 	zlo->disk->flags = GENHD_FL_NO_PART;
-- 
2.53.0



