Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38CC46C831;
	Thu, 20 Aug 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247701; cv=none; b=PpxaiCH8wPl2NC/IF7FGASvkSzXLtu+t0r2IWaqdNCWD7YgiPkqXUpJ06vmQkzUw4v5mpHzlZlvKR7xi+/qOB7+xaUUSkz1e7KLvlrmWmCUsDpZyIR816IDi1kKnX6s/+w4xiNdB12QRiiImr/0ATfpL1gw0aSAodEl8ZsgmN9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247701; c=relaxed/simple;
	bh=FX5fQBxsrM7G5RcILen3Cru2jeSGrC+Dim3PjD0X5cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDCsDEUe6TP4Tf0vX9rgRGVE6D1ZNaF5mxCPVm+duYwjmY+Ade3osPmF56dq94gI7v6Di5GY7i6LO3O2Mbl9sMJ/lzLxPjZKFkDJzZiVhuwhtr4NgLAaKxY5xoN4Cnqtih2lsiPKTfdOvQ1tnfMWn5TMMt6tlOI4gCPE1hEBoC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zV2miU6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zV2miU6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCA81F000E9;
	Thu, 20 Aug 2026 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247699;
	bh=g9Z7C0RFLYCPgZNZppyR4il1lEO5Y3g+Ly6ht0G4vBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zV2miU6GjrGpzonSSTU0e+UIvD44BAxlKVyOWnpltRKhmzhXk093BcYRLFfd7riKs
	 KODl13BRD6CL0cp+z5jMzBKw0kcpVJMRPdSIHhFSS+3Rdn1n3gkOXBy11ZE+3bSpDu
	 oN1fzFYDMCzlMP4Z0g0XP+GqntuOd04xISS/djGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/166] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:56:37 +0200
Message-ID: <20260820145215.322474330@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a9453129c51cb..1770309c68c12 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -752,7 +752,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



