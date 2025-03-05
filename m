Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E45813C67E;
	Wed,  5 Mar 2025 18:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198576; cv=none; b=kTFtbPkT+lOH0rwPct0tm5WvMZ46wUi6R07zb4k3n8vvS0yMKaU+SKd68vuVdJA6fZaEi2s0d4RfwnI+7Oe3NtLuRUVS5x+QDr3LNwNQ7PiqiJs/PptgUVYyo/Q9Y8H0WddCfjBnAuiRbSYJlpvgNE3FuF+NQJspL3oeh0KiF28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198576; c=relaxed/simple;
	bh=ikL1M3DYkB6AvSNZDClj3LIWppHEm0+V0zSuHkNjT7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r66s5nyAvRKYfqqeK+6c+yWrg+juwrq/vFi8uNcMYnuO/WXhTb3N7tmCUSilupmfTwPC2qj2BgAvmBYNpxoLwQmLZoPaECuXhG0N9SRnKIRziePqFiIEhCXM6cI8thaEoMDgySmQ9WUbymx45ZpPm6UvTMAEUEOQfosCTn7FyFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ia2ToDih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ia2ToDih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE00AC4CED1;
	Wed,  5 Mar 2025 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198576;
	bh=ikL1M3DYkB6AvSNZDClj3LIWppHEm0+V0zSuHkNjT7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ia2ToDihal7DkMqMwNi8GoO5SGenJjaljaybu3xH9T/BKNOC6EcE17bMiAbl4H0oL
	 OL8NZAEZCouVmdcIsXc87kHt3IbPGE/zw6M5z+tYdm65SovwsrAbEbnolSN1z2V0sS
	 V3bIsqugTstJ35kwL+LxQwJU2aljBJHa7ernIoBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Jonas Karlman <jonas@kwiboo.se>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 075/157] phy: rockchip: naneng-combphy: compatible reset with old DT
Date: Wed,  5 Mar 2025 18:48:31 +0100
Message-ID: <20250305174508.320582471@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



