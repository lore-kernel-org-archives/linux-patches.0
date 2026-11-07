Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064558;
	b=Z21FKdZ0v6/el1JhyrnH6xS2zEsjWpO7MQNH8Q9B6npSTucv3twZX91Ps55kAqg1eK0+
	 kY4NtCepjtwn3QnPYP7qqoz26HDzkKbb7z6WpfAl5M+nz1thDUOMLki6guRSszRUPQU9f
	 kyIiMNm6aQc4nQUta5tNEZyICWDd1a1+d2scnMVRZm1SEslcabuNj3baoEqLBq4vfO03S
	 UFZEQYjE7p2pVm7n4X0r0jxOq8v1ecmVi/zv/dR3fx3c6yBozR/AxA4v6IkZuV85ylxH6
	 0hz4Lf8GsVl+esN7qx7QiaVJpdd2cCMIfq8SxxwEmVN+YVvtaqD10bmBfORW+SR0YPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DS8UXzKTEWfx7B1g56QlJrsmv1oiFWGbYEPyfMOk8tQ=;
	b=BDpsyiz/Mabd56jsanQT1+hvAAvo3DrOzZzOUkBzn8tqNVem2EKcN71jJzv9PTornc+B
	 ZPFN+oe+SsvQYsHnFBMzMCGgkYHXhTaKtSE/GPYjomkcN11RXe4sM8UK77lewyGCmTJzX
	 RjfR8uE5aOhrC++xJXr7RJsTdGUIVMnS/2HXtRFZDE8mzlBuSqvSo7wjVSnS5jy2hRwLX
	 hkXO9AlLmlD4ZpLUJYvHG+VFM/wfx6n0oZ11b03vWZtF3jDUg9VL6Q6OwFrlpOJ9OafQ4
	 t8CgCNpDG5U2QitYITwW3f+NUthXlQggmstEPafE8ZW4NzAtkYpCdh17O59RYGrkI1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJ48FimY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63938606A331;
	Sat,  7 Nov 2026 15:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJ48FimY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146751F0089F;
	Sat,  7 Nov 2026 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064558;
	bh=DS8UXzKTEWfx7B1g56QlJrsmv1oiFWGbYEPyfMOk8tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJ48FimYFo+MIPFGfHkAoNHfc3BDX23F6byKHI7Nnn+nMjHVgQpeMa/15ZOp35gWV
	 vA+eUegAg1F8iOlBok+/2saN9a+qTqLocFSd2hQ+jWrqSH351pulWl+wqCcGSgzMIY
	 OVw+efp4QS+Y7ZovrG7p4KnHfmmmBoIn6YbpVBxg=
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
Subject: [PATCH 7.3 0580/1257] mm/zswap: publish the initial pool with list_add_rcu()
Date: Sat,  7 Nov 2026 08:47:56 -0500
Message-ID: <20261107134955.372621386@linuxfoundation.org>
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
index 37f34e406c8e3..cb5a0855fd2a7 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1803,7 +1803,7 @@ static int zswap_setup(void)
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



