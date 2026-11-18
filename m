Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047198;
	b=Hkt0hXLegNqWErHt40fxN1xjjpNXSO5y/5Uboucs0vGGsBvRGfjeag3l3HiyA2wPwIf6
	 gI5LdpN1eoJen9HbNVtgSejZE93POdkfvpKgJg/8BD5vrpzQDBL79qCFQvcY6/9p9A2z6
	 aT0binPP6Qhqv2ROoC2D0neeI3LS0b70RxCM4aWF+JYzrp4BSf41WIuTwZPg4YTxjhSLC
	 S05+YEzlw1YkmiwyQelkZzEtHynNK2xhB58POzJd4SzjXmwgDNAM8TOPR4BNmYV2t3tOJ
	 JSCDurCOv6V5ti8T5CXhNhnNe11bDJtxZEu/sFNP0y6YtSOVcUvyPFjJtzmB6G9Y76g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eY7vdsZN9FaSJHDUW9PU+NYX5z+YKWDJWawu7R4MbmM=;
	b=0nGoXEwrcONwDfg9KhguGKd3BmAeItfze97Hol3xjLn+fzxUZEfxtzSkHMbOZuD1V3vf
	 gETlaOd4B5lUQO877SyMFU7BG/Jgp1+8GsIsjWynwXDMQQ82naSTnsvgEJQptUIUfKkyJ
	 0y5+UICFWD7olM3zCe9ZoAQPlkgAO0dMLtLH6HLfRbtX9vuQE09X9swUjXOQOMHVwYLll
	 JWGkpQA0XgMZmPoz/MldSWebbmE1c1TfwV6WwpRrnzCoa9mY3U5sRlZ1iVkJ1iJXIHYGa
	 c67L3FDVNp8+0muvWtipIOS1Z5S+M2zomLMNsdKjTubEub4FMmJ7v2E5djEANf0fZMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtyIRppw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80D606A33E;
	Thu, 19 Nov 2026 00:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EtyIRppw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559951F000C4;
	Thu, 19 Nov 2026 00:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047197;
	bh=eY7vdsZN9FaSJHDUW9PU+NYX5z+YKWDJWawu7R4MbmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EtyIRppwD56Nu1CLLD7hxqZmhWny87kNE6JMmofF9AGCIP2Tl7t7hFbf4a30V9U+k
	 NQIsmiN3hA26d5/sWxJhFa97cI8yZ0TOMOW3K4jTjQJHXX9cSLXCCOdZdhLfJJU5qA
	 w68ObXPm0Jc1iLqbzlkYBkkOOTHoeiTBV5oAjjro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1513/2857] nvmem: rockchip-otp: alloc clks with main struct
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150255.806436806@linuxfoundation.org>
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
index b5a84b379da40..aaa044bb231b8 100644
--- a/drivers/nvmem/rockchip-otp.c
+++ b/drivers/nvmem/rockchip-otp.c
@@ -64,9 +64,9 @@ struct rockchip_data {
 struct rockchip_otp {
 	struct device *dev;
 	void __iomem *base;
-	struct clk_bulk_data *clks;
 	struct reset_control *rst;
 	const struct rockchip_data *data;
+	struct clk_bulk_data clks[];
 };
 
 static int rockchip_otp_reset(struct rockchip_otp *otp)
@@ -239,7 +239,7 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	otp = devm_kzalloc(&pdev->dev, sizeof(struct rockchip_otp),
+	otp = devm_kzalloc(&pdev->dev, struct_size(otp, clks, data->num_clks),
 			   GFP_KERNEL);
 	if (!otp)
 		return -ENOMEM;
@@ -250,11 +250,6 @@ static int rockchip_otp_probe(struct platform_device *pdev)
 	if (IS_ERR(otp->base))
 		return PTR_ERR(otp->base);
 
-	otp->clks = devm_kcalloc(dev, data->num_clks, sizeof(*otp->clks),
-				 GFP_KERNEL);
-	if (!otp->clks)
-		return -ENOMEM;
-
 	for (i = 0; i < data->num_clks; ++i)
 		otp->clks[i].id = data->clks[i];
 
-- 
2.53.0



