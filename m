Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D553B15A84C;
	Mon, 27 May 2024 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837544; cv=none; b=rr8qdwusXNGSJeJtfdQ0g0niGfDnP6smz0U4UN0NDlOd0ysGX+BTauz1LV8DCKXUWchVMA+JZ5pgR4vHu03iViR3h2QdVfJOeZZFYB5kgv58ChRD7zm/IMW2tc+MXdzonzHP1a8aDrdlMSGr7uuzAQjBSpFd8VoJb877FX0XZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837544; c=relaxed/simple;
	bh=VcUHx0/2x7RjQDacEqIBVj9BQCBri5kgAMb69sHn+x8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GGa+IvDcuMfokJSZPrvutW4AZw+/JfVfdcQIHdf4YMX8K09AnUGzfwVyBWavJsOisJX+4rmZXnt6PI0LwDwOSWklM7uRZECOtlSkNnHmZUDg8/N4ZlwrJ6mT2/xQR25XnOwb/Hcoxgp+A9na2T4YkqPzh2R2pbfn8s8PDF1cKkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zr1xBk35; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zr1xBk35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAFDC2BBFC;
	Mon, 27 May 2024 19:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837544;
	bh=VcUHx0/2x7RjQDacEqIBVj9BQCBri5kgAMb69sHn+x8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zr1xBk35gmFIbZebpJG0cntDdbG8GUA3/JpmrxU/jX0kcN2XYnMBBwmEoJuLYM4Qd
	 baRN9/YmagPcHdzvGQ/WINN9sZbggYo37mmGJNqCa5JtfiBm6NbXVUQO+1n36IffnR
	 BRXRtwvG1nhzPLqD2OlkOBnD6qrB6ZX0MpBEOe30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duanqiang Wen <duanqiangwen@net-swift.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/493] Revert "net: txgbe: fix i2c dev name cannot match clkdev"
Date: Mon, 27 May 2024 20:50:55 +0200
Message-ID: <20240527185630.977146074@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 8cddc9ddb3392..29997e4b2d6ca 100644
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
@@ -558,8 +556,8 @@ static int txgbe_clock_register(struct txgbe *txgbe)
 	char clk_name[32];
 	struct clk *clk;
 
-	snprintf(clk_name, sizeof(clk_name), "%s.%d",
-		 TXGBE_I2C_CLK_DEV_NAME, pci_dev_id(pdev));
+	snprintf(clk_name, sizeof(clk_name), "i2c_dw.%d",
+		 pci_dev_id(pdev));
 
 	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
 	if (IS_ERR(clk))
@@ -621,7 +619,7 @@ static int txgbe_i2c_register(struct txgbe *txgbe)
 
 	info.parent = &pdev->dev;
 	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
-	info.name = TXGBE_I2C_CLK_DEV_NAME;
+	info.name = "i2c_designware";
 	info.id = pci_dev_id(pdev);
 
 	info.res = &DEFINE_RES_IRQ(pdev->irq);
-- 
2.43.0



