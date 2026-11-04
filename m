Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829667;
	b=QT7t+gfCn9VFJnENEhIueiHtNOkv4uQsApuc2PFE3Z/C6kq2j3nUG7gnz0aMZ860pSfh
	 4/yIAZ0JCM9UU2k7c+V0EZst6N1u5JbwzQjr/GsrxhMhdwVM1FNc6CDV/FikjSjB+vilw
	 D/nuIZNA1kO1SNZrDs1K4BQ8HaiRS5z0cOANz3v5rGwX+dYyqO46G0APGNNmsCTArbKgc
	 /b41YGYpKW9YTrv7OxXdIXwFn7NPQjM3PEQM6O3+99S1Zc/EVnILbmE3gg6zwpbuj8Lsr
	 pkmMZl0SqMWO2SV7o6J+rWVrfs25Z65gzOKdAGZvXn2kHqIV4QI2P5RRCsMMCwLFWiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FNfiL4Yv/bvYZ2YoY13vbeBotNlOhcqoBxU1/XmiykM=;
	b=mBgRZ6hfvEYdR6cF80tyvkvIvBFH4fGkAWXM7WXbNtcgHm74Af7276htQKS5S0MIh38g
	 9FLQ/+TmXoWcI1pVZqkYYmWGKlZz7KuZn10GhtDFB+Fb0R/dcji+LjfDxi/BhCpW+kHLF
	 u655iI/+BmcXHnjUfW2EjE1TM1jdps+/VNjAResbD3MzVIWyJI98j7aqmSeqasETfdldC
	 28A7HbqkKo9RBd8kmhdlrEoFb881CeeBgeGCoWBkW603UJso4EO+U37Qo/jcHbVvqZndh
	 VQlf8JTfZmtHkMvfWxYK+8W6qBm4i4GnY3L2ZOJfKHcB1wvLCl4pkkLkc3tEB95VmRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+muJL8P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57DF60C2980;
	Wed,  4 Nov 2026 22:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+muJL8P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459171F000C1;
	Wed,  4 Nov 2026 22:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829666;
	bh=FNfiL4Yv/bvYZ2YoY13vbeBotNlOhcqoBxU1/XmiykM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+muJL8PGJIE+g5XCzbWT7s3Jf1i8cnjwg9acBdGCBKIfgejb6Wunpnv8RSFDWqTP
	 6zr0/I4fCJfzGynKK7ZpViGdXJRJKh9epo7Dm7uKsiiCygoRgFzOQYHpILirtYCJPV
	 HanMyP74tDdCY2FLDaSPOa7gaQ84c3ia5qjPcfaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0260/1005] iommu/tegra241-cmdqv: Rate-limit the error ISRs log message
Date: Wed,  4 Nov 2026 15:59:53 -0500
Message-ID: <20261104211051.149912937@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit a86c36163c9722545d27e92bdad8418fdcaa8b1d ]

tegra241_cmdqv_isr() logs the error-map registers on every error interrupt.
A malfunctioning device, or a guest deliberately faulting its own VCMDQs,
can raise these interrupts rapidly, and the unconditional dev_warn() then
floods the kernel log.

Rate-limit the message with dev_warn_ratelimited(), and pass the error-map
registers straight to it so their four MMIO reads run only when the limiter
prints, instead of building the string on every interrupt.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index fdbd487848e64..8c9530873ed98 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -350,21 +350,19 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 {
 	struct tegra241_cmdqv *cmdqv = (struct tegra241_cmdqv *)devid;
 	void __iomem *reg_vintf_map = REG_CMDQV(cmdqv, VINTF_ERR_MAP);
-	char err_str[256];
 	u64 vintf_map;
 
 	/* Use readl_relaxed() as register addresses are not 64-bit aligned */
 	vintf_map = (u64)readl_relaxed(reg_vintf_map + 0x4) << 32 |
 		    (u64)readl_relaxed(reg_vintf_map);
 
-	snprintf(err_str, sizeof(err_str),
-		 "vintf_map: %016llx, vcmdq_map %08x:%08x:%08x:%08x", vintf_map,
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(3))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(2))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(1))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(0))));
-
-	dev_warn(cmdqv->dev, "unexpected error reported. %s\n", err_str);
+	dev_warn_ratelimited(
+		cmdqv->dev,
+		"unexpected error reported. vintf_map: %016llx, vcmdq_map %08x:%08x:%08x:%08x\n",
+		vintf_map, readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(3))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(2))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(1))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(0))));
 
 	/* Handle VINTF0 and its LVCMDQs */
 	if (vintf_map & BIT_ULL(0)) {
-- 
2.53.0



