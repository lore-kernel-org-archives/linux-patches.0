Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648781170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:11:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0DBC433C7;
	Mon, 11 Sep 2023 14:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441465;
	bh=U/26fRIAn6hxdwgYkKUrLFpEbgR0H4rNqyNJQRPRCGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htg+XIv1/yYQS5dE0phW1qcU+kcn0K+gAZhZhPE5RcYe/Gu+WZPdjBtFqrWZnrM0A
	 FdGqd2zvsbUbDfMkBX2C7TnTNecPJw+Y1ZIGuRK/Pt4LRMvwYmkogxhvuod3J0gaKH
	 xT3Sm4Y6mlgiTqM1UKF9MjYUSdbZA8fsBebUuTYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 422/739] pinctrl: mediatek: fix pull_type data for MT7981
Date: Mon, 11 Sep 2023 15:43:41 +0200
Message-ID: <20230911134702.961867074@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 8f6f16fe1553ce63edfb98a39ef9d4754a0c39bf ]

MediaTek has released pull_type data for MT7981 in their SDK.
Use it and set functions to configure pin bias.

Fixes: 6c83b2d94fcc ("pinctrl: add mt7981 pinctrl driver")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/7bcc8ead25dbfabc7f5a85d066224a926fbb4941.1692327317.git.daniel@makrotopia.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt7981.c | 44 +++++++----------------
 1 file changed, 13 insertions(+), 31 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt7981.c b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
index 18abc57800111..0fd2c0c451f95 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt7981.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt7981.c
@@ -457,37 +457,15 @@ static const unsigned int mt7981_pull_type[] = {
 	MTK_PULL_PUPD_R1R0_TYPE,/*34*/ MTK_PULL_PUPD_R1R0_TYPE,/*35*/
 	MTK_PULL_PUPD_R1R0_TYPE,/*36*/ MTK_PULL_PUPD_R1R0_TYPE,/*37*/
 	MTK_PULL_PUPD_R1R0_TYPE,/*38*/ MTK_PULL_PUPD_R1R0_TYPE,/*39*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*40*/ MTK_PULL_PUPD_R1R0_TYPE,/*41*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*42*/ MTK_PULL_PUPD_R1R0_TYPE,/*43*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*44*/ MTK_PULL_PUPD_R1R0_TYPE,/*45*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*46*/ MTK_PULL_PUPD_R1R0_TYPE,/*47*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*48*/ MTK_PULL_PUPD_R1R0_TYPE,/*49*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*50*/ MTK_PULL_PUPD_R1R0_TYPE,/*51*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*52*/ MTK_PULL_PUPD_R1R0_TYPE,/*53*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*54*/ MTK_PULL_PUPD_R1R0_TYPE,/*55*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*56*/ MTK_PULL_PUPD_R1R0_TYPE,/*57*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*58*/ MTK_PULL_PUPD_R1R0_TYPE,/*59*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*60*/ MTK_PULL_PUPD_R1R0_TYPE,/*61*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*62*/ MTK_PULL_PUPD_R1R0_TYPE,/*63*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*64*/ MTK_PULL_PUPD_R1R0_TYPE,/*65*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*66*/ MTK_PULL_PUPD_R1R0_TYPE,/*67*/
-	MTK_PULL_PUPD_R1R0_TYPE,/*68*/ MTK_PULL_PU_PD_TYPE,/*69*/
-	MTK_PULL_PU_PD_TYPE,/*70*/ MTK_PULL_PU_PD_TYPE,/*71*/
-	MTK_PULL_PU_PD_TYPE,/*72*/ MTK_PULL_PU_PD_TYPE,/*73*/
-	MTK_PULL_PU_PD_TYPE,/*74*/ MTK_PULL_PU_PD_TYPE,/*75*/
-	MTK_PULL_PU_PD_TYPE,/*76*/ MTK_PULL_PU_PD_TYPE,/*77*/
-	MTK_PULL_PU_PD_TYPE,/*78*/ MTK_PULL_PU_PD_TYPE,/*79*/
-	MTK_PULL_PU_PD_TYPE,/*80*/ MTK_PULL_PU_PD_TYPE,/*81*/
-	MTK_PULL_PU_PD_TYPE,/*82*/ MTK_PULL_PU_PD_TYPE,/*83*/
-	MTK_PULL_PU_PD_TYPE,/*84*/ MTK_PULL_PU_PD_TYPE,/*85*/
-	MTK_PULL_PU_PD_TYPE,/*86*/ MTK_PULL_PU_PD_TYPE,/*87*/
-	MTK_PULL_PU_PD_TYPE,/*88*/ MTK_PULL_PU_PD_TYPE,/*89*/
-	MTK_PULL_PU_PD_TYPE,/*90*/ MTK_PULL_PU_PD_TYPE,/*91*/
-	MTK_PULL_PU_PD_TYPE,/*92*/ MTK_PULL_PU_PD_TYPE,/*93*/
-	MTK_PULL_PU_PD_TYPE,/*94*/ MTK_PULL_PU_PD_TYPE,/*95*/
-	MTK_PULL_PU_PD_TYPE,/*96*/ MTK_PULL_PU_PD_TYPE,/*97*/
-	MTK_PULL_PU_PD_TYPE,/*98*/ MTK_PULL_PU_PD_TYPE,/*99*/
-	MTK_PULL_PU_PD_TYPE,/*100*/
+	MTK_PULL_PU_PD_TYPE,/*40*/ MTK_PULL_PU_PD_TYPE,/*41*/
+	MTK_PULL_PU_PD_TYPE,/*42*/ MTK_PULL_PU_PD_TYPE,/*43*/
+	MTK_PULL_PU_PD_TYPE,/*44*/ MTK_PULL_PU_PD_TYPE,/*45*/
+	MTK_PULL_PU_PD_TYPE,/*46*/ MTK_PULL_PU_PD_TYPE,/*47*/
+	MTK_PULL_PU_PD_TYPE,/*48*/ MTK_PULL_PU_PD_TYPE,/*49*/
+	MTK_PULL_PU_PD_TYPE,/*50*/ MTK_PULL_PU_PD_TYPE,/*51*/
+	MTK_PULL_PU_PD_TYPE,/*52*/ MTK_PULL_PU_PD_TYPE,/*53*/
+	MTK_PULL_PU_PD_TYPE,/*54*/ MTK_PULL_PU_PD_TYPE,/*55*/
+	MTK_PULL_PU_PD_TYPE,/*56*/
 };
 
 static const struct mtk_pin_reg_calc mt7981_reg_cals[] = {
@@ -1014,6 +992,10 @@ static struct mtk_pin_soc mt7981_data = {
 	.ies_present = false,
 	.base_names = mt7981_pinctrl_register_base_names,
 	.nbase_names = ARRAY_SIZE(mt7981_pinctrl_register_base_names),
+	.bias_disable_set = mtk_pinconf_bias_disable_set,
+	.bias_disable_get = mtk_pinconf_bias_disable_get,
+	.bias_set = mtk_pinconf_bias_set,
+	.bias_get = mtk_pinconf_bias_get,
 	.pull_type = mt7981_pull_type,
 	.bias_set_combo = mtk_pinconf_bias_set_combo,
 	.bias_get_combo = mtk_pinconf_bias_get_combo,
-- 
2.40.1



