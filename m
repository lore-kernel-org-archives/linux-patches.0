Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714E079C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F55C433C1;
	Wed, 30 Nov 2022 18:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833350;
	bh=mKvvtr50Y+5HEe04WOqxdeRSA5Jzjm426hRgIJ9VD8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y2PIJb4iI8IACdgxluD7hXINH10Az2nh75X0PRfYMbCsjtRJ24rUrtl39cGNFi/HT
	 woSQpoUpe/QyPS5KuqaJ5/RdrKkmgAfaLpMCdOYTEf3dMMnsXqdUwm4SzlgyUKwPhW
	 RQBbypOLztWvDIh1MwltznfBqu7oj1Lj/0dGcG9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 074/206] net: liquidio: simplify if expression
Date: Wed, 30 Nov 2022 19:22:06 +0100
Message-Id: <20221130180534.879215572@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 733d4bbf9514890eb53ebe75827bf1fb4fd25ebe ]

Fix the warning reported by kbuild:

cocci warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/cavium/liquidio/lio_main.c:1797:54-56: WARNING !A || A && B is equivalent to !A || B
   drivers/net/ethernet/cavium/liquidio/lio_main.c:1827:54-56: WARNING !A || A && B is equivalent to !A || B

Fixes: 8979f428a4af ("net: liquidio: release resources when liquidio driver open failed")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7bd97d98afeb..ae68821dd56d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -1798,7 +1798,7 @@ static int liquidio_open(struct net_device *netdev)
 
 	ifstate_set(lio, LIO_IFSTATE_RUNNING);
 
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on)) {
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on) {
 		ret = setup_tx_poll_fn(netdev);
 		if (ret)
 			goto err_poll;
@@ -1828,7 +1828,7 @@ static int liquidio_open(struct net_device *netdev)
 	return 0;
 
 err_rx_ctrl:
-	if (!OCTEON_CN23XX_PF(oct) || (OCTEON_CN23XX_PF(oct) && !oct->msix_on))
+	if (!OCTEON_CN23XX_PF(oct) || !oct->msix_on)
 		cleanup_tx_poll_fn(netdev);
 err_poll:
 	if (lio->ptp_clock) {
-- 
2.35.1



