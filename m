Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6EE1C6FFE;
	Wed,  5 Mar 2025 17:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197462; cv=none; b=J1dw4K1FKUiEVo6cEL+COhuv9pIPEBtnNxueyrj9YKZnP9G15Ucfjr8OS7a6cDn0CgTT6ihN0DA5TdeL+EsEtgqtevHL23EAT+n5pZtxyOBlgjcSFw1xsHLMeUWcSvEjY1BGURbJmcbwwDLoLzc70hPQftvQEz/klefuPZVVNOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197462; c=relaxed/simple;
	bh=riE8BN7RwCqmRsLtwiA3SFdAi+7Paw6ySu7ZLN4YJNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOuMer2Q/63zG5cCtkmBaWLhgrdbRxej/a3lXHNkUIHOqYNvWtW/Gu8avlze16XEnit2fdCRrrkXvb/gHna/8ei/IHOR4Vtp9IImnqOzYsgmI2J4YMxkKTU3Sbk66ZV1aXLOtbNXDDqdCgdMl+rVWe2wxN2/fmD0B/dNJ7IXcoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYjd3mPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYjd3mPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5E16C4CED1;
	Wed,  5 Mar 2025 17:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197462;
	bh=riE8BN7RwCqmRsLtwiA3SFdAi+7Paw6ySu7ZLN4YJNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYjd3mPSAN+kkGqgZwExSHk2G6gJIj0zmTk6A7kEXb0zI4AgEBOjfYg0DgUCNnwzY
	 q5lerPsFlwXQwMRI1UsS3I2ujRI3E4cy2jR98vmU4JTGflqw05zeuAifM42IdjYZjp
	 +obW7iE4P/Tgc6HvxWqoNFFXxqJY1lu7G2RsBSso=
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
Subject: [PATCH 6.1 137/176] net/mlx5: IRQ, Fix null string in debug print
Date: Wed,  5 Mar 2025 18:48:26 +0100
Message-ID: <20250305174510.944843889@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a6d3fc96e1685..10b9dc2aaf06f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -513,7 +513,7 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
 	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
-		      name, size, start);
+		      name ? name : "mlx5_pcif_pool", size, start);
 	return pool;
 }
 
-- 
2.39.5



