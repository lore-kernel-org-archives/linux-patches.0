Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30E708F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F71C433C8;
	Sun, 16 Jul 2023 20:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538557;
	bh=rbeTDj8LlUfrGigBIX7AujR0oYtP0HyI6ndM/gWUIfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s00fFIG34k+iYwRYqMR4YphH7KvdvE766PbKuuWr1JjmB2j32z2l9xbVRIWWtN0c5
	 hVQL1UVqg2drLoUrrbn6X1kRnXrvFwgZvR1WB5BIZm3fkjOOy+fTpKOtxk2Rfnkhmx
	 SADiMoC/2dgyVhTe/txvu5CuCangEkYdKPWIhpRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 462/800] pinctrl: npcm7xx: Add missing check for ioremap
Date: Sun, 16 Jul 2023 21:45:15 +0200
Message-ID: <20230716194959.812190443@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit ad64639417161e90b30dda00486570eb150aeee5 ]

Add check for ioremap() and return the error if it fails in order to
guarantee the success of ioremap().

Fixes: 3b588e43ee5c ("pinctrl: nuvoton: add NPCM7xx pinctrl and GPIO driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20230607095829.1345-1-jiasheng@iscas.ac.cn
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
index 21e61c2a37988..843ffcd968774 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -1884,6 +1884,8 @@ static int npcm7xx_gpio_of(struct npcm7xx_pinctrl *pctrl)
 		}
 
 		pctrl->gpio_bank[id].base = ioremap(res.start, resource_size(&res));
+		if (!pctrl->gpio_bank[id].base)
+			return -EINVAL;
 
 		ret = bgpio_init(&pctrl->gpio_bank[id].gc, dev, 4,
 				 pctrl->gpio_bank[id].base + NPCM7XX_GP_N_DIN,
-- 
2.39.2



