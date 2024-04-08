Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73167D07C;
	Mon,  8 Apr 2024 13:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581481; cv=none; b=C71iE2NYbuduUrb3Rk5ZDG79LnkeuNGHGTDahM2A5EhoF3WG8+QT/Ki7DE1LqN/b5KrNmYMIq5GHqBQFOTKokodn6C5fkpAwqbLiPbAN9qjxvH/6Ch87ceR0Trx2NoXbTCQATcJHGO465vZaavwfMq/nQOriFhxbzr6f2RxI2yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581481; c=relaxed/simple;
	bh=ZrcSx/KkmNkc3+hbvHsOL9rLbblQbJAYx6jvfGD6MLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QflmNy7fBilGZBmYrGlwUKPCR9nmJniOSrruqWyusSdd1e7OHgXXRXwTUbO5ySkTcbjpUcU624KLi4HNjX2BTUTSC5JZoHy2jdiIHuIFmBGqAXaP9XsxBPdBhOl+EUz68CgR3Ds+PQM5Le5euexbsBUTYU2v5aQkaRa/I5poCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBzNnvQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBzNnvQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24451C433F1;
	Mon,  8 Apr 2024 13:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581480;
	bh=ZrcSx/KkmNkc3+hbvHsOL9rLbblQbJAYx6jvfGD6MLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBzNnvQkrAGm68lb7m60Z7IhHenGVlACo/UEFQtyWTsxBbXeJCKF/rUqlEWr76zya
	 V50yP+WFc+gh2gEUki47ViyRwsGIIYgwAJHHRLgY2LWXmruzogaXteY8vjHwC49gQ9
	 tTXwWUhERidA9iyVlvt7RMkKQyVpnZvc9WZVThO4=
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
Subject: [PATCH 6.6 010/252] mlxbf_gige: stop PHY during open() error paths
Date: Mon,  8 Apr 2024 14:55:09 +0200
Message-ID: <20240408125306.966896863@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index aaf1faed4133e..044ff5f87b5e8 100644
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



