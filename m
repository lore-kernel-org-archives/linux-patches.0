Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC332FBDFF;
	Wed,  3 Dec 2025 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780530; cv=none; b=dzNC30ZTvvBDae4+pZKi/0ZtTl93QxDAf48wA1sYJxdMUm6z4cFjJBZywkETCYfAY2M1Z3dhPoMN0xRzf7Y9VoVfciJ+DDsQS6QNk5gvNhJRUa4axfbHYjndHdojspu/FeUwlBUgUPr1olU/LN3EAqVeXNDVikSFdvK1Wo/E+PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780530; c=relaxed/simple;
	bh=0p0555iggDIPjiG2dWSOYvIqIW/vp74YYZY04gtsPtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g7zwbgtXz1dvae8iF6XWzuMV8W0WvddgRdSfapJ4o5V97wgsXZUVoDxIM3GJwCjL0cw72Pb03dBYdNDVMsMsW80JQwl1IsoUJZsL+u1CKwrCK+Bnk673hto3Bt+jn2GN5p1FbxdJtX0IxjcPNamrRqfNBXK5MnDcey5wMe4cI1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKirUMa0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKirUMa0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38EDC116B1;
	Wed,  3 Dec 2025 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780530;
	bh=0p0555iggDIPjiG2dWSOYvIqIW/vp74YYZY04gtsPtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKirUMa0DWau10vJHkTsc4pL+FNwYANd14Y0E/YcAE40SEONkeUDoN1rVxWsBiEEZ
	 W5qaIN35ajwKhkqj3ZkHfFHlbV5FBy8qzkfxhOGignOiHrv/XGLo/hTKEWNuGovaMO
	 guEjOPZxqrfxfR/btIbl/8ANmHJLXW+kasZ2m988=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/132] net: phy: mxl-gpy: fix bogus error on USXGMII and integrated PHY
Date: Wed,  3 Dec 2025 16:28:13 +0100
Message-ID: <20251203152343.824393925@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit ec3803b5917b6ff2f86ea965d0985c95d8a85119 ]

As the interface mode doesn't need to be updated on PHYs connected with
USXGMII and integrated PHYs, gpy_update_interface() should just return 0
in these cases rather than -EINVAL which has wrongly been introduced by
commit 7a495dde27ebc ("net: phy: mxl-gpy: Change gpy_update_interface()
function return type"), as this breaks support for those PHYs.

Fixes: 7a495dde27ebc ("net: phy: mxl-gpy: Change gpy_update_interface() function return type")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/f744f721a1fcc5e2e936428c62ff2c7d94d2a293.1763648168.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mxl-gpy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index e5f8ac4b4604b..17b0654644de5 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -523,7 +523,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 	/* Interface mode is fixed for USXGMII and integrated PHY */
 	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
 	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
+		return 0;
 
 	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
 	 * according to speed. Disable ANEG in 2500-BaseX mode.
-- 
2.51.0



