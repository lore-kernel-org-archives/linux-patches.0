Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FBF17756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD11C433C8;
	Wed,  9 Aug 2023 11:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580072;
	bh=Ca2xW03CkZsnqK+E76VYFr7uIFkOOdn/ahPLoWva4HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yT7MJttbKoSQPsjB6OoUeKyJQjCCLTOtYz1Hm2syjgTEZFcNn90kJZoTyh5k3e9Q3
	 DRQW+/cf/IixUEtME/xTJNvNvA128QHNXRBz2X/pN+kJHicZ/sAjxSaaI6kAmAhG0e
	 I5NVL4Lzm3P4XqV75ZlGv8oGpj0Q5yOI/p1n+dWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghui Wang <shhuiw@foxmail.com>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 218/323] bcache: use MAX_CACHES_PER_SET instead of magic number 8 in __bch_bucket_alloc_set
Date: Wed,  9 Aug 2023 12:40:56 +0200
Message-ID: <20230809103708.083779483@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shenghui Wang <shhuiw@foxmail.com>

[ Upstream commit 8792099f9ad487cf381f4e8199ff2158ba0f6eb5 ]

Current cache_set has MAX_CACHES_PER_SET caches most, and the macro
is used for
"
	struct cache *cache_by_alloc[MAX_CACHES_PER_SET];
"
in the define of struct cache_set.

Use MAX_CACHES_PER_SET instead of magic number 8 in
__bch_bucket_alloc_set.

Signed-off-by: Shenghui Wang <shhuiw@foxmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 80fca8a10b60 ("bcache: Fix __bch_btree_node_alloc to make the failure behavior consistent")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 46794cac167e7..a1df0d95151c6 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -497,7 +497,7 @@ int __bch_bucket_alloc_set(struct cache_set *c, unsigned int reserve,
 		return -1;
 
 	lockdep_assert_held(&c->bucket_lock);
-	BUG_ON(!n || n > c->caches_loaded || n > 8);
+	BUG_ON(!n || n > c->caches_loaded || n > MAX_CACHES_PER_SET);
 
 	bkey_init(k);
 
-- 
2.39.2



