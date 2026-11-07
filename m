Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064007;
	b=OiuCA7quUF6jCXyn+TcCqwSDLJana3hQ17ScnAu9DFolKgwp1xP758Wjz0h1nd3dl2MS
	 zsjDKNNW2l7prsFmXbMtOL8dmJ7q7fkiALFgyqQgtJKQfXBfkiOOZHktouMF7MF9zClQE
	 mBhfTHEWs+obGjbXJZseCrgYmALnkLKrsuOpT4XmBGRz/LZaKv6GvvualSnfRQkM0ETHR
	 sLs/UZIKjK6HrVZq7um5l5FYKyU8eks1JFLRsC2SBqUQPLo0PSqSRIBh+pceti2q1+cTT
	 6k8zC2MfZppZx8mLoPlh42RBbHSKxCaf2ogO3ZEOerzcYxG0LdT3H/pCWdkZImufKNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNiVHVCR3gBYfSGJtcV/lhJdlQlKWw8JT4Crb35jXz0=;
	b=YpZwhttk7XB7f7RGhbvYp8djeAEObr38GiUfoNaxdrGNzeyMi/57scvNr2DzyC6tTtGu
	 PHJowWnRflAQFDQ0N5VC8zP01lo+2ajCok2fM1F7whg/SnXLfF/eaW7yFikuM9iBo1QZr
	 eow9Azs/GA5cxwb6wpYDGKx1GeRD7NAnqLk5LeQ8fit6wyIyo5FyZD7ELDJwNEKv5DNNW
	 kPMtdztYN9LfpGXq/HU8//YI+soT++LhaFkxMXZ89q7rGwS3mZxj97uaTdnyKMe21Zvok
	 eTgtx0VtAjhc+ncVunu74Gl6vLqaOhoeMudi9Pc5JIEJCRJAGDlsDwwEsKClERIL2BA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMRzpYg9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D65606D822;
	Sat,  7 Nov 2026 15:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMRzpYg9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FD01F008AB;
	Sat,  7 Nov 2026 15:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064006;
	bh=CNiVHVCR3gBYfSGJtcV/lhJdlQlKWw8JT4Crb35jXz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMRzpYg94BwnhPXL2l6qDSuI3wkYFU4X79B7i/45QpBKmvYzoKfWkF/N8KE/Jak0i
	 qZhZ8kZAxneECqK8fhB/nScRcEuQXdEQFhrPlvnv8Y5V31VRO2tzuydGMSoP9Cr6/s
	 fkAqyu0NyxgMnnzK3Ku2pwjH8jY3lEHvTO5V30GA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0186/1257] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Sat,  7 Nov 2026 08:41:22 -0500
Message-ID: <20261107134944.595009424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index b91545ce090de..e5838bf516e38 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2642,6 +2642,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7552,7 +7553,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7733,7 +7734,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index cb5feae04db27..94b3e2c947ba9 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -667,6 +667,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



