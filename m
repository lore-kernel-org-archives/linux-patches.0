Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620273;
	b=P+Yw22Jt61XAAZSW2CdJ9cWcUCHEJI7fixAlNMCQb+20ajO+Wf2Jut3ZCRlJlC1xw1E6
	 KLLg11wtMR4zKgSZ47txNC8qBQnV2P45EVk30QSNNqcqHaM9MmN0rPWey1/x7YJSLwGcL
	 BQHc8HjfjgtkM9j2NWOb6PhdyhyAWmDVtqqkLz6VKVXGDesqCysD20W5HNKl4V6p1W6MF
	 lGKmCqDbhz75qyCuV3wO72G/ht1K41QAZ0I+u/Pu9T808h28WbL+arT9FMVndhgT3evol
	 zfA70cKAIQ1ft7/c4IjALe6/1/FdsFNii4RvAyG47eIhii4mCsYAZnAJ13DJ61URExg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VoPLKOkT+xtS4dFKe+2el3KBuzTBZI8nqFKCajfMDPI=;
	b=1MvZI75C6PkS3tKZ+AExky9VagJK2UlgkEpXIeM4jCbr1zOyVpArbSHQFdcceCxDcmC8
	 oNHeD3JP8mJqOhSuXbLdgplC/c/1jqZqgqvoo2Q15KVMgB5rxlFLX6RCcxsCWWEZUYSmF
	 lnEtyAL3L4c7dNRsXCP6bAsEQvmHY9GwiUCYvkOE/Yq31rZB2XGCbX4OdLhABEgUhWNgU
	 lvUfVU1ClxjMsoyw6RwQ1RqUd1Y5TN/oSMKE1HP0w0I+fWH5xIwkCwWcxzcj8nnSliKXW
	 IZ8ozQKnxVOFqXA3bk9fLXn2qMCITgSWbNJEGzIZAXjeyNROl2/j9WOaTwmEGa+DSIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL1H7Har;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 509C8606A334;
	Wed, 25 Nov 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KL1H7Har
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8BC1F000D0;
	Wed, 25 Nov 2026 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620272;
	bh=VoPLKOkT+xtS4dFKe+2el3KBuzTBZI8nqFKCajfMDPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KL1H7Har1WRY3qJSTAE2Eel8HYVZ4PiRrdi+yNUiPqoGumAixQquW86fBfAxQNf6N
	 sr/uHQP3zJbOenV+ISKMX2zgzL8O+yGyjFdA/KEDoAYSuv48Eh/LdX0HjMzl3vyalK
	 cTkxtS5yeX9N1HvtOPpozZnwCdV4m8eK8rOk+W/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	guolingxing <guolingxing@tju.edu.cn>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 7.3 0864/1005] dm-pcache: do not advance dirty_tail after backing flush failure
Date: Wed, 25 Nov 2026 15:36:42 +0100
Message-ID: <20261125143841.947794172@linuxfoundation.org>
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

From: guolingxing <guolingxing@tju.edu.cn>

commit b1310cb291935c788f34ed6eb1e7e9b42cfac045 upstream.

After all writeback bios for a kset complete, writeback_ctx_end()
flushes the backing device and then advances the persistent dirty_tail.
However, backing_dev_flush() discards the error returned by
blkdev_issue_flush(), so dirty_tail is advanced even when the written
data is not known to be durable.

dirty_tail points to the first kset that still requires writeback.
Advancing it causes recovery to treat the preceding kset as clean and
allows its cache copy to eventually be reclaimed by garbage collection.
If the backing device flush failed, a subsequent power failure may
therefore result in data loss.

Make backing_dev_flush() return the flush status and handle a flush
failure like a writeback I/O failure. Leave dirty_tail unchanged so
that the same kset will be retried.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: guolingxing <guolingxing@tju.edu.cn>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/backing_dev.c     |    4 ++--
 drivers/md/dm-pcache/backing_dev.h     |    2 +-
 drivers/md/dm-pcache/cache_writeback.c |   28 +++++++++++++++++++++-------
 3 files changed, 24 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-pcache/backing_dev.c
+++ b/drivers/md/dm-pcache/backing_dev.c
@@ -336,9 +336,9 @@ struct pcache_backing_dev_req *backing_d
 	return backing_req;
 }
 
-void backing_dev_flush(struct pcache_backing_dev *backing_dev)
+int backing_dev_flush(struct pcache_backing_dev *backing_dev)
 {
-	blkdev_issue_flush(backing_dev->dm_dev->bdev);
+	return blkdev_issue_flush(backing_dev->dm_dev->bdev);
 }
 
 int pcache_backing_init(void)
--- a/drivers/md/dm-pcache/backing_dev.h
+++ b/drivers/md/dm-pcache/backing_dev.h
@@ -120,7 +120,7 @@ struct pcache_backing_dev_req *backing_d
 						struct pcache_backing_dev_req_opts *opts);
 void backing_dev_req_init(struct pcache_backing_dev_req *backing_req,
 			struct pcache_backing_dev_req_opts *opts);
-void backing_dev_flush(struct pcache_backing_dev *backing_dev);
+int backing_dev_flush(struct pcache_backing_dev *backing_dev);
 
 int pcache_backing_init(void);
 void pcache_backing_exit(void);
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -18,12 +18,18 @@ static void writeback_ctx_end(struct pca
 		return;
 
 	if (!cache->writeback_ctx.ret) {
-		backing_dev_flush(cache->backing_dev);
-
-		mutex_lock(&cache->dirty_tail_lock);
-		cache_pos_advance(&cache->dirty_tail, cache->writeback_ctx.advance);
-		cache_encode_dirty_tail(cache);
-		mutex_unlock(&cache->dirty_tail_lock);
+		ret = backing_dev_flush(cache->backing_dev);
+		if (ret) {
+			pcache_dev_err(CACHE_TO_PCACHE(cache),
+				       "failed to flush backing device: %d", ret);
+			cache->writeback_ctx.ret = ret;
+		} else {
+			mutex_lock(&cache->dirty_tail_lock);
+			cache_pos_advance(&cache->dirty_tail,
+					  cache->writeback_ctx.advance);
+			cache_encode_dirty_tail(cache);
+			mutex_unlock(&cache->dirty_tail_lock);
+		}
 	}
 	queue_delayed_work(cache_get_wq(cache), &cache->writeback_work, 0);
 }
@@ -76,8 +82,16 @@ static inline bool is_cache_clean(struct
 
 void cache_writeback_exit(struct pcache_cache *cache)
 {
+	int ret;
+
 	cancel_delayed_work_sync(&cache->writeback_work);
-	backing_dev_flush(cache->backing_dev);
+
+	ret = backing_dev_flush(cache->backing_dev);
+	if (ret)
+		pcache_dev_err(CACHE_TO_PCACHE(cache),
+			       "failed to flush backing device during exit: %d",
+			       ret);
+
 	cache_tree_exit(&cache->writeback_key_tree);
 }
 


