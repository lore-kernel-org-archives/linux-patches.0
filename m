Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591611;
	b=FVwHa5aGFQB9JVpINR4oKb57YE861zynOsxQksBkMfgqE2iMQsqvOOsiNGTymjolESN6
	 IM1oakDO49kGHDPARn29jheeFaPR+PrerFQ3bYbMkKfMCDzcuJsZ0qN1EybzuIC80peD6
	 4TcLX/MgcIt4Qhe96R0bVebbvCup4lJwKuRFrX/XavtOD+U8nbFsGn9xkG/rrd9Isurl3
	 +fO/FdNixwEDxdiO8D95PseRIl0P5m4rparTjGUqbOXgljgU+6tdopyI6yQ9jQrXYtaxl
	 SlMDm/WkvkmezWfTj/iuoM0gqknEP76Fr47uKiYY2yM73u25YofLL3LWqL82Obm2BCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HQUcIyNC+XMXTtoPaw+JUPJ67sSY0Cbz3H9/D0+wd48=;
	b=lV3wEN89JyTW/QKoAJS1JFbQHArCuDtG4UHK3+A+MnP1G4ZBK7ufLCA88LUaU+K6i0mj
	 hPArBL9fAG30XH2aho1Q/WYvbCyS2PVOIcugnhmEiqb9YgBtkWjqgOo4Dbnezu5WHLE/Q
	 iMvOyURNKaEwPDj3/wu4NAg4yKVwbqMybAknQvWx63zeIK5VITm8/VdJEeLl/W3vW+Jz8
	 vPnEbtI/enHR0YcD+sInV5E2/p7Ug24Jrx5PhLDCnFCjmzMfWDtyg4mGgGgtn4wc8AOSv
	 IfwqiiwWKYfB72ZIhkSBk9X6724LPrNmTERLAEfvLFxCcyQiaDVoGgYiQYUVc5PFVLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwpxGmts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD1E606B466;
	Fri, 13 Nov 2026 17:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwpxGmts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8185B1F000C4;
	Fri, 13 Nov 2026 17:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591611;
	bh=HQUcIyNC+XMXTtoPaw+JUPJ67sSY0Cbz3H9/D0+wd48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwpxGmtsqEk+svBGteCTqOc5v3WP+pHm1vwUWRCBoincTk7jImYQsg7bV0uB+d+GB
	 oRxl+OrCRb4TikyBoNOoIjgSx0PFVuq7YKD8c8mqdn812xp94kyT8eerLlOL4T24m1
	 A5N/yL3UtQAMbc0ymuA6L4zwWJ5EUfUjKWpBXQok=
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
Subject: [PATCH 6.12 611/670] mm/zswap: publish the initial pool with list_add_rcu()
Date: Fri, 13 Nov 2026 10:52:55 -0500
Message-ID: <20261113153832.521746471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Adjusted context to preserve existing logging of both the compressor and the zpool backend. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6c50249d5398f..61311c92bd6f6 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1778,7 +1778,7 @@ static int zswap_setup(void)
 	if (pool) {
 		pr_info("loaded using pool %s/%s\n", pool->tfm_name,
 			zpool_get_type(pool->zpool));
-		list_add(&pool->list, &zswap_pools);
+		list_add_rcu(&pool->list, &zswap_pools);
 		zswap_has_pool = true;
 	} else {
 		pr_err("pool creation failed\n");
-- 
2.53.0



