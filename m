Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D9BBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C22C1C433EF;
	Tue,  7 Mar 2023 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215475;
	bh=cR+qk1JhWw2COPgCW0BvZsUAFliCfLF1PTI0k5q5nNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sHZ7LhPThdPZPUfu3C73oEvtMKrYFNlkoh57vH9n3NcJE6iiwpvRRf3wNvJt5dubI
	 vj7asTadBZfg01RybYtNS8fV+oBrBN01rDVU3I4hp6vyekug6LYHU45z4EOZMbbG6R
	 BVLWH67RElA7yLMtDLNCevkic48YFalrz7stT+oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 274/567] dmaengine: HISI_DMA should depend on ARCH_HISI
Date: Tue,  7 Mar 2023 18:00:10 +0100
Message-Id: <20230307165917.781055076@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit dcca9d045c0852584ad092123c7f6e6526a633b1 ]

The HiSilicon DMA Engine is only present on HiSilicon SoCs.  Hence add a
dependency on ARCH_HISI, to prevent asking the user about this driver
when configuring a kernel without HiSilicon SoC support.

Fixes: e9f08b65250d73ab ("dmaengine: hisilicon: Add Kunpeng DMA engine support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/363a1816d36cd3cf604d88ec90f97c75f604de64.1669044190.git.geert+renesas@glider.be
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 80c2c03cb0141..95344ae49e532 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -236,7 +236,7 @@ config FSL_RAID
 
 config HISI_DMA
 	tristate "HiSilicon DMA Engine support"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_HISI || COMPILE_TEST
 	depends on PCI_MSI
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
-- 
2.39.2



