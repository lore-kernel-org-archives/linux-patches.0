Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F112DF73;
	Mon,  8 Apr 2024 13:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581722; cv=none; b=tmoSJKsWJrT5Wckj45gZ2ySGzjLw7sxfXK9r3a1+KK3ZvGYh+umoC9ze8AJq/Wk3wHJQWYrDs0YiV4Jgkx+vaG9JY8IFi3vvwhtipvqisYpYU3laRkLk8lrLiqbftM7l8qELYln+yV5axe0SfAX9ZraGinFU+dyFSc+1QSbVWAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581722; c=relaxed/simple;
	bh=iIRyXzmrWUuM7a5YwAh5mDrtv2jzR2hU+oa1k4RT1D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBOPASQVwOzPb+WoE7vs8FdfL4kI9ASFA1Dho505TX7JUj0FvRTD92TPSg1oFDiND+4kJ8hUwrBDD01UKBifV+2PknWiQWvHFJByODvhfYG/2fQ7Q92ELVHt6x+FuJC0tx9w8jdmv2PUqND1ZJ45j5VeggnZd9vphliImXDzRbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sru1NLcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sru1NLcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5718C433C7;
	Mon,  8 Apr 2024 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581721;
	bh=iIRyXzmrWUuM7a5YwAh5mDrtv2jzR2hU+oa1k4RT1D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sru1NLcX56YtB9Jgw+XkUlwTQYXFZ8Nj2fG8m7I3+FMuCfEdLTn+C8YDpEUGFmpzr
	 2pwIdukpofCs7yXhylPA65d2umGgAgyaZ8Ecl/64YTUOBVWGwS6lNhA+sN8T2XNkP2
	 pixZP0xdfbV+g/ZWKafjZT88L09FNseWpgHutkuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 010/273] mlxbf_gige: stop PHY during open() error paths
Date: Mon,  8 Apr 2024 14:54:45 +0200
Message-ID: <20240408125309.606179771@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit d6c30c5a168f8586b8bcc0d8e42e2456eb05209b ]

The mlxbf_gige_open() routine starts the PHY as part of normal
initialization.  The mlxbf_gige_open() routine must stop the
PHY during its error paths.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 3d09fa54598f1..cef0e2d3f1a7b 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -157,7 +157,7 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	err = mlxbf_gige_tx_init(priv);
 	if (err)
-		goto free_irqs;
+		goto phy_deinit;
 	err = mlxbf_gige_rx_init(priv);
 	if (err)
 		goto tx_deinit;
@@ -185,6 +185,9 @@ static int mlxbf_gige_open(struct net_device *netdev)
 tx_deinit:
 	mlxbf_gige_tx_deinit(priv);
 
+phy_deinit:
+	phy_stop(phydev);
+
 free_irqs:
 	mlxbf_gige_free_irqs(priv);
 	return err;
-- 
2.43.0



