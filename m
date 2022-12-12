Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77128ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E40C433EF;
	Mon, 12 Dec 2022 13:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851795;
	bh=m7nX502XKe6TIgvNUE4bMQoKJT2EFM1Yfcyd2BDRLD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4FUCauprrU7zrxukwN6kiOKB9wtwl8NbIwdv078LAdNC2OQ5Ax6VD3ikDaIdlvAP
	 kDGtm+8FLxWgYih0GCQETRyuR6jzzLP5PVWHLeHF4t1gFH+8pgqKGYq7rcABKoNQtC
	 L4vC6uPFgsaQxbTY3BbBN+HVZB8vPiSTAt/VGF6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	YueHaibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/123] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
Date: Mon, 12 Dec 2022 14:17:18 +0100
Message-Id: <20221212130929.989500793@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 421f8663b3a775c32f724f793264097c60028f2e ]

commit 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig") fixes the build
that contain 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
and enable BCMGENET=y but PTP_1588_CLOCK_OPTIONAL=m, which otherwise
leads to a link failure. However this may trigger a runtime failure.

Fix the original issue by propagating the PTP_1588_CLOCK_OPTIONAL dependency
of BROADCOM_PHY down to BCMGENET.

Fixes: 8d820bc9d12b ("net: broadcom: Fix BCMGENET Kconfig")
Fixes: 99addbe31f55 ("net: broadcom: Select BROADCOM_PHY for BCMGENET")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20221125115003.30308-1-yuehaibing@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 1cd3c289f49b..cd1706909044 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -71,13 +71,14 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY
 	select BCM7XXX_PHY
 	select MDIO_BCM_UNIMAC
 	select DIMLIB
-	select BROADCOM_PHY if (ARCH_BCM2835 && PTP_1588_CLOCK_OPTIONAL)
+	select BROADCOM_PHY if ARCH_BCM2835
 	help
 	  This driver supports the built-in Ethernet MACs found in the
 	  Broadcom BCM7xxx Set Top Box family chipset.
-- 
2.35.1



