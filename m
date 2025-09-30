Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C67A201017;
	Tue, 30 Sep 2025 14:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244299; cv=none; b=YNxokdURyGFW2hENfigruuMLKDFMeUmlsaagubFM9Ldwi2YX9XOASufy/KR6j8s97Vtz2dMadx8rWMOXPD2ivpOWvW97UuYaJaSxk+2qClmpuZTshycw4+qtNwmmz/QUlVSzvbU3VOJuBLOuEc0HYNyR0RuhPHZp3CL/djEFZwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244299; c=relaxed/simple;
	bh=Ia0+YI/a8Px20OqBPujKWpYnDkYsRyPd8eo/N34qFMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg/KtaLr29enswXdHHzcPeLjchCbEo/ydPk52TtzNZlSHlyPDYWvXg4a3WTVLiTrqPYle6OTjChJgnRrypxqNu+tptFtUkgi467cIYx7kziW5pDa7jJF+ToyMMUrCWlF6GwAtquNx2I7hXg+qVP3LHljFYCzh8WgZi+Fkw1X8aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t+gPC19d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t+gPC19d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C9FC4CEF0;
	Tue, 30 Sep 2025 14:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244298;
	bh=Ia0+YI/a8Px20OqBPujKWpYnDkYsRyPd8eo/N34qFMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+gPC19dTBWCrs15ijNXSrByxpfwSl8vqcvJeEDXaaTzAbf9CPzy1o+TyeTcOmKwO
	 sKXNiN+8zdwAULkbHry6aPnbo90BlussBNpNOewAqmwYZINl9J/BkDGTBrBM3W6wJ9
	 uALHpX8sW9bbHW8ZunX5/Kz1o4aMi+oh1CjlAYF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/122] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Tue, 30 Sep 2025 16:46:26 +0200
Message-ID: <20250930143825.249734376@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tariq Toukan <tariqt@nvidia.com>

[ Upstream commit 3fbfe251cc9f6d391944282cdb9bcf0bd02e01f8 ]

This reverts commit d24341740fe48add8a227a753e68b6eedf4b385a.
It causes errors when trying to configure QoS, as well as
loss of L2 connectivity (on multi-host devices).

Reported-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/20250910170011.70528106@kernel.org
Fixes: d24341740fe4 ("net/mlx5e: Update and set Xon/Xoff upon port speed set")
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index cc93c503984a1..cef60bc2589cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -141,8 +141,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (port_state == VPORT_STATE_UP) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
-		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
-						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.51.0



