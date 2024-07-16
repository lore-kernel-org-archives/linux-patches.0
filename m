Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2479C1DDCE;
	Tue, 16 Jul 2024 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145717; cv=none; b=mgBB7rkPQvbgf1kez5yFFBw2mqVDHHOyXsUuJ5J0IOHqMuiwQfA8nsfqZYJdyqEMwI2pQaSofqpBSDJquU5A9Lg+1xzZ4GoD1JNTYB/Mj+gnaBQpNSLX6m55ayzxtKBUZbTrXdH8Qa1eQeqBxXK8M1OAFWBqzx/baBJW+oxIeaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145717; c=relaxed/simple;
	bh=F79a/6w5xhpyLujg5nGRPik6FPtpGCA3F2nIm+m/1dc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5eNeFUaW72n2FtSqvfSq3zZ9HBy43ARxtfyVS6tl5SwXA79UvIBkOPEWeEhV03gh2G5BBaYwKKmAxy2ul//BJ7ZggrDPnD+HJPwS8WPcanz3adMWmsCFf9iZvMC5XFS/qm6gJCBfuUzjPBznJdsTG/a2TdtfW3n++i1/o0ch5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B068Iwbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B068Iwbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE67C116B1;
	Tue, 16 Jul 2024 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145717;
	bh=F79a/6w5xhpyLujg5nGRPik6FPtpGCA3F2nIm+m/1dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B068IwbownILMzlm0QaCuaWqrDfP3OHYi2Kk7fxT8sICX+02wxGpjtQ1olsecj6rK
	 sFqCloDg96kDPRclITRnCqPWOgKloF5KFNA00wN4e2AkhEViXW/Kbk3klOTlE8qSb5
	 NcWrF/BRf+kDLKdnYWYPmMZeYY2piVTqvqPgQglE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/121] net: phy: microchip: lan87xx: reinit PHY after cable test
Date: Tue, 16 Jul 2024 17:31:22 +0200
Message-ID: <20240716152752.097897551@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 30f747b8d53bc73555f268d0f48f56174fa5bf10 ]

Reinit PHY after cable test, otherwise link can't be established on
tested port. This issue is reproducible on LAN9372 switches with
integrated 100BaseT1 PHYs.

Fixes: 788050256c411 ("net: phy: microchip_t1: add cable test support for lan87xx phy")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240705084954.83048-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/microchip_t1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index a838b61cd844b..a35528497a576 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -748,7 +748,7 @@ static int lan87xx_cable_test_report(struct phy_device *phydev)
 	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
 				lan87xx_cable_test_report_trans(detect));
 
-	return 0;
+	return phy_init_hw(phydev);
 }
 
 static int lan87xx_cable_test_get_status(struct phy_device *phydev,
-- 
2.43.0



