Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017036;
	b=hVQaN5yGH6dVGsA2cuQmNLaoI3ohe6IP/tHn8oILyukKPiknfWQ+C2XbqISmZVzV6JzE
	 G36+Z6TQWyZnXvKPeW/0uMQ22fgNgCKHIWrucTYZCs2a8QjKIjdJKC5xGeS9RdZ/+b/DQ
	 QP7Y8y0kKYD9BMTG0KviP7jLhRIUIE+GtbVOV6GHAx/ECFw5zizQpVT0FzZGZqtOd/dxp
	 TxVRiNZSguDAu0zpcmN87VaJZcAofq8qikGX3I5c9DdKR8exPPsRRshBX0mNKQuI810rL
	 93wLD0pVA2cfVytY/Hvu08m+uQf1doiFvlNP/ZYhJoMySRv70ziVSm/h3kIqUgXatUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017036;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mNUcYupyqJvw+uYGthxq949ddd5G5xMonHuq0QLLU7g=;
	b=bpp9MEYQ3YH7U3c6C1FoJBwc6o3ScIz86E64d+7yOVRku8sRJHwqvhe1k5Dp8Dw+tyet
	 1R7lJIwpTu3wX2UJ6Ho/QFVy1uyzNVJjzVyGXzUJ8nPtFpFWm68eR4LI3npnr3fLtq1ko
	 ukgOoBObZFlQcuQMiFPl7MYEQd6hY5RUYdIiJE4+3ZuIysKULSlL5GJzL4hd+A9oB/RbN
	 T20rYuZ0/GuaFAqEPi7wN9WSQLcaJtRVVsMzEdJSIu5mqW4AlYBjSX900cbi/1P5pQItm
	 kuHzYhnBAzb+4iVd7Dc87PKEq00vdimvG+FN4tntYjpMBQvckgPUlv9y7b6T3CrLFEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCEyLaca;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E232606A31C;
	Wed, 18 Nov 2026 15:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCEyLaca
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774A61F000C4;
	Wed, 18 Nov 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017036;
	bh=mNUcYupyqJvw+uYGthxq949ddd5G5xMonHuq0QLLU7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCEyLacaF2nQVMG6G3fbcvBWSFWhh1hRWOmyxY9OMEJBdkSXOfM8+/0oCFNNB+oS6
	 lPIH3UZb9cMYYXSEsGx3OgkjuvvUDzBvQVEXfMxh165X5OiheuOpAuOZTgHoOBFiI2
	 2uKWNo2Imrucelyo7P166zDi/2hA+ZojcXxspChE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0691/2651] crypto: starfive - handle clock enable failures
Date: Wed, 18 Nov 2026 15:32:11 +0100
Message-ID: <20261118150312.727503885@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 5358248961ae23f7253d010ddfde1cfd2556ce22 ]

Return error from failed clock enable.

starfive_cryp_probe ignores clk_prepare_enable return for hclk/ahb, then
remove/error paths unconditionally clk_disable_unprepare both clocks.

Check consecutive clk_prepare_enable(cryp->hclk)/cryp->ahb returns in
starfive_cryp_probe.

Signed-off-by: Jiawen Liu <1298662399@qq.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: c8acdd77a623 ("crypto: starfive - propagate clock and reset errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index 842f76b0f1148..c3830a7c1810b 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -120,8 +120,15 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(cryp->rst),
 				     "Error getting hardware reset line\n");
 
-	clk_prepare_enable(cryp->hclk);
-	clk_prepare_enable(cryp->ahb);
+	ret = clk_prepare_enable(cryp->hclk);
+	if (ret)
+		return ret;
+
+	ret = clk_prepare_enable(cryp->ahb);
+	if (ret) {
+		clk_disable_unprepare(cryp->hclk);
+		return ret;
+	}
 	reset_control_deassert(cryp->rst);
 
 	spin_lock(&dev_list.lock);
-- 
2.53.0



