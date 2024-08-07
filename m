Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8170982499;
	Wed,  7 Aug 2024 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043078; cv=none; b=TgNqazrMJZWrq0y9ckBbv4CZQo+kbZ0n3+xOUy4Kvo0G9dpd3CE2mz4gtZpSeNye5jPaaChstl3s2VM7GjbrtDqKNxlNLr+wAWizXKU/MJjf9aBS78DgFUSjt4ZH7RxPNJ47XPUplL6TUYoKlEo+wtEmAbkDbsgyzuqaeJwdDMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043078; c=relaxed/simple;
	bh=8ajvqQV4C+wbq3F6jkDO6eupCgElEcXcazUPtAUHtz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6qFRSIjq7VWKmaXy29pkfwU99u26ZNeDXoKweq/X9GErejgTZ7+5l6jA3kjoPXjHMyajoViEmREbZMbhlzoajaaGV0P9WEIvMu9uB4QcqPIb3pJ3dpWha+WxAxzm2h3RH8iu4dA23xWb/Wu0RwTKILWxVXqW+p6U5YeLrdP4s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3DpYVv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3DpYVv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FFBC4AF0E;
	Wed,  7 Aug 2024 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043078;
	bh=8ajvqQV4C+wbq3F6jkDO6eupCgElEcXcazUPtAUHtz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3DpYVv+0SXjC8XmxN0B2fzHUkA76i7Y/9tnawmehDiNrrEBvUlQLr3IeMt0VkmOc
	 dR1Zo2IvOWnW2pEqCeycgipuGM4Djeb91Kmt5rQALRam+wY5nQipfiDb/ToU6C5k0z
	 WHqQZabFZm45BSPwyplsN+7nPj9f6BS5ZGCl0F+c=
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
Subject: [PATCH 6.10 065/123] net/mlx5e: Add a check for the return value from mlx5_port_set_eth_ptys
Date: Wed,  7 Aug 2024 16:59:44 +0200
Message-ID: <20240807150022.900860301@linuxfoundation.org>
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
index 3320f12ba2dbd..58eb96a688533 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1409,7 +1409,12 @@ static int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
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



