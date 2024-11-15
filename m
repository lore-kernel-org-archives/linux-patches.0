Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70336EAD0;
	Fri, 15 Nov 2024 06:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653436; cv=none; b=FZKv9oIbPK4S/5T6P4WoCF+t4lao1TOqPH6o3I887vN4OqLzmbNz6HsCyo0TxaGpWLdnve3rP8wk1gHAvK2f4JhCsHha8uXbn3TXO9f9z7zjnh09NI2FpVnKeB42g0EymudiTYj57VEFeXk9TSnUBik+F6M1ZD3zUTOjiE8AgLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653436; c=relaxed/simple;
	bh=OMnijPmwxd/m0AG8oc/b61xVH3mmOgbw+8eDsFDD4pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djuPN4dW35Ks31nL7r9wGJlxFsCNwY8RZvrrdpMTM7kGD+CHppSF4dxsoLIKBe7Zatb6OqWreidSKd9LLHW/VoPJY0e7lisCD8BDTNRcGGGfczSv1zF0BEHeuTYydXC+2oK3U/ixDzjNhKyc1l4syc3mw/Dyni/Z3YGjzVaJh4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAdw2nEh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAdw2nEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB85C4CECF;
	Fri, 15 Nov 2024 06:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653436;
	bh=OMnijPmwxd/m0AG8oc/b61xVH3mmOgbw+8eDsFDD4pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAdw2nEhwrk1LR4aRiaekp9Bu+sCyXqPLi4BcmvIT0Wu4ZHxtlIrt44nr/x4/n7dG
	 nK+OwM6CS4wJQgH3RFVtG7gG+Dji5/4vTc0En6+2jYEuTmNqJidsymGG2Rbn9lyeSz
	 dBt6By6MxLt9mHQlYwxsWliv0io8M86zkAzaBI4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 21/48] net: phy: mdio-bcm-unimac: Add BCM6846 support
Date: Fri, 15 Nov 2024 07:38:10 +0100
Message-ID: <20241115063723.730206017@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 906b77ca91c7e9833b4e47bedb6bec76be71d497 ]

Add Unimac mdio compatible string for the special BCM6846
variant.

This variant has a few extra registers compared to other
versions.

Suggested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/linux-devicetree/b542b2e8-115c-4234-a464-e73aa6bece5c@broadcom.com/
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20241012-bcm6846-mdio-v1-2-c703ca83e962@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-bcm-unimac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/mdio/mdio-bcm-unimac.c b/drivers/net/mdio/mdio-bcm-unimac.c
index 6b26a0803696d..a29838be335c9 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -336,6 +336,7 @@ static SIMPLE_DEV_PM_OPS(unimac_mdio_pm_ops,
 static const struct of_device_id unimac_mdio_ids[] = {
 	{ .compatible = "brcm,asp-v2.1-mdio", },
 	{ .compatible = "brcm,asp-v2.0-mdio", },
+	{ .compatible = "brcm,bcm6846-mdio", },
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
 	{ .compatible = "brcm,genet-mdio-v3", },
-- 
2.43.0



