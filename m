Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214504;
	b=dPe6qoV2bCe3kn5YDwagaSS4Rdg5oCNw3iIs1nn07ZBV2J8xHDE+mtFnKsHftGngXwMI
	 nyHqYJtHPJa20gOdUUX5SYhAaoIwYwTgROacsqcik0c43uwohCLurV6JuH9ydvUCYHP8b
	 90JFuUhYeQ2QjNDhaVyf15qlFvGWUmUqNuDbFUqbyf48mdY9FiH2wy48+kKSF/04KE7uD
	 84atvGNzjLPn3Bp5zNH4EIPy4+UaLEIAY7Eh4Xt84u4RuHQbxD6Vq99LczWzwpyoRY3v0
	 omgINkcrL88SGBbdpPVeLXnF78/nnp4/Bpp3yTQ+lc5Wh3RTeXInTc9LDv2lB3fN4Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdlK4yjxWvyVYzoCUEcB8Ta9k+EhnCaNkPcn2pK5cLI=;
	b=hUXwl/UfsP/AGVH+YXuIhRF/5Yco7gCDQgT4MdIgNMDqFtpCmsUUsY4lJpeufc+b9b8C
	 h86/6gMbcZxBm4rQZPX85Ifp/uwFYhOQ2cbfYQDyAICSee8EwRh/Puwk57uQq+mpy5TN/
	 SE6L1m0UH+AT9qETBtpIZSgnBnmfCE6AaAVCHZANQaHNgLwTC+q0hg9sqaqsYsaew9AXx
	 HwEGfVtFbocP4hog2nEs/EvLvyMuoXVqz9+3FJaQuPqduAgvu2RWER97yrq1U7Em6E8E3
	 BeakDkR1O9NlRU4D+OM5RXJRTzCuJ+qrnARZ76hTqUnAvN9euISwx4MDQDjj7/uaA/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Yqu/bnhX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65517606BF9E;
	Wed, 28 Oct 2026 19:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yqu/bnhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FCD1F031E4;
	Wed, 28 Oct 2026 19:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214504;
	bh=DdlK4yjxWvyVYzoCUEcB8Ta9k+EhnCaNkPcn2pK5cLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yqu/bnhXpn/zMBy1o6D5bsYSQAK4dowAR5ElS1smEXAbX/ghryiF/kGgslLx385yY
	 Kek6xdrcF9c8x71sWE3MreNtJkxLFB36zzPYRVjL9k1hUTO5xdPaJZ1xrlpa+WIRAk
	 lQ1PM9T2jYpujzZnmCE47HOsI2E9QErL58HQy7yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moti Haimovski <moti.haimovski@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0882/1887] accel/habanalabs: support mapping cb with vmalloc-backed coherent memory
Date: Wed, 28 Oct 2026 17:49:38 +0100
Message-ID: <20261028170519.490572051@linuxfoundation.org>
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

From: Moti Haimovski <moti.haimovski@intel.com>

[ Upstream commit 513024d5a0e34fd34247043f1876b6138ca52847 ]

When IOMMU is enabled, dma_alloc_coherent() with GFP_USER may return
addresses from the vmalloc range. If such an address is mapped without
VM_MIXEDMAP, vm_insert_page() will trigger a BUG_ON due to the
VM_PFNMAP restriction.

Fix this by checking for vmalloc addresses and setting VM_MIXEDMAP
in the VMA before mapping. This ensures safe mapping and avoids kernel
crashes. The memory is still driver-allocated and cannot be accessed
directly by userspace.

Signed-off-by: Moti Haimovski  <moti.haimovski@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/habanalabs/gaudi/gaudi.c   | 19 +++++++++++++++++++
 drivers/misc/habanalabs/gaudi2/gaudi2.c |  7 +++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/misc/habanalabs/gaudi/gaudi.c b/drivers/misc/habanalabs/gaudi/gaudi.c
index 92560414e8433..7224a4636b685 100644
--- a/drivers/misc/habanalabs/gaudi/gaudi.c
+++ b/drivers/misc/habanalabs/gaudi/gaudi.c
@@ -4239,10 +4239,29 @@ static int gaudi_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 	vma->vm_flags |= VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 			VM_DONTCOPY | VM_NORESERVE;
 
+#ifdef _HAS_DMA_MMAP_COHERENT
+	/*
+	 * If dma_alloc_coherent() returns a vmalloc address, set VM_MIXEDMAP
+	 * so vm_insert_page() can handle it safely. Without this, the kernel
+	 * may BUG_ON due to VM_PFNMAP.
+	 */
+	if (is_vmalloc_addr(cpu_addr))
+		vm_flags_set(vma, VM_MIXEDMAP);
+
 	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr,
 				(dma_addr - HOST_PHYS_BASE), size);
 	if (rc)
 		dev_err(hdev->dev, "dma_mmap_coherent error %d", rc);
+#else
+
+	rc = remap_pfn_range(vma, vma->vm_start,
+				virt_to_phys(cpu_addr) >> PAGE_SHIFT,
+				size, vma->vm_page_prot);
+	if (rc)
+		dev_err(hdev->dev, "remap_pfn_range error %d", rc);
+
+ #endif
+
 
 	return rc;
 }
diff --git a/drivers/misc/habanalabs/gaudi2/gaudi2.c b/drivers/misc/habanalabs/gaudi2/gaudi2.c
index 65e6cae6100a4..e043f4d2343b2 100644
--- a/drivers/misc/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/misc/habanalabs/gaudi2/gaudi2.c
@@ -5603,6 +5603,13 @@ static int gaudi2_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 			VM_DONTCOPY | VM_NORESERVE;
 
 #ifdef _HAS_DMA_MMAP_COHERENT
+	/*
+	 * If dma_alloc_coherent() returns a vmalloc address, set VM_MIXEDMAP
+	 * so vm_insert_page() can handle it safely. Without this, the kernel
+	 * may BUG_ON due to VM_PFNMAP.
+	 */
+	if (is_vmalloc_addr(cpu_addr))
+		vm_flags_set(vma, VM_MIXEDMAP);
 
 	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr, dma_addr, size);
 	if (rc)
-- 
2.53.0



