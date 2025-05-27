Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A83C01;
	Tue, 27 May 2025 17:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367308; cv=none; b=BQbGBVFQMi/Pe5AQfsr8QY5iLBJheodeYMHVOA2dqK4R+vu4uYC/8ZQOBdSUgCtfdBqXPA+peAI8HKqgHn2NmVBB1RaOjNIT1oSx+1hQEJAj1kHa7LF9MutEMWN3GyNRsObGN9PliRRJu3QrC45MJ4rYeRBLxZTtYi0flYAiDRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367308; c=relaxed/simple;
	bh=bW9E0KUWfRUIcLYu5MfyMxB+aYJMVXNi5tQFaWrCbZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZbIALnGT6bLUZmbpLbVHW4dHpF7yfYVmWoP41CV1jXmRxr9ESeXo8/frTSQQiRtXs8kjDv78xeUvHyOBF2haSAt8KEjYGqvt+ZBOy23+6Aur9UEvGOQEMQi+KfmFXrfGF3zAAlbIopS2dFvn1iWSV/soGzsGTdBuzgMhCbicdL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6H9ZHp6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6H9ZHp6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D3C4CEE9;
	Tue, 27 May 2025 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367308;
	bh=bW9E0KUWfRUIcLYu5MfyMxB+aYJMVXNi5tQFaWrCbZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6H9ZHp6fU9iHBVAmfUBZ9Uynx834lrvbShzp3lgEC2j8eVomUSSb4I0DKMN9w9v5
	 KVsNQ+4eN8fgJEDP0dEO8iqI8Ha76tk9nj9qXPt0p4DvaK+7N2zz7rj6lVXfa2+aK3
	 80zevU/d0ftNe3amosWCZsV2HYgkOFjbw6pXM+SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dang Huynh <danct12@riseup.net>,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 344/783] pinctrl: qcom: msm8917: Add MSM8937 wsa_reset pin
Date: Tue, 27 May 2025 18:22:21 +0200
Message-ID: <20250527162527.074843743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dang Huynh <danct12@riseup.net>

[ Upstream commit 3dd3ab690172b11758e17775cfbf98986ec0cb71 ]

It looks like both 8917 and 8937 are the same except for one pin
"wsa_reset".

Signed-off-by: Dang Huynh <danct12@riseup.net>
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://lore.kernel.org/20250211-msm8937-v1-4-7d27ed67f708@mainlining.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/Kconfig.msm       | 4 ++--
 drivers/pinctrl/qcom/pinctrl-msm8917.c | 8 +++++++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/qcom/Kconfig.msm b/drivers/pinctrl/qcom/Kconfig.msm
index 35f47660a56b1..a0d63a6725393 100644
--- a/drivers/pinctrl/qcom/Kconfig.msm
+++ b/drivers/pinctrl/qcom/Kconfig.msm
@@ -138,10 +138,10 @@ config PINCTRL_MSM8916
 	  Qualcomm TLMM block found on the Qualcomm 8916 platform.
 
 config PINCTRL_MSM8917
-	tristate "Qualcomm 8917 pin controller driver"
+	tristate "Qualcomm 8917/8937 pin controller driver"
 	help
 	  This is the pinctrl, pinmux, pinconf and gpiolib driver for the
-	  Qualcomm TLMM block found on the Qualcomm MSM8917 platform.
+	  Qualcomm TLMM block found on the Qualcomm MSM8917, MSM8937 platform.
 
 config PINCTRL_MSM8953
 	tristate "Qualcomm 8953 pin controller driver"
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8917.c b/drivers/pinctrl/qcom/pinctrl-msm8917.c
index cff137bb3b23f..350636807b07d 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8917.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8917.c
@@ -539,6 +539,7 @@ enum msm8917_functions {
 	msm_mux_webcam_standby,
 	msm_mux_wsa_io,
 	msm_mux_wsa_irq,
+	msm_mux_wsa_reset,
 	msm_mux__,
 };
 
@@ -1123,6 +1124,10 @@ static const char * const wsa_io_groups[] = {
 	"gpio94", "gpio95",
 };
 
+static const char * const wsa_reset_groups[] = {
+	"gpio96",
+};
+
 static const char * const blsp_spi8_groups[] = {
 	"gpio96", "gpio97", "gpio98", "gpio99",
 };
@@ -1378,6 +1383,7 @@ static const struct pinfunction msm8917_functions[] = {
 	MSM_PIN_FUNCTION(webcam_standby),
 	MSM_PIN_FUNCTION(wsa_io),
 	MSM_PIN_FUNCTION(wsa_irq),
+	MSM_PIN_FUNCTION(wsa_reset),
 };
 
 static const struct msm_pingroup msm8917_groups[] = {
@@ -1616,5 +1622,5 @@ static void __exit msm8917_pinctrl_exit(void)
 }
 module_exit(msm8917_pinctrl_exit);
 
-MODULE_DESCRIPTION("Qualcomm msm8917 pinctrl driver");
+MODULE_DESCRIPTION("Qualcomm msm8917/msm8937 pinctrl driver");
 MODULE_LICENSE("GPL");
-- 
2.39.5



