Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9023A7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976FFC433C1;
	Wed,  2 Nov 2022 02:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357431;
	bh=W1ZpoRNWEMTo3kqn1wDXRuxS8quDMamBop1Whnnbais=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMQPTu0b13705VH22M8Dvv0ayWfYSO1ZLJuS74pEZSeKf5hy1NmqPEnfQa7Q459wp
	 95xpSD9jIN/ifxuW5B6kAfJdqi9nUcSJYP1TuBiGrI2iPxHjowNKp1qKrlxm/IX1s/
	 Y6G8qnOBX5cBgIxbA/S/+ihvzCNxPmNC5vxbLxzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergiu Moga <sergiu.moga@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 169/240] net: macb: Specify PHY PM management done by MAC
Date: Wed,  2 Nov 2022 03:32:24 +0100
Message-Id: <20221102022115.207835463@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergiu Moga <sergiu.moga@microchip.com>

[ Upstream commit 15a9dbec631cd69dfbbfc4e2cbf90c9dd8432a8f ]

The `macb_resume`/`macb_suspend` methods already call the
`phylink_start`/`phylink_stop` methods during their execution so
explicitly say that the PM of the PHY is done by MAC by using the
`mac_managed_pm` flag of the `struct phylink_config`.

This also fixes the warning message issued during resume:
WARNING: CPU: 0 PID: 237 at drivers/net/phy/phy_device.c:323 mdio_bus_phy_resume+0x144/0x148

Depends-on: 96de900ae78e ("net: phylink: add mac_managed_pm in phylink_config structure")
Fixes: 744d23c71af3 ("net: phy: Warn about incorrect mdio_bus_phy_resume() state")
Signed-off-by: Sergiu Moga <sergiu.moga@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20221019120929.63098-1-sergiu.moga@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index a2897549f9c4..aa1b03f8bfe9 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -805,6 +805,7 @@ static int macb_mii_probe(struct net_device *dev)
 
 	bp->phylink_config.dev = &dev->dev;
 	bp->phylink_config.type = PHYLINK_NETDEV;
+	bp->phylink_config.mac_managed_pm = true;
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		bp->phylink_config.poll_fixed_state = true;
-- 
2.35.1



