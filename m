Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0EBA35
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3B9C433D2;
	Tue,  7 Mar 2023 17:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209818;
	bh=Xm66yzCkKyvPsqNUy9kCVebKIt30mXB/4WkmbfJGT0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gpBXokSUN4mDN5yB8y+NFFjL/Fm0+7qC6h4npH9p/Y3weznhAGJSQYm/8tA4unY+
	 fjjLR6q9MU6B/S1FHQUkonsKFhJWNNh6uEGvs87wTFI3PUUsYd7oj+iLayDM2qff+D
	 vfleA5g3D5PU5QbsQpGTXIlphv+ercgkzwDgisXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emeel Hakim <ehakim@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0324/1001] net/mlx5e: Align IPsec ASO result memory to be as required by hardware
Date: Tue,  7 Mar 2023 17:51:36 +0100
Message-Id: <20230307170035.582847562@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit f2b6cfda76d2119871e10fa01ecdc7178401ef22 ]

Hardware requires an alignment to 64 bytes to return ASO data. Missing
this alignment caused to unpredictable results while ASO events were
generated.

Fixes: 8518d05b8f9a ("net/mlx5e: Create Advanced Steering Operation object for IPsec")
Reported-by: Emeel Hakim <ehakim@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/de0302c572b90c9224a72868d4e0d657b6313c4b.1676797613.git.leon@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index 8bed9c3610754..d739d77d68986 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -119,7 +119,7 @@ struct mlx5e_ipsec_work {
 };
 
 struct mlx5e_ipsec_aso {
-	u8 ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
+	u8 __aligned(64) ctx[MLX5_ST_SZ_BYTES(ipsec_aso)];
 	dma_addr_t dma_addr;
 	struct mlx5_aso *aso;
 	/* Protect ASO WQ access, as it is global to whole IPsec */
-- 
2.39.2



