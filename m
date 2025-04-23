Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C336280A27;
	Wed, 23 Apr 2025 14:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419679; cv=none; b=iU+0MX28NujC26vkeW7KHlKWczESascXnyaBFNk6sst7u+K0aNmOcH3uQgzyGutayW7DdChkC4Gj+vilJr3Pw8JDMO3VwN+Wb5EkXWG7JnKRv6L8hyXrpxCVqNuG4dqi7D9V2ROAXSuXsga1UU8hL9s7Klc7X1MZRytBKn5bstU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419679; c=relaxed/simple;
	bh=dxQiIESHnhL8kZAfu4wGiwp5cYBiyE4oMi7W0M/JUQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3WxHElU1D1XMsK1fU0s10Mi6Zoh+Tcp7X61yJshiVRFhSZ4XuuTNVEbBoX/+VJeM0pNgWRRsHJUl8gwUpo5CDJWCEgvYRJxGT7DqWb5bpbjcFKmfF4u5Pl4FYJhj9PFZGF8t1pVNYTA1aARDYKRN4Qvs47znPbcn2G5mTYU5Do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtHXZbGL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtHXZbGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEAAC4CEE2;
	Wed, 23 Apr 2025 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419678;
	bh=dxQiIESHnhL8kZAfu4wGiwp5cYBiyE4oMi7W0M/JUQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtHXZbGLezkAae+3eisIfiYe6srg1cVgEBCdxdw2vtXYob188Nf/BuM+qH+XSlv6W
	 73TrxfRIc4uysY7oAUi5VGkYUsccXhJr4A5pmm8yk9zA4FQ1ydVd7S7+fCvoHU5y1O
	 l+OkqcYpulctvZTPTS7L/bUtrxvOicVQLb1zJDZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/223] test suite: use %zu to print size_t
Date: Wed, 23 Apr 2025 16:41:53 +0200
Message-ID: <20250423142618.801300012@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/shared/linux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/shared/linux.c b/tools/testing/shared/linux.c
index 17263696b5d88..61b3f571f7a70 100644
--- a/tools/testing/shared/linux.c
+++ b/tools/testing/shared/linux.c
@@ -147,7 +147,7 @@ void kmem_cache_free(struct kmem_cache *cachep, void *objp)
 void kmem_cache_free_bulk(struct kmem_cache *cachep, size_t size, void **list)
 {
 	if (kmalloc_verbose)
-		pr_debug("Bulk free %p[0-%lu]\n", list, size - 1);
+		pr_debug("Bulk free %p[0-%zu]\n", list, size - 1);
 
 	pthread_mutex_lock(&cachep->lock);
 	for (int i = 0; i < size; i++)
@@ -165,7 +165,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *cachep, gfp_t gfp, size_t size,
 	size_t i;
 
 	if (kmalloc_verbose)
-		pr_debug("Bulk alloc %lu\n", size);
+		pr_debug("Bulk alloc %zu\n", size);
 
 	pthread_mutex_lock(&cachep->lock);
 	if (cachep->nr_objs >= size) {
-- 
2.39.5



