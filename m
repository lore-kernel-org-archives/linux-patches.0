Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016918;
	b=Z25Y5Hglx9+8uTWGmbrT9Gkm9vmP6vEaw1HISyqnzDzUbgB+zKEewPjLTzhv1jOXHJ4l
	 Xzaj2FBHAwNTXf76VzvgTqxWexcwt2gslZuxipJevBMOGUVrjUdxxcXVB7OXcXPFxEmsH
	 Chl/2teac2jyODfzNBkU1cPWnfAAcdRxYK7ew8tnrNQxxW3qFsHMRkwPhDD+HeUrKgeq6
	 Fe5CnoPug84THDE5UpF+GlVrXB22O+BJ0Z/8i8yAyUMeDUZOnQLNgMYwzCIRqpC2SWIqX
	 2jXo5d1eAqtAosAXNVj8XEtxUXwQlPfhIKRbVA6hmfvpsuk5qlucncyZlRlSFzpCYTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MWVNYDFJoypOtoJKRjzqiypwK7VgypsrKLTLB7B3Ds=;
	b=PkUWLAzI+BJlNpCFOQ6IrR66mfh4WEYEksm6KecxuxvIyxt8fvQwJuedLKi6iTYP6At9
	 VyrgCQmncDQ6QttmsLlJCTcif4oevf+FcP26kPewXRsjvJ2j8Xsfe9icrpmEeqaMi0hGY
	 E2UK0R18yA4jIux6NgfWfY6jnRu2mjh5KiJei9QeYjZmGEVAQ/X9OsMHM6sZpGrEK5Yrf
	 FOvWpS4zG2aUxFrU+1buRBghHT6hhph+VJEY1GyZna5pQF14YZMqzMYc/egcAFKX21QO1
	 sRex15Y6Kef+HWtvzT7zY331GL6lNPRccu6dgHy7LWpuFDJa5NWR7V4zqK0eFUPxTcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7g0cevu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D0D606A320;
	Wed, 18 Nov 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7g0cevu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842C41F000C8;
	Wed, 18 Nov 2026 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016918;
	bh=1MWVNYDFJoypOtoJKRjzqiypwK7VgypsrKLTLB7B3Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7g0cevulb8oXFcsXvBvPbpAbm7t/hDp6tK4g9cIsFGkG6mtCDh1zONAwg7JXtz2A
	 X0wtag+kJbTRhhBm9Ab0hf1L8PlGlgf/bscO9t7zYG/vN0XlPmdcs8rYrlFjHgAp5A
	 X8XfJjNz3wPDZ46ZqqBxvJQA6F2x3o1cgA80bTQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0692/2651] crypto: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:32:12 +0100
Message-ID: <20261118150312.762299332@linuxfoundation.org>
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
index c3830a7c1810b..856290347b95b 100644
--- a/drivers/crypto/starfive/jh7110-cryp.c
+++ b/drivers/crypto/starfive/jh7110-cryp.c
@@ -125,11 +125,12 @@ static int starfive_cryp_probe(struct platform_device *pdev)
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
@@ -177,9 +178,11 @@ static int starfive_cryp_probe(struct platform_device *pdev)
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



