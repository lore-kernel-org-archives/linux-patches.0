Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061284;
	b=V9AHKepvpKevRbjpnC8TFD7mMXbjecdl26HoEzSc8Z/gxnXeCG8IVersJJYPW8STKpFU
	 iuSkS1dMMcUl9iASW2joAkjzt6S4srlXQHMTXmSMyom0SvRQW7WGs8MNTorqBi5fzXIik
	 3v626YeHJasc3/yunQiFREiOornSR4LOGrTXWo7TPpjdTZ0oxunWJzEMSldQ4BPRrKz8k
	 X54bhnHyt9CLJMpbW8k0yAELdDJKOAWzR+bTLYTPKzNbL8+Gb5Y72sv/DS4yLQdJxdDjm
	 zR0gHxB8FzSHiCidkmkfUyqRQ8tp7n8O9qLY2tp6neyt67TULGYz7pSZv3o7EHOeiFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBgKBBU82V+cQFf2cA3zJhdaOTYKd2IiuKR9h1YMyxE=;
	b=ZH22gE005NBaDRB1HUzmUuQGBqdhaFXmHGJZ5ziUFC6AAcC1XdmckdFhv5U4F+KjWIIp
	 +dYII1HCeo4glCp107UWe/XhMw9fbD5qK1d8WkEug3UzfEdLE5brrvk61fOoyuoMj/ZKo
	 NgVtJDFUwZACHKHEIJ42d3RaiKhJEhiR2niGKPZ5hszht3xXJrekMH7aLJg2Kvqg6/ObA
	 TjS10Ype9C8b0IzZHSHOmWwWuoDCV32cYdAxBd3xcggnCTYbKl4yHJHsdLffmCCKXSmCk
	 39SSvxsz3m21Bz+DCFBOK3/faYd3GI5b84fNvCY6BRVoDH50bIxWYzHJfGzSKM44hNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTiXMX9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A66760A2600;
	Thu, 19 Nov 2026 04:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTiXMX9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7ACB1F000C4;
	Thu, 19 Nov 2026 04:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061283;
	bh=PBgKBBU82V+cQFf2cA3zJhdaOTYKd2IiuKR9h1YMyxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTiXMX9GsylI+E2CP85hEkbKvndJJv/ZvWToD+HhOFp7tc8MaN3e5KPWWnFnUdyAi
	 EprXPLVidyfJKpwlrt6oo+bn9Gd/8IEFB/f1Op3GAsG5NuD3rl45gUy3te6DrZYsSX
	 3cfAbP5aCdtpkp5M/UrcxnlLzWhnsgHgGj2XI8uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1496/1848] dmaengine: ste_dma40: Pass dev to OF function
Date: Wed, 18 Nov 2026 15:58:54 +0100
Message-ID: <20261118150021.897212583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8a5574d1df00..4d401c4147f55 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3491,14 +3491,14 @@ static int __init d40_lcla_allocate(struct d40_base *base)
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
 
@@ -3511,7 +3511,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	num_memcpy /= sizeof(*list);
 
 	if (num_memcpy > D40_MEMCPY_MAX_CHANS || num_memcpy <= 0) {
-		d40_err(&pdev->dev,
+		d40_err(dev,
 			"Invalid number of memcpy channels specified (%d)\n",
 			num_memcpy);
 		return -EINVAL;
@@ -3526,7 +3526,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 	num_disabled /= sizeof(*list);
 
 	if (num_disabled >= STEDMA40_MAX_PHYS || num_disabled < 0) {
-		d40_err(&pdev->dev,
+		d40_err(dev,
 			"Invalid number of disabled channels specified (%d)\n",
 			num_disabled);
 		return -EINVAL;
@@ -3537,7 +3537,7 @@ static int __init d40_of_probe(struct platform_device *pdev,
 				   num_disabled);
 	pdata->disabled_channels[num_disabled] = -1;
 
-	pdev->dev.platform_data = pdata;
+	dev->platform_data = pdata;
 
 	return 0;
 }
@@ -3545,7 +3545,6 @@ static int __init d40_of_probe(struct platform_device *pdev,
 static int __init d40_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-	struct stedma40_platform_data *plat_data = dev_get_platdata(dev);
 	struct device_node *np = pdev->dev.of_node;
 	struct device_node *np_lcpa;
 	int ret = -ENOENT;
@@ -3555,7 +3554,7 @@ static int __init d40_probe(struct platform_device *pdev)
 	int num_reserved_chans;
 	u32 val;
 
-	if (d40_of_probe(pdev, np)) {
+	if (d40_of_probe(dev, np)) {
 		ret = -ENOMEM;
 		goto report_failure;
 	}
-- 
2.53.0



