Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C943CE6E;
	Thu, 30 Jul 2026 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421951; cv=none; b=t4ODFJjJ4usgDDzzupJ+xA/UkVpJUt5dz3IL5FpGSC8kF643QqiSHQeEup7PyLuYI7Tdme0OHF02MeMRXbgJ2v+0DA59sbelEpjLmCN8pfTgZbgSsAqpTrMDvl2hPK0haQ4I02DEOG/18enZC8e709YQmYBQzlh4mvjLWWrq+3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421951; c=relaxed/simple;
	bh=naYw8H9VSFDd70902dhse16Arl76hd7V21KzYU59HEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8e/KByEI1Rani6nGbtZUSNdB+/GReCk2mhhqyykJe81d8lLq0Rzyg8666txaW7nqzHQpLxrjRWEUkVWV7RicGiZpbYP68I4GV2WdxSl8WcjG3qHPye4hzlt53nk3iTc8s9pWVdwZK98HRXT//u7IxEZibr1L8wY6T7hsd+bgXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z9GviFnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z9GviFnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976F51F000E9;
	Thu, 30 Jul 2026 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421946;
	bh=+zRDExP3cAS5wdP8zUimb5kCjypye96RaKOwRkyLEF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z9GviFnJxQVhVwcknDXKlP6BGt+1yTyzb9sMt9gp+/DD+NSfGR3bfD1FiLWFn6IWR
	 5kbrDEqsrgRl/bzC4Aex3fnGfJKid+fYALc3/c/u86vgqUSQrArdWlXQY0J+bVSPh9
	 O2kcf4E8dvMRfVePJwuGs6drndCFFsz5BN3QwCjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 229/744] net: phy: marvell: fix return code
Date: Thu, 30 Jul 2026 16:08:22 +0200
Message-ID: <20260730141449.158824952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 7d8ca62d6a9ef593780161586b4efc811ac094fe ]

Return the correct error code, not the value written to the register.

Fixes: a219912e0fec ("net: phy: marvell: implement config_inband() method")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260706120637.1947685-1-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 7a578b5aa2ed60..f71cffa8840628 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -753,7 +753,7 @@ static int m88e1111_config_inband(struct phy_device *phydev, unsigned int modes)
 	err = phy_modify(phydev, MII_M1111_PHY_EXT_SR,
 			 MII_M1111_HWCFG_SERIAL_AN_BYPASS, extsr);
 	if (err < 0)
-		return extsr;
+		return err;
 
 	return phy_modify_paged(phydev, MII_MARVELL_FIBER_PAGE, MII_BMCR,
 				BMCR_ANENABLE, bmcr);
-- 
2.53.0



