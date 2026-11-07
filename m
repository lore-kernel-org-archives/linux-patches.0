Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060908;
	b=LCxZ6BMiFEisSq+y9nSTxUW1NKOOq0IURQ/g8895ZcD2rS0pj9nVEOcAexoMIbbNnMmW
	 dj9Q2AOG7/5X4HqlpWrp6/iDHTqSyiNgbHuquIYKfqD0KRwqIDQBUQQqF9UT0qCzKi4TA
	 aQwl5BbQC4jwOmv9rjnhGi681YPrFgnh2nGde3NXixEqHPBrirs82LYALxinWpfKI22qp
	 x4g+804rUcmB+SInduz4WASSKwaQ28MPIpgY+/IvCy44VAXaiHcB0vFll22BfcoOrHcoP
	 SsjFL7LO945fGG78TfDeMrNa8ogaNt+K1JKRdvo5+oMC8wPo9tRH3hOJnYgzIyZ86ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ofyh/uCZjHWBgSeoQQdbm5Z9McxgrBFuXoHtCpEhJYU=;
	b=jXvrq4xRIQL6C80TU8gavHpNoa6ZBnBgLqIDYEhfcZBfNsRoeNN/BTIckxOHTq+hpyQZ
	 bWZyZyo16MoEkr+NNhoI4VJe0U7LsY4APe91jFot9UuJaMG14uZ9rrduPWJ4/iKukIh2c
	 Fmtn5fJV8cEaVNiVjeeA5MA+6GEQaWiqsYsATO2rKSHM2o/T0eb6j5R9OewjRR+N/xzuc
	 j+ESGMLPpXgRLUgj+vYxVohzRp4wBEHl9RmxC6TH0q+nTLYhQuKszq+XUNgp18SXL25Id
	 JbTtZAWKdP6/XyWsbRuOM9fjGwK8CNwI8G/v8DjzNkUvPWCU/Q47Pca3EWpmi3vdQ7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFYK2RlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFBB606D80A;
	Sat,  7 Nov 2026 14:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QFYK2RlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18AD01F0089F;
	Sat,  7 Nov 2026 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060908;
	bh=ofyh/uCZjHWBgSeoQQdbm5Z9McxgrBFuXoHtCpEhJYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFYK2RlKnXeexADtawxh12AcZAi12F8hMPO4qN+ZNBAj2vBFutfweTFUF5hqi/Okt
	 Ozvyn4s3fHntqnEUIhuvCnzZNL4YWa3UnXuOXIK42D728V6CCGLqS0mgwIaFIYeXBp
	 9UAFA5IVeyoXtSlgYYU4gTm77l8gkH6N3siuaGQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liulhong617 <liulhong617@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0278/1536] arm64: mm: fix accidental linear mapping of no-map reserved memory
Date: Sat,  7 Nov 2026 08:38:14 -0500
Message-ID: <20261107135005.475669596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liulhong617 <liulhong617@gmail.com>

[ Upstream commit 7ace06a01efaba1ec585630aa4c98ac39b38452a ]

When reserved-memory regions with the "no-map" property are not
page-aligned, the kernel may accidentally map them into the linear
mapping, contradicting the no-map semantics.

The root cause is a mismatch between /proc/iomem's address boundaries
and the actual page table mapping boundaries:

1. /proc/iomem derives its ranges from memblock via
   memblock_region_reserved_base_pfn/memblock_region_reserved_end_pfn,
   which perform PFN rounding so the displayed boundaries are
   page-aligned. This gives the impression that the no-map region
   occupies whole pages.

2. However, memblock_mark_nomap() splits memblock.memory regions at
   exact byte boundaries (memblock_isolate_range preserves raw DT
   base/size with no alignment). When for_each_mem_range iterates the
   non-NOMAP regions adjacent to a no-map region, it returns start/end
   values that are NOT page-aligned — they are the precise byte
   boundaries from the memblock split.

3. These sub-page-aligned values are passed to
   __create_pgd_mapping_locked(), which does:
     phys &= PAGE_MASK;
     addr = virt & PAGE_MASK;
     end = PAGE_ALIGN(virt + size);
   The downward rounding of phys via PAGE_MASK extends the mapped
   range backward into the adjacent no-map region, effectively
   including no-map memory in the linear mapping.

For example, with 64K pages, reserved_region@A2000000 (base=0xA2000000,
size=0x8000, no-map) causes for_each_mem_range to return
start=0xA2008000 for the next mappable region. After phys &= PAGE_MASK,
the actual mapping starts at 0xA2000000 — the entire no-map region is
incorrectly mapped.

Fix this by rounding the mappable range inward to PAGE_SIZE boundaries
before passing it to __map_memblock: start is rounded UP and end is
rounded DOWN. This ensures the mapped area never overlaps with adjacent
no-map regions. The cost is at most one page of unmapped gap at each
boundary, which is preferable to violating no-map semantics.

Signed-off-by: liulhong617 <liulhong617@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/mmu.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index c29d16284fe81..78032c19a1f13 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -660,6 +660,20 @@ static void __init map_mem(pgd_t *pgdp)
 	for_each_mem_range(i, &start, &end) {
 		if (start >= end)
 			break;
+		/*
+		 * for_each_mem_range may return sub-page-aligned boundaries
+		 * after memblock_mark_nomap() splits regions at byte precision.
+		 * __create_pgd_mapping_locked aligns phys down to PAGE_MASK,
+		 * which could accidentally map no-map memory on the boundary.
+		 * Round the mappable range inward: start UP, end DOWN, so
+		 * that the mapped area never overlaps with adjacent no-map
+		 * regions. The cost is at most one page of unmapped gap at
+		 * each boundary.
+		 */
+		start = PAGE_ALIGN(start);
+		end = end & PAGE_MASK;
+		if (start >= end)
+			continue;
 		/*
 		 * The linear map must allow allocation tags reading/writing
 		 * if MTE is present. Otherwise, it has the same attributes as
-- 
2.53.0



