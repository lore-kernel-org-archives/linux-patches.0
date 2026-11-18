Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045044;
	b=y5Sw8HCOmaMOHf6tvPAj1zQ6ZbRUwLAZnRDtLs+qO/i+viWu/9nEiYqKkac1fubofIjr
	 Hl7uo3imAy9/MToYniPs0W0amQdNzmBbaqQG9zc+W22UuKQAKINFl3zoUm7zxK1SYIP9L
	 VLJXtGrXKgfJx1VyWc6T1FAEQ/9gqXcH0hm33Syp3XFiHw8WKxE2YfKppBqLJWeVZqaJW
	 5YqzXV83msjRM1K4jgmWmVtyzbJx1tvs2i1GFtz4NE4IdOEUetWK9CT0hNgqZ+M08+Xsi
	 Ognr7oRDzsb4PrdgXFjSOU8yxqT2eCxsSZC4eh6OPmg7xNXk2SJx8ItSHAl84PEmS+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/2clveJBxGY6vSUWvo4XP+5xsLYaggCWiMYnHcK2pEg=;
	b=LZLlIQeO3crrfbZxUG0bc4c5u6+m7R24faG4L9r2Swj9zETA+qI2Sm+Jfg5UdD2tf8YX
	 tJ3j4+fZUUkazHAiidJ8IafKupCBPo4SRi3RQ06TQ8jLEPJsJINo39A8YEYXFZJEFJVS+
	 m07bxpNRjwnyXfSLuc+6aeobweHef3vno+4zV4tlJwlGtVa+EexajyTA3jqGWR1rtEGXw
	 AbnFIKFLWm8rMztSnmiKMYc44KGRGqZY71kYLnwEICobknGl0+f1cIRRZIEi/8iyDFxHD
	 GAR5FG9MZEJ6k8ZEP5TSUMq0CTLscCmG7iS2/cFRGU7EF0gxsM2AhwJA/nla4SfThNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1a+OmrTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C743606A320;
	Wed, 18 Nov 2026 23:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1a+OmrTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352891F000C4;
	Wed, 18 Nov 2026 23:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045043;
	bh=/2clveJBxGY6vSUWvo4XP+5xsLYaggCWiMYnHcK2pEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1a+OmrTojtr+3l/wS6dty+1Hdk1KY0+LQreMlPeBkYrZpCLSLUvoLzOhta7P7I8Cn
	 jdX1Ugx9m5beLDGfD+A8zWN1cv7D3ryOgaW76Iw2S7h6lYE673o7dG7sUvhBwFyUt4
	 GTvVm9SuTFMKkuESWSC0KfZ6h3EPB5RiLvEXZ9C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0780/2857] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Wed, 18 Nov 2026 15:30:14 +0100
Message-ID: <20261118150229.654019094@linuxfoundation.org>
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
index 663b95b82360e..94b38c4fe5a88 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2652,6 +2652,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7422,7 +7423,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7605,7 +7606,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index e873938a6125d..fd0161c5496fc 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -672,6 +672,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



