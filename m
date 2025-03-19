Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51CA1E0DE2;
	Wed, 19 Mar 2025 14:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395026; cv=none; b=nuImPHCPqcWyJ/1ZvyTm4/AKfPeo0nEAQucrsA5gbH5KCi2IjdtGv9qJxCdZewcMhZFyb+gKlDXoJZ8+AXbhk5VkS0OVEoOVc6PtOTfxCJEiqz6BXyBW0BcVdNZObKFUXY/TjI2vUBFVeBfCSnPf1oL5dgogtQXBAJI331OWwik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395026; c=relaxed/simple;
	bh=TP6Df54oQjU97KF6b24ylRNQrh7Q3PewKeU2NArSST8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYEgYopC2OGs2/eb3BqFplWwRFwLM/kNC1TxO8GJwjxXOa2iJU8iTKFJ8LqTbMZwqhC0iHnmZTUGMIMDaXIhvtFXU7RGa8Lb7L4ib5q0mFaM+JpjlcsV/T4ya3NC5qq4BaKReXW4b2xHtLdxhteetBoyo7pG41nL7/cNlUKcIN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fOoGRR8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fOoGRR8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450D8C4CEE4;
	Wed, 19 Mar 2025 14:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395026;
	bh=TP6Df54oQjU97KF6b24ylRNQrh7Q3PewKeU2NArSST8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fOoGRR8/9BENwY7mxNJoSJKJjVbnrl1zrOyRkzU6ooPsR21UTOjkxQSex1dPzOLIa
	 IIU75YbzTXXF93JoSXaYvboqUSdhUOAwSLT80cq11g/QNF/W1TSU84/dD9oIHhaN5I
	 GdZUHuniU+xmWfXgo2mWiz1i1UzuXygfEMvgJdXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/231] pinctrl: nuvoton: npcm8xx: Add NULL check in npcm8xx_gpio_fw
Date: Wed, 19 Mar 2025 07:28:19 -0700
Message-ID: <20250319143027.024739759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit acf40ab42799e4ae1397ee6f5c5941092d66f999 ]

devm_kasprintf() calls can return null pointers on failure.
But the return values were not checked in npcm8xx_gpio_fw().
Add NULL check in npcm8xx_gpio_fw(), to handle kernel NULL
pointer dereference error.

Fixes: acf4884a5717 ("pinctrl: nuvoton: add NPCM8XX pinctrl and GPIO driver")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/20250212100532.4317-1-hanchunchao@inspur.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
index 471f644c5eef2..d09a5e9b2eca5 100644
--- a/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
+++ b/drivers/pinctrl/nuvoton/pinctrl-npcm8xx.c
@@ -2374,6 +2374,9 @@ static int npcm8xx_gpio_fw(struct npcm8xx_pinctrl *pctrl)
 		pctrl->gpio_bank[id].gc.parent = dev;
 		pctrl->gpio_bank[id].gc.fwnode = child;
 		pctrl->gpio_bank[id].gc.label = devm_kasprintf(dev, GFP_KERNEL, "%pfw", child);
+		if (pctrl->gpio_bank[id].gc.label == NULL)
+			return -ENOMEM;
+
 		pctrl->gpio_bank[id].gc.dbg_show = npcmgpio_dbg_show;
 		pctrl->gpio_bank[id].direction_input = pctrl->gpio_bank[id].gc.direction_input;
 		pctrl->gpio_bank[id].gc.direction_input = npcmgpio_direction_input;
-- 
2.39.5



