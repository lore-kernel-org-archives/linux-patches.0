Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595991FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D022DC433C9;
	Tue,  1 Aug 2023 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882983;
	bh=FKETtIGiRZMkTO/5Th+CynsEyIVqlGHnWV2RWNTMr4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iT7Cw41PbTLaCazW779iYb16q4AmQxmnAu1fKdw7YHL4/czbumKG5Nhv2FBpNtuS
	 n/ZT7UZzNPRW/vdXqtwUa/vU55+/Gi9NMHiJ/cjRd1anq4y4JNAV4cZSPYfYc1Vi4g
	 j1RcoII1XxwaylgaOmijvXh1HyaKg/SNSj4+mHPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 073/239] phy: hisilicon: Fix an out of bounds check in hisi_inno_phy_probe()
Date: Tue,  1 Aug 2023 11:18:57 +0200
Message-ID: <20230801091928.324734139@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 13c088cf3657d70893d75cf116be937f1509cc0f ]

The size of array 'priv->ports[]' is INNO_PHY_PORT_NUM.

In the for loop, 'i' is used as the index for array 'priv->ports[]'
with a check (i > INNO_PHY_PORT_NUM) which indicates that
INNO_PHY_PORT_NUM is allowed value for 'i' in the same loop.

This > comparison needs to be changed to >=, otherwise it potentially leads
to an out of bounds write on the next iteration through the loop

Fixes: ba8b0ee81fbb ("phy: add inno-usb2-phy driver for hi3798cv200 SoC")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20230721090558.3588613-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/hisilicon/phy-hisi-inno-usb2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/hisilicon/phy-hisi-inno-usb2.c b/drivers/phy/hisilicon/phy-hisi-inno-usb2.c
index b133ae06757ab..a922fb11a1092 100644
--- a/drivers/phy/hisilicon/phy-hisi-inno-usb2.c
+++ b/drivers/phy/hisilicon/phy-hisi-inno-usb2.c
@@ -158,7 +158,7 @@ static int hisi_inno_phy_probe(struct platform_device *pdev)
 		phy_set_drvdata(phy, &priv->ports[i]);
 		i++;
 
-		if (i > INNO_PHY_PORT_NUM) {
+		if (i >= INNO_PHY_PORT_NUM) {
 			dev_warn(dev, "Support %d ports in maximum\n", i);
 			of_node_put(child);
 			break;
-- 
2.39.2



