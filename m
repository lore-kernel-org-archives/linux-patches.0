Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035951;
	b=UOVW5VBQzE1dIlFT2Fp+ivQ1PdfXTgiJwbAUF2cDYiRQ1KgWYZnaxCdXQRe8nLDqF5sL
	 krQ23tFqlsd6/l55pFmcELVMP368z1q0CxMkegAhaSEVsI3FjFuqAisK/k+/vAwFyzdUo
	 SvXaLNgiw0qngHuvWcHZHe29qSqWN8zOLj0bKcwI5oo4NTeTCBgSXfxsv45XZ1crowigQ
	 8tRoGwVE4j3NXAiwDzyBen4laletOqD8tRD3w18Dp3NB5PESiBZCtTeHt8l+BKBzySwUC
	 5RR9Lsg92m8X3fYfPa4HUrUfWBq7/MRGWuKR7AhwIZas1ICVZEaiXfkNSbj2LQ3uvcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035951;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QZY1+CYTebZbIjHY4b1ZyJPzknBz9sMvhyCWYDnWqKQ=;
	b=DT0rJXAvilVOLnpCyl3AfJ/hu7eUTNAaj//uAYMQ9bp7WYTb+BuTCSOrKHY17lfClqLR
	 qHpNFTxl3VYBP9PHFpsEt55ezLOGuveqHe6MS7fY29VOZLo0MxiuK1xHmV1hRG0JUgNoL
	 ZkvsTjlBaJHuI8fyP7VjydEQzcrf//h9uMojyrY1MpM2diahF3GHzBpzJPK5D2COOyZ9v
	 8esaycNtpLF4zmBXHe2UE8VAl9kN2aOhvAGifRgFuks5qe2mjn+JKqod+om+0OBjMjOc7
	 xwiW0S/4SWaBMI3kfAs9EGxsIVsJug47QiKNdEGWL/KI7hpmJAMhpcK8vFWdA0/7y3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHrlSmIh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3216606A334;
	Wed, 18 Nov 2026 21:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHrlSmIh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B9D1F000C4;
	Wed, 18 Nov 2026 21:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035950;
	bh=QZY1+CYTebZbIjHY4b1ZyJPzknBz9sMvhyCWYDnWqKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHrlSmIhhbBRUsWT8FL0hS12qYKKzRLjYHi+wHaoph/1E1z3VUxTGhP6YRaz3UeFm
	 Yre5ljL9WU7ai0alyNb7QyrsCSH9vBVQFhELbr9n22+lJp7+AFHW1DfZdwLoySl2f/
	 HA5/SUMFx0fPIQbjpV0rEgMJ6fZgSDK+QL0sR7i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0886/3318] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Wed, 18 Nov 2026 15:25:08 +0100
Message-ID: <20261118150345.973505324@linuxfoundation.org>
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

From: Cao Guanghui <caoguanghui@kylinos.cn>

[ Upstream commit 5028ceee173bfcf844469cfb0d1c151d3f6d0296 ]

free_conf() iterates conf->pool_size entries to free extra_page
allocations, but pool_size may not reflect the actual size of the
conf->disks array.  Two scenarios cause a mismatch:

1. setup_conf() early abort: pool_size is 0 (not yet set by
   grow_stripes) but conf->disks has max_disks entries with
   extra_page allocated.  The loop iterates 0 times, leaking all
   pages.

2. resize_stripes() Step 4 failure: conf->disks was replaced with
   a newsize-entry array in Step 3, but pool_size is only updated
   on success.  The loop iterates pool_size (old, smaller value)
   times, leaking (newsize - pool_size) pages.

Add a dedicated disks_cnt field to track the actual number of
entries in conf->disks.  Set it immediately after each allocation
or replacement (in setup_conf and resize_stripes Step 3, where the
array is safely stalled with no concurrent access), and use it in
free_conf() instead of pool_size.

This leaves pool_size untouched, preserving the check_reshape()
retry behavior that depends on pool_size only being updated on
full success.

Fixes: d7bd398e97f2 ("md/r5cache: handle alloc_page failure")
Cc: stable@vger.kernel.org
Signed-off-by: Cao Guanghui <caoguanghui@kylinos.cn>
Link: https://patch.msgid.link/20260827080341.112296-1-ghuicao@163.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 5 +++--
 drivers/md/raid5.h | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d6035fc6232aa..747da5fb96254 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2649,6 +2649,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7454,7 +7455,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7637,7 +7638,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index fd61715538800..64b6a0fb28600 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -668,6 +668,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



