Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FC1A735
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRa3Vwm7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31EF8C433C8;
	Mon,  9 Oct 2023 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859471;
	bh=IVKqACwMBuInVNeWMSFrl11Po/Q/ZsM5VG2XgTNdaos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRa3Vwm7haJbvYtQKdZbS72gEdpbajIIiLkWEs4lwDu9tC1C+p4/vp0hzvfFElx1N
	 wQgNfdp9xWDg4OMYwrh+TWi+AxzWHk5Ips1/DEmaTIWfJbh7A9TQ1vrKXq/al8lMJp
	 HYIYC5YSXjstGcvESnTlo+ff6Uv3bfKxUdLTe3Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 31/91] gpio: pmic-eic-sprd: Add can_sleep flag for PMIC EIC chip
Date: Mon,  9 Oct 2023 15:06:03 +0200
Message-ID: <20231009130112.607159234@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130111.518916887@linuxfoundation.org>
References: <20231009130111.518916887@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 26d9e5640d2130ee16df7b1fb6a908f460ab004c ]

The drivers uses a mutex and I2C bus access in its PMIC EIC chip
get implementation. This means these functions can sleep and the PMIC EIC
chip should set the can_sleep property to true.

This will ensure that a warning is printed when trying to get the
value from a context that potentially can't sleep.

Fixes: 348f3cde84ab ("gpio: Add Spreadtrum PMIC EIC driver support")
Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pmic-eic-sprd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-pmic-eic-sprd.c b/drivers/gpio/gpio-pmic-eic-sprd.c
index 29e044ff4b17d..7697cb96bf36f 100644
--- a/drivers/gpio/gpio-pmic-eic-sprd.c
+++ b/drivers/gpio/gpio-pmic-eic-sprd.c
@@ -341,6 +341,7 @@ static int sprd_pmic_eic_probe(struct platform_device *pdev)
 	pmic_eic->chip.set_config = sprd_pmic_eic_set_config;
 	pmic_eic->chip.set = sprd_pmic_eic_set;
 	pmic_eic->chip.get = sprd_pmic_eic_get;
+	pmic_eic->chip.can_sleep = true;
 
 	pmic_eic->intc.name = dev_name(&pdev->dev);
 	pmic_eic->intc.irq_mask = sprd_pmic_eic_irq_mask;
-- 
2.40.1



