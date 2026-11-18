Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030602;
	b=XrUPKHj6Ho+fqQLYQuV6tR9xBQ1wPxvAc7JDrU5drc7VWQEDrF9GirFbXwLSEC2KIXcO
	 6KxOogc4EuEGzEwam/7ucNGTgBj8iXz9mYlTQpZA60kJfOJ0qISOou3865dpydIimFOjq
	 +Lptw/6FZ/AYNZ/nuz5e+kD/2YWvYMEXTEBaisAtFRx3jb6Wz8Rgww/fp7XqA0hHffe2l
	 KM0Utbluxw1c9lKpjn0OYBKYl66o53CEGM2ylqcij4UXmpaCFgDuWm44jrFvmtJyoWgDU
	 5VVJzTKZcSIuIYizhQ4v/Tf0/jlzvkpGn4z6X7TLMEeDUZaVi7RQWG6XAQ5rv09dHUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kLLsmhN/qWivSSZh1QWUxxXr/Tc467xpPsKBiH/6OPg=;
	b=ZGKqprMkwvggW4I2itMoeZ5Nt7fe5fw+0FNP8KLbBv5exM/UY7POQ2/dIkfOalSYDFN+
	 yBJtrqmknSLVG8P3lmgNkctHDnB7XfwYeay4x2Ot/NQ5XWXeTIsfFRVBNs6MiyEoCjU1G
	 TA4DGK4DVKAXtFLhMesEx6UhKLnKyJEg6VHxTb1LTBH8PlEP252OQHgTRwidm3GFm3oOy
	 rL2UO6kBuE2IXe/VPe//CSymcNJVW57HunfmiFRonF7+zaOTfG+Y8IhvXDidbmDGgSnkI
	 kYYmeVYwqveBHFCd/EBTF26O6i68TBYE7qFg8iuEIQs2pryiE3aoR1Bc61wLhhWn54Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITzCm7+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D006073D42;
	Wed, 18 Nov 2026 19:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITzCm7+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3FE1F000C5;
	Wed, 18 Nov 2026 19:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030602;
	bh=kLLsmhN/qWivSSZh1QWUxxXr/Tc467xpPsKBiH/6OPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITzCm7+6M+OqTEQx95zSYDzLntsmyiZt7C4CGSx9sAFpiwUr8yr8Xe9+73/3Fkj/5
	 oJeAI8OJ9YrTDyRpWRxB9EO0B5jSo569ckMna6NbHA97IO7sW9aqOTvVi/jngPo5GA
	 U7newWJEmYBzkKFDLeB6tEDEM/Bwt+E929Mm36po=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Mostafa Saleh <smostafa@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0763/1756] iommu/arm-smmu-v3: Ensure L2 tables are visible before L1 ptrs
Date: Wed, 18 Nov 2026 15:48:10 +0100
Message-ID: <20261118150040.004331333@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mostafa Saleh <smostafa@google.com>

[ Upstream commit 84366fb547ed987c4857311da0e5127d95bf97e6 ]

Commit 6fabce53f6b9 ("iommu/arm-smmu-v3: Add a missing dma_wmb() for hitless STE update")
adds a dma_wmb() to arm_smmu_write_entry() to make sure stream tables
and context descriptors are observed first.

However, STE L1 table descriptors are configured directly
via WRITE_ONCE(), where before that they were zeroed with memset()
inside dma_direct_alloc() then written to abort in via memset() also
in arm_smmu_init_initial_stes() without a barrier in both cases which
means that the SMMUv3 can observe the allocated table before the
written descriptors causing it to fetch random data.

Similarly in arm_smmu_write_cd_l1_desc() where the L1 CD is written
after dma_alloc_coherent() with no barriers.

Add dma_wmb() in both cases.

Fixes: 48ec83bcbcf5 ("iommu/arm-smmu: Add initial driver support for ARM SMMUv3 devices")
Reported-by: Sashiko <>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 28331d9118b63..af3070db47460 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1240,6 +1240,9 @@ static void arm_smmu_write_cd_l1_desc(struct arm_smmu_cdtab_l1 *dst,
 {
 	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
+	/* Ensure the zero-cleared L2 table is fully visible. */
+	dma_wmb();
+
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
@@ -1511,6 +1514,9 @@ static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	val |= FIELD_PREP(STRTAB_L1_DESC_SPAN, STRTAB_SPLIT + 1);
 	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
+	/* Ensure the new L2 table is fully visible. */
+	dma_wmb();
+
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
-- 
2.53.0



