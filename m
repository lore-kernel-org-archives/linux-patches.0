Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062010;
	b=N3PugV6cH/W8mVtsvStPhvugy1vu5ORDFD0zqyExc0fvBxqrsjts+aqK/ZSTP237mrnv
	 3f4j2gT7FUDO55WxGR3ZijGYMA3ASmqkNAVLiAmPjfTLtVaDrIJum/ygayBwmZdXCxAiI
	 YafXS4i0VmNursO7Jv7WqyIKRvLIRCPYc9HG/eIELxV6LhcSyftzB9/Bp1VCHyIAwWyEi
	 O1VdM8mwdhzTZGRbMWszMWzDjY9rTfk1D6Gi/FgCYJILzrkTu1f5sNQfIwLWIyHBwDgU2
	 QUCqvmusfD85zlEUoHOnDnUgRsNy2N9Acnk9WwuNc6GtEEBHDtB45xYndtKFnGfZsiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JbWRzJsVroeP+ZW82XQQkj/p76OLMeYsJKqQZX/8bRw=;
	b=xD7PAOerWoYirZqG4IMPwTqWweh6pL/GWe1DINfkF4IrgXg8X1cQ1Dmm2dCzOnNDiyog
	 LwP+fh7QOqtCOSMDwI68eXxuzRyT4k1ubr1klbXrer7YhpRp3QT2TIEONpdMoTmgHGJfT
	 OR0gxdZrCajxnTZ4UbIv168kP5Va1d/zw5xDLYpq0yLYhNUYyiIF8D01tl/1WNIqhk91s
	 EJNR2z2hr4m38Tg6m1Hq5e4dUNDciHuQxCJvDI0XJjzKnGoCrTLDg8lsNKxiNKD68223e
	 WpeepQ50CazYlMtC3t9Zvo1AV0s8Q8BniuezP6wX+M80YgZa25iBxT0Z/E4QoLlBh+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwnbz9y2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A70606A333;
	Sat,  7 Nov 2026 14:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qwnbz9y2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC8F1F0089F;
	Sat,  7 Nov 2026 14:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062009;
	bh=JbWRzJsVroeP+ZW82XQQkj/p76OLMeYsJKqQZX/8bRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qwnbz9y25p3asKlvNqez73EeNlZGwNhhq9LzWtRL7T2VyApemGXxo6j28BM9P+jGX
	 o72JCjzSn29yjgrnJIlBTNX+KylKJbUJd7t+DTENBJGjQob8S35pDg+cS5oFGovJ/9
	 I4XCgM7fdWO2bUlhQIwncrqZ0i02HziGy5HYG7+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cao Guanghui <caoguanghui@kylinos.cn>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0999/1536] md/raid5: track disks array size to fix extra_page leak on error paths
Date: Sat,  7 Nov 2026 08:50:15 -0500
Message-ID: <20261107135025.727042304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 36c4cb7326823..a92d98a3c91b0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2635,6 +2635,7 @@ static int resize_stripes(struct r5conf *conf, int newsize)
 		} else {
 			kfree(conf->disks);
 			conf->disks = ndisks;
+			conf->disks_cnt = newsize;
 		}
 	} else
 		err = -ENOMEM;
@@ -7410,7 +7411,7 @@ static void free_conf(struct r5conf *conf)
 	free_thread_groups(conf);
 	shrink_stripes(conf);
 	raid5_free_percpu(conf);
-	for (i = 0; i < conf->pool_size; i++)
+	for (i = 0; i < conf->disks_cnt; i++)
 		if (conf->disks[i].extra_page)
 			put_page(conf->disks[i].extra_page);
 	kfree(conf->disks);
@@ -7593,7 +7594,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	if (!conf->disks)
 		goto abort;
-
+	conf->disks_cnt = max_disks;
 	for (i = 0; i < max_disks; i++) {
 		conf->disks[i].extra_page = alloc_page(GFP_KERNEL);
 		if (!conf->disks[i].extra_page)
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 2e42c1641049f..53e9aecc17f61 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -668,6 +668,7 @@ struct r5conf {
 	unsigned long		cache_state;
 	struct shrinker		*shrinker;
 	int			pool_size; /* number of disks in stripeheads in pool */
+	int			disks_cnt; /* number of entries in disks[] array */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
 	struct bio_set		bio_split;
-- 
2.53.0



