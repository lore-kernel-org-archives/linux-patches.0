Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339DF47F3CE;
	Sat, 12 Sep 2026 13:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218333; cv=none; b=VUFqRlAuSo4aPa2K00+lNKd8JChcoyus0AbK3cNYrtqv3Pv6CrxNxaKvxV6lV26YIq9aUiOEytcna6MzqTN994nzmA0fEYZhuE5gJGuUHzPpxEI/BpupCAP8XK+BO2Cf1I9+4ipqsiSNdVndVwyXezH0bNjhf2g/Sas+X87hDFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218333; c=relaxed/simple;
	bh=tgigubhBB+hS8EQIjg6zvQypScokmM+LGZGRohv4Et4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YdTQNxFUXPC43bT9ihbfmsHO20itHQjcEaKfd65nrSE/fDVDBMPgNzQKPlpRRtqFrACHfrFugKfFLybqayDl8Nydu3nECdHznbA2sAm2d0vf5pHVf2ezz9gcEObz+gRaM6zEneO4JT+jAhvBFX2GelVJc/EddgAFwo7qj6i8Q5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANAQx772; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANAQx772"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE91F00898;
	Sat, 12 Sep 2026 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218332;
	bh=T91O3+GPDv9+KVN3dzRgGy1oGiO+KWv+aIMwmIKn5ZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANAQx772z02zKhxvaMkd7FVJvMHfAb6xFg4Jy5Qp2fcPPYgaVz6WjtYf14SqgVZ0j
	 G5hXkBvYnROG/xM/dFB9ij6wknJAdGdNGGVlJ0w8JOyykjCtjUapMQlL4BVJQg836/
	 oTejO2IS9te8swO9yI3lieLVJaop0zoKR+D+w/GE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Byungchul Park <byungchul@sk.com>,
	Mina Almasry <almasrymina@google.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1124/1376] page_pool: rename __page_pool_release_page_dma() to __page_pool_release_netmem_dma()
Date: Sat, 12 Sep 2026 08:59:10 +0200
Message-ID: <20260912065632.615809206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Byungchul Park <byungchul@sk.com>

[ Upstream commit 4ad125ae380bf0bd55d6e1efb492d2ad4f867030 ]

Now that __page_pool_release_page_dma() is for releasing netmem, not
struct page, rename it to __page_pool_release_netmem_dma() to reflect
what it does.

Signed-off-by: Byungchul Park <byungchul@sk.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Link: https://patch.msgid.link/20250702053256.4594-3-byungchul@sk.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 24ef02f934ee ("net: page_pool: fix UAF in __page_pool_release_netmem_dma on xa_cmpxchg race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/page_pool.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 97ad4cc87be81..642ebe4924edc 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -726,8 +726,8 @@ void page_pool_clear_pp_info(netmem_ref netmem)
 	netmem_set_pp(netmem, NULL);
 }
 
-static __always_inline void __page_pool_release_page_dma(struct page_pool *pool,
-							 netmem_ref netmem)
+static __always_inline void __page_pool_release_netmem_dma(struct page_pool *pool,
+							   netmem_ref netmem)
 {
 	dma_addr_t dma;
 
@@ -763,7 +763,7 @@ void page_pool_return_page(struct page_pool *pool, netmem_ref netmem)
 	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
 		put = pool->mp_ops->release_netmem(pool, netmem);
 	else
-		__page_pool_release_page_dma(pool, netmem);
+		__page_pool_release_netmem_dma(pool, netmem);
 
 	/* This may be the last page returned, releasing the pool, so
 	 * it is not safe to reference pool afterwards.
@@ -1138,7 +1138,7 @@ static void page_pool_scrub(struct page_pool *pool)
 		}
 
 		xa_for_each(&pool->dma_mapped, id, ptr)
-			__page_pool_release_page_dma(pool, page_to_netmem(ptr));
+			__page_pool_release_netmem_dma(pool, page_to_netmem((struct page *)ptr));
 	}
 
 	/* No more consumers should exist, but producers could still
-- 
2.53.0



