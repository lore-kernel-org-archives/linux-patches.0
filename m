Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9903136AB5A;
	Thu, 20 Aug 2026 15:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238495; cv=none; b=M90ba3X4W0oIeZ5X70VWy2dfc5KS0nYW2AYmuNMLVEGYmyBMf4FPsLNzch48euPFJowZQw/vAHC0fSZWqdrfD1/5dJHXHkxYUbF14ogyt/nhMhhZN2/AWGAzhUoFF5Sol//t7++zworrroG4W98HfsM/u5dwvyepttlhuqkwPx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238495; c=relaxed/simple;
	bh=bt0uIHwS6ej3TtJZXq/YIplEsXvoZX85Iyu2Fmhrndk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpqYmrY/mKubaX8dcV9dxVjYBU/QdG1B6oJO9nNEMQUS4MgP2E6dEXB1I5zNZCfh7CqvHO08mO7XSx9JlP2SVxeNXrza3mkqqw1N3PhYxmcQaA1K2cRT6/17Uq8fgaI0+aolyW65oHuouPbUWrduQChfB8fMv7gYPqDXMVW4wnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNdOsv/t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNdOsv/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4734A1F00A3A;
	Thu, 20 Aug 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238493;
	bh=GRW7imkExYyiQ62ddu3KE/llVjr/65cijJvlTICO/54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNdOsv/t8HCflHUUDgJbL61wOYpT8R2QCdGJd/eiUvzuIHj/+o4UCUVoNN+alaXOs
	 OxJU8nEExBb02Fj6aoLc82Sb5ndAnOyGSALShoQUTfKZ17jTFQEg9Fq/YGx5ovfp7V
	 PhvvRDJDMa6TZQeETVox0n0C7XvC2lUivhuEAO1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 167/228] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:55:09 +0200
Message-ID: <20260820145249.759788509@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2ae929ffdef8e..916441e4f2b86 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -747,7 +747,7 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 
 	inst->alg.ivsize = 8;
 	inst->alg.chunksize = crypto_aead_alg_chunksize(alg);
-	inst->alg.maxauthsize = 16;
+	inst->alg.maxauthsize = crypto_aead_alg_maxauthsize(alg);
 
 	inst->alg.base.cra_ctxsize = sizeof(struct crypto_rfc4309_ctx);
 
-- 
2.53.0



