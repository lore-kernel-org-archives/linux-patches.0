Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB9731987E;
	Wed,  3 Dec 2025 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776870; cv=none; b=EFh4BhZuFn1wr6pCn890MRN5fT3FR4yPfnJPrWI3iSsNbvf5wA0qpkSMPiUkbWH3OQ1WF9hUDTg1RNMmv9bLlakwfJd7EOLERM1WF0rFn50GxlxieGboC6+NW79xfvC82HVdBNa4pGPq8LX+2CzGQShr5BeZLdmYrbZRvmiSbFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776870; c=relaxed/simple;
	bh=F2MU4lkaZeHH4sO1Lq5lJJhFERxwJrNt9HR2Lm6PRfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGdUH+D2BQlqi5e1T9JQyP+RkAv4j2e/YHZgTLnJpyM+5yWsj/qzEiUxAcek8d6isKBG1bP0PYpqObHheTFkSXLpcm1r0JQjIvxkSfIkDABPHY6RGaCnmlWMsxZVjIJ+KIzW9BfQAuLbD5LQHKad+tmfSavl6yFm1ztdVILIVaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0VaH8Dhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0VaH8Dhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83643C4CEF5;
	Wed,  3 Dec 2025 15:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776869;
	bh=F2MU4lkaZeHH4sO1Lq5lJJhFERxwJrNt9HR2Lm6PRfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0VaH8DhwTstsKP/mhNxYLQyrzxV9ADQu3rU7jHpj+yDHYIrZPMn7ZGdqIMXC6C1i6
	 lbyyCxGNy/TDW+We3n4/sULchM54cPzJnNdNfXMPToyVRo9gFbVwh6jcQY8AwB/Lah
	 MDtoXdZktjHfXR1rQfIwrMYNZuOm9bOIbXQGWi9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 012/146] net: phy: mxl-gpy: fix bogus error on USXGMII and integrated PHY
Date: Wed,  3 Dec 2025 16:26:30 +0100
Message-ID: <20251203152346.915621618@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0c8dc16ee7bde..221b315203d06 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -540,7 +540,7 @@ static int gpy_update_interface(struct phy_device *phydev)
 	/* Interface mode is fixed for USXGMII and integrated PHY */
 	if (phydev->interface == PHY_INTERFACE_MODE_USXGMII ||
 	    phydev->interface == PHY_INTERFACE_MODE_INTERNAL)
-		return -EINVAL;
+		return 0;
 
 	/* Automatically switch SERDES interface between SGMII and 2500-BaseX
 	 * according to speed. Disable ANEG in 2500-BaseX mode.
-- 
2.51.0



