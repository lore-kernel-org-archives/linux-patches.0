Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052263;
	b=FGyBwq8qWf9VHgHOeS0hHyqpbLWBBCxL5NnHyVE1bL2LJ/MBgl7NqrUm2KfOfcRxyWCJ
	 5EWIdNQVt836uYyioVMaasSMOyZfpiD5W856HDPXvqQBNkD8YTC61mRiGa6Dobrsb5Lrk
	 nNZRvnAqRLWKaEcIb+VEfPWH5l2YYfifD0G/mv0nRvvUqPAe6FlmDcFSZVIDrILlghnUL
	 jDIYnoP97s7uwIAVIGxldk5QgqA2VBvIIybcMNeTm1uZK7XwpsB4oL/yR3L7RcotiXr3Q
	 IfVPC57K6Gq5fykCml+PQZ1Wz2IYI+H4aNLE1Hjb6bQcjIhFXI3bNBtcYS9QeTjHu5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HKPTaPIjIngqHfZW9Xugk4QlxY1sC3+ShTYTDcg8sSM=;
	b=qZRyxSjas9gWijfmPgeUfuEAbi5xEeQa0nrHMiO0bFBxYV8gsDprKdhLS+kKmtUDf0f/
	 VrVr4vBI16/C+3wDRMhbQj3X3knY5+Dfmw7JtkkWcotDZwPolyR6Wft0V9CYtD3Ttqv6Y
	 K9CAMryLF1noYZUhvIVAqYfwW+3t+wnB9gzNlwG73hdCIJDzZ6HlSdaPN17VMSoXToeak
	 ecgQvuzM0V9521En5vFBFGLXGVLTTh1qfO9zwtrGx/dCE5avbY+8VB5OhCPnxBFOMeJGY
	 Oz4pjAuFXWkuYnAlzkLczUm8A1bAReuwrN2b6MbhI69HWOovI6BTX+HuC4j9hwv3Ysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im84nrI8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB7606A325;
	Thu, 19 Nov 2026 01:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Im84nrI8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D98F1F000C4;
	Thu, 19 Nov 2026 01:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052263;
	bh=HKPTaPIjIngqHfZW9Xugk4QlxY1sC3+ShTYTDcg8sSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Im84nrI8UL68YWNQcN45maBqQbcSfCoNiQaVcpFt7cMUZBznkJrc+oUlOEgRqyiBG
	 a0OpZGufxSLu9wwO2Y2KDtA8d/6wHsQxdIM+QEdwPJib4dY2XVhk9CKDw5KsKGog+a
	 dWvSu/I0JgD6b7md69o56Odufd+G4SuS2+tvV0yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0500/2214] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Wed, 18 Nov 2026 15:36:16 +0100
Message-ID: <20261118150031.156941854@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 400e5192078f3..67002e38e70f7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2582,6 +2582,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7106,7 +7107,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7288,7 +7289,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 5c05acf20e1f2..3e6f6df34de7e 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -667,6 +667,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



