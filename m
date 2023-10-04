Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901AB1C6BD
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/zsijNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCEFC433C7;
	Wed,  4 Oct 2023 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444250;
	bh=rhjo2rlxkFhuDwaXC9flxB2fYqx+6+q41GZwjO3MTyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/zsijNCbNGOnBbQOhcaYwvdvpjLZ7FSAIdAJ23Y2n36TXNQlQ8Kyo56SpdloGfUw
	 uxOt0V+Mot5MeNRWKc+uJa/NzEhJZresuI4c1Dj7/Z+1I47LIJnRJvz1lnaS0a9R6Z
	 yfK5snSq75IcSlTuA/+wRMu/G/Ivch726B180v2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 155/321] gpio: pmic-eic-sprd: Add can_sleep flag for PMIC EIC chip
Date: Wed,  4 Oct 2023 19:55:00 +0200
Message-ID: <20231004175236.428006795@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 26d9e5640d2130ee16df7b1fb6a908f460ab004c ]

The drivers uses a mutex and I2C bus access in its PMIC EIC chip
get implementation. This means these functions can sleep and the PMIC EIC
chip should set the can_sleep property to true.

This will ensure that a warning is printed when trying to get the
value from a context that potentially can't sleep.

Fixes: 348f3cde84ab ("gpio: Add Spreadtrum PMIC EIC driver support")
Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pmic-eic-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pmic-eic-sprd.c b/drivers/gpio/gpio-pmic-eic-sprd.c
index c3e4d90f6b183..36f6cfc224c2d 100644
--- a/drivers/gpio/gpio-pmic-eic-sprd.c
+++ b/drivers/gpio/gpio-pmic-eic-sprd.c
@@ -352,6 +352,7 @@ static int sprd_pmic_eic_probe(struct platform_device *pdev)
 	pmic_eic->chip.set_config = sprd_pmic_eic_set_config;
 	pmic_eic->chip.set = sprd_pmic_eic_set;
 	pmic_eic->chip.get = sprd_pmic_eic_get;
+	pmic_eic->chip.can_sleep = true;
 
 	irq = &pmic_eic->chip.irq;
 	gpio_irq_chip_set_chip(irq, &pmic_eic_irq_chip);
-- 
2.40.1



