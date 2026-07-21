Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CAF4014BB;
	Tue, 21 Jul 2026 16:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649671; cv=none; b=YtmM7qDd5yo181nKggQeHrpCYd1dFcCz2yMV9xF5PYIjlZPa80rfoZSNdZ1Ih1Q4uGFKhCBI7Xbc4e3dcthwbHbMWgAdb0jvYA65wlWC1pXYKq02uH/HxK0yc7LKhwai8qKsdpxkAGBg1ubHKXTpYlUDjVvpUchE562GbznzT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649671; c=relaxed/simple;
	bh=FDjR6MNfZI8/TSvqx5NdCypaBILKC5kg5zEfTnHFlh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NO/3AVzfxZj0CItYpl+TDQlWOizqfbFPYCBqv/Kd0nzi8f+0JOqcWIIdbtc+poV3Z0jCSgaS9hIOEUlNVrgED+SMF2dm1yZaVCtm0gQeD83vNTktPSfJwQXCiNOuPRzJ6ajuvCmrsU0msX29CUsrUkV2ZGNX4EsHU4mHRUj4ryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uuUYR8H/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uuUYR8H/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0285B1F00A3A;
	Tue, 21 Jul 2026 16:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649670;
	bh=EIpLdiRrLA3hntvE1jvpaK/aKiMtKDktXnTjN8RISOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uuUYR8H/C/FhX+vKslJwU6F+38L29BHB4xtckQ2Bna1O3+9Y+nyvGqxlMZyP4gp9H
	 HQrN1gYZ/7PeyRUrpiZNUS86sypKbKLLsYbBiQIfOaiNDg1pYTy/TnGvnPQjIv+zSW
	 b3ctjSugO6UPp2x2lWCEdo785O3ir9LSE/t0F0IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Kshevetskiy <mikhail.kshevetskiy@iopsys.eu>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0665/2077] pinctrl: airoha: an7581: fix misprint in gpio19 pinconf
Date: Tue, 21 Jul 2026 17:05:38 +0200
Message-ID: <20260721152608.489237047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c0aed1b6079208..14b2357277360b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-airoha.c
+++ b/drivers/pinctrl/mediatek/pinctrl-airoha.c
@@ -1798,7 +1798,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_pullup_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_PU, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_PU, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_PU, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_PU, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_PU, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_PU, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_PU, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_PU, BIT(22)),
@@ -1915,7 +1915,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_pulldown_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_PD, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_PD, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_PD, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_PD, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_PD, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_PD, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_PD, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_PD, BIT(22)),
@@ -2032,7 +2032,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_drive_e2_conf[] = {
 	PINCTRL_CONF_DESC(29, REG_GPIO_L_E2, BIT(16)),
 	PINCTRL_CONF_DESC(30, REG_GPIO_L_E2, BIT(17)),
 	PINCTRL_CONF_DESC(31, REG_GPIO_L_E2, BIT(18)),
-	PINCTRL_CONF_DESC(32, REG_GPIO_L_E2, BIT(18)),
+	PINCTRL_CONF_DESC(32, REG_GPIO_L_E2, BIT(19)),
 	PINCTRL_CONF_DESC(33, REG_GPIO_L_E2, BIT(20)),
 	PINCTRL_CONF_DESC(34, REG_GPIO_L_E2, BIT(21)),
 	PINCTRL_CONF_DESC(35, REG_GPIO_L_E2, BIT(22)),
@@ -2149,7 +2149,7 @@ static const struct airoha_pinctrl_conf en7581_pinctrl_drive_e4_conf[] = {
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



