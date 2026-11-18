Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016898;
	b=z640wpVi5irLdPlkG5cVvq2jxK+hEsUX8BrGFjRg5p4xbJphj+3TJcgQk8zIe4yi6U49
	 SSg5pAf7k+E1ZWsG8pU9LaHUW6Q+byfGjdpcxeIwNWDDbxY5r+atiNVw03oOI96bO+9H/
	 DJsTYKoS77C+ePRIpkClaY3oItTmfKNCcfMvS5VMO3Gyox6WShQVMstfzqnozR8vyHqsD
	 7wL++Y0ECPyXGwsFH3IHvDE8TaBUMZnhsQ0IcezzOpNbch8Gv+Fov4Y+mKhGQTlZUYRMC
	 R6paKVBXBc3GGkGrR6Rubf4lSzEBvchxpsi84kqrfqLhF/JMxFOBrvzUNvSn2aG8R2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9/YFRzpZ9QsE2zTxde2iEeolX5ddp3s3pRGehkU8iNo=;
	b=MONJ24JlYW9JUd+cCrkjgV8XjVKo4BxWhK1o3c/XO9TqSm+J+0RQrEiEfciYarNM1ufL
	 K8FgWqjqjlgpEAx73ucQcuaBK7ZkzxpMJRU+hd0X2/Z0pk5BtKhjVDwF/ot/3kt5LVh7L
	 GMHLzR8EFEp4NpCSKwEvPiptD199UTHEkNdfkii1Lv+mGqCVwiZidqCsN9L3EBTOUvxje
	 o2ZwJwqYNA5ADO/w9c/9pgeMKT27jsZNpMVjnr5C9kxc2H/uvJ+On4tNn9v6Zrw64k6vV
	 LtSgko0f2ZiTYMzgyiclEVTm+s1PFpBfJ3LQ7cpqjJuOFy+W7zBlPajPezPnjnd88eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVHN6UKo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D70606A320;
	Wed, 18 Nov 2026 15:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sVHN6UKo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11AB1F000C4;
	Wed, 18 Nov 2026 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016898;
	bh=9/YFRzpZ9QsE2zTxde2iEeolX5ddp3s3pRGehkU8iNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sVHN6UKoIBq2tBQvtei4LXxjTXb4tRa7qDKIpoeEOD8jTBmcmIQdLBVQvTM+Hv2Jw
	 dWIdmXQlQ6E8E6KkkcGLAmkfEk7BBtKfAqsNLTWo7ESLdfuJ8R5uFImEXbun69VOIa
	 kZ64M6I7D8H6NG5hSZLJY1wA9nNjSN+KeYks5m7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0690/2651] hwrng: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:32:10 +0100
Message-ID: <20261118150312.693154728@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ace145efdd80cd2eb95e84b1087d0f1fc55bdc0d ]

The StarFive TRNG probe and resume paths ignore failures from their clock
and reset operations. That lets the driver register or resume while its
hardware access prerequisites were not established.

Check each transition, unwind only the previously enabled clock on failure,
and propagate the error to the probe or PM core.

Fixes: c388f458bc34 ("hwrng: starfive - Add TRNG driver for StarFive SoC")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/jh7110-trng.c | 39 +++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/char/hw_random/jh7110-trng.c b/drivers/char/hw_random/jh7110-trng.c
index aee12caab5780..61eb4db7ac014 100644
--- a/drivers/char/hw_random/jh7110-trng.c
+++ b/drivers/char/hw_random/jh7110-trng.c
@@ -320,9 +320,17 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(trng->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
-	reset_control_deassert(trng->rst);
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(trng->rst);
+	if (ret)
+		goto disable_ahb;
 
 	trng->rng.name = dev_driver_string(&pdev->dev);
 	trng->rng.init = starfive_trng_init;
@@ -342,13 +350,18 @@ static int starfive_trng_probe(struct platform_device *pdev)
 		pm_runtime_disable(&pdev->dev);
 
 		reset_control_assert(trng->rst);
-		clk_disable_unprepare(trng->ahb);
-		clk_disable_unprepare(trng->hclk);
-
-		return dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		ret = dev_err_probe(&pdev->dev, ret, "Failed to register hwrng\n");
+		goto disable_ahb;
 	}
 
 	return 0;
+
+disable_ahb:
+	clk_disable_unprepare(trng->ahb);
+disable_hclk:
+	clk_disable_unprepare(trng->hclk);
+
+	return ret;
 }
 
 static int __maybe_unused starfive_trng_suspend(struct device *dev)
@@ -364,11 +377,17 @@ static int __maybe_unused starfive_trng_suspend(struct device *dev)
 static int __maybe_unused starfive_trng_resume(struct device *dev)
 {
 	struct starfive_trng *trng = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_prepare_enable(trng->hclk);
+	if (ret)
+		return ret;
 
-	clk_prepare_enable(trng->hclk);
-	clk_prepare_enable(trng->ahb);
+	ret = clk_prepare_enable(trng->ahb);
+	if (ret)
+		clk_disable_unprepare(trng->hclk);
 
-	return 0;
+	return ret;
 }
 
 static const struct dev_pm_ops starfive_trng_pm_ops = {
-- 
2.53.0



