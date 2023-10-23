Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE451C10
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q886yPiM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7F76C433C7;
	Mon, 23 Oct 2023 11:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061283;
	bh=xA8ILK7krTV+BEkH5wuvXp17JESaS+0WFILke1LRmEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q886yPiMTwgkj+x8gkDJCQG+t+2usGSjb2gIeXCqH6KEvV2ShraZy9a0FYW0Io/cY
	 7yhwxOyMnP2pQtQzxagZcj5RC3Mn85GSvKB5/eMa1TKmSGP+wX3tTPW/LFaHME5eLc
	 see3AtLhUDIreykVSXmIngyY/tz+vOwoX5Z5mraY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Merlijn Wajer <merlijn@wizzup.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/137] phy: mapphone-mdm6600: Fix runtime PM for remove
Date: Mon, 23 Oct 2023 12:58:10 +0200
Message-ID: <20231023104825.173116982@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit b99e0ba9633af51638e5ee1668da2e33620c134f ]

Otherwise we will get an underflow on remove.

Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Fixes: f7f50b2a7b05 ("phy: mapphone-mdm6600: Add runtime PM support for n_gsm on USB suspend")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://lore.kernel.org/r/20230913060433.48373-2-tony@atomide.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/motorola/phy-mapphone-mdm6600.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/motorola/phy-mapphone-mdm6600.c b/drivers/phy/motorola/phy-mapphone-mdm6600.c
index 436b5ab6dc6d5..c3e2ab6a2a717 100644
--- a/drivers/phy/motorola/phy-mapphone-mdm6600.c
+++ b/drivers/phy/motorola/phy-mapphone-mdm6600.c
@@ -641,6 +641,7 @@ static int phy_mdm6600_remove(struct platform_device *pdev)
 	struct phy_mdm6600 *ddata = platform_get_drvdata(pdev);
 	struct gpio_desc *reset_gpio = ddata->ctrl_gpios[PHY_MDM6600_RESET];
 
+	pm_runtime_get_noresume(ddata->dev);
 	pm_runtime_dont_use_autosuspend(ddata->dev);
 	pm_runtime_put_sync(ddata->dev);
 	pm_runtime_disable(ddata->dev);
-- 
2.42.0



