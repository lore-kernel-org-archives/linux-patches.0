Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADBF538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827E3C433C8;
	Mon, 19 Jun 2023 10:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171715;
	bh=M06j8HG/E5y0kcU+swcjO1/P+HJqiElYs8svk535/b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sbm348kvA1J65IgqRnEXozucz/N71IJF5jnKJcXA0awiXVf96AvKTYa3xh5b7ptr4
	 SIfGHbAm38DkPQasgTxVhilw4wPywGSRefoYukoTds4XG3XoEMtbvxFe0twQdPF5u3
	 cMhCs88ZIJ1davFTN46gTNLud0OQuZqRrlb0DSAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/166] net: phylink: report correct max speed for QUSGMII
Date: Mon, 19 Jun 2023 12:30:07 +0200
Message-ID: <20230619102201.099875168@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxime Chevallier <maxime.chevallier@bootlin.com>

[ Upstream commit b9dc1046edfeb7d9dbc2272c8d9ad5a8c47f3199 ]

Q-USGMII is the quad port version of USGMII, and supports a max speed of
1Gbps on each line. Make so that phylink_interface_max_speed() reports
this information correctly.

Fixes: ae0e4bb2a0e0 ("net: phylink: Adjust link settings based on rate matching")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 4073e8243df3f..acd3405ddc9c6 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -188,6 +188,7 @@ static int phylink_interface_max_speed(phy_interface_t interface)
 	case PHY_INTERFACE_MODE_RGMII_ID:
 	case PHY_INTERFACE_MODE_RGMII:
 	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_QUSGMII:
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_GMII:
 		return SPEED_1000;
@@ -204,7 +205,6 @@ static int phylink_interface_max_speed(phy_interface_t interface)
 	case PHY_INTERFACE_MODE_10GBASER:
 	case PHY_INTERFACE_MODE_10GKR:
 	case PHY_INTERFACE_MODE_USXGMII:
-	case PHY_INTERFACE_MODE_QUSGMII:
 		return SPEED_10000;
 
 	case PHY_INTERFACE_MODE_25GBASER:
-- 
2.39.2



