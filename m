Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1796C2C15B2;
	Tue, 31 Mar 2026 16:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975837; cv=none; b=RZRosPfbEB7rjWMGsESEZayuHvMdSDsb3YscnnmMB3B+7xsOCGaEQi641MbK7OnU8SdohsmkNHvKGvxXtcLaf+DFJ0xp3aF6jePKY4K/T88H9+eGPiEW17h8zlnfJPipkFX5WQ8ZZJIhgBFG5po61TQlVoRujYDGop3HOoaXLbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975837; c=relaxed/simple;
	bh=VMN0Lx7FcABMsEwitBEyCb1Ge5OTV/JuH3gFoRhyf6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XixHpxXisZvpoVCv4w9c2J+GRhk3MLVVFwF+B0u9b8kUoAm7n7nIeWkG8PiG9nGnfhQZ+PDwOz0+OPcqBMq6ntVDx0LdbqYpp66m/09AChhm632LCbAod1EYNVpGhWkIFN0xq818jdM4fKXCWFJB9VRtCcKGQiuQGFa6iYmRd3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2eCYU4R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2eCYU4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16C9C19423;
	Tue, 31 Mar 2026 16:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975837;
	bh=VMN0Lx7FcABMsEwitBEyCb1Ge5OTV/JuH3gFoRhyf6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2eCYU4ReZQy2vlCC4dBpBbMgf1gLNe7vsynztAUEW1+CDnSSgziG/sn1/KfQkbj1
	 tKiWJiIVHqOEbH/2mYaneRlZKdFxCcFIlQuR5UT4rN9IfSB84RfHHYpfxDY2lkHy+G
	 j6TaN4dcN7EFHUofmgsgwGqq7v8IrQ9LqvEA2qkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/244] net: bcm: asp2: remove tx_lpi_enabled
Date: Tue, 31 Mar 2026 18:20:23 +0200
Message-ID: <20260331161744.383117448@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit df8017e8a19d72b48abfe02b8611a5c8c7f89e22 ]

Phylib maintains a copy of tx_lpi_enabled, which will be used to
populate the member when phy_ethtool_get_eee(). Therefore, writing to
this member before phy_ethtool_get_eee() will have no effect. Remove
it. Also remove setting our copy of info->eee.tx_lpi_enabled which
becomes write-only.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/E1tXk7w-000r4r-Pq@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: cbfa5be2bf64 ("net: bcmasp: fix double free of WoL irq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
index 256577f0f2170..73334ab526136 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp_ethtool.c
@@ -364,14 +364,9 @@ void bcmasp_eee_enable_set(struct bcmasp_intf *intf, bool enable)
 
 static int bcmasp_get_eee(struct net_device *dev, struct ethtool_keee *e)
 {
-	struct bcmasp_intf *intf = netdev_priv(dev);
-	struct ethtool_keee *p = &intf->eee;
-
 	if (!dev->phydev)
 		return -ENODEV;
 
-	e->tx_lpi_enabled = p->tx_lpi_enabled;
-
 	return phy_ethtool_get_eee(dev->phydev, e);
 }
 
@@ -394,7 +389,6 @@ static int bcmasp_set_eee(struct net_device *dev, struct ethtool_keee *e)
 			return ret;
 		}
 
-		intf->eee.tx_lpi_enabled = e->tx_lpi_enabled;
 		bcmasp_eee_enable_set(intf, true);
 	}
 
-- 
2.51.0



