Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024408;
	b=O0TXM6Q03IDeVFKY/G2gLZypTHJqPWZmaJrZLGzdHU0mBLmMH4/36laWcpIdQOOllfxJ
	 IWC6HcAI+DOOhAzGkmPX+V5sKuCFa8D4CQq6T5Q8K6E70e9ELq1leoxnylrVHfmlwSLGC
	 wFQNOnkyJib7I74zddZa6MmyD215riQbRKX98Fb78M/CFE2YZfTTTGQsZ3MsZDX3sCQpy
	 qsx6klpcAn3xDXZMkwBjwwRHBEmpLmjtLYPB/bXaxEU7dxBHZESHBS/jmQ0eabKKc193s
	 FH2thNZFNcU/scs4XLIU0dN8GCJL1QY0mKnXxxQkkIQhv9rhKh2RMrlXQPPIW9HELpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3VLxWVYBJqZumgQeLpA+wtNPl5liv7JmkA5R+4Jxy3w=;
	b=21dIyJvvMXs9sy6z+VSEMO9ToLZeojMaRqLfypY1huHyXZIp8+K5ahvoksgpnBOvPVuj
	 +kFr9GlTrzzFfg2YHZ5/wkXXVMdxgWEpFzdSjL9+jgdOEl02hCBMgEs99khMByDp65m/P
	 Kn9biPzP6V09nFRpgH3OySc9SSamRK3DbuXmix8BLjv9U25dT7mxGOoU4vQMYWtCVkUTx
	 aHx6HGNqu+5Uen/N/rfnH5e8gnUArOJqHVutV+LxlV/9Of1z76ARBbZ4EqCwA89FrUGx+
	 RtPDy6JcKqNZAaFn1s4x+hzPuo7aHq/bhtdSizNfKDozO5XlzrcwVc3GHSJaun3NWog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QLA+2/Pi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0315606A31C;
	Wed, 18 Nov 2026 17:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QLA+2/Pi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269691F000C4;
	Wed, 18 Nov 2026 17:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024408;
	bh=3VLxWVYBJqZumgQeLpA+wtNPl5liv7JmkA5R+4Jxy3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QLA+2/PilLV3+EacHhq7L+P6HhcwkRMs+5HRdWdBvt2ncsJHguH4o0ZGjFrsreaFZ
	 28h6FffKbc70MAUmuYVQjh/jsA+sexQRdG174n/zpD/4DwCAYvWigPRGS8sxxYtcvl
	 0HUIbzCKMVhqFDf5ywpKJHPcwtOUy6zna9ZibU8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0715/2151] spi: rockchip-sfc: skip DMA cleanup in PIO mode
Date: Wed, 18 Nov 2026 15:40:50 +0100
Message-ID: <20261118150147.923917284@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 926f9c44a76fe9e722180d0804c607c6cf1ebbb4 ]

With rockchip,sfc-no-dma, probe skips allocating and mapping the transfer
buffer. However, controller registration failure and driver removal still
call dma_unmap_single() for that nonexistent mapping.

Guard the DMA mapping and buffer cleanup with use_dma. Keep the existing
cleanup for allocation and mapping failures on the DMA path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: ee795e82e101 ("spi: rockchip-sfc: Fix DMA-API usage")
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260912190056.42192-1-mhun512@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index 4ad845cf70670..6ac0bc2905c24 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -720,10 +720,12 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 
 	return 0;
 err_register:
-	dma_unmap_single(dev, sfc->dma_buffer, sfc->max_iosize,
-			 DMA_BIDIRECTIONAL);
+	if (sfc->use_dma)
+		dma_unmap_single(dev, sfc->dma_buffer, sfc->max_iosize,
+				 DMA_BIDIRECTIONAL);
 err_dma_map:
-	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
+	if (sfc->use_dma)
+		free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
 err_dma:
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
@@ -749,9 +751,11 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-	dma_unmap_single(&pdev->dev, sfc->dma_buffer, sfc->max_iosize,
-			 DMA_BIDIRECTIONAL);
-	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
+	if (sfc->use_dma) {
+		dma_unmap_single(&pdev->dev, sfc->dma_buffer, sfc->max_iosize,
+				 DMA_BIDIRECTIONAL);
+		free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
+	}
 
 	clk_disable_unprepare(sfc->clk);
 	clk_disable_unprepare(sfc->hclk);
-- 
2.53.0



