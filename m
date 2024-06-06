Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D873019E7F6;
	Thu,  6 Jun 2024 14:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683113; cv=none; b=lbAuE1dtqaXptC4WmUvTxGdFrSJzc7rAWZmqE8Nkaa2X3SoMtt+6b8OWRC6OUhytYRX5hcgpDaIsxBxz1ApIc0TdtsrrTyqHMN+96ZZ6IFXnPFMVC3tJJWXjtmQRwRvwyrJP3KpnhK+vR0cu6dEbI47/roMXggzo4K473rhdORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683113; c=relaxed/simple;
	bh=B+wkz7tN6A1kSnZy+GMPBrrcpSreS9LrrY835QFQSnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoZQFiu47BzFm0AtbF+b8RpFc6tldXug5ALo5xUbibjpXrPjeWk5ENLGxaKmha5ZLSIJJCOIWnhr2XlEVdA4fRAXGJWwxfZdDnvbQZNL1m7DyzmWkbg5vndUuMe+F/dd36pRy+AbhCAOQQoMtCh1zYxKqkgl5usA6X2K+3UACmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JC89gSWt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JC89gSWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B936FC2BD10;
	Thu,  6 Jun 2024 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683113;
	bh=B+wkz7tN6A1kSnZy+GMPBrrcpSreS9LrrY835QFQSnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JC89gSWtlpaQu2kkuroDgNyH3DfP1kmdw1dWO1sBW0WygodsCbFYcULpLgAPbWsLL
	 o0eaOI1Ld/I9u3USPUBPgZh0WS43BPcbWeOeD9NFmLxqlQ/AM89lnOGi0PFsS1oDpi
	 IxQEH4k1s3FX9WST68juXiBe1Bmy3ky6OhEyOVSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/744] Revert "net: txgbe: fix i2c dev name cannot match clkdev"
Date: Thu,  6 Jun 2024 15:55:18 +0200
Message-ID: <20240606131733.931007054@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duanqiang Wen <duanqiangwen@net-swift.com>

[ Upstream commit 8d6bf83f6740ba52a59e25dad360e1e87ef47666 ]

This reverts commit c644920ce9220d83e070f575a4df711741c07f07.
when register i2c dev, txgbe shorten "i2c_designware" to "i2c_dw",
will cause this i2c dev can't match platfom driver i2c_designware_platform.

Signed-off-by: Duanqiang Wen <duanqiangwen@net-swift.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://lore.kernel.org/r/20240422084109.3201-1-duanqiangwen@net-swift.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index ad5c213dac077..e457ac9ae6d88 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -20,8 +20,6 @@
 #include "txgbe_phy.h"
 #include "txgbe_hw.h"
 
-#define TXGBE_I2C_CLK_DEV_NAME "i2c_dw"
-
 static int txgbe_swnodes_register(struct txgbe *txgbe)
 {
 	struct txgbe_nodes *nodes = &txgbe->nodes;
@@ -553,8 +551,8 @@ static int txgbe_clock_register(struct txgbe *txgbe)
 	char clk_name[32];
 	struct clk *clk;
 
-	snprintf(clk_name, sizeof(clk_name), "%s.%d",
-		 TXGBE_I2C_CLK_DEV_NAME, pci_dev_id(pdev));
+	snprintf(clk_name, sizeof(clk_name), "i2c_dw.%d",
+		 pci_dev_id(pdev));
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
 	if (IS_ERR(clk))
@@ -616,7 +614,7 @@ static int txgbe_i2c_register(struct txgbe *txgbe)
 
 	info.parent = &pdev->dev;
 	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
-	info.name = TXGBE_I2C_CLK_DEV_NAME;
+	info.name = "i2c_designware";
 	info.id = pci_dev_id(pdev);
 
 	info.res = &DEFINE_RES_IRQ(pdev->irq);
-- 
2.43.0



