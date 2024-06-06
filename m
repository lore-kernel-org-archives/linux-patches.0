Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4068F19EEB8;
	Thu,  6 Jun 2024 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683548; cv=none; b=XWknk/d1IYth/qMclNwllzjIy/vvXskJA5WDAGRZKA5O9dDFGijHwrImavj+aNFpvO6jUeb5Y2yTV5HIXA9ige4wM532mOOUk/qlHkDcz2eRxvrB8M4agRkgmxfu/wEW3KoVmTt7/iMqYjbFNxQgjeJmppI4KKJi7EWjcbm1d3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683548; c=relaxed/simple;
	bh=I7YeMXC2IR6Li1a2/2ebjVp9rmYzNYJ22OorKvtoCYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DxpMO0vkoRE8GcNFHG5wQPhgR7hT+mdXb937AMSVJ1rBC5aixSmUV5qHUQrtML6Z3RdoY9tnpmVcI2dYetZC5RVelpaoU8ATUGeXdS5YWfWDOGUM7k7oU5ocf6eG9oO2vhShkYPsONNwZCnVLIOaN02rrjN/sj2Vytj+TKhg+Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oBUWBKS3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oBUWBKS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E03FC2BD10;
	Thu,  6 Jun 2024 14:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683548;
	bh=I7YeMXC2IR6Li1a2/2ebjVp9rmYzNYJ22OorKvtoCYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBUWBKS3LCBJpsJaFwRL3Eqv7o251ZBK+HS4ZlOcOnDVO5EcJKipksTVWl16mOiPe
	 ycYosLQUpl6/v9Ps2M+XNs+3fcGa/QRB6hmr3e3kQwjBOIxGtT+NZhkhkmQLPr5k+v
	 1hiVjGm0JUI6158Tf3e2vvGZqQ9t7aVnOuUEUekg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karim Ben Houcine <karim.benhoucine@landisgyr.com>,
	Mathieu Othacehe <othacehe@gnu.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 437/473] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061
Date: Thu,  6 Jun 2024 16:06:06 +0200
Message-ID: <20240606131714.181226320@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Othacehe <othacehe@gnu.org>

[ Upstream commit 128d54fbcb14b8717ecf596d3dbded327b9980b3 ]

Following a similar reinstate for the KSZ8081 and KSZ9031.

Older kernels would use the genphy_soft_reset if the PHY did not implement
a .soft_reset.

The KSZ8061 errata described here:
https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8061-Errata-DS80000688B.pdf
and worked around with 232ba3a51c ("net: phy: Micrel KSZ8061: link failure after cable connect")
is back again without this soft reset.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Tested-by: Karim Ben Houcine <karim.benhoucine@landisgyr.com>
Signed-off-by: Mathieu Othacehe <othacehe@gnu.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 2cbb1d1830bbd..98c6d0caf8faf 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3245,6 +3245,7 @@ static struct phy_driver ksphy_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.probe		= kszphy_probe,
 	.config_init	= ksz8061_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= kszphy_suspend,
-- 
2.43.0



