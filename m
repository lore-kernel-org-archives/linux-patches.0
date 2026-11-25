Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617703;
	b=NvpMLBKXh9j8HJUW7tos/LuveqbINAtg8QUkPghwLSC9k7lnAiMaDFWHWLk03KQly8Kr
	 Z5AZX/WWF0ziBNW4fLSLK14LJ8lVRqWk8VE10jitmXpDrqTSwlHuM5wuoIx06ENmOJvzF
	 2/Xt4vutCP570npfDsi2TEPqxQMEGEtKZEvYvR0GeDknE4is/WWSgaA5HioivPlP638+C
	 JaAXxMr9gxXqPZlFFHqdXBk3Zar4ITenmMHspIIA32I7haLe67bqw6RYFyDVUvB6XyMDC
	 e70YpsAks6W/tkPa9mOtOcsuagnoVOo4EHhzijOmtDqDByLLRPKDC6YEvm13f1F5qVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VjfWFWnjNxwSxIV4FCLbKPHjAPcVil8FGreR/3XYAW0=;
	b=jD2ozSqbOP6whno+/0IhOkN4iVsIEx5FpUsk9e1OC60eL3VVShzucBaTU4hizmJPJYpV
	 qi462NnSqDnbGthW2oOua2nRemRYuXqgn7ockCkCCGdqhCnuE4Sz0qMzylltu6sRxvmZi
	 3HE8rWLuHsUw4gsa7m7mmm7ZkdHBexf+CDCrTt2AbEofy0oFQL0lSrigT4V6fzLiKHFj9
	 WSaW2WeKDrJD99UuqrDSzcfD1KFIU4dbvH46RRbDgSHKWGqdkWLIlCNeucKWTVETQTqM7
	 AUz7StSTk41YTdyRtjf0wApPUZjQvqeCVd1nnsm4xhMthW1m3lp4IS8DWyC5a08LU8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1Un8/M/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3B61606A31E;
	Wed, 25 Nov 2026 14:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Un8/M/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AE61F000C0;
	Wed, 25 Nov 2026 14:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617703;
	bh=VjfWFWnjNxwSxIV4FCLbKPHjAPcVil8FGreR/3XYAW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Un8/M/Bf+gbTGZJlQ3LjJM1Wt3vXHaNhPmYksNl9eAxgdSGa+OnUxLPFgytPuDvD
	 LBWtlw/wizLLhQ3rIHHVL8N+VvHRgFdaIvt0ee+ausHb8K2DyN7CrA+aTMQHVmpiMB
	 QKy0rMeIikwUnZcD7qJV9ZHZahf9vjCxINJvBqlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0048/1005] dma-buf: Restore the scatterlist entry count before freeing
Date: Wed, 25 Nov 2026 15:23:06 +0100
Message-ID: <20261125143822.866000259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 052947a3b5e7402eaad53379dfec2ecab27a2d80 ]

dma_buf_phys_vec_to_sgt() clears orig_nents to mark the returned table
as DMA-only. Since sg_free_table() uses orig_nents to walk and free the
scatterlist, dma_buf_free_sgt() leaks the allocation on every successful
map/unmap cycle.

Restore orig_nents from nents before freeing the table. The helper
allocates the DMA list directly, so nents retains the allocation count,
including for chained scatterlists.

The reported kmemleak output was:

KMEMLEAK LEAK: 2 driver-related leak(s)
KMEMLEAK LEAK: unreferenced object 0xff11000125ceff00 (size 32):
KMEMLEAK LEAK:   comm dtr, pid 4432, jiffies 4295031027
KMEMLEAK LEAK:   hex dump (first 32 bytes):
KMEMLEAK LEAK:     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
KMEMLEAK LEAK:     00 00 01 00 28 38 00 00 00 10 00 00 00 00 00 00  ....(8..........
KMEMLEAK LEAK:   backtrace (crc 4e8077f2):
KMEMLEAK LEAK:     __kmalloc_noprof+0x451/0x8b0
KMEMLEAK LEAK:     __sg_alloc_table+0x2a0/0x4d0
KMEMLEAK LEAK:     sg_alloc_table+0x24/0x170
KMEMLEAK LEAK:     dma_buf_phys_vec_to_sgt+0x84f/0xed0
KMEMLEAK LEAK:     0xffffffffa1ad21a8
KMEMLEAK LEAK:     dma_buf_map_attachment+0x138/0x690
KMEMLEAK LEAK:     ib_umem_dmabuf_map_pages+0x249/0xc90 [ib_core]
KMEMLEAK LEAK:     0xffffffffa138f8d2
KMEMLEAK LEAK:     0xffffffffa1396abe
KMEMLEAK LEAK:     0xffffffffa1331a5f
KMEMLEAK LEAK:     0xffffffffa13320dd
KMEMLEAK LEAK:     0xffffffffa1ad696d
KMEMLEAK LEAK:     0xffffffffa1acecc7
KMEMLEAK LEAK:     0xffffffffa1acfd17
KMEMLEAK LEAK:     __x64_sys_ioctl+0x72c/0x11f0
KMEMLEAK LEAK:     do_syscall_64+0xa1/0x4f0
KMEMLEAK LEAK: unreferenced object 0xff1100016dbf3a80 (size 32):
KMEMLEAK LEAK:   comm dtr, pid 4432, jiffies 4295034705
KMEMLEAK LEAK:   hex dump (first 32 bytes):
KMEMLEAK LEAK:     02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
KMEMLEAK LEAK:     00 20 10 00 28 38 00 00 00 10 00 00 00 00 00 00  . ..(8..........

Fixes: 3aa31a8bb11e ("dma-buf: provide phys_vec to scatter-gather mapping routine")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20261013-dma-buf-fixes-v1-1-0e2d9ca41f3a@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/dma-buf-mapping.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma-buf/dma-buf-mapping.c b/drivers/dma-buf/dma-buf-mapping.c
index ef0f22854d018..e1e9c93127b51 100644
--- a/drivers/dma-buf/dma-buf-mapping.c
+++ b/drivers/dma-buf/dma-buf-mapping.c
@@ -251,6 +251,8 @@ void dma_buf_free_sgt(struct dma_buf_attachment *attach, struct sg_table *sgt,
 				       sg_dma_len(sgl), dir, DMA_ATTR_MMIO);
 	}
 
+	/* Restore the allocation count cleared for the DMA-only table. */
+	sgt->orig_nents = sgt->nents;
 	sg_free_table(sgt);
 	kfree(dma->state);
 	kfree(dma);
-- 
2.53.0



