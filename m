Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622574;
	b=ozRYW9ufRmVvcqaaUx+L9aIWjm5J4jbhcFtRk0bRTlp3NaB5EoHRgJpR1URTeAH8NLYW
	 tCOsMXOPoJnhiQrDaXy4m8LWreEye0OGaQlmoMZbbEcUDPl7Rans8+O4MyVIvQZDzeeKq
	 ZVCZTxpbNOCpXjAlze2VdwxI4KEMdDzx5pqNVnE1G6VewIzm+h8DNJE/RNj+JkBCMFUl3
	 LBAni9z06qgYRcm0JwW0Jx38cbefdLenQ0IouLRxqWd/U4Xdcxink0r0o+PDVK9CmqbDD
	 o1cJyZBvIIDaN+nQRhfySc65d/U5tJP8Qlz1r1ud7scVnTErQS0+2N9IHG98wZc2lTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZYPU09dHAAMsVuvgUVUfJT0ysRNxNPdkI1zWR8WtIzE=;
	b=wfqulxz9V9E1D0vL9UcijPYv/WkWdLWhXMUdShpaNYdUSgRyM/DETh3bcxrtCGmnuEpH
	 tL80OwM9JFP77qKAzfZZxcM+SaGAY7GXS22H6sXjYieV267hGAJyMFV4l0L5R+RDechxC
	 p/7sTkcD2C5ZSnO7VjDYoFmdweOeE5nbJR+R2NLnsSpAHF61UVo/vyvaGNmkVvfPVQ4zn
	 GjPoSE/MBdnJQQeAUNrsXjQGNOBwYV8Tbf2GJTpTczBahVwIOHfMb913l+4f1rlc/m67g
	 Pnl6AMuZ3en72W4WRkJ2glxANdmVn1KEKjPiM+rrzMFuQVhbqG53K8Oi91+2a2OhM2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bigV5T73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45280606A33C;
	Wed, 25 Nov 2026 16:02:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bigV5T73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858741F000CA;
	Wed, 25 Nov 2026 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622574;
	bh=ZYPU09dHAAMsVuvgUVUfJT0ysRNxNPdkI1zWR8WtIzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bigV5T73uT9V3JXjq3dmQ3qAUGg7r8w4gFGxP+R3HXWcZgpexwM/NwBUC5/NeqBDd
	 YOl43b7ycwIa8AEKsBC92MdC5iWsgFsr30t7BUA5O/z1m1qsguWGqiv3M/pn/Q01wu
	 CZ6xrvO6lwTWOXzoTq4X8A/IhlCt6fpNMvjcv7yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Opus 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.18 580/990] dma-direct: Restore arch_dma_alloc() for the DMA_ATTR_NO_KERNEL_MAPPING case
Date: Wed, 25 Nov 2026 15:32:27 +0100
Message-ID: <20261125143835.676370837@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the helper's attribute check to use force_dma_unencrypted() instead of the newer __DMA_ATTR_ALLOC_CC_SHARED flag, which this tree lacks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/direct.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index cc334eb94b33d..11960210266fb 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -181,6 +181,21 @@ static struct page *dma_direct_alloc_from_pool(struct device *dev, size_t size,
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
@@ -210,8 +225,7 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	if (attrs & DMA_ATTR_NO_WARN)
 		gfp |= __GFP_NOWARN;
 
-	if ((attrs & DMA_ATTR_NO_KERNEL_MAPPING) &&
-	    !force_dma_unencrypted(dev) && !is_swiotlb_for_alloc(dev))
+	if (dma_direct_use_no_mapping(dev, attrs))
 		return dma_direct_alloc_no_mapping(dev, size, dma_handle, gfp);
 
 	if (!dev_is_dma_coherent(dev)) {
@@ -314,8 +328,7 @@ void dma_direct_free(struct device *dev, size_t size,
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



