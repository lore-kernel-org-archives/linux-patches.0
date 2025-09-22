Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506872820D1;
	Mon, 22 Sep 2025 19:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569893; cv=none; b=YMEPYvtMG2IgC6x2p1S3zo0smmnmUVk1WVJ6RhUMg3lBwRrfHlz84dEBwaIEdmCUfJX1XGk7RjPYLtopGENmQZ6ew1qqX5EYrTn2SYzhsRfTp1mzod0sejwWMFxa+7jn+wf0d8cRRwg2C/jtDKC3b+SPs3EUu1WGJKIl7bBF0W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569893; c=relaxed/simple;
	bh=VKlEI2KIu+zixvANU1fMBH4xVsWZD5fjHmfVN1qVvfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0lRT9HuxPtw93YqbkqU981WrYjCyNvcn32sn4mpgoxojgwM/0d2CQgGag1ju1JLhS49NS2oo+BC0gXKmkmzV//Tp1y/e9/oisZNhJC6+sdcKjiU9uOzP/TfaTqdFPI3nIKcdt5yUNOG6jIoBeuOD8KFbXMMnRkqOFhQlDOusYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oBujByc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oBujByc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA7FC4CEF0;
	Mon, 22 Sep 2025 19:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569891;
	bh=VKlEI2KIu+zixvANU1fMBH4xVsWZD5fjHmfVN1qVvfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oBujByc7uHysAE1mQm4+FI5kkCpFIkLjMH3I3Rp0q6lYM2V1eELbirNKq9CVLrey
	 3he3v8O13ZlcAI9tov8K7g63TDiE9aP9Wrq2DIcPURU4yDcitplu4n9PSDI3Aw9/Cf
	 N7OZPSDFEdemwVh8BHdXKAAJW/+saN8pYmIzGAOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/105] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Mon, 22 Sep 2025 21:29:12 +0200
Message-ID: <20250922192409.675171117@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
References: <20250922192408.913556629@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6176457b846bc..de2327ffb0f78 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -135,8 +135,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
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



