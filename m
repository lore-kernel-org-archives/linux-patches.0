Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8DB28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F61C433F0;
	Mon, 12 Dec 2022 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670850953;
	bh=73Lkqd3ipfuno2uF2kmb4WF2+dzTCaCSZBuNgN6tX6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iNwnugD0PPZ6cm6Nha1WwpFpRcj/+qDcOT3sWMiW+bjbZqtzsePqp1rn/55YHX2A
	 jOD8NTIWlCr+w2kpBjpdONrsbsWA3GvgkLM4yEmO701QvQ3dM2mHBqjpxMyoIB4Evk
	 SV+L0t44T4QuJgCkFLYS+PmIIPDTjZZMD4xPDoPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	YueHaibing <yuehaibing@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 072/106] net: broadcom: Add PTP_1588_CLOCK_OPTIONAL dependency for BCMGENET under ARCH_BCM2835
Date: Mon, 12 Dec 2022 14:10:15 +0100
Message-Id: <20221212130928.024498741@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
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
 drivers/net/ethernet/broadcom/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 7b79528d6eed..06aaeaadf2e9 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -63,6 +63,7 @@ config BCM63XX_ENET
 config BCMGENET
 	tristate "Broadcom GENET internal MAC support"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL || !ARCH_BCM2835
 	select MII
 	select PHYLIB
 	select FIXED_PHY
-- 
2.35.1



