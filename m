Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D86D3203AD;
	Mon, 18 Aug 2025 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525927; cv=none; b=kb3baOd880Uwha0gBSHhw8JCqu3/QHzsqv/k5vk5I5vhccOh0L2fo5TEM9Qrg+PRQrSLqXgUbcP5np4sdCnv/I0E9gM09jyVic20kOt8j7+PXzqOS7132HStTmoY4dH6I21W+CSRRoy3PabTgvOKsOmr/ppcyvLseER7/2uR4Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525927; c=relaxed/simple;
	bh=/gtzECWCY87Py4TBD9lPoTSsMHXeQ9rrH3AzqCi8Yu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btkx6hF/Z5wcgovAIakn5w3JnGk6md+RR/Zmj2nS7ZZM9RjaldXFcLRzXFG+LwEBsfqBJyA0+ccfPokGA8PxC8XYmg5wEMrr3u9wHxbQiD4vfjoCwA2AZbjp2sn37WOLMTNDs8aIGUtX24Krc5TOkyNl/gwC2io69tdxD17jCQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTPxm3Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTPxm3Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7B9C4CEEB;
	Mon, 18 Aug 2025 14:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525927;
	bh=/gtzECWCY87Py4TBD9lPoTSsMHXeQ9rrH3AzqCi8Yu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bTPxm3VxPTg891wW3+WEr1eNH16Tk2vG3mizpmdNIAdmLYxbVDadQU45TukvwKRZq
	 EaVkEIaEr+RjPHfH10K6EUNGDzaXzlUDsi3MKxCDUtIIFU2TXW0y5MukG2KYhfK2Le
	 JXT7FQwT1eHoKNg0Eyiyn7ikYoPoVjOKRfnshSfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 406/570] pinctrl: stm32: Manage irq affinity settings
Date: Mon, 18 Aug 2025 14:46:33 +0200
Message-ID: <20250818124521.488607460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

[ Upstream commit 4c5cc2f65386e22166ce006efe515c667aa075e4 ]

Trying to set the affinity of the interrupts associated to stm32
pinctrl results in a write error.

Fill struct irq_chip::irq_set_affinity to use the default helper
function.

Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Link: https://lore.kernel.org/20250610143042.295376-3-antonio.borneo@foss.st.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/pinctrl-stm32.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index ba49d48c3a1d..e6ad63df82b7 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -411,6 +411,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



