Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034062;
	b=wYvdmax5FcqvVvsNAU3m/FnX4ega76RfMVbakmXy07wrMLeFLF0LrwngEUAd3M0rF1jF
	 kGJKohK/VX3LOasLmHyg/GDWw2Y3T2YybmxUJfLrAC4kviKGKc90SbXRQLdiZCb3SmVvN
	 /upNQmWB7mBEKMKuXzKzJ748kCLlh/c/DGajn+FbDpX/9ILuv3ubxsDyqFiVAK6F59zlc
	 QvMoursCD0MNy9KzPdYzm9d7T7B40z1eAt7E85rmGVAedNa6GaDbVmEoI6m1ewr1x8TPk
	 QUTeG+m2P6VE5Ah4+IRe8rqFOq6rbhCQGIqxWNRPeq1PVsz8h3Zz5AMxNQe/LzCsIsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=dq9Z5xgD62HQIWbbtyD88wkUpE9YEjZSSS6eyb9Fcy8=;
	b=LUaHtJIWFzSs+4QAsbex8sVXRSb6AVRGUDWqoQQTwu7s7hXQPreSq9u77Sss2csaLiJ0
	 B0PmMXfr6iC+SSkjt76cqBRIMwRo+ibdk7TdWAx/qdJTOBOBEkoertw7FDC5v8/hvI4sb
	 VguRCO72+lteywNDK8VCuIo4zr/TDiJioi+EWLVeTnD+KHEjDvg/YYKPH1zHwbePC02s2
	 KXX2rSTAZz97kPwx28PTq+i0jJ3Om6b4F69HIlShZlvre2XZH0+mWgzYPVq295NaW5DSs
	 X/OEZ1ZmXTU66duELdsiJJpqm2ssWl/rGNvLmtm9I/0V91jYOBhh59aB3bK9MpnmG9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibhFiDQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE15606A31C;
	Wed, 18 Nov 2026 20:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ibhFiDQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC631F000C4;
	Wed, 18 Nov 2026 20:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034062;
	bh=dq9Z5xgD62HQIWbbtyD88wkUpE9YEjZSSS6eyb9Fcy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ibhFiDQchzHvkHvokugoZ8dQrGyJBKTCiK+CnMiDs+AvfMlqjb6M2Q+mPlXkvILrk
	 5ZH/egsFvLFab2ZbG3+eqTz4ZCmLZ4JLSqkL3Egl1cLXkhLs0IlCCUHBTQFTPY9tZh
	 22+p0ycJci9Rmuvpmk2qx75Qynf1g9SfeFhrVvMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liulhong617 <liulhong617@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0235/3318] arm64: mm: fix accidental linear mapping of no-map reserved memory
Date: Wed, 18 Nov 2026 15:14:17 +0100
Message-ID: <20261118150322.144424740@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c49cf99161881..8aebd59d6cf43 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -609,6 +609,20 @@ static void __init map_mem(pgd_t *pgdp)
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



