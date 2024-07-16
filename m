Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2242F12B72;
	Tue, 16 Jul 2024 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144869; cv=none; b=OxngXfS7n9rv/lJjplifSnOQVQbzBvkVmyGIeAcQkTzUsMDqLELy1AeOB6LRqsBUk9bPb6bUl0l4xY7rU5aQEIGPO+F58qXwPDBChoHVyQRVhFu8Kdkb3qryAhCDSrZwV8FDgstI6aAGy+CykOEZUyC4qiqr2BZbcvLrBQHEBro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144869; c=relaxed/simple;
	bh=1D7yABu7Cc+YzJUoGhEP92U/U9KcksWK0lxDIiPjEq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i3H8w6Flo9sBEQxlhJebWvYeCj/syXmQIB4G+zyJc996ZXl/zZreWXgsElV313F7A9E6e5DrIMbc2eqzovwQYhi9Q6J9SaqoYZQ4xlXGioaHc0cAzjRqHvCmr0cqoOx0iqbcqY4j2E5GoS+POoxFtzwAiWB4kD+xR+7OPwXRrig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kerKlom+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kerKlom+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F2DC116B1;
	Tue, 16 Jul 2024 15:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144869;
	bh=1D7yABu7Cc+YzJUoGhEP92U/U9KcksWK0lxDIiPjEq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kerKlom+2r2OLru2q6IODLX+81tTtNbBRb3fjqU2IAYXWrkQ8/It0MvyUfM7jL38S
	 I6/I+VzLHwEBIQDffmNCNFbTDJK/9mMaNsH5q7Q4BBnEl4+5g2+cwziqEZYJ4hkksM
	 TSMz54qTxIKzcX84UO3ncpe5odcPBr9UGsqGQszo=
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
Subject: [PATCH 6.9 022/143] net: phy: microchip: lan87xx: reinit PHY after cable test
Date: Tue, 16 Jul 2024 17:30:18 +0200
Message-ID: <20240716152756.843135523@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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



