Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029915;
	b=dOuYYDPHMGa8h3gB1QDIQ2SyYBJzPBfN7OtVFK7m/if7DbVje5IagdKoxBt5MfCwleuW
	 8djHcOg8tnv+arg2F1LgHRX1r/mb/9EEvunJSP5T6+EGQcZqBSkW4uxu1TYpDu5K1wDTR
	 TTQwTBZL/nRAYhMkJXLiUoJDeJnEhN8P8a2pWmykSQgRgvpzHuh1SIDxmgd1HUl7ZgHEw
	 pxjklk3NyMc0N8WBUPXu62s5yRaThf8133iWCHxAKnvq06X7Rr0I0BkbnhRzDIEoRMYnv
	 UP6YfkyI6lrURb0tCT2DatkhHZy0VTWGjKDIkoIFpAEhWEhPRFx7e6r3QkKHM6bMu+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029915;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMEHSxJ3QHDJM+zPEbuZfU2IQUI0omWeTVcZberv42U=;
	b=LPRQMsjsZlCD7CGPCd9kxh1LNF4i7rFCUSWm7iyRx3l90UR1mNRdodyL58PD9CicmwNl
	 WQcZhDJ+PqbpJJBVvHGPmPohVlFxbVQjQLdfRK/vm+w/PYY8SSf2w20j3/HqfHri0m9A4
	 uSNpXIByZ30+SFAlE9Qdas1hQXckAxy3QN7xu8C5Kl8ksSF7GqbwaqeU53e3qxC6hqcNP
	 WJmlW0v6iU3gNQ+TQOaE2YC8DE4676mQhY1j3FYnDAWmyjV4cCwOyYYqQGoj/PeAJv/Cc
	 Sj8z/8TX67z5FdHOaFTfs7zd14XnhHsi1c+Wf02k8hRNOITi0NopByxO6fVKi1FTihg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvaMKxoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6297160A3801;
	Wed, 18 Nov 2026 19:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bvaMKxoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E391F000C6;
	Wed, 18 Nov 2026 19:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029914;
	bh=SMEHSxJ3QHDJM+zPEbuZfU2IQUI0omWeTVcZberv42U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bvaMKxoNJS4lIpxzX4C/Ll+OHHdOlJXssXMHIYlrJW0KJb64oDtTB88LUbVYH2YUc
	 4guLpTlkYzj1hSigAHpWkGB6aj6QF6D4SJN9QCgnfc7AqtpP72VlRmfLv1SqkrtFqZ
	 qyy4YfWgIew+odl5rf75s7uB2FbDs/bM66RBLjLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0512/1756] crypto: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118150029.562564387@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit c8acdd77a62374507ed8e70d59e124269d999b75 ]

starfive_cryp_probe() publishes the crypto device after enabling its clocks
and deasserting its reset without checking whether those operations
succeeded.

Check each hardware activation step and unwind only the resources that were
actually enabled before returning the error.

Fixes: 42ef0e944b01 ("crypto: starfive - Add crypto engine support")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/starfive/jh7110-cryp.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/starfive/jh7110-cryp.c b/drivers/crypto/starfive/jh7110-cryp.c
index a373eba869cc1..9684daa3f03e5 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -131,11 +131,12 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 		return ret;
 
 	ret = clk_prepare_enable(cryp->ahb);
-	if (ret) {
-		clk_disable_unprepare(cryp->hclk);
-		return ret;
-	}
-	reset_control_deassert(cryp->rst);
+	if (ret)
+		goto disable_hclk;
+
+	ret = reset_control_deassert(cryp->rst);
+	if (ret)
+		goto disable_ahb;
 
 	spin_lock(&dev_list.lock);
 	list_add(&cryp->list, &dev_list.dev_list);
@@ -185,9 +186,11 @@ static int starfive_cryp_probe(struct platform_device *pdev)
 	list_del(&cryp->list);
 	spin_unlock(&dev_list.lock);
 
-	clk_disable_unprepare(cryp->hclk);
-	clk_disable_unprepare(cryp->ahb);
 	reset_control_assert(cryp->rst);
+disable_ahb:
+	clk_disable_unprepare(cryp->ahb);
+disable_hclk:
+	clk_disable_unprepare(cryp->hclk);
 
 	return ret;
 }
-- 
2.53.0



