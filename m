Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC39883CD9;
	Wed,  7 Aug 2024 15:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043025; cv=none; b=bmYUxvVfMkGwN/T93plQyAasLwLDgfalpt/kmIYpUF7ATT7FF8F+5Hy4HZtsiEzgYRt0Ervd+nBLnVK06nTHwZpNkqTjN7vrZtFQufJ99iLUGZHYHPD14A9yIkrr395Mz5QR0VvK62kGUxU30qSKR1PeeyrZchbfsT1Ci10V11g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043025; c=relaxed/simple;
	bh=6gbVMu9lcGPZMyWYlDNiom+OxGZ/tq7cUZ1MgaecRUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3I353D1BQJ/dVNHn1KYDPoDB68DgjhC+K0QHwVgfoJDz5T1Ep4pz4eDm/TMPGNiPDuO98jZ2DPlYWreXcdHf34AUzXwyUXRVXhQTARiC2tdSR/M/K/zru2zw+CPlH8/BtfPBgTceoRBJ8aluzjS+tIwKtLl0ZWSp/xh5VoMx6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V489JeBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V489JeBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C540C32781;
	Wed,  7 Aug 2024 15:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043024;
	bh=6gbVMu9lcGPZMyWYlDNiom+OxGZ/tq7cUZ1MgaecRUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V489JeBGmDC3I8w6Gic6nIv7JeqKdfyz3yMljS/LStFJcLDgVO5S9UZKbAlfDee9e
	 +99S5bFLQ+vQNW5bi3Y7rTl54e/67Vs2d05aRDMfnkPLnYzra25UlT7KlrpoLwPt5H
	 KJf06E8Pu65fJZ09lJg2zURZ0+u/7bU4ozJiKx2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 061/123] net/mlx5: Lag, dont use the hardcoded value of the first port
Date: Wed,  7 Aug 2024 16:59:40 +0200
Message-ID: <20240807150022.766524825@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

From: Mark Bloch <mbloch@nvidia.com>

[ Upstream commit 3fda84dc090390573cfbd0b1d70372663315de21 ]

The cited commit didn't change the body of the loop as it should.
It shouldn't be using MLX5_LAG_P1.

Fixes: 7e978e7714d6 ("net/mlx5: Lag, use actual number of lag ports")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-5-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index d0871c46b8c54..cf8045b926892 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1538,7 +1538,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 		goto unlock;
 
 	for (i = 0; i < ldev->ports; i++) {
-		if (ldev->pf[MLX5_LAG_P1].netdev == slave) {
+		if (ldev->pf[i].netdev == slave) {
 			port = i;
 			break;
 		}
-- 
2.43.0



