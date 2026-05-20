Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74324356754;
	Wed, 20 May 2026 16:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294546; cv=none; b=txPP9qjFydTn0Od/ifXgYy6t74D76uCM9yLBgpcV+jagwJQQHoFYMunc6JKDFWq2Ezu36E+3ifbz+dwwSRH+inAIEZOg4u6vz9foF1Vo6o2/at8Y6wVW/MM6ewWgpN6wn4cvI2NYVIpLhphfqyYTATyiTE4vbV4eM0nPx/7NpIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294546; c=relaxed/simple;
	bh=CJwWC9C5bOGlIkqvFklXM8xpsk60Mq9kwPtZGHYRf38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXH43zued0VvHcNVpZzCWtm9vnZZMGUvAkORn5sruXbN+b++cdaBaCZ6s9qieAlKufTq5NjZtusYQsTkVbwiDyy10fp5yoXZA6dWuEcij5AxaQbCYZqGQOBlN+T7E4LLqlAworSy5B99Lt2BGLEqmTQybF2tCY3q2Rt64hiRZew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bF1RHhsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bF1RHhsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91B31F00893;
	Wed, 20 May 2026 16:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294545;
	bh=fxRWKmPXwj23YdNXqboerPFLAAjMUpu6O7OYXMBaS7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bF1RHhsbXrqnd+rv4lNw2cxOJtUTD1kiXHdg8EhHEGeeVAViPjvEibnBoxd36y0Wg
	 rED/PEC05Up3eNEpQoon3/1pDd+15wlGBZVWWPcDd853LTMozbO3aq035YhXGQsZwS
	 WLzQAYP8AMoJV9xbDcRpE2Mx087osUpgTpIjm6oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Cai Xinchen <caixinchen1@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0078/1146] dpaa2: add independent dependencies for FSL_DPAA2_SWITCH
Date: Wed, 20 May 2026 18:05:28 +0200
Message-ID: <20260520162150.119954198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit 12589892f41c4c645c80ef9f036f7451a6045624 ]

Since the commit 84cba72956fd ("dpaa2-switch: integrate
the MAC endpoint support") included dpaa2-mac.o in the driver,
but it didn't select PCS_LYNX, PHYLINK and FSL_XGMAC_MDIO. it
will lead to link error, such as
undefined reference to `phylink_ethtool_ksettings_set'
undefined reference to `lynx_pcs_create_fwnode'

And the same reason as the commit d2624e70a2f53 ("dpaa2-eth: select
XGMAC_MDIO for MDIO bus support"), enable the FSL_XGMAC_MDIO Kconfig
option in order to have MDIO access to internal and external PHYs.

Because dpaa2-switch uses fsl_mc_driver APIs, add depends on FSL_MC_BUS
&& FSL_MC_DPIO as FSL_DPAA2_SWITCH do.

FSL_XGMAC_MDIO and FSL_MC_BUS depend on OF, thus the dependence of
FSL_MC_BUS can satisfy FSL_XGMAC_MDIO's OF requirement.

Fixes: 84cba72956fd ("dpaa2-switch: integrate the MAC endpoint support")
Suggested-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Link: https://patch.msgid.link/20260312065907.476663-2-caixinchen1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/Kconfig | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
index d029b69c3f183..36280e5d99e1f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
+++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
@@ -34,6 +34,10 @@ config FSL_DPAA2_SWITCH
 	tristate "Freescale DPAA2 Ethernet Switch"
 	depends on BRIDGE || BRIDGE=n
 	depends on NET_SWITCHDEV
+	depends on FSL_MC_BUS && FSL_MC_DPIO
+	select PHYLINK
+	select PCS_LYNX
+	select FSL_XGMAC_MDIO
 	help
 	  Driver for Freescale DPAA2 Ethernet Switch. This driver manages
 	  switch objects discovered on the Freeescale MC bus.
-- 
2.53.0



