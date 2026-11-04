Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830814;
	b=QvhLUI/IsD3esb/27kPYcAAH5Uteq5E9g7JXZ4EphmbuxzUn9Rvx1OoqJ3RYgX2Fqi6R
	 R4O+7TOGsshn840wFaPggThkCXVoJocdqo2N81/WgsdiUd2L75hqHcGiqci9RN4jgnan8
	 dKBBiFgI8oOEweoKjkAI0ip0TP7sI81M7enmTEbnshRnALscwi0DeZHUckmswn4eeg1Cn
	 YkPfzUXhwItidc7Mk4y/XY/d2LGGGAayYVAK8o9JbjBHlE23g62F/ePdd8JTQP4tcWz2v
	 HE1+YnBt944iBvtbTahIa6A1FAtP+aGxQ8qzaWqhtjFwR4+WsE+p01MNgFXi4EE0+IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NoN3bXycRLhkZSLrpLe8vYWDl9epBw54oJekyO2sIoY=;
	b=O23K+o92McT+OFK7cjPjJ/a390tw6CDCbg0sbcJHD8oOir6HpLf0M1j8XwXWMsW7JpnI
	 xCJK5tB7MR9JQ6j8U3WwXz6QmavCT5pt1t8dvydlbbBeiIhjrLjH/x5KEtHEafRqd8iim
	 NOM6Fy90Pl5BOjhPZTuR2W8DQtsRwVEAO1Gcf5k9YoVqFic+SSXukFLFN/fgyM4WzA3oR
	 flEjyZLQbNXjFGl4KtoHjsRBl7olhDY/3dILni9a4kxqib8tiGJMGSWsn/cmGNyRgo7Wg
	 1/xUHPO9IC+LMnQWYB3T9rE3yX+74NcX5aqiqFBSLT5UVxOpFGJjOPb/kG6guwEkQgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyUD9egk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C9C606AC36;
	Wed,  4 Nov 2026 22:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pyUD9egk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805FB1F00A16;
	Wed,  4 Nov 2026 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830813;
	bh=NoN3bXycRLhkZSLrpLe8vYWDl9epBw54oJekyO2sIoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pyUD9egk6FsbL0R2uWU8dh10jTeUZMp1QnzFYwo+wteMhn1dcsBbxDJulYNWgVm7A
	 WXKkyE+0KL+z/1+/nUBMVzr+wxWR7Mddu1rO1vbACelk4R7aQ67SnXt8qS2JhGGdkI
	 LBH96q6p6rf8PqQhFoxK+Vh8SH113kyW1XwzNPZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liulhong617 <liulhong617@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0335/1005] arm64: mm: fix accidental linear mapping of no-map reserved memory
Date: Wed,  4 Nov 2026 16:01:08 -0500
Message-ID: <20261104211053.339323298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 71841b5c31928..7c3f560df6529 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1179,6 +1179,20 @@ static void __init map_mem(pgd_t *pgdp)
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



