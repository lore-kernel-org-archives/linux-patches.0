Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216424;
	b=3GTZdUjYnCsSTklF8TTszrMRs+mlXJ1VHJESqJspps7h0a+jC//aPqYjhGBi6Bqihd0F
	 k0DABTN+sWsq+HtlpCxdmhqSIQvOvhKtI67NdhQUGJanklKy2ikgSsOUPzDTTCq2NAAqu
	 kwIfqQnYoCYuJ1Lfa9yXcuHSB4VJbiMT4VBmhuuKVzqkwDvKgOXN1MlfowUg3G+GgU6wX
	 /2kVHI4aZo0FXAl1BijUOaY/DFMlFlYiJJdm5BEgK978fMB5Wr1uvga+eUhAmIS1ww5sF
	 txNfIF8bvVwxIXaIaYDTxfxruanp87YIj6E/AUm5xbA5vSsJki/RYSX9nxVPb1ncVog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216424;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pVUUInu93v8V36I1xc5oN/xdbdSPgnG04rdYpm6Gq78=;
	b=cOKnFMd0EOQhw0rBJcS6n9wxGs7zt9TV4KJqeD6wxGEvO8+wXv9XSDFtgNdo5Az+RMI1
	 Co6prGhWQ/clQR8ZlLWf1KADL6IOupNF3Y/uuX/9XHAhbOVF+oYs8DJV6WuR9gEIhD/YZ
	 ukwu56KC6S9agYrXOwT1ckGjQTQqkLwiIdvU1ZEmAa/CVmDKNVCdefOti6nw36Q8exH5/
	 kxXv9ThUGkH6TYds9jiVXx6WCd3XR9zT/Yk4eSmYTXg5AMAN5W1UyuEP1/PGbZ9+OKnfT
	 XREZmLDmCraQRTaOuLfP+0UithbCMoWTlZ7zNhbh4po5jfmz0MY0eSipTqj2orsVXgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9hRRfF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2731A606A32F;
	Wed, 28 Oct 2026 19:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9hRRfF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464561F01828;
	Wed, 28 Oct 2026 19:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216423;
	bh=pVUUInu93v8V36I1xc5oN/xdbdSPgnG04rdYpm6Gq78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9hRRfF2gnK7+4Yrpv830xCt8VSOAgXClRn5HqXbW0/oUiM1d7ZTrk2KFyxKrQ8gY
	 BvCZDPqVFCGaPOJXLRlaPETrCisv63HddBLSsT9cyK5MOo12LfIfYBCgwWuqyuTYLY
	 TyPgKDtCQale0eN/0IgqDenNeyLIf9fVAnukszPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1549/1887] null_blk: free zones array on device power-off
Date: Wed, 28 Oct 2026 18:00:45 +0100
Message-ID: <20261028170534.716602748@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 2a6357a9b935a34f5508618fee8a7fffbf7722a8 ]

null_init_zoned_dev() allocates dev->zones when a zoned device is powered
on, but null_del_dev() never frees it on power-off; dev->zones is only
freed later in null_free_dev(), when the configfs directory is removed. If
the device is powered off and then on again, null_init_zoned_dev()
allocates a new array and overwrites the dev->zones pointer, leaking the
previous allocation each power cycle.

Free dev->zones in null_del_dev() via null_free_zoned_dev() to solve it.
And calling null_free_zoned_dev() in null_free_dev() is no longer necessary
because every caller already invokes null_del_dev() first: via
nullb_group_drop_item() before nullb_device_release(), in the
null_add_dev() error path of null_create_dev(), and in null_destroy_dev().
Remove the redundant call.

And take &lock around zone_cond_store() in the two store wrappers to
serialize dev->zones check-and-deref against its alloc/free, which already
run under &lock. The reason there was no problem before is that only
nullb_device_release() or null_exit() frees the dev->zones, which
guarantees that subsequent users won't access the configfs interface.

Fixes: ca4b2a011948 ("null_blk: add zone support")
Assisted-by: Claude-Code:GLM-5.2
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260725022509.714271-6-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 237e9a821374c..971dbe77b2947 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -552,8 +552,13 @@ static ssize_t nullb_device_zone_readonly_store(struct config_item *item,
 						const char *page, size_t count)
 {
 	struct nullb_device *dev = to_nullb_device(item);
+	ssize_t ret;
+
+	mutex_lock(&lock);
+	ret = zone_cond_store(dev, page, count, BLK_ZONE_COND_READONLY);
+	mutex_unlock(&lock);
 
-	return zone_cond_store(dev, page, count, BLK_ZONE_COND_READONLY);
+	return ret;
 }
 CONFIGFS_ATTR_WO(nullb_device_, zone_readonly);
 
@@ -561,8 +566,13 @@ static ssize_t nullb_device_zone_offline_store(struct config_item *item,
 					       const char *page, size_t count)
 {
 	struct nullb_device *dev = to_nullb_device(item);
+	ssize_t ret;
 
-	return zone_cond_store(dev, page, count, BLK_ZONE_COND_OFFLINE);
+	mutex_lock(&lock);
+	ret = zone_cond_store(dev, page, count, BLK_ZONE_COND_OFFLINE);
+	mutex_unlock(&lock);
+
+	return ret;
 }
 CONFIGFS_ATTR_WO(nullb_device_, zone_offline);
 
@@ -746,7 +756,6 @@ static void null_free_dev(struct nullb_device *dev)
 	if (!dev)
 		return;
 
-	null_free_zoned_dev(dev);
 	badblocks_exit(&dev->badblocks);
 	kfree(dev);
 }
@@ -1825,6 +1834,7 @@ static void null_del_dev(struct nullb *nullb)
 	}
 
 	put_disk(nullb->disk);
+	null_free_zoned_dev(dev);
 	if (dev->queue_mode == NULL_Q_MQ &&
 	    nullb->tag_set == &nullb->__tag_set)
 		blk_mq_free_tag_set(nullb->tag_set);
-- 
2.53.0



