Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC8F2269AE4;
	Tue,  8 Apr 2025 12:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114538; cv=none; b=YY+17CFkEh/kz5Zcr0grAs5xTHiENCuWQztmrUMhM24/mPts6/cok5uUXxiGVHPGWzRgJysMF1thvJ13+sUNl54QQiPhLKgmDkKTmXVqN/ZXFw7l9DZfSrtuAsa/HrzPfN2vNjgeQNkTUX97HIHA18X9zZhsB2OkvdKrX5Wxpqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114538; c=relaxed/simple;
	bh=FxEf+1oJzVIBbWKzjEDiSc/vttc9ls7ry4n03PK3GNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ/qjWDQ0f1GzmrA13seRyBeh0eGVa+Ego12L1Q+yNSTB4uVLIm9EHBtMyK5QvzTkhOcCvMDisZKx/pWAlZuOVwYiB7FdJItpclMRoEodsDdJuAc4fvHIghzwM39jc2CVuQYbyLUmHV6TCyCV8U15QR7b/OSHLiIOx0cIRI8Tvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccNS4GFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccNS4GFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3B0C4CEE5;
	Tue,  8 Apr 2025 12:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114538;
	bh=FxEf+1oJzVIBbWKzjEDiSc/vttc9ls7ry4n03PK3GNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ccNS4GFbIDqjCRAyJXfNB8XVni76rV1qQlRqzUhDlaYu0xOLLJrUDyRb+LMwsaGCK
	 48SSsoL9UVxHobJzbn9SHbx/CqD2AekPbsYBuVtB2KqWANQ2FHXET5Z+dg0YTnoXrQ
	 2kfUyWNCfCOTWYMvmPBKt+S/Yv+W/Aj2HiCRsC2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yue Haibing <yuehaibing@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 144/499] pinctrl: nuvoton: npcm8xx: Fix error handling in npcm8xx_gpio_fw()
Date: Tue,  8 Apr 2025 12:45:56 +0200
Message-ID: <20250408104854.780219709@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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



