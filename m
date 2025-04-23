Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B348128B4F4;
	Wed, 23 Apr 2025 15:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421839; cv=none; b=px6l85k63qn1p2YzAR8rvR+Wf/C0nDW87+22bWRpda5OlN4i0v3k9xtisV0XXUKtLqy1UAmbljUFXDeM1NMtGU1T0ADwlcvMKLHoVjnqe3144K4J+J9fwFVHWZMNjJY2SwRH5SiNWGZXSBgZIgNz8olUoN9FdFTLIFW3QG1Sntw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421839; c=relaxed/simple;
	bh=9z7vzb3ByT3Zt7OnlXRfBB9niJSHcIHDDg7+v8PlEIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETsaO8KmJHcCnseYzF4PKtPAgjth/JTZf70KyoRKAVQUXM420U8zXZf9VcXx7YfUo5JF5mXJ5SjzURURFMmmuD0EOo7FhzEp70BDFWyDEsZS0Y5uJ1W7QCQQZfw5wslNDYHONA1CH0cmwT4tO+drUAFjDOtLFDcLKX2sD3fwvV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Liu7+qz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Liu7+qz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B0EC4CEE2;
	Wed, 23 Apr 2025 15:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421839;
	bh=9z7vzb3ByT3Zt7OnlXRfBB9niJSHcIHDDg7+v8PlEIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Liu7+qz+QD0Di9tfKugX4/FcbodtDlKHf7AzTCqHUQDP20lcbauBwOQQc08WDHmaj
	 yi3tZYDuuywL9ZPJZq5rcQUGpBGhMCcBOmTIbmNqJsrKhdvXj7SFNzD58vTir+Xy2C
	 v0Mshev2+So+zOFj9AFtRHhNzu3zAlOzhzcMbbqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/291] test suite: use %zu to print size_t
Date: Wed, 23 Apr 2025 16:42:53 +0200
Message-ID: <20250423142631.899032496@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



