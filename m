Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034705;
	b=sCeEu6kt4UukVUpI1AUFmKM0fk1VqEjq4KvFoMkhZDvNxoTOUzILfnA+y55YI04EunZx
	 LfL2hPJ84vYbmexLw2tUtj4rySFVJIXCEyxyWCFPOrR9SUNnkaDFpI7KnL5PuWdeYpXyU
	 iif83Ja8W67Cm2lr5VJk7u8ku4vjd2/mjajqliG2vjY+6O6lOXm0utYHzRSoVZC0jbUMX
	 9tcSJXAfl00JG+9kReTfhAYchjkgw2llcUzrUsg9g+Tv+96cPdR8CakqnVWr6MQqdM6+6
	 4Filt9mwNSsGJpzGzpjDIfvPNSVzOsbsqvlyY7b2JnhFBYVsksh2fUXR2UruZnAZmwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKcSKWZ4MMzVgNxfZiCgXHT9ZVzW72w93VWiOSDYNnA=;
	b=y9YPJG1JU6YBE0OpmeZEIN5UKPCFT32nqjYJim92TZS0qQdUkanpwERJzwC0HDsmM1oI
	 sT/i5E1ZSPyUfFAictnoBHfGU10NbdgeQavd7t4NnUpwaGyhdJQmZG/H2vniucHlSkIxP
	 jUW3tej04zflg3qVxGjzbw2T5WVwol9A3XHOV2d/7NOjb1RQU+t4gb+rGdbNuqL/HdFvz
	 JP+ek0ebiPp7gkzc4zsGg93muk3jPmGul3NMsHyutZ3NIGUMEEVXs2XiNXe1IeV5GvPmh
	 ut+dkttLtI4o27MS4tbXhBa74bmDWuOGHB4z8oXRa04C7kP6+E+m5pPvCJYVg2jAiuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heEBpZ0m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D413606A325;
	Wed, 18 Nov 2026 20:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=heEBpZ0m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D397F1F000C4;
	Wed, 18 Nov 2026 20:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034705;
	bh=tKcSKWZ4MMzVgNxfZiCgXHT9ZVzW72w93VWiOSDYNnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=heEBpZ0mWQEADQFO0XYyUu6iXyhbYYcbrFT3E77z7AowJJVhc5izlAReBTip5aEHI
	 1EP9xNgSDeDTMs/jzb4NxMep+O6eJOQERj5jCRdPpKKrBnh+jkL9QS1WWYrTsj4A+1
	 hB6GDHYFfERPCWfnyOYMEQO0cnL6oWWSsTmzXUDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0463/3318] swiotlb: use the adjusted address for the highmem page lookup
Date: Wed, 18 Nov 2026 15:18:05 +0100
Message-ID: <20261118150330.731665248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit b7d7914a9ae3097e63d113007e4fb44d33d515b1 ]

swiotlb_bounce() reads the page frame number from the slot's recorded
orig_addr, then advances orig_addr by tlb_offset to reach the address
the caller asked about. The highmem branch mixes the two: the offset
within the page comes from the adjusted address, the page from the value
before it.

Once the adjustment crosses a page boundary the pair no longer describes
one location, and the whole copy lands one page below the intended one
for a positive tlb_offset, one above for a negative one. DMA_FROM_DEVICE
writes the device data over the wrong page and leaves the intended one
stale, DMA_TO_DEVICE feeds the device from a page the mapping may not
cover. Partial syncs through dma_sync_single_range_for_*() are what make
tlb_offset non-zero.

The branch test is picked the same way, so a slot recorded in lowmem can
be adjusted into highmem and the lowmem path then hands a highmem
address to phys_to_virt().

Take both from orig_addr once it is final and keep pfn in the branch
that uses it. PhysHighMem() asks the question straight from the address,
as dma-debug already does.

Fixes: 5f89468e2f06 ("swiotlb: manipulate orig_addr when tlb_addr has offset")
Cc: stable@vger.kernel.org
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Link: https://lore.kernel.org/r/20260905084210.148255-1-donggeunyoo.kernel@gmail.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
[ sashal: Replaced the unavailable PhysHighMem(orig_addr) with PageHighMem(pfn_to_page(PFN_DOWN(orig_addr))) in swiotlb_bounce(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 669fd550338db..746bf1d8f9d9f 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -868,7 +868,6 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
-	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset, orig_addr_offset;
 
@@ -902,7 +901,8 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 		size = alloc_size;
 	}
 
-	if (PageHighMem(pfn_to_page(pfn))) {
+	if (PageHighMem(pfn_to_page(PFN_DOWN(orig_addr)))) {
+		unsigned long pfn = PFN_DOWN(orig_addr);
 		unsigned int offset = orig_addr & ~PAGE_MASK;
 		struct page *page;
 		unsigned int sz = 0;
-- 
2.53.0



