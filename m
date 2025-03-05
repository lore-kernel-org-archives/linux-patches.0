Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A333F1A23A6;
	Wed,  5 Mar 2025 18:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198240; cv=none; b=hotPQVLLaY6wETWVc4wbyEYay0MB1abBiNMeqKx3yFtyWooDPzD/AjsVtTsAqe2lLHQGCaeWmoTCEZUN1/qJCaPegtBxU+SOtA7mV9Z07YIUpCd2GCzJM5b7jkSyyBjQVz7GEQkVFw+PsJH+/dt1PCYUjNB8Lo0S2U1L+e2WV64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198240; c=relaxed/simple;
	bh=6VjPmFvI+4lk9pcX8OahjGytqO69lhtQ+42hAogU0vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Boyj172kwS5XThUuLJL0GZqSDTp+OhxbV+A4MWxaYY9mzIagB/ZxvLPIg667hX77Rx0REonOjJyZT2jVKFa1ui7FIb70VWbskk3tyX6HA93gxc9dHC1tBJNzCazAwCxqt0Ci0Nhv0Q2vMa9xtymJGI/qMEgeYOWXkrhXPBQkEsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp5evLc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp5evLc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5620C4CEE0;
	Wed,  5 Mar 2025 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198240;
	bh=6VjPmFvI+4lk9pcX8OahjGytqO69lhtQ+42hAogU0vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp5evLc0YLpsT5lIT00z22EvihzQSrqt5N9SiJyxeZXathQvo/Qq2NAHvxWHtlN7S
	 cih6/uJGIeqjq9H3Cg0x40hOCZbCNRNGHwkvb8ewW6+4/RwWikMPuFY5aIp8hOF7/s
	 xJldJNAPB8MygKMPWMv2jrjeHaz17ZjL50tkzuYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Jonas Karlman <jonas@kwiboo.se>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/150] phy: rockchip: naneng-combphy: compatible reset with old DT
Date: Wed,  5 Mar 2025 18:48:29 +0100
Message-ID: <20250305174507.029064591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit 3126ea9be66b53e607f87f067641ba724be24181 ]

The device tree of RK3568 did not specify reset-names before.
So add fallback to old behaviour to be compatible with old DT.

Fixes: fbcbffbac994 ("phy: rockchip: naneng-combphy: fix phy reset")
Cc: Jianfeng Liu <liujianfeng1994@gmail.com>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Reviewed-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20250106100001.1344418-2-amadeus@jmu.edu.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-naneng-combphy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
index 2eb3329ca23f6..1ef6d9630f7e0 100644
--- a/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-naneng-combphy.c
@@ -309,7 +309,10 @@ static int rockchip_combphy_parse_dt(struct device *dev, struct rockchip_combphy
 
 	priv->ext_refclk = device_property_present(dev, "rockchip,ext-refclk");
 
-	priv->phy_rst = devm_reset_control_get(dev, "phy");
+	priv->phy_rst = devm_reset_control_get_exclusive(dev, "phy");
+	/* fallback to old behaviour */
+	if (PTR_ERR(priv->phy_rst) == -ENOENT)
+		priv->phy_rst = devm_reset_control_array_get_exclusive(dev);
 	if (IS_ERR(priv->phy_rst))
 		return dev_err_probe(dev, PTR_ERR(priv->phy_rst), "failed to get phy reset\n");
 
-- 
2.39.5



