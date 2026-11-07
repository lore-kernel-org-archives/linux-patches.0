Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060825;
	b=1H0nnOqBy02PvwA8VdkUVVUTvmjyFfN48ujuQk0BzIP6hHstigfXsp8TAPD5T0QV7zqh
	 6obi5nyh7Gogq/qklokW2rHruLpP/mZsrvY4yEP1RSjGAanfPbNGvwTRlLecD7MQj17LW
	 pj19JLIphuwcuKuK+UezLZXXaknHIgHqlJbSRzFcinQMw1us1zATHDgaGHvXO5ni1OfNG
	 vKL3jDjtcBpbYq0Wg3CXvlkPskdaSfTs5CWTPXai10zc2fKA4MozzmA2c5gCJRdRS8twf
	 jlZ8FT0CjKPI1dSNBesfH0MNGmULsyYonh+OTijDUm1J8i/eh/h/bXQBgkm4X8nQpRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PhKFaQNvKP30MgvyDlNwPHpJjOmfr69Vs6lSfxvxKOw=;
	b=e4HqbGAv5mBzWMud0HJH4/PwE6X501uF+3w39gfPbnwPix9cbyg9RqbzLofLK5Pnf7AG
	 dhcAByt35lA6mDuQAy6K96qBsA/drann+QCxJo9C9NDBlcD2b9QHQFZrDYs6Lr9e/p+uM
	 wmknLRbwLXOZq8b9B1tJRXzMVYSVKnpLA1giTXJWFflTZwjR5o+JrpsfQvCPbVrzlP1Uk
	 ClYOlZLREgjgDY3bGkM2DHigEQrcJ7CUzOj9LMxOTxWv2QRaoWu2kvLytofH2R/2hHh0T
	 StzciUztENNN7Do7o8Z/mdqSXqcvRitH2xuMEj61C0IUcS50wC0m1W14sJYYLJqmXoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04NT1Sq6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF5D606A336;
	Sat,  7 Nov 2026 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04NT1Sq6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7BD1F0089F;
	Sat,  7 Nov 2026 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060824;
	bh=PhKFaQNvKP30MgvyDlNwPHpJjOmfr69Vs6lSfxvxKOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04NT1Sq6psXmzyDFrICcSXLyOWG/cbvS+MO6GcRRVrHg9I0XWAQxsll2UalwRPmRk
	 Q0eE/9X3Za4xCMZPaD+7S1FMDvy3KX5dUe5yoE5Y1Bp9pikVkbl4LyyHFsBh3Pm8Pn
	 nGHCLREObEVDbJZs94faOdWXXQyLwvcBsl0FF7hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0221/1536] iommu/tegra241-cmdqv: Rate-limit the error ISRs log message
Date: Sat,  7 Nov 2026 08:37:17 -0500
Message-ID: <20261107135003.873828082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 3207fa9836063..c9940e6f1c174 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -282,21 +282,19 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
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



