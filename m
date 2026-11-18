Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019385;
	b=fpdPlHmIwbte1UgYGrF0KkclnSN1vZH342RGm8eJlrayWK0Hq6Ynjw8LJtd3dmtL6UGn
	 wO0NXYrHrHyGYVeeIkuQf/aKDKgHj8N24cSaZNu6gB5zCRzVomDO+o9JIL/DB0qVsWetb
	 Kd9OXyRQPpsPwgU4CoR3B0JMAj+cVlBwS5PstnprU9RbbY2V91rOGNJfsqgC99UayLRD0
	 FBnUsHrtQCjUxj6/hNz8l+VIxjPyh+LVF08I9ZwY+h++Ch9I7EalICuOe75DuSAdpBs9M
	 ZvlQxzUS0WDIpM9j/i+MK7FHxY33LaSpePzAFuK+gJ3HWm5rh1hnNtVsliLaGAWA6Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bwj5DlUQuivYcEOMxOTUmwFpUhZGNzOLSf2l2VxO5Ks=;
	b=KwHIeAMm4LVMariP9cD5XGNxOrOqcH0ewbB2X4nlBQfT6O7UcedeeufgIbC8uZ4HaTXE
	 iuWRL0ajqry+uI2GVYqd45R821OXgI8lGwB1DRXw8hLRzwNBhovPLquVn9Rr41hlM9oAN
	 Baa19ihsT4JL1xM7H7gg3ENot5rj6vR5rjKmOAMRaf06Hyci5KTlEDiL7hhTWD+UIbWoL
	 uj388Mrz+sLSR5OJ+f2jxUGQaUtlE14NDDifYzN9duooAvU77g/S3/kbVT5Z7ybzXB0YC
	 /+IyWE9N9dC99+aPQ99IAhr6SSOQEDR+fKrQltFqEJ+smXwXNHUie/lOCvzkuqSmjgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfe9uwPu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA61660A2602;
	Wed, 18 Nov 2026 16:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cfe9uwPu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D871F000C4;
	Wed, 18 Nov 2026 16:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019385;
	bh=bwj5DlUQuivYcEOMxOTUmwFpUhZGNzOLSf2l2VxO5Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cfe9uwPuriZ/fbME9TV/e3WYSOsKLd0OPh1X9O1Cmilr6ei+zdMSZ3BkBjAiFVoxR
	 Y56LjBAnJ3iG1j9XW20uXL7nv6Qd8n70qPpetlhiNmJsTafyLf36wB47dorBT8zSay
	 lasiaC2cVU6Bo1MVQjfoSSd1YvzE1WGANsnuj0Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 7.3 1570/2651] dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118150344.461079629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c0..a31bd3129f3f4 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -179,6 +179,22 @@ static struct page *dma_direct_alloc_from_pool(struct device *dev, size_t size,
 	return page;
 }
 
+/*
+ * Check if the allocation can skip the kernel mapping and return the page
+ * pointer as the cookie.
+ */
+static bool dma_direct_use_no_mapping(struct device *dev, unsigned long attrs)
+{
+	if ((attrs & (DMA_ATTR_NO_KERNEL_MAPPING | __DMA_ATTR_ALLOC_CC_SHARED)) !=
+	    DMA_ATTR_NO_KERNEL_MAPPING)
+		return false;
+	if (is_swiotlb_for_alloc(dev))
+		return false;
+	if (IS_ENABLED(CONFIG_ARCH_HAS_DMA_ALLOC) && !dev_is_dma_coherent(dev))
+		return false;
+	return true;
+}
+
 static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 		dma_addr_t *dma_handle, gfp_t gfp)
 {
@@ -226,8 +242,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (attrs & DMA_ATTR_NO_WARN)
 		gfp |= __GFP_NOWARN;
 
-	if (((attrs & (DMA_ATTR_NO_KERNEL_MAPPING | __DMA_ATTR_ALLOC_CC_SHARED)) ==
-	     DMA_ATTR_NO_KERNEL_MAPPING) && !is_swiotlb_for_alloc(dev))
+	if (dma_direct_use_no_mapping(dev, attrs))
 		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
 	if (!dev_is_dma_coherent(dev)) {
@@ -374,8 +389,7 @@ void dma_direct_free(struct device *dev, size_t size,
 	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
 		mark_mem_encrypted = true;
 
-	if (((attrs & (DMA_ATTR_NO_KERNEL_MAPPING | __DMA_ATTR_ALLOC_CC_SHARED)) ==
-	     DMA_ATTR_NO_KERNEL_MAPPING) && !is_swiotlb_for_alloc(dev)) {
+	if (dma_direct_use_no_mapping(dev, attrs)) {
 		/* cpu_addr is a struct page cookie, not a kernel address */
 		dma_free_contiguous(dev, cpu_addr, size);
 		return;
-- 
2.53.0



