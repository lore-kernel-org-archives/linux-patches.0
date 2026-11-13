Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585731;
	b=NFgj2vJe1HXXcIJtY1rZoU19+7eRfe/xtkzR6I1KuH98j2w9VGULUxn3ZPJF8f4v66J4
	 GFQBS79xxCJ8AzF04unWjPQaY6Ntwov5qK4daqdeEScBEwLZK/+eMMkeAQrHcBvrSl6Ra
	 0KPC+VoA9aopBq6eyx58R5dMaaDeFmMlSumxTJik2GAV0gSdM/VrqodEke+m5HnZe8ejR
	 jqxNkrd7XfeqTM09wnZJib2LvbfanfUk2oS+nj6AV26lK6uACXPeG2Pog338jDxYqZK3j
	 mgqIbdlRGpCj5d/D7LwCtAdCQ7Rof4urqxNP/FdGQIHKUflF+B3twcHpTF9fDcb2Pgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0JXcJgbCIHRANKRT8IzuHMp7NsH1K7AsXWx460Jq+9Y=;
	b=rBQE0UQectRIqxFW/OjgnIzEVmuRhQy2j3eUEOE3D8R/z/RbZK5J4DRZzm7vAeon5biD
	 Z1RprjI4t6D/iqYK3nDeLTW4o2U4uHZgaA5IgjrUNOg99M9KPl5w7ZHSYaRTyC1c8aoGJ
	 i9JKkITCsU9EUh1+5peyIdDnwsiNK5/Aa2DPEoZb/a3gCiRt1E4Cwy82sYtFXpJxxECB7
	 no69dBSRF+TCdzKVO2B2xlYRE9VdyQula8gWO/OWciGQxh056VxVDGMa7RhlGs0YOxPcy
	 t+G6JQmQt08v6sTKVCBynY3kKcdrgB5tete+EpfK+IR1FhBwBfhxJSzYjYals8hP2uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4RqRHlQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CB8606EB82;
	Fri, 13 Nov 2026 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4RqRHlQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 256BA1F000C6;
	Fri, 13 Nov 2026 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585731;
	bh=0JXcJgbCIHRANKRT8IzuHMp7NsH1K7AsXWx460Jq+9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4RqRHlQw7GxYf34L0yipGQlPfMOwtlxAU1reArn6T9TcAFhci5rXQCyjMUt/BLS2
	 IZ7noFHEnhMVBLXYnc9Cj8v2uR5i9ndgAuPt9sHz+6GXXOWbG99xpC3x0K8fztLUd/
	 TUh7y4L4waOvvTSBKy/Fk4FKVJQRP97ZOXo4qAx0=
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
Subject: [PATCH 7.3 332/507] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
Date: Fri, 13 Nov 2026 10:50:36 -0500
Message-ID: <20261113153806.688299509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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
index fde9ea15fef9e..5f7e3320d4d06 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3061,6 +3061,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	spinlock_t *ptl;
 	pud_t orig_pud;
 
+	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
+
 	ptl = __pud_trans_huge_lock(pud, vma);
 	if (!ptl)
 		return 0;
-- 
2.53.0



