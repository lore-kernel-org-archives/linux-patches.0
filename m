Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187007DA7D;
	Thu, 15 Aug 2024 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730310; cv=none; b=sxrOb2eardY/heeuLUzFt06yDx7TJpDInyGWdGSWpsg+h2hXNDVYgpJsO58pwVpjuoUNzBNoZQ+Ybn5IgBCLyajM+5uCVpAFUY/WlUSk7ufrzwyC24d8SczQnQK9tBQtj4p+VjY+o3B6Ew7FLIwXNTagi5eDVJK1eYSrmMbUhKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730310; c=relaxed/simple;
	bh=mITI4jZHmpodd5tRUm1PDoQmYA1bB5uoaCGG+tXFbvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toKBNqjLs1fNEm84RxgtnujQ/cZP703I0cLiB9wZ9C53SN942AGspdwMHaaBxXKYg8BGdSZfH6pofT4ILXngS5A16U91OT9g6psFDBVXUfBPuNPMTrDU3sqJnpvN7hb85VgKm3voULECjHjkn9AV9Q9oOVD5oopxTlstQRwfABk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrkyF0R4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrkyF0R4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DFFC32786;
	Thu, 15 Aug 2024 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730310;
	bh=mITI4jZHmpodd5tRUm1PDoQmYA1bB5uoaCGG+tXFbvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrkyF0R4gqNXA31U7K9v5QQtB7I6Zagf5C7h1C67q89XD9X8VowLb7uZsvtLfevVs
	 /kpH8luI3KzQ8OdjkvNzZU0VPmPCYND9RmFIRzf/LWQRioWECJ1uWw8YcfV0Mck7G2
	 4ddxcubPTnClXERRZgZljWUp4zvzN99g8gD3ECL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/484] net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys
Date: Thu, 15 Aug 2024 15:23:16 +0200
Message-ID: <20240815131954.468374797@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shahar Shitrit <shshitrit@nvidia.com>

[ Upstream commit 3f8e82a020a5c22f9b791f4ac499b8e18007fbda ]

Since the documentation for mlx5_toggle_port_link states that it should
only be used after setting the port register, we add a check for the
return value from mlx5_port_set_eth_ptys to ensure the register was
successfully set before calling it.

Fixes: 667daedaecd1 ("net/mlx5e: Toggle link only after modifying port parameters")
Signed-off-by: Shahar Shitrit <shshitrit@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Link: https://patch.msgid.link/20240730061638.1831002-9-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2d3cd237355a6..06f6809b1c2b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1181,7 +1181,12 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	if (!an_changes && link_modes == eproto.admin)
 		goto out;
 
-	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
+	err = mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
+	if (err) {
+		netdev_err(priv->netdev, "%s: failed to set ptys reg: %d\n", __func__, err);
+		goto out;
+	}
+
 	mlx5_toggle_port_link(mdev);
 
 out:
-- 
2.43.0



