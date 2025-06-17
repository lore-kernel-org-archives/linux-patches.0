Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4087202C38;
	Tue, 17 Jun 2025 16:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176684; cv=none; b=OU2uBGuVrx8w06t8+Ghz9OSNHrm/snjSxBmpo+HcXKxZCjbPl4PLSc43wRKV1xqLLmuaEF4yQQMZI4Ta0QGo5ypPIeBGJ2TpwDVORUD8k1gKn8+wTv69GPkFlJOYDP0OPuUrd49Q1aD1am9J9JalO6mW9LkQwMrKIrafdyoUHiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176684; c=relaxed/simple;
	bh=AuZjo+pUx7BCNBkaHxrCF+b4ndXte9Fjq6jLDSXWZbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcWAbzczspHnyHmVn3Wa6V+dCufY0236kNOM2VIO8WP+ufCjckYTslSN8awSnPWVB3BVgKBHR8ncX/d/vkyZMtdZObUmAxUph6P0uxbDh89podoTi6bFr8ZE5RyuBuzBan1+dlC87/NOblhRItou38M5uzoBogcx5Yu4fhOrRjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zMNPontN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zMNPontN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CEDC4CEE3;
	Tue, 17 Jun 2025 16:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176683;
	bh=AuZjo+pUx7BCNBkaHxrCF+b4ndXte9Fjq6jLDSXWZbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zMNPontNvVNcaIq05kgcQeUNXSu/fMAxyK7ppKHSEvzkwzaDECSlakQqMM7fiSDsH
	 qrAvApRoJNU5VlioVooGC9osHcAFUm9YsdAqoeg0TVYp4S9jb5rvcx+G9iBVxizxIe
	 7koKuiUJYcVR4qdgLpzBIKLV4NPsh04RHYvm+30o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Slenska <wojciech.slenska@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 304/356] pinctrl: qcom: pinctrl-qcm2290: Add missing pins
Date: Tue, 17 Jun 2025 17:26:59 +0200
Message-ID: <20250617152350.405201823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wojciech Slenska <wojciech.slenska@gmail.com>

[ Upstream commit 315345610faee8a0568b522dba9e35067d1732ab ]

Added the missing pins to the qcm2290_pins table.

Signed-off-by: Wojciech Slenska <wojciech.slenska@gmail.com>
Fixes: 48e049ef1238 ("pinctrl: qcom: Add QCM2290 pinctrl driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/20250523101437.59092-1-wojciech.slenska@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-qcm2290.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-qcm2290.c b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
index f5c1c427b44e9..61b7c22e963c2 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcm2290.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
@@ -165,6 +165,10 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
 	PINCTRL_PIN(62, "GPIO_62"),
 	PINCTRL_PIN(63, "GPIO_63"),
 	PINCTRL_PIN(64, "GPIO_64"),
+	PINCTRL_PIN(65, "GPIO_65"),
+	PINCTRL_PIN(66, "GPIO_66"),
+	PINCTRL_PIN(67, "GPIO_67"),
+	PINCTRL_PIN(68, "GPIO_68"),
 	PINCTRL_PIN(69, "GPIO_69"),
 	PINCTRL_PIN(70, "GPIO_70"),
 	PINCTRL_PIN(71, "GPIO_71"),
@@ -179,12 +183,17 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
 	PINCTRL_PIN(80, "GPIO_80"),
 	PINCTRL_PIN(81, "GPIO_81"),
 	PINCTRL_PIN(82, "GPIO_82"),
+	PINCTRL_PIN(83, "GPIO_83"),
+	PINCTRL_PIN(84, "GPIO_84"),
+	PINCTRL_PIN(85, "GPIO_85"),
 	PINCTRL_PIN(86, "GPIO_86"),
 	PINCTRL_PIN(87, "GPIO_87"),
 	PINCTRL_PIN(88, "GPIO_88"),
 	PINCTRL_PIN(89, "GPIO_89"),
 	PINCTRL_PIN(90, "GPIO_90"),
 	PINCTRL_PIN(91, "GPIO_91"),
+	PINCTRL_PIN(92, "GPIO_92"),
+	PINCTRL_PIN(93, "GPIO_93"),
 	PINCTRL_PIN(94, "GPIO_94"),
 	PINCTRL_PIN(95, "GPIO_95"),
 	PINCTRL_PIN(96, "GPIO_96"),
-- 
2.39.5



