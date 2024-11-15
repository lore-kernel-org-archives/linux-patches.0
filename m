Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EBC17E015;
	Fri, 15 Nov 2024 06:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653357; cv=none; b=IumsthUeFd/Pk6Y4kOl4UqAsB9zXl3GORCoQVW6GhGu7BdWNvmC4HYoROoG62NC80Nn7UH1RVz/AQ5If9o21ZDcv++gJhaXcwE0RuH7X1opvEdE9mgsFNWN1iYMgR/NtWfYs2G71vnnoYONEE3ZTv2n0gg2jFQKUa6P6hIpdUbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653357; c=relaxed/simple;
	bh=YNsg6eVFundoB/EOS62FU6SnZIqbG1C+qiAQezhf6Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKHDm8RJq19r1913iNHDNmcxSi6WJWMweLy/x8672B57ehEQ7X3rc1EA7MnbLL1+3+xziQX5h1w6zLB3gfGWerPo52XUXkRCVRLEdcLCc9vKIsAhgPltRmqXikidZKgbelpLwgDKio6fJhdrc9zdXZJco5mFFd8wvZJaip0MTYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gp+jT4s/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gp+jT4s/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8DEC4CECF;
	Fri, 15 Nov 2024 06:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653356;
	bh=YNsg6eVFundoB/EOS62FU6SnZIqbG1C+qiAQezhf6Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gp+jT4s/DGBQ/aGSQgVLTy/Xvam/FgfMfIOuuQArm/k78ZdoaIHwjIv5/1qpxcky3
	 q9/tfuehZjmcQUfKpvWPuCt89FrhhxYdraOUQCBCJ6kxF/YnbFSAlZyWT24KbgiDCi
	 ia2sAhUQkQSdX62ib95U05boI2oxnPIJ8vkSQQ9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 29/63] net: phy: mdio-bcm-unimac: Add BCM6846 support
Date: Fri, 15 Nov 2024 07:37:52 +0100
Message-ID: <20241115063726.972542748@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index f40eb50bb978d..b7bc70586ee0a 100644
--- a/drivers/net/mdio/mdio-bcm-unimac.c
+++ b/drivers/net/mdio/mdio-bcm-unimac.c
@@ -337,6 +337,7 @@ static const struct of_device_id unimac_mdio_ids[] = {
 	{ .compatible = "brcm,asp-v2.2-mdio", },
 	{ .compatible = "brcm,asp-v2.1-mdio", },
 	{ .compatible = "brcm,asp-v2.0-mdio", },
+	{ .compatible = "brcm,bcm6846-mdio", },
 	{ .compatible = "brcm,genet-mdio-v5", },
 	{ .compatible = "brcm,genet-mdio-v4", },
 	{ .compatible = "brcm,genet-mdio-v3", },
-- 
2.43.0



