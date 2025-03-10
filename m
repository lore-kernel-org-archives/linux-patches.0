Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78411B4F09;
	Mon, 10 Mar 2025 18:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630700; cv=none; b=ubz/vqpB2R623aCpXcHfBWDZSa4EeSZoZ1ZxDqPZPW53wi8xDIpnh5ddLWO3VPrqKhNaRZL48zaHi+HkSDt2sxdgqEcaQM0W1ZZ6P/3pgVts7t0UMF+Vw7HIOhGZOwH9WbsrAdwByhj/R/e4Nj9N3SigzqFLahKLGUnMz9IDMY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630700; c=relaxed/simple;
	bh=R16s6iKxN3MtbOuT1VmI0B7pVqiEMHfDOxV/egX8L4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xp3PHq+D33KDFpD75kQCHq/KJBeZhXQZE97TMRWWbYNczexntVa+2FBsfJofEN7S+bb6/CTGjGQ6flZ8HrA6QPDYhzC5I8cg3/c5FYdnIuQzm2FbC1KRQdhcgvZfLll4TElwxzwC+2n2Oml0lLBgDCdSfJlJHTv5QzqDNbjlX6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnawJBdG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnawJBdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA6D0C4CEE5;
	Mon, 10 Mar 2025 18:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630699;
	bh=R16s6iKxN3MtbOuT1VmI0B7pVqiEMHfDOxV/egX8L4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnawJBdGT3f81EQ8QcMzHiHO498/+lrU6egF4iBDZNeyblQib8knvqRbmheCMB2OE
	 +SmM4tmcpjjN/OGQAnwvNalAPd9vZ6+zPgXxx6WV2Fen7u3V39qvF4cloXD8l+RmQY
	 Ay5twAwuO12UyQDfCYFQXXTe7Q/elYCBeRjidpno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	kernel test robot <lkp@intel.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/620] net/mlx5: IRQ, Fix null string in debug print
Date: Mon, 10 Mar 2025 18:05:51 +0100
Message-ID: <20250310170605.495710668@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 2f5a6014eb168a97b24153adccfa663d3b282767 ]

irq_pool_alloc() debug print can print a null string.
Fix it by providing a default string to print.

Fixes: 71e084e26414 ("net/mlx5: Allocating a pool of MSI-X vectors for SFs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501141055.SwfIphN0-lkp@intel.com/
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250225072608.526866-4-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 2fa84556bc20e..4c78821f5edb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -474,7 +474,7 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
 	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
-		      name, size, start);
+		      name ? name : "mlx5_pcif_pool", size, start);
 	return pool;
 }
 
-- 
2.39.5



