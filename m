Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705027;
	b=kKXfyUBblwI9fyVgwnRwLonGg76+m/TWs5+h7IvYn7QrKU9/nFP6CnmxWxndUUPr42wM
	 INZFCDxRjHJLvhBJTj/MCUQY67BjPrWJJgojSuzKuOZCRAcVrc+wMnllDG7nmXSvD13IX
	 ctQa0KDzaNU+zBrhaGS/aEP+xqWRRCU07DqeqHdrxDltN64GxPgvm8DYA5IE66MoZLCjJ
	 4ABVGjlgvjyw1Dia+KNJnkai5QnwOAqveILwdKooBz2B7kRviuE962wQk8NxHjWlHtcr6
	 /1aOz6ddbr/i0Tri2jFCQVAglYJgSMGdcpY1iwwq+NJ108qsErhgzswEa3c7/X4ED+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705027;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pfvzO4xOFJPP6FPwgLYzhTrcK2rHL27FDfPUjdGpZ8=;
	b=qaMnSjf1UMZz9tftqw+nmwAr+K5vDQgKiT8U4Axph275hb+dm2W0xLqKTF4MEYfH4eGe
	 +MvIcBVz1h1SVNBPNJM0rNsDfIUTFJBv7x2T1pyJUjfZpUn89lfNgNWz1w2KBBPC4ySfU
	 3IJemxPpIoHUetWFwOeKt0GeqlIqAQysBd64JcZNXmpbwPP6xOFuKtWFXOZfPaGfC8YUz
	 tTikLvoHWpXZRWS+XuJO766Guracp5QS26GthYqDXNabLknpzTAc4GOF89MGXLs33Dfj5
	 2neYhk5mCssDB6XMtKiuM//Azmg6NqZ2OniYV/xiUoNtEQXsss7eSSLlshod2H39+6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0+pUGLS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D547606A31E;
	Thu, 26 Nov 2026 14:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L0+pUGLS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1151F000C0;
	Thu, 26 Nov 2026 14:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705027;
	bh=4pfvzO4xOFJPP6FPwgLYzhTrcK2rHL27FDfPUjdGpZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L0+pUGLSU5mMG4tBRGTr3taJwGHzUVePW6bwsP6fjSmO7cyAQglaoj+u3mn5eESPP
	 8fyOBGkwgyy6BeVSbj3Ev8K1zdLNWeRSZ/EFqF3NaF65hxi47bPmCiLD83qV7cauk+
	 Wkwa8MhLS/QrzWDhUESlZDmoOtHJTlGdfOXLGNMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/319] regulator: qcom_spmi: Drop unnecessary of_find_property() call
Date: Thu, 26 Nov 2026 15:37:05 +0100
Message-ID: <20261126144008.025203510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 7540bd3398675e54cbd7324c47be8cd3c7a6d9c5 ]

There's no need to check for presence of "qcom,saw-reg" before parsing
it. If the property doesn't exist, parsing it will return NULL.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Link: https://patch.msgid.link/20240828130056.3481050-1-robh@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 053c50a70525 ("regulator: qcom_spmi: don't take a sleeping lock in the SAW IPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom_spmi-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/qcom_spmi-regulator.c b/drivers/regulator/qcom_spmi-regulator.c
index 41424a3366d0e..56db0ccd57d80 100644
--- a/drivers/regulator/qcom_spmi-regulator.c
+++ b/drivers/regulator/qcom_spmi-regulator.c
@@ -2139,8 +2139,8 @@ static int qcom_spmi_regulator_probe(struct platform_device *pdev)
 	if (!match)
 		return -ENODEV;
 
-	if (of_find_property(node, "qcom,saw-reg", &lenp)) {
-		syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
+	syscon = of_parse_phandle(node, "qcom,saw-reg", 0);
+	if (syscon) {
 		saw_regmap = syscon_node_to_regmap(syscon);
 		of_node_put(syscon);
 		if (IS_ERR(saw_regmap))
-- 
2.53.0



