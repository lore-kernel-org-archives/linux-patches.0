Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DD01A76B7;
	Tue, 30 Jul 2024 17:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359680; cv=none; b=MnZ0yXUg1V7Xaov5NPHJHpKyHWgSQXIR1UKogGbySX86hWLQHbatnk/jgGEDhZDbOZFEFIdTbUhzFKBfRmYlt5WvlGOu/aaJ70Eag/B9/yxwGcT2rZPUOsrN5R5/nnL1wuBGSkkwcn45UxjQXc/3DO/FDCPxPY2PJHAh4hc33PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359680; c=relaxed/simple;
	bh=Ptk/tzmgiduHhQWLE+TI3JueN+mzAqSEEp4GQTFqLjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V7l2Mu23775DLp05YyeuDsbIkp1oneXklE6GQA2Bsd2yLmZxtuDsqGvNE8v3EEL8te92+bGvNMndqASKG6Jfgs30a9T1EUJDCfIjPknVO2M16ULlVrbSs4TkR++CVrckv5JYX/RGYh1eOZso+pkCtcBkZ2G0cYz9ofMPEWf0His=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaEaFeSg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaEaFeSg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD2DC32782;
	Tue, 30 Jul 2024 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359680;
	bh=Ptk/tzmgiduHhQWLE+TI3JueN+mzAqSEEp4GQTFqLjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaEaFeSgTzqtBS73tODuYfWqnI9pTmjHwK6ztrehGA1qVYzDgE/9lyPZjLBDvqB4h
	 7dcM8p2ArqaUlyPgK2XiOnMKOMfMXcAzlcZc4014eabN5zxvRUtECF6j4QtcFfP8lx
	 95M+J+7RR8fvnvAmTY3jQ5DRxLY+hjZhP+DURXg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Oscar Salvador <osalvador@suse.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 518/809] powerpc/8xx: fix size given to set_huge_pte_at()
Date: Tue, 30 Jul 2024 17:46:34 +0200
Message-ID: <20240730151745.199494043@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7ea981070fd9ec24bc0111636038193aebb0289c ]

set_huge_pte_at() expects the size of the hugepage as an int, not the
psize which is the index of the page definition in table mmu_psize_defs[]

Link: https://lkml.kernel.org/r/97f2090011e25d99b6b0aae73e22e1b921c5d1fb.1719928057.git.christophe.leroy@csgroup.eu
Fixes: 935d4f0c6dc8 ("mm: hugetlb: add huge page size param to set_huge_pte_at()")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/nohash/8xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/nohash/8xx.c b/arch/powerpc/mm/nohash/8xx.c
index 43d4842bb1c7a..d93433e26dedb 100644
--- a/arch/powerpc/mm/nohash/8xx.c
+++ b/arch/powerpc/mm/nohash/8xx.c
@@ -94,7 +94,8 @@ static int __ref __early_map_kernel_hugepage(unsigned long va, phys_addr_t pa,
 		return -EINVAL;
 
 	set_huge_pte_at(&init_mm, va, ptep,
-			pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)), psize);
+			pte_mkhuge(pfn_pte(pa >> PAGE_SHIFT, prot)),
+			1UL << mmu_psize_to_shift(psize));
 
 	return 0;
 }
-- 
2.43.0



