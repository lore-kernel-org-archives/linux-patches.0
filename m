Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3991C5D4E;
	Wed,  5 Mar 2025 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197662; cv=none; b=uz1P5qFGZXx+PlUASsf5uVgUjnzmb5ueX4yoEA2khfMKM2/DK4Wc0HgOGH6k9JwGU2xkxn2JmcpayUOhN56d5aIKrfZD1Dg3/treoMC2nkIYRtkrrE4/fLyBxwBZx1LE1S0oMbYg3US4OKTTCw9SyIFUiUHJUZu9kPFN0AqVamM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197662; c=relaxed/simple;
	bh=BXffHO6ZwrYMezVvsi53IbkimLjfTmwEpQ5uSbGgIRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSPav8e0W2z+qrF1KMP0wYBA2YVTkiHIuSY/ZDqthLuLpiU5CrERDuI1fqk7gkv39QcicC5nAsLxFjpC9iCb4VK+pFkUkscJblNVqFOMq3j5F5Y84xo/aMfwpPigzeSihmRnKF31eoMlLT31PGd+0jxDpcObttPlJpR8jTK6U3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CNPvtlM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CNPvtlM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A31C4CED1;
	Wed,  5 Mar 2025 18:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197662;
	bh=BXffHO6ZwrYMezVvsi53IbkimLjfTmwEpQ5uSbGgIRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CNPvtlM+29Q5mcN4HWbovfvLnHxpBEYUHJ+szG4+qRLlSNqZAfqKIphEr2NfFcNxa
	 WOuNtErs6IV6syMbsjTGsP47CcZ/VvQnLvWGb1yuQ34QIK+sW4VTeS4SWlRGKqmXnY
	 0IzqnmkNVYPNlziEHlvpOXwINzxShU4Y4jwvhIBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Jonas Karlman <jonas@kwiboo.se>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/142] phy: rockchip: naneng-combphy: compatible reset with old DT
Date: Wed,  5 Mar 2025 18:47:55 +0100
Message-ID: <20250305174502.588547225@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
References: <20250305174500.327985489@linuxfoundation.org>
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
index 9c231094ba359..2354ce8b21594 100644
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



