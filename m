Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817F42236EB;
	Tue, 30 Sep 2025 15:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244912; cv=none; b=EDBIddTj/Vqjz21wkhxRp1SGVd0HYAT/GC8AyQTKRFFdmkz9ovp/3X1eHSvRLglvd3Q1t7SeDZriX3MM4fjTHgph0prQirMSF7mwGW54ugniuSBwLF0JZKE2VgUEumHwFlI3xloZRQW/BFI9OnBgFX4czqfQtLb+yzwsrckbdi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244912; c=relaxed/simple;
	bh=U1S67C5Kd8pJXkzkH/YAv5SUYhoIZMq6g6VP29wZOMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mmnY2d3n/4cN1Kj0mQa0uqTW1UDDI1aRzVd7xvW+BwlM3orqD+deBkgql3ZRIocfAPWGMOebG4RzWzCfQUeAWv3IWNzCzxHCo69oYDBfhqk1oO6CiuDzkhJrhQaqFLMPYeByIN+jePtdLltYdu8nEq0YUCFsIiFFpCT8Y/lHXP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4IbJTZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4IbJTZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A35C4CEF0;
	Tue, 30 Sep 2025 15:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244912;
	bh=U1S67C5Kd8pJXkzkH/YAv5SUYhoIZMq6g6VP29wZOMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4IbJTZqDmcYxlSpHHFmYty35/gJg7xTGWxKTy09IZMH+j4rCdSjvy3TziLQFc1Fs
	 XuMGbVp+D/a8tdv2gvw9rsebzHSQuw3+ii126G9+lp8OoP/8n4PmY5FY11qwNReSSJ
	 +EDtY40Mttym6C/o9YA0JakmZxsnu/QXPAPze0eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.16 121/143] pinctrl: airoha: fix wrong PHY LED mux value for LED1 GPIO46
Date: Tue, 30 Sep 2025 16:47:25 +0200
Message-ID: <20250930143836.055468878@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit 6f9674aa69ad0178ca8fc6995942ba9848c324f4 upstream.

In all the MUX value for LED1 GPIO46 there is a Copy-Paste error where
the MUX value is set to LED0_MODE_MASK instead of LED1_MODE_MASK.

This wasn't notice as there were no board that made use of the
secondary PHY LED but looking at the internal Documentation the actual
value should be LED1_MODE_MASK similar to the other GPIO entry.

Fix the wrong value to apply the correct MUX configuration.

Cc: stable@vger.kernel.org
Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index 1b2f132d76f0..ee5b9bab4552 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1752,8 +1752,8 @@ static const struct airoha_pinctrl_func_group phy1_led1_func_group[] = {
 		.regmap[0] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
+			GPIO_LAN3_LED1_MODE_MASK,
+			GPIO_LAN3_LED1_MODE_MASK
 		},
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
@@ -1816,8 +1816,8 @@ static const struct airoha_pinctrl_func_group phy2_led1_func_group[] = {
 		.regmap[0] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
+			GPIO_LAN3_LED1_MODE_MASK,
+			GPIO_LAN3_LED1_MODE_MASK
 		},
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
@@ -1880,8 +1880,8 @@ static const struct airoha_pinctrl_func_group phy3_led1_func_group[] = {
 		.regmap[0] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
+			GPIO_LAN3_LED1_MODE_MASK,
+			GPIO_LAN3_LED1_MODE_MASK
 		},
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
@@ -1944,8 +1944,8 @@ static const struct airoha_pinctrl_func_group phy4_led1_func_group[] = {
 		.regmap[0] = {
 			AIROHA_FUNC_MUX,
 			REG_GPIO_2ND_I2C_MODE,
-			GPIO_LAN3_LED0_MODE_MASK,
-			GPIO_LAN3_LED0_MODE_MASK
+			GPIO_LAN3_LED1_MODE_MASK,
+			GPIO_LAN3_LED1_MODE_MASK
 		},
 		.regmap[1] = {
 			AIROHA_FUNC_MUX,
-- 
2.51.0



