Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFB12DFF1B;
	Tue, 17 Jun 2025 16:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176427; cv=none; b=NJmkPXdI2erUwxsIztMgv6L5amh6MO3eBrtVMdHjrVwtMb/G4a53qo1/U/resL1/oAtUfOF/5c/nlN3QLus2iSXCaOVwvGo7zBCGqnXJwEaKIw+2GvjuF2c6Rl5KXNbYq9p/2YbN9TTPWK2t35Mc7Kb6GlwJqd0bnx3FGB21W+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176427; c=relaxed/simple;
	bh=aHAZH9tW6XjSw24vL5eD/YiZOIcVvTWbfCdNf3BduQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcB5+6I+TjnbQ0XnsWxHhdl5u3K6FIraccgo/bCLPoRtWykaY03plXQBHYrMnOSnYBoawIpkUY8gMIqnLYVHxsqt/9FG9Z+DdtqVyLpc/Mf81zNkY55f6HlqojrSpVN+5hEGyoPQoH4EInGDvWYD/pX261chy6weCuB40n/nGZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1uch1g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1uch1g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83A1C4CEE7;
	Tue, 17 Jun 2025 16:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176427;
	bh=aHAZH9tW6XjSw24vL5eD/YiZOIcVvTWbfCdNf3BduQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e1uch1g9lt0HFFMSq35zfoumVVQUjCnYC+FmQGabXS7EEwmjIm0yMrpTjbvi3r/eV
	 4qrDCAqnykc6vVFK4/9PypbvcVUe2ApznyfAWeELJMWaKFdT/sliCOAD6TZ979tCQf
	 oU+u0mqokZDqpCPu4jQaRWCc2jPfPFiEmM9k27qg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mina Almasry <almasrymina@google.com>,
	Yonglong Liu <liuyonglong@huawei.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 188/780] page_pool: Move pp_magic check into helper functions
Date: Tue, 17 Jun 2025 17:18:16 +0200
Message-ID: <20250617152459.135022118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit cd3c93167da0e760b5819246eae7a4ea30fd014b ]

Since we are about to stash some more information into the pp_magic
field, let's move the magic signature checks into a pair of helper
functions so it can be changed in one place.

Reviewed-by: Mina Almasry <almasrymina@google.com>
Tested-by: Yonglong Liu <liuyonglong@huawei.com>
Acked-by: Jesper Dangaard Brouer <hawk@kernel.org>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://patch.msgid.link/20250409-page-pool-track-dma-v9-1-6a9ef2e0cba8@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them when destroying the pool")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  4 ++--
 include/linux/mm.h                            | 20 +++++++++++++++++++
 mm/page_alloc.c                               |  8 ++------
 net/core/netmem_priv.h                        |  5 +++++
 net/core/skbuff.c                             | 16 ++-------------
 net/core/xdp.c                                |  4 ++--
 6 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f803e1c935900..5ce1b463b7a8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -707,8 +707,8 @@ static void mlx5e_free_xdpsq_desc(struct mlx5e_xdpsq *sq,
 				xdpi = mlx5e_xdpi_fifo_pop(xdpi_fifo);
 				page = xdpi.page.page;
 
-				/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
-				 * as we know this is a page_pool page.
+				/* No need to check page_pool_page_is_pp() as we
+				 * know this is a page_pool page.
 				 */
 				page_pool_recycle_direct(page->pp, page);
 			} while (++n < num);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index fdda6b16263b3..af2f551668e9e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4265,4 +4265,24 @@ int arch_lock_shadow_stack_status(struct task_struct *t, unsigned long status);
 #define VM_SEALED_SYSMAP	VM_NONE
 #endif
 
+/* Mask used for checking in page_pool_page_is_pp() below. page->pp_magic is
+ * OR'ed with PP_SIGNATURE after the allocation in order to preserve bit 0 for
+ * the head page of compound page and bit 1 for pfmemalloc page.
+ * page_is_pfmemalloc() is checked in __page_pool_put_page() to avoid recycling
+ * the pfmemalloc page.
+ */
+#define PP_MAGIC_MASK ~0x3UL
+
+#ifdef CONFIG_PAGE_POOL
+static inline bool page_pool_page_is_pp(struct page *page)
+{
+	return (page->pp_magic & PP_MAGIC_MASK) == PP_SIGNATURE;
+}
+#else
+static inline bool page_pool_page_is_pp(struct page *page)
+{
+	return false;
+}
+#endif
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 47fa713ccb4d8..4f29e393f6af1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -898,9 +898,7 @@ static inline bool page_expected_state(struct page *page,
 #ifdef CONFIG_MEMCG
 			page->memcg_data |
 #endif
-#ifdef CONFIG_PAGE_POOL
-			((page->pp_magic & ~0x3UL) == PP_SIGNATURE) |
-#endif
+			page_pool_page_is_pp(page) |
 			(page->flags & check_flags)))
 		return false;
 
@@ -927,10 +925,8 @@ static const char *page_bad_reason(struct page *page, unsigned long flags)
 	if (unlikely(page->memcg_data))
 		bad_reason = "page still charged to cgroup";
 #endif
-#ifdef CONFIG_PAGE_POOL
-	if (unlikely((page->pp_magic & ~0x3UL) == PP_SIGNATURE))
+	if (unlikely(page_pool_page_is_pp(page)))
 		bad_reason = "page_pool leak";
-#endif
 	return bad_reason;
 }
 
diff --git a/net/core/netmem_priv.h b/net/core/netmem_priv.h
index 7eadb8393e002..f33162fd281c2 100644
--- a/net/core/netmem_priv.h
+++ b/net/core/netmem_priv.h
@@ -18,6 +18,11 @@ static inline void netmem_clear_pp_magic(netmem_ref netmem)
 	__netmem_clear_lsb(netmem)->pp_magic = 0;
 }
 
+static inline bool netmem_is_pp(netmem_ref netmem)
+{
+	return (netmem_get_pp_magic(netmem) & PP_MAGIC_MASK) == PP_SIGNATURE;
+}
+
 static inline void netmem_set_pp(netmem_ref netmem, struct page_pool *pool)
 {
 	__netmem_clear_lsb(netmem)->pp = pool;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6cbf77bc61fce..74a2d886a35b5 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -893,11 +893,6 @@ static void skb_clone_fraglist(struct sk_buff *skb)
 		skb_get(list);
 }
 
-static bool is_pp_netmem(netmem_ref netmem)
-{
-	return (netmem_get_pp_magic(netmem) & ~0x3UL) == PP_SIGNATURE;
-}
-
 int skb_pp_cow_data(struct page_pool *pool, struct sk_buff **pskb,
 		    unsigned int headroom)
 {
@@ -995,14 +990,7 @@ bool napi_pp_put_page(netmem_ref netmem)
 {
 	netmem = netmem_compound_head(netmem);
 
-	/* page->pp_magic is OR'ed with PP_SIGNATURE after the allocation
-	 * in order to preserve any existing bits, such as bit 0 for the
-	 * head page of compound page and bit 1 for pfmemalloc page, so
-	 * mask those bits for freeing side when doing below checking,
-	 * and page_is_pfmemalloc() is checked in __page_pool_put_page()
-	 * to avoid recycling the pfmemalloc page.
-	 */
-	if (unlikely(!is_pp_netmem(netmem)))
+	if (unlikely(!netmem_is_pp(netmem)))
 		return false;
 
 	page_pool_put_full_netmem(netmem_get_pp(netmem), netmem, false);
@@ -1042,7 +1030,7 @@ static int skb_pp_frag_ref(struct sk_buff *skb)
 
 	for (i = 0; i < shinfo->nr_frags; i++) {
 		head_netmem = netmem_compound_head(shinfo->frags[i].netmem);
-		if (likely(is_pp_netmem(head_netmem)))
+		if (likely(netmem_is_pp(head_netmem)))
 			page_pool_ref_netmem(head_netmem);
 		else
 			page_ref_inc(netmem_to_page(head_netmem));
diff --git a/net/core/xdp.c b/net/core/xdp.c
index f86eedad586a7..0ba73943c6eed 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -437,8 +437,8 @@ void __xdp_return(netmem_ref netmem, enum xdp_mem_type mem_type,
 		netmem = netmem_compound_head(netmem);
 		if (napi_direct && xdp_return_frame_no_direct())
 			napi_direct = false;
-		/* No need to check ((page->pp_magic & ~0x3UL) == PP_SIGNATURE)
-		 * as mem->type knows this a page_pool page
+		/* No need to check netmem_is_pp() as mem->type knows this a
+		 * page_pool page
 		 */
 		page_pool_put_full_netmem(netmem_get_pp(netmem), netmem,
 					  napi_direct);
-- 
2.39.5



