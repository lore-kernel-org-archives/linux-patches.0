Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240E819049B;
	Mon, 23 Jun 2025 21:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715460; cv=none; b=gbK8pgOsnkdetWqRJMZaDX4m1qcNvHQzdekLMnQs7wawBwMAe9iXmCvrx9L23OB2lCj0ni5JCCek6j7b4YhlnZRvtdSsnjgDD+d9eWNRFLAicSb4B4Hm+yowV/0QGy3BrS4nDEnO/PAf0UnDzP3u43+QkR2Yt+KIlJ8qCeSAtTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715460; c=relaxed/simple;
	bh=omoRU4XsPZchUy8cN9S/5ninhSrbKlSCO6zRQGVWbBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBp9G7uvBm4sH0v/D3rVVrc4XSEGZSBh1wN5JLlt6DLbRmCA4gDQFwr2dOZkx6cPIDyRczxDUIs5ctzsXV+vX69pRBuwWSbAuBH689L4atGqJ2oziZHNaYNzjtGA8a2MHrKzr3YLS0bcBTrVO1mMV2Sn53k2JUQGm+JLRfk34Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQpmbBqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQpmbBqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC1BC4CEEA;
	Mon, 23 Jun 2025 21:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715460;
	bh=omoRU4XsPZchUy8cN9S/5ninhSrbKlSCO6zRQGVWbBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQpmbBqmOrE/V8Exu8JmygxwroYGVOsLcTj61VGRePC+WalkK0meHUy1XCoEvowHO
	 ZDKeYfXKYGWVWIQCihwMjpbNxi1DQYCM+BYvWZCwW1dfuWeONrz4DYjM8NF6ZWgskj
	 jzJT/kPdoDGS+SENhPJNtYRQO4wrN4MZn7jQBUAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wojciech Slenska <wojciech.slenska@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/508] pinctrl: qcom: pinctrl-qcm2290: Add missing pins
Date: Mon, 23 Jun 2025 15:04:41 +0200
Message-ID: <20250623130651.064056509@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aa9325f333fba..fa4575a9396ae 100644
--- a/drivers/pinctrl/qcom/pinctrl-qcm2290.c
+++ b/drivers/pinctrl/qcom/pinctrl-qcm2290.c
@@ -173,6 +173,10 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
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
@@ -187,12 +191,17 @@ static const struct pinctrl_pin_desc qcm2290_pins[] = {
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



