Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CC146EF73;
	Tue, 21 Jul 2026 17:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656640; cv=none; b=LTxc1k0qm3hhzyN9eWuvpRUyt3FW8rgXilt48G+nh7GhUyAvaONfel1G+RbOKi/aoORToNiSGrB7vDBEn+YRrokCe+7CbObXM9q4450i7wrQSKYG340Rm4E6Ju2ySYIj55shC57VUQ1u5bPY8QkDWSx36RgLDYx72bO+rpXcS4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656640; c=relaxed/simple;
	bh=ka32aweYT1ct28bcNMPbCJmCVzokTSF4jxGyJuKe9ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0Ll/Wd9CVd56pNxXW4wTnYEKbW5exx/34TpGpmNukYivS3xuw/TrIokDjlTlooZ/cO8COYesT/LJnz2JblV5D0Ezv1iJq+IL9vVltY+Gi0A+mxuY8yrEE8ClW6vHKS++ngl9DsCF1OaVaTbwsjcOUTiCN4Ttz6y/iIhWFfbHLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r9aNxAI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r9aNxAI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B81F000E9;
	Tue, 21 Jul 2026 17:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656639;
	bh=Sz30nqAWhQfr9j8Bhz4xk1+JNKG1ZEsOXpPDw2azq7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r9aNxAI4XT7EhRnfJemacvZIISPpMDxebhK9SkVPnRvx118Pz/hnRbszlMc6NoFvA
	 DDJbFzRFIwjgW0yjDmGL1a/Lv8nMXBHa2kWsPdBD5krMlLJ3GLiPyJ2tBV671lASzs
	 jua1kqdo6a53mG/qJ2dYrYK02Ge+U2fJi1SHYZWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0461/1611] pinctrl: airoha: an7581: fix misprint in gpio19 pinconf
Date: Tue, 21 Jul 2026 17:09:37 +0200
Message-ID: <20260721152525.679812253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>

[ Upstream commit 08a39a0617ff32a7c3962bbc38a9eee41b14659a ]

Pin 32 (gpio19) duplicate pinconf settings of pin 31. Fix it using
a proper bit number in the configuration register.

Fixes: 1c8ace2d0725 ("pinctrl: airoha: Add support for EN7581 SoC")
Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-airoha.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-airoha.c b/drivers/pinctrl/mediatek/pinctrl-airoha.c
index acc010bdf3777c..ae769ef0cdc6ba 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -2041,7 +2041,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_pullup_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_PU, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_PU, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_PU, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_PU, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_PU, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_PU, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_PU, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_PU, BIT(22)),
@@ -2102,7 +2102,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_pulldown_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_PD, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_PD, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_PD, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_PD, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_PD, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_PD, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_PD, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_PD, BIT(22)),
@@ -2163,7 +2163,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_drive_e2_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_E2, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_E2, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_E2, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_E2, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_E2, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_E2, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_E2, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_E2, BIT(22)),
@@ -2224,7 +2224,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_drive_e4_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_E4, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_E4, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_E4, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_E4, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_E4, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_E4, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_E4, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_E4, BIT(22)),
-- 
2.53.0



