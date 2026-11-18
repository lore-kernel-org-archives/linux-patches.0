Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030039;
	b=YH+8pFguliJfLgKUp0NHOaiMBjhsC2xJlUFSoPhTR6wa5QwfQCH9gs5kNDik/XfYn4TC
	 XSfDV6kAXf1+oNHKYB+LoViZ8PEtzuq3Knts/9CRqqA7N3W/407u64fZMUqpvjljRxk9A
	 YtZLJ0fiutWsE2vaAj3p1cxRlvAa8OEbjrcPLItXMR4NCw7rE3uYlhsmYUmx/XgIGRGRF
	 4UFHO/k0dwZLP719L03VkQ19BKBGOgRfJ/oova3iZ+Y0vEy++6Qmq3zrBqnjuVnMd9+xB
	 eCx84dRcYoErTNFSAw+48Ro1g7g07gNersFxnPG2ZWGf+5yIUJiMBRPP2ehyFBnbqIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030039;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oHpVtW3jFDCi/KYmxVJIwipwhfimyVg+ouFQSuK0U1A=;
	b=MxwmA8Bz4xq15XEqZxlHJd1pHr6Z/P/9nZtuaCm3SmJ2ilYjzfPTQHP9sltVEfOrbsec
	 ntxSy08yCVPjezEtjwAC1HkrBChG1aLJuYK2dyU/Iz8xqHMHxHXp6RIwXvCs8fym6PB9A
	 IKuq9c3CruBX00JXhshASKAOSfRamUHpgnaWPTu3XSADyf9XK96I7edcSKRWguRY5HmSk
	 nJ4UemaLM17pEyW/3TmJOuKaDDouQRPLnSAFaBOEF2NPrmVpLB7HzyW/U7n4udG4ufYtJ
	 /t0kfpA/hMWpoq93blKmGa7amAiLYBOLGe2LD/67lCxTsGO3xGXs7UWxAtC+abdHOMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFlauz1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C341E606A32C;
	Wed, 18 Nov 2026 19:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tFlauz1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F041F000C9;
	Wed, 18 Nov 2026 19:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030039;
	bh=oHpVtW3jFDCi/KYmxVJIwipwhfimyVg+ouFQSuK0U1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tFlauz1yQvXM0kOKvflNQ3Pcnf7A9yNAykquYnJOlFU+SyfE17gwU6GbpuLvNpF1q
	 s/VTtBd4FVkxW0QTJb8eNl6qT2ocSG3fXFugoUwEtPOWHcrIBNy8BH9eX6Vq/XaFLp
	 IEqQoy0cAcFh4d0dDnQhM8z47aCvjSyuCfBpn+lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Liu <1298662399@qq.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0511/1756] crypto: starfive - handle clock enable failures
Date: Wed, 18 Nov 2026 15:43:58 +0100
Message-ID: <20261118150029.529570878@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e4dfed7ee0b01..a373eba869cc1 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -126,8 +126,15 @@ static int starfive_cryp_probe(struct platform_device *pdev)
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



