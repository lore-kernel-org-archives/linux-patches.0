Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB008287E;
	Wed,  7 Aug 2024 15:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043461; cv=none; b=mEptzasDXoqNtxW422DDZGevaMohq0/2jdJ+TRl+d68r0MJFuTGXVyu5P9Ou35ubG+ZH3XQ+k2lJH3l+6TRH1GnbgYeJWrjJJ+eZDeBlRJKc3Phcg3dJcsdjCwhnIT0BazpCJ85ouWNDDOHe3JSdOYs5TZnlrZWXAiB0we+o1yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043461; c=relaxed/simple;
	bh=lAsxR8lkjcGWL4zD1grYYzXNRNvL705x+K8axm7TQTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktV2OnBxRIJxDyBYtkS45UIwzepf9HutjFB9tV0h/6MxjzZv4RokTibaqtpKfSbyYySEqsdNLjFXwDLRGoxtU7v5YqjV1lC141jaGf2HvQJgWATqF4Pga8KuQ/B+04FVMNxT0JCQ4WCVx/sEnfLkEfKtphtCqmA6pEdNDcokMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JhczJNiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JhczJNiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF9C32781;
	Wed,  7 Aug 2024 15:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043461;
	bh=lAsxR8lkjcGWL4zD1grYYzXNRNvL705x+K8axm7TQTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JhczJNizWg4RVHSTY38Kl+6xzAsd/M+Qbr+cHW6P29QxtiGRNUHfQ81aJd/7k/MFY
	 yNZRoGrWTyteiLXhcStIKImWQmukYLQ5L/vXm4+R5gsmmKMHWkgX5fe5T5zLpXyV7O
	 kkrDoNH5HPSf0dFOJ5aIaX8dgHIqUnmgI+DJ+p8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/121] net/mlx5: Lag, dont use the hardcoded value of the first port
Date: Wed,  7 Aug 2024 17:00:14 +0200
Message-ID: <20240807150022.096043401@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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
index dfc2ba6f780a2..18cf756bad8cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1512,7 +1512,7 @@ u8 mlx5_lag_get_slave_port(struct mlx5_core_dev *dev,
 		goto unlock;
 
 	for (i = 0; i < ldev->ports; i++) {
-		if (ldev->pf[MLX5_LAG_P1].netdev == slave) {
+		if (ldev->pf[i].netdev == slave) {
 			port = i;
 			break;
 		}
-- 
2.43.0



