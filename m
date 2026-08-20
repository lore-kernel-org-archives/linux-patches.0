Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA9447D461;
	Thu, 20 Aug 2026 16:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244580; cv=none; b=TBHEAqWJ9tSLeR9RMM3CUuzdxmw9e1KhC9+wVFcw7ye7pnQvpEPG3Q2juIZHNBI4Oyzvh+SjZXT8jDl1J8iVc9Jzveuht4dYAanB67GEHtAcTjCbxLAOoHivw6CHSCAp5ygm2jE0vE8aot1ihL3Bjm0RBaTF6Lu5CXPcZo1RaeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244580; c=relaxed/simple;
	bh=7MWzZK+yk4lw44aw8ylU+3Cg7ZW1NNuXMOY2Id97hN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ejxl+wS8P3J6KdQPnUOYb6VvO81wQf1OH8NfwUHe7OBbq3gJ+PnPJYON0kKU3ffGuZAEICoOgSKMYs/EZKeb89yc+Zs51lh3pi6F+8nnnENviWSwMR43IAcNbni/oFA/QSAH/3fpU/RVIVoGk6mEWxh1Y51j9lDQuCZaPje2lPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yh5fL+Pa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yh5fL+Pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3715C1F00A3A;
	Thu, 20 Aug 2026 16:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244579;
	bh=S6CqlA4GnScwD+q3OqDFJTAzGtq+5ORoMu9v/rHeaJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yh5fL+PariOD339TbqZ0lZ3yidJhqRK+1QzXoWsj8CDQWsDbNyH4i8MzgEMA1cWeF
	 PCfCBPEV3svB3/OdCVTmP6nGIQ6l1UnCPy1/1bM0lfio0vLXrPvx/FrCFDb1s9b/ge
	 2ZSqvtYE+TmGKWiwBkpNxL/Gq8VFCKCzAznjVoiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seohyeon Maeng <bioloidgp@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/235] crypto: ccm - Set rfc4309 maxauthsize from child
Date: Thu, 20 Aug 2026 16:57:33 +0200
Message-ID: <20260820145223.198253196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 494d709011862..52ace42e11e82 100644
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



