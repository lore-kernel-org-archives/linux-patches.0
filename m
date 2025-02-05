Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431EC1FC7C4;
	Wed,  5 Feb 2025 14:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766824; cv=none; b=oXXMC2e5j5HZy7RaUMbuLhVdwBYhigym1CvI9EYpLMMCtOCieb/6NMmaU/a5KSLkFPGoJjxCnZrwrg1+h/yX5zqUw2AIPs1i+RofggPNM1ewcHWnbuKosbEy8IffNTe0eLzw5QZIiLuHABQFRKC3SevaZeI24SRvzEDsY/XV20I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766824; c=relaxed/simple;
	bh=G28laikxOylY1kCG6fb8bKeb0Su6trUQ7a65Y3imjhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjLp4dCEmiiGYrSNz0RNMoFaybAxL6dwB3/nxwMc7i9djCT+JdPrtgMyuWmzLA3zH/GWk/5kkg4Hj/r6Ica+ev4+hjGcYHs12gUIK//lJMrgkrzc1yJQ9YaWVcC0HZcDMiLZttqGIK6PPBhsaEnfmgTGmhSxPN9lxZKVZ8vzisY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cYXfclUm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cYXfclUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9C4C4CED1;
	Wed,  5 Feb 2025 14:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766823;
	bh=G28laikxOylY1kCG6fb8bKeb0Su6trUQ7a65Y3imjhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cYXfclUm+vgLZEfkIzRzI4OO6agPYJORu6W30lVQGwQhPx1tffdOsrXUiWM73jHIF
	 u/KKE6j1gH4QCKcuYQnbMsEJcUIIOkz1bFoyM5XbU9p2/YFFM2qfEmYs2xr/sBYSTz
	 zUBG4h05b9nWDMTZmRqK24M175gIKq4kV6eJAMxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guo Ren <guoren@linux.alibaba.com>,
	Guo Ren <guoren@kernel.org>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 313/623] iommu/riscv: Fixup compile warning
Date: Wed,  5 Feb 2025 14:40:55 +0100
Message-ID: <20250205134508.198692514@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 10c62c38b073ecea775b7e23fa7c7a3995a84ff3 ]

When __BITS_PER_LONG == 32, size_t is defined as unsigned int rather
than unsigned long. Therefore, we should use size_t to avoid
type-checking errors.

Fixes: 488ffbf18171 ("iommu/riscv: Paging domain support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Cc: Tomasz Jeznach <tjeznach@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Link: https://lore.kernel.org/r/20250103024616.3359159-1-guoren@kernel.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 8a05def774bdb..38d381164385a 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1270,7 +1270,7 @@ static phys_addr_t riscv_iommu_iova_to_phys(struct iommu_domain *iommu_domain,
 					    dma_addr_t iova)
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	unsigned long pte_size;
+	size_t pte_size;
 	unsigned long *ptr;
 
 	ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-- 
2.39.5



