Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B971A15748E;
	Mon, 16 Sep 2024 12:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488344; cv=none; b=T+6zbFIZWUTDTlIbTYM92x5M4MLD9Jq6eh1vGZuig6c9XrpxMprgJBqAVxs+2dTmVc2WGGlppiAKTIhRBAZFIdE49vqFKNIflLtFlQ60x2EHHKO5+CV/6YXY8qAxYmoX/hP9B6V1O3aIuVtgX12X1DmFwMM26h4K0HSpM1ZfV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488344; c=relaxed/simple;
	bh=LO+xCwWtjmpNmSJ/1UMOhjAfE03LvKKAzdf94iY/EdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YsA/xdANfYY0Tu2E0oBm+dXqrZaCmDCbkUdgfYXuYNOYTR7QN2flnX9i1F5E2Hji+8rkVPL/GtI8WTQyji5bIEtsJjhW/z2U82cA92xRn/mx+JHKr3j14KeX5B/zNw61TOFb3dGZZ/fOp0XOEnVrZ0fYHqB95azepieRofW2XRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dxTBBiC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dxTBBiC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFC6C4CEC4;
	Mon, 16 Sep 2024 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488344;
	bh=LO+xCwWtjmpNmSJ/1UMOhjAfE03LvKKAzdf94iY/EdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dxTBBiC41R5sOr1v1F1jtL5tQdseL/NecNIwYTx1JboOfm12rkKrnb44RUNExw7T5
	 nAjODNdh/5ZLaejXHyRLHK9LKaBe+ki6Ru1OS7ckVMTtdqyFA+KulF1glY6BJbRM5e
	 uXKW2N4ZYetPftbnyC/f99Wo6A8WEYyNDa79CHII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 081/121] net/mlx5: Correct TASR typo into TSAR
Date: Mon, 16 Sep 2024 13:44:15 +0200
Message-ID: <20240916114231.831013108@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit e575d3a6dd22123888defb622b1742aa2d45b942 ]

TSAR is the correct spelling (Transmit Scheduling ARbiter).

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240613210036.1125203-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 861cd9b9cb62 ("net/mlx5: Verify support for scheduling element and TSAR type")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 2 +-
 include/linux/mlx5/mlx5_ifc.h                     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index bcea5f06807a..997c412a81af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -538,7 +538,7 @@ static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
 	switch (type) {
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_TASR;
+		       ELEMENT_TYPE_CAP_MASK_TSAR;
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
 		       ELEMENT_TYPE_CAP_MASK_VPORT;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index d4dd7e2d8ffe..6ffafd596d39 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3913,7 +3913,7 @@ enum {
 };
 
 enum {
-	ELEMENT_TYPE_CAP_MASK_TASR		= 1 << 0,
+	ELEMENT_TYPE_CAP_MASK_TSAR		= 1 << 0,
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
-- 
2.43.0



