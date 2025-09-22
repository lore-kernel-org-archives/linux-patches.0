Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27017191F66;
	Mon, 22 Sep 2025 19:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758569529; cv=none; b=VyCylHGFxFG06U7NPRDewGmrJ4Kf/RJfZv8RgY7qj+No6qYLEnXoiQxwT+SnR6i71mCumnRaGn9GoerrtMTXh5b6Q31sJcBPUe//IoFAE4vA2rqd9yMWrC6dMyGEANjjJo5qX/lsogTjUN4J9rjEhKXGYvu1V5fDoygscVrN+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758569529; c=relaxed/simple;
	bh=SFxuIkJHHj5mObC53j57kirRiwTj+ObIThVbx6b+M+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBN118wR7yRXcM68H2IYZkT0Zn1fdw1yCzJuPkKRd0PYkZhnO/+ZMR1BGSYo7317cN54X6VbtKtTc0M6c9cXtBDZ144OCJIxLJR7tLZKhvbjxX4wbyxE9Ya7rjCtl9IOz3Kit7CeOccGwXmxk1qCDlCXULOYI0iBDoDHhvqeRzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/Xs1uJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/Xs1uJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37EFC4CEF0;
	Mon, 22 Sep 2025 19:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758569529;
	bh=SFxuIkJHHj5mObC53j57kirRiwTj+ObIThVbx6b+M+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/Xs1uJmiEvC02jlVGZAosgppuwnfGstNOLoKcSv+upPcqDuieiylzidRmCiVWfoE
	 LVgI7hkMoI3FM+07dFn5y3Nc3CNz0AmMIL8L17pW4sYF6iofUzZ3MFa4rjQFfQsCfF
	 Di+Z1VA/FfMmEbWbJCBZZyz77aZVO+68wVubPUmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 16/61] Revert "net/mlx5e: Update and set Xon/Xoff upon port speed set"
Date: Mon, 22 Sep 2025 21:29:09 +0200
Message-ID: <20250922192403.993876459@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
References: <20250922192403.524848428@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ae3a7b96f7978..7612070b66160 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -107,8 +107,6 @@ void mlx5e_update_carrier(struct mlx5e_priv *priv)
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



