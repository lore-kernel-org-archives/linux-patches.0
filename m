Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05976FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:40:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579D6C433EF;
	Mon,  3 Apr 2023 14:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532802;
	bh=S7OjGKte1pX1kY30gP8vsytyOjLYKxZapwy+x44o/wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/vrJ5Dpm8iCAIdyBSEr54PqD0xWpSS1fjd20J34RdeUaTRa33+gH6z6hWViyz5h1
	 VQ+u2/KuR1/hzEzFjLv5UOSwhZjXm+vmH9RpxtzeY4aOFagxOEpNUiBO3zkPTBBG2M
	 qLJM/osk3jYiTd5fZoUAR3EdMzVwcLfC7JIbr7Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/181] net: dsa: microchip: ksz8: fix MDB configuration with non-zero VID
Date: Mon,  3 Apr 2023 16:08:47 +0200
Message-Id: <20230403140418.107057683@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 9aa5757e1f71d85facdc3c98028762cbab8d15c7 ]

FID is directly mapped to VID. However, configuring a MAC address with a
VID != 0 resulted in incorrect configuration due to an incorrect bit
mask. This kernel commit fixed the issue by correcting the bit mask and
ensuring proper configuration of MAC addresses with non-zero VID.

Fixes: 4b20a07e103f ("net: dsa: microchip: ksz8795: add support for ksz88xx chips")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Acked-by: Arun Ramadoss <arun.ramadoss@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/microchip/ksz_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 286e081830e7c..3d59298eaa5cf 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -357,7 +357,7 @@ static const u32 ksz8863_masks[] = {
 	[VLAN_TABLE_VALID]		= BIT(19),
 	[STATIC_MAC_TABLE_VALID]	= BIT(19),
 	[STATIC_MAC_TABLE_USE_FID]	= BIT(21),
-	[STATIC_MAC_TABLE_FID]		= GENMASK(29, 26),
+	[STATIC_MAC_TABLE_FID]		= GENMASK(25, 22),
 	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
 	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
 	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
-- 
2.39.2



