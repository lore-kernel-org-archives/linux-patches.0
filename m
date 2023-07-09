Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E33522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA6CC433C7;
	Sun,  9 Jul 2023 11:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902494;
	bh=/aYLQXzEbaPlzbEtwY5wHCg8joDUvhV6XCBBXurPAfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ylp7lJWO5jhf8yUOk29K8hmb3C1IdYq+EDubx9igy+rKyKyv/5YPwnpY4ea1De38J
	 Yr1sIIk108Oox5OtjqF1TqKIUb1B8ewOf6uxFZYWaDSwc5zsK1gfEoZ5+sbEscCFA+
	 VXQV6rnXVyN+YW9IbSzSUqz2EasYMCrEq0Jg0m/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 368/431] pinctrl: npcm7xx: Add missing check for ioremap
Date: Sun,  9 Jul 2023 13:15:16 +0200
Message-ID: <20230709111459.793299258@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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
index ff5bcea172e84..071bdfd570f94 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm7xx.c
@@ -1881,6 +1881,8 @@ static int npcm7xx_gpio_of(struct npcm7xx_pinctrl *pctrl)
 		}
 
 		pctrl->gpio_bank[id].base = ioremap(res.start, resource_size(&res));
+		if (!pctrl->gpio_bank[id].base)
+			return -EINVAL;
 
 		ret = bgpio_init(&pctrl->gpio_bank[id].gc, dev, 4,
 				 pctrl->gpio_bank[id].base + NPCM7XX_GP_N_DIN,
-- 
2.39.2



