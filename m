Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218A315C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987F2C433C1;
	Mon,  5 Dec 2022 19:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268424;
	bh=GUQ6c3yVQg+7taBqazpsQQ8NJEiB6iPo6qTi2QEXEfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ga2FJ+occ5D7uY+iJqMNDACRPf6ewxVoB1COjGaOphC5tR8f2YK81XG5CXMFnuuo
	 W2iGJOLeljT9bdzqDOiR0SqgdEWeYvNmTIaWzdwqQVgvC0GsA3iW0OMcIFAL1VMOoN
	 bSNZeA1nmupTVvMGx8cwy0Toqx7Pv6EkOreFrE24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerry Ray <jerry.ray@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 059/124] dsa: lan9303: Correct stat name
Date: Mon,  5 Dec 2022 20:09:25 +0100
Message-Id: <20221205190810.097624070@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerry Ray <jerry.ray@microchip.com>

[ Upstream commit 39f59bca275d2d819a8788c0f962e9e89843efc9 ]

This patch changes the reported ethtool statistics for the lan9303
family of parts covered by this driver.

The TxUnderRun statistic label is renamed to RxShort to accurately
reflect what stat the device is reporting.  I did not reorder the
statistics as that might cause problems with existing user code that
are expecting the stats at a certain offset.

Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20221128193559.6572-1-jerry.ray@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/lan9303-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index e03ff1f267bb..1de62604434d 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -959,7 +959,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
-- 
2.35.1



