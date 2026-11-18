Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025281;
	b=5ofDBky0syYTPOdxUTmXHynyXI5TnXwls6p28Fjh/Qj59lPLuBcIrtcBz+2ERRzh/T9l
	 X9g0qWoEoY7ngNDarkQ9NY2i2s/WVSfhIid6pJaKG3rSIBXPMjFLuYnuqGXJCm9yEkc8c
	 nfTT4P7XL+sDU08KJctzDz2XEQQ2cfZFoWxQqSqckemOz29QKfB2ot65CSm2Z/zFfctw9
	 9vQ4/+sBk+RJpxjI+U6xt5N2UZ63zH8QrMTNocKNnT5jDoepxDmGedh4Yqp0dZZhItjxU
	 ZQodp5KBcmCDoR1sEuvct+s+O84n9EsdhEa0gxjxmoRjdRHXYwOJcABn1zoRrdeGBkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSWMh6OsCqm/Nu+VI5IJ3sSPvt4roCQKeXSMBcwnPfk=;
	b=vq74xUSvdvUbkYyjiwPbYJ088TGcDkYQK8LYVwouNDlUSjqQsTot2Ish5HF9ERMvGpjc
	 gwbhZm7eSDdfZf/5UlVEZ88j7/g8I8dYLTL3xceu9gkzMIYPdOek5WjHqv8g54ubbuyor
	 cOPb9nBHABTqJFugh07GWWre4XcSI7qByotKRNSPpvotHtoysBIBCe0RZ7E8LvvOw/IW5
	 RANHZJqNorO5MfO8vvb/ptYUzh89N0lQOdo+pa0YKLQMMPB8GhaI7KxlloPI5mYM/LpId
	 RZC9DfCJEF8XBaerH5Oivp5q3W7vLuFirQRjgy5/OCLyvFIKXlsvD/TtQKne2xCiFEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDhJGUHb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983F0606A320;
	Wed, 18 Nov 2026 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YDhJGUHb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FB01F000C4;
	Wed, 18 Nov 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025281;
	bh=DSWMh6OsCqm/Nu+VI5IJ3sSPvt4roCQKeXSMBcwnPfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDhJGUHb4sABv/6/kLVKZq1IYVdHxsevRFVPydhOdIdSq/OgULuzAKrBB+NqeFvhp
	 Lcd+mdHWcz1WjPyd9fTJZF+BineACVBwEHCCpcWdAbvtBCjm2IJAyHYZnUJqZQ2+6e
	 kUtInmv06PveDWdWSMXhp0ZYjHlsNSFBdV0sdeEE=
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
Subject: [PATCH 6.18 0972/2151] iommu/arm-smmu-v3: Ensure L2 tables are visible before L1 ptrs
Date: Wed, 18 Nov 2026 15:45:07 +0100
Message-ID: <20261118150157.910807156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 41c66c6498eb2..84dff2f06bcd1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1312,6 +1312,9 @@ static void arm_smmu_write_cd_l1_desc(struct arm_smmu_cdtab_l1 *dst,
 {
 	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
+	/* Ensure the zero-cleared L2 table is fully visible. */
+	dma_wmb();
+
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
@@ -1583,6 +1586,9 @@ static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
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



