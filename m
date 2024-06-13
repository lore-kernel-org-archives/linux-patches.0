Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920F8384;
	Thu, 13 Jun 2024 12:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282536; cv=none; b=g9V/QooOEvwwgmXRTXuZz7c1jrhPVXmzWtHd3uCVlZYVktXGovwRUVCFfWQdPG5NlK4pVXPZC7ix2bhIETv931SX/5ofecgsqQBkUQgI08LOKuxIclZmbV4Pxx/PrOsrBZVpwTK5WM6Sel7/r/faHKXa8aE+Ml3x4Um8pdseEgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282536; c=relaxed/simple;
	bh=3+QtWgQsT8Yy5u1nS440iEu1HYqRvAomFUTeq0ELl1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLSv1I3lehp3sGyv68BexLsaq3nrukzwiOF7Ksuq3Ko+nfKqgcyynHTCB5uKh4FcN3nv+mMZDS4NY42KQcjP1/8VYKJY04+VHi2xjGR2nb+jCSvHCt2XaFLALYlnHOg+6VNQYFhlrG1so+IZ8MTetwUyVdwVsYH9Qo/YLuWo5G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgAYqWpo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgAYqWpo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C62C2BBFC;
	Thu, 13 Jun 2024 12:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282536;
	bh=3+QtWgQsT8Yy5u1nS440iEu1HYqRvAomFUTeq0ELl1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgAYqWpoXnXRDfe5bsowuzQBxoAsL1nxsBWJ8+FOip+DdyT06Q/LFzFwRlF60zSG/
	 xNfMrKH+FuWiqIJ+d/ZonDMlGC4DNyeh21jMxzcy6P0PFHdl8NwZ7G8Hvp/Wfx/tIj
	 3NDcV0FfZgrQXP2uvZBICEibd2qYFpqjRDC7NPRs=
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
Subject: [PATCH 5.15 310/402] net: phy: micrel: set soft_reset callback to genphy_soft_reset for KSZ8061
Date: Thu, 13 Jun 2024 13:34:27 +0200
Message-ID: <20240613113314.235657183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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
index dc209ad8a0fed..59d05a1672ece 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1669,6 +1669,7 @@ static struct phy_driver ksphy_driver[] = {
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	/* PHY_BASIC_FEATURES */
 	.config_init	= ksz8061_config_init,
+	.soft_reset	= genphy_soft_reset,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
 	.suspend	= genphy_suspend,
-- 
2.43.0



