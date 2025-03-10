Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014E222E407;
	Mon, 10 Mar 2025 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627876; cv=none; b=Z75sZkOrNUXwtvYGxiF2bM0JE1LGcuLox1xu5adU3QlPayNpq7y9bY7Hrt67Z9vrKK++J35B7dhqCOzLj8qqRrsSn1HNw8jRQ7oKn12XVt1cQROtRkiBNaoKN/3dLJnuxzkpQbD5hSTzlkIc551W54VsgWz9qYUkoirDHcrZs1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627876; c=relaxed/simple;
	bh=XCYGV5tYrZ164r3UIhSODmRJ2e68K1cI2VlWhH64CBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSc340T1YoreuLqzQ4kZeeookVq9GWe8ZGrLFT8q/L8gftIitx6FgRdTgHvcp+eBabbDG7yBs4YoIPAX9ivtNiY9xLYHI46scQmYeT4lFw21dNh4P2C6jZRllFyqogL8edefpsFbXtv2amZiUahBlIoMXAUUisfVwNP2MgV7GFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=js5LiMF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="js5LiMF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C0BC4CEEC;
	Mon, 10 Mar 2025 17:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627875;
	bh=XCYGV5tYrZ164r3UIhSODmRJ2e68K1cI2VlWhH64CBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=js5LiMF9dPGSSsOCC/98tBeIAMaFjTNWyAwX+BlX4p9k4feAqytjRKowlWieXQ7T2
	 rfFNkV2TzoDSXtZRAflmu0xmLz6x/HkNmqxp0ZhpK24C9RThD6yL0dPVOEYJwYrKlT
	 XPXudCmfxvdo799snlCHu0ihAYozpJgy2HeGkgII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/145] net: enetc: Remove setting of RX software timestamp
Date: Mon, 10 Mar 2025 18:05:05 +0100
Message-ID: <20250310170435.198284905@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 3dd261ca7f84c65af40f37825bf1cbb0cf3d5583 ]

The responsibility for reporting of RX software timestamp has moved to
the core layer (see __ethtool_get_ts_info()), remove usage from the
device drivers.

Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20240901112803.212753-13-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a562d0c4a893 ("net: enetc: VFs do not support HWTSTAMP_TX_ONESTEP_SYNC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index e993ed04ab572..aa7d427e654ff 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -846,17 +846,13 @@ static int enetc_get_ts_info(struct net_device *ndev,
 	if (phc_idx) {
 		info->phc_index = *phc_idx;
 		symbol_put(enetc_phc_index);
-	} else {
-		info->phc_index = -1;
 	}
 
 #ifdef CONFIG_FSL_ENETC_PTP_CLOCK
 	info->so_timestamping = SOF_TIMESTAMPING_TX_HARDWARE |
 				SOF_TIMESTAMPING_RX_HARDWARE |
 				SOF_TIMESTAMPING_RAW_HARDWARE |
-				SOF_TIMESTAMPING_TX_SOFTWARE |
-				SOF_TIMESTAMPING_RX_SOFTWARE |
-				SOF_TIMESTAMPING_SOFTWARE;
+				SOF_TIMESTAMPING_TX_SOFTWARE;
 
 	info->tx_types = (1 << HWTSTAMP_TX_OFF) |
 			 (1 << HWTSTAMP_TX_ON) |
@@ -864,9 +860,7 @@ static int enetc_get_ts_info(struct net_device *ndev,
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_ALL);
 #else
-	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-				SOF_TIMESTAMPING_TX_SOFTWARE |
-				SOF_TIMESTAMPING_SOFTWARE;
+	info->so_timestamping = SOF_TIMESTAMPING_TX_SOFTWARE;
 #endif
 	return 0;
 }
-- 
2.39.5



