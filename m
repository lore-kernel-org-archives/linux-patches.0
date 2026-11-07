Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063223;
	b=0uwYcCk56i+U71J38ipLTUV9MfsROmwb+2CkMJ4BJdDJ6Nzs6hgDEei1KF1eToYqXbGi
	 8nWfDEvIV2e0NU1i3lZR5KQhy/sFPTpCryPRHFVE6WonSVnFv2p1zXY2zij0oA7YvBzzS
	 xxATiLc8JBB9RHtaO2UPJlLj/BMsd87DrChI52mLaAqV2L8Pnihsof2ZXoSWD2AMQzafT
	 C+1m3/euRsl4DcW6np9ttOTtW/YrlE2Jp3hVomZx0Kb7UTDcwLZGz4FHPRO14dJehlfAS
	 6M9RU9eN6UWuxP2gtXfLZJfreZWK1uTkM5yf773GxZ+pIS+wdQBCM+gqiEjnUnQ47JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5uzda+5KCgzQl3p11weeyLCSIg5RI6R7Ev5V7bcGWg=;
	b=Ry0obtlvBUCClE3XXtpAKX9op6cCPdzU4lAVlOqmbGn8EtCNLmhUwdD0UXUouxXYRrlh
	 E4JXUnUcSDuErmryZzK6NuAwgeLZL22zskeNXN9M91ALqUGnrnQORHQ8JFKBC4XWgBKpf
	 yy5qdE/T5QS4vZJeKARgG1fJ5kxf2I3jQFStibW4YY/T7ou9blD5+h1rja7qfReupx94O
	 3RFcZXP1NOakMIc9YOgicB+qZ0EveKDzyeg7kGjFOkU4bpeyyKZ6ea0yby8xxuzib+T4y
	 6ZSha1C2tqQTBRK2iMmVuGr3TJWx5RMCyzPaDoM+HKVO5mlnTePt9KZ969SKLcAAffA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUWFvtC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42FC606A326;
	Sat,  7 Nov 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RUWFvtC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3F71F0089F;
	Sat,  7 Nov 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063222;
	bh=O5uzda+5KCgzQl3p11weeyLCSIg5RI6R7Ev5V7bcGWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RUWFvtC+SQwfC4gC2QWJjORt+0MPRngSx8c8FBNoaPBsLEwD24AsUrqaiSbZR20Ol
	 K1NJv1x+5L9A/Z0nbp4jDxDrD6KvRoG/1P1HQIgWVlqBKcop3dKrRO4Ta6cFP7ds4R
	 nS8WeoHi2If7PiWZvK3ISCbpazUNCf/MVTP7A6JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sashiko <sashiko-bot@kernel.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 430/869] mm/zswap: publish the initial pool with list_add_rcu()
Date: Sat,  7 Nov 2026 08:51:52 -0500
Message-ID: <20261107134908.410556587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longlong Xia <xialonglong@kylinos.cn>

[ Upstream commit c1dd5e24a82d19bff8eef50ba8205d4776584aff ]

zswap_setup() publishes the pool on the zswap_pools list with a plain
list_add(), but the list is walked by concurrent RCU readers holding
nothing but rcu_read_lock() through zswap_total_pages(), e.g.
/proc/meminfo and the shrinker count path.

    CPU 0 (writer)                          CPU 1 (reader)
    --------------                          --------------
    zswap_pool_create():
      pool->zs_pool = zs_create_pool(); (1)
    list_add() -> __list_add():
      WRITE_ONCE(zswap_pools.next,
          &pool->list);                (2)   zswap_total_pages():
                                                pool = READ_ONCE(     (a)
                                                    zswap_pools.next);
                                                zs_get_total_pages(   (b)
                                                    pool->zs_pool);

If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at (a)
but dereferences a wild pointer at (b).  Publish the node with
list_add_rcu().

Link: https://lore.kernel.org/20260908012801.1864430-1-xialonglong2025@163.com
Fixes: 91cdcd8d624b ("mm: zswap: optimize zswap pool size tracking")
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong2025%40163.com
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Assisted-by: Zcode:GLM-5.3
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 18249dd96ef86..e4b2f6abefafb 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1818,7 +1818,7 @@ static int zswap_setup(void)
 	pool = __zswap_pool_create_fallback();
 	if (pool) {
 		pr_info("loaded using pool %s\n", pool->tfm_name);
-		list_add(&pool->list, &zswap_pools);
+		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 		static_branch_enable(&zswap_ever_enabled);
 	} else {
-- 
2.53.0



