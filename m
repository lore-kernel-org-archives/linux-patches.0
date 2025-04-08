Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1710826AABC;
	Tue,  8 Apr 2025 12:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116721; cv=none; b=qalJBZT4nWCNKDTyTbeIeSKQkSRpMZHw4mtCACUefd1QhBavJ3S1YhDP96k9oaVlE1fct8QhFnNqIVleoMRqMrYnDIhAb+UujtxrAwsBxzv4ojy53xcOEGTx4bDetKZEw2uUMiQoJp0mobej3rR6qMD0atuY376IbBmC1fpFqyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116721; c=relaxed/simple;
	bh=iB/WxQikY+OJUrHTfA6OrIOrALSbrdliI+1Xzdci+ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMWaDJzO5Hvz9z12ar5cgNZes6R/0meH7dcnlluUDsRKzJIjAL8Hysu14+wgse4w/xyabvs8c4l/KC7amn+KmMb+R2Y3vS3frHLWQrQpWdcH2GRIzGzudYF+pf3xBjozcTrYz0e39DQATbxsdtN75sErkLt/pvhWzEaHPzlo+44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/BWbnKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/BWbnKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA98C4CEE5;
	Tue,  8 Apr 2025 12:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116720;
	bh=iB/WxQikY+OJUrHTfA6OrIOrALSbrdliI+1Xzdci+ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/BWbnKIL68jTvTkIWa2SsS9QZIRMBphnFcMLjqpc4gCtP2o5wEbPXMA4uHkGSfb9
	 C6F6pVE/1FG74PJfugpdhtWWS0Te/7MfBbqpbCBV8oj+L/O5vvKu9SX0LMoltk8Aah
	 H2XyGafFgwkqGco7UTfssvCTQrFs7w590kv8Ssy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Liu <jim.t90615@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/423] net: phy: broadcom: Correct BCM5221 PHY model detection
Date: Tue,  8 Apr 2025 12:49:30 +0200
Message-ID: <20250408104851.413899043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jim Liu <jim.t90615@gmail.com>

[ Upstream commit 4f1eaabb4b66a1f7473f584e14e15b2ac19dfaf3 ]

Correct detect condition is applied to the entire 5221 family of PHYs.

Fixes: 3abbd0699b67 ("net: phy: broadcom: add support for BCM5221 phy")
Signed-off-by: Jim Liu <jim.t90615@gmail.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/broadcom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
index ddded162c44c1..d2a9cf3fde5ac 100644
--- a/drivers/net/phy/broadcom.c
+++ b/drivers/net/phy/broadcom.c
@@ -859,7 +859,7 @@ static int brcm_fet_config_init(struct phy_device *phydev)
 		return reg;
 
 	/* Unmask events we are interested in and mask interrupts globally. */
-	if (phydev->phy_id == PHY_ID_BCM5221)
+	if (phydev->drv->phy_id == PHY_ID_BCM5221)
 		reg = MII_BRCM_FET_IR_ENABLE |
 		      MII_BRCM_FET_IR_MASK;
 	else
@@ -888,7 +888,7 @@ static int brcm_fet_config_init(struct phy_device *phydev)
 		return err;
 	}
 
-	if (phydev->phy_id != PHY_ID_BCM5221) {
+	if (phydev->drv->phy_id != PHY_ID_BCM5221) {
 		/* Set the LED mode */
 		reg = __phy_read(phydev, MII_BRCM_FET_SHDW_AUXMODE4);
 		if (reg < 0) {
@@ -1009,7 +1009,7 @@ static int brcm_fet_suspend(struct phy_device *phydev)
 		return err;
 	}
 
-	if (phydev->phy_id == PHY_ID_BCM5221)
+	if (phydev->drv->phy_id == PHY_ID_BCM5221)
 		/* Force Low Power Mode with clock enabled */
 		reg = BCM5221_SHDW_AM4_EN_CLK_LPM | BCM5221_SHDW_AM4_FORCE_LPM;
 	else
-- 
2.39.5



