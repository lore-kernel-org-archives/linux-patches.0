Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B34207E14;
	Tue,  8 Apr 2025 11:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111285; cv=none; b=HbdaJg+SY/WLGhnP2X/NenOHO73XK4EIghd1DsEGq/VszHq53lKKF56sG8gL7mUKLGTlOgsEim1D5an8qMly8MpMsuQHeM5XiC7Oc+bZypMQTBOnbFowixEuFym4oinLMNoNUF6mSI3iiG2IOXTfOpvqVIlrAy+YKT08Wx5jJqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111285; c=relaxed/simple;
	bh=whPFb9kLyAnE9YBx2/vo3p6QMOzSYOl/5wpBx9oPscc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7xPudoad/4McSfg7wchJR1t23Xrffk6zDv9EApLC9BhgcDwlvDlPSaYXCKz8giXC07bE4itQXRxRo4SSxq65rJaue9m9WANJSDWGPOEKGSAyhYbB3lWJGECcKAbU2wC2JN34/rhxzJW1kUqJeoRRBa1HJO5ULckRLEeeYnqYeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQQVaVSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQQVaVSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1364C4CEE5;
	Tue,  8 Apr 2025 11:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111285;
	bh=whPFb9kLyAnE9YBx2/vo3p6QMOzSYOl/5wpBx9oPscc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQQVaVSZhz731C7Rv5RGjkqBsQLm7KVE7QicBYU+8dnc0ZZr3s51mFfUCKKWzUHyW
	 FzwavFt8M8fk5OQjtAxMNtcNvF32GZi43D16OGXe8uiB/PfAlzCqwHl6TyF1EVlWVk
	 pn7WEGSRgu0fLD4esJvUfK7DrxQVaFGjS96sD1Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 375/731] pinctrl: nuvoton: npcm8xx: Fix error handling in npcm8xx_gpio_fw()
Date: Tue,  8 Apr 2025 12:44:32 +0200
Message-ID: <20250408104922.999065137@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



