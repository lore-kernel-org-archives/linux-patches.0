Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242FA2AE68;
	Tue, 26 Aug 2025 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217955; cv=none; b=eANTPpPel9NSPEZjIJBpHQsyZ9tJ1rI4qe6xFYutDK7fFhb0/NfcnNxIPrwfVzrZ1cwK1i2RIkQ/PTRWUV0wGy/2ejYd1Feis/zojxdYuDwAg+ZFSbTa+SuzSRBrByLoddg6FcG7GhrRfC2o+UZiocJSJqsJVhjVDMvzgcdAPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217955; c=relaxed/simple;
	bh=c4CnVwBlD/d+ErDm9rNdZERF4iqeYLN5+2hZMuhnsW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRhHDTm0OdpPcsoNYxrTpfoBkRE08z0glLQa6vxxGgNQ+LBh+/GG1QMaHbrh9t2zUG6otK1lt6gakSLnFr5ZTEwUQaoebYyHEQPLUF53RKwEGiW38MfLEJ9BiXM0xjH2WMjVOEgarUbk2uhMol9a3xoQXCKeMX/sCtomKLaUH+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qCRSJJgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qCRSJJgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9700C4CEF1;
	Tue, 26 Aug 2025 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217955;
	bh=c4CnVwBlD/d+ErDm9rNdZERF4iqeYLN5+2hZMuhnsW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qCRSJJgDMseFkS4o7kOkfyaTrinMW7mI/s8JudOlmn0kFw1mSnwpoHRn+7956YBVq
	 qRINVZjSg+UHWYUSADtoxFeh65bJ7M5Uysjq2Ih01TZNSa/Ooe6FBGgNFbsm2yqmx0
	 HBbWeJar0URxkUAvzc9D81ks761+F5MidZO1m/zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheick Traore <cheick.traore@foss.st.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 307/523] pinctrl: stm32: Manage irq affinity settings
Date: Tue, 26 Aug 2025 13:08:37 +0200
Message-ID: <20250826110932.030541049@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2d852f15cc50..6b6fdb711659 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -412,6 +412,7 @@ static struct irq_chip stm32_gpio_irq_chip = {
 	.irq_set_wake	= irq_chip_set_wake_parent,
 	.irq_request_resources = stm32_gpio_irq_request_resources,
 	.irq_release_resources = stm32_gpio_irq_release_resources,
+	.irq_set_affinity = IS_ENABLED(CONFIG_SMP) ? irq_chip_set_affinity_parent : NULL,
 };
 
 static int stm32_gpio_domain_translate(struct irq_domain *d,
-- 
2.39.5



