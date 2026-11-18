Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044022;
	b=AkyaoFrM/bt2nZciXcObWFV/f0ojfCQOU31N6Wi+27Kf8ri5+qIeyVx9lQ74Jvy1eHTj
	 vrAKGdP5ev3ski2MCAy0ipcdkt25IUuMroDWG27xd8rm+pw8WU2vF1QeAFy9UDFCEfAEz
	 mxY8CfNOW6hlWijBH7lg311lQNREkcwIP/KDa6xWLy5UHi2nY9tLdKw2uATrzlMnJREhx
	 pZUa76G/j1gzsQVojg5P1xO6DsGwlXKWSZkU1Ugdm97fmL+dhPu/Rkcu4a/SCmuI2niYD
	 EeMhQiBizS3A5TRzw1Hwxn7XljC7XXWohtdsgXeasg4efxZ1xfxQjz4MhdVYwlUS/6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TMgAtUXNjs3cK5LRngDQIFgUOKG6hj9/oS+/ZVPA/dI=;
	b=u2RNd9jNdM/3D++gJE4yvk0xp4mN/mEv4BmUDgPBsbfgcWv56R3X3+3sgLDZEcL21EqN
	 nQHLgPt87aj8MHZT/i1NUfM0TarRMIxIAO/EcZtN2rR2JG2VS8b41ZwohvhWaqPWjwG8/
	 Iz+6FrS4CosQHR5gprFvnj9JTLuhecGpPVWQgU4Iy8CSW8POEEElYDlovujZrgQEa0Uk8
	 Gy8Y0P5co1pXldRZ5iKMc9yUWAAwUrLFqfEcowivzpb4Oxqv9y8TGdjv3+2a8yTnaviX9
	 4JUIcK2wwjO2Ljj4gfQjXO3w7GjArnEG+c2JG06MGYcZ0DAPiuSkGCfLaBfVHN9yxMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTBBf0Wl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66408606A31C;
	Wed, 18 Nov 2026 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTBBf0Wl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2211F000C4;
	Wed, 18 Nov 2026 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044022;
	bh=TMgAtUXNjs3cK5LRngDQIFgUOKG6hj9/oS+/ZVPA/dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTBBf0WlFmYe/1ErL7FlZ4pEgmO9ksZ0mCdWq5b0rG0TpZaMuaM4xX0IIMUFS9mZ6
	 lJLm8k7smnBQ/zl86x4wBRQnRrQooJYfhzdOwSWfduuHOo02PEbLOTYplxQydKl9Bg
	 Ckz6r+HbOMi4rROqigv77ViIEg5EVSeBISagfNmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0412/2857] swiotlb: use the adjusted address for the highmem page lookup
Date: Wed, 18 Nov 2026 15:24:06 +0100
Message-ID: <20261118150216.221134602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
[ sashal: Replaced the missing PhysHighMem(orig_addr) helper with PageHighMem(pfn_to_page(PFN_DOWN(orig_addr))), which tests the same adjusted address. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/swiotlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index b5c8ba23ff625..946366828c7b4 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -556,7 +556,6 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
 	int index = (tlb_addr - mem->start) >> IO_TLB_SHIFT;
 	phys_addr_t orig_addr = mem->slots[index].orig_addr;
 	size_t alloc_size = mem->slots[index].alloc_size;
-	unsigned long pfn = PFN_DOWN(orig_addr);
 	unsigned char *vaddr = mem->vaddr + tlb_addr - mem->start;
 	unsigned int tlb_offset, orig_addr_offset;
 
@@ -590,7 +589,8 @@ static void swiotlb_bounce(struct device *dev, phys_addr_t tlb_addr, size_t size
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



