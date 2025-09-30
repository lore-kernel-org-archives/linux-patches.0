Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2391F1302;
	Tue, 30 Sep 2025 15:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245120; cv=none; b=coMInu31XNFsZTmDtLSasmjlxraJKgdtmzPdi1RX6Ki2l6HgTaNLAcbtYAXf0KYrjjAfIfVNSiLAfaQDk8R9BnQzAFcR/iFjY79euFX0BP9AFt/iPdA1A3CL5pm2rRW5Y00T5FvNCojNw7pWnBh8ATBJniiTro9e46QG49o8JH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245120; c=relaxed/simple;
	bh=YSsePNlVQPEirLdZ52KaynVAN4r5XjFVIOhrDCc7iSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4NzL1bd3YpvqtRp9L8OFRlZu70OVRKqIx3GBVKK0hDqOpSPbyXFzhH7hyweLegvPr3y45FFyOcPKlWc6PdYINgOHMroHWuKFwTpuZ+g2TXFiOjmiboVbwjTETkWIMO5Uj8I2o17pdKi0AZHkMQsXAHEvea1d8HmmC3IJQMM0Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o6BUS9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o6BUS9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6C5C4CEF0;
	Tue, 30 Sep 2025 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245120;
	bh=YSsePNlVQPEirLdZ52KaynVAN4r5XjFVIOhrDCc7iSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o6BUS9OEUDbRrnjdinqbEcHDhvBSSWqsaLR8TZkT3ZH5gJL5JmBuqp4LKjMeo7P2
	 NWa8Na4+XEJg+2qCM4tpAZaMPN4f/9wnjvfdmvLRsieW7DmVse0jStci4KrJVTduMs
	 dl8AnQisqLgPx3v20QmqvXsoZtWv5P/9uyzGeJEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/151] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Tue, 30 Sep 2025 16:46:45 +0200
Message-ID: <20250930143830.584059692@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cfbc569edfb5f..bb7e3c80ad74e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -104,8 +104,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
 	if (up) {
 		netdev_info(priv->netdev, "Link up\n");
 		netif_carrier_on(priv->netdev);
-		mlx5e_port_manual_buffer_config(priv, 0, priv->netdev->mtu,
-						NULL, NULL, NULL);
 	} else {
 		netdev_info(priv->netdev, "Link down\n");
 		netif_carrier_off(priv->netdev);
-- 
2.51.0



