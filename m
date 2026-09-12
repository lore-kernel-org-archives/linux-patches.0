Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B703F788A;
	Sat, 12 Sep 2026 11:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213118; cv=none; b=LKkNJWvSBd7O6vkAbOrCErlaUaXpiM/3AVsA4irB07xiPs3ryMXvK8RCn4cQWDYHUX2mUvnu/wrfPkgVc7Cv1fr7SctX2nNLp40AtwkcYkbE8MO67sSShyNJq1GjJhegIKuCxb1htu9KjyZnRCqtui/+x16ZHHtoHn1O4Wtt/JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213118; c=relaxed/simple;
	bh=iQeSGJePbw21f1LWHidsxHUsfzKl9/9X2vFLksjmBss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ea2ikk3mYoQrDijCRRukKZZz4TPhevIK2WxqzMCgGn/mwf+sqWK6oBE99oI/Fs5wwtV65T9pBZMw50vVmIFArL5vNDg1dgDKzInEQ5kO12LhtBA8KY3sVTT1wCE/SkpWa/v65vqWT8OqFb1QgatjBb5PeeWgUNxr/WIhY2BVgPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eqX3eqJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eqX3eqJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3671F000FF;
	Sat, 12 Sep 2026 11:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213117;
	bh=A7v/G3RGy4+4BmBw3monZd/ud0JWJ25ixsPvTcmu+IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eqX3eqJUCZ/bN/t4GMjb98f5swWIw0Ojx7jpixUJodCgCaOgM2DSHZnSzMBj/daLW
	 OqGYJdxpWIQcHfbAuZjY1ZuDkV338Y9W8RCOKZd6u2JxWK9bZQ8rj+Uaj/rMkTFbud
	 zYtgXu5+A6vSfxUmYIO/9U2qj9wLhatL3r3bsONw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.12 0057/1376] dma-direct: return struct page from dma_direct_alloc_from_pool()
Date: Sat, 12 Sep 2026 08:41:23 +0200
Message-ID: <20260912065608.829045618@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

commit 94a04ad732c9f8b9554270fc4038a06737de5c22 upstream.

Commit 5b138c534fda ("dma-direct: factor out a dma_direct_alloc_from_pool
helper") changed dma_direct_alloc_from_pool() to return the CPU address
from dma_alloc_from_pool(). That fits dma_direct_alloc(), but
dma_direct_alloc_pages() also uses the helper and expects a struct page *.

Fix this by making dma_direct_alloc_from_pool() return the struct page *
again, and pass the CPU address back through an out-parameter for the
dma_direct_alloc() caller.

Fixes: 5b138c534fda ("dma-direct: factor out a dma_direct_alloc_from_pool helper")
Cc: stable@vger.kernel.org
Tested-by: Michael Kelley <mhklinux@outlook.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Link: https://lore.kernel.org/r/20260717180442.110954-2-aneesh.kumar@kernel.org
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/dma/direct.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -168,22 +168,21 @@ static bool dma_direct_use_pool(struct d
 	return !gfpflags_allow_blocking(gfp) && !is_swiotlb_for_alloc(dev);
 }
 
-static void *dma_direct_alloc_from_pool(struct device *dev, size_t size,
-		dma_addr_t *dma_handle, gfp_t gfp)
+static struct page *dma_direct_alloc_from_pool(struct device *dev, size_t size,
+		dma_addr_t *dma_handle, void **cpu_addr, gfp_t gfp)
 {
 	struct page *page;
 	u64 phys_limit;
-	void *ret;
 
 	if (WARN_ON_ONCE(!IS_ENABLED(CONFIG_DMA_COHERENT_POOL)))
 		return NULL;
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_from_pool(dev, size, &ret, gfp, dma_coherent_ok);
+	page = dma_alloc_from_pool(dev, size, cpu_addr, gfp, dma_coherent_ok);
 	if (!page)
 		return NULL;
 	*dma_handle = phys_to_dma_direct(dev, page_to_phys(page));
-	return ret;
+	return page;
 }
 
 static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
@@ -251,8 +250,11 @@ void *dma_direct_alloc(struct device *de
 	 * the atomic pools instead if we aren't allowed block.
 	 */
 	if ((remap || force_dma_unencrypted(dev)) &&
-	    dma_direct_use_pool(dev, gfp))
-		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
+	    dma_direct_use_pool(dev, gfp)) {
+		page = dma_direct_alloc_from_pool(dev, size, dma_handle,
+						  &ret, gfp);
+		return page ? ret : NULL;
+	}
 
 	/* we always manually zero the memory once we are done */
 	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
@@ -361,7 +363,7 @@ struct page *dma_direct_alloc_pages(stru
 	void *ret;
 
 	if (force_dma_unencrypted(dev) && dma_direct_use_pool(dev, gfp))
-		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
+		return dma_direct_alloc_from_pool(dev, size, dma_handle, &ret, gfp);
 
 	page = __dma_direct_alloc_pages(dev, size, gfp, false);
 	if (!page)


