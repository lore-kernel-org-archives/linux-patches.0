Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CE83314C3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301230; cv=none; b=KgKgcQy2mrw1EcWIB0LDGKPTIEkf+cm0QWAEoBfxJbmSpyrlE0CLLaiwG0eTY3We8TM+bzgMS9OkSOohiYC1wcv9l3QrTClqEGq/B+Kcouf4Dx/teYPorePZHpqwitGUGLCBEYW5Rhn+5vacAKfStdRb1nRgrGAMe0aMiipsuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301230; c=relaxed/simple;
	bh=weKkzB8KZ5DLReewVFSur3h8mJwcAvL7MIgP5XVfu5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0qimWzZ6MJHliKmtEtkurmeEbufQPe8uQy1CNEHTkeGJ7PhW269ZCVHEUh7OBkb2O/ZKJfSyWMsk2QyCvwbgJTSNxxDJEjrCQPN9q9sz5LlMzSO1sa0837JaJcpBAWKHHVXk1JzW8k2GOZCuTt9J866RiKkU6Od2elH+BEG7N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qk7dB9JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qk7dB9JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72468C19424;
	Sat, 28 Feb 2026 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301230;
	bh=weKkzB8KZ5DLReewVFSur3h8mJwcAvL7MIgP5XVfu5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qk7dB9JXhxw66Bhkjn+PhpfhXGccpJx+kkTSyGbVCFLL4Uqzb808/5K/3lo98SaHH
	 UwMr/wfbGSWFfErPNxO+utztvDPYm/iiVm/fbmvJM09oXbn7tpLD3vIlZmHD8AKI2T
	 eeKKNtr6jcHnZ90gNmgHBytomtV8gpPpVhv9Sf2+1OOA3ABf7nogfQAp5/5Z1rvwr0
	 slbndyWCbartz7zHCkMiWM0MOV4IuMFKVF4/tJf2rzoKuVtCPmZjad901/khtGLV3i
	 RmFaftlnC7co6Fkmv81AcKLwLkHbysdqC5c49Z9lCOcrpSp7xfIBNmhRruhIEVMY3I
	 ITVPyIq0SUZig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/752] net: phy: qcom: qca807x: normalize return value of gpio_get
Date: Sat, 28 Feb 2026 12:41:59 -0500
Message-ID: <20260228174750.1542406-408-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 2bb995e6155cb4f254574598cbd6fe1dcc99766a ]

The GPIO get callback is expected to return 0 or 1 (or a negative error
code). Ensure that the value returned by qca807x_gpio_get() is
normalized to the [0, 1] range.

Fixes: 86ef402d805d ("gpiolib: sanitize the return value of gpio_chip::get()")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/aZZeyr2ysqqk2GqA@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/qca807x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/qcom/qca807x.c b/drivers/net/phy/qcom/qca807x.c
index 1be8295a95cb5..511cde345e089 100644
--- a/drivers/net/phy/qcom/qca807x.c
+++ b/drivers/net/phy/qcom/qca807x.c
@@ -375,7 +375,7 @@ static int qca807x_gpio_get(struct gpio_chip *gc, unsigned int offset)
 	reg = QCA807X_MMD7_LED_FORCE_CTRL(offset);
 	val = phy_read_mmd(priv->phy, MDIO_MMD_AN, reg);
 
-	return FIELD_GET(QCA807X_GPIO_FORCE_MODE_MASK, val);
+	return !!FIELD_GET(QCA807X_GPIO_FORCE_MODE_MASK, val);
 }
 
 static int qca807x_gpio_set(struct gpio_chip *gc, unsigned int offset, int value)
-- 
2.51.0

