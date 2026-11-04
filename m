Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829646;
	b=CmJw9CuuhrZ4wHuBw0knn8lHsgXvOJLX93HE6uyggfDkmtbNmVAyBsuWETFvflyfY/A2
	 jBHPlP+EuoFHg8feO1Ym3RThQKAQM82h7/ynqbAq184oFG4VvUNPix8NfQMGnK7/nfeMt
	 aYaLiiX3Dzm8faPHN+8YDxTAnG/DKt01duxYyQPurMvyqy56QjBe4OMQnOO2ZBrxRYit+
	 xDS50cOfZaGX7OJWproi2DVRFXAcY8334NfBN4DlOE93tqjeMFvUdTE6yizwIdpuGjks8
	 VzAdxUloHI+vJDhxqyw4LgVaTM9CRCdIyeGcavq5oSEf+6TS5Kei7SWajDWXNVYjoKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uuYoAEbvL1aZ7vAbf4CRhKxNlvkNIDJjkzLmT/03w1A=;
	b=d+Eihvn/Tqbl4U4LJWwVra6rbyr8OEeX1lY0muQDwyLgghfH+BAVoIOzEWLaQAEFQpl4
	 D8aGhfOy1SokEFJkC13Uhy/YcnvSo4veTa52Rg5LzMHTfjFLN2LGfqZByXBwrY34Z/C0u
	 hgULE0Jgybh4tEGH1nu7h6Hs5eOhtDXbz6QNaZbyAwuNQo0Az4gHqkKY1404A6ct+ayDN
	 J16WJoGT8SItatID2MRCrYqgGRybYMPf1ucRKntid8m++9cwyK1xELkq8njt3YU5HJfJ7
	 YMVpcahdTTor/0JbzfYJWHxsSGe2vPkn17nFmU/xfgYQGb1BayLxRR0wPxCN6MOibow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFS8Id5b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C097A606AC2E;
	Wed,  4 Nov 2026 22:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BFS8Id5b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9811F000C1;
	Wed,  4 Nov 2026 22:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829645;
	bh=uuYoAEbvL1aZ7vAbf4CRhKxNlvkNIDJjkzLmT/03w1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFS8Id5bXWXvQrLNUBNjknJpaUhAO+MvnNIOUrH4RaNjntkHecBlZIpfiPfS3iYY2
	 aFnrXh/DGCikxofsUQc9SItFoJ6wfQ645ECP6u8xxgCTKNCjJGnRGE+wlBCy0sbT9a
	 cZcjCY2cVoEzWNCJLuQn9oVfihXiBrvEo82hwlSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxing Hu <gahing@gahingwoo.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0253/1005] iommu/rockchip: Clear stale page faults before enabling stall
Date: Wed,  4 Nov 2026 15:59:46 -0500
Message-ID: <20261104211050.950586682@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaxing Hu <gahing@gahingwoo.com>

[ Upstream commit b10d5920cafa292ee3cab9c20f813da4fe4f00b8 ]

Boot firmware can leave an IOMMU bank in PAGE_FAULT_ACTIVE before the
driver has configured paging:

  PAGE_FAULT_ACTIVE=1  STALL_ACTIVE=0  IDLE=1

Such a bank ignores CMD_ENABLE_STALL and never reaches STALL_ACTIVE, so
rk_iommu_enable_stall()'s readx_poll_timeout() spins until it times out
(seen on the RK3576 NPU, whose MMUs share this poll across banks).

Rather than special-casing these banks in the stall path, acknowledge the
stale fault with CMD_PAGE_FAULT_DONE before enabling stall, so every bank
starts from a clean state and the normal stall sequence applies to all of
them.  Banks without a pending fault are untouched.

Signed-off-by: Jiaxing Hu <gahing@gahingwoo.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 309ba78e27d4f..982ea9cafee1b 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -422,6 +422,19 @@ static int rk_iommu_enable_stall(struct rk_iommu *iommu)
 	if (!rk_iommu_is_paging_enabled(iommu))
 		return 0;
 
+	/*
+	 * Boot firmware can leave a bank in PAGE_FAULT_ACTIVE with no handler
+	 * (PAGE_FAULT_ACTIVE & !STALL_ACTIVE & IDLE).  Such a bank ignores
+	 * CMD_ENABLE_STALL and never reaches STALL_ACTIVE, timing out the poll
+	 * below.  Acknowledge any stale fault first so every bank starts clean.
+	 */
+	for (i = 0; i < iommu->num_mmu; i++) {
+		if (rk_iommu_read(iommu->bases[i], RK_MMU_STATUS) &
+		    RK_MMU_STATUS_PAGE_FAULT_ACTIVE)
+			writel(RK_MMU_CMD_PAGE_FAULT_DONE,
+			       iommu->bases[i] + RK_MMU_COMMAND);
+	}
+
 	rk_iommu_command(iommu, RK_MMU_CMD_ENABLE_STALL);
 
 	ret = readx_poll_timeout(rk_iommu_is_stall_active, iommu, val,
-- 
2.53.0



