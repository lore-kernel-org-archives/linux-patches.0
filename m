Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EFF746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138E9C433F0;
	Thu, 12 Jan 2023 14:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532069;
	bh=T13BHHEVDg1pwjfe5+N4wKRWC5r/tMgNVAkz78zWJIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBKZSldm0i3jHZ/ebp6XlMAkWfdzrerJk+VdPHzn559uWqkHTd9RAuZKLz3+p1T0a
	 /tubrM2YVAa7KfPUnidrZSk2+Yd9SgkRJmLQLIP/O1o2qoeIpWBjFxOHub+D4sv1qV
	 QaWgp41jhsquyT3GoGDar4c8k/YA39keU0eaU7Jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/783] soc: qcom: llcc: make irq truly optional
Date: Thu, 12 Jan 2023 14:45:28 +0100
Message-Id: <20230112135524.748600084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit c882c899ead3545102a4d71b5fbe73b9e4bc2657 ]

The function platform_get_irq prints an error message into the kernel
log when the irq isn't found.

Since the interrupt is actually optional and not provided by some SoCs,
use platform_get_irq_optional which does not print an error message.

Fixes: c081f3060fab ("soc: qcom: Add support to register LLCC EDAC driver")
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221104153041.412020-1-luca.weiss@fairphone.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/llcc-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/llcc-qcom.c b/drivers/soc/qcom/llcc-qcom.c
index 2e06f48d683d..c60fe98f03e3 100644
--- a/drivers/soc/qcom/llcc-qcom.c
+++ b/drivers/soc/qcom/llcc-qcom.c
@@ -476,7 +476,7 @@ static int qcom_llcc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err;
 
-	drv_data->ecc_irq = platform_get_irq(pdev, 0);
+	drv_data->ecc_irq = platform_get_irq_optional(pdev, 0);
 	if (drv_data->ecc_irq >= 0) {
 		llcc_edac = platform_device_register_data(&pdev->dev,
 						"qcom_llcc_edac", -1, drv_data,
-- 
2.35.1



