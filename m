Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049188;
	b=fzmige1YyYhqRXNNZ0tHWnMXK9bGksqqG5DSvu8Uo4B/X/n0EluIEiPBrWpPRmgixLFL
	 OhFQiCs6nvAB8lblGV1h6Ruptf8Xf61a8QqJWZKSRCzEQuON+7KHjJMXo5kx56NBkZXXj
	 5HoUusChs73iuZnTPTy0SMhj0s9Q/kIbMXIVu5YMgFwl4Rv2PWZTFgqoS8HCysce/s5yy
	 vKSU/PemMzw+kHtMHlU+URpuutG/CNfSGA+iPrQfb7V4zdvLIyT3LSrLREbyQMQyZ8jjl
	 RxQ2Jq2FcmQteYdPGZc1P9FdfFU46GJylhIEeTLIc1jjmrcQK6aN9y/5cPY0tt4fpOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CxpfdcP9DkN+n5o/8FNDUa1WGDUPvgywbCcBX3FV5go=;
	b=TAw9YQi1TJhJzzcsPh9yfJ3FaLntM7YSNqJNmMH7aWHEkxuD8bcTlVxi3uR0Tki+CSci
	 1P9DVUiFsb1OJ2aYnCHkHPKU/CrDmjF4GUEJrNl667TM+QTvVqTUnn5HTdLTGVDRQyFnA
	 9m5xlA//Yq2lr1uh5ZT/z5n0ysD2P2ZYw2sTlrA9hCZ7T1UO9bScSC4hYxWsHsEHAxHdm
	 L7ObMzMBwbknvMDLD4CRBs2KophcM2K38+Ugz2mWdnhXhaYkce8P3dqxOiWxV6rcK44iO
	 tQcxhQcKVPf+WDUENlp6nvbJz7JIQp41zVoUyl2St2P+FdIfsB3e10GQ5fqvYhl/cNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KscMywi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B9606A331;
	Thu, 19 Nov 2026 00:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0KscMywi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C6F1F000C4;
	Thu, 19 Nov 2026 00:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049188;
	bh=CxpfdcP9DkN+n5o/8FNDUa1WGDUPvgywbCcBX3FV5go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0KscMywiWUdtJXXuLKpe6+4TkHsTaeOEaQE/BLUK19/wHRq8ghoN6SzZ/RFXPoibc
	 WwgjI3XfpybjICZxO73vP2EUQuem179F8NlgVdJNns3kU7b/lfqE6PKRGyXKoikhR/
	 a+peLqI3RsfdXxhdOCj5uAA0A6Lv6HZgc+VDN2e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2261/2857] dmaengine: ste_dma40: Pass dev to OF function
Date: Wed, 18 Nov 2026 15:54:55 +0100
Message-ID: <20261118150322.856994766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit e59d81e9173ae4b5037a81a08b1c5a6915b333e3 ]

The OF platform data population function only wants to
use struct device *dev, so pass that instead.

This change makes the compiler realize that the local
platform data variable is unused, so drop that too.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20230417-ux500-dma40-cleanup-v3-5-60bfa6785968@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: f2baf04a695d ("dmaengine: ste_dma40: Fix memcpy channel parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 87825a157d470..63e93d99f533a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3490,14 +3490,14 @@ static int __init d40_lcla_allocate(struct d40_base *base)
 	return ret;
 }
 
-static int __init d40_of_probe(struct platform_device *pdev,
+static int __init d40_of_probe(struct device *dev,
 			       struct device_node *np)
 {
 	struct stedma40_platform_data *pdata;
 	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
 	const __be32 *list;
 
-	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
@@ -3510,7 +3510,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	num_memcpy /= sizeof(*list);
 
 	if (num_memcpy > D40_MEMCPY_MAX_CHANS || num_memcpy <= 0) {
-		d40_err(&pdev->dev,
+		d40_err(dev,
 			"Invalid number of memcpy channels specified (%d)\n",
 			num_memcpy);
 		return -EINVAL;
@@ -3525,7 +3525,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	num_disabled /= sizeof(*list);
 
 	if (num_disabled >= STEDMA40_MAX_PHYS || num_disabled < 0) {
-		d40_err(&pdev->dev,
+		d40_err(dev,
 			"Invalid number of disabled channels specified (%d)\n",
 			num_disabled);
 		return -EINVAL;
@@ -3536,7 +3536,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 				   num_disabled);
 	pdata->disabled_channels[num_disabled] = -1;
 
-	pdev->dev.platform_data = pdata;
+	dev->platform_data = pdata;
 
 	return 0;
 }
@@ -3544,7 +3544,6 @@ static int __init d40_of_probe(struct platform_device *pdev,
 static int __init d40_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct stedma40_platform_data *plat_data = dev_get_platdata(dev);
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *np_lcpa;
 	int ret = -ENOENT;
@@ -3554,7 +3553,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	int num_reserved_chans;
 	u32 val;
 
-	if (d40_of_probe(pdev, np)) {
+	if (d40_of_probe(dev, np)) {
 		ret = -ENOMEM;
 		goto report_failure;
 	}
-- 
2.53.0



