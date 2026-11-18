Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038515;
	b=WESajj59s4V5lMNhyQeeFY94g8LDzLBc+g0lP79QN57+Q8sO0OL5Z6ERmrBZRPFJC3dq
	 gRtkJMk+XbgjihVcmKawRFREa2grSsIgzH4F5thZmISyDBtdxoy6hTxI67rxzKKBvvJqq
	 IZz96PL7jOY3Iq64Y/hAcOPwGnn76SoBvobbox1LABg1ce9j89M7z2FuBLT4Ubl02iaOg
	 FUhAXuL661Ms2wmOHCJoLqXM5wjBSrivwFeK6CfwGVCUGmLayO3b02AbHBglL2gLhftou
	 +Eb4Yriou/tN584VMaj8xnjSSl/pgjRg95aRIFszkzZMFXhfmDx/O44E7NP0y3qwAqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eMm6OahwCOZfuPthlln2+4qz1KTwLBWbLx7/62uI65s=;
	b=q7NXS4pEGQjNuRBKWz0NONZlwcB0ORWIQ1iuwpWy27Qb3VMuoo/an9bAGfRgil2aji1n
	 JKacomp0+PU97ZmAJaa/Y4roXZ2p1yaBUqyrxWQI2sE79a/A7yTmiKsDqjC6VKz5V4KSK
	 KpWDJ93hhLy8eO0EbT3q3msdLUCGaenT5SgAIGGXiH3TotM6L6dxavgPBCf18pgrc/fN4
	 TBp4QkDHmV6qhIzFtryApEL5ZOmiHu41Raq4iVuh/injJTMbdvHjgM6/7IWUECwFIqCwa
	 z29IcZVQ81pnm4YX4ufXeZ12myZgI5wZqPgPpc4GSQG7pez8Yud+RQbErXSVmSDJQ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TfpU0Oe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E84606A31C;
	Wed, 18 Nov 2026 21:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2TfpU0Oe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABCE41F000CF;
	Wed, 18 Nov 2026 21:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038515;
	bh=eMm6OahwCOZfuPthlln2+4qz1KTwLBWbLx7/62uI65s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2TfpU0OeEgNuoU2J7+q4NTANdu+qNXE7gMKSksWWNvMBFzNHuu7eZjusxXjMdUflT
	 Ye7gc6NUhVJCUNHGlHkqu+1Vrx6ITAocR4TiY1ZQcNl3Lzqu/sRyMpmzvAPl57/UdV
	 cfx5GsP9IUaxZBhyjms6wCAhQjfFD1Da5ZOYTWiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1769/3318] nvmem: rockchip-otp: alloc clks with main struct
Date: Wed, 18 Nov 2026 15:39:51 +0100
Message-ID: <20261118150414.924571320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 9f99bb979f930e52e6861114fe03535d4bc2f374 ]

Use a flexible array member to simplify allocation slightly. No need for
a separate calloc.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530205333.117458-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9fc6a1592d84 ("nvmem: rockchip-otp: Serialize reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rockchip-otp.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/nvmem/rockchip-otp.c b/drivers/nvmem/rockchip-otp.c
index c6684ab14e742..f5b7d3f6986b5 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -77,9 +77,9 @@ struct rockchip_data {
 struct rockchip_otp {
 	struct device *dev;
 	void __iomem *base;
-	struct clk_bulk_data *clks;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	struct clk_bulk_data clks[];
 };
 
 static int rockchip_otp_reset(struct rockchip_otp *otp)
@@ -326,7 +326,7 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 	if (!data)
 		return dev_err_probe(dev, -EINVAL, "failed to get match data\n");
 
-	otp = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_otp),
+	otp = devm_kzalloc(&pdev->dev, struct_size(otp, clks, data->num_clks),
 			   GFP_KERNEL);
 	if (!otp)
 		return -ENOMEM;
@@ -338,11 +338,6 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, PTR_ERR(otp->base),
 				     "failed to ioremap resource\n");
 
-	otp->clks = devm_kcalloc(dev, data->num_clks, sizeof(*otp->clks),
-				 GFP_KERNEL);
-	if (!otp->clks)
-		return -ENOMEM;
-
 	for (i = 0; i < data->num_clks; ++i)
 		otp->clks[i].id = data->clks[i];
 
-- 
2.53.0



