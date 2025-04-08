Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B729E267B8C;
	Tue,  8 Apr 2025 11:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111804; cv=none; b=QeVhWyxHqPcYStDu8zrNct3RU+HrF8DTr7TUHp92nsHIuMYo7LjCtyMShwAC+ZBc8FHZmZvZJoHNmSvn+N5YktskQ3EKT/+BN/Mv79JC0901+5BQaIJnnqKxCvOleKeM07rpoNgaqlqrAYsPfGIAvMSJ1c7r6BmUSL7hMxbJeF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111804; c=relaxed/simple;
	bh=M+TZ2re8DRjUxs4I9oDALGUFg28cKjHDDEi4E3IArhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgu63KPe1D9Fbu5aJOTuhaI8u+gBXP8VUOLp98n3Z/OOgGyljB8BAUE0l0PTpj8ll6Y7WgLyFi3gwGijBFf0rzTZZrED3bDvx+NmIEwPMnDjSvR12KQYdvxHP6HwuR1w5yOUbwbNGtmAwg/tmzu3aM1Synvpft7kEUFGrigkbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A0wfvAiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0wfvAiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A29C4CEE5;
	Tue,  8 Apr 2025 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111804;
	bh=M+TZ2re8DRjUxs4I9oDALGUFg28cKjHDDEi4E3IArhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0wfvAiPjGY+wEI3ut8SKXBa4eQvOmiJWwnUfVJWX7pCyqJKW/hOHClNIq0GwA3fm
	 qJ/EtQFYh7PeJ1sRyD3+0BBhHFkfSBTa/RA3h1y4mAKhgN9O0TOaifaBcI+ISfH+IE
	 oTV2yaKwkIvhKmMcY0hhUIUQNwEnAR2JecT0nEfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Liu <jim.t90615@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 567/731] net: phy: broadcom: Correct BCM5221 PHY model detection
Date: Tue,  8 Apr 2025 12:47:44 +0200
Message-ID: <20250408104927.463215647@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 22edb7e4c1a1f..5a963b2b7ea78 100644
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



