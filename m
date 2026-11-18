Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017241;
	b=V0VwJ5jOm0SM1+jjqwH4o3IkoNnrZyeStmYC18Spznh2aDcJrSIDQmuWO4eWEbkGxD8r
	 lU+GObEVl70tdLMs6+cE32/IQU12gCJrKBuiC7S7GqNJ61YhiEBxq7nU9ymEuWcBmgn1A
	 O8Qmm/JkxmVZUN+2BRYYKjmzI8Ffh3dkWMnrcIqz3PqWgRli16wUzZlFaFiVr7ubBNS5l
	 lHPLNyK+pY34s1vlFHyJmmApdqYPq5ItKZUyDiZtAfD91VrSNzuMdrvcW60bZiLhZmZsr
	 JvYEkmjZOjDN9unWODGLW40iYI/B4Joi1bCDCVTjGXX/ql9ATrKkjFc9ZfafG7KeCLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zi1sGIO9o6s0ykcaAltPm4HBVW2ygD/0nqZs54f8Avk=;
	b=spnWBfhjYc81rm+u/Rb7wkF2ry1lqbrUkaj4kg6cOytlCglyBow2C0gG85NH0PaSF/Q7
	 QsrGiQ7WO8RqteTwQ10gDxrEzHU7qrpHL7/NmMZjsFnUeG8EPPVYrvVH6F+Qcm52s6WvS
	 gnGqRceKSurzihOuOROKZo0sFPv7/9oOddmZTOLK3nyMx+9csjKwT76ahRTPAiMPj92Ec
	 z6Fz4LlCJBmsld68YdhhpVuMFOS9D37bWBk7/BHxlspCO9xmDmYRJ94PAdbLDkdKkf+9d
	 aDuy5SJ/mgiz9lThjPpwyAkzdWD0xI6HlFrY+5Qd7xuuwXH4aEgfzM4JFE15CNRFi6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="s7CwJ/O9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD87B606A320;
	Wed, 18 Nov 2026 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7CwJ/O9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C864B1F000C4;
	Wed, 18 Nov 2026 15:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017241;
	bh=Zi1sGIO9o6s0ykcaAltPm4HBVW2ygD/0nqZs54f8Avk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7CwJ/O9cnGdsSjbp64c0ICZcqCqyYaHXex0jsrV/hkrPF8DdswOzYVMJAKtfjw9T
	 LILZzbYhNCrulk4zK/OY5msM2BDckqf0ZBc7kY0IIm822hpqEXFtPtnnYptfBuEn3+
	 MMZGg2M7S6fFgCnGsuMbC0IQ9Cyp/Mj/Z4/Pl6Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0813/2651] spi: rockchip-sfc: skip DMA cleanup in PIO mode
Date: Wed, 18 Nov 2026 15:34:13 +0100
Message-ID: <20261118150317.170200377@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 43e91b49bb1dc..a85a260ba95f7 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -719,10 +719,12 @@ static int rockchip_sfc_probe(struct platform_device *pdev)
 
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
@@ -748,9 +750,11 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
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



