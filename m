Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74E21A316B;
	Wed,  5 Mar 2025 18:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198573; cv=none; b=O9mCVjsJPmiRNx51UTxe9mR2Ai4v/RPhwkT2q5PSDsa0cq6nu8gFjejVBYYb6HwESPN70hMhLEctDG+EsFPk1hIiVx7rnwWqkhRzKrWCT1vseg/IToc0qKd3N3kLAxOZkNvftT347U+Pygd8Jxdw5yBU3GKsBMIUtbd1ynzBOIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198573; c=relaxed/simple;
	bh=rv81iGikYhgTyIQDZyXgHtCp4MK6JTfpcFYwIVDLSdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+7UoXvmec1XaFwJ3pyTTTVUEg++9Q37vzI7T+cHBTQf1xN4zacB5aYrFS6jlYPpjDD576GM1L0BEKfR2st92dNFlrUzumvWQYDovGqDisn7F0YykSiydPkJ4vcLCkrVIBhS7ndlcse589YbDrXFfYgfyM6yBBmu/l10hFhL5Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeokwYxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeokwYxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB409C4CED1;
	Wed,  5 Mar 2025 18:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198573;
	bh=rv81iGikYhgTyIQDZyXgHtCp4MK6JTfpcFYwIVDLSdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeokwYxWk2ixUpi/lLr8qe2cfDvSaf7PYqefUOnmj8nr79+b1k00rKV3TgQST4tgP
	 wDEEnC/mt4yjt+PPXr6kL57DvBqY+nGpuBx703WBl2PHpi0J38u3/uI6m/Upwbmikh
	 5gzl3ihTEHObtxq0fsaPAbJfpwKRnK+VImAQs2Us=
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
Subject: [PATCH 6.13 057/157] net/mlx5: IRQ, Fix null string in debug print
Date: Wed,  5 Mar 2025 18:48:13 +0100
Message-ID: <20250305174507.596322511@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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
index 7db9cab9bedf6..d9362eabc6a1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -572,7 +572,7 @@ irq_pool_alloc(struct mlx5_core_dev *dev, int start, int size, char *name,
 	pool->min_threshold = min_threshold * MLX5_EQ_REFS_PER_IRQ;
 	pool->max_threshold = max_threshold * MLX5_EQ_REFS_PER_IRQ;
 	mlx5_core_dbg(dev, "pool->name = %s, pool->size = %d, pool->start = %d",
-		      name, size, start);
+		      name ? name : "mlx5_pcif_pool", size, start);
 	return pool;
 }
 
-- 
2.39.5



