Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04196296155;
	Wed, 23 Apr 2025 15:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422029; cv=none; b=LwZY5YjiyxU3kOZjl2LkQpC7s4EdwCtofGC8VtaT9jfNwYMoyL96jYANKDcpmXZrQjyko/0AtLKN8e8JlAPv1Va4tYnjWYXo5YlFIfq8YQB41d9ZZ67WRdtlWul+lLp7TOsbOifzm/QznI+jvo7vo7603hAsUeJzpJBleyMJYBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422029; c=relaxed/simple;
	bh=EQDQkLfb855H94vNq0lgengECwAPWx/jo72x7wTcCFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKQHLG2VchAexGcK9idwpCOtx9sGAP/LSj0vq4P9aIhOwBT8/Wvm0UWAnLi8SH1+ul0jJD/YoRu4N0SJ3TPhxeVs9JYsu+4bhdddFunVpoZZgGuu1/w0bHDaXLzydCIl/MzGMIlXocdOrJRMiPnd7raZhyX7HBUdN4ek5DJKjzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhByT8cJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhByT8cJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7DFC4CEE2;
	Wed, 23 Apr 2025 15:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422028;
	bh=EQDQkLfb855H94vNq0lgengECwAPWx/jo72x7wTcCFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QhByT8cJ8DiiXa/Co4233sagW1c2HB91aZUh5D2fNPLyOf7q31roUrrAWf5E/+o8+
	 h3LZZBFs2YKEhTBBkdEb2sBjPXCjQMhOTea5ZvsaZnVwEEa2lyBhL1bkhrRUlE84J9
	 NvqmcY9dFG9PZ3vBgqh/CKWuEmFOmp4xaG67T+hI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/393] test suite: use %zu to print size_t
Date: Wed, 23 Apr 2025 16:42:41 +0200
Message-ID: <20250423142654.312627848@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit a30951d09c33c899f0e4aca80eb87fad5f10ecfa ]

On 32-bit, we can't use %lu to print a size_t variable and gcc warns us
about it.  Shame it doesn't warn about it on 64-bit.

Link: https://lkml.kernel.org/r/20250403003311.359917-1-Liam.Howlett@oracle.com
Fixes: cc86e0c2f306 ("radix tree test suite: add support for slab bulk APIs")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/linux.c b/tools/testing/radix-tree/linux.c
index d587a558997f8..11149bd12a1f7 100644
--- a/tools/testing/radix-tree/linux.c
+++ b/tools/testing/radix-tree/linux.c
@@ -121,7 +121,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list)
 {
 	if (kmalloc_verbose)
-		pr_debug("Bulk free %p[0-%lu]\n", list, size - 1);
+		pr_debug("Bulk free %p[0-%zu]\n", list, size - 1);
 
 	pthread_mutex_lock(&cachep->lock);
 	for (int i = 0; i < size; i++)
@@ -139,7 +139,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 	size_t i;
 
 	if (kmalloc_verbose)
-		pr_debug("Bulk alloc %lu\n", size);
+		pr_debug("Bulk alloc %zu\n", size);
 
 	if (!(gfp & __GFP_DIRECT_RECLAIM)) {
 		if (cachep->non_kernel < size)
-- 
2.39.5



