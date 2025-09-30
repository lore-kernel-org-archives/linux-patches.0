Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A183C465;
	Tue, 30 Sep 2025 14:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759243857; cv=none; b=PQwG+tVe/FYQ+3/cU4Ck615zEIpnKnb9KoKmZaHxLyz0sgpr9ZJzSh70c8CPwuAROzzeFEfxxKC07Kl+63lIg1KqyCc1Ix1DWZv3IagiL6cSOFfoYu1gZhVPIQDWjOhhzY0jp7VxgWveUQXn7xMp2C1hDTZAhPiplWdJ/bEB8Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759243857; c=relaxed/simple;
	bh=z9p5kl1cqf1HolKJNVzf0VcELEnJvvwAaDvKHQb5caw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdWQi7Iefxsw5s8rRVS1wZA5uhOR/eG294x7JfAJYVgyC859U3KhAmzkioDnlVkF4wpCySctGT39vo+YGAzM9CiP9hfDTVY3RMYPTbtCipXBtLl9FYhOsjAzaZDU7GeKV0EKpOIbn3e56WR6BZM+u6PTv5CZdI2TE/P07xwsmW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CeE0G2Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CeE0G2Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77409C4CEF0;
	Tue, 30 Sep 2025 14:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759243857;
	bh=z9p5kl1cqf1HolKJNVzf0VcELEnJvvwAaDvKHQb5caw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CeE0G2Qf9xZtLbqcFQE6uqpl52gja6OiqBzN1szF2WKvRsNLcGrXbGtw21cTdI9D2
	 N6Eh5g9M9PbAeCkbY6SYNmjqi56AKENBjMmFT4ymyMD5E7pL5iSKoq5ymcgCdsF72F
	 EYBl4KPnhfase6incU4wRMYij7ECNru8T8q/zQm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 38/81] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Tue, 30 Sep 2025 16:46:40 +0200
Message-ID: <20250930143821.268808804@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143819.654157320@linuxfoundation.org>
References: <20250930143819.654157320@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b8d0b68befcb9..41bd16cc9d0f6 100644
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



