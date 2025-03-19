Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F911C7013;
	Wed, 19 Mar 2025 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394842; cv=none; b=YIU2VxHRKwJdgnkebcUlXH2j6pfkXQVTQW2zlDZ3EUgzqO6xygv2YA1ZhblwbKHC33GsQpuNWlPiBZRwoR+kY0S9ypB46DU3a5vrbQWujgbw6HHsOiubjn/auP6K3AM4lXrhjlGqn8+/phEQiyxYnyZ5HHKf+QuwTdiP52Rbwx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394842; c=relaxed/simple;
	bh=HGNYmY7om7RTaGYRPPu9mVjEqcrRUMITE0u8F3I1xlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA56SY4B4QLKZ8uuFsiprxQdBghMtZ1oEkhk0NVqhxW+GRM0pY3HCR3NlwvQDaTNu1xrcShw4jR5hoSg57mH6STlyx7imw6/yuexu8Z2H4goPpQNNUbCcbC4RNyncvDhmaSO/B9239by4dp1iFwH0IePvfmQAljzTKGF7yBZWeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCGLem5+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCGLem5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97A5C4CEE4;
	Wed, 19 Mar 2025 14:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394842;
	bh=HGNYmY7om7RTaGYRPPu9mVjEqcrRUMITE0u8F3I1xlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCGLem5+kAWimBDIXb8gv6Qh5el3lP6C1nwa/psKWll5KBu4fzZGEbLfqqVHVgrFI
	 KQC9iHX+6K4SeRlwaivx4VSo6U8X+gXg55zaTz8PoGc4jZ+U+3WzhFpQHqHIUmW1Zn
	 gj2aMLW/x94wga29u3ewCOz7Z5++82rqy6acvk7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 007/241] pinctrl: nuvoton: npcm8xx: Add NULL check in npcm8xx_gpio_fw
Date: Wed, 19 Mar 2025 07:27:57 -0700
Message-ID: <20250319143027.878695495@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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



