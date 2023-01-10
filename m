Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD26A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43B06C433EF;
	Tue, 10 Jan 2023 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374269;
	bh=Mgp1tA2OFevIx3mzZEDuWq5RCF5ZS41ytX25kB19hJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnxPO/deiAYAZ+J22CeDQssHYMNmDnVqNBG0LjLEteADcX8OtAFg2ubglrx6fjf5Q
	 Si4e00sC5QVIN/Hvz7twp1wzgAX7+ve85PLUdZbh7j9pKSwE2EgNUVI6fD6ZOjJ0J7
	 pKVea3m3Bt3Cz1Y348j5KMm1XGM1BX1yOLRSlxfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 102/148] usb: dwc3: xilinx: include linux/gpio/consumer.h
Date: Tue, 10 Jan 2023 19:03:26 +0100
Message-Id: <20230110180020.424948655@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e498a04443240c15c3c857165f7b652b87f4fd96 ]

The newly added gpio consumer calls cause a build failure in configurations
that fail to include the right header implicitly:

drivers/usb/dwc3/dwc3-xilinx.c: In function 'dwc3_xlnx_init_zynqmp':
drivers/usb/dwc3/dwc3-xilinx.c:207:22: error: implicit declaration of function 'devm_gpiod_get_optional'; did you mean 'devm_clk_get_optional'? [-Werror=implicit-function-declaration]
  207 |         reset_gpio = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
      |                      ^~~~~~~~~~~~~~~~~~~~~~~
      |                      devm_clk_get_optional

Fixes: ca05b38252d7 ("usb: dwc3: xilinx: Add gpio-reset support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230103121755.956027-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index 67b237c7a76a..550ae64350df 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -13,6 +13,7 @@
 #include <linux/of.h>
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
+#include <linux/gpio/consumer.h>
 #include <linux/of_gpio.h>
 #include <linux/of_platform.h>
 #include <linux/pm_runtime.h>
-- 
2.35.1



