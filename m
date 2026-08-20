Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB2E47D463;
	Thu, 20 Aug 2026 16:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243907; cv=none; b=RDkb3ejy/CO+Q3JweD0ZcJMvDLn888gGxWlvqibpFoyffURluq06fEw4BHu3a/2qEiZuUd226/9zFlG8mkarD2/hMD6UzoAnOotVHGjYp8426buvRrrHBYY6bZ4dWmstQWEjAx1zJEuJuqlG7hEQRelrREsxrbbEBPRjEic036c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243907; c=relaxed/simple;
	bh=O4IY9NdJUn+OvQyivNd72FnFCQ662k4v1BbTR/ItZg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra8s3TA4SMCB4LGsQaEbo6uqTDw6F+o2JBFKqkdWw0wlVuiGkKS8Ze6U7IgpfPOp2MDV6D21RPy2qD6YPb4JG4OgFzY81M0UjVqHag0Yzkp2VxYZbXmpEOHdKZAcgYpe6CT/bP9wk0ycB1soN22iZjQA/2qiClo0sSaQB/1XfKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzgwwd+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzgwwd+t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7451F1F00ACA;
	Thu, 20 Aug 2026 16:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243906;
	bh=F0L9T6LDyaR0WT83W7/j39wUIBygl84y5GQSb1k9Q2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzgwwd+t0sAlQJ9MT/1UvoEhzI7K3VgtcHTNbOsRkpBzmPkrcoiU+vbPA+sVa8SOo
	 syPOn9traqc/TKR6zvUP03yxmBqopGVINxJJyJ+EYyU/WUHZB25ankUPGCmCZ5bUhs
	 qQZy/Hpa6LLnGFO1Y9nyjJsuMndk+ZyGrIOLuTOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/272] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:57:22 +0200
Message-ID: <20260820145239.371945062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6b815ece51c6a..30c8f10408a3d 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -753,7 +753,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



