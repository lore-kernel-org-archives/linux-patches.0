Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4196C146A79;
	Mon, 16 Sep 2024 12:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488650; cv=none; b=rjCPnmkfNRYqgNaMV6XLlMFccT73dpkFGao2PY+LIA1UGPsBukYoK+wU+FnbfSciDOXG8Km2BbtPpkT1yvSoHMGA59VpsDBFb4VF1MW1rkfGdbjeu25Ca6YPuw3k9ih6LscGaT7srNgMknEbFln76SwhqRgQn9OYW7WNSDD1m6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488650; c=relaxed/simple;
	bh=qnvm8p/k9nkOvokFq5p9Aus7hgm8w/NIeJaCs9b/T2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeyY85Rp7mBLdiSAccTi+Kro+371U1EtiPLC0iW3NjfzT5CkhgvNkf4cQaltiMFkmg8thh4h12IJdDDqZXEczDtf/rLD7GFpyDM7t2g4X9nBSly1cCm4M5fpZY06OlJ0+q/PHzFOEHpPFd8dY9jB8D+RpuVe6sfAG8aMs1a81aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOKnY/B2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOKnY/B2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BB6C4CECC;
	Mon, 16 Sep 2024 12:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488650;
	bh=qnvm8p/k9nkOvokFq5p9Aus7hgm8w/NIeJaCs9b/T2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOKnY/B2CpgwGOdBvv1LXt7Ed+UtVAGZyR9z/K0gfdNQ8VVludJqj5R77O8VDPYxH
	 PkXggbY9/ccktzOfpp6KIWocrW0wAV288FWmone8uC7cK70uiF0HWGLYgODc91OqUq
	 huy1HO7KjjI5tcCkWlcmp1ep0HdInrRCc3BeLkCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 65/91] net/mlx5: Correct TASR typo into TSAR
Date: Mon, 16 Sep 2024 13:44:41 +0200
Message-ID: <20240916114226.629929699@linuxfoundation.org>
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
index 627cdb072573..f4cd6bb1870d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -537,7 +537,7 @@ static bool esw_qos_element_type_supported(struct mlx5_core_dev *dev, int type)
 	switch (type) {
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
-		       ELEMENT_TYPE_CAP_MASK_TASR;
+		       ELEMENT_TYPE_CAP_MASK_TSAR;
 	case SCHEDULING_CONTEXT_ELEMENT_TYPE_VPORT:
 		return MLX5_CAP_QOS(dev, esw_element_type) &
 		       ELEMENT_TYPE_CAP_MASK_VPORT;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 0e20d7109028..9106771bb92f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -3844,7 +3844,7 @@ enum {
 };
 
 enum {
-	ELEMENT_TYPE_CAP_MASK_TASR		= 1 << 0,
+	ELEMENT_TYPE_CAP_MASK_TSAR		= 1 << 0,
 	ELEMENT_TYPE_CAP_MASK_VPORT		= 1 << 1,
 	ELEMENT_TYPE_CAP_MASK_VPORT_TC		= 1 << 2,
 	ELEMENT_TYPE_CAP_MASK_PARA_VPORT_TC	= 1 << 3,
-- 
2.43.0



