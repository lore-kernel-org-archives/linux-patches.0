Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B78E0BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD00C433D2;
	Tue,  7 Mar 2023 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213177;
	bh=iTw/78BSAVpQZvd+pK66e2spGCGmHFO/fPM0Sq5d/68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdEWel26t92MmK2L7bGtcEkGdZo2co7z2fhb9zAH/lvWKCPmeO89qKWKBvK3YT2lF
	 dtlMce6gdkYfD7iLMbrYwcHEus2G/j1Au0nB2DUD6KyN1fyKxt2cTSdx8B134rTqSZ
	 5Mgi8jSRJFUZYY2TvdWoCh+woG+gIY96U4pWdOP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 406/885] dmaengine: HISI_DMA should depend on ARCH_HISI
Date: Tue,  7 Mar 2023 17:55:40 +0100
Message-Id: <20230307170020.045905196@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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
index 7524b62a8870a..b64ae02c26f8c 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -244,7 +244,7 @@ config FSL_RAID
 
 config HISI_DMA
 	tristate "HiSilicon DMA Engine support"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_HISI || COMPILE_TEST
 	depends on PCI_MSI
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
-- 
2.39.2



