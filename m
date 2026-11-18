Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018413;
	b=A4ot6mSZirgrlpp7pmyqIzMiuE6w5Tp8CWqlEwQDaf/bp7jbl8qPQQMRKQe8IhLrTiAz
	 t6UfXPhqQUqCqkfzhoPawqczbYvT1/x7Qj3E4Wbbyy7tYJAg4UKa4f5W6A03R3sHMUPJv
	 eKQlVQqhzOzYmVH1iZsHyUtA8shlBIQuz+WNHBXU6KL2bevEBxhE6pb1SeLSiNYbVvYab
	 QrRujB8ClIultqK79x0FWRYjVsI13c7fRQiG1iwb95k1erQxlZcQaKfOBs7Lbwz1IYnCW
	 /UNZAWFSG4ilGdv1JJi2RSI9wZMATzYXd24s3Lzfa2DI0IiT2IGy18I6zDPaXrLxX/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018413;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xXh9tnnvdMJ97SdhbRur99cyAio2OS+GD5cBsVjF7C0=;
	b=WopHbPiov1FyLkJUweaujQW1tGeWV6H75H9PnavLcOE1edrO1hEzN3yv0TLg46IJV6ku
	 JjwrXBAHiVXmViTfd9gL6U6Sko8LMmOxzdJun46QmJx8/0PjF2uQZpEGTCZe066iCQPd7
	 +/cployd/VkkJDMGvSlsfXDdTDBt3pa06/uOOSXRkkXTF/P9GjoQKYpI3P4PIrMhR69r6
	 HziM3sFnYrUaMT7eI6xex997gJUGa43YE4L4HSBQ+hx4waD0XobTWKayoOjaJaeaM2t1K
	 sqPRS3q5mUygHuG/s6kQkhligDWEdVS4gs8mUMF65tP+tQYl2NZ1WAUNAUYDrImIrog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TvAOaox;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101BD606A31C;
	Wed, 18 Nov 2026 16:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TvAOaox
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552141F000C5;
	Wed, 18 Nov 2026 16:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018412;
	bh=xXh9tnnvdMJ97SdhbRur99cyAio2OS+GD5cBsVjF7C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TvAOaoxuZTIAVQSI3XuN41YV7wOHWpN6YptGWtqWP/6FZ6Pf0km9QbKBvFEeKNBU
	 fLkUztr0wWZCrRJjLFgGDGcSeGn9RD3Qx55nvZ/lLtLnI6AVM3aw6sW0UBpdDUdos1
	 3dv5JNxfXO1c+obxpR8yadnDZoPUKcckP1MdZjTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yang <jason98166@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1232/2651] phy: rockchip-samsung-dcphy: Enable runtime PM at PHY core level
Date: Wed, 18 Nov 2026 15:41:12 +0100
Message-ID: <20261118150332.361467146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yang <jason98166@gmail.com>

[ Upstream commit 261e84f9278f4373970471ad71479df20d82ed4c ]

phy_create() only enables runtime PM on the new PHY device if the parent
already has it enabled, and this driver enables it afterwards. The PHY
device therefore never gets runtime PM, and phy_pm_runtime_get_sync()
returns -ENOTSUPP for every phy_init() and phy_power_on(). The block is
still resumed today, but only through the supplier link fw_devlink builds
from the phys phandle, which fw_devlink=off and =permissive do not.

Move devm_pm_runtime_enable() before devm_phy_create(), as done for the
sibling HDPTX PHY in commit 10ba8479f460 ("phy:
phy-rockchip-samsung-hdptx: Enable runtime PM at PHY core level").

Fixes: b2a1a2ae7818 ("phy: rockchip: Add Samsung MIPI D-/C-PHY driver")
Signed-off-by: Jason Yang <jason98166@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Link: https://patch.msgid.link/20260821-dcphy-rpm-v1-v1-1-a7db728b2539@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c b/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
index 18f5f582d1d7a..7382043e1f319 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-dcphy.c
@@ -1610,16 +1610,16 @@ static int samsung_mipi_dcphy_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(samsung->grf_apb_rst),
 				     "Failed to get system grf_apb_rst control\n");
 
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
+
 	samsung->phy = devm_phy_create(dev, NULL, &samsung_mipi_dcphy_ops);
 	if (IS_ERR(samsung->phy))
 		return dev_err_probe(dev, PTR_ERR(samsung->phy), "Failed to create MIPI DC-PHY\n");
 
 	phy_set_drvdata(samsung->phy, samsung);
 
-	ret = devm_pm_runtime_enable(dev);
-	if (ret)
-		return dev_err_probe(dev, ret, "Failed to enable runtime PM\n");
-
 	phy_provider = devm_of_phy_provider_register(dev, samsung_mipi_dcphy_xlate);
 	if (IS_ERR(phy_provider))
 		return dev_err_probe(dev, PTR_ERR(phy_provider),
-- 
2.53.0



