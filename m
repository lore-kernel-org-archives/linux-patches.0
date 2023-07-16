Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3918F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:44:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C82C433C9;
	Sun, 16 Jul 2023 20:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540277;
	bh=KdiG2Q4pYq81Bk281qEmONgr4UuReyTtJy5mHeFCm/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sazMYt4zwkNG1RsCqTU0hRlUMznhrf0xQ+xuDnZSpvYyWmVxfsaQaVO8QfEJCbShV
	 N2qStu/J35G/JB7FA308+P8Z0EEXDc4Ohcdh2UGY9X5uh/7GAhye+cGU/O2oj09rCs
	 etEul9UH0pnHA4MKHboazj+lmwJy5ZnAXkYIx6D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 305/591] pinctrl: npcm7xx: Add missing check for ioremap
Date: Sun, 16 Jul 2023 21:47:24 +0200
Message-ID: <20230716194931.783189719@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 1c4e89b046de1..ac4c69132fa03 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -1878,6 +1878,8 @@ static int npcm7xx_gpio_of(struct npcm7xx_pinctrl *pctrl)
 		}
 
 		pctrl->gpio_bank[id].base = ioremap(res.start, resource_size(&res));
+		if (!pctrl->gpio_bank[id].base)
+			return -EINVAL;
 
 		ret = bgpio_init(&pctrl->gpio_bank[id].gc, dev, 4,
 				 pctrl->gpio_bank[id].base + NPCM7XX_GP_N_DIN,
-- 
2.39.2



