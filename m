Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BD619DF73;
	Tue, 16 Jul 2024 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145277; cv=none; b=Hqxqn3ePYwArAx1QCdwwrID+wMlKh7mRivuctFcuatWkpaLLifGmLSVcmwCm/eFCULSAhTSTLeKD4ktycK5yhavEZOBpPk9TbqkYPjaV6XBF6aA7aRIs1se8tiVsIUB9ty40G2QGXFubUYTndnawC1mf5bLyRPNQ8xTgoA65unk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145277; c=relaxed/simple;
	bh=ortJVA7tcxjOxTS86XGooe3v9ZctGi5b2D6xvs4hmdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFRE5OeejNTb0f/anVoDhPzGte5Ho1D/KJxMeTI9l/SRiDlLan2CLK/46m8bSixKf3dl1qLuZXGNnydC9ebDsIPfPB4Z5A6IYU/qbgl4h7TUdD30F0780Tj2V9LdNPXRZvIn6v7G5HO6DlbK4SJsewcwWOUxB0oiZWkeWyE6pq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojGSPT1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojGSPT1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E33B6C4AF0D;
	Tue, 16 Jul 2024 15:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145277;
	bh=ortJVA7tcxjOxTS86XGooe3v9ZctGi5b2D6xvs4hmdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojGSPT1n3Qf942KTBWPjWn+JEnjvMsCICSjLJFKD7q5HDgf308Nb8dyy6j4Dxe9uW
	 oZAJMvc/ILYwi7WfinlN/wXrwLNIYEQYGGWC96zs4YTgVgPAsFeCpb7FHp7CDogI+8
	 1nD+98YsD40nSEuJM655hqRsbdO3C8g9zE1Vzi+0=
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
Subject: [PATCH 6.1 13/96] net: phy: microchip: lan87xx: reinit PHY after cable test
Date: Tue, 16 Jul 2024 17:31:24 +0200
Message-ID: <20240716152747.028029770@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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
index 8569a545e0a3f..9517243e3051e 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -711,7 +711,7 @@ static int lan87xx_cable_test_report(struct phy_device *phydev)
 	ethnl_cable_test_result(phydev, ETHTOOL_A_CABLE_PAIR_A,
 				lan87xx_cable_test_report_trans(detect));
 
-	return 0;
+	return phy_init_hw(phydev);
 }
 
 static int lan87xx_cable_test_get_status(struct phy_device *phydev,
-- 
2.43.0



