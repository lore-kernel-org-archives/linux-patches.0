Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E9218A6A7;
	Wed,  3 Dec 2025 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779448; cv=none; b=aotAZCr/OhfpCRC6CW7GA0zRiFQ6gFtH7xuR6E0vUmLvZ6WXtR2dlz+mCBkcXG+lmfYo8LOgDi1NyU2XUQP+2kXDh0LBuskRjHDihxrWOdMDlh8M5Z0n7egbjD08yDOPvLOx52Hblm5KE0Tagxe739mARf59TaPqzxYNR3JCsRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779448; c=relaxed/simple;
	bh=AEX3ohW3DuRh4HGxrrINIK8MBiUbmYA700hYZ9a4DcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBx8+/qKXTxZCw21dNZvyBm8Gv1s483dXtgOTaz9Nbwe++1O/4A9kTyXHX8QWB6CTLtyrofHyKLrhzxKNzxYLmrElguhNG02+K97JqMy5J3alYNAdACxpISgnHUnmjqWVVKQIKq/FQZRvXA7FX6WNyCzy1+Hf/ZsUb9U75hJjVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbZJfFnC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbZJfFnC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECFBC4CEF5;
	Wed,  3 Dec 2025 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779448;
	bh=AEX3ohW3DuRh4HGxrrINIK8MBiUbmYA700hYZ9a4DcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbZJfFnCw6J9NG7+aQy3ZQU+2K9MNTAoQUN+EiRucfm2E55NXY4HelatlO8/qBDPu
	 XgJDHJU9rfYHk1XQRp9eOfA0nKh2Nt6Z+8rIoZ7LThYamfyJdFdEzgn+sSprKCTgZp
	 HaxyQavtEKAPNhxv3gxsUorWYXMLE8YSomztVYPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Yael Chemla <ychemla@nvidia.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 261/568] net/mlx5e: Dont query FEC statistics when FEC is disabled
Date: Wed,  3 Dec 2025 16:24:23 +0100
Message-ID: <20251203152450.276954979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 6b81b8a0b1978284e007566d7a1607b47f92209f ]

Update mlx5e_stats_fec_get() to check the active FEC mode and skip
statistics collection when FEC is disabled.

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Yael Chemla <ychemla@nvidia.com>
Signed-off-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20250924124037.1508846-3-vadim.fedorenko@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index f7f54550a8bbc..5db4fd40fe8b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -1301,16 +1301,13 @@ static void fec_set_rs_stats(struct ethtool_fec_stats *fec_stats, u32 *ppcnt)
 }
 
 static void fec_set_block_stats(struct mlx5e_priv *priv,
+				int mode,
 				struct ethtool_fec_stats *fec_stats)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	u32 out[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	u32 in[MLX5_ST_SZ_DW(ppcnt_reg)] = {};
 	int sz = MLX5_ST_SZ_BYTES(ppcnt_reg);
-	int mode = fec_active_mode(mdev);
-
-	if (mode == MLX5E_FEC_NOFEC)
-		return;
 
 	MLX5_SET(ppcnt_reg, in, local_port, 1);
 	MLX5_SET(ppcnt_reg, in, grp, MLX5_PHYSICAL_LAYER_COUNTERS_GROUP);
@@ -1351,11 +1348,14 @@ static void fec_set_corrected_bits_total(struct mlx5e_priv *priv,
 void mlx5e_stats_fec_get(struct mlx5e_priv *priv,
 			 struct ethtool_fec_stats *fec_stats)
 {
-	if (!MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
+	int mode = fec_active_mode(priv->mdev);
+
+	if (mode == MLX5E_FEC_NOFEC ||
+	    !MLX5_CAP_PCAM_FEATURE(priv->mdev, ppcnt_statistical_group))
 		return;
 
 	fec_set_corrected_bits_total(priv, fec_stats);
-	fec_set_block_stats(priv, fec_stats);
+	fec_set_block_stats(priv, mode, fec_stats);
 }
 
 #define PPORT_ETH_EXT_OFF(c) \
-- 
2.51.0



