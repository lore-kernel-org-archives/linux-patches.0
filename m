Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CEF4149C57;
	Mon, 16 Sep 2024 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488636; cv=none; b=gQkTZANalvaED/zLZPAgM9gqNZIahVfBcWYR3sOH7encnpjlqM6BSmqsYQXtSLvVTinV1kQrBAyKgo/ND2YhvBAlPAkCUdfQ0i6w5EG3PXOZ5la9J69f1UMGJtT49j/zpyCOwvV/qNcs/u9XAYF6C2FnopF4rGt/tiPXyzFf/ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488636; c=relaxed/simple;
	bh=rMKaxa4GK5zXMLyshZ4OlwxXPoacdlvHcsyd8P7YcLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJZKQR1sixcwrrHACe7A/PU+bqjP6QOEiDE5R9WKEZQKmphrsaxsjH/8r5BMQpvUqVImtEZavKXhlBEDVOMjgVo5rkVEopoRQLAvMJrljgO5/sVrQk9BDG9KORM/3by67qqRcACbOrgPT1anwPfgxr0YhaUKZ2x8XRVN8NzlC6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0WkZR+p5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0WkZR+p5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A15C4CEC4;
	Mon, 16 Sep 2024 12:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488635;
	bh=rMKaxa4GK5zXMLyshZ4OlwxXPoacdlvHcsyd8P7YcLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0WkZR+p5Jqaan1zEqeNb6AAZlYMkk3IJ57pu4UYFji+ml0SoD4RBilBYld8t316/3
	 T0ViQya4wc1tMSn6lhjIEp6B/4KRQElabtk2eFvQCVtYWiC0+BcmPxXZH5mAgCeLrU
	 7vAccTV0FIoPRaQ25hNUJG42rMMj8DhR/u1DW2hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Zhang <markzhang@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 61/91] IB/mlx5: Rename 400G_8X speed to comply to naming convention
Date: Mon, 16 Sep 2024 13:44:37 +0200
Message-ID: <20240916114226.502307566@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit b28ad32442bec2f0d9cb660d7d698a1a53c13d08 ]

Rename 400G_8X speed to comply to naming convention.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Zhang <markzhang@nvidia.com>
Link: https://lore.kernel.org/r/ac98447cac8379a43fbdb36d56e5fb2b741a97ff.1695204156.git.leon@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: 80bf474242b2 ("net/mlx5e: Add missing link mode to ptys2ext_ethtool_map")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c              | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 2 +-
 include/linux/mlx5/port.h                      | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 45a497c0258b..2d179bc56ce6 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -444,7 +444,7 @@ static int translate_eth_ext_proto_oper(u32 eth_proto_oper, u16 *active_speed,
 		*active_width = IB_WIDTH_2X;
 		*active_speed = IB_SPEED_NDR;
 		break;
-	case MLX5E_PROT_MASK(MLX5E_400GAUI_8):
+	case MLX5E_PROT_MASK(MLX5E_400GAUI_8_400GBASE_CR8):
 		*active_width = IB_WIDTH_8X;
 		*active_speed = IB_SPEED_HDR;
 		break;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index be70d1f23a5d..749f0fc2c189 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -1098,7 +1098,7 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
 	[MLX5E_CAUI_4_100GBASE_CR4_KR4] = 100000,
 	[MLX5E_100GAUI_2_100GBASE_CR2_KR2] = 100000,
 	[MLX5E_200GAUI_4_200GBASE_CR4_KR4] = 200000,
-	[MLX5E_400GAUI_8] = 400000,
+	[MLX5E_400GAUI_8_400GBASE_CR8] = 400000,
 	[MLX5E_100GAUI_1_100GBASE_CR_KR] = 100000,
 	[MLX5E_200GAUI_2_200GBASE_CR2_KR2] = 200000,
 	[MLX5E_400GAUI_4_400GBASE_CR4_KR4] = 400000,
diff --git a/include/linux/mlx5/port.h b/include/linux/mlx5/port.h
index 98b2e1e149f9..5cc34216f23c 100644
--- a/include/linux/mlx5/port.h
+++ b/include/linux/mlx5/port.h
@@ -115,7 +115,7 @@ enum mlx5e_ext_link_mode {
 	MLX5E_100GAUI_1_100GBASE_CR_KR		= 11,
 	MLX5E_200GAUI_4_200GBASE_CR4_KR4	= 12,
 	MLX5E_200GAUI_2_200GBASE_CR2_KR2	= 13,
-	MLX5E_400GAUI_8				= 15,
+	MLX5E_400GAUI_8_400GBASE_CR8		= 15,
 	MLX5E_400GAUI_4_400GBASE_CR4_KR4	= 16,
 	MLX5E_EXT_LINK_MODES_NUMBER,
 };
-- 
2.43.0



