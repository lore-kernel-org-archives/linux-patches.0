Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024147;
	b=33rU4GTr9mot4XfFBow9XnF/m/OMab5VsV92gfk/30+tDQ7wa/WA80HFeQ4N/nIcnamr
	 Ze/cexVdmbz+RML10i/u+GHhESu70VpwV42/RnUwzFKJFmSIccCwfriBJzBlCJm0Se7Im
	 z+XbojwVDkr53hQIqPTwin8U9S6Z96IFvqaOTFWSefsVka37Qns/hjcmHWIcILN2TwhgZ
	 Qjfwy2O8J2wObostpemls5QPtTfgVNSXQ1Aza/wAfwNdbHsPoUKy9u4DPCJ92LEbqYfD5
	 Rw9S3V84th/IAcn9D5B8OFanElqN69LdI36MniP6Yizm3ntk2Dw3rbR6TaXo6EG+4rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FNZ0i5H/h8Xxd13tS4tQmZkTPPQWOSoO941N79wAdFQ=;
	b=4aO68vN+EI+MgVmtBxV8YOx+xNaOlzAq8bpt2LyzBiX+W1lIp5AbTcywn4bv0iYu1//b
	 v+gWUwZo9XcbGuHFy4/L6qLG6tNu9O3LONusA5JVCIdY2AVD+lHLyzNKJxlr2oGDiwhZU
	 ZksKcj7hyvb9QDa7M59mTyuBrC2HnnGqJ72i8bV7rmQUArKZPSv/5xrqqSNjJJerFtbvG
	 CzKSSaeY/OlbFRbLD8CBztsMH2A9ID0Pang05RAdMu/ocnqXmUaS1veaaKzA/uUdo40m4
	 cG36KkrzU0XvKcQAGdzXrTyouutxYSaf6r3y6Pblb7QqKiLoSED/4iwqXxftrXe3cpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTaXdmgQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2545C606A32C;
	Wed, 18 Nov 2026 17:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZTaXdmgQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783A81F000C4;
	Wed, 18 Nov 2026 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024147;
	bh=FNZ0i5H/h8Xxd13tS4tQmZkTPPQWOSoO941N79wAdFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZTaXdmgQpx+rz0cmD61tKXUbmu0YLWqYUXiL4Kq7IOW7Ce7mX3XCNXh+5WlAfVFjL
	 8pqOHQAk9AehGWhGafiFJzXDwHAk/wut1vuNFptOPYC2R9TfJznrSbtzw6nWc4hf10
	 GYZODPXmZQqwCqrcWrPntckAyl5a4V+nAkpeCmr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0622/2151] crypto: starfive - propagate clock and reset errors
Date: Wed, 18 Nov 2026 15:39:17 +0100
Message-ID: <20261118150144.568972659@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a976de668abe2..462dee2f0819a 100644
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
@@ -183,9 +184,11 @@ static int starfive_cryp_probe(struct platform_device *pdev)
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



