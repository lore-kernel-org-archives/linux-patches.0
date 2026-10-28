Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216285;
	b=ejT/c7urE9Yjz1Zxq1TrW8VgPqPg/nHCtiGmLYqZCENiz/Rl+Dz9pmvcohEnexLDphIh
	 WIv9LfpUYAlyrVGANksQdATM6Gimh2aHuP3K8ZAFs1zDply/wwbM+dmyKD+NpxLRT0uOT
	 S90G6+FfUbgZwD2kFi97XG5qLBXpgwu6RxNs9vwV+LifWW1y/SnSfo0HFvvfQhMCXvByW
	 8IIZrfhIT+xeMKE30mDiGtrSn3sgl27pI3VIM5m6cnYMLdQeakTggriphZlWT62FIqL6S
	 FRKjExOD93/RHScBp20mZ1AWty+kK9tXfK0xktV142B5y+z678/y2geMhoI9HJXW0Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216285;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PFMv89eS1L14IyYAI0NFy/3CmSe6F8yWnPktEITgNBw=;
	b=3zyLlTne8ZnWcOoI3iV6/Jyd0KDT1xr+kVgQzHxQxY5Uhb8oN3j1nrjKVtUd569gnKWh
	 Df27HyY0hU/2xOXhq/QKF+pQp/Jjj7wmPRMLVGkWx4ptSbPvFAa+Ygo6ervJMszmlx+kk
	 ygOp39yxLpPi2T9mrpe50dw/olL8Syq70ETDTjOEZ55vqUg5HmW/ynEgBNBPg/JvPpeOU
	 qfPsVv3raFIKzLV5IM0RKh3nqKQUfQ1/VTKc6fs72CTYUeaO+T7r1E2qf8hA7ZD2ZkqZ8
	 Jr624zPYK034kCjesiwgoFRv8hsz6lIri4vN7cBHCo1cs5F4ab2vHE6449uehHYkQIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRCSBklu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5472D606A31F;
	Wed, 28 Oct 2026 19:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tRCSBklu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB2721F01828;
	Wed, 28 Oct 2026 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216285;
	bh=PFMv89eS1L14IyYAI0NFy/3CmSe6F8yWnPktEITgNBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRCSBkluf5MqoEVO6wdeyCknP39lIm9TkccbbBV77t+lrwXML5LtenJHRnmDdiiwT
	 OZdcBjhw5ehtfIZ7sg+JrQe2F1KhRzYlYUIPy7lScsePG/mH8e0A/YDsqZ1WAapEoE
	 pZkbL0c4sGGEbJ7T/Z3MBNm+KF3d17tu11O4t/a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Mostafa Saleh <smostafa@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1503/1887] dma-direct: return struct page from dma_direct_alloc_from_pool()
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028170533.662527583@linuxfoundation.org>
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

From: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>

[ Upstream commit 94a04ad732c9f8b9554270fc4038a06737de5c22 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 621a711224574..88ec1b5cb5060 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -168,22 +168,21 @@ static bool dma_direct_use_pool(struct device *dev, gfp_t gfp)
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
@@ -255,8 +254,11 @@ void *dma_direct_alloc(struct device *dev, size_t size,
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
@@ -367,7 +369,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 	void *ret;
 
 	if (force_dma_unencrypted(dev) && dma_direct_use_pool(dev, gfp))
-		return dma_direct_alloc_from_pool(dev, size, dma_handle, gfp);
+		return dma_direct_alloc_from_pool(dev, size, dma_handle, &ret, gfp);
 
 	page = __dma_direct_alloc_pages(dev, size, gfp, false);
 	if (!page)
-- 
2.53.0



