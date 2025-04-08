Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E37E20A5C3;
	Tue,  8 Apr 2025 12:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116375; cv=none; b=EAChJXOB8ajyup9bk3q0jXqDU7OlmWFgfGtuDBTOOp7wDLpB64s+Zrc67h9eLq9FxtBIqsmVQv+Qc83dPvlzz4zUao9DSznVGpVWD0qkUMEgvJhT/s8VkyhET3L2BHLn8gVoD7lpoXO1yzdNfv6YXIfscD6D4gRrRv0ptL+Z/3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116375; c=relaxed/simple;
	bh=TJgD8YMe2oR3bVWRMuEMunYaMtpOYeKAP2PVZCSboBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivOZ1MndACYoj19g5jixBXbVGX4Mi5FxZqTchZk0dKxrimCxb0j5bgkfOUukSo5IQon77WUO/LcAnACdTIKV/HSWK+gG4klsrQAa+RBpio0kc3vLKbsBbxspCn8WoUrjyFeGHhKDO55bRS6AQ/eDVD68tB2je5cD8yeNFg5p3K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJz2xo3b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJz2xo3b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8675C4CEE5;
	Tue,  8 Apr 2025 12:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116375;
	bh=TJgD8YMe2oR3bVWRMuEMunYaMtpOYeKAP2PVZCSboBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJz2xo3byNI8ya1mrTXhyYdVL3QBcwo+Tu9WrbCwQObP+0H+JW9S/K54u7IqIAhBQ
	 TgBYqWfS4rXokXU1l7hUpyHI0nYcuyq1KUCZMitVa4gXrUGNdLGrOOO/vsJugUdcfX
	 wRf2yK+JJuRXJTXY+mFRBmmviHCHNkOQYCDipAZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/423] pinctrl: nuvoton: npcm8xx: Fix error handling in npcm8xx_gpio_fw()
Date: Tue,  8 Apr 2025 12:47:23 +0200
Message-ID: <20250408104848.454057929@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Yue Haibing <yuehaibing@huawei.com>

[ Upstream commit d6c6fd77e5816e3f6689a2767cdd777797506f24 ]

fwnode_irq_get() was changed to not return 0, fix this by checking
for negative error, also update the error log.

Fixes: acf4884a5717 ("pinctrl: nuvoton: add NPCM8XX pinctrl and GPIO driver")
Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Link: https://lore.kernel.org/20250118031334.243324-1-yuehaibing@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index d09a5e9b2eca5..17825bbe14213 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2361,8 +2361,8 @@ static int npcm8xx_gpio_fw(struct npcm8xx_pinctrl *pctrl)
 			return dev_err_probe(dev, ret, "gpio-ranges fail for GPIO bank %u\n", id);
 
 		ret = fwnode_irq_get(child, 0);
-		if (!ret)
-			return dev_err_probe(dev, ret, "No IRQ for GPIO bank %u\n", id);
+		if (ret < 0)
+			return dev_err_probe(dev, ret, "Failed to retrieve IRQ for bank %u\n", id);
 
 		pctrl->gpio_bank[id].irq = ret;
 		pctrl->gpio_bank[id].irq_chip = npcmgpio_irqchip;
-- 
2.39.5



