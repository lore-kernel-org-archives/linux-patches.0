Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A754326B2CD;
	Tue,  8 Apr 2025 12:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114947; cv=none; b=GWG1oDln6z5YrqMYWNsUx2TJbjVzP+IbEq+U25+k8k5xn3Tczk4tiEAU2bHfgavJ3GQ9dYGV86LHlkFUq3k/yTglwk5H5OB/YE72SfgS4hgk6tAwttffdNYyO+Tx83UHk+iXGogS2CkbakoUD6iItEJNGuF/PTQ08Xnr8ivCqwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114947; c=relaxed/simple;
	bh=r4dhWnyNnSpjwUYqgLtwKsYL0G9FOsGiICc0braF4c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLYFworY+oS5dNtwmwvuhxmNfCcN7PRL524RtSixQmGrc4UCZEQAY1Yh9CjKx1ODOxqdCJfghIx0ne9gSgM9x7eNjzngix7HPjfun9VzGLvjyeNgcdH4/VIsTNe/dcDw7XT9QUWthDQp42Z0vGACksPtwLzHSGKvOQaplF+81nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHSrZgDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHSrZgDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362C4C4CEE7;
	Tue,  8 Apr 2025 12:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114947;
	bh=r4dhWnyNnSpjwUYqgLtwKsYL0G9FOsGiICc0braF4c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHSrZgDPyEd1EcaOCdZWDXJG7DuID3GGnuEX0gHOFMYCzRjH93FhnhoPRvrKMwzLV
	 8nzkgQfCnoVmKDZTZbBccjzSF+8X1TzzKpyhtjtIQex/7WUP64WKPJXAF/SsK6bskx
	 mjOMXk/k1zAiz4wiiPBYRUXMnfSnIxcXV8NJ51cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Liu <jim.t90615@gmail.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 291/499] net: phy: broadcom: Correct BCM5221 PHY model detection
Date: Tue,  8 Apr 2025 12:48:23 +0200
Message-ID: <20250408104858.474471598@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



