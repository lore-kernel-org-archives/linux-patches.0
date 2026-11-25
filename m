Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625310;
	b=xXnDDDAv5swauY6yrz1rpq28auGqcTf+su+WqHaZc8nY6ud8rMS0haaLrHN/ekJzQhxx
	 Hh11VeHmGPjCbgrJPpJ+UCcf8892pzGV0ogjzXCqWy8I9xvkDlNNEDMrU/1vkhINXdKbp
	 KE8WlETuDD/+VHXHRWMHydXaOImmL6CZaaQ5ybU0NaPRqw1fSmkEFqUV+bamY+UTDAw6l
	 BBswD8G1InA8ZaOv70BggYsZ9ixcuuzL4Qdsfh2OKHX+kab+t9QyHVa9ZKXf9j8H+zfRq
	 f/4xXjDqdENPU3hUR2hOzDuLZ3Wga9p5uul1I+TYfQA4ediK56Yzt3a6kgQEwiFpQjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ZfUpjEUcJFdLDsFcWusjeXMCpCs6u5DMTPwTTu5y+8=;
	b=vWeHQkHimlLCuwc4EiLOBomPYNxqtelbsbdVCR6JBTHGInQZonPAUSh0u/VyJedc2Ql5
	 Jr/QxPb37/c9iczUaTFFoF7eEF+oyhFWsQLv+pL1FYVUkXikpWY1lMqmSCYDuT6VJWvlv
	 80JryvVhXBOrokY2vpwo2bqsuHrq5/DPuSWjzWJurj5eqqWiX+fwTS2u+12AttKM2EX9/
	 FbRVjkdfemlS2aHVkesFFCFODpALALfRP0V7Ah4t6v7m2yw3G7VLJo8oqH6EbVWRnYc9R
	 5Lv5G7Ip6DARgZZQh0EWfZ12JutRZXMGRl/k5Tyo2qFTQkaK59amX3scmWmjzEutiaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPXalsOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0816606A31E;
	Wed, 25 Nov 2026 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPXalsOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 102051F000CF;
	Wed, 25 Nov 2026 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625309;
	bh=4ZfUpjEUcJFdLDsFcWusjeXMCpCs6u5DMTPwTTu5y+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPXalsOolk3DzfSoOLdKehq6DWmUK4kuZIXmJvHAmU25Ejyi45+45yNXpGkCB8w+i
	 LRPFaWXkIyLREGReUwP9l01USncrSdL5CPZhUJimZi6JxtkBIydRFAk1AUz8BoC9V5
	 hzofAzfg8h8C27nv2aHxjbl+hmxhhQEx5eWsWwRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.12 475/816] dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case
Date: Wed, 25 Nov 2026 15:33:43 +0100
Message-ID: <20261125143900.195180496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit 5e3bc6b44c8853bcc7782eac122c5baf2d02f399 ]

Commit 849facea92fa ("dma-direct: simplify the DMA_ATTR_NO_KERNEL_MAPPING
handling") moved the DMA_ATTR_NO_KERNEL_MAPPING shortcut in
dma_direct_alloc() in front of the arch_dma_alloc() call. Architectures
providing their own DMA coherent allocator (CONFIG_ARCH_HAS_DMA_ALLOC)
therefore no longer see such requests. ARM 32bit is one of such. Lack of
the call to arch_dma_alloc() results in the lack of proper cache
management on HighMem pages.

Take the dma-direct shortcut only for coherent devices or when the
architecture doesn't provide arch_dma_alloc(). While touching this,
move that check into separate function to avoid duplication in alloc
and free paths.

Fixes: 849facea92fa ("dma-direct: simplify the DMA_ATTR_NO_KERNEL_MAPPING handling")
Reported-by: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
Closes: https://lore.kernel.org/all/yq5ams2akznl.fsf@kernel.org/
Assisted-by: Claude Opus 5.5 <noreply@anthropic.com>
Link: https://lore.kernel.org/r/20260930135734.1013905-1-m.szyprowski@samsung.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[ sashal: Replaced the upstream __DMA_ATTR_ALLOC_CC_SHARED check with the existing force_dma_unencrypted(dev) test in the new dma_direct_use_no_mapping() helper, since that attribute doesn't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index c8bba1b6f59c2..8abca2804435a 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -185,6 +185,21 @@ static struct page *dma_direct_alloc_from_pool(struct device *dev, size_t size,
 	return page;
 }
 
+/*
+ * Check if the allocation can skip the kernel mapping and return the page
+ * pointer as the cookie.
+ */
+static bool dma_direct_use_no_mapping(struct device *dev, unsigned long attrs)
+{
+	if (!(attrs & DMA_ATTR_NO_KERNEL_MAPPING))
+		return false;
+	if (force_dma_unencrypted(dev) || is_swiotlb_for_alloc(dev))
+		return false;
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) && !dev_is_dma_coherent(dev))
+		return false;
+	return true;
+}
+
 static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
@@ -214,8 +229,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (attrs & DMA_ATTR_NO_WARN)
 		gfp |= __GFP_NOWARN;
 
-	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
-	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
+	if (dma_direct_use_no_mapping(dev, attrs))
 		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
 	if (!dev_is_dma_coherent(dev)) {
@@ -318,8 +332,7 @@ void dma_direct_free(struct device *dev, size_t size,
 {
 	unsigned int page_order = get_order(size);
 
-	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
-	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev)) {
+	if (dma_direct_use_no_mapping(dev, attrs)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
 		dma_free_contiguous(dev, cpu_addr, size);
 		return;
-- 
2.53.0



