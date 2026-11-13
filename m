Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590426;
	b=Jj/EU86Lur/uGtc/5GLTb7zGNXQa+Jhh/dOub4FI4uUUDXgL9RPbVOfRcVLzDeqYroAl
	 SPQOCjowWZJIhLPwBKVmMTkNnWyqjMgG3rkGZXGC3P54CYQmJ0yYBinrHOFo0it9sbwa6
	 YLFbj2qcpZW1MJy0v8vZlsyjk4qHxQfhEIShM7Ud5hieXL+7tndJPUmZI+2XqPFRrpKRl
	 SwL75nF3ZySs+LV32AwzFyo6wc+xCja1z6wcPXJS+r/+2ICFH4KXg3+6aWeRY3t+iJ0sm
	 17yh+OJJkgRL3nPU7EpjU7+0u0EcttOuWYxNvk5epL0qqVEQcqIVmdjbqdy9nEAi7Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lei2YeMdjyVDd16ND0FjuNryUm7aHZkfu2pMJ/gDZwA=;
	b=zSw4SFPnwdQ7W1mn3mI9cFY2nc3xz8cAoQXCKfTRO/vtij3HniiPi+dpY1OpnQ4Ecw92
	 1X3sBStjIJMZmBr9nbTT4KaJkut2/oEQDibRz6IRVl/jSKzm71uiiVgHQBSBcgCcMC2fm
	 cyxNWwM/f3EzzHAHqAAdLqsPBmQggeCNI9AYm+XO3WN06/yINWFC9QDiAa5AeKrhFL5JY
	 cIFF6LGnwbJ700iXcKzbrYeXg4BPwIVY/MJuh/g0ihPyG3+SJ7RpHxJkOc8X8gPEnH6t+
	 Lr2J/ax1XUGdj0l44rkAEXn0KIDs8QxlewCeThgqBQ+wv/V4t1v5vBphrBfmrn+Pspw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTXtSnkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA90D606A884;
	Fri, 13 Nov 2026 17:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTXtSnkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCB1F000C6;
	Fri, 13 Nov 2026 17:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590426;
	bh=Lei2YeMdjyVDd16ND0FjuNryUm7aHZkfu2pMJ/gDZwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTXtSnkfMd0v56tiw22q+Mad4hFH1O0vtxF0NiDjgMegytjyWRPM1J7wGW6Th+dIU
	 Blkpee2A3dVPdaGvXhT+/B2resz9AVV7Qttvsy+Vx38juSZdrab3jDHmnTEyzyuGeC
	 qV9W+GR82/Z3MVO2BPyCN6knGen2Xs/Eg/S8ZzIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavithra <pavrampu@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 389/686] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
Date: Fri, 13 Nov 2026 10:48:42 -0500
Message-ID: <20261113153834.187886203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit 466d6844c8f19fba16b668b49861bdb8d7ded282 ]

Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
built with CONFIG_DEBUG_VM triggers this warning on every munmap:

    WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
    NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
    LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
    Call Trace:
     zap_huge_pud+0x170/0x2d0 (unreliable)
     __zap_vma_range+0x1604/0x1e20
     unmap_vmas+0xa0/0x1f0
     unmap_region+0xb0/0x130
     vms_complete_munmap_vmas+0x120/0x310
     do_vmi_align_munmap+0x1ec/0x240
     __vm_munmap+0x148/0x220
     sys_munmap+0x28/0x40

To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
byte so that the whole 1G is mapped by a single PUD and then munmap()
it.

PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
the page size for which tlb flush is needed. zap_huge_pmd(),
zap_pte_range(), change_huge_pud() etc all do this already. However,
since commit:
  dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")

a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
tlb->page_size is still whatever the previous user left behind, which is
0 for the fresh gather set up by munmap() and so the check fires.

Fix this in the same way like how other similar paths do.

Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
Cc: stable@vger.kernel.org
Reported-by: Pavithra <pavrampu@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Pavithra Prakash <pavrampu@linux.ibm.com>
Link: https://patch.msgid.link/8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index df4a3e6215d4d..78fecc3ad5700 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2822,6 +2822,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pud_t orig_pud;
 
+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
-- 
2.53.0



