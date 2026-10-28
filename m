Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216280;
	b=S34pWNA+ScjbMvVIneYrqFNJSVsm/pYrkvEBGyFRsQSmFwfxbfYjuhwjyr+mLgbIgj+w
	 sd5kJrgiV/O9WmE3hNI87MG387XiQEn8rqU42SAqvfeqpz0GZT4nVX3fObDBbmv6lyFJP
	 wgh/eOFQRJl38xh/On1YV0zL2nqMhA7BHMRoOhQr3Vcu0z0XyIYlTsTfU7nY24jz5CRI8
	 HqZhcHixqrGtZmZJDz6feflXZQKFJyunOlhGDFoSiGemmcACl73w2ehwjufZ31mdoa1+s
	 Ec92hP8BlIFoDk28BSjyb0CQtXQNHvvmiLHSOtKSxmbRRmKSl8xBedv0bpCRr/numdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=79me9rlSnnEjFjgEQ8GtdXAPEtg6rSZcDw2NFMk/YiQ=;
	b=L6xb73vcCrJrepOGsgp1UjQRQqpW93b68heMg5x8QJVeGEh1rCysxrXhnS1HHTEwTPTJ
	 iyBzoiRSq+aw2KjRFz3b1koWWoSrOw6KhnxX6C5GspGBijmwy50yewiabh3DiZ0szp+ks
	 S5pWDio8ATxaW1eR/Wf8yzw6ofrDUsJoZ3ZkQdxC93uc1TYNNs0L0Lakhz2lxZYWxjFXD
	 qAdaQCyPCb0t7wEVmPMKLOIxkH/dNeJHFmFYcpdQZIRqShKl8IQ+EXrrGUcGytFcYe+GH
	 DBDBQGNf/Oa66IheLMLGeos07hPPl4I4NBgcK9ZJ38dVj58hbxM7r56+YYXEreq7GNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WACAQuey;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B050B606A31C;
	Wed, 28 Oct 2026 19:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WACAQuey
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC331F01825;
	Wed, 28 Oct 2026 19:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216279;
	bh=79me9rlSnnEjFjgEQ8GtdXAPEtg6rSZcDw2NFMk/YiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WACAQueyVg4mCfTQO16CbFb/7U59CZw/O1bXfXyDHNzfASN76ojgqxrbfv5vxbWmn
	 gecrtykDQ8NoxyggF9xWjvnr2rbR+n5HKcxRWTMHHq+2/IkBjqozPXV5Tq9vgjDnqC
	 Ca3grIHgnm6ZDdevAbWb68Fz/7vwMTzEShcffmAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Tesarik <petrtesarik@huaweicloud.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1501/1887] dma-direct: cleanup parameters to dma_direct_optimal_gfp_mask
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028170533.616099470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Tesarik <petrtesarik@huaweicloud.com>

[ Upstream commit 25a4ce564921db0973b74c04e0ea23bd2ee12a3a ]

Since both callers of dma_direct_optimal_gfp_mask() pass
dev->coherent_dma_mask as the second argument, it is better to
remove that parameter altogether.

Not only is reducing number of parameters good for readability, but
the new function signature is also more logical: The optimal flags
depend only on data contained in struct device.

While touching this code, let's also rename phys_mask to phys_limit
in dma_direct_alloc_from_pool(), because it is indeed a limit.

Signed-off-by: Petr Tesarik <petrtesarik@huaweicloud.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 94a04ad732c9 ("dma-direct: return struct page from dma_direct_alloc_from_pool()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index d4215739efc71..d6871a3fe5f6a 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -44,10 +44,11 @@ u64 dma_direct_get_required_mask(struct device *dev)
 	return (1ULL << (fls64(max_dma) - 1)) * 2 - 1;
 }
 
-static gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 dma_mask,
-				  u64 *phys_limit)
+static gfp_t dma_direct_optimal_gfp_mask(struct device *dev, u64 *phys_limit)
 {
-	u64 dma_limit = min_not_zero(dma_mask, dev->bus_dma_limit);
+	u64 dma_limit = min_not_zero(
+		dev->coherent_dma_mask,
+		dev->bus_dma_limit);
 
 	/*
 	 * Optimistically try the zone that the physical address mask falls
@@ -126,8 +127,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	if (is_swiotlb_for_alloc(dev))
 		return dma_direct_alloc_swiotlb(dev, size);
 
-	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
-					   &phys_limit);
+	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
 	page = dma_alloc_contiguous(dev, size, gfp);
 	if (page) {
 		if (!dma_coherent_ok(dev, page_to_phys(page), size) ||
@@ -172,14 +172,13 @@ static void *dma_direct_alloc_from_pool(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
 	struct page *page;
-	u64 phys_mask;
+	u64 phys_limit;
 	void *ret;
 
 	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_DMA_COHERENT_POOL)))
 		return NULL;
 
-	gfp |= dma_direct_optimal_gfp_mask(dev, dev->coherent_dma_mask,
-					   &phys_mask);
+	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
 	page = dma_alloc_from_pool(dev, size, &ret, gfp, dma_coherent_ok);
 	if (!page)
 		return NULL;
-- 
2.53.0



