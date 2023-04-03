Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87326FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30615C433EF;
	Mon,  3 Apr 2023 14:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532797;
	bh=5Ibs8XaRsw3GJTRXybnG7NOIxFYYbo+B7ezdB/Z7ESM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVXjn0SFn4Ad3LoXWIDVLhzt1QT9JXgzy5gO6lE+NVMca1pY4ZqrRpn8V9PiYl9z2
	 Xv5IMawY1P8W4tdNzd2kSByUdt34VVul7SlXYfhWaBX5hTsXwlrLSOjgwh69QDO1ZD
	 0rrk8l/3kGDX6CobwnQ/9luqzlCg0oCUKgpERHQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Arun Ramadoss <arun.ramadoss@microchip.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/181] net: dsa: microchip: ksz8: ksz8_fdb_dump: avoid extracting ghost entry from empty dynamic MAC table.
Date: Mon,  3 Apr 2023 16:08:45 +0200
Message-Id: <20230403140418.044719257@linuxfoundation.org>
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

[ Upstream commit 492606cdc74804d372ab1bdb8f3ef4a6fb6f9f59 ]

If the dynamic MAC table is empty, we will still extract one outdated
entry. Fix it by using correct bit offset.

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
index 160d7ad26ca09..286e081830e7c 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -361,7 +361,7 @@ static const u32 ksz8863_masks[] = {
 	[STATIC_MAC_TABLE_OVERRIDE]	= BIT(20),
 	[STATIC_MAC_TABLE_FWD_PORTS]	= GENMASK(18, 16),
 	[DYNAMIC_MAC_TABLE_ENTRIES_H]	= GENMASK(1, 0),
-	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(7),
+	[DYNAMIC_MAC_TABLE_MAC_EMPTY]	= BIT(2),
 	[DYNAMIC_MAC_TABLE_NOT_READY]	= BIT(7),
 	[DYNAMIC_MAC_TABLE_ENTRIES]	= GENMASK(31, 24),
 	[DYNAMIC_MAC_TABLE_FID]		= GENMASK(19, 16),
-- 
2.39.2



