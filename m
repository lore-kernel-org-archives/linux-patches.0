Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0FA1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E97FC433C8;
	Tue,  1 Aug 2023 09:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882352;
	bh=BlpZ905ny4sc/XE8c3TZg17Kqlv6zWBEltEw5Pve6yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RS3ViRZ3wtHtLvLOZwaGlY9CHsExwiI8pfvPAaISI0kdZ0ZrOlOMfSxMuDdZjOj6
	 35K51bxPDeEbyThhGe9svny7gDk4Wyr+14LY0+BQuLERV914EdpowDqdaH5H6s4jyr
	 5et+MQKh54MY22+97oX4takiYEfX/WDC2nfc2pkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 074/228] phy: phy-mtk-dp: Fix an error code in probe()
Date: Tue,  1 Aug 2023 11:18:52 +0200
Message-ID: <20230801091925.505084272@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 5782017cc4d0c8f3425d55b893675bb8a20c33e9 ]

Negative -EINVAL was intended instead of positive EINVAL.

Fixes: 6a23afad443a ("phy: phy-mtk-dp: Add driver for DP phy")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://lore.kernel.org/r/3c699e00-2883-40d9-92c3-0da1dc38fdd4@moroto.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/mediatek/phy-mtk-dp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/mediatek/phy-mtk-dp.c b/drivers/phy/mediatek/phy-mtk-dp.c
index 232fd3f1ff1b1..d7024a1443358 100644
--- a/drivers/phy/mediatek/phy-mtk-dp.c
+++ b/drivers/phy/mediatek/phy-mtk-dp.c
@@ -169,7 +169,7 @@ static int mtk_dp_phy_probe(struct platform_device *pdev)
 
 	regs = *(struct regmap **)dev->platform_data;
 	if (!regs)
-		return dev_err_probe(dev, EINVAL,
+		return dev_err_probe(dev, -EINVAL,
 				     "No data passed, requires struct regmap**\n");
 
 	dp_phy = devm_kzalloc(dev, sizeof(*dp_phy), GFP_KERNEL);
-- 
2.39.2



