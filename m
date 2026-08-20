Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498A628C2BF;
	Thu, 20 Aug 2026 17:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247225; cv=none; b=l80F//JU1NsJm03Vo+eysH0ORSWv6lBdtW9yXF6+m6X2CEA9n2hBdUrfki9er57FX2AP5AvRfgfsd7TWYdAlq8kfQKCI0k7SWJViwGLO/Kz89tGbzoHO8KHHV+ovYuYFXXC5lFyrZ/pv8Uy17PcUoF00NZzBeqFx8rLKRf1CSvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247225; c=relaxed/simple;
	bh=4YnDeZF1o68IpYCjkLYGIzV0B/rrFyGpudiqa6Ikzs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsxLvm+LQ8jCRVe75RmySwmauGF8DBYDAtt47XiHLLEeA8KAMSfLAuIPKQrgsQFoCciiRsF9bhP44aa1ckv1h21ZwIC70Bge+V/QMqb/NjvvX10BHnEsUnaX3P+ZHg7G+lp6vLOkLPZxo7TUK2br9QARPZA9P78qbzZNiCauC3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8S5ACwb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8S5ACwb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EE71F000E9;
	Thu, 20 Aug 2026 17:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247224;
	bh=pzeGFnxQSBb34Kygx0n8XbLD0nBmqvqnwCd42+9W1dM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8S5ACwbU0MEpyxSHGbQSoOfgrEQPB7q7jm2r7ceJI44jl2h6ATJky6XzU48zxRwe
	 6g31o4MupBEp6r4CGF1vVFMM3UFU0u65mKMRMxTdSNNZhuPYOF94e5O805/uTIVUv4
	 RwXTnDQ3Zw1Ahv4qScR+cJpQMfG1A0my6C2/8PxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/220] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:56:23 +0200
Message-ID: <20260820145229.316774243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 438f4896f78f69ec73d5f32d2c024193f1223569 ]

Set the maxauthsize of rfc4309 using that of the child algorithm.

Fixes: 4a49b499dfa0 ("[CRYPTO] ccm: Added CCM mode")
Reported-by: Seohyeon Maeng <bioloidgp@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/ccm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 36f0acec32e19..88c932faf6ced 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -751,7 +751,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



